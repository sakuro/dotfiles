---
name: merge-renovate-prs
description: Checks open Renovate pull requests in the current repository, reports their state, and merges them one by one, waiting for Renovate to rebase when a merge conflict appears. Use when the user asks to merge renovate PRs, process dependency update PRs, or clear the Renovate queue.
allowed-tools: [Bash, Read, Grep]
---

# Merge Renovate PRs Skill

Merges all open Renovate PRs of the current repository sequentially. Merging one PR often makes the next one conflict (typically adjacent lines in the same manifest or lockfile), so the PRs are handled one at a time and the state is re-checked after every merge.

**Announce when using this skill**: "Using merge-renovate-prs skill to merge Renovate PRs."

## Workflow

### 1. Check and report

```bash
gh pr list --author "app/renovate" --state open \
  --json number,title,headRefName,mergeable,statusCheckRollup,reviewDecision
```

Report a table to the user before merging anything: number, title, `mergeable`, check results, and review decision. If there are no PRs, say so and stop.

A PR is ready when all of the following hold:
- `mergeable` is `MERGEABLE`
- every entry in `statusCheckRollup` is successful (`SUCCESS` for `state`, `SUCCESS`/`NEUTRAL`/`SKIPPED` for `conclusion`)
- `reviewDecision` is not `CHANGES_REQUESTED`

Handle the others as follows:
- Failing checks or requested changes: do not merge. Report and skip.
- Pending checks (including `renovate/stability-days`, which stays pending until the minimum release age has passed): report and skip; do not wait for these.
- `CONFLICTING`: go to step 3.
- `UNKNOWN`: GitHub is still computing it. Re-query after a few seconds before deciding.

### 2. Merge one PR at a time

Take the lowest-numbered ready PR and merge it with the `merge-pr` skill's conventions (check the repository's `CONTRIBUTING.md` first for strategy overrides):

```bash
BRANCH_NAME=$(gh pr view [PR] --json headRepositoryOwner,headRefName -q '.headRepositoryOwner.login + "/" + .headRefName')
gh pr merge [PR] --merge --subject ":inbox_tray: Merge pull request #[PR] from $BRANCH_NAME"
```

Never pass `--delete-branch`. After each merge, go back to step 1 and re-query the remaining PRs: the merge changes `main`, so a PR that was `MERGEABLE` a moment ago may now conflict. Do not reuse the earlier list.

### 3. Conflict: report and wait

When a PR is `CONFLICTING`, tell the user which PR, which files conflict (`gh pr view [PR] --json files`), and which merged PR most likely caused it. Then wait for Renovate to rebase it on its own, which normally happens within minutes, instead of resolving it by hand.

`sleep` is blocked in the foreground, so poll in the background and continue when the notification arrives:

```bash
# run_in_background: true
end=$((SECONDS + 900))
until [ "$(gh pr view [PR] --json mergeable -q .mergeable)" = "MERGEABLE" ]; do
  [ $SECONDS -ge $end ] && { echo TIMEOUT; exit 1; }
  sleep 30
done
gh pr view [PR] --json mergeable,statusCheckRollup
```

While waiting, other ready PRs may be merged, but each one can introduce new conflicts, so keep the one-at-a-time rule.

After the wait ends:
- Became `MERGEABLE`: confirm checks again (the rebase re-runs them), then merge.
- Timed out: report and ask the user how to proceed. Offer (a) keep waiting, (b) comment `@renovate rebase` on the PR, (c) merge the base branch into the PR branch and resolve the conflict manually. Comments and pushes are visible outside the local machine, so do them only after the user chooses.

### 4. Finish

```bash
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git checkout "$DEFAULT_BRANCH" && git pull
```

Final report: merged PRs, skipped PRs with reasons, and anything still open. Hooks that run on `git pull` may fail for reasons unrelated to the merge (for example `sudo` without a terminal); report such failures separately and state that the merges themselves succeeded.

## Never

- Merge a PR with failing or requested-changes state, or one that is not `MERGEABLE`.
- Resolve conflicts, push to the Renovate branch, or comment on a PR without the user's go-ahead.
- Merge several PRs based on a single early snapshot of the list.

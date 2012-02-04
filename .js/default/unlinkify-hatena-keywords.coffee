# Unlinkify keywords in Hatena::Diary pages.
$ ->
  $('a[href^="http://d.hatena.ne.jp/keyword/"]').each ->
    $(this).replaceWith($(this).text())

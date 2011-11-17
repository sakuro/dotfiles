# Unlinkify keywords in Hatena::Diary pages.
$ ->
  $('a.keyword').each -> $(this).replaceWith($(this).text())

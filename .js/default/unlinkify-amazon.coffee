$(
  $('a[href^="http://www.amazon"][href*="-22"]').each ->
    $(this).replaceWith($(this).text())
)

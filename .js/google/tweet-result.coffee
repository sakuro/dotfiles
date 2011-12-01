$ ->
  url = decodeURI(document.location.href)
  if url.match(/\/search/)
    phrase = $('title').text().replace(/"/g, '&quot;')
    count = $('#resultStats').text().replace(/件.*/, '件')

    $('#resultStats').append """
    <a href="http://twitter.com/share"
       class="twitter-share-button" data-count="none" data-lang="ja"
       data-url="#{url}" data-text="#{phrase} #{count}">ツイート</a>
    <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
    """

$ ->
  url = decodeURI(document.location.href)
  phrase = $('#tsf-oq').text().replace(/"/g, '&quot;')
  count = $('#resultStats').text().replace(/件.*/, '件')

  $('#resultStats').append """
  <a href="https://twitter.com/share"
     class="twitter-share-button" data-count="none" data-lang="ja"
     data-url="#{url}" data-text="#{phrase} #{count}">ツイート</a>
  <script type="text/javascript" src="//platform.twitter.com/widgets.js"></script>
  """

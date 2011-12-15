$ ->
  url = decodeURI(document.location.href)
  if url.match(/\/search/)
    phrase = $('title').text()
    count = $('#resultStats').text().replace(/件.*/, '件')

    $('head').append '''
    <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
    '''

    $('#resultStats').append '<a id="tweetcount">ツイート</a>'
    $('#tweetcount').attr
      href: 'http://twitter.com/share'
      class: 'twitter-share-button'
      'data-count': 'none'
      'data-lang': 'ja'
      'data-url': url
      'data-text': "#{phrase} #{count}"

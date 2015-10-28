youtube_uri = 'https://www.googleapis.com/youtube/v3'
API_KEY = '' # Provide your own!

@YouTube =

  getVideoFromId: (id, done, fail) ->
    promise = $.get youtube_uri + '/videos',
      part: 'snippet'
      id: id
      key: API_KEY
    promise.done (data) ->
      title = data.items[0].snippet.title
      video = {title: title, id: id}
      done video
    promise.fail (response) ->
      fail response


  getIdFromUrl: (url) -> # Mmmm you can almost taste the StackOverflow
    name = 'v'
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    results = regex.exec(url)
    if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))

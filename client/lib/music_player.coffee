window.onYouTubeIframeAPIReady = ->
  @MusicPlayer = {}

  MusicPlayer.youtube = null
  MusicPlayer.playlistId = null
  MusicPlayer.roomId = null
  MusicPlayer.currentSong = null
  MusicPlayer.sourceType = null
  MusicPlayer.playedSongIds = []

  MusicPlayer.setPlaylist = (playlistId) =>
    MusicPlayer.playlistId = playlistId
    MusicPlayer.sourceType = 'playlist'

  MusicPlayer.setRoom = (roomId) =>
    MusicPlayer.roomId = roomId
    MusicPlayer.sourceType = 'room'
    MusicPlayer.playedSongIds = []
    MusicPlayer.playlistId = null

  MusicPlayer.play = =>
      MusicPlayer.youtube.playVideo()

  MusicPlayer.pause = =>
      MusicPlayer.youtube.pauseVideo()

  MusicPlayer.loadById = (id) =>
      MusicPlayer.youtube.loadVideoById id

  MusicPlayer.onPause = =>
    $('.controls > .fa-pause').addClass 'hidden'
    $('.controls > .fa-play').removeClass 'hidden'
    $('.music-bars-wrapper').removeClass('active')
    clearInterval(MusicPlayer.playerUpdateInterval)

  MusicPlayer.onPlay = =>
    $('.controls > .fa-play').addClass 'hidden'
    $('.controls > .fa-pause').removeClass 'hidden'
    $('.music-bars-wrapper').addClass('active')
    MusicPlayer.playerUpdateInterval = setInterval(MusicPlayer.updateProgress, 100)

  MusicPlayer.updateProgress = =>
    progressInfo = MusicPlayer.getProgress()
    $('.progress-bar').width(progressInfo.progressPercentage)

  MusicPlayer.playNext = =>
    if MusicPlayer.sourceType == 'playlist'
      playlist = Playlists.findOne _id: MusicPlayer.playlistId
      index = playlist.song_ids.indexOf MusicPlayer.currentSong
      unless index == playlist.song_ids.length - 1
        MusicPlayer.playSong playlist.song_ids[index + 1]

    if MusicPlayer.sourceType == 'room'
      # Get the room
      room = Rooms.findOne _id: MusicPlayer.roomId

      # Get the playlists
      playlistIds = room.playlist_ids
      playlists = (Playlists.findOne(_id: pId) for pId in playlistIds)

      # Start over if all songs have been played
      totalSongs = 0
      totalSongs += playlist.song_ids.length for playlist in playlists
      if totalSongs == MusicPlayer.playedSongIds.length
        MusicPlayer.playedSongIds = []
        MusicPlayer.playlistId = null

      # Check which playlist is playing now
      index = playlistIds.indexOf MusicPlayer.playlistId
      if index == -1
        # If no playlist is playing, pick the first one
        MusicPlayer.playlistId = playlistIds[0]
      else
        # Otherwise pick the next one
        MusicPlayer.playlistId = playlistIds[(index + 1) % playlistIds.length]
      playlist = Playlists.findOne _id: MusicPlayer.playlistId

      # Play the first song in the current playlist that
      # hasn't been played yet
      for songId in playlist.song_ids
        if MusicPlayer.playedSongIds.indexOf(songId) == -1
          MusicPlayer.playedSongIds.push songId
          MusicPlayer.playSong songId
          return true

      # If every song in the playlist has been played,
      # start the process over with the next playlist
      MusicPlayer.playNext()

  MusicPlayer.playPrev = =>
    if MusicPlayer.sourceType == 'playlist'
      playlist = Playlists.findOne _id: MusicPlayer.playlistId
      index = playlist.song_ids.indexOf MusicPlayer.currentSong
      unless index == 0
        MusicPlayer.playSong playlist.song_ids[index - 1]

  MusicPlayer.playSong = (song_id) =>
    song = Songs.findOne({_id: song_id})
    MusicPlayer.currentSong = song_id
    MusicPlayer.loadById song.youtube.id
    MusicPlayer.play()
    $('.current-song-title').html song.youtube.title

  MusicPlayer.getProgress = =>
    duration = MusicPlayer.youtube.getDuration()
    progress = MusicPlayer.youtube.getCurrentTime()

    duration: duration
    progress: progress
    progressPercentage: ((progress / duration) * 100) + '%'

  player = new YT.Player 'player',
    height: '0'
    width: '0'
    # videoId: 'BC_Ya4cY8RQ'
    events:
      onReady: (event) ->
        console.log "YouTube API Ready"
        MusicPlayer.youtube = event.target
        event.target.unMute()
        event.target.setVolume(100)
      onStateChange: (state) =>
        state = state.data
        if state == -1 # unstarted
          console.log 'MusicPlayer state change: unstarted'
          return

        if state == 0  # ended
          console.log 'MusicPlayer state change: ended'
          MusicPlayer.playNext()
          return

        if state == 1  # playing
          console.log 'MusicPlayer state change: playing'
          MusicPlayer.onPlay()
          return

        if state == 2  # paused
          console.log 'MusicPlayer state change: paused'
          MusicPlayer.onPause()
          return

        if state == 3  # buffering
          console.log 'MusicPlayer state change: buffering'
          return

        if state == 5  # video cued
          console.log 'MusicPlayer state change: video cued'
          return

  console.log "YouTube player loaded", player

  MusicPlayer.youtube = player

  $(document).keydown (e) ->
    if e.keyCode == 32
      if player.getPlayerState() == 2
        MusicPlayer.play()
      else
        MusicPlayer.pause()

YT.load()

Template.player.onRendered ->
  $('.fa-play').click ->
    MusicPlayer.play()

  $('.fa-pause').click ->
    MusicPlayer.pause()

  $('.fa-forward').click ->
    MusicPlayer.playNext()

  $('.fa-backward').click ->
    MusicPlayer.playPrev()

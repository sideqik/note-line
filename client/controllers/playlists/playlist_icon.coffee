Template.playlist_icon.events
  'click .play': (e) ->
    playlistId = $(e.target).closest('.playlist').data 'playlist-id'
    songId = Playlists.findOne(_id: playlistId).song_ids[0]
    MusicPlayer.setPlaylist playlistId
    MusicPlayer.playSong songId

  'click .edit': (e) ->
    id = $(e.target).closest('.playlist').data 'playlist-id'
    playlist = Playlists.findOne _id: id
    Modal.show 'playlist_modal', playlist: playlist, songs: Songs.find({playlist_id: id})

  'click .delete': (e) ->
    id = $(e.target).closest('.playlist').data 'playlist-id'
    playlist = Playlists.findOne _id: id
    bootbox.confirm "Are you sure you want to delete the playlist '#{playlist.name}'?", (result) =>
      if result
        Playlists.remove(id)

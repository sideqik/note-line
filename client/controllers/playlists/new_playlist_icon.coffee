Template.new_playlist_icon.events
  'click .playlist': (e) ->
    playlist = Playlists.add "Untitled Playlist"
    Modal.show('playlist_modal', playlist: playlist)

# there's a bug where the songs added to a playlist cannot be played until the modal is closed and opened back up

Template.playlist_modal.helpers
  title: (id) ->
    Songs.findOne(_id: id).title

Template.playlist_modal.events
  'click .play-song': (e) ->
    song_id = $(e.target).closest('.song-container').data 'song-id'
    playlist_id = $(e.target).closest('.playlist-container').data 'playlist-id'
    MusicPlayer.setPlaylist playlist_id
    MusicPlayer.playSong song_id

  'click .delete-song': (e) ->
    song_id = $(e.target).closest('.song-container').data 'song-id'
    Songs.remove(song_id)



Template.playlist_modal.onRendered ->
  $('.new-song').editable
    mode: 'inline'
    value: ''
    success: (response, newValue) =>
      console.log 'new-song', @
      video_id = YouTube.getIdFromUrl newValue
      YouTube.getVideoFromId video_id, (video) =>
        Playlists.addSong
          playlist_id: @data.playlist._id
          youtube: video
        $('.new-song').html 'Enter the URL of a YouTube video'
        $('.new-song').val ''


  $('.playlist-name').editable
    mode: 'inline'
    success: (response, newValue) =>
      Playlists.update @data.playlist._id, $set: {name: newValue}

Template.playlist_modal.events
	'click .delete-playlist': (e) ->
		playlist_id = this.playlist._id
		Playlists.remove(playlist_id)

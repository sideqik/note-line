@Playlists = new Mongo.Collection 'playlists'

@Playlists.add = (name) ->
  playlist_id = Playlists.insert
    name: name
    song_ids: []
    user_id: Meteor.userId()
  Playlists.findOne playlist_id

@Playlists.addSong = (song) ->
  song_id = Songs.insert song
  playlist = Playlists.findOne(_id: song.playlist_id)
  pl_song_ids = if playlist.song_ids? then playlist.song_ids else []
  pl_song_ids.push song_id
  playlist.song_ids = pl_song_ids
  Playlists.update playlist._id, playlist

@Playlists.changeTitle = (title) ->
	newTitle = title

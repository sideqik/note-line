Template.rooms.helpers
  rooms: ->
    Rooms.find user_id: Meteor.userId()

Template.new_room_icon.events
  'click .create-new-room': (e) ->
    Modal.show 'new_room_modal'

Template.new_room_modal.events
  'submit form': (e) ->
    Rooms.add $('.new-room-name').val()
    Modal.hide()
    false

Template.room.helpers
  dj_slot: ->
    [1..(@dj_cap - @playlist_ids.length)]

  playlists: ->
    roomId = @_id
    room = Rooms.findOne _id: roomId
    playlistIds = room.playlist_ids
    playlists = (Playlists.findOne(_id: pId) for pId in playlistIds)
    playlists

Template.room.events
  'click .dj-slot': (e) ->
    Modal.show 'choose_playlist_modal'

  'click .play-room': (e) ->
    MusicPlayer.setRoom @_id
    MusicPlayer.playNext()

  'click .play-next': (e) ->
    MusicPlayer.playNext()

Template.choose_playlist_modal.helpers
  playlists: ->
    Playlists.find user_id: Meteor.userId()

Template.choose_playlist_modal.events
  'click .choose-playlist': (e) ->
    roomId = $('.room').data 'room-id'
    playlistId = $(e.target).closest('.choose-playlist').data('playlist-id')
    playlist = Playlists.findOne _id: playlistId
    room = Rooms.findOne _id: roomId

    playlistIds = room.playlist_ids
    playlistIds.push playlist._id

    Rooms.update roomId, $set: {playlist_ids: playlistIds}

    Modal.hide()


@Rooms = new Mongo.Collection 'rooms'

@Rooms.add = (name) ->
  room_id = Rooms.insert
    name: name
    dj_cap: 10
    user_id: Meteor.userId()
    playlist_ids: []
  Rooms.findOne room_id

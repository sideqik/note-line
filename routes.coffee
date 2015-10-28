# Routes
Router.configure({layoutTemplate: 'layout'})

Router.route '/', action: -> Router.go '/sign-in'
Router.route '/sign-in', layoutTemplate: 'signInLayout', action: -> if Meteor.user() then Router.go '/playlists' else @render 'signin'
Router.route '/sign-up' , layoutTemplate: 'signInLayout', action: -> if Meteor.user() then Router.go '/playlists' else @render 'signup'
Router.route '/sign-out', layoutTemplate: 'signInLayout', action: ->
  Meteor.logout()
  Router.go('/');
Router.route '/playlists', action: -> if Meteor.user() then @render 'playlists' else Router.go 'sign-in'
Router.route '/profile' , action: -> if Meteor.user() then @render 'profile' else Router.go 'sign-in'
Router.route '/delete-profile' , action: -> if Meteor.user() then @render 'delete_profile' else Router.go 'sign-in'

Router.route '/rooms', -> @render 'rooms'
Router.route '/rooms/:_id', ->
  room = Rooms.findOne _id: @params._id
  @render 'room', data: room

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup
    return

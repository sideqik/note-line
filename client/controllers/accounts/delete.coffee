Template.delete_profile.events
  'submit #delete-profile': (e) ->
    e.preventDefault()
    $('#delete-profile-btn').button('loading')
    $('#failed-delete').remove()
    Meteor.users.remove Meteor.user()._id, (error) ->
      if error
        $('#delete-profile-btn-btn').button('reset')
        $('#delete-profile').prepend("<div id='invalid-login' class='alert alert-danger'><strong> Couldn't delete profile.</strong> Please try again.</div>")
      else
        $('#delete-profile-btn').button('reset')
        Router.go('/')
    return

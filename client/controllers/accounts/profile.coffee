Template.profile.events
  'submit #profile': (e) ->
    e.preventDefault()
    $('#profile-btn').button('loading')
    $('#profile-save-info').remove()
    options = $('#profile').serializeJSON()
    options.emails = [{address: options.emails}]
    Meteor.users.update Meteor.user()._id, {$set: options}, (error) ->
      if error
        $('#profile-btn').button('reset')
        $('#profile').prepend("<div id='profile-save-info' class='alert alert-danger'><strong> Invalid Profile.</strong> #{error.reason}</div>")
      else
        $('#profile-btn').button('reset')
        $('#profile').prepend("<div id='profile-save-info' class='alert alert-success'><strong> Profile Saved.</strong></div>")

Template.profile.rendered = ->
  $('#email-field').val(Meteor.user().emails[0].address)

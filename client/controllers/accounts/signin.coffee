Template.signin.events
  'submit #signin': (e) ->
    e.preventDefault()
    $('#signin-btn').button('loading')
    $('#invalid-login').remove()
    login = $('#signin').serializeJSON()
    Meteor.loginWithPassword login.username, login.password, (error) ->
      if error
        $('#signin-btn').button('reset')
        $('#signin').prepend("<div id='invalid-login' class='alert alert-danger'><strong> Invalid Login.</strong> Please check your user information and try again.</div>")
      else
        $('#signin-btn').button('reset')
        Router.go('/')
    return

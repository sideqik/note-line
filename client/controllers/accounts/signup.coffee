Template.signup.events
  'submit #signup': (e) ->
    e.preventDefault()
    $('#signup-btn').button('loading')
    $('#invalid-account').remove()
    options = $('#signup').serializeJSON()
    Accounts.createUser options, (error) ->
      if error
        console.log error
        $('#signup-btn').button('reset')
        $('#signup').prepend("<div id='invalid-account' class='alert alert-danger'><strong> Invalid Account.</strong> #{error.reason}</div>")
      else
        $('#signin-btn').button('reset')
        Router.go('/')

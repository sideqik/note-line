Accounts.config({sendVerificationEmail: true})
Meteor.users.allow {
  update: (userId, doc, fields, modifier) ->
    if userId && doc._id == userId
      return true
    else
      false
  remove: (userId, doc) ->
    if userId && doc._id == userId
      return true
    else
      false
}

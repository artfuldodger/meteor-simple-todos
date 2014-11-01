Tasks = new Mongo.Collection('tasks')

if Meteor.isClient
  Template.body.helpers
    tasks: ->
      if Session.get('hideCompleted')
        Tasks.find({ checked: { $ne: true } }, { sort: { createdAt: -1 } })
      else
        Tasks.find({}, { sort: { createdAt: -1 } })
    hideCompleted: ->
      Session.get('hideCompleted')
    incompleteCount: ->
      Tasks.find({ checked: { $ne: true }}).count()

  Template.body.events
    'submit .new-task': (event) ->
      text = event.target.text.value

      Tasks.insert(
        text:      text,
        createdAt: new Date(),
        owner:     Meteor.userId(),
        username:  Meteor.user().username
      )

      # Clear form
      event.target.text.value = ''

      # Prevent default form submit
      false
    'change .hide-completed input': (event) ->
      Session.set('hideCompleted', event.target.checked)

  Template.task.events
    'click .toggle-checked': ->
      Tasks.update(this._id, { $set: { checked: not this.checked } })
    'click .delete': ->
      Tasks.remove(this._id)

  Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'

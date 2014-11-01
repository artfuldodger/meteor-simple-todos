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

      Meteor.call('addTask', text)

      # Clear form
      event.target.text.value = ''

      # Prevent default form submit
      false
    'change .hide-completed input': (event) ->
      Session.set('hideCompleted', event.target.checked)

  Template.task.events
    'click .toggle-checked': ->
      Meteor.call('setChecked', this._id, not this.checked)
    'click .delete': ->
      Meteor.call('deleteTask', this._id)

  Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'

Meteor.methods
  addTask: (text) ->
    throw new Meteor.Error('not-authorized') unless Meteor.userId()

    Tasks.insert(
      text:      text
      createdAt: new Date()
      owner:     Meteor.userId()
      username:  Meteor.user().username
    )
  deleteTask: (taskId) ->
    Tasks.remove(taskId)
  setChecked: (taskId, setChecked) ->
    Tasks.update(taskId, { $set: { checked: setChecked } })

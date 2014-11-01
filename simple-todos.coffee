Tasks = new Mongo.Collection('tasks')

if Meteor.isClient
  Template.body.helpers
    tasks: ->
      Tasks.find({}, { sort: { createdAt: -1 } })

  Template.body.events
    'submit .new-task': (event) ->
      text = event.target.text.value

      Tasks.insert(
        text: text,
        createdAt: new Date()
      )

      # Clear form
      event.target.text.value = ''

      # Prevent default form submit
      false

  Template.task.events
    'click .toggle-checked': ->
      Tasks.update(this._id, { $set: { checked: not this.checked } })
    'click .delete': ->
      Tasks.remove(this._id)

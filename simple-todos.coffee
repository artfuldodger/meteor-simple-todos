Tasks = new Mongo.Collection('tasks')

if Meteor.isClient
  Template.body.helpers
    tasks: ->
      Tasks.find({})

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

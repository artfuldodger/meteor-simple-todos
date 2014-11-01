Tasks = new Mongo.Collection('tasks')

if Meteor.isClient
  Template.body.helpers
    tasks: ->
      Tasks.find({})

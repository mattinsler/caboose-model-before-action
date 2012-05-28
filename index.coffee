caboose = Caboose.exports
util = Caboose.util
logger = Caboose.logger

module.exports =
  'caboose-plugin': {
    install: (util, logger) ->
      return logger.error('caboose-model is a prerequisite.  Please install it first.') unless Caboose.app.plugins.is_loaded('caboose-model')
      
      logger.title 'Running installer for caboose-model-before-action'
    
    initialize: ->
      return logger.error('caboose-model is a prerequisite.  Please install it first.') unless Caboose.app.plugins.is_loaded('caboose-model')
      
      if Caboose?
        Caboose.app.after 'initialize', (app) ->
        
          console.log Caboose.app.models
          for model in Caboose.app.models
            caboose.controller.Builder.add_plugin "before_action_#{model._short_name}",
              name: "before_action_#{model._short_name}"
              execute: (name, method) ->
                @before_action ((next) ->
                  id = @params["#{model._short_name}_id"] || @params.id
                  model.where(_id: id).first (err, value) =>
                    return next(err) if err?
                    return next(new Error("Could not find #{model._name} #{id}")) unless value?
                    @[model._short_name] = value
                    next()
                ), only: ['show', 'edit', 'update', 'destroy']
  }

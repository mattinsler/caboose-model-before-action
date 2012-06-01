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
        caboose.controller.Builder.add_plugin 'fetch_model_before_action',
          name: 'fetch_model_before_action'
          execute: (model, options) ->
            model = Caboose.get(model) if typeof model is 'string'
            @before_action ((next) ->
              id = @params["#{model.__short_name__}_id"] || @params.id
              model.where(_id: id).first (err, value) =>
                return next(err) if err?
                return next(new Error("Could not find #{model.__name__} #{id}")) unless value?
                @[model.__short_name__] = value
                next()
            ), options
  }

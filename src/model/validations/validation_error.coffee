#= require ../../object

class Batman.ValidationError extends Batman.Object

  formatErrorsForField = (allFailures, key, errorValues) ->
    if errorValues.length == 1
      allFailures += "<li>#{key} " + errorValues.join(',') + "</li>"
    else
      allFailures += "<ul>"
      for error in errorValues
        allFailures += "<li>" + error + "</li>"
      allFailures += "</ul>"

    return allFailures

  @accessor 'fullMessage', ->
    if @attribute == 'base'
      if typeof @message == "string"
        Batman.t 'errors.base.format',
          message: @message
    else
      if typeof @message == "string"
        Batman.t 'errors.format',
          attribute: Batman.helpers.humanize(@attribute)
          message: @message
      else if typeof @message == "object"
        if Object.keys(@message).length == 1
          key = Object.keys(@message)[0]
          val = @message[key]
          allFailures = key + " " + val
        else
          allFailures = "<ul>"
          for key, val of @message
            formatErrorsForField(allFailures, key, val)
          allFailures += "</ul>"


        Batman.t 'errors.format',
          attribute: Batman.helpers.humanize(@attribute)
          message: allFailures
  constructor: (attribute, message) -> super({attribute, message})

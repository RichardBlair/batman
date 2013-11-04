#= require ../../object

class Batman.ValidationError extends Batman.Object

  formatErrorObject: (message) ->
    allKeys = Batman.keys(message)
    if allKeys.length == 1
      key = allKeys[0]
      val = message[key]
      val = val.join (", ") if Batman.typeOf(val) == 'Array'

      allFailures = "#{key} #{val}"
    else
      allFailures = "<ul class='#{@UL_ERROR_CLASS}'>"
      for key, val of message
        allFailures += @formatErrorsForField(key, val)
      allFailures += "</ul>"

    return allFailures

  formatErrorsForField: (key, errorValues) ->
    allFailures = ""
    if errorValues.length == 1
      allFailures += "<li class='#{@LI_ERROR_CLASS}'>#{key} #{errorValues.join(', ')}</li>"
    else
      allFailures += "<li class='#{@LI_ERROR_CLASS}'>#{key}"
      allFailures += "<ul class='#{@UL_ERROR_CLASS}'>"
      for error in errorValues
        allFailures += "<li class='#{@LI_ERROR_CLASS}'>#{error}</li>"
      allFailures += "</ul>"
      allFailures += '</li>'

    return allFailures

  UL_ERROR_CLASS: ""
  LI_ERROR_CLASS: ""

  @accessor 'fullMessage', ->
    if typeof @message == "string"
      allFailures = @message
    else if typeof @message == "object"
      allFailures = @formatErrorObject(@message)

    if @attribute == 'base'
      Batman.t 'errors.base.format',
        message: allFailures
    else
      Batman.t 'errors.format',
        attribute: Batman.helpers.humanize(@attribute)
        message: allFailures
  constructor: (attribute, message) -> super({attribute, message})

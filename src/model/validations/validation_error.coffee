#= require ../../object

class Batman.ValidationError extends Batman.Object

  formatErrorObject = (message) ->
    if Object.keys(message).length == 1
      key = Object.keys(message)[0]
      val = message[key]
      if val instanceof Array
        val = val.join (", ")

      allFailures = key + " " + val
    else
      allFailures = "<ul class='#{ValidationError.UL_ERROR_CLASS}'>"
      for key, val of message
        allFailures += formatErrorsForField(key, val)
      allFailures += "</ul>"

    return allFailures

  formatErrorsForField = (key, errorValues) =>
    allFailures = ""
    if errorValues.length == 1
      allFailures += "<li class='#{@LI_ERROR_CLASS}'>#{key} " + errorValues.join(', ') + "</li>"
    else
      allFailures += "<li class='#{ValidationError.LI_ERROR_CLASS}'>" + key
      allFailures += "<ul class='#{@UL_ERROR_CLASS}'>"
      for error in errorValues
        allFailures += "<li class='#{@LI_ERROR_CLASS}'>" + error + "</li>"
      allFailures += "</ul>"
      allFailures += '</li>'

    return allFailures

  @UL_ERROR_CLASS = ""
  @LI_ERROR_CLASS = ""

  @accessor 'fullMessage', ->
    if typeof @message == "string"
      allFailures = @message
    else if typeof @message == "object"
      allFailures = formatErrorObject(@message)

    if @attribute == 'base'
      Batman.t 'errors.base.format',
        message: allFailures
    else
      Batman.t 'errors.format',
        attribute: Batman.helpers.humanize(@attribute)
        message: allFailures
  constructor: (attribute, message) -> super({attribute, message})

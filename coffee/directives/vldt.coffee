Site.directive 'vldt', ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    EMAIL_REGEX = /^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    DIGIT_REGEX = /^\d+$/

    rules = for rawRule in attrs.vldt.split ','
      p = type:null, param:null, message:null
      for rulePart in rawRule.split(/(?=[:|!])/)
        $.trim rulePart
        switch rulePart.charAt 0
          when ";" then p.message = $.trim rulePart.substring(1) # its the message
          when ":" then p.param = $.trim rulePart.substring(1) # its the parameter
          else p.type = $.trim rulePart # must be the type
      p

    messages =
      req:'Feltet skal udfyldes'
      mail:'Ikke en gyldig email'
      length:'Mindst :param: karaktere'
      match:'Er ikke ens'
      digit:'Må kun indeholde tal'

    messageForRule = (rule) -> (rule.message ?= messages[rule.type]).replace ':param:', rule.param

    handleErrors = (rules) ->
      if rules.length == 0 then element.removeClass 'vldt-error' else element.addClass 'vldt-error'
    #for rule in rules
    #  element.val(messageForRule rule)

    $(element).on 'change', () ->
      failedRules = []
      val = $(this).val()
      for rule in rules
        switch rule.type
          when 'req' then if val.length is 0 then failedRules.push rule
          when 'mail' then if not EMAIL_REGEX.test val then failedRules.push rule
          when 'length' then if val.length < parseInt rule.param, 10 then failedRules.push rule
          when 'match' then if val isnt $(rule.param).val() then failedRules.push rule
          when 'digit' then if not DIGIT_REGEX.test val then failedRules.push rule
          else throw new Error "Unknown rule type '#{rule.type}'"
      handleErrors failedRules

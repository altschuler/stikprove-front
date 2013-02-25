Site.directive 'roleNav', (Session) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    clearance = parseInt attrs.roleNav

    updateVisibility = ->
      user = Session.user

      if clearance is 0 # 0 means everybody has access
        element.show()
      else if user?
        if clearance is -1 # -1 means hide from authenticated users, therefore hide
          element.hide()
        else if user.Role.Id <= clearance
          element.show()
        else # user did not have sufficient role
          element.hide()
      else if clearance is -1
        element.show()
      else # it's not 0 and there is no user, therefore deny
        element.hide()


    scope.$on 'session:changed', -> updateVisibility()


    updateVisibility()

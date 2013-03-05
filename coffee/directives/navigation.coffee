Site.directive 'roleNav', (Session) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    requiredRole = parseInt attrs.roleNav

    updateVisibility = ->
      # 0 means everybody has access
      if requiredRole is 0
        element.show()
      # -1 means hide from authenticated users
      else if Session.isLoggedIn() and requiredRole is -1
        element.hide()
      # check that user's roles contain the required role
      else if Session.isLoggedIn() and _.any(Session.user.Roles, (role) -> role.Id is requiredRole)
        element.show()
      else if not Session.isLoggedIn() and requiredRole is -1
        element.show()
      # user did not have sufficient role
      else
        element.hide()

    scope.$on 'session:changed', -> updateVisibility()

    updateVisibility()

Site.controller 'UserIndexCtrl', ($scope, $location, $routeParams, Api, Utils) ->
  console.log 'ABE'
  $scope.user = new Api.user()
  $scope.user.Roles = []

  # get current users and roles
  $scope.users = Api.user.query()
  $scope.availableUserRoles = Api.userRole.query()

  $scope.addUser = ->
    success = ->
      $location.path '/manage/users'

    error = (u, response) ->
      alert 'something bad happened while creating user'
      console.log u, response

    $scope.user.$save {}, success, error

  # TODO TEST ROLES
  $scope.removeRole = (role) ->
    [$scope.user.Roles, $scope.availableUserRoles] = Utils.moveElement role, $scope.user.Roles, $scope.availableUserRoles

  $scope.removeUser = (user) ->
    Api.user.remove id:user.Id, ->
      $scope.apply ->
        $scope.users = Api.user.query()

  # tabs control
  $scope.activePage = $routeParams.page
  $scope.$on '$routeChangeSuccess', (scope, next, current) ->
    $scope.activePage = next.params.page
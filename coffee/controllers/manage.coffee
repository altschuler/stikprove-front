Site.controller 'ManageIndexCtrl', ($scope, $routeParams, $location, Api, Utils) ->
  $scope.company = new Api.company()
  $scope.user = new Api.user()
  $scope.user.Roles = []

  $scope.addCompany = ->
    $scope.company.$save()

  $scope.addUser = ->
    success = ->
      $location.path '/manage/users'

    error = (u, response) ->
      alert 'something bad happenede'
      console.log u, response

    $scope.user.$save {}, success, error

  # TODO TEST ROLES
  $scope.addRole = (selectedRole) ->
    [$scope.availableUserRoles, $scope.user.Roles] =
      Utils.moveElement {Id:parseInt selectedRole}, $scope.availableUserRoles, $scope.user.Roles

  $scope.removeRole = (role) ->
    [$scope.user.Roles, $scope.availableUserRoles] =
      Utils.moveElement role, $scope.user.Roles, $scope.availableUserRoles

  $scope.removeUser = (user) ->
    Api.user.remove id:user.Id, ->
      $scope.apply ->
        $scope.users = Api.user.query()

  $scope.users = Api.user.query()
  $scope.companies = Api.company.query()
  $scope.availableUserRoles = Api.userRole.query()

  # tabs control
  $scope.activePage = $routeParams.page
  $scope.$on '$routeChangeSuccess', (scope, next, current) ->
    $scope.activePage = next.params.page


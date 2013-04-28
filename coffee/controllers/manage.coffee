Site.controller 'ManageIndexCtrl', ($scope, $routeParams, $location, Api, Utils) ->
  $scope.company = new Api.company()

  $scope.addCompany = ->
    $scope.company.$save()

  $scope.addRole = (selectedRole) ->
    [$scope.availableUserRoles, $scope.user.Roles] =
      Utils.moveElement {Id:parseInt selectedRole}, $scope.availableUserRoles, $scope.user.Roles

  $scope.companies = Api.company.query()

  # tabs control
  $scope.activePage = $routeParams.page
  $scope.$on '$routeChangeSuccess', (scope, next, current) ->
    $scope.activePage = next.params.page


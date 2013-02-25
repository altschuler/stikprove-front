Site.controller 'ManageIndexCtrl', ($scope, $routeParams, Api) ->
  $scope.company = new Api.company()
  $scope.user = new Api.user()

  $scope.addCompany = ->
    $scope.company.$save()

  $scope.addUser = ->
    $scope.user.$save()

  $scope.removeUser = (user) ->
    Api.user.remove id:user.Id, ->
      $scope.apply ->
        $scope.users = Api.user.query()

  $scope.users = Api.user.query()
  $scope.companies = Api.company.query()
  $scope.userRoles = Api.userRole.query()

  # tabs control
  $scope.activePage = $routeParams.page
  $scope.$on '$routeChangeSuccess', (scope, next, current) ->
    $scope.activePage = next.params.page


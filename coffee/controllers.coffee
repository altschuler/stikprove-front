Site.controller 'FrontCtrl', ($scope, Api) ->
  $scope.translateFromId = (id) ->
    $scope.data.translated = Api.translation.get
      id:id

Site.controller 'ManageCtrl', ($scope, $routeParams, Api) ->
  $scope.company = new Api.company()

  $scope.addCompany = () ->
    $scope.company.$save()

  $scope.users = Api.user.query()
  $scope.companies = Api.company.query()

  # tabs control
  $scope.activePage = $routeParams.page
  $scope.$on '$routeChangeSuccess', (scope, next, current) ->
    $scope.activePage = next.params.page


Site.controller 'LoginCtrl', ($scope, Api) ->
  $scope.login = () ->
    Api.auth.login($scope.data.userName, $scope.data.password)
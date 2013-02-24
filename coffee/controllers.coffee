Site.controller 'FrontCtrl', ($scope, Api) ->
  $scope.translateFromId = (id) ->
    $scope.data.translated = Api.translation.get
      id:id

Site.controller 'ManageCtrl', ($scope, $routeParams, Api) ->
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


Site.controller 'LoginCtrl', ($scope, $http, Session) ->
  $scope.login = ->
    token = Base64.encode "#{$scope.data.userName}:#{$scope.data.password}"
    $http.defaults.headers.common['Authorization'] = "Basic #{token}"

    success = (response) ->
      if response.status is 200
        Session.login response.data
        console.log Session.user

    error = (response) ->
      delete $http.defaults.headers.common['Authorization']
      alert 'How about no!'

    $http.get("/api/ping/any").then success, error
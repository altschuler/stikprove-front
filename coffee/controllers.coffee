Site.controller 'FrontCtrl', ($scope, Api) ->
  $scope.translateFromId = (id) ->
    $scope.data.translated = Api.translation.get
      id:id


Site.controller 'ManageCtrl', ($scope, $routeParams) ->
  $scope.activePage = $routeParams.page || "consumption"



Site.controller 'LoginCtrl', ($scope, Api) ->
  $scope.data =
    msg: 'Go login'

  $scope.login = () ->
    Api.auth.login($scope.data.userName, $scope.data.password)


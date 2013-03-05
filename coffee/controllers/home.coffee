Site.controller 'NavCtrl', ($scope, Session, $location) ->

  updateScope = ->
    $scope.data =
      isLoggedIn: Session.isLoggedIn()
      displayName: if Session.isLoggedIn() then Session.user.FirstName

  updateScope()

  $scope.$on 'session:changed', updateScope

  $scope.logout = ->
    Session.logout()
    $location.path '/'


Site.controller 'HomeIndexCtrl', ($scope, Api) ->
  $scope.translateFromId = (id) ->
    $scope.data.translated = Api.translation.get id:id


Site.controller 'HomeLoginCtrl', ($scope, $http, $location, Session, Api) ->
  $scope.login = ->
    success = (response) ->
      if response.status is 200
        Session.login response.data
        $location.path '/'

    error = (response) ->
      alert 'Invalid login!'

    Api.auth.login($scope.data.userName, $scope.data.password).then success, error
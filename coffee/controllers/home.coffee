Site.controller 'NavCtrl', ($scope, Session, $location) ->

  updateScope = ->
    $scope.data =
      isAuthenticated: Session.isAuthenticated()
      displayName: if Session.isAuthenticated() then Session.user.FirstName

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
    token = Session.generateToken $scope.data.userName, $scope.data.password
    success = (response) ->
      if response.status is 200
        Session.login response.data, token
        $location.path '/'

    error = (response) ->
      alert 'How about no!'

    Api.auth.validateToken(token).then success, error
    #Session.validateSession()
    #Api.auth.try(token).then success, error
    #$http.get("/api/ping/any", headers:{'Authorization':"Basic #{token}"}).then success, error
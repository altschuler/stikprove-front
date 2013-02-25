Site = angular.module('Site', ['ngResource', 'ngCookies'])

# --- ROUTING --- #
Site.config ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
    .when '/',
      templateUrl:'views/home/index.html'
      controller:'HomeIndexCtrl'
      auth:0

    .when '/login',
      templateUrl:'views/home/login.html'
      controller:'HomeLoginCtrl'
      auth:0

    .when '/manage', # default to consumption tab
      redirectTo:'manage/usage'

    .when '/manage/:page',
      templateUrl:'views/manage/index.html'
      controller:'ManageIndexCtrl'
      auth:1

    .when '/not-found',
      templateUrl:'views/errors/not-found.html'
      auth:0

    .otherwise
      redirectTo:'/not-found'

  #$locationProvider.html5Mode true

# --- ROUTE AUTHORIZATION --- #
Site.run ($rootScope, $location, $route, Session) ->

  startListening = ->
    $rootScope.$on '$routeChangeStart', (event, current, previous) ->
      # if we are being redirected, don't try to validate the route
      if not current.redirectTo?
        validateRoute current.$route

  # TODO this could be using a simple callback instead
  error = success = ->
    # validate current route - will only be triggered once per page load
    validateRoute $route
    startListening()

  # try logging in with cookie data
  Session.tryCookie().then success, error
  # TODO simplify
  validateRoute = (route) ->
    authorized = no
    clearance = route.auth
    if clearance is 0 # 0 means everybody has access
      authorized = yes
    else if clearance? and Session.user?
      authorized = Session.user.Role.Id <= clearance
    else # no auth attribute means any authenticated user has access
      authorized = Session.user?

    if not authorized then $location.path '/login'
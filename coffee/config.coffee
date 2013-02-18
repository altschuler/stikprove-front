Site = angular.module('Site', ['ngResource'])

Site.config ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl:'views/home/front.html',
      controller:'FrontCtrl'

    .when '/home/login',
      templateUrl:'views/home/login.html',
      controller:'LoginCtrl'

    .when '/manage', # default to consumption tab
      redirectTo:'manage/consumption'

    .when '/manage/:tab',
      templateUrl:'views/manage/index.html',
      controller:'ManageCtrl'

    .when '/not-found',
      templateUrl:'views/errors/not-found.html'

    .otherwise
      redirectTo:'/not-found'
  #$locationProvider.html5Mode(true)

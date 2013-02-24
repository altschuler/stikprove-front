Site = angular.module('Site', ['ngResource'])

Site.config ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
    .when '/',
      templateUrl:'views/home/index.html'
      controller:'FrontCtrl'

    .when '/login',
      templateUrl:'views/home/login.html'
      controller:'LoginCtrl'

    .when '/manage', # default to consumption tab
      redirectTo:'manage/usage'

    .when '/manage/:page',
      templateUrl:'views/manage/index.html'
      controller:'ManageCtrl'

    .when '/spot/new',
      templateUrl:'views/spot/new.html'
      controller:'SpotNewCtrl'

    .when '/not-found',
      templateUrl:'views/errors/not-found.html'

    .otherwise
      redirectTo:'/not-found'

  $httpProvider.responseInterceptors.push 'authHttpInterceptor'

  #$locationProvider.html5Mode true


#Site.run ($http) ->
#  $http.defaults.headers.common['Authorization'] = "Basic c2ltb25AYWx0c2NodWxlci5kazoxMjM="


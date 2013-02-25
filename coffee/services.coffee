Site.value 'BaseURL', 'http://localhost\\:55471'

Site.factory 'Api', ($http, $resource, BaseURL) ->
  translation: $resource BaseURL + '/api/translation/:id'
  user: $resource BaseURL + '/api/user/:id'
  company: $resource BaseURL + '/api/company/:id'
  userRole: $resource BaseURL + '/api/userrole/:id'
  auth:
    validateToken: (token) ->
      $http.get("/api/ping/any", headers:{'Authorization':"Basic #{token}"})

Site.service 'Session', ($cookieStore, $http, $rootScope, $q, Api) ->
  @user = null
  @token = null

  generateToken: (login, password) ->
    Base64.encode "#{login}:#{password}"

  login: (user, token) ->
    @user = user
    @token = token
    $cookieStore.put 'session', (user:@user, token:@token)
    $http.defaults.headers.common['Authorization'] = "Basic #{@token}"
    $rootScope.$broadcast 'session:changed'

  logout: ->
    @user = null
    @token = null
    $cookieStore.remove 'session'
    delete $http.defaults.headers.common['Authorization']
    $rootScope.$broadcast 'session:changed'

  isAuthenticated: ->
    @user? and @token?

  tryCookie: ->
    deferred = $q.defer()
    session = $cookieStore.get 'session'
    if session
      success = =>
        @login session.user, session.token
        deferred.resolve()
      error = =>
        deferred.reject()
      @validateSession(session).then success, error
    else
      deferred.reject()
    deferred.promise

  validateSession: (session) ->
    Api.auth.validateToken session.token

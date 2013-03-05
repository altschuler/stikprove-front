Site.value 'BaseURL', 'http://localhost\\:55471'

Site.factory 'Utils', ->
  moveElement: (match, fromArr, toArr) ->
    elms = if typeof match is 'object'
      _.where fromArr, match
    else
      [match]

    newTo = _.union toArr, elms
    newFrom = _.difference fromArr, elms
    [newFrom, newTo]

Site.service 'Api', ($http, $resource, BaseURL) ->
  translation: $resource BaseURL + '/api/translation/:id'
  user: $resource BaseURL + '/api/user/:id'
  company: $resource BaseURL + '/api/company/:id'
  userRole: $resource BaseURL + '/api/userrole/:id'
  auth:
    login: (name, password) ->
      $http.post("/api/access/login", {Name:name, Password:password})

    ping: (token) ->
      $http
        method:'POST'
        url:"/api/ping"
        headers:
          Authorization: "token #{token}"

Site.service 'Session', ($cookieStore, $http, $rootScope, $q, Api) ->
  @user = null

  generateToken: (id, token) ->
    Base64.encode "#{id}:#{token}"

  # set a user as the session owner
  login: (user) ->
    @user = user
    token = @generateToken(user.Id, user.AccessToken)
    $cookieStore.put 'session-user', @user
    $http.defaults.headers.common['Authorization'] = "token #{token}"
    $rootScope.$broadcast 'session:changed'

  logout: ->
    @user = null
    $cookieStore.remove 'session-user'
    delete $http.defaults.headers.common['Authorization']
    $rootScope.$broadcast 'session:changed'

  isLoggedIn: -> @user?

  tryCookie: ->
    deferred = $q.defer()
    sessionUser = $cookieStore.get 'session-user'
    if sessionUser
      success = =>
        @login sessionUser
        deferred.resolve()
      error = =>
        deferred.reject()
      @validateSession(sessionUser).then success, error
    else
      deferred.reject()
    deferred.promise

  validateSession: (sessionUser) ->
    if not sessionUser?
      deferred = $q.defer()
      deferred.reject()
      return deferred
    Api.auth.ping @generateToken(sessionUser.Id, sessionUser.AccessToken)

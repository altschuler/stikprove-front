Site.value 'BaseURL', 'http://localhost\\:55471'

Site.factory 'Api', ($http, $resource, BaseURL) ->
  translation: $resource BaseURL + '/api/translation/:id'
  user: $resource BaseURL + '/api/user/:id'
  company: $resource BaseURL + '/api/company/:id'
  userRole: $resource BaseURL + '/api/userrole/:id'

Site.service 'Session', ->
  @user = null

  #setAuth: (login, password) ->
  #  token = Base64.encode "#{login}:#{password}"
  #  #$http.defaults.headers.common['Authorization'] = "Basic #{token}"

  login: (user) ->
    @user = user
    @user.FullName = "#{user.FirstName} #{user.LastName}"

  logout: ->
    @user = null

  isAuthenticated: ->
    @user isnt null

Site.factory 'authHttpInterceptor', ($q, $location, Session) ->
  success = (response) ->
    console.log Session
    if not Session.user
      $location.path '/login'
    response

  error = (response) ->
    if response.status == 401
      $location.path '/login'
    $q.reject response

  (promise) ->
    promise.then success, error

Site.value 'BaseURL', 'http://localhost:55471\:55471'

Site.factory 'Api', ($http, $resource, Auth, BaseURL) ->
  rootURL = 'http://localhost:55471\:55471'
  Translation = $resource rootURL + '/api/translation/:id'
  User = $resource rootURL + '/api/user/:id'

  # model
  translation: Translation,
  user: User
  # service
  auth:Auth

Site.factory 'Auth', (BaseURL) ->
  login: (userName, password) ->
    console.log(BaseURL, userName, password)
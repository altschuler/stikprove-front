Site.value 'BaseURL', 'http://localhost:55471\:55471'

Site.factory 'Api', ($http, $resource, Auth, BaseURL) ->
  translation: $resource BaseURL + '/api/translation/:id'
  user: $resource BaseURL + '/api/user/:id'
  company: $resource BaseURL + '/api/company/:id'
  auth: Auth

Site.factory 'Auth', (BaseURL) ->
  login: (userName, password) ->
    console.log(BaseURL, userName, password)
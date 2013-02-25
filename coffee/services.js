// Generated by CoffeeScript 1.4.0
(function() {

  Site.value('BaseURL', 'http://localhost\\:55471');

  Site.factory('Api', function($http, $resource, BaseURL) {
    return {
      translation: $resource(BaseURL + '/api/translation/:id'),
      user: $resource(BaseURL + '/api/user/:id'),
      company: $resource(BaseURL + '/api/company/:id'),
      userRole: $resource(BaseURL + '/api/userrole/:id'),
      auth: {
        validateToken: function(token) {
          return $http.get("/api/ping/any", {
            headers: {
              'Authorization': "Basic " + token
            }
          });
        }
      }
    };
  });

  Site.service('Session', function($cookieStore, $http, $rootScope, $q, Api) {
    this.user = null;
    this.token = null;
    return {
      generateToken: function(login, password) {
        return Base64.encode("" + login + ":" + password);
      },
      login: function(user, token) {
        this.user = user;
        this.token = token;
        $cookieStore.put('session', {
          user: this.user,
          token: this.token
        });
        $http.defaults.headers.common['Authorization'] = "Basic " + this.token;
        return $rootScope.$broadcast('session:changed');
      },
      logout: function() {
        this.user = null;
        this.token = null;
        $cookieStore.remove('session');
        delete $http.defaults.headers.common['Authorization'];
        return $rootScope.$broadcast('session:changed');
      },
      isAuthenticated: function() {
        return (this.user != null) && (this.token != null);
      },
      tryCookie: function() {
        var deferred, error, session, success,
          _this = this;
        deferred = $q.defer();
        session = $cookieStore.get('session');
        if (session) {
          success = function() {
            _this.login(session.user, session.token);
            return deferred.resolve();
          };
          error = function() {
            return deferred.reject();
          };
          this.validateSession(session).then(success, error);
        } else {
          deferred.reject();
        }
        return deferred.promise;
      },
      validateSession: function(session) {
        return Api.auth.validateToken(session.token);
      }
    };
  });

}).call(this);
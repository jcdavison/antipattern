angular.module('App.services', [] )
  .factory 'User', ($q, $http) ->
    User = 
      authorized: false
      isAuthorized: () ->
        $http
          method: 'get' 
          url: '/api/authorized_user'
        .success (response) ->
          @authorized = true
    return User

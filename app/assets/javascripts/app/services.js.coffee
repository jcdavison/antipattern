angular.module('App.services', [] )
  .factory 'User', ($q, $http, $rootScope) ->
    User = 
      authorize: () ->
        deferred = $q.defer()
        $http
          method: 'get' 
          url: '/api/authorized_user'
        .success (response) =>
          $rootScope.authorizedUser = true
          deferred.resolve(response)
        .error (response) =>
          deferred.reject(response)
        return deferred.promise
    return User

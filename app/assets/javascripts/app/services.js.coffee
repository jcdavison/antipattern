angular.module('App.services', [] )
  .factory 'User', ($q, $http, $rootScope) ->
    User = 
      isAuthorized: () ->
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

  .factory 'Offer', ($q, $http) ->
    Offer = 
      display_status: 'instructions'
      submit: (reviewRequestId) ->
        deferred = $q.defer()
        data = 
          reviewRequestId: reviewRequestId
        $http
          method: 'post' 
          url: '/api/offers'
          data: data
        .success (response) =>
          @display_status = 'confirmation'
          deferred.resolve(response)
        .error (response) =>
          @display_status = 'error'
          deferred.reject(response)
        return deferred.promise
    return Offer

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
      state: null
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
      registerDecision: (args) ->
        deferred = $q.defer()
        data = 
          id: args.offerId
          decision: args.decision
        $http
          method: 'post'
          url: '/api/offer_decisions'
          data: data
        .success (response) =>
          offer = JSON.parse response.offer
          @state = offer.aasm_state
          deferred.resolve(response)
        .error (response) =>
          deferred.reject(response)
        return deferred.promise
    return Offer

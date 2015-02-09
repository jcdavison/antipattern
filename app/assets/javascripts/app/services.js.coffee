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

  .factory 'ReviewRequest', ($q, $http) ->
    ReviewRequest = 
      accepted: null
      allCodeReviews: []
      getAll: () ->
        $http
          method: 'get'
          url: '/api/reviews.json'
        .then (response) =>
          @allCodeReviews = response.data
      userHasOffered: (reviewRequestId) ->
        deferred = $q.defer()
        $http
          method: 'get' 
          url: "/api/has_offered?id=#{reviewRequestId}"
        .success (response) =>
          deferred.resolve(response)
        .error (response) =>
          deferred.reject(response)
        return deferred.promise
      ownedByCurrentUser: (reviewRequestId) ->
        deferred = $q.defer()
        $http
          method: 'get' 
          url: "/api/owned_by?id=#{reviewRequestId}"
        .success (response) =>
          deferred.resolve(response)
        .error (response) =>
          deferred.reject(response)
        return deferred.promise
      create: (codeReview) ->
        codeReview.value = codeReview.value.value * 100
        data =
          code_review: codeReview
        $http
          method: 'post' 
          url: '/api/reviews.json'
          data: data
        .then (response) =>
          if response.status == 200
            @allCodeReviews.unshift response.data.review_request
      update: (codeReview, indexOfCodeReview) ->
        codeReview.value = (codeReview.value * 100)
        $http
          method: 'put'
          url: '/api/reviews.json'
          data:
            code_review: codeReview
        .then (response) =>
    return ReviewRequest

  .factory 'Offer', ($q, $http) ->
    Offer = 
      display_status: 'instructions'
      accept_status: null
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
      checkStatus: (offerId) ->
        deferred = $q.defer()
        $http
          method: 'get'
          url: "/api/decision_registered?id=#{offerId}"
        .success (response) =>
          @accept_status = response.accept_status
          deferred.resolve(response)
        .error (response) =>
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
          deferred.resolve(response)
        .error (response) =>
          deferred.reject(response)
        return deferred.promise
    return Offer

angular.module('App.services', [] )
  .factory 'User', ($q, $http, $rootScope) ->
    User = 
      hasStripeAccount: null 
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
  
  .factory 'Wallet', ($q, $http, $rootScope) ->
    Wallet = 
      validCreditCard: true
      setCcToken: (token) ->
        $http
          method: 'post' 
          data: 
            stripe_cc_token: token
          url: '/api/tokens'
        .then (response) =>
          if response.status == 200
            @validCreditCard == true
          return response
      validateDetail: (detail) ->
        $http
          method: 'get'
          url: "/api/tokens?detail=#{detail}"
        .then (response) ->
          return response.data
    return Wallet

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
      get: (id) ->
        $http
          method: 'get'
          url: "/api/review.json?id=#{id}"
        .then (response) ->
          return response
      userHasOffered: (reviewRequestId) ->
        $http
          method: 'get' 
          url: "/api/has_offered?id=#{reviewRequestId}"
        .then (response) =>
          return response
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
          return response
      delete: (codeReview) ->
        $http
          method: 'delete'
          url: "/api/reviews/#{codeReview.id}.json"
        .then (response) =>
          return response
    return ReviewRequest

  .factory 'Offer', ($q, $http) ->
    Offer = 
      getSpecified: (codeReviewId, userId) ->
        $http
          method: 'get' 
          url: "/api/offers.json?code_review_id=#{codeReviewId}&user_id=#{userId}"
        .then (response) ->
          return response
      submit: (reviewRequestId) ->
        data = 
          reviewRequestId: reviewRequestId
        $http
          method: 'post' 
          url: '/api/offers'
          data: data
        .then (response) ->
          return response
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
      updateOfferState: (args) ->
        data = 
          offer: args.offer
          new_state: args.newState
        $http
          method: 'put'
          url: '/api/offers.json'
          data: data
        .then (response) ->
          return response
      deliver: (offer) ->
        $http
          method: 'post'
          url: '/api/offers/deliver.json'
          data: offer
        .then (response) ->
          return response
      setPaymentDetail: (args) ->
        $http
          method: 'post'
          url: '/api/offers/payments.json'
          data: 
            proportion_to_donate: args.proportionToDonate
            offer: args.offer
        .then (response) ->
          return response
    return Offer

controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User, ReviewRequest) ->
  User.isAuthorized().then (response) ->
    if response.success
      $rootScope.$broadcast 'authorized-user'

  $scope.newReviewRequests = []

  $scope.$on 'review-request-created', () ->
    $scope.newReviewRequests = ReviewRequest.recentlyCreated
)

controllers.controller('createCodeReviewCtrl', ($scope, $rootScope, $modalInstance, $modal, ReviewRequest) ->
  $scope.codeReview = {}
  $scope.reviewRequests = []
  $scope.values = [
    {value: '$10.00'},
    {value: '$25.00'},
    {value: '$50.00'} ]
  $scope.reviewRequest.value = $scope.values[0]

  setAcceptStatus = () ->
    $scope.accepted = ReviewRequest.accepted
  setAcceptStatus()

  $scope.createReviewRequest = () ->
    ReviewRequest.create($scope.codeReview).then (newReviewRequest) ->
      $rootScope.$broadcast 'review-request-created'
      setAcceptStatus()
      $modalInstance.dismiss('cancel');


  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

controllers.controller('requestCodeReview', ($scope, $rootScope, $modal, User) ->
  $scope.requestCodeReview = () ->
    if $rootScope.authorizedUser == true
      modalInstance = $modal.open(
        templateUrl: 'requestCodeReview.html'
        controller: 'createCodeReviewCtrl'
      )
    else
      modalInstance = $modal.open(
        templateUrl: 'pleaseLogin.html'
        controller: 'genericModalCtrl'
      )
)

controllers.controller('reviewRequestCtrl', ($scope, $rootScope, $modal, $location, User, $attrs, ReviewRequest) ->
  $scope.reviewRequest = {}
  $scope.showDetail = false
  $scope.hasOffered = false
  $scope.ownedByCurrentUser = false

  ownedByCurrentUser = () ->
    ReviewRequest.ownedByCurrentUser($attrs.reviewRequestId).then (response) ->
      $scope.ownedByCurrentUser = response.owned_by

  $scope.$on 'authorized-user', () ->
    ownedByCurrentUser()

  setShowDetail = () ->
    if $location.absUrl().match /code-reviews/
      $scope.showDetail = true
  setShowDetail()

  $scope.$on 'review-offer-created', () ->
    setHasOffered()

  $scope.toggleDetail = () ->
    $scope.showDetail = ! $scope.showDetail

  setHasOffered = () ->
    ReviewRequest.userHasOffered($attrs.reviewRequestId).then (response) ->
      $scope.hasOffered = response.has_offered

  setHasOffered()

  $scope.editReviewRequest = () ->
    modalInstance = $modal.open(
      templateUrl: 'editCodeReview.html'
      controller: 'editCodeReviewCtrl'
      size: 'md'
      resolve:
        reviewRequestId: () ->
          $attrs.reviewRequestId
        reviewRequestDetail: () ->
          $attrs.reviewRequestDetail
        reviewRequestValue: () ->
          $attrs.reviewRequestValue
        reviewRequestTitle: () ->
          $attrs.reviewRequestTitle
    )

  $scope.confirmReviewOffer = (modalPurpose, reviewRequestId, size) ->
    if $rootScope.authorizedUser == true
      if modalPurpose == 'submitOffer'
        modalInstance = $modal.open(
          templateUrl: 'submitOffer.html'
          controller: 'offerCodeReviewCtrl'
          size: size
          resolve:
            reviewRequestId: () ->
              reviewRequestId
        )
    else
      modalInstance = $modal.open(
        templateUrl: 'pleaseLogin.html'
        controller: 'genericModalCtrl'
      )
)

controllers.controller('editCodeReviewCtrl', ($scope, $rootScope, $modalInstance, User, reviewRequestId, reviewRequestDetail, reviewRequestValue, reviewRequestTitle, ReviewRequest) -> 
  $scope.reviewRequest = {}

  $scope.reviewRequest.id = reviewRequestId
  $scope.reviewRequest.detail_html = reviewRequestDetail
  $scope.reviewRequest.title = reviewRequestTitle
  $scope.values = [ {value: '$10.0'}, {value: '$25.0'}, {value: '$50.0'} ]

  $scope.values.forEach (ele, i) ->
    if ele.value == reviewRequestValue
      $scope.reviewRequest.display_value = $scope.values[i] 

  $scope.editReviewRequest = () ->
    ReviewRequest.update($scope.reviewRequest).then () ->
      console.log "wtf"
      $scope.reviewRequest = ReviewRequest.codeReviews[reviewRequestId]
)

controllers.controller('offerCodeReviewCtrl', ($rootScope, $scope, $modalInstance, reviewRequestId, Offer) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');

  setDisplayStatus = () ->
    $scope.display_status = Offer.display_status
  setDisplayStatus()

  $scope.offerCodeReview = () ->
    Offer.submit(reviewRequestId).then (r) ->
      $rootScope.$broadcast 'review-offer-created'
      setDisplayStatus()
)

controllers.controller('offerCtrl', ($rootScope, $scope, Offer, $attrs) ->
  $scope.acceptStatus = null
  $scope.registerDecision = (decision, offerId) ->
    Offer.registerDecision( decision: decision, offerId: offerId).then (response) ->
      setAcceptStatus()

  setAcceptStatus = () ->
    Offer.checkStatus($attrs.offerId).then (response) ->
      $scope.acceptStatus = Offer.accept_status

  $scope.$on 'authorized-user', () ->
    setAcceptStatus()
)

controllers.controller('genericModalCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

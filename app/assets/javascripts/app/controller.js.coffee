controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User) ->
  User.isAuthorized()
)

controllers.controller('createCodeReviewCtrl', ($scope, $rootScope, $modalInstance, $modal, ReviewRequest) ->
  setAcceptStatus = () ->
    $scope.accepted = ReviewRequest.accepted
  setAcceptStatus()

  $scope.codeReview = {}

  $scope.createReviewRequest = () ->
    ReviewRequest.create($scope.codeReview).then (someVal) ->
      setAcceptStatus()
      console.log "accepted", $scope.accepted

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

controllers.controller('offerAcceptanceCtrl', ($scope, $modal, Offer) ->
  # this is buggy, it shows the buttons after page refresh even if all the offers have a state
  $scope.offer_status = null
  $scope.registerDecision = (offerId, decision) ->
    args = 
      offerId: offerId 
      decision: decision
    Offer.registerDecision(args).then () ->
      $scope.offer_status = Offer.state
)

controllers.controller('genericModalCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

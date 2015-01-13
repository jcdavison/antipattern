controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User) ->
  User.isAuthorized()
)

controllers.controller('requestCodeReview', ($scope, $rootScope, $modal, User) ->
  User.isAuthorized()
  $scope.reviewRequest = {}
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

controllers.controller('offerCodeReviewCtrl', ($scope, $modalInstance, reviewRequestId, Offer) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');

  setDisplayStatus = () ->
    $scope.display_status = Offer.display_status
  setDisplayStatus()

  $scope.offerCodeReview = () ->
    Offer.submit(reviewRequestId).then (r) ->
      setDisplayStatus()
)

controllers.controller('genericModalCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User) ->
  User.isAuthorized()
  $scope.open = (modalPurpose) ->
    if $rootScope.authorizedUser == true
      if modalPurpose == 'submitOffer'
        modalInstance = $modal.open(
          templateUrl: 'ng-views/submit_offer_modal.html'
          controller: 'offerCodeReviewCtrl'
        )
    else
      modalInstance = $modal.open(
        templateUrl: 'ng-views/please_login_modal.html'
        controller: 'genericModalCtrl'
      )
)

controllers.controller('offerCodeReviewCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

controllers.controller('genericModalCtrl', ($scope, $modalInstance) ->
  $scope.doStuff = () ->
    console.log 'stuff in modal done'

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

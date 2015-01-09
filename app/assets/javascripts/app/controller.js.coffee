controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User) ->
  User.isAuthorized()
  $scope.open = (modalPurpose) ->
    if $rootScope.authorizedUser == true
      if modalPurpose == 'submitOffer'
        modalInstance = $modal.open(
          templateUrl: 'submitOffer.html'
          controller: 'offerCodeReviewCtrl'
        )
    else
      modalInstance = $modal.open(
        templateUrl: 'pleaseLogin.html'
        controller: 'genericModalCtrl'
      )
)

controllers.controller('offerCodeReviewCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

controllers.controller('genericModalCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

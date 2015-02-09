var directives = angular.module('App.directives', [])

directives.directive('ngFocus', [function() {
  var FOCUS_CLASS = "ng-focused";
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, element, attrs, ctrl) {
      ctrl.$focused = false;
      element.bind('focus', function(evt) {
        element.addClass(FOCUS_CLASS);
        scope.$apply(function() {ctrl.$focused = true;});
      }).bind('blur', function(evt) {
        element.removeClass(FOCUS_CLASS);
        scope.$apply(function() {ctrl.$focused = false;});
      });
    }
  }
}]);

directives.directive('showifowner', [ 'ReviewRequest', function(ReviewRequest) {
  return {
    restrict: 'A',
    scope: {
      showifowner: '@',
      displaySetting: '='
    },
    link: function (scope, element, attrs) {
      ReviewRequest.ownedByCurrentUser(scope.showifowner).then( function (response) { 
        if (response.owned_by == true) {
          scope.$parent.shouldHideEdit = false
        }
      });
    }
  }
}]);

directives.directive('hideifowner', [ 'ReviewRequest', function(ReviewRequest) {
  return {
    restrict: 'A',
    scope: {
      hideifowner: '@'
    },
    link: function (scope, element, attrs) {
      ReviewRequest.ownedByCurrentUser(scope.hideifowner).then( function (response) { 
        if (response.owned_by == true) {
          element.hide();
        }
      });
    }
  }
}]);

directives.directive('hideifoffered', [ 'ReviewRequest', function(ReviewRequest) {
  return {
    restrict: 'A',
    scope: {
      reviewid: '@'
    },
    link: function ($scope, element, $attrs) {
      // this feels very redundant but i'm going with it for now
      ReviewRequest.userHasOffered($scope.reviewid).then( function (response) { 
        if(response.data.has_offered == true) {
          element.hide();
        }
      });
      $scope.$on('offer-success', function () {
        ReviewRequest.userHasOffered($scope.reviewid).then( function (response) { 
          if(response.data.has_offered == true) {
            element.hide();
          }
        });
      });
    }
  }
}]);

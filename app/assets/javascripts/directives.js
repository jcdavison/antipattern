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

directives.directive('setReviewRequestId', [function() {
    return {
      scope : {
          reviewRequestId : '@reviewRequestId',
      },
      controller: function($scope, $element, $attrs){
          $scope.reviewRequestId = $attrs.reviewRequestId
      }
    }
}]);

directives.directive('setReviewRequestDetailHtml', [function() {
    return {
      scope : {
          reviewRequestDetailHtml : '@reviewRequestDetailHtml',
      },
      controller: function($scope, $element, $attrs){
          $scope.reviewRequestDetailHtml = $attrs.reviewRequestDetailHtml
      }
    }
}]);


directives.directive('setReviewRequestDetailRaw', [function() {
    return {
      scope : {
          reviewRequestDetailRaw : '@reviewRequestDetailRaw',
      },
      controller: function($scope, $element, $attrs){
          $scope.reviewRequestDetailRaw = $attrs.reviewRequestDetailRaw
      }
    }
}]);

directives.directive('setReviewRequestValue', [function() {
    return {
      scope : {
          reviewRequestValue : '@reviewRequestValue',
      },
      controller: function($scope, $element, $attrs){
          $scope.reviewRequestValue = $attrs.reviewRequestValue
      }
    }
}]);

directives.directive('setReviewRequestTitle', [function() {
    return {
      scope : {
          reviewRequestTitle : '@reviewRequestTitle',
      },
      controller: function($scope, $element, $attrs){
          $scope.reviewRequestTitle = $attrs.reviewRequestTitle
      }
    }
}]);
directives.directive('setOfferId', [function() {
    return {
      scope : {
          offerId : '@offerId',
      },
      controller: function($scope, $element, $attrs){
          $scope.offerId = $attrs.offerId
      }
    }
}]);

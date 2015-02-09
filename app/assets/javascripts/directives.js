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
  var IS_OWNER = false
  return {
    restrict: 'A',
    scope: {
      showifowner: '@'
    },
    link: function (scope, element, attrs) {
      ReviewRequest.ownedByCurrentUser(scope.showifowner).then( function (response) { 
        if (response.owned_by == true) {
          element.show();
        }
      });
    }
  }
}]);

directives.directive('hideifowner', [ 'ReviewRequest', function(ReviewRequest) {
  var IS_OWNER = false
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

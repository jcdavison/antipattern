controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, User) ->
  $rootScope.authorizedUser = false
  User.isAuthorized().then () ->
    $rootScope.authorizedUser = true
)

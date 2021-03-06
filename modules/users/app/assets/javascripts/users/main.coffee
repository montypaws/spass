'use strict'

define(['angular'], (angular) ->

  users = angular.module('users', ['ngResource', 'ngRoute'])

  users.config [
    '$routeProvider',
    ($routeProvider) ->
      $routeProvider.when '/home',
        templateUrl: 'users/vassets/partials/home.tpl.html'
      $routeProvider.when '/login',
        templateUrl: 'users/vassets/partials/login.tpl.html'
      #$routeProvider.when '/logout',
      #  resolve:
      $routeProvider.when '/signup',
        templateUrl: 'users/vassets/partials/signup-start.tpl.html'
      $routeProvider.when '/signup/:token',
        templateUrl: 'users/vassets/partials/signup.tpl.html'
      $routeProvider.when '/reset',
        templateUrl: 'users/vassets/partials/reset-start.tpl.html'
      $routeProvider.when '/reset/:token',
        templateUrl: 'users/vassets/partials/reset.tpl.html'
      $routeProvider.when '/password',
        templateUrl: 'users/vassets/partials/password.tpl.html'
      $routeProvider.otherwise
        redirectTo: '/home'
  ]

  users.factory 'navigation',
    ($resource) ->
      $resource('users/navigation')

  users.factory 'home',
    ($resource) ->
      $resource('users/home')

  users.factory 'logout',
    ($location, $resource) ->
      $resource('users/logout')
      $location.path("login")

  users.controller 'SignUpController',
    class SignUpController
      constructor: ($scope, $http, $location, $routeParams) ->
        $scope.form = {} if $scope.form is undefined

        $scope.generateName = ->
          $http.get('users/generate-name')
          .success (response) ->
              $scope.form.firstName = response.firstName
              $scope.form.lastName = response.lastName

        $scope.getEmail = ->
          $http.get('users/email/' + $routeParams.token)
          .success (response) ->
              $scope.form.email = response.email
              $location.path("login") if response.email = null

        $scope.sendEmail = ->
          $http.post('users/signup', $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

        $scope.signUp = ->
          $http.post('users/signup/' + $routeParams.token, $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

              if (response["password"])
                $scope.form.errors["password.password2"] = response["password"]

  users.controller 'LoginController',
    class LoginController
      constructor: ($scope, $http, $location) ->
        $scope.form = {} if $scope.form is undefined

        $scope.login = ->
          $http.post('users/authenticate/userpass', $scope.form)
          .success () ->
              $location.path("home")
          .error (response) ->
              $scope.form.errors = response

  users.controller 'PasswordController',
    class PasswordController
      constructor: ($scope, $http, $location, $routeParams) ->
        $scope.form = {} if $scope.form is undefined

        $scope.sendEmail = ->
          $http.post('users/reset', $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

        $scope.reset = ->
          $http.post('users/reset/' + $routeParams.token, $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

              if (response["password"])
                $scope.form.errors["password.password2"] = response["password"]

        $scope.change = ->
          $http.post('users/password')
          .success () ->
              $location.path("home")
          .error (response) ->
              $scope.form.errors = response

              if (response["password"])
                $scope.form.errors["password.password2"] = response["password"]
)

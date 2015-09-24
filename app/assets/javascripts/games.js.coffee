# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.websocket = new Faye.Client('/faye')

jQuery ->
  websocket.subscribe '/movements', (payload) ->
    console.log 'payload', payload
    if payload.action == 'new-game'
      console.log('New Game')
      # Create a new dashboard in blank
      $('.coin').removeClass('blue')
      $('.coin').removeClass('red')
      $('.coin').addClass('blank')
    else if payload.action == 'movement'
      $('#r' + payload.row + ' .c' + payload.col + ' .coin').removeClass('blue')
      $('#r' + payload.row + ' .c' + payload.col + ' .coin').removeClass('red')
      $('#r' + payload.row + ' .c' + payload.col + ' .coin').removeClass('blank')
      console.log '#r' + payload.row + ' .c' + payload.col + ' .coin'
      $('#r' + payload.row + ' .c' + payload.col + ' .coin').addClass(payload.color)
    else if payload.action == 'win'
      alert(payload.message)

window.angularApp = angular.module('AngularAPP', [])
angularApp.controller('BoardController', ['$scope', ($scope)->

  $scope.new_game = ->

    $.ajax('/games/new_game', {method: 'POST'})
    return true

  $scope.move = ($event)->
    target = $event.currentTarget
    console.log $(target).attr('col')
    $.ajax('/games/move', method: 'POST', data: {
      user: window.current_user,
      col: $(target).attr('col')
    })
    return true
])
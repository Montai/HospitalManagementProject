# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
  jQuery(function() {
    return $("a.fancybox").fancybox({
      'transitionIn': 'elastic',
      'transitionOut': 'elastic',
      'speedIn': 600,
      'speedOut': 200,
      'overlayShow': false
    });
  });
});

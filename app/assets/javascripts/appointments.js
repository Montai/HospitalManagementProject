# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
  $(document).on('turbolinks:load', function() {
  	var loading_posts = false;
  	return $('a.load-more-appointments').on('inview', function(e, visible) {
  	  if (loading_posts || !visible) {
  	  	return
  	  }
  	  loading_posts = true;
  	  return $.getScript($(this).attr('href'),function() {
  	  	return loading_posts = false;
  	  });
  	});
  });
});

$(document).ready(function() {
  $(document).on('turbolinks:load', function() {
  	var loading_posts = false; //Set initial value to false
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

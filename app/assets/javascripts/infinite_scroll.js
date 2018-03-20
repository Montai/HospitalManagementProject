$(document).on('ready page:load', function() {
  var isLoading = false;
  if ($("#infinite_scrolling").size() > 0) {
    $(window).on('scroll', function() {
      var more_posts_url = $('.pagination a.next_page').attr('href');
      if (!isLoading && more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 250) {
        isLoading = true;
        $.getScript(more_posts_url).done(function(data, textStatus, jqxhr) {
          isLoading = false;
        }).fail(function() {
          isLoading = false;
        });
      }
    });
  }
});

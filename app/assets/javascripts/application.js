// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
// function get_radio_value() {
// 	var radioValue = $("#radio_buttons:checked").val();
// 		$.ajax({
// 			url: "/appointments",
// 			type: "POST",
// 			data: { start_time: radioValue },
// 			cache: false,
// 			success: function(data) {
// 				alert(data + 'sent');
// 			},
// 			error: function(xhr, ajaxOptions, thrownError) {},
// 			timeout: 15000
// 		});
// 	}
	// $.(function() {
 //      $("#radio_buttons").click(function() {
 //        var radioValue = $("#radio_buttons:checked").val();
 //        return true;
 //      });
 //    });
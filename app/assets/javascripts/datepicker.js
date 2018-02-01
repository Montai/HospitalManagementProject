// $("#date_button").hide();
// $("#mydate").remove();

	// appointment = params[:appointment]
	// curr_date = Date.new(appointment["date(1i)"].to_i, appointment["date(2i)"].to_i, appointment["date(3i)"].to_i)
// $("date_button").on("click", function() {
// 	var d = document.getElementById("appointment_date_1i");
// 	var dstr = d.options[d.selectedIndex].value;

// 	var m = document.getElementById("appointment_date_2i");
// 	var mstr = m.options[m.selectedIndex].value;

// 	var y = document.getElementById("appointment_date_3i");
// 	var ystr = y.options[y.selectedIndex].value;
	
// 	var date_val = y + "-" + m + "-" + d;

// 	$.ajax({
// 		url: "appointments"
// 		type: "POST",
// 		cache: false,
// 		data: { my_date: date_val },
// 		success: function(data) {
// 			console.log("success");
// 		},
// 		error: function(xhr, ajaxOptions, thrownError) {},
// 		timeout: 15000
// 	});
// });
$(document).ready(function(){
	$('#get_timeslots').on('click', function(){
		var date = $('#appointment_date_1i').val() + '-' + $('#appointment_date_2i').val() + '-' + $('#appointment_date_3i').val();
		$.ajax({
			url: '/appointments/available_slots',
			data: {selected_date: date},
			success: function(data){
				console.log('fetched!');
			}
		})
	})
})
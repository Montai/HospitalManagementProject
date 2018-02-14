$(document).ready(function(){
	
		// $("#get_timeslots").hide();
		var date = $('#appointment_date_1i').val() + '-' + $('#appointment_date_2i').val() + '-' + $('#appointment_date_3i').val();
		var today = new Date();

		var d = $('#appointment_date_3i').val();
		var dd = today.getDate();

		var m = $('#appointment_date_2i').val()-1;
		var mm = today.getMonth(); 

		if (m < mm || d <= dd) {
			alert("sorry, choose another date");
			// $("#available_slots").hide();
			$("#error-box").html('this is an error-box');
		}

		else {
			$("#available_slots").show();
			$.ajax({
			url: '/appointments/available_slots',
			data: { selected_date: date },
			success: function(data){
				console.log('fetched!');
				console.log(date);

			}
		    })
		}

})
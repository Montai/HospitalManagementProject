 $(document).ready(function(){
  
//    // $("#get_timeslots").hide();
//    var date = $('#appointment_date_1i').val() + '-' + $('#appointment_date_2i').val() + '-' + $('#appointment_date_3i').val();
//    var today = new Date();

//    var d = $('#appointment_date_3i').val();
//    var dd = today.getDate();

//    var m = $('#appointment_date_2i').val()-1;
//    var mm = today.getMonth(); 

//    if (m < mm || d <= dd) {
//      alert("sorry, choose another date");
//      $("#error-box").html('this is an error-box');
//    }

//    else {
//      $("#available_slots").show();
//      $.ajax({
//      url: '/appointments/available_slots',
//      data: { selected_date: date },
//      success: function(data){
//        console.log('fetched!');
//        console.log(date);

//      }
//        })
//    }

  $(".check-slot").children().hide();

  $('body').on('change', '.date-picker', function(){
    var link = $("#get_timeslots").prop("href");
    var doctor = $("#appointment_doctor_id").val();
    var date = $(".date-picker").val();
    $("#get_timeslots").prop("href", link.split('?')[0] + "?query=" + date + "&doctor=" + doctor);
    $("#get_timeslots").trigger("click");
  });

  function tomorrowDate(){
    var date = new Date();
    date.setDate(date.getDate() + 1);

    var mm = (date.getMonth() < 12 ? date.getMonth() + 1 : 1);
    mm = mm.toString().length > 1 ? mm : (0 + mm.toString()); 
    var dd = date.getDate();
    var yyyy = date.getFullYear();
    return yyyy + "-" + mm + "-" + dd;
  }

  $('body').on('change', '#appointment_doctor_id', function(){
    $("#appointment_date").val(tomorrowDate());
    $(".check-slot").children().hide();
    $(".available-slots").text("");
  });

})
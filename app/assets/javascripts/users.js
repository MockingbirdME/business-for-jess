$('document').ready( function(){

  $('#show_future_appointments').click(function(){

    var show_future_appointments_btn = document.getElementById('show_future_appointments');
    var hide_future_appointments_btn = document.getElementById('hide_future_appointments');
    var future_appointments_display_div = document.getElementById('future_appointments_display');
      future_appointments_display_div.style.display='block';
      show_future_appointments_btn.style.display='none';
      hide_future_appointments_btn.style.display='block';
    return true;
  });

  $('#show_past_appointments').click(function(){

    var show_past_appointments_btn = document.getElementById('show_past_appointments');
    var hide_past_appointments_btn = document.getElementById('hide_past_appointments');
    var past_appointments_display_div = document.getElementById('past_appointments_display');
      past_appointments_display_div.style.display='block';
      show_past_appointments_btn.style.display='none';
      hide_past_appointments_btn.style.display='block';
    return true;
  });

  $('#show_messages').click(function(){

    var show_messages_btn = document.getElementById('show_messages');
    var hide_messages_btn = document.getElementById('hide_messages');
    var messages_display_div = document.getElementById('messages_display');
      messages_display_div.style.display='block';
      show_messages_btn.style.display='none';
      hide_messages_btn.style.display='block';
    return true;
  });

  $('#hide_future_appointments').click(function(){

    var show_future_appointments_btn = document.getElementById('show_future_appointments');
    var hide_future_appointments_btn = document.getElementById('hide_future_appointments');
    var future_appointments_display_div = document.getElementById('future_appointments_display');
      future_appointments_display_div.style.display='none';
      show_future_appointments_btn.style.display='block';
      hide_future_appointments_btn.style.display='none';
    return true;
  });

  $('#hide_past_appointments').click(function(){

    var show_past_appointments_btn = document.getElementById('show_past_appointments');
    var hide_past_appointments_btn = document.getElementById('hide_past_appointments');
    var past_appointments_display_div = document.getElementById('past_appointments_display');
      past_appointments_display_div.style.display='none';
      show_past_appointments_btn.style.display='block';
      hide_past_appointments_btn.style.display='none';
    return true;
  });

  $('#hide_messages').click(function(){

    var show_messages_btn = document.getElementById('show_messages');
    var hide_messages_btn = document.getElementById('hide_messages');
    var messages_display_div = document.getElementById('messages_display');
      messages_display_div.style.display='none';
      show_messages_btn.style.display='block';
      hide_messages_btn.style.display='none';
    return true;
  });
});

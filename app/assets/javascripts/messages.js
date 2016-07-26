$('document').ready( function(){
console.log("++++++++++++++++++++messages++++++++++++++++++++++++++++");

  $('#my_select').on('change', function(){
console.log("++++++++++++++++++++++messages#change++++++++++++++++++++++++++");
    var name_div = document.getElementById('name_input');
    var email_div = document.getElementById('email_input');
    var phone_div = document.getElementById('phone_input');
    if (this.value == 'none_required') {
      name_div.style.display='none';
      email_div.style.display='none';
      phone_div.style.display='none';
    } else if (this.value == 'email') {
      email_div.style.display='block';
      name_div.style.display='block';
      phone_div.style.display='none';
    } else {
      phone_div.style.display='block';
      name_div.style.display='block';
      email_div.style.display='none';
    }
    return true;
  });
});

window.onload = function(){



  var select_box = document.getElementById('my_select');
  var name_div = document.getElementById('name_input');
  var email_div = document.getElementById('email_input');
  var phone_div = document.getElementById('phone_input');
console.log("++++++++++++++++++++messages++++++++++++++++++++++++++++");
console.log(select_box);
  select_box.addEventListener('change', function(){
console.log("++++++++++++++++++++++messages++++++++++++++++++++++++++");
    var select_value = 9;
    var select_value = select_box.value;
console.log(select_value);
    if (select_value == 'none_required') {
      name_div.style.display='none';
      email_div.style.display='none';
      phone_div.style.display='none';
    } else if (select_value == 'email') {
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
}

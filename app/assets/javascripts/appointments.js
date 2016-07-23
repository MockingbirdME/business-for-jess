$('document').ready( function(){
console.log("++++++++++++++++++++appointments++++++++++++++++++++++++++++");

  var appointment_select_box = document.getElementById('appointment_type_select');
  if (appointment_select_box) {
console.log(appointment_select_box);
    appointment_select_box.addEventListener('change', function(){
console.log("+++++++++++++++++++++appointments#change+++++++++++++++++++++++++++");
    var dog_walking_options_div = document.getElementById('dog_walking_options');
    var small_animal_hotel_options_div = document.getElementById('small_animal_hotel_options');
    var in_home_animal_care_options_div = document.getElementById('in_home_animal_care_options');
    var select_value = 9;
    select_value = appointment_select_box.value;
console.log(select_value);
    if (select_value == 'dog_walking') {
      dog_walking_options_div.style.display='block';
      small_animal_hotel_options_div.style.display='none';
      in_home_animal_care_options_div.style.display='none';
    } else if (select_value == 'small_animal_hotel') {
      dog_walking_options_div.style.display='none';
      small_animal_hotel_options_div.style.display='block';
      in_home_animal_care_options_div.style.display='none';
    } else {
      dog_walking_options_div.style.display='none';
      small_animal_hotel_options_div.style.display='none';
      in_home_animal_care_options_div.style.display='block';
    }
    return true;
  });
}
});

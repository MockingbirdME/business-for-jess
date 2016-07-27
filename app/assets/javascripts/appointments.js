
$('document').ready( function(){
console.log("++++++++++++++++++++appointments++++++++++++++++++++++++++++");

  $('#appointment_form_selector').on('change', function(){
console.log("+++++++++++++++++++++appointments#change+++++++++++++++++++++++++++");
    var dog_walking_form_div = document.getElementById('dog_walking_form');
    var small_animal_hotel_form_div = document.getElementById('animal_hotel_form');
    var in_home_animal_care_form_div = document.getElementById('in_home_form');

    if (this.value == 'dog_walking') {
      dog_walking_form_div.style.display='block';
      small_animal_hotel_form_div.style.display='none';
      in_home_animal_care_form_div.style.display='none';
    } else if (this.value == 'small_animal_hotel') {
      dog_walking_form_div.style.display='none';
      small_animal_hotel_form_div.style.display='block';
      in_home_animal_care_form_div.style.display='none';
    } else {
      dog_walking_form_div.style.display='none';
      small_animal_hotel_form_div.style.display='none';
      in_home_animal_care_form_div.style.display='block';    }
    return true;
  });
});

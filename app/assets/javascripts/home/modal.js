//js to activate the sign up login modal here!!
$(function(){

  $('#lgn').on('click', function(){
    $('.modal-container').removeClass('hidden');
  });

  $('.close').on('click', function(){
    $('.modal-container').addClass('hidden');
  });
});

var Mask_Input = function() {
$(document).on('turbolinks:load', function() {
  $('.mask_phone').inputmask({mask: "(999) 999-9999"});
});
};

document.addEventListener('turbolinks:load', function () {
  Mask_Input();
});

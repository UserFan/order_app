// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap
//= require jquery
//= require rails-ujs
//= require moment
//= require moment/ru
//= require bootstrap-datetimepicker
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.numeric.extensions
//= require jquery.inputmask.date.extensions
//= require jquery.inputmask.phone.extensions
//= require turbolinks
//= require cocoon
//= require_tree .



var ClickRowTable = function() {
  $(".table-row td").click(function() {
   if (!$(this).hasClass("row-skip")) {
       window.document.location = $(this).parent().data("href")
    }
  });
};

var date_pic = function () {
  $('.datepicker').datetimepicker();
  $('form').on('cocoon:after-insert', function() { $('.datepicker').datetimepicker() });
};


var Mask_Input = function() {
  $('.phone').inputmask({mask: "+9 (999) 999-99-99"});
  $('.ip_computer').inputmask({'alias': 'ip', 'greedy' : false });
  $('.ip_cash').inputmask({'alias': 'ip', 'greedy' : false });
  $('.macaddress').inputmask({mask: "**:**:**:**:**:**"});
  $('.team').inputmask({mask: "999-999-999"});
  $('.date_start_esp').inputmask({mask: "99.99.9999"});
  $('.date_end_esp').inputmask({mask: "99.99.9999"});
  $('.date_start_rsa').inputmask({mask: "99.99.9999"});
  $('.date_end_rsa').inputmask({mask: "99.99.9999"});
  $('#computers').on('cocoon:after-insert', function() { $('.ip_computer').inputmask({'alias': 'ip', 'greedy' : false }) });
  $('#computers').on('cocoon:after-insert', function() { $('.ip_cash').inputmask({'alias': 'ip', 'greedy' : false }) });
  $('#computers').on('cocoon:after-insert', function() { $('.team').inputmask("999-999-999") });
};


document.addEventListener('turbolinks:load', function () {
  date_pic();
});

document.addEventListener('turbolinks:load', function () {
  ClickRowTable();
});

document.addEventListener('turbolinks:load', function () {
  Mask_Input();
});

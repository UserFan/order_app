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
//= require jquery.raty
//= require ratyrate
//= require moment
//= require moment/ru
//= require bootstrap-datetimepicker
//= require bootstrap.file-input
//= require inputmask
//= require jquery.inputmask
//= require inputmask.extensions
//= require inputmask.numeric.extensions
//= require inputmask.date.extensions
//= require inputmask.phone.extensions
//= require cocoon
//= require turbolinks
//= require_tree .

var ClickRowTable = function() {
  $(".table-row td").click(function() {
   if (!$(this).hasClass("row-skip")) {
       window.document.location = $(this).parent().data("href")
    }
  });
};

var date_pic = function () {
  name_selector = '#date_start_esp, #date_end_esp, #date_start_rsa,' +
                  '#date_end_rsa, #date_open_order, #date_execution,' +
                  '#date_close_order, #date_close_shop, #date_image_cash,' +
                  '#date_service, #date_performance, #date_cost,' +
                  '#date_recruitment, #date_quit, #work_start_date,' +
                  '#work_end_date, #performer_deadline, #task_performer_deadline,' +
                  '#date_open_task, #date_execution_task, #date_close_task,' +
                  '#update_traffic, #date_report'
  $(name_selector).datetimepicker();
  $('form').on('cocoon:after-insert', function() { $(name_selector).datetimepicker() });
};

var Mask_Input = function() {
  $('.phone').inputmask({mask: "+9 (999) 999-99-99"});
  $('.ip_computer').inputmask({'alias': 'ip', 'greedy' : false });
  $('.ip_cash').inputmask({'alias': 'ip', 'greedy' : false });
  $('.ip_weigher').inputmask({'alias': 'ip', 'greedy' : false });
  $('.macaddress').inputmask({mask: "**:**:**:**:**:**"});
  $('.team').inputmask({'alias': 'integer', 'integerDigits' : 12,
                                            'autoGroup' : true,
                                            'groupSeparator' : " ",
                                            'groupSize' : 3 });

  $('.date_mask').inputmask({mask: "99.99.9999"});
  $('.month_mask').inputmask({mask: "99.9999"});
  $('#computers').on('cocoon:after-insert', function() { $('.ip_computer').inputmask({'alias': 'ip', 'greedy' : false }) });
  $('#cashboxes').on('cocoon:after-insert', function() { $('.ip_cash').inputmask({'alias': 'ip', 'greedy' : false }) });
  $('#weigher').on('cocoon:after-insert', function() { $('.ip_weigher').inputmask({'alias': 'ip', 'greedy' : false }) });
  $('#computers').on('cocoon:after-insert', function() { $('.team').inputmask({'alias': 'integer', 'integerDigits' : 12,
                                                                                                   'autoGroup' : true,
                                                                                                   'groupSeparator' : " ",
                                                                                                   'groupSize' : 3}) });
                                                          $('input[type=file]').bootstrapFileInput();
  $('form').on('cocoon:after-insert', function(e, add_image) { add_image.find('input[type=file]').bootstrapFileInput() });
};

document.addEventListener('turbolinks:load', function () {
  date_pic();
  ClickRowTable();
  Mask_Input();
});

// document.addEventListener('turbolinks:load', function () {
//   ClickRowTable();
// });
//
// document.addEventListener('turbolinks:load', function () {
//   Mask_Input();
// });

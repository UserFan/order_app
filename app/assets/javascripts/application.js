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

//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets
//= require moment
//= require moment/ru
//= require bootstrap-datetimepicker
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

var date_pic = function () { $('.datepicker').datetimepicker();

$('.nested-fields').on('cocoon:after-insert', function() {
  $('.datepicker').datetimepicker() });

};


document.addEventListener('turbolinks:load', function () {
        date_pic();
});



document.addEventListener('turbolinks:load', function () {
  ClickRowTable();
});

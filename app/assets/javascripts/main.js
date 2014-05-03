function load() {
   $(window).scroll(function () {
      if ($(this).scrollTop() > 50) {
          $('#back-to-top').fadeIn();
      } else {
          $('#back-to-top').fadeOut();
      }
  });
  // scroll body to 0px on click
  $('#back-to-top').click(function () {
      $('#back-to-top').tooltip('hide');
      $('body,html').animate({
          scrollTop: 0
      }, 800);
      return false;
  });
  $('#back-to-top').tooltip('show');

  $("#report_body").markdown();

  bindLiveLinks();
//  bindCharCounter();
  bindMonthSelector();
  du = new dropupload();
  du.init();
  bindPictureForm(du);
}

function bindPictureForm(du) {
  $('form#new_picture a.submit').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).button('loading');

    var $that = $(this),
        url   = $that.attr('href'),
        data  = new FormData();
    data.append("picture[file]", du.picture());
    data.append("picture[description]", $('#picture_description').val());

    $.ajax({
      url: url,
      type: 'post',
      data: data,
      headers: {
        "X-CSRF-Token": $("meta[name=csrf-token]").attr('content')
      },
      dataType: 'json',
      processData: false,
      contentType: false,
      success: function(data, textstatus, xhrreq){
        if (xhrreq.getAllResponseHeaders().match(/Content-Type: text\/html/)){
          alert('error', "You need to login first. Reload the page.");
          return;
        }
        if(data.status == 'ok'){
          alert('success', data.message);
          du.clean();
          $('#picture_description').val('');
        } else {
          alert('warning', data.message);
        }
        $that.button('reset');
      },
      fail: function(xhr) {
        $that.button('reset');
        alert('danger', "Somthing went wrong");
      },
    })
  });
}

function bindMonthSelector() {
  var picker = $("#datepicker").datepicker({
    format: "mm-yyyy",
    viewMode: "months",
    minViewMode: "months"
  }).on('changeDate', function(ev) {
    window.location = picker.data('on-change-url') + '?date=' + (ev.date.getMonth()+1) + "-" + ev.date.getFullYear();
  });
}

function showFlashs() {
  $(".alert").alert();
}

function alert(type, message) {
  $('#messages').html("<div class='alert alert-" + type + "'><a class='close' data-dismiss='alert'>×</a><span>" + message + "</span></div>");
}


function bindCharCounter() {
  $(".counted").charCounter(parseInt($("#counter").data('default')),{container: "#counter"});
}

function bindLiveLinks() {
  $('.report a.love').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).button('loading');

    var $that = $(this),
        url   = $that.data("url");

    $.ajax({
      url: url,
      type: 'post',
      headers: {
        "X-CSRF-Token": $("meta[name=csrf-token]").attr('content')
      },
      dataType: 'json',
      success: function(data, textstatus, xhrreq){
        if (xhrreq.getAllResponseHeaders().match(/Content-Type: text\/html/)){
          alert('error', "You need to login first. Reload the page.");
          return;
        }
        if(data.status == 'ok'){
          if ($that.hasClass('btn-danger')) {
            $that.removeClass('btn-danger');
          } else {
            $that.addClass('btn-danger');
            $that.siblings().each(function() {
              $(this).removeClass('btn-danger').addClass('btn-default');
            });
          }
          alert('success', data.message);
        } else {
          alert('warning', data.message);
        }
        $that.button('reset')
      },
      fail: function(xhr) {
        $that.button('reset')
        alert('danger', "Somthing went wrong");
      },
    })
  });
}

$(function () {
  load();
});

$(document).on('page:load',function () {
  load();
});


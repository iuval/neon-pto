$(function () {
  load();
});

$(document).on('page:load',function () {
  load();
});

function load() {
  bindLiveLinks();
  showLoveBars();
  bindCharCounter();
  bindMonthSelector();
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

function showLoveBars() {
  var scale = 100 / parseInt($('.rated_reports').data('total-love'))
  $(".love_bar").each(function(index, v) {
    $(v).progressbar({
      value: parseInt($(v).data('love')) * scale
    });
  });
}

function bindLiveLinks() {
  $('.reports a.love').click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    var $that = $(this),
        url   = $that.data("url");

    $that.addClass("waiting");

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
          var love_span = $that.children('.love'),
              love = parseInt(love_span .text());
          if ($that.hasClass('btn-danger')) {
            love_span.text(love - 1);
            $that.removeClass('btn-danger');
          } else {
            love_span.text(love + 1);
            $that.addClass('btn-danger');
          }
          alert('success', data.message);
        } else {
          alert('warning', data.message);
        }
        $that.removeClass("waiting");
      },
      fail: function(xhr) {
        $that.removeClass("waiting");
        alert('danger', "Somthing went wrong");
      },
    })
  });
}

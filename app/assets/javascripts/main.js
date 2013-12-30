$(function() {
  bindLiveLinks();

  $(".counted").charCounter(parseInt($("#counter").data('default')),{container: "#counter"});
});

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
          $.jGrowl("You need to login first. Reload the page.", { theme: 'alert' });
          return;
        }
        if(data.status == 'ok'){
          $that.toggleClass('btn-danger');
          $.jGrowl(data.message, { theme: 'success' });
        } else {
          $.jGrowl(data.message, { theme: 'alert' });
        }
        $that.removeClass("waiting");
      },
      fail: function(xhr) {
        $that.removeClass("waiting");
        $.jGrowl("Somthing went wrong", { theme: 'alert' });
      },
    })
  });
}

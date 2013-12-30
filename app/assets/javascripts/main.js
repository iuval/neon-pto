$(function() {
  bindLiveLinks();
//  $(".counted").charCounter(270,{container: "#counter"});
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
          return;
        }

        $that.toggleClass('btn-danger');
        $that.removeClass("waiting");
      },
      fail: function(xhr) {
        $that.removeClass("waiting");
      },
    })
  });
}

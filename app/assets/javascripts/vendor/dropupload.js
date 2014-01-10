function dropupload() {
  var reader;
  var picture;

  this.init = function() {
    $('#browse-file').click(function() {
      $('input.file').click();
    });

    $("input.file").change(function(evt){
      var file = evt.target.files[0];
      handleFileSelect(file);
    });

      // Check for the various File API support.
    if (window.File && window.FileReader && window.FileList && window.Blob) {
      reader = new FileReader();

      reader.onloadend = function(evt) {
        if (evt.target.readyState == FileReader.DONE) {
          var image = new Image();
          image.src = evt.target.result;
          $('.preview').empty().append(image);
          $('input.file').value = evt.target.result;
        }
      };

      $('.drop_zone').on("dragover", function(evt) {
        $('#drag-overlay').removeClass("dragleave").addClass("dragover");
      });

      $('#drag-overlay').on("dragover", function(evt) {
        evt.stopPropagation();
        evt.preventDefault();
        evt.originalEvent.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
      });

      $('#drag-overlay').on("dragleave", function(evt) {
        $('#drag-overlay').removeClass("dragover").addClass("dragleave");
      });

      $('#drag-overlay').on("drop", function(evt) {
        evt.stopPropagation();
        evt.preventDefault();

        var file = evt.originalEvent.dataTransfer.files[0];
        handleFileSelect(file);

        $('#drag-overlay').removeClass("dragover").addClass("dragleave");
      });
    } else {
      console.log('The File APIs are not fully supported in this browser.');
    }
  }

  this.clean = function() {
    picture = null;
    $('.preview').empty();
  };

  this.picture = function() {
    return picture;
  };

  function handleFileSelect(file) {
    if(reader && file){
      reader.readAsDataURL(file);
      picture = file;
    }
  }
};

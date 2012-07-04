(function (win, $) {

  'use strict';

  win.Courseware = {
    run: function() {
      /**
       * Hide alert boxes on clicks
       */
      $(".alert-box").delegate("a.close", "click", function(event) {
        event.preventDefault();
        $(this).closest(".alert-box").fadeOut(function(event){
          $(this).remove();
        });
      });

      /**
       * Enable placeholder plugin
       */
      $('input, textarea').placeholder();
    }
  };

  $(document).ready(Courseware.run);

}(window, window.jQuery));

(function (win, $) {

  'use strict';

  win.Courseware = {
    /**
     * Enables dropdown buttons
     */
    enableDropdownButtons: function() {
      $('.button.dropdown > ul').addClass('no-hover');

      $('.button.dropdown').on('click.fndtn touchstart.fndtn', function (e) {
        e.stopPropagation();
      });

      $('.button.dropdown.split span').on(
        'click.fndtn touchstart.fndtn',
        function (e) {
          e.preventDefault();
          $('.button.dropdown').not($(this).parent()).children('ul').removeClass('show-dropdown');
          $(this).siblings('ul').toggleClass('show-dropdown');
        }
      );

      $('.button.dropdown').not('.split').on(
        'click.fndtn touchstart.fndtn',
        function (e) {
          $('.button.dropdown').not(this).children('ul').removeClass('show-dropdown');
          $(this).children('ul').toggleClass('show-dropdown');
        }
      );

      $('body, html').on('click.fndtn touchstart.fndtn', function () {
        $('.button.dropdown ul').removeClass('show-dropdown');
      });
    },

    /**
     * Hide alert boxes on clicks
     */
    enableAlertBoxesClose: function() {
      $(".alert-box").delegate("a.close", "click", function(event) {
        event.preventDefault();
        $(this).closest(".alert-box").fadeOut(function(event){
          $(this).remove();
        });
      });
    },

    /**
     * Start Courseware plugins/modules
     */
    run: function() {
      Courseware.enableAlertBoxesClose();
      Courseware.enableDropdownButtons();
      $('input, textarea').placeholder();
    }
  };

  $(document).ready(Courseware.run);

}(window, window.jQuery));

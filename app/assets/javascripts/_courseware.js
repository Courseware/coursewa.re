( function ( win, $ ) {

  'use strict';

  var $doc = $( document );

  win.Courseware = {
    /**
     * Handles xhr "tagged" requests
     * On `trigger` clicks, element `data="parent-container-id"`
     * element will be replaced with ajax result.
     */
    enable_xhr_requests: function(selector, trigger) {
      $(selector).on('click', trigger, function(event){
        var href = $(this).attr('href'),
          target = '#' + $(this).data('parent-container-id');

        $.ajax({
          url: href,
          success: function(content) {
            $(target).replaceWith(content)
          }
        })
        return false;
      });
    },

    /**
     * Handles on lick expanding of elements
     */
    enable_on_click_expanding: function(selector, trigger) {
      $(selector).on('click', trigger, function(event){
        var $this = $(this),
          target = $this.data('expand-target'),
          toggleClass = $this.data('toggle-class');

        if ( $this.hasClass(toggleClass) ) {
          $this.parent().find(target).addClass('hide');
          $this.removeClass(toggleClass);
        } else {
          $this.parent().find(target).removeClass('hide');
          $this.addClass(toggleClass);
        }

        return false;
      });
    },

    /**
     * Handles alerts hiding after a timeout
     */
    hide_alerts_after_timeout: function(selector, timeout) {
      setTimeout( function() {
        $(selector).fadeOut( 'slow' );
      }, timeout * 1000);
    },

    /**
     * Start Courseware plugins/modules
     */
    run: function() {
      Courseware.enable_xhr_requests('#content', 'a.run-as-xhr');
      Courseware.enable_on_click_expanding('#content', 'a.expands');
      Courseware.hide_alerts_after_timeout('#notifications .alert-box', 3);

      $.fn.foundationAlerts           ? $doc.foundationAlerts() : null;
      $.fn.foundationButtons          ? $doc.foundationButtons() : null;
      $.fn.foundationAccordion        ? $doc.foundationAccordion() : null;
      $.fn.foundationNavigation       ? $doc.foundationNavigation() : null;
      $.fn.foundationTopBar           ? $doc.foundationTopBar() : null;
      $.fn.foundationCustomForms      ? $doc.foundationCustomForms() : null;
      $.fn.foundationMediaQueryViewer ? $doc.foundationMediaQueryViewer() : null;
      $.fn.foundationTabs             ? $doc.foundationTabs() : null;
      $.fn.foundationTooltips         ? $doc.foundationTooltips() : null;
      $.fn.foundationMagellan         ? $doc.foundationMagellan() : null;
      $.fn.foundationClearing         ? $doc.foundationClearing() : null;
      $.fn.placeholder                ? $( 'input, textarea' ).placeholder() : null;
    }
  };

  $doc.ready( Courseware.run );

}( window, jQuery ));

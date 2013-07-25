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
          global = $this.data('look-allover'),
          toggleClass = $this.data('toggle-class');

        if ( $this.hasClass(toggleClass) ) {
          if ( global ) {
            $(target).slideUp('slow').addClass('hide');
          } else {
            $this.parent().find(target).slideUp('slow').addClass('hide');
          }

          if ( toggleClass ) {
            $this.removeClass(toggleClass);
          }
        } else {
          if ( global ) {
            $(target).slideDown('slow').removeClass('hide');
          } else {
            $this.parent().find(target).slideDown('slow').removeClass('hide');
          }

          if ( toggleClass ) {
            $this.addClass(toggleClass);
          }
        }

        // Skip link clicking event propagation
        if ( $this.get(0).tagName === 'A' ) {
          return false;
        }
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
     * Handles survey submission
     */
    submit_survey: function(selector, modalId, timeout) {
      var $form = $( selector );
      $form.on( 'submit', function( event ) {
        event.preventDefault();

        $.ajax({
          url: $form.attr( 'action' ),
          type: $form.attr( 'method' ),
          data: {
            current_path: $form.find( 'input[name="current_path"]' ).val(),
            message: $form.find( 'textarea[name="message"]' ).val(),
            category: $form.find( 'input[name="category"]' ).filter( ':checked' ).val(),
            authenticity_token: $('meta[name="csrf-token"]').attr('content')
          },
          success: function(content) {
            $form.addClass('hide').after( '<h5>' + content + '</h5>' );
            setTimeout( function() {
              $( modalId ).trigger( 'reveal:close' );
              $form.removeClass( 'hide' ).parent().find( 'h5' ).remove();
              $form.find( 'textarea' ).val( '' );
            }, timeout * 1000 );
          }
        });
      } );
    },

    /**
     * Handle a friendly modal message if assetable object is not available yet
     */
    redactor_unsaved_modal: function( selector ) {
      var $selector = $( selector );
      if ( $selector.get(0) && ( $selector.val().length === 0 ) ) {
        // TODO: add support for a localized message
        return '<div id="redactor_modal_content">Please save this page first.' +
          '</div><div id="redactor_modal_footer">' +
          '<a href="javascript:void(null);" ' +
          ' class="redactor_modal_btn redactor_btn_modal_close">' +
          RLANG.cancel + '</a></div>';
      }
    },

    /**
     * Start Courseware plugins/modules
     */
    run: function() {
      Courseware.enable_xhr_requests('#content', 'a.run-as-xhr');
      Courseware.enable_on_click_expanding('#content', '.expands');
      Courseware.hide_alerts_after_timeout('#notifications .alert-box', 3);
      Courseware.submit_survey( '#survey', '#feedbackModal', 3 );

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

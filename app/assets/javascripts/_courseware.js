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
        });
        return false;
      });
    },

    enable_dnd_lectures: function(selector) {
      //var ajaxOpts = {
        //url: 
      //}
      var get_lecture_pos = function(el, i, arr, collect_array, parent_id) {
        var ret = {id: el.id, position: i};
        if (typeof(parent_id) !== 'undefined') {
          ret.parent_lecture_id = parent_id;
        }
        collect_array.push(ret);
        if (el.children) {
          var i = 0, len = el.children.length;
          for (i = 0; i < len; i++) {
            get_lecture_pos(el.children[i], i, el.children, collect_array, el.id);
          }
        }
      };
      var options = {
        collapseBtnHTML: '<button class="collapse-button" data-action="collapse">Collapse</button>'
      };

      $(selector).nestable(options);
      $('.dd').on('change', function(e) {
        console.log(e);
        //$.ajax({
          //url: $(selector).attr( 'action' ),
          //authenticity_token: $('meta[name="csrf-token"]').attr('content'),
          //method: 'POST'
        //});
        console.log('reordered lectures');
        var order = $('.dd').nestable('serialize'),
            lectures_attributes = [], i = 0, len = order.length;

          for (i = 0; i < len; i++) {
            get_lecture_pos(order[i], i, order, lectures_attributes);
          }
          console.log(lectures_attributes);
      });
      

    },

    /**
     * Handles on click expanding of elements
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
      if ( $( selector ).val().length === 0 ) {
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
      $.fn.nestable                   ? Courseware.enable_dnd_lectures( '.dd' ) : null;
    }
  };

  $doc.ready( Courseware.run );

}( window, jQuery ));

/**
 * New assignment screen javascript
 */

// =require ./lib/jquery.quizbuilder.js

( function( $, w ) {
  w.Courseware.quiz_toggler = function( $el, selector ) {
    if ( $el.attr( 'checked' ) ) {
      $( selector ).removeClass( 'hide' );
    } else {
      $( selector ).addClass( 'hide' );
    }
  }

  $(document).ready( function() {
    var $check = $( '#has_quiz' );

    w.Courseware.quiz_toggler( $check, '.quiz-builder' );

    $check.click( function() {
      w.Courseware.quiz_toggler( $check, '.quiz-builder' );
    } );
  });
}( jQuery, window ))

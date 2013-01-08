/**
 * Coursewa.re 2013
 * Handle non-application JavaScript
 */

// =require jquery

(function(w, $){
  $(w.document).ready(function() {
    $('#container .submission form').submit(function() {
      var $this = $(this);
      var $email = $this.find('input[type="email"]');
      var action = $this.attr('action');
      var email = $email.val();

      $.ajax({
        url: action,
        type: 'POST',
        data: { EMAIL: email }
      });

      $this.fadeOut('slow', function() {
        $this.parents('.row').find('p').eq(1).fadeOut('slow', function() {
          $(this).text('Thank you for subscribing!');
        }).fadeIn('slow')
      });

      return false;
    });
  });
})(window, jQuery)

/**
 * Wysiwyg related javascript
 */

// =require ./lib/redactor.js

(function($){
  $(document).ready( function() {
    /**
     * Minimal wysiwyg support
     */
    $('.wysiwyg-minimal').redactor({
      airButtons: ['bold', 'italic', 'deleted', '|', 'link'],
      air: true
    });

    /**
     * Basic wysiwyg support
     */
    $('.wysiwyg').redactor();

    /**
     * Assets-aware wysiwyg support
     */
    $('.wysiwyg-full').redactor({
      imageUpload: '#TODO',
      fileUpload: '#TODO',
      autosave: '#TODO',
      interval: 20
    });
  });
}(jQuery))

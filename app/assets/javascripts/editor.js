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
      fixed: true,
      wym: true,
      imageUpload: '/images',
      imageGetJson: '/images',
      imageUploadErrorCallback: function( o, json ) { alert( json.error ); },
      fileUpload: '/uploads',
      fileUploadErrorCallback: function( o, json ) { alert( json.error ); },
      uploadFields: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        assetable_type: $('.assetable_type').val(),
        assetable_id: $('.assetable_id').val()
      }
    });
  });
}(jQuery))

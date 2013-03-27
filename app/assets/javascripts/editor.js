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
      convertLinks: false,
      air: true
    });

    /**
     * Basic wysiwyg support
     */
    $('.wysiwyg').redactor({
      convertLinks: false
    });

    /**
     * Assets-aware wysiwyg support
     */
    $('.wysiwyg-full').redactor({
      fixed: true,
      wym: true,
      convertLinks: false,
      convertDivs: false,
      imageUpload: '/images',
      imageGetJson: '/images',
      imageUploadErrorCallback: function( o, json ) { alert( json.error ); },
      fileUpload: '/uploads',
      fileUploadErrorCallback: function( o, json ) { alert( json.error ); },
      uploadFields: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        assetable_type: $('.assetable_type').val(),
        assetable_id: $('.assetable_id').val()
      },
      modal_image: Courseware.redactor_unsaved_modal( '.assetable_id' ),
      modal_file: Courseware.redactor_unsaved_modal( '.assetable_id' )
    });

    /**
     * Minimal asset-aware wysiwyg support for dynamic editors
     */
    $( '.quiz-builder' ).on( 'click', '.question', function() {
      var $self = $( this ), $textarea = $self.find( 'textarea.input' );

      if ( $self.hasClass( 'template' ) || $self.hasClass( 'has-wysiwyg' ) ) {
        return true;
      }

      $textarea.redactor( {
        convertLinks: false,
        airButtons: ['bold', 'italic', '|', 'link', '|', 'image', 'file'],
        air: true,
        imageUpload: '/images',
        imageGetJson: '/images',
        imageUploadErrorCallback: function( o, json ) { alert( json.error ); },
        fileUpload: '/uploads',
        fileUploadErrorCallback: function( o, json ) { alert( json.error ); },
        uploadFields: {
          authenticity_token: $('meta[name="csrf-token"]').attr('content'),
          assetable_type: $('.assetable_type').val(),
          assetable_id: $('.assetable_id').val()
        },
        modal_image: Courseware.redactor_unsaved_modal( '.assetable_id' ),
        modal_file: Courseware.redactor_unsaved_modal( '.assetable_id' )
      } );

      // Trigger `change` event for underlying textarea
      $self.on( 'focusout, mouseout', function() {
        $textarea.trigger( 'change' );
      } );

      $self.addClass( 'has-wysiwyg' );
    } );
  });
}(jQuery))

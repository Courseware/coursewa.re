/**
 * jQuery Quiz Builder Plugin - v.0.1
 *
 * Copyright 2012 Stas Suscov
 * http://coursewa.re
 */
;(function ( $, window, undefined ) {
  var pluginName = 'quizBuilder',
      document = window.document,
      defaults = {
        store: '.quiz-store',
        fromStore: false,
        controls: {
          text: '.quiz-new-text',
          radios: '.quiz-new-radios',
          checkboxes: '.quiz-new-checkboxes'
        },
        templates: {
          text: '.quiz-text.template',
          radios: '.quiz-radios.template',
          checkboxes: '.quiz-checkboxes.template'
        }
      };

  /**
   * Constructor
   */
  function QuizBuilder( element, options ) {
    this.element = element;

    this.options = $.extend( {}, defaults, options) ;
    this.storeElement = $( this.element ).find( this.options.store );

    this._defaults = defaults;
    this._name = pluginName;

    if ( this.options.fromStore ) {
      this.loadFromStore();
    }

    this.controls();
    this.storeBindings();
  }

  /**
   * Extends String object prototype to handle slug keys generation
   * @return String
   */
  String.prototype.slug = function() {
    return this.toLowerCase().replace( /[^\w ]+/g, '' ).replace( / +/g, '-' );
  }

  /**
   * Prototype definition
   */
  QuizBuilder.prototype = {
    constructor: QuizBuilder,

    /**
     * Wrapper around storage element
     * Loads and de-serializes quiz content
     */
    store: function() {
      return $.parseJSON( this.storeElement.val() ) || [];
    },

    /**
     * Wrapper around storage element
     * Saves and serializes quiz content
     */
    storeUpdate: function( data ) {
      data = JSON.stringify( data );
      this.storeElement.val( data );
    },

    /**
     * Loads quiz from store and builds the elements
     */
    loadFromStore: function() {
      var quiz = this.store();

      if ( quiz.length > 0 ) {
        for( var i=0; i < quiz.length; i++) {
          var question = quiz[i];
          switch( question.type ) {
            case 'text':
              this.buildText( question );
              break;
            case 'radios':
              this.buildRadios( question );
              break;
            case 'checkboxes':
              this.buildCheckboxes( question );
              break;
          }
        }
      }
    },

    /**
     * Handles addition of one option/one answer questions
     * @param event, Object
     * @return Object, newly created element
     */
    textHandler: function( event ) {
      if ( event['preventDefault'] ) { event.preventDefault() }

      var self = event.data;
      var tmpl = $( self.element ).find( self.options.templates.text ).clone();
      tmpl.removeClass( 'template' );
      $( self.element ).append( tmpl );
      tmpl.slideDown();
      return tmpl;
    },

    /**
     * Builds a text question
     * @param Object, question data
     */
    buildText: function( data ) {
      var tmpl = this.textHandler( {data: this} );
      tmpl.find( '.input' ).val( data.content );
      tmpl.find( '.option textarea' ).val( data.options[0].content );
    },

    /**
     * Handles addition of multiple options/one answer questions
     * @param event, Object
     * @return Object, newly created element
     */
    radiosHandler: function( event ) {
      if ( event['preventDefault'] ) { event.preventDefault() }

      var self = event.data;
      var tmpl = $( self.element ).find( self.options.templates.radios ).clone();
      tmpl.removeClass( 'template' );
      $( self.element ).append( tmpl );
      tmpl.slideDown();
      return tmpl;
    },

    /**
     * Builds a radios question
     * @param Object, question data
     */
    buildRadios: function( data ) {
      var tmpl = this.radiosHandler( {data: this} );
      var self = this;

      tmpl.find( '.option' ).remove();
      tmpl.find( '.input' ).val( data.content );

      $.each( data.options, function() {
        var plus = tmpl.find( '.add' );
        var option = self.addAnswer.call( plus, {data: self} );
        option.find( '.option-validation input' ).attr( 'checked', this.valid );
        option.find( '.option-content textarea' ).val( this.content );
      });
    },

    /**
     * Handles addition of multiple options/multiple answers questions
     * @param event, Object
     * @return Object, newly created element
     */
    checkboxesHandler: function( event ) {
      if ( event['preventDefault'] ) { event.preventDefault() }

      var self = event.data;
      var tmpl = $( self.element ).find( self.options.templates.checkboxes ).clone();
      tmpl.removeClass( 'template' );
      $( self.element ).append( tmpl );
      tmpl.slideDown();
      return tmpl;
    },

    /**
     * Builds a checkboxes question
     * @param Object, question data
     */
    buildCheckboxes: function( data ) {
      var tmpl = this.checkboxesHandler( {data: this} );
      var self = this;

      tmpl.find( '.option' ).remove();
      tmpl.find( '.input' ).val( data.content );

      $.each( data.options, function() {
        var plus = tmpl.find( '.add' );
        var option = self.addAnswer.call( plus, {data: self} );
        option.find( '.option-validation input' ).attr( 'checked', this.valid );
        option.find( '.option-content textarea' ).val( this.content );
      });
    },

    /**
     * Handles answers removal, in case of radios/checkboxes
     * @param event, Object
     */
    removeAnswer: function( event ) {
      $(this).parents( '.option' ).slideUp( 'normal', function() {
        $(this).remove();
      } );
      return false;
    },

    /**
     * Handles question removal
     * @param event, Object
     */
    deleteQuestion: function( event ) {
      $(this).parents( '.question' ).slideUp( 'normal', function() {
        $(this).remove();
      } );
      return false;
    },

    /**
     * Handles answer addition, in case of radios/checkboxes
     * @param event, Object
     * @return Object, created element
     */
    addAnswer: function( event ) {
      if ( event['preventDefault'] ) { event.preventDefault() }

      var self = event.data;
      var template = $(this).parents( '.question' ).attr( 'class' );
      template = template.match( /quiz\-\w+/ )[0]
      var $answer = $( self.element ).find( '.template.' + template + ' .option' ).clone();
      $answer.hide();
      $(this).parents( '.question' ).find( '.question-content' ).append( $answer );
      $answer.slideDown();
      return $answer;
    },

    /**
     * Callback, gets triggered on quiz builder events
     * Parses and stores quiz data
     */
    storeQuiz: function( event ) {
      var self = event.data;
      var store = [];

      $(self.element).find( '.question-content' ).each( function(){
        var question = $( this );
        var entry = { options: [] };

        if ( question.parent().attr( 'class' ).match( /template/ ) ) {
          return true;
        }

        entry['content'] = question.find( '.input' ).val();
        entry['type'] = question.parent().attr( 'class' ).match( /quiz-(\w+)/ )[1];

        question.find( '.option' ).each( function() {
          var option = $( this );
          var data = {};

          if ( entry.type === 'text' ) {

            data['valid'] = true;
          } else {
            data['valid'] = !!option.find( '.option-validation input' ).attr( 'checked' );
          }

          data['content'] = option.find( '.option-content textarea' ).val();

          entry.options.push( data );
        })

        store.push( entry );
      });

      self.storeUpdate( store );
    },

    /**
     * Binds up events to store modifications
     * @param event, Object
     */
    storeBindings: function( event ) {
      var self = this;

      // Bind questions and options to store
      $.each( this.options.templates, function( key, ctrl ){
        var question = ctrl.replace( '.template', ' .question-content .input' );
        $( self.element ).on( 'change', question, self, self[ 'storeQuiz' ] );

        var option = question.replace( '.input', ' .option textarea' );
        $( self.element ).on( 'change', option, self, self[ 'storeQuiz' ] );

        var validation = question.replace( '.input', ' .option input' );
        $( self.element ).on( 'click', validation, self, self[ 'storeQuiz' ] );
      });
    },

    /**
     * Binds up callbacks to main controls
     * @param event, Object
     */
    controls: function() {
      var self = this,
        $element = $( self.element );

      // Bind main controls
      $.each( this.options.controls, function( key, ctrl ){
        $( ctrl ).on( 'click', function( event ) {
          self[ key + 'Handler' ]( {data: self} );
          // Scroll to latest element
          $( 'html, body' ).animate( {
            scrollTop: $element.offset().top + $element.height()
          }, 500 );
        } );
      });

      // Bind radio/checkboxes deletion controls
      $.each( this.options.templates, function( key, ctrl ){
        var toRem = ctrl.replace( '.template', ' .remove' );
        var toAdd = ctrl.replace( '.template', ' .add' );
        var toDel = ctrl.replace( '.template', ' .delete' );
        $element.on( 'click', toRem, self, self[ 'removeAnswer' ] );
        $element.on( 'click', toAdd, self, self[ 'addAnswer' ] );
        $element.on( 'click', toDel, self, self[ 'deleteQuestion' ] );
      });
    }
  }

  /**
   * A really lightweight plugin wrapper around the constructor,
   * preventing against multiple instances
   */
  $.fn[pluginName] = function ( options ) {
    return this.each(function () {
      if ( !$.data( this, 'quiz-instance' ) ) {
        $.data( this, 'quiz-instance', new QuizBuilder( this, options ) );
      }
    });
  }

  /**
   * Data API
   */
  $(window).on('load', function () {
    $('[data-quiz="auto"]').each(function () {
      var $quiz = $(this);
      $quiz.quizBuilder($quiz.data());
    })
  })

}(jQuery, window));

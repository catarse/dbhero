$(function(){
  Dbhero.Dataclips.LoadDatatable = function() {
    if($('.dataTables_wrapper').length < 1) {
      try {
        var $table = $('table#clip_table');

        $table.dataTable({
          scrollX: true,
          searching: false,
          lengthChange: false,
          pagingType: 'simple'
        });

      } catch(e) {
        console.log(e);
      }
    }
  };

  Dbhero.Dataclips.Editor = {
    render: function() {
      this.textarea = $('textarea#dataclip_raw_query');
      this.buildAndInsertEditor();

      try {
        this.textarea.css('display', 'none');
        this.startAce();

        $('.ace_editor').css({'padding':'0'});
      } catch(e) {
        console.log(e);
        this.textarea.css('display', 'block');
      }

      var that = this;
      this.textarea.closest('form').submit(function () {
        that.textarea.val(that.ace_editor.getSession().getValue());
      });
    },

    buildAndInsertEditor: function() {
      this.editor = $('<div>', {
        id: "ace_editor",
        position: 'absolute',
        width: this.textarea.width(),
        height: this.textarea.height(),
        class: this.textarea.attr('class')
      });

      this.editor.insertBefore(this.textarea);
      this.editor.css({ 'font-size': '15px' })

      return this;
    },

    startAce: function() {
      this.ace_editor = ace.edit(this.editor[0]);
      this.ace_editor.renderer.setShowGutter(true);

      this.ace_editor.getSession().setUseWrapMode(true);
      this.ace_editor.getSession().setValue(this.textarea.val());
      this.ace_editor.getSession().setTabSize(2);
      this.ace_editor.getSession().setUseSoftTabs(true);
      this.ace_editor.getSession().setMode("ace/mode/pgsql");
      this.ace_editor.setTheme("ace/theme/xcode");

      return this;
    }
  };

  if($('textarea#dataclip_raw_query').length > 0){
    Dbhero.Dataclips.Editor.render();
  }

  var loadDropdown = function(){
    $('.dropdown-button').dropdown({
      inDuration: 300,
      outDuration: 225,
      constrain_width: false, // Does not change width of dropdown to that of the activator
      hover: false, // Activate on click
      alignment: 'left', // Aligns dropdown to left or right edge (works with constrain_width)
      gutter: 0, // Spacing from edge
      belowOrigin: false // Displays dropdown below the button
    });
  }

  if($('.fetch-remote-clip-table').length > 0){
    var $fetchremote = $('.fetch-remote-clip-table');
    $.get($fetchremote.data('path'), function(response) {
      $fetchremote.html(response);
      Dbhero.Dataclips.LoadDatatable();
      loadDropdown();
    });
  }
  loadDropdown();
});


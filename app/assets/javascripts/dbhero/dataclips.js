$(function(){

    startAce = function() {
        var textarea = $('textarea#dataclip_raw_query');
        console.log(textarea.width());
        console.log(textarea.height());

        var editDiv = $('<div>', {
            id: "ace_editor",
            position: 'absolute',
            width: textarea.width(),
            height: textarea.height(),
            'class': textarea.attr('class')
        }).insertBefore(textarea);

        textarea.css('display', 'none');

        var editor = ace.edit(editDiv[0]);
        editor.renderer.setShowGutter(true);

        editor.getSession().setUseWrapMode(true);
        editor.getSession().setValue(textarea.val());
        editor.getSession().setTabSize(2);
        editor.getSession().setUseSoftTabs(true);
        editor.getSession().setMode("ace/mode/sql");

        textarea.closest('form').submit(function () {
            textarea.val(editor.getSession().getValue());
        });

        $('.ace_editor').css({'padding':'0'});

        editor.setTheme("ace/theme/xcode");
        $(editDiv).css({ 'font-size': '15px' })
    }

    if($('textarea#dataclip_raw_query').length > 0){
      startAce();
    }

});


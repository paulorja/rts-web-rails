$(function() {


    var selected_sprite = null;
    var content_selected_sprite = $('.content-selected-sprite');

    $(".link-sprite").click(function() {

        if(selected_sprite != null) {
            selected_sprite.removeClass('sprite-selected');
            content_selected_sprite.hide();
        }

        selected_sprite = $(this);
        selected_sprite.addClass('sprite-selected');

        content_selected_sprite.show();

        $.get('/cell_actions/'+selected_sprite.attr('obj_id'), function(data) {
            content_selected_sprite.html(data);
        });
    });
});
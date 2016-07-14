$(document).on('turbolinks:load', function() {

    var selected_sprite = null;
    var content_selected_sprite = $('.content-selected-sprite');

    $(".link-sprite").click(function() {
        clear_selected_villager();

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

function clear_selected_villager() {
    $('.villager-selected').removeClass('villager-selected');
    $('.content-selected-villager').html('');
}
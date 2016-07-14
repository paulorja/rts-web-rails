$(document).on('turbolinks:load', function() {

    var selected_villager = null;
    var content_selected_villager = $('.content-selected-villager ');

    $(".sprite-villager").click(function(event) {
        event.stopPropagation();
        clear_selected_sprite();


        if(selected_villager != null) {
            selected_villager.removeClass('villager-selected');
            content_selected_villager.hide();
        }

        selected_villager = $(this);
        selected_villager.addClass('villager-selected');

        content_selected_villager.show();

        $.get('/villager/'+$(this).parent().attr('obj_id')+'/'+selected_villager.attr('obj_id'), function(data) {
            content_selected_villager.html(data);
        });

    });

});

function clear_selected_sprite() {
    $('.sprite-selected').removeClass('sprite-selected');
    $('.content-selected-sprite').html('');
}
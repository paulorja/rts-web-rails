$(document).on('turbolinks:load', function() {

    var selected_sprite = null;
    var content_selected_sprite = $('.content-selected-sprite');

    var selected_villager = null;
    var content_selected_villager = $('.content-selected-villager ');


    $(".link-sprite").click(function() {
        if(selected_villager != null && $(this).attr('v-action')) {
            window.location = '/villager/'+selected_villager.parent().attr('obj_id')+'/'+selected_villager.attr('obj_id')+'/'+$(this).attr('obj_id');
        } else {
            selected_villager = null;
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
        }
    });


    $(".sprite-villager").click(function(event) {
        event.stopPropagation();
        selected_sprite = null;
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

    $(".link-sprite").hover(function() {

        if(selected_villager != null) {
            switch($(this).attr('v-action')) {
                case 'go':
                    $('body').css('cursor', 'url(/assets/sprites/world/villagers/vil_'+selected_villager.attr('obj_id')+'), pointer');
                    break;
                default:
                    set_default_cursor()
                    break;
            }
        }

    });

});

function clear_selected_villager() {
    $('.villager-selected').removeClass('villager-selected');
    $('.content-selected-villager').html('');
}

function clear_selected_sprite() {
    $('.sprite-selected').removeClass('sprite-selected');
    $('.content-selected-sprite').html('');
}

function set_default_cursor() {
    $('body').css('cursor', 'default');
}
$(document).on('turbolinks:load', function() {

    var selected_sprite = null;
    var content_selected_sprite = $('.content-selected-sprite');

    var selected_villager = null;
    var content_selected_villager = $('.content-selected-villager ');


    $(".link-sprite").click(function() {
        if(selected_villager != null && $(this).attr('v-action')) {
            Turbolinks.visit('/villager/'+selected_villager.parent().attr('obj_id')+'/'+selected_villager.attr('obj_id')+'/'+$(this).attr('obj_id'));
            $(".link-sprite").off();
        } else {
            selected_villager = null;
            clear_selected_villager();

            if(selected_sprite != null) {
                selected_sprite.removeClass('sprite-selected');
                content_selected_sprite.removeClass('animated slideInLeft');
                content_selected_sprite.hide();
            }

            selected_sprite = $(this);
            selected_sprite.addClass('sprite-selected');
            content_selected_sprite.addClass('animated slideInLeft');

            $.get('/cell_actions/'+selected_sprite.attr('obj_id'), function(data) {
                content_selected_sprite.html(data);
                content_selected_sprite.show();
            });
        }
    });


    $(".sprite-villager").click(function(event) {
        event.stopPropagation();
        selected_sprite = null;
        clear_selected_sprite();


        if(selected_villager != null) {
            selected_villager.removeClass('villager-selected');
            content_selected_villager.removeClass('animated slideInLeft');
            content_selected_villager.hide();
        }

        selected_villager = $(this);
        selected_villager.addClass('villager-selected');
        content_selected_villager.addClass('animated slideInLeft');

        $.get('/villager/'+$(this).parent().attr('obj_id')+'/'+selected_villager.attr('obj_id'), function(data) {
            content_selected_villager.html(data);
            content_selected_villager.show();
        });

    });

    var body = $('body');

    $(".link-sprite").hover(function() {

        if(selected_villager != null) {
            switch($(this).attr('v-action')) {
                case 'go':
                    body.addClass('cursor-vil-'+selected_villager.attr('obj_id')+'');
                    break;
                case 'lumber':
                    body.addClass('icon-axe');
                    break;
                case 'mine':
                    body.addClass('icon-pick');
                    break;
                case 'farm':
                    body.addClass('icon-hoe');
                    break;
                default:
                    body.attr('class', ''); // remove all class
                    break;
            }
        }

    });

});

function clear_selected_villager() {
    $('.villager-selected').removeClass('villager-selected');
    $('.content-selected-villager').html('');
    $('.content-selected-villager').removeClass('animated slideInLeft');
}

function clear_selected_sprite() {
    $('.sprite-selected').removeClass('sprite-selected');
    $('.content-selected-sprite').html('');
    $('.content-selected-sprite').removeClass('animated slideInLeft');
}

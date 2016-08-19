$(document).on('turbolinks:load', function() {

    var selected_sprite = null;
    var content_selected_sprite = $('.content-selected-sprite');

    var selected_unit = null;
    var content_selected_unit = $('.content-selected-unit');


    $(".link-sprite").click(function() {
        if(selected_unit != null && $(this).attr('v-action')) {
            Turbolinks.visit('/villager/'+selected_unit.parent().attr('obj_id')+'/'+selected_unit.attr('obj_id')+'/'+$(this).attr('obj_id'));
            $(".link-sprite").off();
        } else {
            selected_unit = null;
            clear_selected_unit();

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


    $(".sprite-unit").click(function(event) {
        event.stopPropagation();
        selected_sprite = null;
        clear_selected_sprite();


        if(selected_unit != null) {
            selected_unit.removeClass('unit-selected');
            content_selected_unit.removeClass('animated slideInLeft');
            content_selected_unit.hide();
        }

        selected_unit = $(this);
        selected_unit.addClass('unit-selected');
        content_selected_unit.addClass('animated slideInLeft');

        $.get('/unit/'+$(this).attr('obj_id'), function(data) {
            content_selected_unit.html(data);
            content_selected_unit.show();
        });

    });

    var body = $('body');

    $(".link-sprite").hover(function() {

        if(selected_unit != null && selected_unit.hasClass('sprite-villager')) {
            switch($(this).attr('v-action')) {
                case 'go':
                    body.addClass('cursor-vil-'+selected_unit.attr('obj_id')+'');
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

function clear_selected_unit() {
    $('.unit-selected').removeClass('unit-selected');
    $('.content-selected-unit').html('');
    $('.content-selected-unit').removeClass('animated slideInLeft');
}

function clear_selected_sprite() {
    $('.sprite-selected').removeClass('sprite-selected');
    $('.content-selected-sprite').html('');
    $('.content-selected-sprite').removeClass('animated slideInLeft');
}

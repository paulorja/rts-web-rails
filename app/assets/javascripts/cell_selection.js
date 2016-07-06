$(function() {

    var selected_sprite = null;

    $("body").click(function(event) {
        target = $(event.target);

        if(selected_sprite != null) {
            selected_sprite.removeClass('sprite-selected');
        }

        if(target.hasClass('link-sprite')) {
            selected_sprite = $(target);
            selected_sprite.addClass('sprite-selected');
        }
    });
});
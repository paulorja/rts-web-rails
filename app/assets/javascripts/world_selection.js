$(document).on('turbolinks:load', function() {
    var world = $('#world');

    if(world.length) {
        var world_selection = $('#world_selection');
        var x;
        var y;

        world_pos = [
            world.offset().left,
            world.offset().top,
                world.offset().left + world.outerWidth(),
                world.offset().top + world.outerHeight()
        ];

        world.mousemove(function(e){
            refresh_world_selection(e);
        });

        world_selection.mousemove(function(e){
            refresh_world_selection(e);
        });

        function refresh_world_selection(e) {
            var final_x = e.pageX-world_pos[0];
            var final_y = e.pageY-world_pos[1];

            x = parseInt(final_x/2);
            y = parseInt(final_y/2);

            $('#coords').show();
            $('#coords').html(x +', '+ y);

            set_world_selection(e.pageY, e.pageX)
        }

        function set_world_selection(x, y) {
            var s_center = world_selection.width()/2;

            var limit_top = world_pos[1];
            var limit_left = world_pos[0];
            var limit_bottom = world_pos[3]-world_selection.width();
            var limit_right = world_pos[2]-world_selection.width();

            var final_top = x-s_center;
            var final_left = y-s_center;

            if(final_top < limit_top) {
                final_top = limit_top;
            }
            if(final_left < limit_left) {
                final_left = limit_left;
            }

            if(final_top > limit_bottom) {
                final_top = limit_bottom;
            }
            if(final_left > limit_right) {
                final_left = limit_right;
            }

            world_selection.css({top: final_top, left: final_left});
        }

        world.mouseleave(function() {
            $('#coords').hide();
        });

        world_selection.click(function() {
            window.location = '/world_zoom/'+x+'/'+y;
        });
    }
});

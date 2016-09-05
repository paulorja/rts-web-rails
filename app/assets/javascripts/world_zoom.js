$(document).on('turbolinks:load', function() {
    var cell_container = $('#cell-container');

    if(cell_container.length) {

        var default_top = cell_container.position().top;
        var default_left = cell_container.position().left;

        var final_top = 0;
        var final_left = 0;

        cell_container.draggable({
            stop: function(event, ui) {
                final_top = (cell_container.position().top-default_top)/64
                final_left = (cell_container.position().left-default_left)/64

                //ruby set x and y (url params)
                var final_x = x-final_left;
                var final_y = y-final_top;

                if (final_x < 5) {
                    final_x = 5;
                }
                if (final_x > 251) {
                    final_x = 251;
                }
                if (final_y < 5) {
                    final_y = 5;
                }
                if (final_y > 251) {
                    final_y = 251;
                }


                if(final_top != 0 || final_left != 0) {
                    var url = '/world_zoom/';
                    url += parseInt((final_x)).toString();
                    url += '/'
                    url += parseInt((final_y)).toString();

                    Turbolinks.visit(url);
                } else {
                    document.elementFromPoint(event.clientX, event.clientY).click();
                }
            },
            grid: [64, 64]
        });
    }
});
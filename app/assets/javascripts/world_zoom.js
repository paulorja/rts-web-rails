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

                if(final_top != 0 || final_left != 0) {
                    var url = '/world_zoom/';
                    url += parseInt((x-final_left)).toString();
                    url += '/'
                    url += parseInt((y-final_top)).toString();

                    Turbolinks.visit(url);
                } else {
                    document.elementFromPoint(event.clientX, event.clientY).click();
                }
            },
            grid: [64, 64]
        });
    }
});
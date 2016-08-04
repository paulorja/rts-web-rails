
window.setInterval(function() {
    update_timers();
}, 1000);

function update_timers() {
    var sprite_timers = $('.sprite-timer');

    if(sprite_timers.length) {

        $.each(sprite_timers, function(index, item) {
            if ($(item).attr('data_time') > 0) {

                $(item).attr('data_time', $(item).attr('data_time')-1)

                $(item).html(($(item).attr('data_time')).toString().toHHMMSS());
            } else {
                $(item).html('TERMINAR');
                $(item).click(function() {
                    Turbolinks.visit(location);
                });
            }
        });

    }
}

$(document).on('turbolinks:load', function() {
    var sprite_timers = $('.sprite-timer');

    if(sprite_timers.length) {
        $.each(sprite_timers, function(index, item) {
            $(item).html(($(item).attr('data_time')).toString().toHHMMSS());
        });
    }



    refresh_label_timers();
});


function refresh_label_timers() {
    var label_timers = $('.label-timer');

    if(label_timers.length) {
        $.each(label_timers, function(index, item) {
            $(item).html($(item).html().toString().toHHMMSS());
        });
    }
}
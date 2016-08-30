$(document).on('turbolinks:load', function() {

    var toggle_btn = $('.user-data-toggle-component-btn');

    toggle_btn.click(function() {
        if (toggle_btn.hasClass('flip-Y')) {
            toggle_btn.removeClass('flip-Y');
        } else {
            toggle_btn.addClass('flip-Y');

        }

        $('.user-data-toggle-component').slideToggle('fast');
    });
});
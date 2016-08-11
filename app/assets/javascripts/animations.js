$(document).on('turbolinks:load', function() {

    //$('#game-content-left').addClass('animated fadeIn');
    $('#game-content-right').addClass('animated fadeIn');

    $('.side-menu-item').click(function() {
        $('#game-content-right').addClass('animated fadeOut');
    });

});


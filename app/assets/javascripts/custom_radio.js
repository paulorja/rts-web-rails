$(document).on('turbolinks:load', function() {
    $('.custom-radio').hide();

    var checked_class = 'custom-radio-checked';

    $('.custom-radio').change(function() {
        $('.custom-radio').parent().removeClass(checked_class);
        $(this).parent().addClass(checked_class);
    });

    $('.custom-radio-checked').attr('checked', 'checked');
    $('.custom-radio-checked').parent().addClass(checked_class);
});
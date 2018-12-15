$(document).on('turbolinks:load', function(){

    // Edit answer button

    $('.answers').on('click', '.edit-answer-link',  function(e){
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    // Delete answer button

    $('.answers').on('click', '.delete-answer-button', function(){
       $(this).closest('.card').hide('fast');
    });

    // Mark best answer button

    $('.answers').on('click', '.best-answer-button', function(){
        if ($(this).attr('value') == 'Mark as best answer') {
            $('.best-answer-button').hide('fast');
            $(this).show('fast');
            $(this).prop('value', 'Cancel mark as best answer');
            $(this).closest('.card').children('.best-answer-mark').html('Best Answer!');
        } else {
            $('.div-best-answer-button').show();
            $(this).prop('value', 'Mark as best answer');
            $('.best-answer-button').show('fast');
            $(this).closest('.card').children('.best-answer-mark').html('');
        }
    });
});
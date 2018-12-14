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

    $('.answers').on('click', '.best-answer-button', function(e){
        e.preventDefault();
        $('.best-answer-button').hide('fast');
    });
});
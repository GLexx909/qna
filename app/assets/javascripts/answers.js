$(document).on('turbolinks:load', function() {

    // Edit answer button

    $('.question-and-answers-block').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });


    // Vote update

    $('.answers').on('ajax:success', function(e) {
        var xhr = e.detail[0];
        var rating = xhr['rating'];
        var answerId = xhr['votable_id'];

        $('.answer-vote-' + answerId + ' .rating').html('<b>' + rating + '</b>');
    });


});

$(document).on('turbolinks:load', function() {

    // Edit answer button

    $('.question-and-answers-block').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });


    // Vote update

    $('.answers').on('ajax:success', '.vote', function(e) {
        var xhr = e.detail[0];
        var rating = xhr['rating'];
        var answerId = xhr['votable_id'];

        $('.answer-vote-' + answerId + ' .rating').html('<b>' + rating + '</b>');

    }).on('ajax:error', '.vote', function (e) {
        var errors = e.detail[0];
        $('.notice').html(errors)
    });



    // Answer update CanCan exception.message

    $('.answers').on('ajax:error', '.answer-form', function(e) {
        let errors = e.detail[0];
        var answerId = $(this).data('answerId');

        $('#edit-answer-errors-' + answerId).html('<b>' + errors + '</b>');
    });


    // Answer new form CanCan exception.message

    $('.answer-new-form').on('ajax:error', '.new-answer', function(e) {
        let errors = e.detail[0]['error'];

        $('.answer-errors').html('<b>' + errors + '</b>');
    });



    // Answer Cable question/show

    var questionId = $('.question-block').data('questionId');
    if (questionId) {
        App.cable.subscriptions.create({channel: 'AnswersChannel', id: questionId}, {
            connected: function () {
                return this.perform('follow');
            },

            received: function (data) {
                answer_files = data['answer_files'];
                if (gon.user_id !== data['answer'].author_id && data['answer'].action === 'create') {
                    ($(".answers").append(JST["templates/answer"]({answer: data['answer']})));
                } else if (gon.user_id !== data['answer'].author_id && data['answer'].action === 'delete') {
                    $('.answer-vote-' + data['answer'].id).remove();
                }
            }
        });
    }
});

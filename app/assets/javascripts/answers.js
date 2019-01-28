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

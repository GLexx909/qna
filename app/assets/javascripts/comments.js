$(document).on('turbolinks:load', function() {

    // Show question comment create-form

    $('.question-comments-block').on('click', '.question-comments__add-button', function () {
        $('.question-comment-form').removeClass('hidden');
    });


    // Show answer comment create-form

    $('.answers').on('click', '.answer-comments__add-button', function (e) {
        var answerId = $(this).data('answerId');
        $('.answer-comment-form-' + answerId).removeClass('hidden');
    });



    // Comment Cable question/show

    var questionId = $('.question-block').data('questionId');
    if (questionId) {
        App.cable.subscriptions.create({channel: 'CommentsChannel', id: questionId}, {
            connected: function () {
                return this.perform('follow');
            },

            received: function (data) {
                //if comment was created
                if (gon.user_id !== data['comment'].author_id && data['comment'].action === 'create') {
                    if (data['comment'].commentable_type === 'Question') {
                        $('.question-comments-body').append(JST["templates/comment"]({comment: data['comment']}));
                    } else if (data['comment'].commentable_type === 'Answer') {
                        $('.answer-comments-block-' + data['comment'].commentable_id + ' .answer-comments-body').append(JST["templates/comment"]({comment: data['comment']}));
                    }
                    //if comment was deleted
                } else if (gon.user_id !== data['comment'].author_id && data['comment'].action === 'delete') {
                    if (data['comment'].commentable_type === 'Question') {
                        $('.question-comments-body' + ' .comment-' + data['comment'].id).remove();
                    } else if (data['comment'].commentable_type === 'Answer') {
                        $('.answer-comments-body' + ' .comment-' + data['comment'].id).remove();
                    }
                }
            }
        });
    }
});

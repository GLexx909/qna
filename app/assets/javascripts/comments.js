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

    App.cable.subscriptions.create('CommentsChannel', {
        connected: function () {
            return this.perform('follow');
        },

        received: function (data) {
            //if comment was created
            if (gon.user_id !== data['author'] && data['action'] === 'create') {
                $('.question-comments-body').append(JST["templates/comment"]({id: data['comment_id'], comment: data['comment_body']}));
            //if comment was deleted
            }else if (gon.user_id !== data['author'] && data['action'] === 'delete'){
                $('.question-comments-body' + ' .comment-' + data['comment_id']).remove();
            }
        }
    });
});

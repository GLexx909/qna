$(document).on('turbolinks:load', function() {

    // Show comment create-form

    $('.question-comments-block').on('click', '.question-comments__add-button', function () {
        $('.question-comment-form').removeClass('hidden');
    });

    // Comment Cable question/show

    App.cable.subscriptions.create('CommentsChannel', {
        connected: function () {
            return this.perform('follow');
        },

        received: function (data) {
            //if comment was created
            if (data['action'] === 'create') {
                $('.question-comments-body').append(data['data']);
                //if question was deleted
            // }else if (data['action'] === 'delete'){
            //     $('.question-' + data['data']).remove();
            }
        }
    });
});

$(document).on('turbolinks:load', function() {

    // How comment create-form

    $('.question-comments-block').on('click', '.question-comments__add-button', function () {
        $('.question-comment-form').removeClass('hidden');
    });
});

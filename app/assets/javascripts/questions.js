$(document).on('turbolinks:load', function(){

    // 'Edit' button of Question edit form

    $('.question-and-answers-block').on('click', '.edit-question-link', function(e){
        e.preventDefault();
        $(this).hide();
        $('form.question-edit-form').removeClass('hidden');
    });

    // Add Badge of Question new form

    $('.add-badge-form').on('click','a.badge-link', function(e){
        e.preventDefault();

        if ($(this).text() === 'Remove badge') {
            $(this).text('Assign badge');
        }else{
            $(this).text('Remove badge');
        }

        $('.badge-form').toggle('hidden');
    });

    // Vote update

    $('.question-block').on('ajax:success', '.vote', function(e) {
        let rating = e.detail[0]['rating'];

        $('.question-block .rating').html('<b>' + rating + '</b>');
    });

    // Question Cable

    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function () {
            return this.perform('follow');
        },

        received: function (data) {
            $('.questions-list').append(data);
        }
    });
});


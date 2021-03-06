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

    // Question update CanCan exception.message

    $('.question-block').on('ajax:error', '.question-edit-form', function(e) {
        let errors = e.detail[0];

        $('.notice').html('<b>' + errors + '</b>');
    });


    // Vote update

    $('.question-block').on('ajax:success', '.vote', function(e) {
        let rating = e.detail[0]['rating'];

        $('.question-block .rating').html('<b>' + rating + '</b>');

    }).on('ajax:error', '.vote', function (e) {
        var errors = e.detail[0];
        $('.notice').html(errors)
    });


    // Question Cable index.html

    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function () {
            return this.perform('follow');
        },

        received: function (data) {
             //if question was created
            if (data['action'] === 'create') {
                $('.questions-list').append(data['data']);
             //if question was deleted
            }else if (data['action'] === 'delete'){
                $('.question-' + data['data']).remove();
            }
        }
    });
});

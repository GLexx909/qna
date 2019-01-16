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

        if ($(this).text() == 'Remove badge') {
            $(this).text('Assign badge');
        }else{
            $(this).text('Remove badge');
        }

        $('.badge-form').toggle('hidden');
    });

    // Vote update

    $('.question-block').on('ajax:success', function(e) {
        var rating = e.detail[0];

        $('.question-block .rating').html('<b>' + rating + '</b>');
    })

});


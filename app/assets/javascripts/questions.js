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

        // При повторном нажатии (если обьект и так создан), rating возвращает undefined, хотя прослушка вообще срабатывать не должна.
        // вернее ajax не success же!
        if (rating !== undefined) {
            $('.question-block .rating').html('<b>' + rating + '</b>');
        }
    })
});


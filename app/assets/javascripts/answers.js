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

    App.cable.subscriptions.create('AnswersChannel', {
        connected: function () {
            return this.perform('follow');
        },

        received: function (data) {
            answer_files = data['answer_files'];
            if (gon.user_id !== data['author'] && data['action'] === 'create') {
                ($(".answers").append(JST["templates/answer"]({id: data['answer_id'],
                                                               answer_body: data['answer_body'],
                                                              })
                                    )
                );

                function render_files() {
                    var files = data['answer_files'];
                    $.each(files, function (index, file) {
                        $('#card-answer-'+ data['answer_id'] +' .file-block').append(`<div><p><a href="${file.url}" target='_blanck' rel='noopener'> ${file.name} </a></p></div>`)
                    });
                }
                render_files();

                function render_links() {
                    var links = data['answer_links'];
                    $.each(links, function (index, link) {
                        if (link.hasOwnProperty('text')) {
                            $('#card-answer-'+ data['answer_id'] +' .gist-code').append(link.text);
                            $('#card-answer-'+ data['answer_id'] +' .links').append(`<ul><li><a href="${link.url}" target='_blanck' rel='noopener'> ${link.name} </a></li></ul>`)
                        }else{
                            $('#card-answer-'+ data['answer_id'] +' .links').append(`<ul><li><a href="${link.url}" target='_blanck' rel='noopener'> ${link.name} </a></li></ul>`)
                        }
                    });
                }
                render_links()
            } else if (gon.user_id !== data['author'] && data['action'] === 'delete') {
                $('.answer-vote-'+ data['answer_id']).remove();
            }
        }
    });

});

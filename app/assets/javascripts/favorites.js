// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var Favorites  = function(){
    var module = {};

    module.modifyView = function(){
        var $favoriteList = $('#favorite-trends');
        if($favoriteList.children().length > 5){
            $favoriteList.css('max-height', '200px')
                         .css('overflow-y', 'scroll');
        }
    };

    module.addFavorite = function(){

        var data = {};
        data.hashtag = $('#current-trend').text();
        $('#add-favorite-message').empty();

        $.ajax({
            url: '/favorites',
            data: JSON.stringify(data),
            type: 'POST',
            dataType: 'json',
            contentType: 'application/json',
            success: function(){
                $('#add-favorite-message').append('<strong>' + data.hashtag + '</strong> has been added to your favorite collection');
                $('#favorite-trends').append('<li class="list-group-item"><a href="home/index/' + data.hashtag +'">' + data.hashtag + '<a/></li>');
                module.modifyView();
                $('#favorite-button').remove();
                $('#favorite-modal').modal('show');
            },
            error: function(result){
                var message = '';
                if (result.status == 442){
                    message = 'You have already <strong>' + data.hashtag + '</strong> as favorite!';
                }
                else{
                    message = '<strong>Upss!</strong> Error connecting with server';
                }
                $('#add-favorite-message').append(message);
                $('#favorite-modal').modal('show');
            }
        });
    };

    return module;
};

$().ready(function(){
    var favoritesModule = Favorites();
    favoritesModule.modifyView();
    $('#favorite-button').click(favoritesModule.addFavorite)
});

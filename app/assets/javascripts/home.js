// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var Animation = function(){
    var animation = {};

    var slideListTweet = function(){
        var $lastChild = $('#tweets-div li').last();
        $('<li class="list-group-item">' + $lastChild.html() + '</li>')
            .hide()
            .prependTo('#tweets-div')
            .slideDown();
        $lastChild.remove();
    };

    animation.animate = function(){
        setInterval(slideListTweet, 2000);
    };

    return animation
}


$().ready(function(){
    var animationModule = Animation();
    animationModule.animate();

});
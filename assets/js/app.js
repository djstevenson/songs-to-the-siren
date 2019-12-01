function deleteSongTag(songID, tagID) {
    var url = "/admin/song/" + songID + "/tag/" + tagID;
    $.ajax({
        type: "DELETE",
        url: url,
        success: function(data) {
            var buttonID = "#song-tag-" + songID + "-" + tagID;
            var listItemID = buttonID + "-li";
            $(buttonID).hide(150, function(){
                this.remove();
                $(listItemID).remove();
            });
        },
    });
}

$(function() {
    $('.song-tag').hover(
        function() { $(this).toggleClass('btn-primary');  $(this).toggleClass('btn-outline-dark') }
    );
    $('.song-tag-remove').hover(
        function() { $(this).toggleClass('btn-danger');  $(this).toggleClass('btn-outline-dark') }
    );

    $('[data-markdown-preview]').on('change keyup paste focus', $.throttle( 500, function() {
        const data = $(this).data()
        const previewAreaId = '#' + data['markdownPreview']
        $.ajax({
            type: "POST",
            url: "/markdown",
            data: { markdown: $(this).val() },
            success: function(data) {
                $(previewAreaId).html(data).show();
            },
        });
    }));
});


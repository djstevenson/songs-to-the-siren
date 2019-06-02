function markdownPreview(textAreaID, previewAreaID) {
    $(textAreaID).on('change keyup paste focus', $.throttle( 500, function() {
        $.ajax({
            type: "POST",
            url: "/markdown/render",
            data: { markdown: $(this).val() },
            success: function(data) {
                $(previewAreaID).html(data).show();
            },
        });
    }));
}

function deleteSongTag(songID, tagID) {
    var url = "/song/" + songID + "/tag/" + tagID;
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



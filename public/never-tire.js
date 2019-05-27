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

function markdownPreview(textAreaID, previewAreaID) {
    $(textAreaID).on('change keyup paste focus', $.throttle( 500, function() {
        $.ajax({
            type: "POST",
            url: "/text/render",
            data: { markdown: $(this).val() },
            success: function(data) {
                $(previewAreaID).html(data);
            },
        });
    }));
}

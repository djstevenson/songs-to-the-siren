function markdownPreview(textAreaID, previewAreaID) {
    var oldVal="";
    $(textAreaID).on('change keyup paste', function() {
        var currentVal = $(this).val();
        if (currentVal == oldVal) {
            return;
        }

        oldVal = currentVal;
        /* Rate limit these? */
        $.ajax({
            type: "POST",
            url: "/text/render",
            data: {markdown: currentVal},
            success: function(data) {
                $(previewAreaID).html(data);
            },
        });
    })
}

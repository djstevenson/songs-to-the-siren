$(function() {
    $('.song-tag').hover( function() {
        $(this).toggleClass('btn-primary')
        $(this).toggleClass('btn-outline-secondary')
    })
    $('.song-tag-remove').hover( function() {
        $(this).toggleClass('btn-danger')
        $(this).toggleClass('btn-outline-secondary')
    })

    
    $('[data-markdown-preview]').on('change keyup paste focus', $.throttle( 500, function() {
        const data = $(this).data()
        const previewAreaId = '#' + data['markdownPreview']
        const songId = data['songId']
        $.ajax({
            type: "POST",
            url: "/markdown",
            data: { markdown: $(this).val(), song: songId },
            success: function(data) {
                $(previewAreaId).html(data).show()
            },
        })
    }))

    // Page for editing song's tags - delete an existing tag
    $('[data-delete-song-tag]').on('click', function() {
        const data = $(this).data()
        const tagId = data['tagId']
        const songId = data['songId']
        var url = "/admin/song/" + songId + "/tag/" + tagId
        const button = $(this)
        const listItem = button.parent()
        $.ajax({
            type: "DELETE",
            url: url,
            success: function(data) {
                button.hide(150, function() {
                    listItem.remove()
                })
            },
        })
    })

    // Page for editing song's tags - add an existing tag
    // This just fills in the input field, the user then
    // clicks the submit button to actually add it.
    $('[data-add-song-tag]').on('click', function() {
        const data = $(this).data()
        const tagName = data['tagName']

        $('#add-tag-name').val(tagName)
    })
})


$(function() {
    $('.song-tag').hover( function() {
        $(this).toggleClass('btn-primary')
        $(this).toggleClass('btn-outline-dark')
    })
    $('.song-tag-remove').hover( function() {
        $(this).toggleClass('btn-danger')
        $(this).toggleClass('btn-outline-dark')
    })

    
    $('[data-markdown-preview]').on('change keyup paste focus', $.throttle( 500, function() {
        const data = $(this).data()
        const previewAreaId = '#' + data['markdownPreview']
        $.ajax({
            type: "POST",
            url: "/markdown",
            data: { markdown: $(this).val() },
            success: function(data) {
                $(previewAreaId).html(data).show()
            },
        })
    }))

    $('[data-delete-song-tag]').on('click', function() {
        const data = $(this).data()
        const buttonID = $(this).attr('id')
        const tagId = data['tagId']
        const songId = data['songId']
        var url = "/admin/song/" + songId + "/tag/" + tagId
        const button = $(this)
        const listItemID = '#' + buttonID + "-li"
        console.log("list item "+ listItemID)
        const listItem = $(listItemID)
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

})


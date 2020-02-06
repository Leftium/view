import { onMount } from 'svelte'

TASKPAPER_TEXT = """
ProjectA: @tag(with value)
	- Task1 with @baretag in middle
	@(Nameless tag) with note after it
	- Task2 with sub-project
		EmptyProject:
ProjectB:
	- Plain task3
	Plain note
"""


itemPath = ''
contentText = TASKPAPER_TEXT
html = ''


renderTaskpaperOutline  = (text, itemPath='*') ->
    text = await text
    renderItem = (item) ->
        itemLI = document.createElement('li')
        for attribute in item.attributeNames
             itemLI.setAttribute attribute, item.getAttribute(attribute)

        indentation = ''
        for n in [0...item.depth-1]
            indentation += '\t'
        itemLI.setAttribute 'depth', item.depth
        itemLI.innerHTML = indentation + item.bodyHighlightedAttributedString
                                             .toInlineBMLString() or '&nbsp;'
        return itemLI.outerHTML

    outline = new birchoutline.Outline.createTaskPaperOutline(text)
    results = outline.evaluateItemPath(itemPath)

    html = ''
    for result in results
        html += renderItem result

    return html

location = window.location
urlObject = new URL location

url = urlObject.searchParams.get 'url'
itemPath = urlObject.searchParams.get('query')


loadUrl = (url) ->
    url = url.replace /www.dropbox.com/, 'dl.dropboxusercontent.com'
    res = await fetch url
    await res.text()


if url
    contentText = loadUrl(url)

`$: html = renderTaskpaperOutline(contentText, itemPath || '*');`


onDropboxChoose = (results) ->
    url = "#{location.origin}/?url=#{results[0].link}"
    window.open url, '_top'


onMount () ->
    options =
        success: onDropboxChoose
        linkType: 'direct'
        multiselect: false
        extensions: ['text']
    button = Dropbox.createChooseButton(options)
    document.getElementById('controls').appendChild(button)

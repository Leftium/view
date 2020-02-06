import { onMount } from 'svelte'

import * as linkify from 'linkifyjs'
import linkifyHtml from 'linkifyjs/html'



MAXLENGTH = 50
LINKIFY_OPTIONS =
    attributes: (href) ->
        attributes =
            title: href
    format: (value) =>

        constructUrl = (head, tail) ->
            if tail.length
                head.concat(tail).join('/')
            else
                head.join('/')

        truncate = (string, length) ->
            if string.length > length
                string = string[0...length-1] + '…'
            string


        # Strip URL hash, query strings, http, www, trailing slash
        value = value.split('#')[0]
                     .split('?')[0]
                     .replace ///^https?://(www[0-9]*\.)?///i, ''
                     .replace ////$///i, ''


        # If URL short enough, don't shorten
        if value.length < MAXLENGTH
            return value

        parts = value.split('/')

        # Start with the domain
        head = parts.splice(0, 1)
        tail = []

        # strip file extension
        lastPart = parts.pop()
        lastPart = lastPart?.replace ///(index)?\.[a-z]+$///i, ''
        if lastPart
            parts.push(lastPart)

        # Append very last URL fragment, truncating if required
        lengthLeft = MAXLENGTH - constructUrl(head, tail).length
        if lengthLeft > 0 and parts.length
            fragment = parts.pop()
            tail.push(truncate(fragment, lengthLeft))

        # Insert very first URL fragment, truncating if required
        lengthLeft = MAXLENGTH - constructUrl(head, tail).length
        if lengthLeft > 0 and parts.length
            fragment = parts.shift()
            head.push(truncate(fragment, lengthLeft))

        if parts.length
            head.push('\u22EF')  # Midline horizontal ellipsis ⋯

        constructUrl(head, tail)


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
        return linkifyHtml itemLI.outerHTML, LINKIFY_OPTIONS

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

`let itemPath = '';`
html = ''

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

renderTaskpaperOutline  = (text, itemPath='*') ->
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

`$: html = renderTaskpaperOutline(TASKPAPER_TEXT, itemPath || '*');`

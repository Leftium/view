<script src='./script.coffee'></script>


<main>
    <div id=controls>
        <input bind:value={itemPath} placeholder='TaskPaper Query'>
    </div>
    <div id=content>
        {@html html}
    </div>

</main>

<style>
    main {
        padding: 0.5em;
    }

    #content {
        white-space: pre-wrap;
        display: inline-block;
        tab-size: 40px;
    }

    :global([data-type="project"]) { font-weight: bold; }
    :global([data-type="note"]) { font-style: italic; color: #93a1a1; }
    :global([data-done]) { text-decoration: line-through; }
    :global(span[tag]) { color: #2aa198; font-weight: normal }

    :global(span[link]) { position: relative;}
    :global(span[lead]) { position: absolute; left: -10px }

    :global(ul),
    :global(li),
    :global(p)
    {
        list-style-type: none;
        margin: .38em auto;
    }
</style>

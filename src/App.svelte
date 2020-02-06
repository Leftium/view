<script src='./script.coffee'></script>


<main>
    <h1>Hello {name}!</h1>
    <p>Visit the <a href="https://svelte.dev/tutorial">Svelte tutorial</a> to learn how to build Svelte apps.</p>

    <div id=content>
        {@html html}
    </div>

</main>

<style>
    main {
        padding: 1em;
        max-width: 240px;
        margin: 0 auto;
    }

    h1 {
        color: #ff3e00;
        text-transform: uppercase;
        font-size: 4em;
        font-weight: 100;
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

    @media (min-width: 640px) {
        main {
            max-width: none;
        }
    }
</style>

---
layout: post
title:  "First steps with Vim script"
tags: vim firststeps dotfiles
---

# Starting

I didn't know the Vim language.

But I'm writing a blog, and I wanted to enable spell checking. I found on the
Internet this:
{% highlight vim %}
:setlocal spell spelllang=en
{% endhighlight %}

Nice, but it is a long command,  let's create a key binding:
{% highlight vim %}
map <space>s :setlocal spell! spelllang=en<CR>
{% endhighlight %}
Writing this in `.vimrc` and reloading the editor (or running `:source ~/.vimrc`
to reload the config) we should be able to  toggle the spell checking pressing
`SPACE s`.

Notes:

* the **!** after `spell` means _toggle_ and inverts the state of the parameter
* `<CR>` is _carriage return_ (enter)


# One step further
Now why not print a message when the check is enabled or disabled? To run
multiple instruction we can use a function:

{% highlight vim %}
let s:is_spell_active = 0
function SpellLoop()
    let s:is_spell_active = !s:is_spell_active
    setlocal spell! spelllang=en

    if s:is_spell_active
        echo "spell check enabled"
    else
        echo "spell check disabled"
    endif
endfunction

map <silent> <space>s :call SpellLoop()<CR>
{% endhighlight %}

Notes:

* variables with name starting with `s:` are visible only in the current script
file, the ones starting with `g:` are globals and with `l:` are locals (the `l:`
can be omitted, but it's useful to avoid conflict with reserved variable names)

* `<silent>` prevent the printing of called command, we want to display stuff
from the function


# More languages

We can also write a function to loop over different languages:

{% highlight vim %}
let s:spell_list = ["en", "it"]
let s:spell_i = 0

function SpellLoop()
    let s:spell_i = (s:spell_i + 1) % len(s:spell_list)
    let l:spell = s:spell_list[s:spell_i]

    exec "setlocal spell spelllang=" . l:spell

    echo "spell check: " . l:spell
endfunction
{% endhighlight %}

And support the "none" language too:

{% highlight vim %}
let s:spell_list = ["none", "en", "it"]
let s:spell_i = 0

function SpellLoop()
    let s:spell_i = (s:spell_i + 1) % len(s:spell_list)
    let l:spell = s:spell_list[s:spell_i]

    if l:spell == "none"
        setlocal spell!
    else
        exec "setlocal spell spelllang=" . l:spell
    endif

    echo "spell check: " . l:spell
endfunction
{% endhighlight %}


# Make a plugin

Everything can be packet in a plugin putting the code in a _.vim_ file inside
`~/.vim/plugin/`

To change the languages list from `.vimrc` we have to define `s:spell_list` as
global with the `g:` and check if it is already defined before setting the
default value

{% highlight vim %}
if !exists('g:spell_list')
    let g:spell_list = ["none", "en"]
endif
{% endhighlight %}

The full plugin can be downloaded from GitHub [here](https://github.com/edne/spell-loop)

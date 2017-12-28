Some vim support for IN files
=============================

**What's an IN file?**

Eh, it's just a file with an outline. Name it foo.in. It's "in" as in inbox
— a place to keep todo lists or anything else. My IN.in once had almost 7000
items! Crap! (It's down to 3000 now, but hey, at least I know this plugin
is performant.)

Outlines look like:

    -  This item is at the top
    -  Here's another item
        -  Items nest and stuff
            -  They can nest a lot.
        -  Items can be really really long, so that they wrap over multiple
           lines. I've set vim options that make this happen automatically, for
           the most part.
        -  baz

**What's this plugin do?**

Well, it used to do lots of questionably useful things! Now I've rebooted it,
and it:

* Sets some good options
* Abbreviates `--` to `——`
* Makes `<cr>` act sort of clever. Maybe too clever? Hopefully intuitive.

Recommendations
--------------

* Keep items formatted with judicious use of `gq`.
* Be careful moving items around. There's no notion of an "item" text
  object, so you have to do everything linewise at best.
* Use the shift operators! `>>` and `<<` in Normal mode, and `<c-t>` and
  `<c-d>` in Insert mode. It's fun.
* Works well with [Goyo](https://github.com/junegunn/goyo.vim) and [NrrwRgn](https://github.com/chrisbra/NrrwRgn).

I'd like to make formatting and moving easier in the future.

License
-------

GPLv3+, as in LICENSE.

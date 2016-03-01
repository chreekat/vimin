Some vim support for IN files
=============================

**What's an IN file?**

Eh, it's just a file with an outline. Name it foo.in. It's "in" as in inbox
— a place to keep todo lists or anything else. My IN.in once had almost 7000
items! Crap! (It's down to 3000 now, but hey, at least I know this plugin
is performant.)

Outlines look like:

    - This item is at the top
    - Here's another item
        - Items nest and stuff
          - They can nest a lot.
            > They can also have comments!
        - Items can be really really long, so that they wrap over multiple
          lines. It's up to you to set vim to indent things properly. I
          should find out what options I use that make it nice. Short
          story: it's nice.
        - baz

**What's this plugin do?**

It makes outlines fold hecka nice! The above list, at foldlevel=1, would look like:

    - This item is at the top
    + Here's another item (↓3)

And at foldlevel=2:

    - This item is at the top
    - Here's another item
        + Items nest and stuff (↓1)
        - Items can be really really long, so that they wrap over multiple…
        - baz


There's also some visual niceness around comments and long lines, and some
other secret hidden features (tm)

Recommendations
--------------

* Keep items formatted with judicious use of `gq`.
* Be careful moving items around. There's no notion of an "item" text
  object, so you have to do everything linewise at best.
* Use the shift operators! `>>` and `<<` in Normal mode, and `<c-t>` and
  `<c-d>` in Insert mode. It's fun.

I'd like to make formatting and moving easier in the future.

TODO
----

See the 'bugs' file (and [t](https://github.com/sjl/t)).


License
-------

GPLv3+, as in LICENSE.

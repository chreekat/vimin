Some vim support for IN files
=============================

**What's an IN file?**

Eh, it's just a file with an outline. Name it foo.in. It's "in" as in inbox
— a place to keep todo lists or anything else. My IN.in has almost 7000
items! Crap! (But hey, at least I know this plugin is performant.)

Outlines look like:

    - This item is at the top
    - Here's another item
        - Items nest and stuff

**What's this plugin do?**

It makes outlines fold hecka nice! The above list, at foldlevel=1, would look like:

    - This item is at the top
    + Here's another item (↓1)

It also makes folded lines bold. That might look funky with some colorschemes, so YMMV.

Recomendations
--------------

Use this modeline:

    -- vim: nocin nosi ai sw=2 ts=80 :

License
-------

GPLv3+, as in LICENSE.

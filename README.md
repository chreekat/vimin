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
        - Items can be really really long, so that they wrap over multiple
          lines. I've set vim options that make this happen automatically, for
          the most part.
        - baz

**What's this plugin do?**

Well, it used to do lots of questionably useful things! Now I've rebooted it,
and it:

* Sets some good options
* Makes `<cr>` act sort of clever. Maybe too clever? Hopefully intuitive.
* `o` and `O` also kinda do the right thing.

Recommendations
--------------

* Keep items formatted with judicious use of `gq`.
* Be careful moving items around. There's no notion of an "item" text
  object, so you have to do everything linewise at best.
* Use the shift operators! `>>` and `<<` in Normal mode, and `<c-t>` and
  `<c-d>` in Insert mode. It's fun.
* Try using `insort` (from [chreekat/usort](https://github.com/chreekat/usort))
  for sorting top-level items.
* vim-unimpaired's "paste and indent" mappings are nice. I re-implemented them
  like so:
  ```vim
  function! VimrcIndentPaste(reg, dent, dir)
      set nofoldenable
      exec 'normal "' . a:reg . ']' . a:dir . a:dent . "']"
      set foldenable
  endfu

  for dent in ['>','<']
      for dire in ['p','P']
          exec 'nnoremap ' . dent . dire . " :call VimrcIndentPaste(v:register, '".dent."', '".dire."')<cr>zv"
      endfor
  endfor
  unlet dire dent
  ```
    *  [From my vimrc](https://github.com/chreekat/bDotfiles/blob/699b416a3ece2a0e3d2f9c5277d02db8352c387f/vimrc#L117-L129)
* Works well with [Goyo](https://github.com/junegunn/goyo.vim) and [NrrwRgn](https://github.com/chrisbra/NrrwRgn).

I'd like to make formatting and moving easier in the future.

License
-------

GPLv3+, as in LICENSE.

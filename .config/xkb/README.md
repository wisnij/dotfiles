Some ThinkPads, including the E550, have a rather peculiar keyboard which looks
something like this:

    ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───────┐
    │ ~ │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 0 │ [ │ ] │ Bkspc │
    ├───┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─────┤
    │ Tab │ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │ [ │ ] │  \  │
    ├─────┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴─────┤
    │ Caps │ A │ S │ D │ F │ G │ H │ J │ K │ L │ ; │ ' │  Enter │
    ├──────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴────────┤
    │ Shift  │ Z │ X │ C │ V │ B │ N │ M │ , │ . │ / │    Shift │
    ├───┬────┼───┼───┼───┴───┴───┴───┴───┼───┼───┴─┬─┴──┬───────┤
    │ Fn│Ctrl│Win│Alt│                   │Alt│PrtSc│Ctrl│ARROWS │
    └───┴────┴───┴───┴───────────────────┴───┴─────┴────┴───────┘

For use with xmonad, I'm remapping RAlt and PrtSc to be RWin and RAlt,
respectively, and using Win as the mod key.  I tried just mapping PrtSc to RWin
and calling it a day, but having Alt and Ctrl right next to each other is more
convenient for Emacs combos, and more similar to other laptops I've had in the
past, so the muscle memory is already there.

In any case, if your keyboard doesn't look like the above, these settings will
probably not do what you want.  Use with caution.

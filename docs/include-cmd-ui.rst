.. _ui-commands:

`ui.*` commands
^^^^^^^^^^^^^^^

Commands in this group control aspects of the ‘curses’ UI.

.. glossary::

    ui.current_view
    ui.current_view.set

        .. code-block:: ini

            ui.current_view ≫ string ‹viewname›
            ui.current_view.set = ‹viewname› ≫ 0

        Query or change the current view the user is seeing (querying since ``0.9.7``).
        :term:`view.list` gives you a list of all the added views.

        Typical uses are to change and then restore the active view,
        or rotate through a set of views.
        Rotating through views requires querying the current view and the view list,
        to find the next one.

        In *rTorrent-PS* 1.1+, view changes trigger event handlers for
        :term:`event.view.hide` and :term:`event.view.show`.


    ui.torrent_list.layout
    ui.torrent_list.layout.set

        Offers a choice between ``full`` and ``compact`` layout (since ``0.9.7``).

    ui.unfocus_download

        Used internally before erasing an item, to move the focus away from it.


.. note::

    The following are only available in *rTorrent-PS*!

.. glossary::

    ui.bind_key
    ui.bind_key.verbose
    ui.bind_key.verbose.set

        .. code-block:: ini

            # rTorrent-PS 0.*+ only
            ui.bind_key = display, key, "command=[...]" ≫ 0
            # rTorrent-PS 1.1+ only
            ui.bind_key.verbose = ≫ bool (0 or 1)

        Binds the given key on a specified display to execute the given command when pressed.
        Note that this needs to be called in a one-shot schedule, after *rTorrent* is fully initialized.

        ``display`` must always be ``download_list``, for the moment.

        ``key`` can be either a single character for normal keys,
        ``^`` plus a character for control keys,
        or a 4 digit octal code for special keys.

        The :term:`ui.bind_key.verbose` flag determines whether replacing an existing binding
        is logged (``1``, the default) or not (``0``).

        Configuration example:

        .. code-block:: ini

            # Bind '^' to show the "rtcontrol" result
            schedule2 = bind_view_rtcontrol, 1, 0,\
                "ui.bind_key = download_list, ^, ui.current_view.set=rtcontrol"


    ui.color.custom1…9
    ui.color.alarm
    ui.color.complete
    ui.color.even
    ui.color.focus
    ui.color.footer
    ui.color.incomplete
    ui.color.info
    ui.color.label
    ui.color.leeching
    ui.color.odd
    ui.color.progress0
    ui.color.progress20
    ui.color.progress40
    ui.color.progress60
    ui.color.progress80
    ui.color.progress100
    ui.color.progress120
    ui.color.queued
    ui.color.seeding
    ui.color.stopped
    ui.color.title
    ui.color.‹type›.set

        .. code-block:: ini

            # rTorrent-PS 0.*+ only
            ui.color.‹type›= ≫ string ‹color-spec›
            ui.color.‹type›.set=‹color-spec› ≫ 0

        These commands allow you to set colors for selected elements of the user
        interface in *rTorrent-PS*, in some cases depending on their status. You can either
        provide colors by specifying the numerical index in the terminal's color
        table, or by name (for the first 16 colors). The possible color names
        are "black", "red", "green", "yellow", "blue", "magenta", "cyan",
        "gray", and "white"; you can use them for both text and background
        color, in the form "«fg» on «bg»", and you can add "bright" in front of
        a color to select a more luminous version. If you don't specify a color,
        the default of your terminal is used.

        Also, these additional modifiers can be placed in the color definitions,
        but it depends on the terminal you're using whether they have an effect:
        "bold", "standout", "underline", "reverse", "blink", and "dim".

        See the `color scheme for 256 xterm colors`_ for an example.


    ui.canvas_color
    ui.canvas_color.set

        **rTorrent-PS 1.1+ only**

        **TODO**

    ui.column.render

        **rTorrent-PS 1.1+ only**

        **TODO**

    ui.focus.end
    ui.focus.home
    ui.focus.pgdn
    ui.focus.pgup
    ui.focus.page_size
    ui.focus.page_size.set

        .. code-block:: ini

            # rTorrent-PS 0.*+ only

        **TODO**

    ui.style.progress
    ui.style.progress.set
    ui.style.ratio
    ui.style.ratio.set

        .. code-block:: ini

            # rTorrent-PS 0.*+ only, obsolete with 1.1+

        **TODO**


.. _`color scheme for 256 xterm colors`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/color-schemes/default-256.rc


.. _view-commands:

`view.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    view.add
    view.list
    view.size
    view.persistent

        **TODO**

    view.event_added
    view.event_removed

        **TODO**

    view.filter
    view.filter_all
    view.filter_download
    view.filter_on

        **TODO**

    view.set
    view.set_visible
    view.set_not_visible
    view.size_not_visible

        **TODO**

    view.sort
    view.sort_current
    view.sort_new

        **TODO**


    view.collapsed.toggle

        .. code-block:: ini

            # rTorrent-PS 0.*+ only
            view.collapsed.toggle=‹view-name› ≫ 0

        This command changes between the normal item display, where each item
        takes up three lines, to a more condensed form exclusive to *rTorrent-PS*,
        where each item only takes up one line.

        Note that each view has its own state, and that if the view
        name is empty, the current view is toggled. You can set the default
        state in your configuration, by adding a toggle command for each view
        you want collapsed after startup (the default is expanded).

.. END cmd-ui

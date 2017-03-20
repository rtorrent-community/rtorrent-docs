.. _ui-commands:

`ui.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

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
        Rotating though views requires querying the current view and the view list,
        to find the next one.

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

            # rTorrent-PS only
            ui.bind_key = display, key, "command=[...]" ≫ 0

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


    ui.color.alarm[.set]
    ui.color.complete[.set]
    ui.color.even[.set]
    ui.color.focus[.set]
    ui.color.footer[.set]
    ui.color.incomplete[.set]
    ui.color.info[.set]
    ui.color.label[.set]
    ui.color.leeching[.set]
    ui.color.odd[.set]
    ui.color.progress0[.set]
    ui.color.progress20[.set]
    ui.color.progress40[.set]
    ui.color.progress60[.set]
    ui.color.progress80[.set]
    ui.color.progress100[.set]
    ui.color.progress120[.set]
    ui.color.queued[.set]
    ui.color.seeding[.set]
    ui.color.stopped[.set]
    ui.color.title[.set]

        **TODO**

        See the `color scheme for 256 xterm colors`_ for an example.

    ui.focus.end
    ui.focus.home
    ui.focus.pgdn
    ui.focus.pgup
    ui.focus.page_size
    ui.focus.page_size.set

        **TODO**

    ui.style.progress
    ui.style.progress.set
    ui.style.ratio
    ui.style.ratio.set

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

.. END cmd-ui

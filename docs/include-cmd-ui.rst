.. _ui-commands:

`ui.*` commands
^^^^^^^^^^^^^^^

Commands in this group control aspects of the `curses` UI.

.. glossary::

    ui.current_view
    ui.current_view.set

        .. rubric:: *ui.current_view since rTorrent-PS 0.x / rTorrent 0.9.7*

        .. code-block:: ini

            ui.current_view.set = ‹viewname› ≫ 0
            ui.current_view ≫ string ‹viewname›

        Query or change the current view the user is seeing.
        :term:`view.list` gives you a list of all the built-in and added views.

        Typical uses are to change and then restore the active view,
        or rotate through a set of views.
        Rotating through views requires querying the current view and the view list,
        to find the next one.

        In `rTorrent-PS` 1.1+ and `rTorrent` 0.9.8+,
        view changes also trigger event handlers for
        :term:`event.view.hide` and :term:`event.view.show`.

        ``ui.current_view`` is needed
        if you want to use a hyphen ``-`` as a view name in ``rtcontrol``
        to refer to the currently shown view. An example for that is passing
        ``-M-`` as an option, which performs in-place filtering of the current
        view via ``rtcontrol``.


    torrent_list_layout
    ui.torrent_list.layout
    ui.torrent_list.layout.set

        .. rubric:: *since rTorrent 0.9.7*

        Offers a choice between ``full`` and ``compact`` layout.


    ui.unfocus_download

        Used internally before erasing an item, to move the focus away from it.


    ui.bind_key
    ui.bind_key.verbose
    ui.bind_key.verbose.set

        .. rubric:: *rTorrent-PS 0.x+ / 1.1+ only*

        .. code-block:: ini

            # rTorrent-PS 0.x+ only
            ui.bind_key = ‹display›, ‹key›, "command=[...]" ≫ 0
            # rTorrent-PS 1.1+ only
            ui.bind_key.verbose = ≫ bool (0 or 1)
            ui.bind_key.verbose.set = ‹mode› (0 or 1) ≫ 0

        Binds the given key on a specified display to execute the given command when pressed.
        Note that this needs to be called in a one-shot schedule, after *rTorrent* is fully initialized.

        ``display`` must always be ``download_list``, for the moment
        (currently, no other displays are supported).

        ``key`` can be either a single character for normal keys,
        ``^`` plus a character for control keys,
        or a 4 digit octal code for special keys.

        The :term:`ui.bind_key.verbose` flag determines whether replacing an existing binding
        is logged (``1``, the default) or not (``0``).

        .. rubric:: Configuration Example

        .. code-block:: ini

            # Bind '^' to show the last "rtcontrol" result
            schedule2 = bind_view_rtcontrol, 1, 0,\
                "ui.bind_key = download_list, ^, ui.current_view.set=rtcontrol"

        .. important::

            This currently can NOT be used immediately when ``rtorrent.rc`` is parsed,
            so it has to be scheduled for one-shot execution,
            shortly after startup (see above example).


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
    ui.color.‹type›.index

        .. rubric:: *rTorrent-PS 0.x+ only*

        .. code-block:: ini

            ui.color.‹type›= ≫ string ‹color-spec›
            ui.color.‹type›.set=‹color-spec› ≫ 0

        These commands allow you to set colors for selected elements of the user
        interface in *rTorrent-PS*, in some cases depending on their status.

        You can either provide colors by specifying the numerical index in
        the terminal's color table, or by name (for the first 16 colors).
        The possible color names are "black", "red", "green", "yellow",
        "blue", "magenta", "cyan", "gray", and "white".

        You can use those names for both text and background color,
        in the form "«fg» on «bg»", and you can add "bright" in front of
        a color to select a more luminous version. If you don't specify a color,
        the default of your terminal is used.

        Also, these additional modifiers can be placed in the color definitions,
        but it depends on the terminal you're using whether they have an effect:
        "bold", "standout", "underline", "reverse", "blink", and "dim".

        The *private* ``ui.color.‹type›.index`` calls return the related ID in the `rTorrent-PS` color table.
        These IDs are used in the color definitions ``C‹id›/‹len›`` of :term:`ui.column.render`.

        See the `color scheme for 256 xterm colors`_ for an example.


    ui.canvas_color
    ui.canvas_color.set

        .. rubric:: *rTorrent-PS 1.1+ only*

        *Not working right now.*


    ui.column.render

        .. rubric:: *rTorrent-PS 1.1+ only*

        This is a multi-command that holds the column layout specifications
        for the customizable *canvas v2* display in `rTorrent-PS` version 1.1+,
        and maps them to their rendering commands.

        See `Customizing the Display Layout`_ in the `rTorrent-PS` manual for a detailed explanation.


    ui.column.spec

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            ui.column.spec = ‹column index› ≫ string (column specification)

        For a given column index, looks up the column specification as defined in
        :term:`ui.column.render`.
        This can also be used to check whether a certain index is defined
        – an undefined one returns an empty string.

        .. rubric:: Examples

        .. code-block:: ini

            # Permanently remove the 'ignoring commands' column
            method.set_key = ui.column.render, (ui.column.spec, 130)

        .. literalinclude:: rtorrent-ps/tests/commands/ui.txt
            :language: console
            :start-after: # ui.column.spec
            :end-before: # END


    ui.column.hide
    ui.column.show
    ui.column.is_hidden
    ui.column.hidden.list

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            ui.column.hide = ‹column index›[, …] ≫ 0
            ui.column.show = ‹column index›[, …] ≫ 0
            ui.column.is_hidden = ‹column index› ≫ bool (0 or 1)
            ui.column.hidden.list = ≫ array of value (column index list)

        Hide or show columns by their index.
        The hide/show commands take any number of arguments, or a list of values.

        The ``ui.column.is_hidden`` command allows to query the visibility of a column,
        and the last command returns a list of index values for all hidden columns.

        The hiddden state is *not* persisted over client restarts.
        Also note that some columns are auto-hidden in case the terminal gets too narrow
        to show all of them.


    ui.column.sacrificed
    ui.column.sacrificed.set
    ui.column.sacrificed.toggle
    ui.column.sacrificial.list

        .. rubric:: *rTorrent-PS 1.1+ only*

        The ``ui.column.sacrificed`` value is *false* (0) by default,
        and can set set as usual.
        The ``ui.column.sacrificed.toggle`` command changes the state of this value
        and :term:`ui.column.hide`\ s or :term:`ui.column.show`\ s all the columns
        that ``ui.column.sacrificial.list`` returns (as a list of values).


    ui.focus.end
    ui.focus.home
    ui.focus.pgdn
    ui.focus.pgup
    ui.focus.page_size
    ui.focus.page_size.set

        .. rubric:: *rTorrent-PS 0.x+ only*

        These commands support quick paging through the download list,
        and jumping to the start or end of it.
        See `bind-navigation-keys.rc`_ on how to use them in a `rTorrent-PS` configuration.

        With the ``ui.focus.page_size.set`` command, the amount of items to skip
        can be changed from the default value of 50, e.g. in the ``_rtlocal.rc`` file.


    ui.find.term
    ui.find.term.set

        .. versionadded:: 1.2 **rTorrent-PS only**

        This string variable holds the current search term,
        and is normally set by entering a value into the :kbd:`Ctrl-F` prompt.

        When you hit :kbd:`Enter` in the ``find>`` prompt, the entered text
        is saved here and then :term:`ui.find.next` is called.


    ui.find.next

        .. versionadded:: 1.2 **rTorrent-PS only**

        This command is bound to :kbd:`Shift-F` and :kbd:`F3` and jumps to the next hit
        for a non-empty :term:`ui.find.term`. The search is ignoring case (for :abbr:`ASCII` names).

        A console message is shown if nothing is found in the current view, or if the view is empty.

    ui.input.history.clear
    ui.input.history.size
    ui.input.history.size.set

        .. versionadded:: 0.9.8

        **TODO**

    ui.style.progress
    ui.style.progress.set
    ui.style.ratio
    ui.style.ratio.set

        .. deprecated:: 1.1 rTorrent-PS *canvas v2* made these obsolete

    ui.throttle.global.step.large
    ui.throttle.global.step.large.set
    ui.throttle.global.step.medium
    ui.throttle.global.step.medium.set
    ui.throttle.global.step.small
    ui.throttle.global.step.small.set

        .. versionadded:: 0.9.8

        **TODO**

    view.filter.temp
    view.filter.temp.excluded
    view.filter.temp.excluded.set
    view.filter.temp.log
    view.filter.temp.log.set

        .. versionadded:: 0.9.8

        **TODO**

.. _`Customizing the Display Layout`: https://rtorrent-ps.readthedocs.io/en/latest/setup.html#custom-layout
.. _`color scheme for 256 xterm colors`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/color-schemes/default-256.rc#L1
.. _`bind-navigation-keys.rc`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/rtorrent.d/bind-navigation-keys.rc#L1


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

        Further explanations on what the columns show and what forms of
        abbreviations are used, to get a display as compact as possible while
        still showing all the important stuff, can be found on `Extended Canvas Explained`_.
        There you also find hints on **how to correctly setup your terminal**.

        Note that each view has its own state, and that if the view
        name is empty, the current view is toggled.
        Newly added views are expanded –
        but in `rTorrent-PS 1.1+` the built-in views are collapsed by default.

        You can set the default state of views to collapsed in your configuration,
        by adding a toggle command for each created view.

        Also when using `rTorrent-PS` before version 1.1,
        you should bind the current view toggle to a key, like this:

        .. code-block:: ini

            schedule = bind_collapse,0,0,"ui.bind_key=download_list,*,view.collapsed.toggle="


.. _`Extended Canvas Explained`: https://rtorrent-ps.readthedocs.io/en/latest/manual.html#extended-canvas-explained


.. END cmd-ui

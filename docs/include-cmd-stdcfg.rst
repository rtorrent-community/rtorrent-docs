The following sections explain some major commands added by well-known configuration sets.

If you want other setups (`rtinst`, `QuickBox`, …) to be documented, we accept pull requests.


Examples in This Manual
^^^^^^^^^^^^^^^^^^^^^^^

These commands are from snippets presented in other chapters.

.. glossary::

    cfg.drop_in

        The directory to import snippets from, see :ref:`drop-in-config`. This is a *private* command.

    event.download.finished_delayed
    event.download.finished_delayed.interval
    event.download.finished_delayed.interval.set

        Events for delayed completion processing,
        see :ref:`event.download.finished_delayed` for a full explanation.


`rTorrent` Wiki Template
^^^^^^^^^^^^^^^^^^^^^^^^

The `CONFIG Template`_ wiki page defines a few commands in its configuration snippet.
See :ref:`config-deconstructed` for a detailed tour.


.. glossary::

    cfg.basedir
    cfg.watch
    cfg.logs

        These define important base paths in the file system layout of a `rTorrent` instance,
        and are all private. They are used where appropriate to define further paths
        like the session directory, and allow easy changes at just one place.

        By default, ``cfg.watch`` and ``cfg.logs`` are sub-dirs of ``cfg.basedir``.


    system.startup_time

        A constant value that holds the :term:`system.time` when the client was started.


    d.data_path

        Return path to an item's data – this is never empty, unlike :term:`d.base_path`.
        Multi-file items return a path ending with a ``/``.

        .. rubric:: Definition

        .. code-block:: ini

            method.insert = d.data_path, simple,\
                "if=(d.is_multi_file),\
                    (cat, (d.directory), /),\
                    (cat, (d.directory), /, (d.name))"


.. _`CONFIG Template`: https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template


.. _pyrocore-cfg:

`pyrocore` Configuration
^^^^^^^^^^^^^^^^^^^^^^^^

In addition to the commands listed here, `pyrocore` also defines :term:`d.data_path`.


.. glossary::

    startup_time

        The :term:`system.time` the client was started at.
        Used in the message shown by `rTorrent-PS` when pressing ``u``,
        and for similar purposes throughout ``rtcontrol``.

        This is an alias for :term:`system.startup_time`.


    d.session_file

        Return path to an item's session file.

        .. rubric:: Definition

        .. code-block:: ini

            method.insert = d.session_file, simple, "cat=(session.path), (d.hash), .torrent"


    d.tracker.bump_scrape

        Send a scrape request for an item, set its ``tm_last_scrape`` custom attribute to now,
        and save the session data. Part of `auto-scrape.rc`_, and bound to the ``&`` key
        in *rTorrent-PS*, to manually request a scrape update.


    d.timestamp.downloaded

        The modification time of the :term:`d.tied_to_file`, or else :term:`system.time`.
        This is set *once* when an item is newly added to the download list, so a later
        :term:`d.delete_tied` does not change it.


    d.timestamp.last_active

        Last time any peer was connected. This is checked at least once per minute,
        but very short connections might not be recorded.

        Redefine the ``pyro_update_last_active`` schedule if you want the check to
        run at a different frequency.


    d.timestamp.last_xfer
    d.last_xfer.is_active
    pyro.last_xfer.min_rate
    pyro.last_xfer.min_rate.set

        Last time any data was transferred for this item.

        ``pyro.last_xfer.min_rate`` sets the threshold in bytes
        below which activity is not counted, and defaults to ``5000``.
        Do not set this too low, since there is always some accounting traffic on an item,
        when peers connect and then are not interested in transferring actual data.

        ``d.last_xfer.is_active`` checks that threshold against both current upstream and downstream traffic.

        Checking is done several times per minute,
        but very short transfer bursts might not be recorded.
        Redefine the ``pyro_update_last_xfer`` schedule if you want the check to
        run at a different frequency.


    d.watch.start
    d.watch.startable
    cfg.watch.start
    cfg.watch.start.set

        **TODO**

        ``d.watch.startable`` is private.


    d.category.set
    load.category
    load.category.normal
    load.category.start

        To add an item to a category previously added with :term:`pyro.category.add`,
        or move it from its old one, use ``d.category.set`` and pass the new category name.

        The *load* commands use this to load items from watch directories
        named like a category – all items loaded from there are added to the related category view.
        :term:`cfg.watch` is used as the root directory which contains the category watch directories.
        They are *private*, and all use the equivalent *verbose* built-in command under the hood.
        To make starting the new items optional,
        ``load.category`` uses the :term:`d.watch.startable` mechanism.

        The definitions are in `rtorrent.d/categories.rc`_,
        and a usage example is in `rtorrent.d/autolabel-categories.rc`_.


    pyro.category.separated

        **TODO**


    pyro.category.add
    pyro.category.list

        The *private* ``pyro.category.add`` command adds a named category.
        That means a ``category_‹name›`` view is defined – you can
        rotate though those views in `rTorrent-PS` using the ``<`` and ``>`` keys.

        See :term:`d.category.set` and :term:`load.category` on how to put new items into a category.

        If you call the ``pyro.category.list`` command,
        it prints a list of currently defined categories to the `rTorrent` console.

        For a full example, see `rtorrent.d/autolabel-categories.rc`_.


    cull
    purge

        Convenience commands for use with the ``Ctrl-X`` prompt,
        to call ``rtcontrol --cull`` or  ``rtcontrol --purge`` on the currently selected item.

        These are *private* commands, from a shell prompt or script use ``rtcontrol`` directly.


    tag.add
    tag.rm
    tag.show

        Convenience commands for use with the ``Ctrl-X`` prompt,
        to call ``rtcontrol --tag`` on the currently selected item.

        ``tag.show`` is bound to the ``Ctrl-G`` key in `rTorrent-PS`,
        and uses the ``tag_show`` output format to define what is printed to the console
        (the list of tags and the item's name by default).

        These are *private* commands, from outside the client use ``rtcontrol`` with ``--tag``,
        and its ``tagged`` field.


    pyro.collapsed_view.add

        .. code-block:: ini

            pyro.collapsed_view.add = ‹view name› ≫ 0

        Like :term:`view.add`, but sets the new view to collapsed state.


    pyro.view.collapsed.toggle

        .. code-block:: ini

            pyro.view.collapsed.toggle = ‹view name› ≫ 0

        The same as :term:`view.collapsed.toggle`, but protected by
        the :term:`pyro.extended` flag (i.e. safe to call in vanilla `rTorrent`).


    pyro.view.toggle_visible

        .. code-block:: ini

            pyro.view.toggle_visible = ‹view name› ≫ 0

        Toggle visibility of an item for the given view.


    pyro.color_theme.name

        Used in color theme files of `rTorrent-PS` to announce switching to a different theme
        (defined in `pyrocore`'s `rtorrent.d/theming.rc`_).


    pyro.watchdog

        **TODO**

        This is a *private* command.


.. _`rtorrent.d/categories.rc`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/rtorrent.d/categories.rc#L1
.. _`rtorrent.d/theming.rc`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/rtorrent.d/theming.rc#L1
.. _`rtorrent.d/autolabel-categories.rc`: https://github.com/pyroscope/pimp-my-box/blob/master/roles/rtorrent-ps/templates/rtorrent/rtorrent.d/autolabel-categories.rc#L5-L7


.. _pmb-cfg:

`pimp-my-box` Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO**

In addition to the commands listed here, `pimp-my-box` also defines
:term:`cfg.basedir`, :term:`cfg.watch`, and :term:`cfg.logs`,
and includes anything from :ref:`pyrocore-cfg`.


.. glossary::

    quit

        **TODO** ``disable-control-q.rc``


    pyro.extended

        Set ``pyro.extended`` to ``1`` to activate `rTorrent-PS` features.
        Note that this *tells* the rest of the configuration that it can
        safely use the extended command set – it *won't* magically make a
        vanilla `rTorrent` an extended one.

        Starting with `rTorrent-PS 1.1+`, this setting is detected automatically,
        thanks to :term:`system.has`.


    pyro.bin_dir

        A constant that should be set to the ``bin`` directory
        where you installed the `pyrocore` tools.

        Make sure you end it with a ``/``;
        if this is left empty, then the shell's path is searched.


    pyro.logfile_path

        **TODO**

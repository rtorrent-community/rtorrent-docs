Commands Reference
==================

The reference chapter lists all relevant XMLRPC and ‘private’ commands
provided by *rTorrent* with a short explanation.
See the :doc:`scripting` on how to combine them into meaningful command sequences,
and :ref:`xmlrpc-api` for some general hints on using the XMLRPC API

**Use the search box** in the sidebar to find specific commands,
or the :ref:`search`.
The :ref:`generated index <genindex>` also lists all the command names.


.. contents:: List of Command Groups
    :local:


The following are similar, but incomplete resources:

-  `PyroScope's reference`_
-  `wikia.com Reference`_

.. _PyroScope's reference: https://github.com/pyroscope/pyroscope/blob/wiki/RtXmlRpcReference.md
.. _wikia.com Reference: http://scratchpad.wikia.com/wiki/RTorrentCommands


Download Items and Attributes
-----------------------------

.. include:: include-cmd-items.rst


Scripting
---------

.. include:: include-cmd-scripting.rst


Logging, Files, and OS
----------------------

.. include:: include-cmd-system.rst


Network (Sockets, HTTP, XMLRPC)
-------------------------------

.. include:: include-cmd-network.rst


Bittorrent Protocol
-------------------

.. include:: include-cmd-bt.rst


User Interface
--------------

.. include:: include-cmd-ui.rst


Miscellaneous
-------------

.. include:: include-cmd-misc.rst


TODO (Groups)
^^^^^^^^^^^^^

 * choke_group
 * fi
 * file
 * group
 * group2
 * keys
 * ratio
 * scheduler


.. glossary::

    directory.default
    directory.default.set
    directory
    encoding.add
    encoding_list

        **TODO**



.. glossary::

    trackers.disable
    trackers.enable
    trackers.numwant
    trackers.numwant.set
    trackers.use_udp
    trackers.use_udp.set

        **TODO**

    trackers.alias.items
    trackers.alias.set_key

        **TODO**


TODO (singles)
^^^^^^^^^^^^^^

.. glossary::

    print
    add_peer
    bind
    catch
    check_hash
    connection_leech
    connection_seed
    download_rate
    encoding_list
    encryption
    ip
    key_layout
    max_downloads
    max_downloads_div
    max_downloads_global
    max_memory_usage
    max_peers
    max_peers_seed
    max_uploads
    max_uploads_div
    max_uploads_global
    min_downloads
    min_peers
    min_peers_seed
    min_uploads
    on_ratio
    port_random
    port_range
    proxy_address
    scgi_local
    scgi_port
    torrent_list_layout
    upload_rate

        **TODO**


.. _intermediate-commands:

‘Intermediate’ Commands
^^^^^^^^^^^^^^^^^^^^^^^

The *intermediate* commands are kept around as aliases for ‘new’ ones
– at least for the time being. Probably best avoided.

Avoiding the *deprecated* commands is a must, these will disappear at some time.

.. glossary::

    method.use_deprecated
    method.use_deprecated.set

        .. code-block:: ini

            method.use_deprecated ≫ bool (0 or 1)
            method.use_deprecated.set = ‹0 or 1› ≫ bool ‹current› (0 or 1)

        The default is ``true``.
        The undocumented ``-D`` command line options sets this to ``false``
        with a ``Disabled deprecated commands`` console message.

    method.use_intermediate
    method.use_intermediate.set

        .. code-block:: ini

            method.use_intermediate ≫ value (0 … 2)
            method.use_intermediate.set = ‹0 … 2› ≫ value ‹current› (0 … 2)

        The default is 1 (allow everywhere), values other than 1 or 2 are treated like 0.
        The undocumented ``-I`` command line options sets this to 0
        with a ``Disabled intermediate commands`` console message,
        while ``-K`` sets it to 2,
        printing ``Allowing intermediate commands without xmlrpc``.


All the command aliases can be found in these three source files:
``command_local.cc``, ``command_throttle.cc``, and ``main.cc``.
Search for ``REDIRECT`` using ``grep``.

These are called *intermediate:*

* ``execute`` → ``execute2`` (ignore both, just use ``execute.throw``)
* ``schedule`` → ``schedule2``
* ``schedule_remove`` → ``schedule_remove2``

* ``group.‹name›.view`` → ``group2.‹name›.view``
* ``group.‹name›.view.set`` → ``group2.‹name›.view.set``
* ``group.‹name›.ratio.min`` → ``group2.‹name›.ratio.min``
* ``group.‹name›.ratio.min.set`` → ``group2.‹name›.ratio.min.set``
* ``group.‹name›.ratio.max`` → ``group2.‹name›.ratio.max``
* ``group.‹name›.ratio.max.set`` → ``group2.‹name›.ratio.max.set``
* ``group.‹name›.ratio.upload`` → ``group2.‹name›.ratio.upload``
* ``group.‹name›.ratio.upload.set`` → ``group2.‹name›.ratio.upload.set``


Standard Configuration Sets
---------------------------

The following sections explain some core commands added by well-known configuration sets.

If you want other setups (`rtinst`, `QuickBox`, …) to be documented, we accept pull requests.


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

        Definition:

        .. code-block:: ini

            method.insert = d.data_path, simple,\
                "if=(d.is_multi_file),\
                    (cat, (d.directory), /),\
                    (cat, (d.directory), /, (d.name))"


.. _`CONFIG Template`: https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template


.. _pyrocore-cfg:

`pyrocore` Configuration
^^^^^^^^^^^^^^^^^^^^^^^^

**TODO** check if they belong with "p-m-b"

In addition to the commands listed here, `pyrocore` also defines :term:`d.data_path`.


.. glossary::

    d.session_file

        Return path to session file.

        Definition:

        .. code-block:: ini

            method.insert = d.session_file, simple, "cat=(session.path), (d.hash), .torrent"


    d.tracker.bump_scrape

        Send a scrape request for an item, set its ``tm_last_scrape`` custom attribute to now,
        and save the session data. Part of `auto-scrape.rc`_, and bound to the ``&`` key
        in *rTorrent-PS*, to manually request a scrape update.


    d.timestamp.downloaded
    d.last_active

        **TODO**

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

        **TODO**

        The `load` commands are private.

    d.last_xfer
    d.last_xfer.is_active

        **TODO**

    event.download.finished_delayed
    event.download.finished_delayed.interval
    event.download.finished_delayed.interval.set

        **TODO**

    quit

        **TODO**

    startup_time

        **TODO**


.. _`auto-scrape.rc`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/rtorrent.d/auto-scrape.rc


`pimp-my-box` Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO**

In addition to the commands listed here, `pimp-my-box` also defines
:term:`cfg.basedir`, :term:`cfg.watch`, and :term:`cfg.logs`,
and includes anything from :ref:`pyrocore-cfg`.


.. glossary::

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


.. END cmd-ref

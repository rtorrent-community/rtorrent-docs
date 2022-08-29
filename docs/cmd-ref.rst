Commands Reference
==================

The reference chapter lists all relevant XMLRPC and ‘private’ commands
provided by *rTorrent* with a short explanation.
See the :doc:`scripting` on how to combine them into meaningful command sequences,
and :ref:`xmlrpc-api` for some general hints on using the XMLRPC API

**Use the search box** in the sidebar to find specific commands,
or the :ref:`search`.
The :ref:`generated index <genindex>` also lists all the command names.

.. important::

    All ``d.*`` commands take an info hash as the first argument when called over the XML-RPC API,
    to uniquely identify the *target* object. ‘Target’ is the term used for that 1st parameter in
    error messages and so on.

      .. code-block:: ini

         d.name = ‹hash› ≫ string ‹name›

    When called within configuration methods or in a ``Ctrl-X`` prompt, the target is implicit.
    It is explicit and *must* be provided for all XMLRPC calls, with very few exceptions like the
    `xmlrpc-c` built-ins.

    Also note that :command:`rtxmlrpc` has some magic that adds this to any command ending in
    ``.multicall`` or ``.multicall.filtered``, from the time this change was introduced.
    :term:`d.multicall2` came later and thus needs an explicit target, and it is a bit of a mess.
    Changing this to be consistent is a breaking change, and might happen sometime in the future.


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

        Returns all the mappings in the form ``«domain»=«alias»`` as a list.

        Note that domains that were not explicitly defined so far, but shown
        previously, are also contained in the list, with an empty alias. So to
        create a list for you to fill in the aliases, scroll through all your
        items on ``main`` or ``trackers``, so you can dump the domains of all
        loaded items.

        Example that prints all the domains and their aliases as commands that
        define them:

        .. code-block:: shell

            rtxmlrpc trackers.alias.items \
                | sed -r -e 's/=/, "/' -e 's/^/trackers.alias.set_key = /' -e 's/$/"/' \
                | tee ~/rtorrent/rtorrent.d/tracker-aliases.rc

        This also dumps them into the ``tracker-aliases.rc`` file to persist
        your mappings, and also make them easily editable. To reload edited
        alias definitions, use this:

        .. code-block:: shell

            rtxmlrpc "try_import=,~/rtorrent/rtorrent.d/tracker-aliases.rc"


    trackers.alias.set_key

        Sets an alias that replaces the given domain, when displayed on the
        right of the collapsed canvas.

        .. rubric:: Configuration Example

        .. code-block:: ini

            trackers.alias.set_key = bttracker.debian.org, Debian


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
    encoding.add
    encoding_list
    encryption
    group.seeding.ratio.command
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
    upload_rate
    fi.filename_last
    fi.is_file
    file.append
    file.prioritize_toc
    keys.layout
    keys.layout.set

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

`rTorrent` 0.9.7 adds some missing ``group.seeding.*`` command aliases.


Standard Configuration Sets
---------------------------

.. include:: include-cmd-stdcfg.rst


.. _`auto-scrape.rc`: https://github.com/pyroscope/pyrocore/blob/master/src/pyrocore/data/config/rtorrent.d/auto-scrape.rc#L1

.. END cmd-ref

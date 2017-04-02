Commands Reference
==================

The reference chapter lists all relevant XMLRPC and ‘private’ commands
provided by *rTorrent* with a short explanation.
See the :doc:`scripting` on how to combine them into meaningful command sequences.

**Use the search box** in the sidebar to find specific commands,
or the :ref:`search`.
The :ref:`generated index <genindex>` also lists all the commmand names.


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

    cat
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
        with a ''Disabled deprecated commands`` console message.

    method.use_intermediate
    method.use_intermediate.set

        .. code-block:: ini

            method.use_intermediate ≫ value (0 … 2)
            method.use_intermediate.set = ‹0 … 2› ≫ value ‹current› (0 … 2)

        The default is 1 (allow everywhere), values other than 1 or 2 are treated like 0.
        The undocumented ``-I`` command line options sets this to 0
        with a ''Disabled intermediate commands`` console message,
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


.. END cmd-ref

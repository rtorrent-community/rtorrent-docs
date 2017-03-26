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

    dht.add_node
    dht.mode.set
    dht.port
    dht.port.set
    dht.statistics
    dht.throttle.name
    dht.throttle.name.set
    dht
    dht_port

        **TODO**


.. glossary::

    protocol.choke_heuristics.down.leech
    protocol.choke_heuristics.down.leech.set
    protocol.choke_heuristics.down.seed
    protocol.choke_heuristics.down.seed.set
    protocol.choke_heuristics.up.leech
    protocol.choke_heuristics.up.leech.set
    protocol.choke_heuristics.up.seed
    protocol.choke_heuristics.up.seed.set
    protocol.connection.leech
    protocol.connection.leech.set
    protocol.connection.seed
    protocol.connection.seed.set
    protocol.encryption.set
    protocol.pex
    protocol.pex.set

        **TODO**


.. glossary::

    session
    session.name
    session.name.set
    session.on_completion
    session.on_completion.set
    session.path
    session.path.set
    session.save
    session.use_lock
    session.use_lock.set

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
    download_list
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

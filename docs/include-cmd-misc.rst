.. _strings-commands:

`strings.*` commands
^^^^^^^^^^^^^^^^^^^^

.. glossary::

    strings.choke_heuristics

        .. hlist::
            :columns: 3

            * ``upload_leech``
            * ``upload_leech_dummy``
            * ``download_leech``
            * ``download_leech_dummy``
            * ``invalid``

    strings.choke_heuristics.download

        .. hlist::
            :columns: 3

            * ``download_leech``
            * ``download_leech_dummy``

    strings.choke_heuristics.upload

        .. hlist::
            :columns: 3

            * ``upload_leech``
            * ``upload_leech_dummy``

    strings.connection_type

        .. hlist::
            :columns: 3

            * ``leech``
            * ``seed``
            * ``initial_seed``
            * ``metadata``

    strings.encryption

        .. hlist::
            :columns: 3

            * ``none``
            * ``allow_incoming``
            * ``try_outgoing``
            * ``require``
            * ``require_RC4``
            * ``require_rc4``
            * ``enable_retry``
            * ``prefer_plaintext``

    strings.ip_filter

        .. hlist::
            :columns: 3

            * ``unwanted``
            * ``preferred``

    strings.ip_tos

        .. hlist::
            :columns: 3

            * ``default``
            * ``lowdelay``
            * ``throughput``
            * ``reliability``
            * ``mincost``

        Options for :term:`network.tos.set`.


    strings.tracker_mode

        .. hlist::
            :columns: 3

            * ``normal``
            * ``aggressive``


    strings.tracker_event

        .. rubric:: *since rTorrent 0.9.7*

        .. hlist::
            :columns: 3

            * ``completed``
            * ``scrape``
            * ``started``
            * ``stopped``
            * ``updated``


    strings.log_group

        .. rubric:: *since rTorrent 0.9.7*

        .. hlist::
            :columns: 3

            * ``connection_critical``
            * ``connection_debug``
            * ``connection_error``
            * ``connection_info``
            * ``connection_notice``
            * ``connection_warn``
            * ``critical``
            * ``debug``
            * ``dht_all``
            * ``dht_critical``
            * ``dht_debug``
            * ``dht_error``
            * ``dht_info``
            * ``dht_manager``
            * ``dht_node``
            * ``dht_notice``
            * ``dht_router``
            * ``dht_server``
            * ``dht_warn``
            * ``error``
            * ``info``
            * ``instrumentation_choke``
            * ``instrumentation_memory``
            * ``instrumentation_mincore``
            * ``instrumentation_polling``
            * ``instrumentation_transfers``
            * ``__non_cascading__``
            * ``notice``
            * ``peer_critical``
            * ``peer_debug``
            * ``peer_error``
            * ``peer_info``
            * ``peer_list_events``
            * ``peer_notice``
            * ``peer_warn``
            * ``protocol_metadata_events``
            * ``protocol_network_errors``
            * ``protocol_piece_events``
            * ``protocol_storage_errors``
            * ``resume_data``
            * ``rpc_dump``
            * ``rpc_events``
            * ``socket_critical``
            * ``socket_debug``
            * ``socket_error``
            * ``socket_info``
            * ``socket_notice``
            * ``socket_warn``
            * ``storage_critical``
            * ``storage_debug``
            * ``storage_error``
            * ``storage_info``
            * ``storage_notice``
            * ``storage_warn``
            * ``thread_critical``
            * ``thread_debug``
            * ``thread_error``
            * ``thread_info``
            * ``thread_notice``
            * ``thread_warn``
            * ``torrent_critical``
            * ``torrent_debug``
            * ``torrent_error``
            * ``torrent_info``
            * ``torrent_notice``
            * ``torrent_warn``
            * ``tracker_critical``
            * ``tracker_debug``
            * ``tracker_error``
            * ``tracker_info``
            * ``tracker_notice``
            * ``tracker_warn``
            * ``ui_events``
            * ``warn``


Singular Commands
^^^^^^^^^^^^^^^^^

These are ‘special’ and fall into no group.

.. glossary::

    directory.watch.added

        .. rubric:: *since rTorrent 0.9.7*

        .. code-block:: ini

            directory.watch.added = ‹root folder path›, ‹handler command name› ≫ 0

        On `Linux`, use this command to watch a directory tree via `inotify`.

        The provided handler command is called with the the full path of new files
        as the first argument, i.e. ``argument.0`` in a custom handler method.
        Use :term:`method.insert` to define such a more complex multi-command handler,
        and then use its name as the second argument to ``directory.watch.added``.

        See `Watch Directories`_ in the `rTorrent` wiki for more.

        .. rubric:: Configuration Example

        .. code-block:: ini

            directory.watch.added = "~/Downloads/watch/", load.start_verbose


.. _`Watch Directories`: https://github.com/rakshasa/rtorrent/wiki/TORRENT-Watch-directories

.. _dht-commands:

`dht.*` commands
^^^^^^^^^^^^^^^^

.. glossary::

    dht.add_node

        **TODO**

    dht.mode.set
    dht

        **TODO**

    dht.port
    dht.port.set
    dht_port

        **TODO**

    dht.statistics

        Returns ``{'active': 0, 'dht': 'disable', 'throttle': ''}`` when DHT is off,
        and …

        **TODO**

    dht.throttle.name
    dht.throttle.name.set

        **TODO**


.. _pieces-commands:

`pieces.*` commands
^^^^^^^^^^^^^^^^^^^

.. glossary::

    pieces.hash.on_completion
    pieces.hash.on_completion.set
    pieces.hash.queue_size
    pieces.memory.block_count
    pieces.memory.current
    pieces.memory.max
    pieces.memory.max.set
    pieces.memory.sync_queue
    pieces.preload.min_rate
    pieces.preload.min_rate.set
    pieces.preload.min_size
    pieces.preload.min_size.set
    pieces.preload.type
    pieces.preload.type.set
    pieces.stats.total_size
    pieces.stats_not_preloaded
    pieces.stats_preloaded
    pieces.sync.always_safe
    pieces.sync.always_safe.set
    pieces.sync.queue_size
    pieces.sync.safe_free_diskspace
    pieces.sync.timeout
    pieces.sync.timeout.set
    pieces.sync.timeout_safe
    pieces.sync.timeout_safe.set

        **TODO**


.. _protocol-commands:

`protocol.*` commands
^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    protocol.choke_heuristics.down.leech
    protocol.choke_heuristics.down.leech.set
    protocol.choke_heuristics.down.seed
    protocol.choke_heuristics.down.seed.set
    protocol.choke_heuristics.up.leech
    protocol.choke_heuristics.up.leech.set
    protocol.choke_heuristics.up.seed
    protocol.choke_heuristics.up.seed.set

        **TODO**

    protocol.connection.leech
    protocol.connection.leech.set
    protocol.connection.seed
    protocol.connection.seed.set

        **TODO**

    protocol.encryption.set

        **TODO**

        See also `BitTorrent protocol encryption`_.


    protocol.pex
    protocol.pex.set

        **TODO**


.. _`BitTorrent protocol encryption`: http://en.wikipedia.org/wiki/BitTorrent_protocol_encryption


.. _throttle-commands:

`throttle.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

Throttles are names for bandwidth limitation rules (for upload, download, or both).
The throttle assigned to the item in focus can be changed using ``Ctrl-T``
– it will rotate through all defined ones.

There are two system throttles, ``NULL`` and the one with an empty name.
``NULL`` is a special throttle for *unlimited*, and the latter is the *global* throttle,
which is the default for new items and what's shown in the status bar on the left
as ``[Throttle ‹UP›/‹DOWN› KB]``.

**TODO** Explain how throttles work, borrowing from the global throttle.

Other commands in this group determine the limits for upload / download slots,
and the amount of peers requested in tracker announces.

.. warning::

    Note that since named throttles *borrow* from the global throttle,
    the global one has to be set to a non-zero value for the named ones to work
    (because borrowing from ∞ means there is no limit).


.. glossary::

    throttle.down
    throttle.up

        .. code-block:: ini

            throttle.down = ‹name›, ‹rate› ≫ 0
            throttle.up = ‹name›, ‹rate› ≫ 0

        Define a named throttle. The ``rate`` must be a string (important when using XMLRPC),
        and is always in KiB/s.

        You can also set a new rate for existing throttles this way
        (i.e. repeated definitions are no error).

    throttle.down.max
    throttle.up.max

        .. code-block:: ini

            throttle.down.max = ‹name› ≫ value ‹limit›
            throttle.up.max = ‹name› ≫ value ‹limit›

        Get the current limit of a named throttle in bytes/s.

        Unknown throttles return ``-1``, unlimited ones ``0``.
        If the global throttle is not set, you also get ``0`` for any call.

    throttle.down.rate
    throttle.up.rate

        .. code-block:: ini

            throttle.down.rate = ‹name› ≫ value ‹rate›
            throttle.up.rate = ‹name› ≫ value ‹rate›

        Get the current rate of a named throttle in bytes/s, averaged over recent history.

        Unknown throttles always return ``0``.
        If the global throttle is not set, you also get ``0`` for any call.

    throttle.global_down.max_rate
    throttle.global_down.max_rate.set
    throttle.global_down.max_rate.set_kb
    throttle.global_up.max_rate
    throttle.global_up.max_rate.set
    throttle.global_up.max_rate.set_kb

        Query or change the current value for the global throttle.
        Always use ``set_kb`` to change these values (the ``set`` commands have bugs),
        and be aware that you always get bytes/s when querying them.

    throttle.global_down.rate
    throttle.global_up.rate

        .. code-block:: ini

            throttle.global_down.rate ≫ value ‹rate›
            throttle.global_up.rate ≫ value ‹rate›

        Current overall bandwidth usage in bytes/s, averaged over recent history.

    throttle.global_down.total
    throttle.global_up.total

        .. code-block:: ini

            throttle.global_down.total ≫ value ‹bytes›
            throttle.global_up.total ≫ value ‹bytes›

        Amount of data moved over all items, in bytes.

        **TODO** … in this session, including deleted items?

    throttle.max_downloads
    throttle.max_downloads.set
    throttle.max_downloads.div
    throttle.max_downloads.div.set
    throttle.max_downloads.div._val
    throttle.max_downloads.div._val.set
    throttle.max_uploads
    throttle.max_uploads.set
    throttle.max_uploads.div
    throttle.max_uploads.div.set
    throttle.max_uploads.div._val
    throttle.max_uploads.div._val.set

        **TODO**

    throttle.max_downloads.global
    throttle.max_downloads.global.set
    throttle.max_downloads.global._val
    throttle.max_downloads.global._val.set
    throttle.max_uploads.global
    throttle.max_uploads.global.set
    throttle.max_uploads.global._val
    throttle.max_uploads.global._val.set

        **TODO**

    throttle.min_downloads
    throttle.min_downloads.set
    throttle.min_uploads
    throttle.min_uploads.set

        **TODO**

    throttle.max_peers.normal
    throttle.max_peers.normal.set
    throttle.max_peers.seed
    throttle.max_peers.seed.set
    throttle.min_peers.normal
    throttle.min_peers.normal.set
    throttle.min_peers.seed
    throttle.min_peers.seed.set

        **TODO**

    throttle.unchoked_downloads
    throttle.unchoked_uploads

        **TODO**

    throttle.ip

        .. code-block:: ini

            throttle.ip = ‹throttle name›, ‹IP or domain name› ≫ 0

        Throttle a specific peer by its IP address.

.. END cmd-bt

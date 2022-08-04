.. _dht-commands:

`dht.*` commands
^^^^^^^^^^^^^^^^

See the Github wiki for an example of `enabling DHT in rTorrent`_.

.. glossary::

    dht.add_node

        .. code-block:: ini

            dht.add_node = string ‹[host]:[port]› ≫ 0

        Adds a hostname/port to use for bootstrapping DHT information.

    dht.mode.set
    dht

        .. code-block:: ini

            dht.mode.set = string ‹mode› ≫ 0
            dht = string ‹mode› ≫ 0

        Controls when (if at all) DHT is activated. Regardless of what this is set to, DHT
        will never be used for torrents with the "private" flag enabled (see :term:`d.is_private`).
        ``dht`` is an alias for ``dht.mode.set``.

        Possible values are:

        * ``on`` – Start DHT immediately.
        * ``off`` – Do not start DHT.
        * ``auto`` – Start and stop DHT as needed.
        * ``disable`` – Completely disable DHT.

    dht.port
    dht.port.set
    dht_port

        .. code-block:: ini

            dht.port ≫ value ‹port›
            dht.mode.set = value ‹port› ≫ 0
            dht_port = value ‹port› ≫ 0

        Controls which port DHT will listen on. Note that ``dht_port`` is an alias for ``dht.port.set``,
        not ``dht.port``.

    dht.statistics

        Returns ``{'active': 0, 'dht': 'disable', 'throttle': ''}`` when DHT is off,
        and …

        **TODO**

    dht.throttle.name
    dht.throttle.name.set

        **TODO**

.. _`enabling DHT in rTorrent`: https://github.com/rakshasa/rtorrent/wiki/Common-Tasks-in-rTorrent#supporting-public-torrents-magnet-links-udp-trackers-dht

.. _pieces-commands:

`pieces.*` commands
^^^^^^^^^^^^^^^^^^^

.. glossary::

    pieces.hash.on_completion
    pieces.hash.on_completion.set

        .. code-block:: ini

            pieces.hash.on_completion ≫ bool (0 or 1)
            pieces.hash.on_completion.set = bool (0 or 1) ≫ 0

        When set to true, this triggers a full hash check after a torrent completes.
        This is not strictly necessary, as hashing already occurs as each piece is downloaded,
        and turning it off is recommended if you encounter bugs such as
        `completed torrents not announcing properly`_.

    pieces.hash.queue_size

        **TODO**

    pieces.memory.block_count

        .. code-block:: ini

            pieces.memory.block_count ≫ value ‹blocks›

        Returns the number of blocks *rTorrent* is tracking in memory. **TODO** What determines block size?

    pieces.memory.current

        .. code-block:: ini

            pieces.memory.current ≫ value ‹bytes›

        Returns the amount of memory *rTorrent* is currently using to track pieces which haven't yet been
        synced to a file.

    pieces.memory.max
    pieces.memory.max.set

        .. code-block:: ini

            pieces.memory.max ≫ value ‹bytes›
            pieces.memory.max.set = value ‹bytes› ≫ 0

        Controls the max amount of memory used to hold chunk information. By default this is set to 1/5
        of the available detected memory.

    pieces.memory.sync_queue

        .. code-block:: ini

            pieces.memory.sync_queue ≫ value ‹bytes›

        The amount of memory queued to be synced.

    pieces.preload.min_rate
    pieces.preload.min_rate.set
    pieces.preload.min_size
    pieces.preload.min_size.set

        .. code-block:: ini

            pieces.preload.min_rate ≫ value ‹bytes›
            pieces.preload.min_rate.set = ‹bytes› ≫ 0
            pieces.preload.min_size ≫ value ‹chunks›
            pieces.preload.min_size.set = ‹chunks› ≫ 0

        Preloading can be controlled to only activate when an item either reaches a certain rate
        of upload, and when the piece size is greater than a certain amount. Both conditions must be met
        in order for preloading to occur.

    pieces.preload.type
    pieces.preload.type.set

        .. code-block:: ini

             pieces.preload.type ≫ value ‹enum›
             pieces.preload.type.set = value ‹enum› ≫ 0

        When a piece is to be uploaded to a peer, *rTorrent* can preload the piece of the file before
        it does the non-blocking write to the network. This will not complete the whole piece
        if parts of the piece is not already in memory, having instead to try again later.

        Possible values for ``value`` are:

        * ``0`` – off
        * ``1`` – madvise
        * ``2`` – direct page

        Off means it doesn't do any preloading at all.

        `madvise` means it calls `madvise`_ on the file for the specific ``mmap``'ed memory range,
        which tells the kernel to load it in memory when it gets around to it.
        Which is hopefully before `rTorrent` writes to the network socket.

        Direct paging means it touches each file page in order to force the kernel to load it into
        memory. This can help if you're dealing with very large number of peers and large/many files,
        especially in a low-memory setting, as you can avoid thrashing the disk where loaded file
        pages get thrown out before they manage to get sent.

        |    *Adapted from*
        |    https://github.com/rakshasa/rtorrent/issues/418#issuecomment-211335027

    pieces.stats_not_preloaded
    pieces.stats_preloaded

        .. code-block:: ini

             pieces.stats_not_preloaded ≫ value ‹num›
             pieces.stats_preloaded ≫ value ‹num›

        This counts the number of pieces that were preloaded or not, as per :term:`pieces.preload.min_size`
        and :term:`pieces.preload.min_rate`. If :term:`pieces.preload.type` is set to ``0``,
        all pieces will be marked as ``not_preloaded``.

    pieces.stats.total_size

        .. code-block:: ini

            pieces.stats.total_size ≫ value ‹bytes›

        Returns the total cumulative size of all files in all items. This includes incomplete files
        and does not consider duplicates, so it will often be larger than the sum of all
        the files as they exist on the disk.

    pieces.sync.always_safe
    pieces.sync.always_safe.set

        .. code-block:: ini

            pieces.sync.always_safe ≫ bool (0 or 1)
            pieces.sync.always_safe.set = bool (0 or 1) ≫ 0

        When safe sync is enabled, each chunk is synced to the file synchronously, which is
        slightly slower but ensures that the file has been written correctly.

    pieces.sync.queue_size

        .. code-block:: ini

            pieces.sync.queue_size ≫ value ‹chunks›

        The number of chunks that are queued up for writing in memory (i.e. not written
        to a file yet).

    pieces.sync.safe_free_diskspace

        .. code-block:: ini

            pieces.sync.safe_free_diskspace ≫ value ‹bytes›

        If :term:`d.free_diskspace` ever drops below this value, all chunks will behave as though
        :term:`pieces.sync.always_safe` is set to true. This is set to :term:`pieces.memory.current`
        \+ 512 MiB.

    pieces.sync.timeout
    pieces.sync.timeout.set

        .. code-block:: ini

            pieces.sync.timeout ≫ value ‹seconds›
            pieces.sync.timeout.set = value ‹seconds› ≫ 0

        If the piece hasn't been synced within this time period, immediately mark it for
        syncing.

    pieces.sync.timeout_safe
    pieces.sync.timeout_safe.set

        .. code-block:: ini

            pieces.sync.timeout_safe ≫ value ‹seconds›
            pieces.sync.timeout_safe.set = value ‹seconds› ≫ 0

        **TODO** This does not appear to be in use.

.. _`madvise`: https://man7.org/linux/man-pages/man2/madvise.2.html
.. _`completed torrents not announcing properly`: https://github.com/rakshasa/rtorrent/issues/437

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

        .. code-block:: ini

            protocol.encryption.set = string ‹flags› ≫ 0

        This command takes a comma-separated list of flags, as seen in :term:`strings.encryption`,
        and uses them to determine how to handle connections to other peers (i.e. tracker and DHT
        connections are not effected by this setting). The flags are all applied simultaneously, which
        means that certain applied flags may not take effect (e.g. for ``prefer_plaintext,require_rc4``,
        plaintext will never used despite the flag being applied). rTorrent has support for both
        plaintext "encryption" (uses no extra CPU cycles, provides only obfuscation of the header) and
        RC4 encryption (encrypts the entire header and message, at the cost of a few CPU cycles),
        with flags to control the behavior of both.

        * ``none`` – The default, don't attempt any encryption.
        * ``allow_incoming`` – Allow incoming encrypted connections from other peers.
        * ``try_outgoing`` – Attempt to set up encryption when initiating a connection.
        * ``require`` – Require encryption, and reject peers who don't support it.
        * ``require_RC4`` – Require RC4 encryption specifically.
        * ``require_rc4`` – Same as above.
        * ``enable_retry`` – If a peer is rejected for not supporting the encryption we need, retry the handshake.
        * ``prefer_plaintext`` – Prefer plaintext encryption.

        See `BitTorrent protocol encryption`_ for more information.


    protocol.pex
    protocol.pex.set

        .. code-block:: ini

            protocol.pex ≫ bool (0 or 1)
            protocol.pex.set = bool (0 or 1) ≫ 0

        Controls whether `peer exchange`_ is enabled.

.. _`peer exchange`: https://en.wikipedia.org/wiki/Peer_exchange

.. _`BitTorrent protocol encryption`: https://en.wikipedia.org/wiki/BitTorrent_protocol_encryption


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

    throttle.names

        .. code-block:: ini

            # rTorrent-PS 1.1+ only
            throttle.names= ≫ array ‹names›

        Returns a list of all defined throttle names,
        including the built-in ones (i.e. ``''`` and ``'NULL'``).

        Example:

        .. code-block:: console

            $ rtxmlrpc --repr throttle.names
            ['', 'NULL', 'kb500', 'lo_up', 'onemb']

.. END cmd-bt

.. _d-commands:

`d.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

All ``d.*`` commands take an info hash as the first argument when called over the XML-RPC API,
to uniquely identify the *target* object. ‘Target’ is the term used for that 1st parameter in
error messages and so on.

  .. code-block:: ini

     d.name = ‹hash› ≫ string ‹name›

When called within configuration methods or in a ``Ctrl-X`` prompt, the target is implicit.


.. glossary::

    d.multicall2
    d.multicall.filtered
    download_list

        .. rubric:: *'d.multicall.filtered' is rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.multicall2 = '', ‹view›, [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ list of lists of results ‹rows of results›
            d.multicall.filtered = ‹view›, ‹predicate›, [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ same as 'multicall2'
            download_list = ‹view› ≫ list of strings ‹info hashes›

        These commands iterate over the content of a given view,
        or ``default`` when the view is omitted or empty.
        ``download_list`` always just returns a list of the contained infohashes.

        ``d.multicall2`` iterates over all items in ``view`` and calls the given commands on each,
        assembling the results of those calls in a row per item.
        Typically, the given commands either just have a side effect (e.g. :term:`d.stop`),
        or return some item attribute (e.g. :term:`d.name`).
        The first argument is always an empty string.

        ``d.multicall.filtered`` is only available in *rTorrent-PS*,
        and evaluates the ``predicate`` condition as a filter for each item,
        only calling the commands for items that match it.
        See :term:`elapsed.greater` for an example.

        If you request a lot of attribute values on *all* items,
        make sure you set a big enough value for :term:`network.xmlrpc.size_limit`
        to hold all the returned data serialized to XML.
        It is also valid to pass no commands at all to ``d.multicall2``, but all you get from that
        is a list of empty lists.

        .. rubric:: Example

        .. code-block:: console

            $ rtxmlrpc --repr d.multicall2 '' tagged d.hash= d.name= d.custom=category
            [['91C588B9A9B5A71F0462343BC74E2A88C1E0947D',
              'sparkylinux-4.0-x86_64-lxde.iso',
              'Software'],
             ['17C14214B60B92FFDEBFB550380ED3866BF49691',
              'sparkylinux-4.0-x86_64-xfce.iso',
              'Software']]

            $ rtxmlrpc --repr download_list '' tagged
            ['91C588B9A9B5A71F0462343BC74E2A88C1E0947D',
             '17C14214B60B92FFDEBFB550380ED3866BF49691']


    d.name
    d.base_filename
    d.base_path
    d.directory
    d.directory.set
    d.directory_base
    d.directory_base.set

        .. code-block:: ini

            d.name = ‹hash› ≫ string ‹name›
            d.base_filename = ‹hash› ≫ string ‹basename›
            d.base_path = ‹hash› ≫ string ‹path›
            d.directory = ‹hash› ≫ string ‹path›
            d.directory_base = ‹hash› ≫ string ‹path›
            d.directory.set = ‹hash›, ‹path› ≫ 0
            d.directory_base.set = ‹hash›, ‹path› ≫ 0

        These commands return various forms of an item's data path and name,
        and the last two can change the path, and sometimes the name in the file system.
        Note that *rTorrent-PS* can also change the displayed name,
        by setting the ``displayname`` custom attribute using :term:`d.custom.set`.

        Basics:

            * ``d.base_filename`` is always the basename of ``d.base_path``.
            * ``d.directory_base`` and ``d.directory`` are always the same.
            * ``d.base_filename`` and ``d.base_path`` are empty on closed items,
              after a restart, i.e. not too useful (since 0.9.1 or so).

        Behaviour when ``d.directory.set`` + ``d.directory_base.set`` are used (tested with 0.9.4):

            * ``d.base_path`` always remains unchanged, and item gets closed.
            * ``d.start`` sets ``d.base_path`` if resume data is OK.
            * ‘single’ file items (no containing folder, see :term:`d.is_multi_file`):

                * ``d.directory[_base].set`` → ``d.name`` is **never** appended (only in ``d.base_path``).
                * after start, ``d.base_path`` := ``d.directory/d.name``.

            * ‘multi’ items (and yes, they can contain just one file):

                * ``d.directory.set`` → ``d.name`` is appended.
                * ``d.directory_base.set`` → ``d.name`` is **not** appended
                  (i.e. item renamed to last path part).
                * after start, ``d.base_path`` := ``d.directory``.

        Making sense of it (trying to at least):

            * ``d.directory`` is *always* a directory (thus, single items
              auto-append ``d.name`` in ``d.base_path`` and cannot be renamed).
            * ``d.directory_base.set`` means set path **plus** basename together
              for a multi item (thus allowing a rename).
            * only ``d.directory.set`` behaves consistently for single+multi,
              regarding the end result in ``d.base_path``.

        The definition below is useful, since it *always* contains a valid path to an item's data,
        and can be used in place of the unreliable ``d.base_path``.

        .. code-block:: ini

            # Return path to item data (never empty, unlike `d.base_path`);
            # multi-file items return a path ending with a '/'.
            method.insert = d.data_path, simple,\
                "if=(d.is_multi_file),\
                    (cat, (d.directory), /),\
                    (cat, (d.directory), /, (d.name))"

    d.state
    d.state_changed
    d.state_counter
    d.is_open
    d.is_active

        .. code-block:: ini

            d.state = ‹hash› ≫ bool (0 or 1)
            d.state_changed = ‹hash› ≫ value ‹timestamp›
            d.state_counter = ‹hash› ≫ value ‹count›
            d.is_open = ‹hash› ≫ bool (0 or 1)
            d.is_active = ‹hash› ≫ bool (0 or 1)

        These commands return the item's state (1 = started or paused, 0 = stopped),
        when that changed the last time, and how often it did change.
        Note that although pausing / resuming a started item does not change ``state``,
        the timestamp and counter are.

        In summary:

        * Closed items are *not* ``open``, with ``state=0``.
        * Paused items are ``open``, but *not* ``active``, with ``state=1``.
        * Started items are both ``open`` and ``active``, with ``state=1``.

        The three state values are persisted to the session, while ``active`` (paused) is not.
        See :ref:`faq-stop-using-sed` on how you can use that to influence the startup
        behaviour of rTorrent.

    d.open
    d.close
    d.pause
    d.resume
    d.close.directly
    d.try_close

        **TODO**

    d.start
    d.stop
    d.try_start
    d.try_stop

        Starts or stops an item, including everything that needs to be done for that.
        For starting, that includes hashing the data if it already exists.
        On stop, incomplete chunks are discarded as part of the stop.

        The ``try`` variants look at the :term:`d.ignore_commands` flag
        and thus only conditionally start/stop the item.

    d.loaded_file
    d.tied_to_file
    d.tied_to_file.set

        ``d.loaded_file`` is the metafile from which this item was created.
        After loading from a watch directory, this points to that watch directory,
        but after a client restart it is the session file
        (since the item is then loaded from there).

        ``d.tied_to_file`` also starts out as the file the item is initially created from,
        but can be set to arbitrary values, and an item can be *untied* using :term:`d.delete_tied`,
        leading to an empty value and the deletion of the tied file.

        One of the :term:`stop_untied`, :term:`close_untied`, or :term:`remove_untied` commands
        can then be used in a schedule to stop, close, or remove an item that lost its tied file,
        including when you delete or move it from the outside in a shell or cron job.


    d.accepting_seeders
    d.accepting_seeders.disable
    d.accepting_seeders.enable

       .. code-block:: ini

            d.accepting_seeders = ‹hash› ≫ bool (0 or 1)
            d.accepting_seeders.disable = ‹hash› ≫ 0
            d.accepting_seeders.enable = ‹hash› ≫ 0

       Controls whether or not new connections to seeders are sought out. Existing connections
       are not effected.


    d.bitfield

        .. code-block:: ini

            d.bitfield = ‹hash› ≫ string ‹bitfield›

        Returns the bitfield represented by a string of hexadecimal digits, with each character
        representing the "completeness" of each field. Note that due to rounding inaccuracies,
        the number of fields with likely neither align exactly with the number of chunks nor number of
        bytes.


    d.bytes_done

        .. code-block:: ini

            d.bytes_done = ‹hash› ≫ value ‹bytes›

        This tracks the amount of bytes for a torrent which has been accepted from peers.
        Note that bytes aren't considered to be "completed" until the full chunk is
        downloaded and verified. See :term:`d.completed_bytes` for that value.
        See also :term:`d.left_bytes` for the number of bytes yet to be accepted.


    d.check_hash

        .. code-block:: ini

            d.check_hash = ‹hash› ≫ 0

        Checks the piece hashes of an item against its data.
        Started items are paused during the rehashing.


    d.chunk_size

        .. code-block:: ini

            d.chunk_size = ‹hash› ≫ value ‹size›

        Returns the item's chunk size in bytes (also known as the “piece size”).


    d.chunks_hashed

        .. code-block:: ini

            d.chunks_hashed = ‹hash› ≫ value ‹chunks›

        While a torrent is hash checking, this tracks the number of chunks that have
        successfully hashed.

    d.chunks_seen

        **TODO**

    d.complete
    d.incomplete

        .. code-block:: ini

            d.complete = ‹hash› ≫ bool (0 or 1)
            d.incomplete = ‹hash› ≫ bool (0 or 1)

        Indicates whether an item is complete (100% done) or not.


    d.completed_bytes
    d.completed_chunks

        .. code-block:: ini

            d.completed_bytes = ‹hash› ≫ value ‹bytes›
            d.completed_chunks = ‹hash› ≫ value ‹chunks›

        Returns the number of completed bytes and chunks, respectively.
        "Completed" means the bytes/chunk has been downloaded and verified against the hash.


    d.connection_current
    d.connection_current.set
    d.connection_leech
    d.connection_seed

        **TODO**

    d.create_link
    d.delete_link

        **TODO**


    d.delete_tied

        .. code-block:: ini

            d.delete_tied = ‹hash› ≫ 0

        Delete the :term:`d.tied_to_file`, which obviously also unties the item.
        This command is bound to the ``U`` key by default, and also called whenever
        an item is erased.

        .. rubric:: Example

        .. code-block:: ini

            # Delete metafile from a watch dir directly after loading it
            # (note that a copy still remains in the session directory)
            schedule2 = watch_cleaned, 29, 10, \
                ((load.normal, (cat,(cfg.watch),"cleaned/*.torrent"), "d.delete_tied="))


    d.creation_date

        .. code-block:: ini

            d.creation_date = ‹hash› ≫ value ‹timestamp›

        Returns a timestamp reflecting the .torrent file creation date (i.e. separate
        from the date the item was loaded into the client). This value can be inspected with
        tools like `lstor`_:

        .. code-block:: console

            $ lstor -o 'creation date' file.torrent
            1480229112

        **TODO** What does this return for magnet files?


    d.custom
    d.custom.set
    d.custom_throw
    d.custom1
    d.custom1.set
    d.custom2…5
    d.custom2…5.set

        .. code-block:: ini

            d.custom[_throw] = ‹hash›, string ‹key› ≫ string ‹value›
            d.custom.set = ‹hash›, string ‹key›, string ‹value› ≫ 0
            d.custom1 = ‹hash› ≫ string ‹value›
            d.custom1.set = ‹hash›, string ‹value› ≫ 0

        Set and return custom values using either arbitrary keys, or a limited set of 5 numbered slots.
        Note that ``d.custom1`` is *not* the same as ``d.custom=1`` or ``d.custom=custom1``,
        and can only be accessed by its assigned commands.

        If ``d.custom`` is called for a key that doesn't exist,
        it will return an empty string, unlike ``d.custom_throw`` which
        throws a ``No such custom value`` error.

        Try to avoid the numbered versions, they're obviously limited,
        and collisions with other uses are quite likely. *ruTorrent* for example
        uses #1 for its label, and the other slots for various other purposes.

        .. warning::

            **Never** add spaces after the key when using new syntax,
            i.e. ``(d.custom, bugfest  )`` will look for the ``bugfest␣␣`` key.


    d.custom.if_z

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.if_z = ‹hash›, string ‹key›, string ‹default› ≫ string ‹value›

        Just like :term:`d.custom`, but returns the `‹default›` value if the `‹key›` does not exist,
        or if its value is empty.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/custom.txt
            :language: console
            :start-at: # d.custom.if_z
            :end-before: # END


    d.custom.set_if_z

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.set_if_z = ‹hash›, string ‹key›, string ‹value› ≫ 0

        This is a companion to :term:`d.custom.if_z` and sets a custom value only once,
        if it was missing or empty previously.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/custom.txt
            :language: console
            :start-at: # d.custom.set_if_z
            :end-before: # END


    d.custom.erase

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.erase = ‹hash›, string ‹key›[, …] ≫ 0

        Removes the given custom key(s) – erasing non-existent keys is not an error.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/custom.txt
            :language: console
            :start-at: # d.custom.erase
            :end-before: # END


    d.custom.toggle

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.toggle = ‹hash›, string ‹key› ≫ value ‹negated›

        Inverts the truthiness of a custom attribute using ``0`` or ``1`` as the only results.
        Empty strings and ``0`` become ``1``, and any other string becomes ``0``.

        It also returns the current *value* that was set (as in the *value type*, i.e. as an integer).

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/custom.txt
            :language: console
            :start-at: # d.custom.toggle
            :end-before: # END


    d.custom.as_value

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.as_value = ‹hash›, string ‹key› ≫ value ‹number›

        Returns a custom attribute as a *value* (base 10 integer).
        Missing keys and empty strings are ``0``,
        while non-numbers raise an exception.

        Major use-cases of this are custom timestamp fields, and querying toggles (see :term:`d.custom.toggle`).

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/custom.txt
            :language: console
            :start-at: # d.custom.as_value
            :end-before: # END


    d.custom.keys

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.keys = ‹hash› ≫ list of string ‹defined keys›

        Returns a list of custom keys that are defined for an item.

        .. rubric:: Example

        .. code-block:: console

            $ rtxmlrpc --repr d.custom.keys $(rtxmlrpc download_list | head -n1) | tr -d \\n
            [… 'tm_downloaded', 'tm_last_scrape', 'tm_loaded', 'tm_started']


    d.custom.items

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.custom.items = ‹hash› ≫ map of key / value strings ‹defined items›

        Returns keys and their associated values, for all custom values of an item.

        .. rubric:: Example

        .. code-block:: console

            $ rtxmlrpc --repr d.custom.items $(rtxmlrpc download_list | head -n1)
            {…
             'tm_downloaded': '1522406424',
             'tm_last_scrape': '1527931151',
             'tm_loaded': '1522406432',
             'tm_started': '1522406432'}


    d.disconnect.seeders

        .. code-block:: ini

            d.disconnect.seeders = ‹hash› ≫ 0

        Cleanly drop all connections to seeders. This does not prevent them from
        reconnecting later on.

    d.down.choke_heuristics
    d.down.choke_heuristics.leech
    d.down.choke_heuristics.seed
    d.down.choke_heuristics.set

        **TODO**


    d.down.rate
    d.down.total

        .. code-block:: ini

            d.down.rate = ‹hash› ≫ value ‹rate [bytes/s]›
            d.down.total = ‹hash› ≫ value ‹total [bytes]›

        The total amount and current rate of download traffic for this item.
        It's possible for the total download to be greater than :term:`d.size_bytes`,
        due to error correction or discarded data.


    d.downloads_max
    d.downloads_max.set
    d.downloads_min
    d.downloads_min.set

        .. code-block:: ini

            d.downloads_max = ‹hash› ≫ value ‹max›
            d.downloads_max.set = ‹hash›, value ‹max› ≫ 0
            d.downloads_min = ‹hash› ≫ value ‹max›
            d.downloads_min.set = ‹hash›, value ‹max› ≫ 0

        Control the maximum and minimum download slots that should be used per item.
        *rTorrent* will attempt to balance the number of active connections so that
        the number of unchoked connections is between the minimum and maximum,
        which means that these are not hard limits, but are instead goals that *rTorrent* will try to reach.

        ``0`` means unlimited, and while ``d.downloads_max`` can be set to less than
        ``d.downloads_min``, *rTorrent* will then use ``d.downloads_min`` as the maximum instead.


    d.erase

        **TODO**

    d.free_diskspace

        .. code-block:: ini

            d.free_diskspace = ‹hash› ≫ value ‹bytes›

        Return the *minimum* free space of devices where files of the item reside on.
        In the usual case without symlinks and the like, it's the free space of the drive
        holding :term:`d.directory`.


    d.group
    d.group.name
    d.group.set

        **TODO**

    d.hash

       .. code-block:: ini

            d.hash = ‹hash› ≫ string ‹hash›

       Returns the hash of the torrent in hexadecimal form, with uppercase letters.
       The most common use is in the command list of a :term:`d.multicall2`,
       to return the hash in a list of results.
       It can also be used to check if a hash already exists in the client
       – while most other getters can serve the same purpose, this is the obvious one to use for that.

       If you are looking to cause a hash check, see :term:`d.check_hash`.


    d.hashing

       .. code-block:: ini

            d.hashing = ‹hash› ≫ value ‹hash_status›

       Returns an integer denoting the state of the hash process. The possible values are:

       * ``0`` – No hashing is happening.
       * ``1`` – The very first hash check is occurring.
       * ``2`` – If :term:`pieces.hash.on_completion` is enabled, the torrent is in the
         middle of hashing due to the finish event, and at the end, will be checked for completeness.
       * ``3`` – A rehash is occurring (i.e. the torrent has already been marked as complete once).

       See also :term:`d.is_hash_checking`.

    d.hashing_failed
    d.hashing_failed.set

       .. code-block:: ini

            d.hashing_failed = ‹hash› ≫ bool (0 or 1)
            d.hashing_failed.set = ‹hash›, bool (0 or 1) ≫ 0

       Checks to see if the hashing has failed or not. This flag is primarily used to determine
       whether or not a torrent should be marked for hashing when it's started/resumed.

    d.ignore_commands
    d.ignore_commands.set

        .. code-block:: ini

            d.ignore_commands = ‹hash› ≫ bool (0 or 1)
            d.ignore_commands.set = ‹hash›, bool (0 or 1) ≫ 0

        The ignore flag controls the :term:`d.try_close`, :term:`d.try_start`, and :term:`d.try_stop`
        commands, and if set to true exclude the item at hand from reacting to those commands.

        One use of that is being able to exclude items from ratio control, if you use the ``try``
        versions in :term:`group.seeding.ratio.command` definitions.

    d.is_hash_checked
    d.is_hash_checking

        .. code-block:: ini

            d.is_hash_checked = ‹hash› ≫ bool (0 or 1)
            d.is_hash_checking = ‹hash› ≫ bool (0 or 1)

        These mark the hashing state of a torrent. ``d.is_hash_checked`` is counter-intuitive in that
        regardless of how much the torrent has successfully completed hash checking, if a torrent is active
        and is not in the middle of hashing (i.e. ``d.is_hash_checking`` returns ``0``), it will always
        return ``1``.

    d.is_meta

        .. rubric:: *since rTorrent-PS 1.1 / rTorrent 0.9.7*

        .. code-block:: ini

            d.is_meta = ‹hash› ≫ bool (0 or 1)

        Meta torrents refer to magnet torrents which are still in the process of gathering data from trackers/peers.
        Once enough data is collected, the meta torrent is removed and a "regular" torrent is created. Since meta
        torrents lack certain data fields, this is useful for filtering them out of commands that don't play well with them.

    d.is_multi_file

        .. code-block:: ini

            d.is_multi_file = ‹hash› ≫ bool (0 or 1)

        Returns ``1`` if the torrents is marked as having multiple files, ``0`` if it's a single file.
        Note that multifile-marked torrents are able to only have 1 actual file in them. See :term:`d.size_files`
        for returning the number of files in an item.


    d.is_not_partially_done
    d.is_partially_done

        **TODO**


    d.is_pex_active

        .. code-block:: ini

            d.is_pex_active = ‹hash› ≫ bool (0 or 1)

        Return whether `PEX`_ is active for this item.
        See :term:`protocol.pex` to determine if PEX is active globally.


    d.is_private

        .. code-block:: ini

            d.is_private = ‹hash› ≫ bool (0 or 1)

        Indicates if the private flag is set. If it is, the client will not attempt to find new peers
        in addition to what a tracker returned (i.e. PEX and DHT are inactive).


    d.left_bytes

        .. code-block:: ini

            d.left_bytes = ‹hash› ≫ value ‹bytes›

        Tracks the number of bytes that have yet to be downloaded. See :term:`d.bytes_done` for the
        inverse value, e.g. ``d.left_bytes`` plus :term:`d.bytes_done` will always equal :term:`d.size_bytes`.


    d.load_date

        .. code-block:: ini

            d.load_date = ‹hash› ≫ value ‹time›

        Returns the timestamp of when the torrent was loaded into the client. This is the value used when comparing
        fast-resume data against the actual files. Note that all torrents are considered to be newly loaded when
        pulled from the session directory, so this value will update every time *rTorrent* is restarted.


    d.local_id
    d.local_id_html

        .. code-block:: ini

            d.local_id = ‹hash› ≫ string ‹ID›
            d.local_id_html = ‹hash› ≫ string ‹ID›

        Returns the peer ID assigned to this item. This is the same value that is sent to the tracker when
        announces are done. ``d.local_id`` returns a hex string, while ``d.local_id_html`` returns the value
        `percent encoded`_. See :term:`p.id` to find this value for remote peers.


    d.max_file_size
    d.max_file_size.set

        .. code-block:: ini

            d.max_file_size = ‹hash› ≫ value ‹bytes›
            d.max_file_size.set = ‹hash›, value ‹bytes› ≫ 0

        Controls the maximum size of any file in the item.
        If a file exceeds this amount, the torrent cannot be opened and an error will be shown.
        Defaults to the value of :term:`system.file.max_size` at the time the torrent is added.


    d.max_size_pex

        **TODO**


    d.message
    d.message.set
    d.message.alert

        .. rubric:: *d.message.alert is rTorrent-PS 1.1+ only*

        .. code-block:: ini

            d.message = ‹hash› ≫ string ‹message›
            d.message.set = ‹hash›, string ‹message› ≫ 0
            d.message.alert = ‹hash› ≫ value ‹category›

        Used to store messages relating to the item, such as errors
        in communicating with the tracker or a hash check failure.

        The ``d.message.alert`` command returns an enum categorizing messages into classes,
        used for the configurable canvas of `rTorrent-PS`:

            * ``␣`` 0 *ALERT_NORMAL*
            * ``♺`` 1 *ALERT_NORMAL_CYCLING* (Tried all trackers)
            * ``⚠`` 2 *ALERT_GENERIC*
            * ``◔`` 3 *ALERT_TIMEOUT*
            * ``⚡`` 4 *ALERT_CONNECT*
            * ``↯`` 5 *ALERT_REQUEST*
            * ``¿?`` 6 *ALERT_GONE*
            * ``⨂`` 7 *ALERT_PERMS*

    d.mode

        **TODO**: Does not appear to be functional, only throws
        ``Object operator [mode] could not find element``.

    d.peer_exchange
    d.peer_exchange.set

        .. code-block:: ini

            d.peer_exchange = ‹hash› ≫ bool (0 or 1)
            d.peer_exchange.set = ‹hash›, bool (0 or 1) ≫ 0

        Determines if `PEX`_ is enabled for this item. By default this is set to the value of
        :term:`protocol.pex`.

    d.peers_accounted
    d.peers_complete
    d.peers_connected

        **TODO**

    d.peers_max
    d.peers_max.set
    d.peers_min
    d.peers_min.set
    d.peers_not_connected

        **TODO**

    d.priority
    d.priority.set
    d.priority_str

        .. code-block:: ini

            d.priority = ‹hash› ≫ value ‹prio›
            d.priority.set = ‹hash›, value ‹prio› ≫ 0
            d.priority_str = ‹hash› ≫ string ‹name›

        Controls the priority of the item. The possible settings (and the associated value)
        are as follows:

        * ``0`` – off
        * ``1`` – low
        * ``2`` – normal
        * ``3`` – high

    d.ratio

        Returns the current upload/download ratio of the torrent.
        This is the amount of uploaded data divided by the completed bytes multiplied by 1000.
        If no bytes have been downloaded, the ratio is considered to be ``0``.


    d.save_full_session

        Flushes the item's state to files in the session directory (if enabled).
        This writes *all* files that contribute to an item's state, i.e. the ‘full’ state.

        See also :term:`session.save` and :term:`d.save_resume` below.


    d.save_resume

        Similar to :term:`d.save_full_session`, but skips writing the original metafile,
        only flushing the data in the ``*.libtorrent_resume`` and ``*.rtorrent`` files.

        The new data is written to ``*.new`` files and afterwards renamed, if writing
        those files succeeded.


    d.size_bytes
    d.size_chunks
    d.size_files
    d.size_pex

        .. code-block:: ini

            d.size_bytes = ‹hash› ≫ value ‹bytes›
            d.size_chunks = ‹hash› ≫ value ‹chunks›
            d.size_files = ‹hash› ≫ value ‹files›
            d.size_pex = ‹hash› ≫ value ‹peers›

        Returns the various size attributes of an item.

        * **bytes** – The total number of bytes in the item's files.
        * **chunks** – The number of chunks, including the trailing chunk.
        * **files** – The number of files (does not include directories).
        * **pex** – The number of peers that were reported via the PEX extension.
          If :term:`d.is_pex_active` is false, this will be always be 0.

    d.skip.rate
    d.skip.total

        .. code-block:: ini

            d.skip.rate = ‹hash› ≫ value ‹rate›
            d.skip.total = ‹hash› ≫ value ‹total›

        Skipped pieces are ones that were received from peers, but weren't needed and thus ignored.
        These values are part of the main download statistics, i.e. :term:`d.down.rate` and :term:`d.down.total`.


    d.throttle_name
    d.throttle_name.set

        **TODO**

    d.timestamp.finished
    d.timestamp.started

        .. code-block:: ini

            d.timestamp.finished = ‹hash› ≫ value ‹epoch›
            d.timestamp.started = ‹hash› ≫ value ‹epoch›

        Returns the time (as an `epoch <https://en.wikipedia.org/wiki/Unix_time>`_ integer) the item was finished or started.
        These values are set when :term:`event.download.finished` and :term:`event.download.resumed` are triggered,
        respectively. If :term:`event.download.finished` has not triggered yet, :term:`d.timestamp.finished` will return 0.


    d.tracker.insert

        .. code-block:: ini

            d.tracker.insert = ‹hash›, value ‹group›, string ‹url› ≫ 0

        Inserts a tracker into a tracker group. A tracker group can be numbered from 0-32, and consists of multiple URLs.


    d.tracker.send_scrape

        .. code-block:: ini

            d.tracker.send_scrape = ‹hash›, value ‹delay› ≫ 0

        Manually triggers a `scrape request`_ after ``delay`` seconds. See `auto-scrape.rc`_ for an automated *rTorrent* scraping
        system.


    d.tracker_announce

        .. code-block:: ini

            d.tracker_announce = ‹hash› ≫ 0

        Manually triggers a tracker announce.


    d.tracker_focus
    d.tracker_size

        .. code-block:: ini

            d.tracker_focus = ‹hash› ≫ value ‹num›
            d.tracker_size = ‹hash› ≫ value ‹num›

        Returns the number of trackers assigned to the torrent.


    d.tracker_numwant
    d.tracker_numwant.set

        .. code-block:: ini

            d.tracker_numwant = ‹hash› ≫ value ‹numwant›
            d.tracker_numwant.set = ‹hash›, value ‹numwant› ≫ 0

        Controls the `optional numwant parameter`_ sent to the tracker. By default it's set to ``-1``, and *rTorrent*
        only sends ``numwant`` if it is greater than 0.


    d.up.choke_heuristics
    d.up.choke_heuristics.set
    d.up.choke_heuristics.leech
    d.up.choke_heuristics.seed
    d.up.choke_heuristics.leech.set
    d.up.choke_heuristics.seed.set

        **TODO**

        ``d.up.choke_heuristics.leech.set`` and ``d.up.choke_heuristics.seed.set`` are *private*.


    d.up.rate
    d.up.total

        .. code-block:: ini

            d.up.rate = ‹hash› ≫ value ‹rate [bytes/s]›
            d.up.total = ‹hash› ≫ value ‹total [bytes]›

        The total amount and current rate of upload traffic for this item.


    d.update_priorities

        .. code-block:: ini

            d.update_priorities = ‹hash› ≫ 0

        After a scripted change to priorities using :term:`f.priority.set`,
        this command **must** be called. It updates the internal state of a
        download item based on the new priority settings.


    d.uploads_max
    d.uploads_max.set
    d.uploads_min
    d.uploads_min.set

        .. code-block:: ini

            d.uploads_max = ‹hash› ≫ value ‹max›
            d.uploads_max.set = ‹hash›, value ‹max› ≫ 0
            d.uploads_min = ‹hash› ≫ value ‹min›
            d.uploads_min.set = ‹hash›, value ‹min› ≫ 0

        Control the maximum and minimum upload slots that should be used.
        *rTorrent* will attempt to balance the number of active connections so that
        the number of unchoked connections is between the given minimum and maximum.

        ``0`` means unlimited, and when ``d.uploads_max`` is less than ``d.uploads_min``,
        *rTorrent* will use ``d.uploads_min`` as the maximum instead.

    d.views
    d.views.has
    d.views.push_back
    d.views.push_back_unique
    d.views.remove

        **TODO**

    d.wanted_chunks

        .. code-block:: ini

            d.wanted_chunks = ‹hash› ≫ value ‹chunks›

        The number of chunks *rTorrent* wants to download. Contrast with :term:`d.completed_chunks`,
        although ``d.wanted_chunks`` will not count chunks from files prioritized as "off" as wanted. See
        :term:`f.priority` for commands relating to file prioritization.


    d.tracker_alias
    d.tracker_domain

        .. rubric:: *rTorrent-PS only*

        ``d.tracker_domain`` returns a shortened version of the domain in the tracker's URL,
        for a given download item.
        The chosen tracker is the first HTTP one with active peers (seeders or leechers),
        or else the first one.

        ``d.tracker_alias`` (1.1+ only) is basically the same,
        but uses the mappings defined by :term:`trackers.alias.set_key` to transform its return value.
        The main use-case for that is to be able to sort the `rTorrent-PS` ``trackers`` view
        by the same values as shown to the very right of the terminal.

        But you can also use it in a :term:`d.multicall.filtered` command together with :term:`string.equals`,
        to easily select items of one or more specified tracker(s).

        .. rubric:: Examples

        .. code-block:: ini

            # Trackers view (all items, sorted by tracker domain and then name).
            # This will ONLY work if you use rTorrent-PS!
            view.add          = trackers
            view.sort_new     = trackers, "compare=,d.tracker_alias=,d.name="
            view.sort_current = trackers, "compare=,d.tracker_alias=,d.name="

        .. code-block:: console

            $ rtxmlrpc d.multicall.filtered '' 'string.equals=(d.tracker_alias),Linux,Debian' \
                       d.tracker_domain= d.name=
            ['linuxtracker.org', 'Container Linux 1745.7.0.iso']
            ['linuxtracker.org', 'robolinux64-mate3d-v9.3.iso']
            ['bttracker.debian.org', 'debian-9.4.0-amd64-netinst.iso']


    d.tracker_scrape.complete
    d.tracker_scrape.downloaded
    d.tracker_scrape.incomplete

        .. rubric:: *rTorrent-PS 1.1+ only*

        **TODO**


.. _`scrape request`: https://en.wikipedia.org/wiki/Tracker_scrape

.. _`optional numwant parameter`: https://wiki.theory.org/index.php/BitTorrentSpecification#Tracker_Request_Parameters

.. _`PEX`: https://en.wikipedia.org/wiki/Peer_exchange

.. _`lstor`: https://pyrocore.readthedocs.io/en/latest/usage.html#lstor

.. _f-commands:

`f.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

These commands can be used as arguments in a :term:`f.multicall`.
They can also be called directly, but you need to pass `‹infohash›:f‹index›` as the first argument.
Index counting starts at ``0``, the array size is :term:`d.size_files`.

.. rubric:: Example

.. code-block:: console

    $ rtxmlrpc --repr f.multicall "145B85116626651912298F9400805254FB1192AE" "" f.path=
    [['ubuntu-16.04.3-server-amd64.iso']]

    $ rtxmlrpc --repr f.size_bytes "145B85116626651912298F9400805254FB1192AE:f0"
    865075200


.. glossary::

    f.multicall

        .. code-block:: ini

            f.multicall = ‹infohash›, ‹pattern›, [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ list of lists of results ‹rows of results›

        Iterates over the files in an item, calling the given ``f.*`` commands.
        The second argument, if non-empty, is a glob-like pattern (e.g. ``*.mkv``) and
        filters the result for matching filenames. That pattern matching is very simplistic,
        be cautious and test that you get the results you expect.

        See also :term:`d.multicall2` on basics regarding multi-calls.

    f.completed_chunks

        .. code-block:: ini

            f.completed_chunks = ‹infohash› ≫ value ‹chunks›

        The number of chunks in the file completed. Just as with :term:`f.size_chunks`, this number is
        inclusive of any chunks that contain only part of the file.

    f.frozen_path

        .. code-block:: ini

            f.frozen_path = ‹infohash› ≫ string ‹abspath›

        The absolute path to the file.

    f.is_created
    f.is_open

        **TODO**

    f.is_create_queued
    f.set_create_queued
    f.unset_create_queued
    f.is_resize_queued
    f.set_resize_queued
    f.unset_resize_queued

        **TODO**

    f.last_touched

        .. code-block:: ini

            f.last_touched = ‹infohash› ≫ value ‹microseconds›

        The last time, in `epoch <https://en.wikipedia.org/wiki/Unix_time>`_ microseconds, *rTorrent* prepared to use the file
        (for either reading or writing). This will not necessarily correspond to the file's
        access or modification times.

    f.match_depth_next
    f.match_depth_prev

        **TODO**

    f.offset

        .. code-block:: ini

            f.offset = ‹infohash› ≫ value ‹bytes›

        The offset (in bytes) of the file from the start of the torrent data. The first file starts at ``0``, the second file
        at :term:`f.size_bytes` of the first file, the third at :term:`f.size_bytes` of the first two files combined, and so on.

    f.path

        .. code-block:: ini

            f.path = ‹infohash› ≫ string ‹path›

        The path of the file relative to the base directory.

    f.path_components
        .. code-block:: ini

            f.path_components = ‹infohash› ≫ array ‹components›

        Returns an array of the individual parts of the path.

    f.path_depth

        .. code-block:: ini

            f.path_depth = ‹infohash› ≫ value ‹depth›

        Returns a value equal to how deep the file is relative to the base directory.
        This is equal to the number of elements in the array that
        :term:`f.path_components` returns.

    f.prioritize_first
    f.prioritize_first.disable
    f.prioritize_first.enable
    f.prioritize_last
    f.prioritize_last.disable
    f.prioritize_last.enable

        .. code-block:: ini

            f.prioritize_first = ‹infohash› ≫ bool (0 or 1)
            f.prioritize_first.disable = ‹infohash› ≫ 0
            f.prioritize_first.enable = ‹infohash› ≫ 0
            f.prioritize_last = ‹infohash› ≫ bool (0 or 1)
            f.prioritize_last.disable = ‹infohash› ≫ 0
            f.prioritize_last.enable = ‹infohash› ≫ 0

        This determines how files are prioritized when :term:`f.priority` is set to normal.
        While any high (i.e. ``2``) priority files take precedence, when a torrent is started, the rest of the files are sorted
        according to which are marked as ``prioritize_first`` vs ``prioritize_last``. If both flags are set,
        ``prioritize_first`` is checked first. This sorting happens whenever :term:`d.update_priorities` is called.

        See also :term:`file.prioritize_toc`.

    f.priority
    f.priority.set

        .. code-block:: ini

            f.priority = ‹infohash› ≫ value ‹priority›
            f.priority.set = ‹infohash›, value ‹priority› ≫ 0

        There are 3 possible priorities for files:

        * ``0`` off – Do not download this file. Note that the file can still show up
          if there is an overlapping chunk with a file that you do want to download.
        * ``1`` normal – Download this file normally.
        * ``2`` high – Prioritize requesting chunks for this file above normal files.

        In the ncurses file view, you can rotate a selected file between these states with the space bar.

        See also :term:`d.update_priorities`.

    f.range_first
    f.range_second

        **TODO**

    f.size_bytes
    f.size_chunks

        .. code-block:: ini

            f.size_bytes = ‹infohash› ≫ value ‹bytes›
            f.size_chunks = ‹infohash› ≫ value ‹chunks›

        Returns the number of bytes and chunks in the file respectively. If the file is only partially in some chunks,
        those are included in the count. This means the sum of all ``f.size_chunks`` can be
        larger than :term:`d.size_chunks`.


.. _p-commands:

`p.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

These commands can be used as arguments in a :term:`p.multicall`.
They can also be called directly, but you need to pass `‹infohash›:p‹peerhash›` as the first argument
(referenced as ``target`` from here on out). The ``‹peerhash›`` is the ID as returned by
:term:`p.id`, which is encoded as a hexadecimal string.


.. rubric:: Example

.. code-block:: console

    $ hash="145B85116626651912298F9400805254FB1192AE" # some valid info hash
    $ rtxmlrpc --repr p.multicall "$hash" "" p.id= p.port=
    [['17C14214B60B92FFDEBFB550380ED3866BF49691', 62066]]
    $ rtxmlrpc --repr p.port "$hash:p17C14214B60B92FFDEBFB550380ED3866BF49691"
    62066

.. glossary::

    p.multicall

        .. code-block:: ini

            p.multicall = ‹infohash›, "", [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ list of lists of results ‹rows of results›

        Iterates over the peers in an item, calling the given ``p.*`` commands.

        The second argument is ignored, pass an empty string.
        See also :term:`d.multicall2` on basics regarding multi-calls.

    p.address

        .. code-block:: ini

            p.address = ‹target› ≫ string ‹address›

        Returns the IP address of the peer.

    p.banned
    p.banned.set

        .. code-block:: ini

            p.banned = ‹target› ≫ bool (0 or 1)
            p.banned.set = ‹target›, bool (0 or 1) ≫ 0

        Returns (or sets) whether to ban the peer for too much bad data being sent, which means rTorrent will never connect
        to the peer again.

        **TODO** What are the conditions for a peer being banned automatically?

        .. warning::

            Once a peer is set as banned, it cannot be unbanned. Only restarting rTorrent can clear the ban.

    p.call_target

        .. code-block:: ini

            p.call_target = ‹infohash›, ‹peerhash›, ‹cmd›, [‹arg1›, [, ‹arg2›…]] ≫ bool (0 or 1)

        **TODO** While functional, the code looks incomplete and it isn't very useful.

    p.client_version

        .. code-block:: ini

            p.client_version = ‹target› ≫ string ‹client version›

        Returns a string client containing the client and version of the peer, if *rTorrent* knows enough to parse the
        peer ID. Otherwise, ``Unknown`` will be returned. The list of clients *rTorrent* understands is available
        in `client_list.cc <https://github.com/rakshasa/libtorrent/blob/master/src/torrent/peer/client_list.cc>`_.

    p.completed_percent

        .. code-block:: ini

            p.completed_percent = ‹target› ≫ value ‹percent›

        Returns the percent of data the remote peer has completed.

    p.disconnect
    p.disconnect_delayed

        .. code-block:: ini

           p.disconnect = ‹target› ≫ 0
           p.disconnect_delayed = ‹target› ≫ 0

        Disconnects from the specified peer. The ``p.disconnect`` disconnects immediately, while ``p.disconnect_delayed``
        puts the actual disconnect into a queue.

        **TODO** What causes delayed disconnect actions to finally be acted upon?

    p.down_rate
    p.down_total

        .. code-block:: ini

            p.down_rate = ‹target› ≫ value ‹rate  [bytes/s]›
            p.down_total = ‹target› ≫ value ‹total  [bytes]›

        Returns the rate and total of the bytes you are downloading from the peer.

    p.id

        .. code-block:: ini

             p.id = ‹target› ≫ string ‹peerhash›

        Returns the peer ID hash, in the form of a 40-character hex string. This is the ID *rTorrent* uses to reference the peer
        in all XMLRPC commands, and is different from the ID peers send to identify themselves.

    p.id_html

        .. code-block:: ini

            p.id_html = ‹target› ≫ string ‹client id›

        Returns the client ID string, with non-printable characters `percent encoded`_, like URLs. This command is completely
        unrelated to :term:`p.id`. This is instead the raw string that peers send to identify themselves uniquely, and is what
        :term:`p.client_version` attempts to parse. See `BEP 20`_ for more information on the conventions clients
        use for the value.

    p.is_encrypted

        .. code-block:: ini

            p.is_encrypted = ‹target› ≫ bool (0 or 1)

        Returns true if the connection to the peer is encrypted (not just obfuscated). However, if this returns true,
        :term:`p.is_obfuscated` will always be true as well. See :term:`protocol.encryption.set`.

    p.is_incoming

        .. code-block:: ini

            p.is_incoming = ‹target› ≫ bool (0 or 1)

        Return true if the remote peer was the first one to initiate the connection.

    p.is_obfuscated

        .. code-block:: ini

            p.is_obfuscated = ‹target› ≫ bool (0 or 1)

        Returns true if the header messages sent to the peer are obfuscated. If the connection is fully encrypted, this
        is true automatically. Be aware that this means the data is still being sent unencrypted.

    p.is_preferred
    p.is_unwanted

        .. code-block:: ini

            p.is_preferred = ‹target› ≫ bool (0 or 1)
            p.is_unwanted = ‹target› ≫ bool (0 or 1)

        Returns whether or not the peer is marked as preferred or unwanted when
        `IP filtering <https://github.com/rakshasa/rtorrent/wiki/IP-filtering>`_ is in use.

    p.options_str

        .. code-block:: ini

            p.options_str = ‹target› ≫ string ‹options›

        Returns the reserved option bytes as a string. Currently only two options are recognized by *rTorrent*:
        extensions (`BEP 10`_) and DHT (`BEP 5`_). For clients that support both (most modern ones do),
        ``0000000000100005`` will be the returned string.

    p.peer_rate
    p.peer_total

        .. code-block:: ini

            p.peer_rate = ‹target› ≫ value ‹rate [bytes/s]›
            p.peer_total = ‹target› ≫ value ‹total [bytes]›

        Returns the rate and total of the bytes which the peer is downloading from everyone (local client included).
        Note that this is calculated from the number of chunks the peer has completed, and as such
        should not be taken as an exact indicator.

    p.port

         .. code-block:: ini

             p.port = ‹target› ≫ value ‹port›

         Returns the remote port as an integer.

    p.is_snubbed
    p.snubbed
    p.snubbed.set

        .. code-block:: ini

            p.snubbed = ‹target› ≫ bool (0 or 1)
            p.is_snubbed = ‹target› ≫ bool (0 or 1)
            p.snubbed.set = ‹target›, bool (0 or 1) ≫ 0

        Control if a peer is snubbed, meaning that *rTorrent* will stop uploading to the peer. ``p.is_snubbed`` is an
        alias for ``p.snubbed``.

    p.up_rate
    p.up_total

        .. code-block:: ini

            p.up_rate = ‹target› ≫ value ‹rate [bytes/s]›
            p.up_total = ‹target› ≫ value ‹total [bytes]›

        Returns the rate and total of the bytes you are uploading to the peer.

.. _`BEP 5`: http://www.bittorrent.org/beps/bep_0005.html
.. _`BEP 10`: http://www.bittorrent.org/beps/bep_0010.html
.. _`BEP 20`: http://www.bittorrent.org/beps/bep_0020.html
.. _`percent encoded`: https://tools.ietf.org/html/rfc3986#section-2.1

.. _t-commands:

`t.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

These commands can be used as arguments in a :term:`t.multicall`.
They can also be called directly, but you need to pass `‹infohash›:t‹index›` as the first argument.
Index counting starts at ``0``, the array size is :term:`d.tracker_size`.

.. glossary::

    t.multicall

        .. code-block:: ini

            t.multicall = ‹infohash›, "", [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ list of lists of results ‹rows of results›

        Iterates over the trackers in an item, calling the given ``t.*`` commands.

        The second argument is ignored, pass an empty string.
        See also :term:`d.multicall2` on basics regarding multi-calls.

    t.activity_time_last
    t.activity_time_next
    t.can_scrape
    t.disable
    t.enable
    t.failed_counter
    t.failed_time_last
    t.failed_time_next
    t.group
    t.id
    t.is_busy
    t.is_enabled
    t.is_enabled.set
    t.is_extra_tracker
    t.is_open
    t.is_usable
    t.latest_event
    t.latest_new_peers
    t.latest_sum_peers
    t.min_interval
    t.normal_interval
    t.scrape_complete
    t.scrape_counter
    t.scrape_downloaded
    t.scrape_incomplete
    t.scrape_time_last
    t.success_counter
    t.success_time_last
    t.success_time_next
    t.type
    t.url

        **TODO**


.. _load-commands:

`load.*` commands
^^^^^^^^^^^^^^^^^

The client may be configured to check a directory for new metafiles and load them.
Items loaded in this manner will be tied to the metafile's path (see :term:`d.tied_to_file`).

This means when the metafile is deleted, the item may be stopped (see :term:`stop_untied`),
and when the item is removed the metafile is also.
Note that you can untie an item by using the ``U`` key (which will also delete the tied file),
and using ``Ctrl-K`` also implicitly unties an item.

.. glossary::

    load.normal
    load.verbose
    load.start
    load.start_verbose

        .. code-block:: ini

            # all other commands have the same arguments
            load.normal = ‹metafile pattern›, [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ 0

        Load a single metafile, or expand a pattern of new files to be loaded.
        These commands are typically used in watch directory schedules.

        ``normal`` loads them stopped, and ``verbose`` reports problems to the console,
        like when a new file's infohash collides with an already loaded item.

        .. code-block:: ini

            # Simple watches that load items started or closed
            schedule2 = watch_start, 1, 10, ((load.start_verbose, (cat, (cfg.watch), "start/*.torrent")))
            schedule2 = watch_load,  2, 10, ((load.verbose, (cat, (cfg.watch), "load/*.torrent")))

        .. rubric:: Post-load commands

        You can list any number of commands as additional arguments,
        after the metafile pattern in a load command.
        Typical uses are calling :term:`d.delete_tied`, setting custom attributes via
        :term:`d.custom.set`, or immediately setting a specific download directory
        with :term:`d.directory.set` (as opposed to doing that in completion moving).

        These commands are executed before the new item is fully added to the download list,
        and some commands like :term:`d.start` won't work in that state.
        So you sometimes have to use :term:`event.download.inserted_new` handlers instead.

        .. code-block:: ini

            schedule2 = watch_with_catgeory, 27, 10, \
                ((load.verbose, (cat,(cfg.watch),"foobar/*.torrent"), "d.custom1.set=foobar"))

        .. rubric:: Remotely loading an item with a specific path

        The following example is also using post-load commands, but does so ‘from the outside’
        using the XMLRPC API.

        .. code-block:: shell

            LOAD_PRIORITY=2
            rtxmlrpc -q load.verbose '' "$metafile_path" \
                "d.directory_base.set=\"$data_dir\"" "d.priority.set=$LOAD_PRIORITY"


    load.raw
    load.raw_start
    load.raw_start_verbose
    load.raw_verbose

        .. rubric:: *load.raw_start_verbose since rTorrent 0.9.7*

        .. code-block:: ini

            # all other commands have the same arguments
            load.raw = ‹binary (i.e. raw) metafile›, [‹cmd1›=[‹args›][, ‹cmd2›=…]] ≫ 0

        Load a metafile passed as *base64* data. The method of encoding the data for XMLRPC
        will vary depending on which tool you're using.

        Take note that :term:`d.tied_to_file` and :term:`d.loaded_file` (until a client restart)
        will be empty for items added by these commands
        – which is the case for all items added via `ruTorrent`.

        As with :term:`load.normal`, ``raw`` loads them stopped, and ``raw_verbose``
        reports problems to the console.

        .. rubric:: Example

        .. code-block:: console

            $ mktor -q README.md local
            $ rtxmlrpc --debug load.raw_verbose '' @README.md.torrent | egrep 'xmlrpclib|stats'
            DEBUG    load.raw_verbose('', <xmlrpclib.Binary instance at 0x15e1200>) took 0.000 secs
            DEBUG    XMLRPC stats: 3 req, out 795 bytes [564 bytes max], in 445 bytes [153 bytes max], …
            $ rtxmlrpc d.multicall.filtered '' 'string.contains=$d.name=,README' \
                       d.name= d.tied_to_file= d.loaded_file=
            ['README.md', '', '']


.. _session-commands:

`session.*` commands
^^^^^^^^^^^^^^^^^^^^

.. glossary::

    session.name
    session.name.set

        .. code-block:: ini

            session.name ≫ string ‹name›
            session.name.set = string ‹name› ≫ 0

        This controls the session name. By default this is set to :term:`system.hostname` + ':' +
        :term:`system.pid`. Like :term:`session.path`, once the session is active this cannot
        be changed


    session.on_completion
    session.on_completion.set

        .. code-block:: ini

            session.on_completion ≫ bool (0 or 1)
            session.on_completion.set = bool (0 or 1) ≫ 0

        When true, :term:`d.save_resume` is called right before :term:`event.download.finished`
        occurs.


    session
    session.path
    session.path.set

        .. code-block:: ini

            session.path ≫ string ‹path›
            session.path.set = string ‹path› ≫ 0

        ``session.path.set`` specifies the location of the directory where *rTorrent*
        saves its status between starts – a command you should *always* have in your configuration.

        It enables session management, which means the metafiles and status information for all
        open downloads will be stored in this directory. When restarting *rTorrent*, all items
        previously loaded will be restored. Only one instance of *rTorrent* should be used with
        each session directory, though at the moment no locking is done.

        An empty string will disable session handling. Note that you cannot change to another
        directory while a session directory is already active.

        ``session`` is an alias for ``session.path.set``, but should not be used as it may become
        deprecated.


    session.save

        Flushes the full session state for all torrents to the related files in the session folder.
        Note that this can cause
        `heavy IO <https://github.com/rakshasa/rtorrent/issues/180#issuecomment-55140832>`_
        with many torrents.
        The default interval this command runs at
        `can be adjusted <https://github.com/rakshasa/rtorrent/wiki/Performance-Tuning#session-save>`_,
        however if *rTorrent* restarts or goes down, there may be a loss of statistics
        and resume data for any new torrents added after the last snapshot.

        See also :term:`d.save_full_session`, which saves the state of a single item.


    session.use_lock
    session.use_lock.set

        .. code-block:: ini

            session.use_lock ≫ bool (0 or 1)
            session.use_lock.set = bool (0 or 1) ≫ 0

        By default, a lockfile is created in the session directory to prevent multiple instances of
        *rTorrent* from using the same session simultaneously.


.. END cmd-items

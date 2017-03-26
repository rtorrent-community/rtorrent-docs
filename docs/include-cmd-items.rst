.. _d-commands:

`d.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

All `d.*` commands take an info hash as the first argument when called over the XMLRPC API.

  .. code-block:: ini

     d.name = ‹hash› ≫ 0

.. glossary::

    d.accepting_seeders
    d.accepting_seeders.disable
    d.accepting_seeders.enable
    d.base_filename
    d.base_path
    d.bitfield
    d.bytes_done
    d.check_hash

        **TODO**

    d.chunk_size

        Returns the chunk size of the item (also known as the
        "peice size") in bytes.

        .. code-block:: ini

           d.chunk_size = ‹hash› ≫ 0

    d.chunks_hashed
    d.chunks_seen
    d.close
    d.close.directly
    d.complete
    d.completed_bytes
    d.completed_chunks
    d.connection_current
    d.connection_current.set
    d.connection_leech
    d.connection_seed
    d.create_link
    d.creation_date
    d.custom
    d.custom.set
    d.custom1
    d.custom1.set
    d.custom2
    d.custom2.set
    d.custom3
    d.custom3.set
    d.custom4
    d.custom4.set
    d.custom5
    d.custom5.set
    d.custom_throw
    d.delete_link
    d.delete_tied
    d.directory
    d.directory.set
    d.directory_base
    d.directory_base.set
    d.disconnect.seeders
    d.down.choke_heuristics
    d.down.choke_heuristics.leech
    d.down.choke_heuristics.seed
    d.down.choke_heuristics.set
    d.down.rate
    d.down.total
    d.downloads_max
    d.downloads_max.set
    d.downloads_min
    d.downloads_min.set
    d.erase
    d.free_diskspace
    d.group
    d.group.name
    d.group.set
    d.hash
    d.hashing
    d.hashing_failed
    d.hashing_failed.set
    d.ignore_commands
    d.ignore_commands.set
    d.incomplete
    d.is_active
    d.is_hash_checked
    d.is_hash_checking
    d.is_meta
    d.is_multi_file
    d.is_not_partially_done
    d.is_open
    d.is_partially_done
    d.is_pex_active
    d.is_private
    d.left_bytes
    d.load_date
    d.loaded_file
    d.local_id
    d.local_id_html
    d.max_file_size
    d.max_file_size.set
    d.max_size_pex
    d.message
    d.message.set
    d.mode
    d.multicall2
    d.name
    d.open
    d.pause
    d.peer_exchange
    d.peer_exchange.set
    d.peers_accounted
    d.peers_complete
    d.peers_connected
    d.peers_max
    d.peers_max.set
    d.peers_min
    d.peers_min.set
    d.peers_not_connected
    d.priority
    d.priority.set
    d.priority_str
    d.ratio
    d.resume

        **TODO**

    d.save_full_session

        Flushes the item's state to files in the session directory (if enabled).

    d.save_resume
    d.size_bytes
    d.size_chunks
    d.size_files
    d.size_pex
    d.skip.rate
    d.skip.total
    d.start
    d.state
    d.state_changed
    d.state_counter
    d.stop
    d.throttle_name
    d.throttle_name.set
    d.tied_to_file
    d.tied_to_file.set
    d.timestamp.finished
    d.timestamp.started
    d.tracker.insert
    d.tracker.send_scrape
    d.tracker_announce
    d.tracker_focus
    d.tracker_numwant
    d.tracker_numwant.set
    d.tracker_size
    d.try_close
    d.try_start
    d.try_stop
    d.up.choke_heuristics
    d.up.choke_heuristics.leech
    d.up.choke_heuristics.seed
    d.up.choke_heuristics.set
    d.up.rate
    d.up.total

        **TODO**

    d.update_priorities

        After a scripted change to priorities using :term:`f.priority.set`,
        this command **must** be called. It updates the internal state of a
        download item based on the new priority settings.

    d.uploads_max
    d.uploads_max.set
    d.uploads_min
    d.uploads_min.set
    d.views
    d.views.has
    d.views.push_back
    d.views.push_back_unique
    d.views.remove
    d.wanted_chunks

        **TODO**


The following are only available in *rTorrent-PS*!

.. glossary::

    d.tracker_domain

        Returns the (shortened) tracker domain of the given download item. The
        chosen tracker is the first HTTP one with active peers (seeders or
        leechers), or else the first one.

        .. code-block:: ini

            # Trackers view (all items, sorted by tracker domain and then name).
            # This will ONLY work if you use rTorrent-PS!
            view.add          = trackers
            view.sort_new     = trackers, "compare=,d.tracker_domain=,d.name="
            view.sort_current = trackers, "compare=,d.tracker_domain=,d.name="


These are part of the default ``pyrocore`` configuration:

.. glossary::

    d.data_path
    d.session_file
    d.tracker.bump_scrape
    d.timestamp.downloaded
    d.last_active

        **TODO**


.. _f-commands:

`f.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    f.completed_chunks
    f.frozen_path
    f.is_create_queued
    f.is_created
    f.is_open
    f.is_resize_queued
    f.last_touched
    f.match_depth_next
    f.match_depth_prev
    f.multicall
    f.offset
    f.path
    f.path_components
    f.path_depth
    f.prioritize_first
    f.prioritize_first.disable
    f.prioritize_first.enable
    f.prioritize_last
    f.prioritize_last.disable
    f.prioritize_last.enable

        **TODO**

    f.priority
    f.priority.set

        **TODO**

        See also :term:`d.update_priorities`.

    f.range_first
    f.range_second
    f.set_create_queued
    f.set_resize_queued
    f.size_bytes
    f.size_chunks
    f.unset_create_queued
    f.unset_resize_queued

        **TODO**


.. _p-commands:

`p.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    p.address
    p.banned
    p.banned.set
    p.call_target
    p.client_version
    p.completed_percent
    p.disconnect
    p.disconnect_delayed
    p.down_rate
    p.down_total
    p.id
    p.id_html
    p.is_encrypted
    p.is_incoming
    p.is_obfuscated
    p.is_preferred
    p.is_snubbed
    p.is_unwanted
    p.multicall
    p.options_str
    p.peer_rate
    p.peer_total
    p.port
    p.snubbed
    p.snubbed.set
    p.up_rate
    p.up_total

        **TODO**


.. _t-commands:

`t.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

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
    t.multicall
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
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    load.normal
    load.verbose

        **TODO**

    load.start
    load.start_verbose

        **TODO**

    load.raw
    load.raw_start
    load.raw_start_verbose
    load.raw_verbose

        **TODO**

.. END cmd-items

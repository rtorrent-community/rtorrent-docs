.. _network-commands:

`network.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    network.bind_address
    network.bind_address.set

        **TODO**

    network.http.dns_cache_timeout
    network.http.dns_cache_timeout.set

        **TODO**

    network.http.current_open
    network.http.max_open
    network.http.max_open.set

        **TODO**

    network.http.proxy_address
    network.http.proxy_address.set

        **TODO**

    network.http.cacert
    network.http.cacert.set
    network.http.capath
    network.http.capath.set

        **TODO**

    network.http.ssl_verify_host
    network.http.ssl_verify_host.set
    network.http.ssl_verify_peer
    network.http.ssl_verify_peer.set

        **TODO**

    network.listen.backlog
    network.listen.backlog.set
    network.listen.port

        **TODO**

    network.local_address
    network.local_address.set

        **TODO**

    network.max_open_files
    network.max_open_files.set

        **TODO**

    network.max_open_sockets
    network.max_open_sockets.set
    network.open_sockets

        **TODO**

    network.port_open
    network.port_open.set
    network.port_random
    network.port_random.set
    network.port_range
    network.port_range.set

        **TODO**

    network.proxy_address
    network.proxy_address.set

        **TODO**

    network.receive_buffer.size
    network.receive_buffer.size.set

        **TODO**

    network.scgi.dont_route
    network.scgi.dont_route.set

        **TODO**

    network.scgi.open_local
    network.scgi.open_port

        **TODO**

    network.send_buffer.size
    network.send_buffer.size.set

        **TODO**

    network.tos.set

        **TODO**

    network.xmlrpc.dialect.set
    network.xmlrpc.size_limit
    network.xmlrpc.size_limit.set

        **TODO**


The following are only available in *rTorrent-PS*!

.. glossary::

    network.history.auto_scale
    network.history.auto_scale.set
    network.history.depth
    network.history.depth.set
    network.history.refresh
    network.history.sample

        Commands to add network traffic charts to the bottom of the collapsed
        download display.

        Add these lines to your configuration:

        .. code-block:: ini

            # rTorrent-PS only!

            # Show traffic of the last hour (112*32 = 3584 ≈ 3600)
            network.history.depth.set = 112

            method.insert = network.history.auto_scale.toggle, simple|private,\
                "branch=(network.history.auto_scale),\
                    ((network.history.auto_scale.set, 0)),\
                    ((network.history.auto_scale.set, 1))"
            method.insert = network.history.auto_scale.ui_toggle, simple|private,\
                "network.history.auto_scale.toggle= ; network.history.refresh="

            schedule2 = network_history_sampling, 1, 32, "network.history.sample="
            schedule2 = bind_auto_scale, 0, 0,\
                "ui.bind_key=download_list, =, network.history.auto_scale.ui_toggle="

        This will add the graph above the footer,
        you get the upper and lower bounds of traffic
        within your configured time window, and each bar of the graph
        represents an interval determined by the sampling schedule.
        Pressing ``=`` toggles between a graph display with base line 0,
        and a zoomed view that scales it to the current bounds.


`ip_tables.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    ip_tables.add_address
    ip_tables.get
    ip_tables.insert_table
    ip_tables.size_data

        **TODO**


`ipv4_filter.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    ipv4_filter.add_address
    ipv4_filter.dump
    ipv4_filter.get
    ipv4_filter.load
    ipv4_filter.size_data

        **TODO**


.. END cmd-network

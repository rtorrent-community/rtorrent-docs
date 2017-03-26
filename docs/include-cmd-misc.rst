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

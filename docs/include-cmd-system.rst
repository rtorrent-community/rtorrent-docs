.. _execute-commands:

`execute.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    execute2

        **TODO**

    execute.capture
    execute.capture_nothrow

        **TODO**

    execute.nothrow
    execute.nothrow.bg
    execute.throw
    execute.throw.bg

        **TODO**

    execute.raw
    execute.raw.bg
    execute.raw_nothrow
    execute.raw_nothrow.bg

        **TODO**


.. _system-commands:

`system.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    system.listMethods
    system.methodExist
    system.methodHelp
    system.methodSignature
    system.capabilities
    system.getCapabilities

        **TODO**

    system.multicall

        **TODO**

    system.shutdown

        **TODO**

    system.api_version
    system.client_version
    system.library_version

        **TODO**

    system.colors.enabled
    system.colors.max
    system.colors.rgb

        **TODO**

    system.cwd
    system.cwd.set

        **TODO**

    system.env

        **TODO**

    system.file.allocate
    system.file.allocate.set

        **TODO**

    system.file.max_size
    system.file.max_size.set

        **TODO**

    system.file.split_size
    system.file.split_size.set
    system.file.split_suffix
    system.file.split_suffix.set

        **TODO**

    system.file_status_cache.prune
    system.file_status_cache.size

        **TODO**

    system.files.closed_counter
    system.files.failed_counter
    system.files.opened_counter

        **TODO**

    system.hostname

        **TODO**

    system.pid

        **TODO**

    system.random

        ``system.random = [[<lower>,] <upper>]`` **rTorrent-PS only**

        Generate *uniformly* distributed random numbers in the range
        defined by ``lower`` … ``upper``.

        The default range with no args is ``0`` … ``RAND_MAX``. Providing
        just one argument sets an *exclusive* upper bound, and two
        args define an *inclusive*  range.

        An example use-case is adding jitter to time values that you
        later check with :term:`elapsed.greater`, to avoid load spikes and
        similar effects of clustered time triggers.

    system.time
    system.time_seconds
    system.time_usec

        **TODO**

    system.umask.set

        **TODO**


.. _log-commands:

`log.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    log.add_output

        **TODO**

    log.execute
    log.xmlrpc

        **TODO**

    log.open_file
    log.open_gz_file

        **TODO**

    log.open_file_pid
    log.open_gz_file_pid

        **TODO**

    log.vmmap.dump

        **TODO**

.. END cmd-system

.. _execute-commands:

`execute.*` commands
^^^^^^^^^^^^^^^^^^^^

Call operating system commands, possibly catching their output for use within *rTorrent*.


.. note::

    The ``.bg`` variants detach the child process from the *rTorrent* parent,
    i.e. it runs in the background. This **must** be used if you want to call
    back into *rTorrent* via XMLRPC, since otherwise there *will* be a deadlock.

    ``throw`` means to raise an error when the called command fails,
    while the ``nothrow`` variants will return the exit code.


.. glossary::

    execute.throw
    execute.throw.bg
    execute2

        .. code-block:: ini

            execute.throw[.bg] = {command, arg1, arg2, ...} ≫ 0

        This will execute a system command with the provided arguments.
        These commands either raise an error or return ``0``.
        ``execute2`` is the same as ``execute.throw``, and should be avoided.

        Since internally ``spawn`` is used to call the OS command,
        the shell is not involved and things like shell redirection will not work here.
        There is also no reason to use shell quoting in arguments,
        just separate them by commas.
        If you need shell features, call ``bash -c "‹command›"``
        like shown in this example:

        .. code-block:: ini

            # Write a PID file into the session directory
            execute.throw = bash, -c, (cat, "echo >", (session.path), "rtorrent.pid", " ", (system.pid))

        Note that the result of the ``(cat, …)`` command ends up as a *single* argument passed on to ``bash``.


    execute.nothrow
    execute.nothrow.bg

        .. code-block:: ini

            execute.nothrow[.bg] = {command, arg1, arg2, ...} ≫ value ‹exit status›

        Like :term:`execute.throw`, but return the command's exit code
        (*warning:* due to a bug the return code is shifted by 8 bits, so ``1`` becomes ``0x100``).

        The ``.bg`` variant will just indicate whether
        the child could be successfully spawned and detached.


    execute.capture
    execute.capture_nothrow

        .. code-block:: ini

            execute.capture[_nothrow] = {command, arg1, arg2, ...} ≫ string ‹stdout›

        Like ``execute.[no]throw``, but returns the command's standard output.
        The ``nothrow`` variant returns any output that was written before an error,
        in case one occurs. The exit code is never returned.

        Note that any line-endings are included, so if you need a plain string value,
        wrap the command you want to call into an ``echo -n`` command:

        .. code-block:: ini

            method.insert = log_stamp, private|simple,\
                "execute.capture_nothrow = bash, -c, \"echo -n $(date +%Y-%m-%d-%H%M%S)\""


    execute.raw
    execute.raw.bg
    execute.raw_nothrow
    execute.raw_nothrow.bg

        The ``execute.raw`` variants function identically to other ``execute.*`` commands,
        except that a tilde in the path to the executable is not expanded.


.. _system-commands:

`system.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

Commands related to the operating system and the XMLRPC API.

.. glossary::

    system.listMethods
    system.methodExist
    system.methodHelp
    system.methodSignature
    system.getCapabilities

        .. code-block:: ini

            system.listMethods ≫ array ‹methods›
            system.methodExist = string ‹method› ≫ bool (0 or 1)
            system.methodHelp = string ‹method› ≫ string ‹help›
            system.methodSignature = string ‹method› ≫ string ‹signature›
            system.getCapabilities ≫ array ‹capabilities›

        XML-RPC introspection methods. For more information, see `XML-RPC Introspection`_.
        Note that no help or signature is currently defined for *rTorrent*-specific
        commands.

    system.capabilities

        .. code-block:: ini

            system.capabilities ≫ array ‹capabilities›

        This returns protocol and version information about the XML-RPC interface implementation.
        See `xmlrpc-c system.capabilities`_ for more.


    system.multicall

        Similar to :term:`d.multicall2`, this allows multiple commands to be sent in one request.
        Unlike :term:`d.multicall2`, this is a generic multicall not specific to rTorrent.
        See the `xmlrpc-c system.multicall docs`_ for more.

    system.shutdown

        This shuts down the XMLRPC server. This does **not** shut down rTorrent.

    system.api_version
    system.client_version
    system.library_version

        .. code-block:: ini

            system.api_version ≫ string ‹version›
            system.client_version ≫ string ‹version›
            system.library_version ≫ string ‹version›

        The versions of the XMLRPC API, the *rTorrent* client, and the *libtorrent* library respectively.
        The client and library versions are currently tightly coupled, while ``system.api_version``
        is incremented whenever changes are made to the XMLRPC API.

    system.colors.enabled
    system.colors.max
    system.colors.rgb

        .. code-block:: ini

            # rTorrent-PS only
            system.colors.enabled ≫ bool (0 or 1)
            system.colors.max ≫ int ‹colors›
            system.colors.rgb ≫ int

        Returns some ``ncurses`` system state related to colors (in rTorrent-PS only).

    system.cwd
    system.cwd.set

        .. code-block:: ini

            system.cwd ≫ string ‹path›
            system.cwd.set = string ‹path› ≫ 0

        Query or change the current working directory of the running process.
        This will affect any relative paths used after the change, e.g. in schedules.

    system.env

        .. code-block:: ini

            # 0.9.7+ / rTorrent-PS 0.*+ only
            system.env = ‹varname› ≫ string ‹env-value›

        Query the value of an environment variable,
        returns an empty string if ``$varname`` is not defined.

        Example:

        .. code-block:: ini

            session.path.set = (cat, (system.env, RTORRENT_HOME), "/.session")


    system.file.allocate
    system.file.allocate.set

        .. code-block:: ini

            system.file.allocate ≫ bool (0 or 1)
            system.file.allocate.set = bool (0 or 1) ≫ 0

        Controls whether file pre-allocation is enabled. If it is, and file allocation
        is supported by the file system, the full amount of space required for a file
        is allotted *immediately* when an item is started. Otherwise space is used only
        when data arrives and must be stored.


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

        .. code-block:: ini

            system.file_status_cache.size ≫ value ‹size›
            system.file_status_cache.prune ≫ 0

        Used when loading metafiles from a directory/glob, this helps prevent *rTorrent* from trying
        to load the same file multiple times, especially when using watch directories.

    system.files.closed_counter
    system.files.failed_counter
    system.files.opened_counter

        .. code-block:: ini

            system.files.closed_counter ≫ value ‹closed›
            system.files.failed_counter ≫ value ‹failed›
            system.files.opened_counter ≫ value ‹opened›

        Return the number of files which were closed, failed to open, and were
        successfully opened respectively.

    system.hostname

        .. code-block:: ini

            system.hostname ≫ string ‹hostname›

        Returns the hostname of the system.

    system.pid

        .. code-block:: ini

            system.pid ≫ value ‹pid›

        Returns the process's identifier.

    system.random

        .. code-block:: ini

            # rTorrent-PS 1.0+ only
            system.random = [[‹lower›,] ‹upper›] ≫ value

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

        .. code-block:: ini

            system.time ≫ value ‹time›
            system.time_seconds ≫ value ‹time›
            system.time_usec ≫ value ‹time›

        Returns the system times in `epoch <https://en.wikipedia.org/wiki/Unix_time>`_ notation.
        ``system.time_usec`` returns the value in microseconds instead of seconds.
        ``system.time`` is essentially an alias for ``system.time_seconds``.

        **TODO** Is there any practical difference when using the cached ``system.time``?

    system.umask.set

        .. code-block:: ini

            system.umask.set ≫ value ‹time›

        Set the `umask`_ for the running *rTorrent* process.

.. _`umask`: https://en.wikipedia.org/wiki/Umask
.. _`XML-RPC Introspection`: http://xmlrpc-c.sourceforge.net/introspection.html
.. _`xmlrpc-c system.multicall docs`: https://openacs.org/api-doc/proc-view?proc=system.multicall
.. _`xmlrpc-c system.capabilities`: http://xmlrpc-c.sourceforge.net/doc/libxmlrpc_server.html#system.capabilities


.. _log-commands:

`log.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    log.add_output

        .. code-block:: ini

            log.add_output = ‹scope›, ‹name› ≫ 0

        This command adds another logging scope to a named log file,
        opened by one of the :term:`log.open_file` commands.

        Log messages are classified into groups
        (``connection``, ``dht``, ``peer``, ``rpc``, ``storage``, ``thread``, ``torrent``, and ``tracker``),
        and have a level of ``critical``, ``error``, ``warn``, ``notice``, ``info``, or ``debug``.

        Scopes can either be a whole level,
        or else a group on a specific level by using ``‹group›_‹level›`` as the scope's name.

        Example:

        .. code-block:: ini

            log.add_output = tracker_debug, tracelog


    log.execute

        .. code-block:: ini

            log.execute = ‹path› ≫ 0

        (Re-)opens a log file that records commands called via :ref:`execute-commands`,
        including their return code and output.
        This can grow large quickly, see :ref:`log-rotation` for how to manage this and other log files.

        Passing an empty string closes the file.

        Example:

        .. code-block:: ini

            log.execute = (cat, (cfg.logs), "execute.log")

    log.xmlrpc

        .. code-block:: ini

            log.xmlrpc = ‹path› ≫ 0

        (Re-)opens a log file that contains a log of commands executed via XMLRPC.
        This logs the raw SCGI and XMLRPC call and response for each request.
        The file can get huge quickly, see :ref:`log-rotation` for how to manage this and other log files.

        Passing an empty string closes the file.

        Example:

        .. code-block:: ini

            log.xmlrpc = (cat, (cfg.logs), "xmlrpc.log")

    log.open_file
    log.open_gz_file
    log.open_file_pid
    log.open_gz_file_pid

        .. code-block:: ini

            log.open_file = ‹name›, ‹log file path›[, ‹scope›…] ≫ 0
            log.open_gz_file
            log.open_file_pid
            log.open_gz_file_pid

        All these commands open a log file, giving it a name to refer to.
        Paths starting with ``~`` are expanded.
        You can immediately add some logging scopes,
        see :term:`log.add_output` for details on those.

        The ``pid`` variants add the PID of *rTorrent* at the end of the file name
        (see :ref:`log-rotation` for a way better scheme for log separation).
        Adding ``gz`` opens the logfile directly as a compressed streams,
        note that you have to add an appropriate extension yourself.

        There is an arbitrary limit on the number of log streams you can open (64 in 0.9.6).
        The core of the logging subsystem is implemented in ``torrent/utils/log`` of *libtorrent*.

        You can re-open existing logs in *rTorrent-PS* 1.1+ (and maybe in *rTorrent* 0.9.7+),
        by just calling an open command with a new path. To ‘close’ one, bind it to ``/dev/null``.

        Example:

        .. code-block:: ini

            log.open_file_pid = tracker, /tmp/tracker.log, tracker_debug
            # … opens '/tmp/tracker.log.NNNNN' for debugging tracker announces etc.

        .. warning::

            Compressed log files do not seem to work, in version 0.9.6 at least.


    log.vmmap.dump

        .. code-block:: ini

            log.vmmap.dump = ‹dump file path› ≫ 0

        Dumps all memory mapping regions to the given file,
        each line contains a region in the format ``‹begin›-‹end› [‹size in KiB›k]``.


    log.messages

        .. code-block:: ini

            # rTorrent-PS 0.*+ only
            log.messages = ‹log file path› ≫ 0

        (Re-)opens a log file that contains the messages normally only visible
        on the main panel and via the ``l`` key. Each line is prefixed with the
        current date and time in ISO8601 format. If an empty path is passed, the
        file is closed.

        Example:

        .. code-block:: ini

            log.messages = (cat, (cfg.logs), "messages.log")

.. END cmd-system

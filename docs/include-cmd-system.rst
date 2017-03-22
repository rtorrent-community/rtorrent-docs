.. _execute-commands:

`execute.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

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

        **TODO**


.. _system-commands:

`system.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

Commands related to the operating system and the XMLRPC API.

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

        .. code-block:: ini

            # 0.9.7+ / rTorrent-PS only
            system.env = ‹varname› ≫ string ‹env-value›

        Query the value of an environment variable,
        returns an empty string if ``$varname`` is not defined.

        Example:

        .. code-block:: ini

            session.path.set = (cat, (system.env, RTORRENT_HOME), "/.session")


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

        .. code-block:: ini

            # rTorrent-PS only
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

    log.messages

        .. code-block:: ini

            # rTorrent-PS only
            log.messages = ‹log file path› ≫ 0

        (Re-)opens a log file that contains the messages normally only visible
        on the main panel and via the ``l`` key. Each line is prefixed with the
        current date and time in ISO8601 format. If an empty path is passed, the
        file is closed.

        Example:

        .. code-block:: ini

            log.messages = (cat, (cfg.logs), "messages.log")

.. END cmd-system

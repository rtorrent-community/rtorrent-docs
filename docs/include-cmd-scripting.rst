.. _method-commands:

`method.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    method.insert

        .. code-block:: ini

            method.insert = ‹name›, ‹type›[|‹sub-type›…][, ‹definition›] ≫ 0

        The general way to define *any* kind of command.
        See :ref:`object-types` for the possible values in the 2nd argument.

        **TODO** more details


    method.insert.simple

        .. code-block:: ini

            method.insert.simple = ‹name›, ‹definition› ≫ 0

        This is a shortcut to define commands that are ``simple`` non-private functions.


    method.insert.c_simple

        .. code-block:: ini

            method.insert.c_simple = ‹name›, ‹definition› ≫ 0

        Defines a ``const`` simple function.  **TODO** Meaning what?


    method.insert.s_c_simple

        .. code-block:: ini

            method.insert.s_c_simple = ‹name›, ‹definition› ≫ 0

        Defines a ``static const`` simple function.  **TODO** Meaning what?


    method.insert.value

        .. code-block:: ini

            method.insert.value = ‹name›, ‹default› ≫ 0

        Defines a value that you can query and set, just like with any built-in value.

        The example shows how to do optional logging for some new command you define,
        and also how to split a complicated command into steps using the ``multi`` method type.


        .. code-block:: ini

            # Enable verbose mode by setting this to 1
            method.insert.value = sample.verbose, 0

            # Do something with optional logging
            method.insert = sample.action, multi|rlookup|static
            method.set_key = sample.action, 10, ((print, "action"))
            method.set_key = sample.action, 20, ((print, "action2"))
            method.set_key = sample.action, 99,\
                ((branch, sample.verbose=,\
                    "print=\"Some log message\""\
                ))
            method.const.enable = sample.action


    method.const
    method.const.enable

        .. code-block:: ini

            method.const = ‹name› ≫ bool (0 or 1)
            method.const.enable = ‹name› ≫ 0

        Set a method to immutable (or final).
        ``method.const`` queries whether a given command is.
        If you try to change a ``const`` method,
        you'll get an ``Object is wrong type or const.`` error.

        See :term:`method.insert.value` for an example.


    method.erase

        Doesn't work, don't bother.


    method.get

        .. code-block:: ini

            method.get = ‹name› ≫ list of command definitions

        An example shows best what you get here, if you query the
        command defined in the :term:`method.insert.value` example,
        you'll get this:

        .. code-block:: shell

            $ rtxmlrpc --repr method.get '' sample.action
            {'10': ['print', 'action'],
             '20': ['print', 'action2'],
             '99': ['branch', 'sample.verbose=', 'print="Some log message"']}

        ``method.get`` is also great to see what system handlers are registered,
        they often (always?) begin with a ``!`` to ensure they sort before any user-defined handlers.

        .. code-block:: shell

            $ rtxmlrpc --repr method.get '' event.download.closed
            {'!view.indemand': 'view.filter_download=indemand',
             'log': 'print="CLOSED ",$d.name=," [",$convert.date=$system.time=,"]"'}

        The ``!view.‹viewname›`` handler is added dynamically
        when you register it for an event using :term:`view.filter_on`.


    method.set

        **TODO**


    method.set_key
    method.has_key
    method.list_keys

        .. code-block:: ini

            method.set_key = ‹name›, ‹key›, ‹definition› ≫ 0
            method.has_key = ‹name›, ‹key› ≫ bool (0 or 1)
            method.list_keys = ‹name› ≫ list of strings

        Set entries in a ``multi`` method, query a single key, or list them all.

        ``method.set_key`` is commonly used to add handler commands to event types
        like :term:`event.download.finished`.
        It can also be used to split complicated command definitions,
        see :term:`method.insert.value` for an example.


    method.rlookup
    method.rlookup.clear

        **TODO**

    method.redirect
    method.use_deprecated
    method.use_deprecated.set
    method.use_intermediate
    method.use_intermediate.set

        **TODO**


.. _event-commands:

`event.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    event.download.closed
    event.download.erased
    event.download.finished
    event.download.hash_done
    event.download.hash_failed
    event.download.hash_final_failed
    event.download.hash_queued
    event.download.hash_removed
    event.download.inserted
    event.download.inserted_new
    event.download.inserted_session
    event.download.opened
    event.download.paused
    event.download.resumed

        **TODO**


Scheduling Commands
^^^^^^^^^^^^^^^^^^^

The scheduling commands define tasks that call another command or list of commands repeatedly,
just like a cron job, but with a resolution of seconds.

.. glossary::

    schedule2

        .. code-block:: ini

            schedule2 = ‹name›, ‹start›, ‹interval›, ((‹command›[, ‹args›…])) ≫ 0
            schedule2 = ‹name›, ‹start›, ‹interval›, "‹command›=[‹args›…][ ; ‹command›=…]" ≫ 0

        Call the given command(s) every ``interval`` seconds, starting from ``start``.
        An interval of zero calls the task once, while a start of zero calls it immediately.
        Currently command is forwarded to the option handler (*ed note*: whatever that means).

        The ``name`` serves both as a handle for :term:`schedule_remove2`,
        and as an easy way to document what this task actually does.
        Existing tasks can be changed at any time, just use the same name.

        ``start`` and ``interval`` may optionally use a time format like ``[dd:]hh:mm:ss``.
        An interval of ``07:00:00:00`` would mean weekly execution.

        Examples:

        .. code-block:: ini

            # Watch directories
            schedule2 = watch_start, 11, 10, ((load.start, (cat, (cfg.watch), "start/*.torrent")))
            schedule2 = watch_load,  12, 10, ((load.normal, (cat, (cfg.watch), "load/*.torrent")))

            # Add day break to console log
            # → ( 0:00:00) New day: 20/03/2017
            schedule2 = log_new_day, 00:00:00, 24:00:00,\
                "print=\"New day: \", (convert.date, (system.time))"

            # … or the equivalent using "new" syntax:
            schedule2 = log_new_day, 00:00:05, 24:00:00,\
                ((print, "New day: ", ((convert.date, ((system.time_seconds)) )) ))


    schedule_remove2

        .. code-block:: ini

            schedule_remove2 = ‹name› ≫ 0

        Delete an existing task referenced by ``name`` from the scheduler.
        Deleting a non-existing tasks is not an error.


    start_tied
    stop_untied
    close_untied
    remove_untied

        **TODO**

    close_low_diskspace

        **TODO**


Importing Script Files
^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    import
    try_import

        **TODO**


Conditions (if/then/else)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    branch
    if

        **TODO**


Conditional Operators
^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    false

        **TODO**

    and
    or
    not

    equal
    greater
    less

        **TODO**

    elapsed.greater
    elapsed.less

        Compare time stamps like created by :term:`system.time`.


    compare

        .. code-block:: ini

            # rTorrent-PS only
            compare = ‹order›, ‹sort_key›=[, ...] ≫ bool (0 or 1)

        Compares two items like :term:`less` or :term:`greater`, but allows
        to compare by several different sort criteria, and ascending or
        descending order per given field.

        The first parameter is a string of order
        indicators, either one of ``aA+`` for ascending or ``dD-`` for descending.
        The default, i.e. when there's more fields than indicators, is ascending.

        Field types other than value or string are treated as equal
        (or in other words, they're ignored).
        If all fields are equal, then items are ordered in a random,
        but stable fashion.

        Example (sort a view by message *and* name):

        .. code-block:: ini

            view.add = messages
            view.filter = messages, ((d.message))
            view.sort_new = messages, "less=d.message="
            view.sort_new = messages, "compare=,d.message=,d.name="


Value Conversion & Formatting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``to_*`` forms are **deprecated**.

.. glossary::

    convert.kb
    convert.mb
    convert.xb
    to_kb
    to_mb
    to_xb

        **TODO**

    convert.date
    convert.elapsed_time
    convert.gm_date
    convert.gm_time
    convert.time
    to_date
    to_elapsed_time
    to_gm_date
    to_gm_time
    to_time

        **TODO**

    convert.throttle
    to_throttle

        **TODO**

.. END cmd-scripting

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

            method.get = ‹name› ≫ various (see text)

        Returns the definition of a method,
        i.e. its current integer or string value,
        the definition for ``simple`` methods, or
        a dict of command definitions for ``multi`` methods.
        Querying any built-in method (a/k/a non-*dynamic* commands)
        results in a ``Key not found.`` fault.

        The type of the definition can be either string or list,
        depending on whether ``"…"`` or ``((…))`` was used during insertion.

        An example shows best what you get here, if you query the
        commands defined in the :term:`method.insert.value` example,
        you'll get this:

        .. code-block:: shell

            $ rtxmlrpc --repr method.get '' sample.verbose
            1

            $ rtxmlrpc --repr method.get '' sample.verbose.set
            ERROR    While calling method.get('', 'sample.verbose.set'): <Fault -503: 'Key not found.'>

            $ rtxmlrpc --repr method.get '' sample.action
            {'10': ['print', 'action'],
             '20': ['print', 'action2'],
             '99': ['branch', 'sample.verbose=', 'print="Some log message"']}

        ``method.get`` is also great to see what system handlers are registered.
        They often begin with a ``!`` or ``~`` to ensure they sort before / after any user-defined handlers.

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

        .. code-block:: ini

            method.redirect = ‹alias›, ‹target› ≫ 0

        Defines an alias for an existing command, the arguments are command names.
        Aliases cannot be changed, using the same alias name twice causes an error.


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

        **TODO**

    less
    equal
    greater

        .. code-block:: ini

            less = ‹cmd1›[, ‹cmd2›] ≫ bool (0 or 1)
            equal = ‹cmd1›[, ‹cmd2›] ≫ bool (0 or 1)
            greater = ‹cmd1›[, ‹cmd2›] ≫ bool (0 or 1)

        The comparison operators can work with strings or values (integers),
        returned from the given command(s).
        The most common form is with one provided command, that is then
        called for a target (e.g. with :term:`view.filter`)
        or a target pair (e.g. :term:`view.sort_new` or  :term:`view.sort_current`).

        Consider this example, where items are sorted by comparing the names of target pairs,
        and the ``less`` command is called by a typical sorting algorithm:

        .. code-block:: ini

            view.sort_new     = name,((less,((d.name))))
            view.sort_current = name,((less,((d.name))))

        An example for a filter with two commands returning integer values is
        the ``important`` view, showing only items with a high priority:

        .. code-block:: ini

            view.add = important
            ui.current_view.set = important
            method.insert = prio_high, value|const|private, 3
            view.filter = important, "equal=d.priority=,prio_high="

        When two commands are given, their return types must match,
        and each command is called with the target (or the left / right sides of a target pair, respectively).

        As you can see above, to compare against a constant you have to define it as a command.
        If you run *rTorrent-PS*, you can use :term:`value` instead.

        For strings, you can use :term:`cat` as the command, and pass it the text literal.

        .. code-block:: ini

            view.filter = important, ((not, ((equal, ((d.throttle_name)), ((cat)) )) ))
            view.filter = important, ((equal, ((d.throttle_name)), ((cat, NULL)) ))

        Looks strange, like so many things in *rTorrent* scripting.
        The first filter shows all items that have *any* throttle set,
        i.e. have a non-empty throttle name.
        ``((cat))`` is the command that returns that empty string we want to compare against.
        The second filter selects items that have the special unlimited throttle ``NULL`` set.


    elapsed.greater
    elapsed.less

        .. code-block:: ini

            elapsed.greater = ‹start-time›, ‹interval› ≫ bool (0 or 1)
            elapsed.less = ‹start-time›, ‹interval› ≫ bool (0 or 1)

        Compare time elapsed since a given timestamp against an interval in seconds.
        The timestamps are UNIX ones, like created by :term:`system.time_seconds`.
        The result is ``false`` if the timestramp is empty / zero.

        Example:

        .. code-block:: ini

            method.insert.value = cfg.seed_seconds, 259200
            schedule2 = limit_seed_time, 66, 300, "d.multicall.filtered = started,\
                \"elapsed.greater = (d.timestamp.finished), (cfg.seed_seconds)\",\
                d.try_stop="

        What this does is stop any item finished longer than 3 days ago
        (selected via :term:`d.multicall.filtered`),
        unless it is set to ignore commands
        (:term:`d.try_stop` checks the ignore flag before stopping).


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


    value

        .. code-block:: ini

            # rTorrent-PS only
            value = ‹number›[, ‹base›] ≫ value

        Converts a given number with the given base (or 10 as the default) to an integer value.

        Examples:

        .. code-block:: shell

            $ rtxmlrpc -qi 'view.filter = rtcontrol, "equal = d.priority=, value=3"'
            # the 'rtcontrol' view will now show all items with priority 'high'
            $ rtxmlrpc --repr value '' 1b 16
            27
            $ rtxmlrpc --repr value '' 1b
            ERROR    While calling value('', '1b'): <Fault -503: 'Junk at end of number: 1b'>


.. END cmd-scripting

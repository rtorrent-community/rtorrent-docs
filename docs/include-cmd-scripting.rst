.. _method-commands:

`method.*` commands
^^^^^^^^^^^^^^^^^^^

.. glossary::

    method.insert

        .. code-block:: ini

            method.insert = ‹name›, ‹type›[|‹sub-type›…][, ‹definition›] ≫ 0

        The general way to define *any* kind of command.
        See :ref:`object-types` for the possible values in the 2nd argument,
        :ref:`commands-intro` regarding some basic info on custom commands,
        and get comfortable with :ref:`escaping` because you typically need that
        in more complex command definitions.

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


    argument.0
    argument.1
    argument.2
    argument.3

        .. code-block:: ini

            # Internal, not callable from XMLRPC!
            $argument.‹N›= ≫ value of Nth argument

        These can be used to refer to arguments passed into a custom method,
        either via ``$argument.‹N›=`` or ``(argument.‹N›)``.


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

        .. code-block:: console

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

        .. code-block:: console

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

            method.set_key = ‹name›, ‹key›[, ‹definition›] ≫ 0
            method.has_key = ‹name›, ‹key› ≫ bool (0 or 1)
            method.list_keys = ‹name› ≫ list of strings

        Set entries in a ``multi`` method, query a single key, or list them all.
        If you omit the definition in a ``method.set_key`` call, the key is erased
        – it is safe to do that with a non-existing key.

        ``method.set_key`` is commonly used to add handler commands to event types
        like :term:`event.download.finished`.
        It can also be used to split complicated command definitions,
        see :term:`method.insert.value` for an example.

        See the explanation of the :ref:`multi type<multi-type>` for more details.


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

rTorrent events are merely :ref:`multi commands <multi-type>`
that are called automatically when certain things happen,
like completion of a download item.

You can trigger them manually by calling them on selected items (e.g. via ``rtxmlrpc``).
Make sure though that the registered handlers do not have adverse effects when called repeatedly,
i.e. know what you're doing.

The handlers for an event can be listed like so:

.. code-block:: bash

    rtxmlrpc --repr method.get '' event.download.finished

Note that practically all the events have pre-registered system handlers,
often starting with a digit, ``!``, or ``~``, for ordering reasons.


.. glossary::

    event.download.closed
    event.download.opened

        Download item was closed / opened.

    event.download.paused
    event.download.resumed

        Download item was paused / resumed.

    event.download.hash_done
    event.download.hash_failed
    event.download.hash_final_failed

        **TODO**

    event.download.hash_queued
    event.download.hash_removed

        **TODO**

    event.download.inserted
    event.download.inserted_new
    event.download.inserted_session

        ``inserted`` is *always* called when an item is added to the main downloads list.
        After that, ``inserted_session`` is called when the source of that item is the session state (on startup),
        or else ``inserted_new`` is called for items newly added via a ``load`` command.

    event.download.finished

        Download item is complete.

    event.download.erased

        Download item was removed.

    event.view.hide
    event.view.show

        .. rubric:: *since rTorrent-PS 1.1 / rTorrent 0.9.8*

        .. code-block:: ini

            event.view.hide = ‹new-view-name› ≫ 0
            event.view.show = ‹old-view-name› ≫ 0

        These events get called shortly before and after the download list canvas changes to a new view.
        Each gets passed the view name that is *not* available via :term:`ui.current_view`
        at the time of the trigger, i.e. either the new or the old view name.

        Be aware that during startup these view names can be *empty* strings!

        .. rubric:: Event handler example

        .. code-block:: ini

            method.set_key = event.view.hide, ~log,\
                ((print, "× ", ((ui.current_view)), " → ", ((argument.0))))'
            method.set_key = event.view.show, ~log,\
                ((print, "⊞ ", ((argument.0)), " → ", ((ui.current_view))))'



Scheduling Commands
^^^^^^^^^^^^^^^^^^^

The scheduling commands define tasks that call another command or list of commands repeatedly,
just like a cron job, but with a resolution of seconds.

.. glossary::

    schedule2

        .. code-block:: ini

            schedule2 = ‹name›, ‹start›, ‹interval›, ((‹command›[, ‹args›…])) ≫ 0
            schedule2 = ‹name›, ‹start›, ‹interval›, "‹command›=[‹args›…][ ; ‹command›=…]" ≫ 0

        Call the given command(s) every ``interval`` seconds,
        with an initial delay of ``start`` seconds after client startup.
        An interval of zero calls the task once, while a start of zero calls it immediately.

        The ``name`` serves both as a handle for :term:`schedule_remove2`,
        and as an easy way to document what this task actually does.
        Existing tasks can be changed at any time, just use the same name.

        ``start`` and ``interval`` may optionally use a time format like ``[dd:]hh:mm:ss``.
        An interval of ``07:00:00:00`` would mean weekly execution.

        .. rubric:: Examples

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
        Deleting a non-existing task is not an error.


    start_tied
    stop_untied
    close_untied
    remove_untied

        **TODO**

    close_low_diskspace

        **TODO**


.. _cmd-import:

Importing Script Files
^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    import
    try_import

        .. code-block:: ini

            import = ‹rc-file-path› ≫ 0
            try_import = ‹rc-file-path› ≫ 0

        Both of these commands open the given file
        and execute the contained commands, one per logical line.

        Physical ines can be continued by escaping the line end with ``\``.
        The maximum length is 4096 bytes.

        Lines beginning with ``#`` are comments.

        ``try_import`` ignores a missing script file,
        while ``import`` throws an error in that case.

        If you're nesting imports, relative filenames are resolved using :term:`system.cwd`,
        and *not* based on the location of the importing file.

        .. rubric:: Example

        .. code-block:: ini

            import = (cat, (cfg.basedir), "_rtlocal.rc")


    import.return

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            import.return= ≫ throw('import.return')

        Leaves the currently imported file and returns to the level above.

        Since this works by throwing an exception, you will see that
        exception when called *outside* of an imported file.


        .. rubric:: Example: Quick toggle of experimental configuration

        Add a commented ``import.return`` into a configuration file,
        above some code you work on, at the very end of the file.
        Remove the ``#`` to test that code, put it back to ignore your experiment.

        .. code-block:: ini

            #import.return=
            «here be dragons»


        .. rubric:: Example: Protecting imports that use new features

        First, protect the import like this (to make it compatible with older builds):

        .. code-block:: ini

            branch=(system.has, "import.return="), ((import, using-math-stuff.rc))

        Then in the ``using-math-stuff.rc`` file, you can return when certain capabilities are missing.

        .. code-block:: ini

            branch=(not, (system.has, "math.add=")), ((import.return))

        You can do this incrementally ordered from older to younger capabilities,
        using exactly those features a build has to offer.


.. _cond-cmds:

Conditions (if/branch/do)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    branch
    if

        .. code-block:: ini

            branch = ‹condition-cmd›, ‹then-cmds›[, ‹else-cmds›] ≫ 0
            if = ‹condition›, ‹then-cmds›[, ‹else-cmds›] ≫ 0

        Both of these commands take a predicate,
        and based on its value execute either
        the command or commands given as the 2nd argument,
        or else the ones in the 3rd argument.
        See :ref:`cond-ops` below for details on these predicates,
        and :term:`do` for calling several commands in ‘new’ syntax
        as the *then* or *else* part.

        The fundamental difference between ``branch`` and ``if`` is
        the first takes commands to evaluate for the predicate,
        the latter expects values.

        See the following examples for details, these are easier to understand
        than long-winded explanations.
        Take note of the different forms of :ref:`escaping` needed
        when the then/else commands themselves take arguments.

        And always consider adding additional helper methods when you have
        complex multi-command then or else arguments, because escaping escalates fast.
        You also **must** use *double* parentheses if you use those, because otherwise
        *both* ``then`` and ``else`` are already evaluated when the ``branch/if`` itself is,
        which defeats the whole purpose of the conditional.

        .. code-block:: ini

            # Toggle a value between 0 and 1
            method.insert.value = foobar, 0
            method.insert = foobar.toggle, simple, \
                "branch=(foobar), ((foobar.set, 0)), ((foobar.set, 1))"

        Using ``branch=foobar=, …`` is equivalent, just using the older command syntax for the condition.

        .. code-block:: console

            $ rtxmlrpc branch '' greater=value=2,value=2 cat=YES cat=NO
            NO
            $ rtxmlrpc branch '' greater=value=4,value=2 cat=YES cat=NO
            YES

        **TODO:** More examples, using or/and/not and other more complex constructs.


    do

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            do = ‹cmd1›, [, ‹cmd2›…] ≫ 0

        The ``do`` command behaves just like the vanilla :term:`catch` command,
        the only difference being that it doesn't catch exceptions.

        It can be used to group a sequence of commands in ‘new’ syntax,
        for execution as the *then* or *else* command of :term:`if` or :term:`branch`.

        Otherwise you'd need to use ``"cmd1=… ; cmd2=…; …"`` for such a sequence,
        with all the usual escaping problems when calling commands with several arguments.

        .. rubric:: Examples

        .. code-block:: ini

            branch = (system.has, "do="), \
                ((do, \
                    ((print, "Just")), \
                    ((print, "DO")), \
                    ((print, "it!")) \
                )), \
                ((print, "Awwwwww!"))

        .. literalinclude:: rtorrent-ps/tests/commands/misc.txt
            :language: console
            :start-after: # do
            :end-before: # END


.. _cond-ops:

Conditional Operators
^^^^^^^^^^^^^^^^^^^^^

.. glossary::

    false

        Ignores any amount of arguments, and always returns ``0``.

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

        .. rubric:: Example

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

        .. rubric:: *rTorrent-PS 0.x+ only*

        .. code-block:: ini

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

        .. rubric:: Example: Sort a view by message *and* name

        .. code-block:: ini

            view.add = messages
            view.filter = messages, ((d.message))
            view.sort_new = messages, "compare=,d.message=,d.name="


String Functions
^^^^^^^^^^^^^^^^

.. glossary::

    cat

        .. code-block:: ini

            cat=«text»[,…] ≫ string
            cat={"array", "of", "text"}[,…] ≫ string

        ``cat`` takes a list of object arguments, or an array of objects,
        and smushes them all together with no delimiter
        (see :term:`string.join` for the variant *with* a delimiter).

        Note that ``cat`` can be used to feed strings into the parser
        that are otherwise not representable,
        like passing an empty string where a command is expected via ``(cat,)``,
        or text starting with a dollar sign using ``(cat,{$})``.

        .. rubric:: Example

            .. code-block:: ini

                print=(cat, text\ or\ , {"array", " of", " text"})

            will print ``(HH:MM:SS) text or array of text`` to the console.


    string.len
        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.len = «text» ≫ value (length)

        Returns the length of an UTF-8 encoded string in terms of Unicode characters.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/string.txt
            :language: console
            :start-at: # string.len
            :end-before: # END


    string.equals
    string.startswith
    string.endswith

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.equals = «text», «other»[, …] ≫ bool (0 or 1)
            string.startswith = «text», «prefix»[, …] ≫ bool (0 or 1)
            string.endswith = «text», «tail»[, …] ≫ bool (0 or 1)

        Checks whether the first argument is equal to, starts with, or ends with another string.

        If you pass more than two arguments,
        *any* match with the 2nd to last argument will return *true* (1).

        .. rubric:: Examples

        .. code-block:: ini

            # Show ETA column only on 'active' and 'leeching' views
            method.set_key = event.view.show, ~eta_toggle, \
                "branch = \"string.equals=$ui.current_view=, active, leeching\", \
                    ui.column.show=533, ui.column.hide=533"

        .. literalinclude:: rtorrent-ps/tests/commands/string.txt
            :language: console
            :start-after: # string.compare
            :end-before: # END


    string.contains
    string.contains_i

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.contains[_i] = «haystack», «needle»[, …] ≫ bool (0 or 1)

        Checks if a given string contains any of the strings following it.
        The variant with ``_i`` is case-ignoring, but *only* works for pure ASCII needles.

        .. rubric:: Example

        .. code-block:: console

            $ rtxmlrpc d.multicall.filtered '' 'string.contains_i=(d.name),Mate' d.name=
            ['sparkylinux-4.0-x86_64-mate.iso']


    string.substr

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.substr = «text»[, «pos»[, «count»[, «default»]]] ≫ string

        Returns part of an UTF-8 encoded string.
        The positional arguments can be passed as either strings (base 10) or values,
        and they count Unicode characters.
        A negative *«pos»* is relative to the end of the string.

        When *«pos»* is outside the string bounds (including ‘at the end’),
        then *«default»* is returned when provided,
        instead of an empty string.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/string.txt
            :language: console
            :start-at: # string.substr
            :end-before: # END


    string.join
        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.join = «delim»[, «object»[, …]] ≫ string

        Works just like :term:`cat` (including conversion of the passed objects to strings),
        but concatenates the arguments using a provided delimiter.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/string.txt
            :language: console
            :start-at: # string.join
            :end-before: # END


    string.split
        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.split = «text», «delim» ≫ array of string (parts)

        Splits an UTF-8 encoded string into parts delimited by the 2nd argument.
        If that delimiter is the empty string, you'll get a Unicode character array
        of the first argument.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/string.txt
            :language: console
            :start-at: # string.split
            :end-before: # END


    string.map
    string.replace

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            string.map = «text», {«old»,«new»}[, …] ≫ string
            string.replace = «text», {«old»,«new»}[, …] ≫ string

        ``string.map`` scans a list of replacement pairs for an ``old`` text that matches
        *all* of the given string, and replaces it by ``new``.

        ``string.replace`` substitutes any occurence of the old text by the new one.

        .. rubric:: Examples

        .. code-block:: console

            $ rtxmlrpc string.map '' 'foo' [foo,bar [bar,baz
            baz

            $ rtxmlrpc string.replace '' "it's like 1" [1,2ic [2,ma3 [3,g
            it's like magic

            $ rtxmlrpc -i 'print = (string.map, (cat, (value,1)), {0,off}, {1,low}, {2,""}, {3,high})'
            # prints 'low' as a console message, this is how you map integers


Array Functions
^^^^^^^^^^^^^^^

.. glossary::

    array.at

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            array.at = «array», «pos» ≫ object (element)

        **TODO**

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/array.txt
            :language: console
            :start-at: # array.at
            :end-before: # END


Math Functions
^^^^^^^^^^^^^^

Most of these commands are available in `rTorrent-PS` 1.1+, in `rTorrent-PS-CH`,
and `rTorrent` 0.9.7+. Deviations are explicitly noted.

Values can either be of type *value* or *string* –
strings are automatically converted,
with an error thrown when the string contains something other than digits.

The handled values are restricted to integer arithmetic (as in `bash`),
because `rTorrent` has no floating point type.
Division, average, and median always round down.

All commands support multiple arguments, including lists.
List arguments are handled recursively,
as-if there were a nested `math.*` call of the same type,
with the list as its arguments.

When using multiple list arguments, or mixing them with plain numbers,
this can lead to unexpected results with non-commutative operators,
see the ``math.sub`` examples below.


.. glossary::

    math.add
    math.sub
    math.mul
    math.div
    math.mod

        Basic arithmetic operators (+, -, *, /, %).

        These share the same code, so the errors shown in the following examples
        usually apply to all commands, and are not repeated for each operator.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.add
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.sub
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.mul
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.div
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.mod
            :end-before: # END


    math.min
    math.max
    math.cnt
    math.avg
    math.med

        Functions to calculate the minimum, maximum, element count, average, or median over the input values.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.min
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.max
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.cnt
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.avg
            :end-before: # END

        .. literalinclude:: rtorrent-ps/tests/commands/math.txt
            :language: console
            :start-at: # math.med
            :end-before: # END


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

    convert.time_delta

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            convert.time_delta = ‹timestamp›[, ‹timebase›] ≫ string

        Converts the difference of two timestamps into
        an approximate but short and human readable representation
        (the result is always 5 chars wide).

        If ``timestamp`` is zero, the result is ``⋅␣⋅⋅␣``.
        If ``timebase`` is missing or zero, the current time is used instead.

        .. rubric:: Examples

        .. literalinclude:: rtorrent-ps/tests/commands/misc.txt
            :language: console
            :start-at: # convert.time_delta
            :end-before: # END


    convert.human_size

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            convert.human_size = ‹bytes›[, ‹format›] ≫ string

        Converts a size in bytes to a compact, human readable string.
        See also :term:`convert.xb` for a similar command.

        Format is a number (default 2), with these values:

        * ``0``: use 6 chars (one decimal place)
        * ``1``: just print the rounded value (4 chars)
        * ``2``: combine the two formats into 4 chars by rounding for values >= 9.95
        * ``+8``: adding 8 converts zero values to whitespace of the correct length

        Examples:

        .. code-block:: console

            $ rtxmlrpc --repr convert.human_size '' +970 +0
            '  0.9K'
            $ rtxmlrpc --repr convert.human_size '' +970 +1
            '  1K'
            $ rtxmlrpc --repr convert.human_size '' +970 +10
            '0.9K'
            $ rtxmlrpc --repr convert.human_size '' +0 +2
            '0.0K'
            $ rtxmlrpc --repr convert.human_size '' +0 +10
            '    '


    convert.magnitude

        .. rubric:: *rTorrent-PS 1.1+ only*

        .. code-block:: ini

            convert.magnitude = ‹number› ≫ string

        Converts any positive number below 10 million into
        a very compact string representation with only 2 characters.
        Above 99, only the first significant digit is retained,
        plus an order of magnitude indicator using roman numerals
        (c = 10², m = 10³, X = 10⁴, C = 10⁵, M = 10⁶).
        Zero and out of range values are handled special (see examples below).

        Examples:

        .. code-block:: console

            $ rtxmlrpc convert.magnitude '' +0
             ·
            $ rtxmlrpc convert.magnitude '' +1
             1
            $ rtxmlrpc convert.magnitude '' +99
            99
            $ rtxmlrpc convert.magnitude '' +100
            1c
            $ rtxmlrpc convert.magnitude '' +999
            9c
            $ rtxmlrpc convert.magnitude '' +1000
            1m
            $ rtxmlrpc convert.magnitude '' +9999999
            9M
            $ rtxmlrpc convert.magnitude '' +10000000
            ♯♯
            $ rtxmlrpc -- convert.magnitude '' -1
            ♯♯


    value

        .. rubric:: *since rTorrent-PS 1.1 / rTorrent 0.9.8*

        .. code-block:: ini

            value = ‹number›[, ‹base›] ≫ value

        Converts a given number with the given base (or 10 as the default) to an integer value.

        Examples:

        .. code-block:: console

            $ rtxmlrpc -qi 'view.filter = rtcontrol, "equal = d.priority=, value=3"'
            # the 'rtcontrol' view will now show all items with priority 'high'
            $ rtxmlrpc --repr value '' 1b 16
            27
            $ rtxmlrpc --repr value '' 1b
            ERROR    While calling value('', '1b'): <Fault -503: 'Junk at end of number: 1b'>


.. END cmd-scripting

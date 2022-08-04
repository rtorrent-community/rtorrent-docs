Scripting Guide
===============

Building on the :doc:`cookbook`, this chapter explains more complex commands and
constructs of the scripting language. It also helps with controlling *rTorrent*
from the outside, via the XMLRPC protocol.

It is to become the comprehensive reference to rTorrent's
command language that was always missing, and will only be a success
when enough people join forces and thus spread the workload to many shoulders.
If you're a developer or power user, this will be an invaluable tool,
so please take the time and :doc:`contribute what you know <contributing>`.

See the :doc:`cmd-ref` chapter for a list of all relevant XMLRPC and ‘private’ commands
of *rTorrent* with a short explanation.
The :ref:`generated index <genindex>` also lists all the command names.

Another helpful tool is the quite powerful *GitHub* search.
Use it  to find information on commands,
e.g. their old vs. new syntax variants, what they actually do (i.e. “read the source”),
and internal uses in predefined methods, handlers, and schedules.
Consider the `view.add <https://github.com/rakshasa/rtorrent/search?utf8=%E2%9C%93&q=%22view.add%22>`_ example.


Introduction
------------

*rTorrent* scripting uses a strictly line-oriented syntax,
with no control structures that span several logical lines.
Read :ref:`basic-syntax` (again) regarding the most fundamental syntax rules.
If you skipped :ref:`config-deconstructed`, now is the time to go through it,
since it exposes you to common idioms while explaining the core config commands.

Here's also a short command syntax summary:

* Comments start with a ``#``.
* Line continuations work by escaping the line end with ``\``.
* Commands take the form ``cmd = arg, …`` (‘old’ syntax) or ``(cmd, arg, …)`` (‘new’ syntax).
* Arguments are a comma-separated list: ``arg1, arg2, …``.
* ``$cmd=…`` evaluates ``cmd`` and inserts its result value in place of the call.
  A command in single parentheses is also immediately evaluated.
* Use double quotes for preserving whitespace, or to pass statements
  as arguments to other commands (like :term:`method.insert` and :term:`schedule2`).
  Use ``\"`` to escape quotes within quoted strings.
* Within double quotes, a semicolon ``;`` can be used as a delimiter to pass command *sequences*,
  e.g. in event handler bodies and scheduled commands.
* Use double parentheses to pass a command unevaluated to another command.
* Braces ``{…, …}`` pass a list as an argument, used for setting list values,
  or with boolean operators.
* All commands are defined in the *C++* source files ``rtorrent/src/command_*.cc``
  of the client's source code, which is the ultimate reference
  when it comes to intricate details.


.. _commands-intro:

Commands
^^^^^^^^

A command is basically a function call or *method*, used to either query or change a configuration setting,
or cause some side-effect at runtime.
They're called by the configuration file parser, timed schedules, event handlers, and via XMLRPC.

See :ref:`object-types` for the difference between simple and ‘multi’ commands,
and what return types commands can have.
You can use :term:`method.redirect` to define alias names for commands,
which is mostly used internally to keep deprecated command names alive for a while.

A deep-dive into defining your own commands can be found in the
:ref:`reference of related method.* commands <method-commands>`.

Use the :doc:`cmd-ref` for details on specific commands,
and the :ref:`generated index <genindex>` to find them by name.


.. _escaping:

Escaping
^^^^^^^^

The most basic form of escaping are literal string values that contain spaces.
Use double quotes for that as in ``"this example"``.

Quotes must also be used when you have to supply a command
with multiple arguments to another command as part of an argument list.
You have to tell rTorrent which comma belongs to the inner argument
list, and which to the outer one, by quoting the inner command using
double quotation marks:

.. code-block:: ini

    outer = arg1, "inner=arg21,arg22", arg3

To have a string literal or another command in a quote, escape
quotes with a backslash.
In practice, anything but a single nested quote should be avoided,
because the next level already gives you the ``\\\"`` awkwardness.
See :ref:`best-practices` for more on that.


.. _object-types:

Object Types
^^^^^^^^^^^^

This is a summary about the possible object types in
`command_dynamic.cc <https://github.com/rakshasa/rtorrent/blob/master/src/command_dynamic.cc>`_
(applies to ``0.9.6``).

Subtypes determine certain traits of a command, like immutability (``const``, enabled directly
in a definition, or via :term:`method.const.enable`).
If a command is ``private``, it can only be called from within rTorrent, but not directly via XMLRPC
– it will thus also be excluded from :term:`system.listMethods`.

**TODO** static?!


.. _basic-type:

value, bool, string, list (subtypes: static, private, const)
   These are the standard object types, ``value`` is an integer,
   and ``bool`` just a convention of using the integer values ``0`` for :term:`false` and ``1`` for true.

   Lists are either generated by commands that return multiple values, like :term:`download_list`,
   or defined literally using the ``{val[, …]}`` syntax to pass them *into* commands.

   .. seealso::

        :term:`method.insert.value`


.. _simple-type:

simple (subtypes: static, private, const)
   Simple commands are defined once and cannot be changed dynamically like ``multi`` ones.
   They can still contain a sequence of several commands in a given order,
   using ``"cmd1=… ; cmd2=…"`` or ``(( (cmd1,…), (cmd2,…) ))``.

   .. important::

        Be aware of the time of evaluation of commands in method definitions.

        Quoted command sequences are parsed on each execution and thus only evaluated then,
        while using parentheses means *instant* evaluation for a single pair,
        and delayed evaluation for commands in double parentheses.

        That delay is *not* inherited by nested commands.
        So ``((cat, (manifest.constant) ))`` works as intended,
        while ``((if, (dynamic.value), … ))`` does not (the inner call *also* needs double parentheses)!

        Which means you always have to keep the surrounding context in mind
        when writing nested command sequences.

   .. seealso::

        :term:`method.insert.simple`


.. _multi-type:

multi (subtypes: static, private, const, rlookup)
   A multi command is an array of ``simple`` commands, indexed by a name.
   When you call a multi command, the sequence is executed in order of the keys
   used when defining a single command of the sequence.

   Multi commands are used at many places in rTorrent,
   especially where dynamic user-defined behaviour is needed.
   All the :ref:`event handlers <event-commands>` are of type ``multi``.

   Note that many internal entries in multi commands used by the system are prefixed
   with either ``!`` or ``~``, to push them to the front or end of the processing order.

   The ``rlookup`` flag enables a reverse index from method keys to method names.
   See :term:`method.rlookup` for more details on that.

   .. seealso::

        :term:`method.insert`,
        :term:`method.set_key`


.. _fmt-type-conv:

Formatting & Type Conversions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Many commands are specific as to what type they expect for their arguments
– that is when you need type conversion commands.
There's also some commands that take an input value and format it,
typically for human consumption. The time and byte size conversion methods serve this purpose.

The :term:`cat` command is the Swiss army knife of conversion,
and makes a string of practically all `rTorrent` types.
:term:`string.join` is the same, but takes a delimiter string that is added between the converted parts.

To coerce strings to integers, use :term:`value` – it takes an optional base value,
and also returns arguments that already *are* an integer as-is.

The ``convert.*`` command group with methods like :term:`convert.elapsed_time`
is mostly of the ‘format values for humans’ variety,

See :ref:`conversion` for all the formatting helper details.


Custom Attributes
^^^^^^^^^^^^^^^^^

Custom attributes allow you to store additional information on an item,
in the form of key / value pairs.
There are 5 numbered slots, and unlimited named attributes.

The numbered forms like :term:`d.custom1` are very limited and thus overcrowded.
Old software like `ruTorrent` that also never changed to the new named forms pretty much hogs these
– colliding use can lead to all sorts of problems and misbehaviour.

So avoid the old numbered forms and instead prefer the named custom attributes,
while also using *unique* names.
Use :term:`d.custom` to get a named value, and :term:`d.custom.set` to change one.
The form :term:`d.custom_throw` raises an error if you query a non-existent key.

The only ‘old’ command you *should* use is :term:`d.custom1`, and *only* with `ruTorrent`'s
semantics of using it as a category label.
So you might refer to it in a completion event handler for target path building,
or set it in watch schedules for use by `ruTorrent`.

There are also commands that allow more versatile access, but are not available yet everywhere
(see the command reference for availability).
:term:`d.custom.as_value` gets a custom attribute as a number,
and :term:`d.custom.if_z` returns a default value for empty values.
To remove a key, use :term:`d.custom.erase`.
The commands :term:`d.custom.keys` and :term:`d.custom.items` return
all keys or key/value pairs for an item.
To define a value only once use :term:`d.custom.set_if_z`,
and finally :term:`d.custom.toggle` can be used to invert bools.


Advanced Concepts
-----------------


‘✴.multicall’ Demystified
^^^^^^^^^^^^^^^^^^^^^^^^^

A multicall applies a given list of commands repeatedly on a set of objects,
passing each object to the command calls and collecting the results in a 2-dimensional array
(a list of lists).
Each row is as long as the list of commands,
and there are as many rows as objects.
It is the only form of looping `rTorrent` knows about.

All multicall variants stem from the XMLRPC-C :term:`system.multicall` built-in,
which allows to call several arbitrary commands in a single request.

Other forms apply a set of commands to a set of entries in various lists:

 * :term:`d.multicall2` iterates over all download items in a given view
 * :term:`f.multicall` applies ``f.*`` commands to all files in an item
 * :term:`p.multicall` works on the peer list
 * :term:`t.multicall` goes through the tracker list

Follow the links to the command references to get more details and see some examples.

`rTorrent-PS` and maybe `rTorrent` 0.9.8+ also has :term:`d.multicall.filtered`,
which takes an additional argument after the view name to only apply
commands to items that satisfy the given filter condition.
This can greatly reduce the amount of information that
has to be passed back in an XMLRPC response,
when you'd otherwise discard most of the items after client-side filtering.


.. _best-practices:

Scripting Best Practices
------------------------

**TODO**

Form Follows Function
^^^^^^^^^^^^^^^^^^^^^

Format your code so that it is naturally broken down into its structural parts.
This greatly helps others to understand what's going on,
and your future self has a chance to understand what you wrote a while ago, too.

It's good style to avoid deep nesting of quotes by defining helper commands
(see :term:`method.insert`, and also :ref:`config-deconstructed`
and :doc:`use-cases` for many examples).

You can then use these building blocks in another command, instead of a
literal nested group. The additional benefit is you can name things for
documentation purposes, and also avoid overly long lines.

In practice, anything but a single nested quote should be avoided,
because the next level already gives you the ``\\\"`` awkwardness.

Make *plenty* use of line continuations, i.e. escaping of line ends to
break up long physical lines into several short ones. Put the breaks
into places where you can use any amount of whitespace, and then indent
the parts according to the structure of the logical line.

.. code-block:: ini

    method.insert = indent_sequence_of_cmds_and_their_args, private|simple,\
        "load.verbose =\
            (cat, (cfg.watch), (argument.0), /*.torrent),\
            (cat, d.category.set=, (argument.0)) ;\
         category.view.update = (argument.0)"

    schedule2 = polling, 10, 120,\
        ((d.multicall2, main,\
            "branch=\"or={d.up.rate=,d.down.rate=,}\",\
                poll=$interval.active=,\
                poll=$interval.idle="))

Also note how using combinations of ‘new’ and ‘old’ syntax
keeps the needed amount of escaping at bay
(double parentheses are also a form of escaping).


.. _xmlrpc-api:

Using XMLRPC for Remote Control
-------------------------------

XMLRPC is the remote interface rTorrent offers to execute commands *after* startup in a running process.
Commands are sent via either a UNIX domain socket or a TCP socket using a protocol called SCGI,
typically used between a web server and a long-running CGI process.

The ``/RPC2`` mount some software needs just bridges that internal connection to a full HTTP end point.
Any XMLRPC library can be used against such a HTTP gateway, while using the ‘raw’ SCGI end point
requires special client libraries that speak that protocol (see below).

Commands usable via XMLRPC are *almost* the same you can use in configuration files.
Differences are:

 * There is the concept of *internal* commands that are not exposed to XMLRPC,
   and only available in configuration and via the ``Ctrl-X`` prompt.
   You can circumvent that restriction by putting commands into a file, and
   then :term:`import`\ ing that.
 * You (almost) *always* have to pass the so-called *target* which is the object the command should act on,
   like a download item or a peer or file entry. See below for details.

See the :doc:`cmd-ref` for descriptions of existing commands,
the :ref:`generated index <genindex>` can help you to quickly find them by their name.


.. rubric:: Command Targets

All XMLRPC commands (with a few exceptions like :term:`system.listMethods`)
take an info hash as the first argument when called over the API,
to uniquely identify the *target* object.
‘Target’ is also the term used for that first parameter in error messages like
``Unsupported target type found``,
and that message is the one you'll most likely get if you forgot to provide one.

Commands that do not target a specific item still need to have one (in newer versions
of *rTorrent*), so provide an empty string as a placeholder in those cases.

.. code-block:: console

    $ rtxmlrpc view.size default
    ERROR    While calling view.size('default'): <Fault -501: 'Unsupported target type found.'>
    $ rtxmlrpc view.size '' default
    133

Note that :ref:`f-commands`, :ref:`p-commands`, and :ref:`t-commands`,
when not called via their associated multicall command,
have special target forms with additional information appended:
`‹infohash›:f‹file-index›`, `‹infohash›:p‹peer-id›`, and `‹infohash›:t‹tracker-index›`.


.. rubric:: Configuration Considerations

Be aware of the security implications of opening a XMLRPC socket,
as described in the :term:`network.scgi.open_port` reference
– you **must** safe-guard it via file level permissions or HTTP authorization.
A TCP socket generally is open to *all* local users on a machine,
unless you use network namespaces.
That is why it is deprecated and a secured UNIX domain socket is better in all regards.

If you activate the `daemon mode`_ introduced with rTorrent *0.9.7*,
using XMLRPC is the *only* way to control a running rTorrent process

Regarding available commands, the ``-D``, ``-I``, and ``-K`` :ref:`command line options <rtorrent-cli>`
switch the *deprecated* and *intermediate* command groups off during startup.
The related :term:`method.use_deprecated` and :term:`method.use_intermediate` commands
reflect those options.
If you run badly maintained or abandoned client software,
you still need to keep the deprecated commands active.
See :ref:`intermediate-commands` for more details.

XMLRPC payloads can get quite large, especially when you get a large list of attributes
for all loaded items.
The :term:`network.xmlrpc.size_limit.set` command determines the size of the buffer used to hold those payloads.
Use ``16M`` or more for larger instances, for example getting 20 attributes for 10,000 items
generates a 1.4 KiB request, resulting in a roughly 10 MiB response.


.. rubric:: Client Libraries

**TODO**


.. _`daemon mode`: https://github.com/rakshasa/rtorrent/wiki/Daemon_Mode

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
* Use double parentheses to pass a command unevaluated to another command.
* Braces ``{…, …}`` pass a list as an argument, used for setting list values,
  or with boolean operators.
* All commands are defined in the *C++* source files ``rtorrent/src/command_*.cc``
  of the client's source code, which is the ultimate reference
  when it comes to intricate details.


Commands
^^^^^^^^

A command is ... It's called by ...

A deep-dive into defining your own commands can be found in the
:ref:`reference of related commands <method-commands>`.

Use the :doc:`cmd-ref` for details on specific commands,
and the :ref:`generated index <genindex>` to find them by name.


Escaping
^^^^^^^^

The most basic form of escaping is when you have to supply a command
with multiple arguments to another command as part of an argument list.
You have to tell rTorrent which comma belongs to the inner argument
list, and which to the outer one, by quoting the inner command using
double quotation marks:

.. code-block:: ini

    outer = arg1, "inner=arg21,arg22", arg3

It's also good style to avoid deep nesting by defining your own custom
commands (see :term:`method.insert`, and also :ref:`config-deconstructed`
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


.. _object-types:

Object Types
^^^^^^^^^^^^

This is a summary about the possible object types in
`command_dynamic.cc <https://github.com/rakshasa/rtorrent/blob/master/src/command_dynamic.cc>`_
(applies to ``0.9.6``).

 * multi (with subtypes: static, private, const, rlookup)

   * **TODO:** what is it

 * simple (with subtypes: static, private, const)

   * **TODO:** why is it "simple"

 * value, bool, string, list (with subtypes: static, private, const)

   * Standard types, ``value`` is an integer.


Formatting & Type Conversions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO**


Custom Attributes
^^^^^^^^^^^^^^^^^

**TODO**



Advanced Concepts
-----------------


‘✴.multicall’ Demystified
^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO**


Scripting Best Practices
------------------------

**TODO**


.. _xmlrpc-api:

Using XMLRPC for Remote Control
-------------------------------

See the :doc:`cmd-ref` for descriptions of existing commands,
the :ref:`generated index <genindex>` can help you to quickly find them by their name.

All XMLPPC commands (with a few exceptions like :term:`system.listMethods`)
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


**TODO**

* TCP vs. Unix domain sockets
* raw SCGI vs. HTTP gateways
* XMLRPC buffer size
* client libs
* daemon mode

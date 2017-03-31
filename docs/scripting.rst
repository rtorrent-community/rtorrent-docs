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
The :ref:`generated index <genindex>` also lists all the commmand names.

Another helpful tool is the quite powerful *GitHub* search.
Use it  to find information on commands,
e.g. their old vs. new syntax variants, what they actually do (i.e. “read the source”),
and internal uses in predefined methods, handlers, and schedules.
Consider the `view.add <https://github.com/rakshasa/rtorrent/search?utf8=%E2%9C%93&q=%22view.add%22>`_ example.


Introduction
------------

**TODO**


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


Advanced Concepts
-----------------


‘✴.multicall’ Demystified
^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO**


Scripting Best Practices
------------------------

**TODO**


Using XMLRPC for Remote Control
-------------------------------

**TODO**

* TCP vs. Unix domain sockets
* raw SCGI vs. HTTP gateways
* XMLRPC buffer size
* client libs
* daemon mode

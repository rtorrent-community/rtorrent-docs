Configuration Quick Start
=========================

To help you with fundamental configuration tasks, this chapter contains a quick start
into the ‘scripting language’ rTorrent uses for its configuration files.
:ref:`config-deconstructed` uses a basic configuration file to explain what
the contained commands are doing, also showing common syntax constructs by example.

The next chapter then dives into some :doc:`use-cases`,
adding more features to that basic configuration.

The `ArchLinux wiki page`_ is also a good source on *rTorrent* in general
and its configuration in particular.

.. _new-syntax:

.. note::

    *rTorrent* started to rename a lot of configuration commands
    with the release of version ``0.8.9``.
    This handbook uses the new commands throughout,
    and does not mention the old ones.

    See the `RPC Migration 0.9`_ wiki page for more details.
    That pages also links to a `sed script`_ that can transform old snippets
    you found on the web and might want to use to using the new command names.

    :ref:`rtorrent-cli` section shows you how you can prevent *rTorrent* from adding
    most of the old names as aliases for the new ones, by using the ``-D -I``
    command line options.


.. _`RPC Migration 0.9`: https://github.com/rakshasa/rtorrent/wiki/RPC-Migration-0.9
.. _`sed script`: https://github.com/rakshasa/rtorrent/blob/master/doc/scripts/update_commands_0.9.sed
.. _`ArchLinux wiki page`: https://wiki.archlinux.org/title/Rtorrent


.. _rtorrent-basics:

rTorrent Basics
---------------

We're assuming you used one of the ways in the :doc:`installation` to
add the *rTorrent* binary to your host, ready to be configured and started.
Try calling ``rtorrent -h`` to make sure that worked.

To be really useful, *rTorrent* must be given a basic configuration file,
with some essential settings that ensure you get more than the bare-bones defaults.
Follow the configuration steps in this chapter on a fresh installation,
then try to start *rTorrent* and initiate your first downloads.
Or check if you see something you want to add to your existing setup.

After some time, when you're familiar with the basic operation of *rTorrent*,
try to work through the :doc:`scripting` if you want to dive deeper into
customizing *rTorrent*.


.. _config-template:

Modernized Configuration Template
---------------------------------

Any configuration should start with using the modernized `rTorrent wiki config template`_.
The configuration is loaded from the file ``~/.rtorrent.rc`` by
default (that is the hidden file ``.rtorrent.rc`` in your user home
directory). This command fetches the template from *GitHub* and writes it
into that file:

.. code-block:: shell

    curl -Ls "https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md" \
        | grep -A9999 '^######' | grep -B9999 '^### END' \
        | sed -re "s:/home/USERNAME:$HOME:" >~/.rtorrent.rc
    mkdir ~/rtorrent  # create user's instance directory

All files *rTorrent* uses or creates are located in the ``~/rtorrent`` directory,
except the main configuration file.

Here is a copy of the template in full, see :ref:`config-deconstructed`
below for a detailed explanation of its parts.

.. literalinclude:: rtorrent.rc
   :language: ini


.. _`rTorrent wiki config template`: https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template


.. _rtorrent-cli:

The rTorrent Command Line
-------------------------

Calling ``rtorrent -h`` shows this usage message regarding command line options
(with the last three missing):

.. code-block:: none

    Usage: rtorrent [OPTIONS]... [FILE]... [URL]...
      -h                Display this very helpful text
      -n                Don't try to load ~/.rtorrent.rc on startup
      -b <a.b.c.d>      Bind the listening socket to this IP
      -i <a.b.c.d>      Change the IP that is sent to the tracker
      -p <int>-<int>    Set port range for incoming connections
      -d <directory>    Save torrents to this directory by default
      -s <directory>    Set the session directory
      -o key=opt,...    Set options, see 'rtorrent.rc' file

      -D                Disable deprecated commands
      -I                Disable intermediate commands
      -K                Allow intermediate commands without XMLRPC (just in config files)

The really useful ones are ``-n`` and ``-o import=‹file›``,
to load configuration from a non-standard location.
Everything else is better set in a configuration file.

It is recommended to add ``-D`` and ``-I`` to your start script,
so that all the old command names are gone. However, some external
software (web UIs and so on) might not be able to work with such a
reduced command set.
Also be aware that those undocumented switches changed their semantics
with the release of ``0.9.6`` – the above shows the current situation.

And here is a simple start script that you should use before you tackle
auto-starting *rTorrent* at boot time. First make it work for you,
then add the bells and whistles. Copy the script to ``~/rtorrent/start``,
and make it executable using ``chmod a+x ~/rtorrent/start``.

.. literalinclude:: start.sh
   :language: shell

You can call it in a simple shell prompt first, but for normal operation
it must be launched in a ``tmux`` session, like so:

.. code-block:: shell

   tmux -2u new -n rTorrent -s rtorrent "~/rtorrent/start; exec bash"

The ``exec bash`` keeps your ``tmux`` window open if *rTorrent* exits,
which allows you to actually read any error messages in case it exited unexpectedly.

You can of course add more elaborate start scripts,
like a cron watchdog, init.d scripts or systemd units,
see the *rTorrent* wiki for examples.


.. _basic-syntax:

Basic Syntax Elements
---------------------

The configuration ‘scripts’ have some usual syntax elements, and some not so usual ones.
If you're versed in *any* computer language, you surely spotted some of them in the
:ref:`config-template`.
Comments start with a ``#``,
and you can break long lines apart by escaping the line ends with ``\``.

The basic structure of lines is ``‹command› = ‹arg1›[, ‹arg2›, …]``.
In configuration files, the ``command`` either sets some value, or has some side effect:
defining a method or schedule, executing a OS command, and so on.
This is the ‘old’ syntax, and still relevant on the top level of configuration files.

Other elements are escaped text in quotes (these are *not* strings in the classical sense),
lists in braces ``{…}``, and commands in single or double parentheses ``(…)``.
At some places, a semicolon ``;`` separates multiple commands executed in sequence.

Quoted text keeps words separated by spaces together,
passing all of it as a single argument to a command – quite similar to a string.
However, simple words do not need to be escaped; simply put,
everything that's not a command is a string.

Quoting can be nested, but the inner quotes have to be escaped using ``\``,
and on the third level the backslashes have to be escaped too, leading to abominations like
``"…\"…\\\"…\\\"…\"…"``.
Just avoid that, keep it to two levels at most,
e.g. quoted text within a quoted sequence of commands.
If you need more complex structures, work with helper methods
where you can ‘start fresh’ when it comes to escaping levels.

Be pragmatic, and have no fear of mixing ‘old’ and ‘new’ syntax to your advantage.
Prefer the new one with parentheses,
but that your syntax works and does the thing you want is most important,
readability is next, and any theoretical purity of syntax ideas come in last.


.. _config-deconstructed:

Config Template Deconstructed
-----------------------------

With the most basic syntax elements explained, let's look at the configuration template again.

First, some manifest constants used in later commands are defined,
with the most important one being the instance's root directory, named ``cfg.basedir``.
The ``cfg.`` part is nothing special, just a way to group command names and establish
namespaces to avoid naming collisions.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Instance layout
   :end-before: Create instance

The :term:`method.insert` defines new commands, in this case ``private`` ones that are
only visible within *rTorrent*, but not exposed via the XMLRPC API.
They're ``const`` and thus only evaluated once – if you look at ``cfg.logfile`` that
becomes important, because :term:`system.time` is called only once, during definition.
Their type is ``string``, other types are ``value`` and ``simple``.

The :term:`cat` command concatenates its arguments to a single string,
in this case the 3rd argument to :term:`method.insert`,
which is the value that is assigned to the method's name.
Text in parentheses are command calls, most notably ``(cfg.basedir)``
is used to refer to the definition of the root directory everything else is based upon.

The root directory and sub-folders contained in it, that are referenced by various
commands further below, are created by calling ``mkdir``.
It is wrapped in a call to ``bash``,
because we ``cd`` into the instance root first and use ``&&`` to execute ``mkdir`` after it.
Also, the ``{brace expansion}`` syntax helps to concisely list all the sub-folder names.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Create instance
   :end-before: Listening port

Next, the listening port for incoming peer traffic is set using the associated commands
:term:`network.port_range.set` and :term:`network.port_random.set`.
As shown, the single port number ``50000`` is used.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Listening port
   :end-before: Tracker-less

The settings for tracker-less torrents :term:`dht.mode.set`,
peer exchanges :term:`protocol.pex.set`,
and UDP tracker support :term:`trackers.use_udp.set` are
conservative ones for 'private' trackers.
Change them accordingly for using 'public' trackers.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: conservative settings
   :end-before: Peer settings

The :ref:`throttle-commands` set minimal demands and upper limits on the amount of peers
for incomplete and seeding items.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Peer settings
   :end-before: Limits for file handle

Next file handle resource limits are defined using some :ref:`network-commands`.
The values used are optimized for an `ulimit` of 1024,
which is a common default in many Linux systems.
You **MUST** leave a ceiling of handles reserved for internal use,
that is why they only add up to 950.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: ceiling of handles
   :end-before: Memory resource

The command :term:`pieces.memory.max.set` determines the size of the memory region
used by *rTorrent* to map chunks of files for receiving from and sending to peers.

XMLRPC payloads cannot be larger than what :term:`network.xmlrpc.size_limit.set` specifies,
the size you need depends on how many items you have loaded,
and also what software is using the XMLRPC port.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: available resources
   :end-before: Basic operational settings

The :term:`session.path.set` command sets the location of the directory where *rTorrent*
saves its status between starts – a command you should *always* have in your configuration.
The default download location for data is set by :term:`directory.default.set`.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Basic operational settings
   :end-before: Other operational settings

The :term:`log.execute` and :term:`log.xmlrpc` commands open related log files,
which can be very helpful when debugging problems of added extensions.
The :term:`execute.nothrow` writes a PID file to the session directory.

There are some other operational settings that don't apply equally to every setup,
so check if the values fit for you, and uncomment those settings you want to activate.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Other operational settings
   :end-before: Some additional values and commands

The next section defines some additional values and commands.
``system.startup_time`` memorizes the time *rTorrent* was last started,
:term:`d.data_path` returns the path to an item's data,
and :term:`d.session_file` the path to its session file.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Some additional values and commands
   :end-before: Watch directories

*Watch directories* are an important concept to automatically load metafiles you drop
into those directories.
They use the :term:`schedule2` command to *watch* these locations,
by calling one of the :ref:`load-commands` on a regular basis,
taking a directory path and a pattern of files to watch out for.
Each schedule must be given a *unique* name, in the simplest case just
give them numbers like ``watch_01``, ``watch_02``, and so on.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Watch directories
   :end-before: Logging

Finally, the logging facility of *rTorrent* is configured,
opening a log file using :term:`log.open_file`,
giving it a name and a location.
The path to that file is also shown on the console at startup,
with the :term:`print` command.
You can have several of these files, and if you enable the ``debug`` level
for a logging group (see below), it is recommended to put that in a separate file.

Log messages are classified into groups
(``connection``, ``dht``, ``peer``, ``rpc``, ``storage``, ``thread``, ``tracker``, and ``torrent``),
and have a level of ``critical``, ``error``, ``warn``, ``notice``, ``info``, or ``debug``.

With :term:`log.add_output` you can add a logging scope to a named log file.
Scopes can either be a whole level,
or else a group on a specific level by using ``‹group›_‹level›`` as the scope's name.

.. literalinclude:: rtorrent.rc
   :language: ini
   :start-after: Groups = connection
   :end-before: END of

And that's it, more details on using commands are in the :doc:`scripting`,
and more examples can be found in the following chapter.

.. _method-commands:

`method.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO**


.. _event-commands:

`event.*` commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

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

        ``compare = <order>, <sort_key>=[, ...]`` **rTorrent-PS only**

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

.. glossary::

    to_kb
    to_mb
    to_xb

        **TODO**

    to_date
    to_elapsed_time
    to_gm_date
    to_gm_time
    to_time

        **TODO**

    to_throttle

        **TODO**

.. END cmd-scripting

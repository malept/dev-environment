Development Environment Configuration Management
================================================

SaltStack_-based configuration management for Mark's development
environment(s).

.. _SaltStack: http://docs.saltstack.com/

Bootstrap
=========

.. code:: shell

   wget -O - https://raw.githubusercontent.com/malept/dev-environment/master/bootstrap.sh | \
     bash -s -- $MINION_FILE # $LOCAL_PILLAR (optional)

License
-------

This work is copyright © 2014, 2015, 2016 Mark Lee, under the `Apache License`_
(version 2).

.. _Apache License: https://www.apache.org/licenses/LICENSE-2.0

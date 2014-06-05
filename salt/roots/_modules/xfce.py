# -*- coding: utf-8 -*-
#
# Copyright (C) 2014 Mark Lee
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

try:
    from shlex import quote
except ImportError:
    from pipes import quote

# Don't shadow built-in identifiers.
__func_alias__ = {
    'set_': 'set'
}


def _xfconf_query(user, channel, prop_name, prop_value=None, prop_type=None,
                  create_if_not_exists=False):
    cmd = ('dbus-launch --exit-with-session xfconf-query '
           '-c {0} -p {1}').format(quote(channel), quote(prop_name))
    if prop_value is not None:
        if create_if_not_exists:
            cmd += ' -n'
        if prop_type is not None:
            cmd += ' -t {0}'.format(quote(prop_type))
            if prop_type == 'bool':
                prop_value = str(prop_value).lower()
        cmd += ' -s {0}'.format(quote(str(prop_value)))
    result = __salt__['cmd.run_all'](cmd, runas=user)
    if prop_value is None:
        if result['retcode'] == 0:
            return result['stdout']
        else:
            return False
    else:
        return result


def get(user=None, channel=None, prop_name=None, **kwargs):
    return _xfconf_query(user, channel, prop_name)


def set_(user=None, channel=None, prop_name=None, prop_value=None,
         prop_type=None, create_if_not_exists=False):
    return _xfconf_query(user, channel, prop_name, prop_value, prop_type,
                         create_if_not_exists)

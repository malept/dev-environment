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

import logging

log = logging.getLogger(__name__)

# Maps Python types to Xfconf types.
_XFCONF_TYPE_MAP = {
    int: 'int',
    float: 'float',
    bool: 'bool',
    # TODO array -> list, much more complex.
}


def _check_current_value(xfce_kwargs, value):
    '''
    Check the current value with the passed value
    '''
    current_value = __salt__['xfce.get'](**xfce_kwargs)
    if current_value is False:
        return False
    if xfce_kwargs['prop_type'] == 'bool':
        value = str(value).lower()
    return str(current_value) == str(value)


def _do(name, xfce_kwargs, preferences):
    ret = {
        'name': name,
        'result': True,
        'changes': {},
        'comment': '',
    }

    messages = []

    for key, value in preferences.iteritems():
        prop_type = _XFCONF_TYPE_MAP.get(type(value), 'string')
        xfce_kwargs.update(prop_name=key, prop_value=value,
                           prop_type=prop_type)
        if _check_current_value(xfce_kwargs, value):
            messages.append('{0} is already set to {1}'.format(key, value))
        else:
            result = __salt__['xfce.set'](**xfce_kwargs)
            if result['retcode'] == 0:
                messages.append('Setting {0} to {1}'.format(key, value))
                ret['changes'][key] = '{0}:{1}'.format(key, value)
                ret['result'] = True
            else:
                messages.append(result['stdout'])
                ret['result'] = False

        ret['comment'] = ', '.join(messages)

    return ret


def wm_preferences(name, user=None, create_if_not_exists=False, **kwargs):
    '''
    wm_preferences: set values in the ``xfwm4`` channel.
    '''
    xfce_kwargs = {
        'user': user,
        'channel': 'xfwm4',
        'create_if_not_exists': create_if_not_exists,
    }

    prefs = {'/general/{0}'.format(k): v for k, v in kwargs.iteritems()}

    return _do(name, xfce_kwargs, prefs)


def session_preferences(name, user=None, create_if_not_exists=False, **prefs):
    '''
    session_preferences: set values in the ``xfce4-session`` channel.
    '''
    xfce_kwargs = {
        'user': user,
        'channel': 'xfce4-session',
        'create_if_not_exists': create_if_not_exists,
    }

    return _do(name, xfce_kwargs, prefs)

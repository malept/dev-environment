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


def _check_current_value(xfce_kwargs, value):
    '''
    Check the current value with the passed value.

    Possible values:

    :data:`True`
        Current value equal to passed value
    :data:`False`
        Current value not equal to passed value
    :data:`None`
        Key does not exist
    '''
    current_value_exists = __salt__['xfce.exists'](**xfce_kwargs)
    if not current_value_exists:
        return None
    current_value = __salt__['xfce.get'](**xfce_kwargs)
    return current_value == value


def _do(name, xfce_kwargs, preferences):
    ret = {
        'name': name,
        'result': True,
        'changes': {},
        'comment': '',
    }

    messages = []
    create_if_not_exists = xfce_kwargs['create_if_not_exists']

    for key, value in preferences.iteritems():
        xfce_kwargs.update(prop_name=key, prop_value=value)
        current_value_equal = _check_current_value(xfce_kwargs, value)
        if current_value_equal:
            messages.append('{0} is already set to {1}'.format(key, value))
        else:
            xfce_kwargs['create_if_not_exists'] = \
                current_value_equal is None and create_if_not_exists
            try:
                __salt__['xfce.set'](**xfce_kwargs)
            except Exception as e:
                messages.append(str(e))
                ret['result'] = False
            else:
                messages.append('Setting {0} to {1}'.format(key, value))
                ret['changes'][key] = '{0}:{1}'.format(key, value)
                ret['result'] = True

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


def desktop_preferences(name, user=None, create_if_not_exists=False, **prefs):
    '''
    desktop_preferences: set values in the ``xfce4-desktop`` channel.
    '''
    xfce_kwargs = {
        'user': user,
        'channel': 'xfce4-desktop',
        'create_if_not_exists': create_if_not_exists,
    }

    return _do(name, xfce_kwargs, prefs)

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

from contextlib import contextmanager
import dbus
from dbus.bus import BusConnection
import os
import pwd
from subprocess import PIPE, Popen

# Don't shadow built-in identifiers.
__func_alias__ = {
    'set_': 'set'
}


class _DBusDaemon(object):
    def __init__(self, user):
        self.user = user
        uinfo = pwd.getpwnam(user)
        self.uid = uinfo.pw_uid

    def __enter__(self):
        self.process = Popen(['sudo', '-u', self.user, 'dbus-daemon',
                              '--session', '--print-address=1'], stdout=PIPE)
        self.address = self.process.stdout.readline().strip()
        # Need to set the effective UID to gain access to the user's DBus data.
        self._old_euid = os.geteuid()
        os.seteuid(self.uid)
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        os.seteuid(self._old_euid)
        self.process.terminate()


@contextmanager
def _xfconf(user, existing_xfconf=None):
    if existing_xfconf:
        yield existing_xfconf
    else:
        with _DBusDaemon(user) as daemon:
            bus = BusConnection(daemon.address)
            xfconf = dbus.Interface(bus.get_object('org.xfce.Xfconf',
                                                   '/org/xfce/Xfconf'),
                                    'org.xfce.Xfconf')
            yield xfconf


def get(user, channel, prop_name, **kwargs):
    with _xfconf(user) as xfconf:
        return xfconf.GetProperty(channel, prop_name)


def exists(user, channel, prop_name, existing_xfconf=None, **kwargs):
    with _xfconf(user, existing_xfconf) as xfconf:
        return xfconf.PropertyExists(channel, prop_name)


def set_(user, channel, prop_name, prop_value, create_if_not_exists=False,
         **kwargs):
    with _xfconf(user) as xfconf:
        if exists(user, channel, prop_name, xfconf) or create_if_not_exists:
            xfconf.SetProperty(channel, prop_name, prop_value)

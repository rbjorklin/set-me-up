#!/usr/bin/env python3
from datetime import datetime
import os
import pwd
import subprocess
import time
import atexit

LOG_FILE = os.path.expanduser('~/.time_log.csv')
CMD = subprocess.Popen(["dbus-monitor",
                        "type='signal',interface='org.gnome.ScreenSaver'"],
                       stdout=subprocess.PIPE, encoding='UTF-8')


def main():
    state_changed = False
    log_message("logged in")
    atexit.register(log_message, "logged out")
    while True:
        time.sleep(1)  # Probably unnecessary as readline should block
        if state_changed:
            output = CMD.stdout.readline()
            action = 'locked' if 'true' in output else 'unlocked'
            log_message("{action} the screen".format(action=action))
            state_changed = False
        line = CMD.stdout.readline()
        if "ActiveChange" in line and 'org.gnome.ScreenSaver' in line:
            state_changed = True


def log_message(action):
    new_event = "{time}\t{user}\t{action}\n".format(
        time=datetime.now().isoformat(),
        user=pwd.getpwuid(os.getuid())[0],
        action=action)
    with open(LOG_FILE, 'a') as log_file:
        log_file.write(new_event)


if __name__ == '__main__':
    main()

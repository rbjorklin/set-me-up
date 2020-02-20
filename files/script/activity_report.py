#!/usr/bin/env python3
from datetime import datetime, timedelta
import os
import pwd
import csv
import pprint

LOG_FILE = os.path.expanduser('~/.time_log.csv')
USER = pwd.getpwuid(os.getuid())[0]


def main():
    pp = pprint.PrettyPrinter()
    days = {}
    with open(LOG_FILE) as csvfile:
        csvreader = csv.reader(csvfile, delimiter='\t')
        for row in csvreader:
            event = datetime.strptime(row[0], '%Y-%m-%dT%H:%M:%S.%f')
            date = "{year}-{month}-{day}".format(
                    year=event.year,
                    month=event.month,
                    day=event.day)
            if row[2] == 'logged in' or row[2] == 'unlocked the screen':
                if date not in days:
                    days[date] = {'day_start': event,
                            'duration': 0,
                            'previous': event,
                            'day_end': 0}
                else:
                    days[date]['previous'] = event
            else:
                days[date]['duration'] = days[date]['duration'] + event.timestamp() - days[date]['previous'].timestamp()
            # Always store the current event as day_end in case of missing
            # lock or logged out events
            days[date]['day_end'] = event
    for date, data in days.items():
        print("{day_start} until: {day_end}, hours at work: {h}, time with screen unlocked: {g}".format(
            date=date, day_start=data['day_start'], day_end=data['day_end'], h=data['day_end'] - data['day_start'],
            g=str(timedelta(seconds=data['duration']))))
    #pp.pprint(days)


if __name__ == '__main__':
    main()

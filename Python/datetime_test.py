import datetime
import re



HOUR = datetime.timedelta(days=0, hours=1)

time_limit = '2023-01-13T14:00:00+03:00'
l_date_time = re.split('T|\+', time_limit)
date_time = l_date_time[0] + ' ' + l_date_time[1]
date_lim = datetime.datetime.strptime(date_time, '%Y-%m-%d %H:%M:%S')
date_td = datetime.datetime.now()
delta_time = datetime.timedelta(days=(date_lim.day - date_td.day), hours=(date_lim.hour - date_td.hour))

if delta_time > HOUR:
    print('ok')
    pass
else:
    print('no')
    pass

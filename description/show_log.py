import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import datetime
import re
import time

steps = []
dates = []

logfile = "challenge/logfile.txt"
with open(logfile) as log:
    for line in log.readlines():
        m = re.search("##\s+(\S+)\s+.*in step (\d+)", line)
        if m is not None:
            date = datetime.datetime.strptime(m.group(1), '%H:%M:%S')
            step = int(m.group(2))
            steps.append(step)
            dates.append(date)

plt.figure(figsize=(9, 6))
plt.plot(dates, steps, linewidth=3)
plt.title("steps vs time")
plt.xlabel("time")
plt.ylabel("steps")

plt.xlim(dates[0])
xformatter = mdates.DateFormatter('%H:%M')
plt.gcf().axes[0].xaxis.set_major_formatter(xformatter)

plt.grid()
plt.show()

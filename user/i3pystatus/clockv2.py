from datetime import datetime
from i3pystatus import IntervalModule
from collections import deque
from subprocess import call

class Clock(IntervalModule):

    settings = (
        "color",
        "interval",
    )
    format1 = "%a %-d %b, %H:%M"
    format2 = "%a %-d %b %Y, Week %V, %X"
    formats = deque([format1, format2])
    interval = 1
    color = "#FFFFFF"

    on_leftclick = "change_format"
    on_rightclick = "agenda"

    def run(self):
        self.output = {
            "full_text": datetime.now().strftime(self.formats[0]),
            "color": self.color,
        }

    def change_format(self):
        self.formats.rotate()
        self.run()

    def agenda(self):
        call('notify-send -u critical agenda "$(gcalcli --nocolor agenda)"', shell=True)

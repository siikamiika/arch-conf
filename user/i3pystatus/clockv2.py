from datetime import datetime
from i3pystatus import IntervalModule
from collections import deque

class Clock(IntervalModule):

    settings = (
        "format1",
        "format2",
        "color",
        "interval",
    )
    format1 = "%X"
    format2 = "%a %-d %b %Y, Week %V"
    formats = deque([format1, format2])
    interval = 1
    color = "#FFFFFF"

    on_leftclick = "change_format"

    def run(self):
        self.output = {
            "full_text": datetime.now().strftime(self.formats[0]),
            "color": self.color,
        }

    def change_format(self):
        self.formats.rotate()
        self.run()


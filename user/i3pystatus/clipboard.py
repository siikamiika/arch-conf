from i3pystatus import IntervalModule
from subprocess import getoutput

class Clipboard(IntervalModule):

    settings = [
        "format",
        "color",
        "interval",
    ]
    color = "#FFFFFF"
    interval = 1

    def run(self):
        self.output = {
            "full_text": self.format.format(
                clipboard=getoutput('xsel -b').replace('\n', ''),
                ),
            "color": self.color,
        }


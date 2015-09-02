from i3pystatus import IntervalModule
from subprocess import getoutput
import re

def sanitize(text):
    text = re.sub(r'[\n]', '', text)
    if len(text) > 20:
        text = text[:20] + '...'
    return text

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
            "full_text": sanitize(self.format.format(
                clipboard=getoutput('xsel -b').replace('\n', ''),
                )),
            "color": self.color,
        }


class Selection(IntervalModule):

    settings = [
        "format",
        "color",
        "interval",
    ]
    color = "#FFFFFF"
    interval = 1

    def run(self):
        self.output = {
            "full_text": sanitize(self.format.format(
                primary=getoutput('xsel').replace('\n', ''),
                )),
            "color": self.color,
        }


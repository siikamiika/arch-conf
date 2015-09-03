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
    cmd = 'xsel -b'

    def run(self):
        try:
            self.output = {
                "full_text": sanitize(self.format.format(
                    buffer=getoutput(self.cmd).replace('\n', ''),
                    )),
                "color": self.color,
            }
        except Exception as e:
            self.output = {"full_text": str(e)}


class Selection(Clipboard):

    cmd = 'xsel'

from i3pystatus import IntervalModule
from subprocess import getoutput
import re

class Touchpad(IntervalModule):

    settings = [
        "format",
        "color_on",
        "color_off",
        "interval",
    ]
    color_on = '#00FF00'
    color_off = '#FF0000'
    interval = 1

    def run(self):
        try:
            state = getoutput('synclient -l | grep TouchpadOff | awk \'{print $3}\'')
            self.output = {
                "full_text": '██',
                "color": self.color_on if state == '0' else self.color_off,
            }
        except Exception as e:
            self.output = {"full_text": str(e)}

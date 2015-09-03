from i3pystatus import Module
from subprocess import getoutput
import re
import socket
import os
import os.path
from threading import Thread

class Touchpad(Module):

    settings = [
        "format",
        "color_on",
        "color_off",
    ]
    color_on = '#00FF00'
    color_off = '#FF0000'
    interval = 1
    socket_file = '/tmp/touchpadtoggle.sock'

    def init(self):
        self.manual_update()

        if os.path.exists(self.socket_file):
            os.remove(self.socket_file)
        self.listener = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.listener.bind(self.socket_file)
        self.listener.listen(5)
        def bg():
            while True:
                c, a = self.listener.accept()
                data = c.recv(4096).decode().strip()
                self.output["color"] = self.color_on if data == "0" else self.color_off
        Thread(target=bg).start()


    def manual_update(self):
        try:
            state = getoutput('synclient -l | grep TouchpadOff | awk \'{print $3}\'')
            self.output = {
                "full_text": '██',
                "color": self.color_on if state == '0' else self.color_off,
            }
        except Exception as e:
            self.output = {"full_text": str(e)}

from i3pystatus import Module
from subprocess import call, DEVNULL
import socket
import os
import os.path
from threading import Thread

class Compton(Module):

    settings = [
        "format",
        "color",
    ]
    socket_file = '/tmp/compton-status.sock'

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
                if data == "on":
                    self.output["full_text"] = "C"
                elif data == "off":
                    self.output["full_text"] = ""
        Thread(target=bg).start()


    def manual_update(self):
        try:
            state = call(['pgrep', 'compton'], stdout=DEVNULL, stderr=DEVNULL)
            self.output = {
                "full_text": 'C' if state == 0 else '',
            }
        except Exception as e:
            self.output = {"full_text": str(e)}

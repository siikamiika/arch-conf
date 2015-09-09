from i3pystatus import Module
import socket
import os
import os.path
from threading import Thread

class MpvMusic(Module):

    settings = [
        "color",
    ]
    socket_file = '/tmp/mpv-music.sock'
    color = "#FFFFFF"

    def init(self):

        self.output = {
            "full_text": "",
            "color": self.color,
        }

        self.text = ""
        if os.path.exists(self.socket_file):
            os.remove(self.socket_file)
        self.listener = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.listener.bind(self.socket_file)
        self.listener.listen(5)
        def bg():
            while True:
                c, a = self.listener.accept()
                data = c.recv(4096).decode().strip()
                self.output["full_text"] = data
        Thread(target=bg).start()

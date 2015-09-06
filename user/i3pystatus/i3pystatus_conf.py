from i3pystatus import Status
from pavutoggle import PulseAudio
from cpu_temp import CpuTemp
from nvidia_temp import NvGpuTemp
from nvidia import GpuInfo
from colored_load import Load
from colored_cpu import CpuUsage
from clockv2 import Clock
from cond_text import Text
from clipboard import Clipboard, Selection
from touchpad_socket import Touchpad
from compton import Compton

status = Status(standalone=True)

NVIDIA = "#619701"
INTEL  = "#0860A7"
I3BLUE = "#285577"
TEMP_OK = "#05A600"

status.register(Touchpad,
    )

status.register(Compton,
    )

status.register("battery",
        battery_ident="BAT1",
        format="{percentage:3.0f}%[ {remaining:%E%hh:%Mm}]",
        color="#ffff00",
        )

status.register(PulseAudio,
    format="♪{volume:3}{muted}",
    step=2,
    #color=I3BLUE,
    )

status.register(Clock,
    color="#FFFF80",
    )

status.register("network",
    format_up="{essid} ({quality}%) {bytes_recv:4}k▼ {bytes_sent:4}k▲",
    interface="wlp8s0",
    dynamic_color=False,
    on_leftclick=None,
    )

status.register("mem",
    format="{used_mem}/{total_mem} GiB",
    divisor=1024**3,
    )

status.register(CpuUsage,
    format="{usage:02}%",
    color=INTEL,
    )

status.register(Load,
    format="{avg1} {avg5} {avg15}",
    color=INTEL,
    )

status.register(CpuTemp,
    format="{temp:.0f}°",
    color=TEMP_OK,
    medium_temp=55,
    )

status.register("text",
    text="i7-4710HQ:",
    color=INTEL,
    )

status.register(GpuInfo,
    format="{0[utilization.gpu]}",
    color=NVIDIA,
    )

status.register(NvGpuTemp,
    format="{gpu_temp}°",
    color=TEMP_OK,
    )

status.register(Text,
    text="GTX 860M:",
    color=NVIDIA,
    condition="nvidia-smi 2>&1 > /dev/null",
    )

status.register(Clipboard,
    format="CB: {buffer}",
    #color="#FFFFFF",
    )

status.register(Selection,
    format="SEL1: {buffer}",
    #color="#FFFFFF",
    )

status.run()


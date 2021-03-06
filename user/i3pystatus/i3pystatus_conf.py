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
from compton import Compton
from mpv_music import MpvMusic

status = Status(standalone=True)

NVIDIA = "#619701"
INTEL  = "#0860A7"
I3BLUE = "#285577"
TEMP_OK = "#05A600"
LIGHT_YELLOW = "#FFFF80"

status.register(Compton,
    )

status.register(PulseAudio,
    format="♪{volume:3}{muted}",
    step=2,
    #color=I3BLUE,
    )

status.register(Clock,
    color=LIGHT_YELLOW,
    )

status.register("network",
    format_up="{quality} {essid} {bytes_recv:_>4}k▼ {bytes_sent:_>4}k▲",
    interface="enp5s0",
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
    format="{avg1}",
    color=INTEL,
    )

status.register(CpuTemp,
    format="{temp:.0f}°",
    color=TEMP_OK,
    medium_temp=55,
    )

status.register("text",
    text="i5-3550",
    color=INTEL,
    )

status.register(NvGpuTemp,
    format="{gpu_temp}°",
    color=TEMP_OK,
    )

status.register(Text,
    text="GTX 760",
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

status.register(MpvMusic,
    color=LIGHT_YELLOW,
    )

status.run()


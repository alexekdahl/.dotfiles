from libqtile.layout.floating import Floating
from libqtile.layout.xmonad import MonadTall
from libqtile.layout.bsp import Bsp

from libqtile import bar, widget, hook
from libqtile.config import Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

from os.path import expanduser
import subprocess

ALT = "mod1"
SUPER = "mod4"
HOME = expanduser("~")

# Use lazy.spawn to execute a shell command
keys = [
    # Switch between windows
    Key([ALT], "h", lazy.layout.left()),
    Key([ALT], "j", lazy.layout.down()),
    Key([ALT], "k", lazy.layout.up()),
    Key([ALT], "l", lazy.layout.right()),
    # Move windows
    Key([ALT, "shift"], "h", lazy.layout.swap_left()),
    Key([ALT, "shift"], "j", lazy.layout.shuffle_down()),
    Key([ALT, "shift"], "k", lazy.layout.shuffle_up()),
    Key([ALT, "shift"], "l", lazy.layout.swap_right()),
    # Resize windows
    Key(
        [ALT, "control"],
        "h",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
    ),
    Key(
        [ALT, "control"],
        "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
    ),
    Key(
        [ALT, "control"],
        "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
    ),
    Key(
        [ALT, "control"],
        "l",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
    ),
    # Switch focus
    Key(["control"], "Right", lazy.screen.next_group()),
    Key(["control"], "Left", lazy.screen.prev_group()),
    # Switch focus to specific monitor (out of three)
    Key([ALT], "o", lazy.next_screen()),
    Key([ALT], "i", lazy.next_screen()),
    # Switch focus of monitors
    # Layouts
    Key([ALT], "e", lazy.layout.toggle_split()),
    Key(["control"], "Tab", lazy.next_layout()),
    Key([ALT], "t", lazy.window.toggle_floating()),
    Key([ALT], "f", lazy.window.toggle_fullscreen()),
    # kill
    Key([SUPER], "w", lazy.window.kill()),
    # Application Launch
    Key([SUPER], "space", lazy.spawn(f"{HOME}/.dotfiles/scripts/start_alacritty")),
    Key([ALT], "d", lazy.spawn(f"{HOME}/.config/rofi/scripts/launcher.sh")),
    Key([ALT, SUPER], "m", lazy.spawn(f"{HOME}/.dotfiles/scripts/switch_to_monitor.sh")),
    Key([SUPER], "p", lazy.spawn("xfce4-screenshooter")),
    # System Control
    Key([SUPER, "control"], "r", lazy.restart()),
    Key([SUPER, "control"], "q", lazy.shutdown()),
    # Increase volume
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ),
    # Decrease volume
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ),
    # Toggle mute
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    # Microphone mute/unmute
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
    ),
]

groups = [Group(i) for i in "12345"]

for i in groups:
    keys.extend(
        [
            Key(["control"], i.name, lazy.group[i.name].toscreen()),
            Key([ALT, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
            Key([ALT], "Tab", lazy.screen.next_group(), desc="Move to next group."),
            Key(
                [ALT, "shift"],
                "Tab",
                lazy.screen.prev_group(),
                desc="Move to previous group.",
            ),
        ]
    )

layout_theme = {
    "border_width": 1,
    "margin": 20,
    "border_focus": "#808000",
    "border_normal": "#000000",
}

layouts = [MonadTall(**layout_theme), Bsp(**layout_theme)]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text=" 󰘧 ",
                    fontsize=16,
                    font="MesloLGM Nerd Font",
                    margin_y=2,
                    margin_x=4,
                    padding_y=6,
                    padding_x=6,
                    borderwidth=0,
                ),
                widget.GroupBox(
                    font="MesloLGM Nerd Font",
                    fontsize=16,
                    margin_y=2,
                    margin_x=4,
                    padding_y=6,
                    padding_x=6,
                    borderwidth=0,
                    highlight_method="line",
                    urgent_alert_method="line",
                    rounded=False,
                ),
                widget.CurrentLayoutIcon(scale=0.6),
                widget.WindowName(),
                widget.Systray(icon_size=20, padding=4),
                widget.Sep(linewidth=1, padding=10),
                widget.BatteryIcon(),
                widget.Battery(
                    show_short_text=True,
                    format="{percent:2.0%}",
                ),
                widget.Sep(linewidth=1, padding=10),
                widget.TextBox(
                    text="󰕾",
                    fontsize=14,
                    font="JetBrainsMono Nerd Font",
                ),
                widget.PulseVolume(padding=10),
                widget.Sep(linewidth=1, padding=10),
                widget.TextBox(
                    text=" ",
                    fontsize=14,
                    font="MesloLGM Nerd Font",
                ),
                widget.Clock(format="%a %I:%M %p"),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [ALT],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = Floating(
    # Run the utility of `xprop` to see the wm class and name of an X client
    float_rules=[
        *Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True


@hook.subscribe.startup_once
def autostart():
    home = expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])

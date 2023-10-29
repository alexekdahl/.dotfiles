from libqtile import bar, widget, hook
from libqtile.layout.bsp import Bsp
from libqtile.layout.floating import Floating
from libqtile.layout.xmonad import MonadTall

from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

from os.path import expanduser
import subprocess

ALT = "mod1"
SUPER = "mod4"
TERMINAL = 'alacritty'
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
        Key([ALT, "control"], "h",
            lazy.layout.grow_right(),
            lazy.layout.grow(),
            lazy.layout.increase_ratio(),
            lazy.layout.delete()
            ),
        Key([ALT, "control"], "j",
            lazy.layout.grow_down(),
            lazy.layout.shrink(),
            lazy.layout.increase_nmaster()
            ),
        Key([ALT, "control"], "k",
            lazy.layout.grow_up(),
            lazy.layout.grow(),
            lazy.layout.decrease_nmaster()
            ),
        Key([ALT, "control"], "l",
            lazy.layout.grow_left(),
            lazy.layout.shrink(),
            lazy.layout.decrease_ratio(),
            lazy.layout.add()
            ),

        # Switch focus
        Key(["control"], "Right", lazy.screen.next_group()),
        Key(["control"], "Left", lazy.screen.prev_group()),
        # Switch focus to specific monitor (out of three)
        # Key([mod], "i", lazy.to_screen(0)),
        # Key([mod], "o", lazy.to_screen(1)),

        # Switch focus of monitors
        # Key([mod], "period", lazy.next_screen()),
        # Key([mod], "comma", lazy.prev_screen()),

        # Layouts
        Key([ALT], "e", lazy.layout.toggle_split()),
        Key(["control"], "Tab", lazy.next_layout()),
        Key([ALT], "t", lazy.window.toggle_floating()),
        Key([ALT], "f", lazy.window.toggle_fullscreen()),

        # kill
        Key([SUPER], "w", lazy.window.kill()),


        # Application Launch
        Key([SUPER], "space", lazy.spawn(TERMINAL)),
        Key([ALT], "d", lazy.spawn(f"{HOME}/.config/rofi/scripts/launcher.sh")),
        Key([ALT, "shift"], "d", lazy.spawn(f"{HOME}/.config/rofi/scripts/s_launcher.sh")),
        Key([ALT, SUPER], "r", lazy.spawncmd()),

        # System Control
        Key([SUPER, "control"], "r", lazy.restart()),
        Key([SUPER, "control"], "q", lazy.shutdown()),
    ]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            Key(["control"], i.name, lazy.group[i.name].toscreen()),
            Key([ALT, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
        ]
    )

layout_theme = {"border_width": 1,
                "margin": 10,
                "border_focus": "#d75f5f",
                "border_normal": "#8f3d3d"
                }

layouts = [
    MonadTall(**layout_theme),
    Bsp(**layout_theme)
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

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
                widget.GroupBox(
                    font="MesloLGM Nerd Font",
                    fontsize = 16,
                    margin_y = 2,
                    margin_x = 4,
                    padding_y = 6,
                    padding_x = 6,
                    borderwidth = 1,
                ),
                widget.WindowName(),
                # widget.Systray(),
                widget.Battery(),
                # widget.Memory(),
                widget.Clock(format="%a %I:%M %p"),
                # widget.QuickExit(),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([ALT], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([ALT], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([ALT], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
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

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

@hook.subscribe.startup_once
def autostart():
    home = expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

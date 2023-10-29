# from libqtile import bar, layout, widget
# from libqtile.config import Click, Drag, Group, Key, Match, Screen
# from libqtile.lazy import lazy
# import os
#
# alt = "mod1"
# super = "mod4"
#
# terminal = 'alacritty'
# home = os.path.expanduser("~")
#
# keys = [
#     # A list of available commands that can be bound to keys can be found
#     # at https://docs.qtile.org/en/latest/manual/config/lazy.html
#     # Switch between windows
#     Key([alt], "h", lazy.layout.left(), desc="Move focus to left"),
#     Key([alt], "l", lazy.layout.right(), desc="Move focus to right"),
#     Key([alt], "j", lazy.layout.down(), desc="Move focus down"),
#     Key([alt], "k", lazy.layout.up(), desc="Move focus up"),
#     # Toggle between split and unsplit sides of stack.
#     # Split = all windows displayed
#     # Unsplit = 1 window displayed, like Max layout, but still with
#     # multiple stack panes
#     # Toggle between different layouts as defined below
# ]
#
# groups = [Group(i) for i in "123456789"]
#
# for i in groups:
#     keys.extend(
#         [
#             # mod1 + letter of group = switch to group
#             Key(
#                 [alt],
#                 i.name,
#                 lazy.group[i.name].toscreen(),
#                 desc="Switch to group {}".format(i.name),
#             ),
#             # mod1 + shift + letter of group = switch to & move focused window to group
#             Key(
#                 [alt, "shift"],
#                 i.name,
#                 lazy.window.togroup(i.name, switch_group=True),
#                 desc="Switch to & move focused window to group {}".format(i.name),
#             ),
#             # Or, use below if you prefer not to switch to that group.
#             # # mod1 + shift + letter of group = move focused window to group
#             # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
#             #     desc="move focused window to group {}".format(i.name)),
#         ]
#     )
# layout_theme = {"border_width": 2,
#                 "margin": 8,
#                 "border_focus": "#d75f5f",
#                 "border_normal": "#8f3d3d"
#                 }
#
# layouts = [
#     layout.Bsp(**layout_theme)
#     # layout.Max(),
#     # Try more layouts by unleashing below layouts.
#     # layout.Stack(num_stacks=2),
#     # layout.Bsp(),
#     # layout.Matrix(),
#     # layout.MonadTall(),
#     # layout.MonadWide(),
#     # layout.RatioTile(),
#     # layout.Tile(),
#     # layout.TreeTab(),
#     # layout.VerticalTile(),
#     # layout.Zoomy(),
# ]
#
# widget_defaults = dict(
#     font="sans",
#     fontsize=12,
#     padding=3,
# )
# extension_defaults = widget_defaults.copy()
#
# screens = [
#     Screen(
#         top=bar.Bar(
#             [
#                 widget.CurrentLayout(),
#                 widget.GroupBox(),
#                 widget.Prompt(),
#                 widget.WindowName(),
#                 widget.Chord(
#                     chords_colors={
#                         "launch": ("#ff0000", "#ffffff"),
#                     },
#                     name_transform=lambda name: name.upper(),
#                 ),
#                 widget.TextBox("default config", name="default"),
#                 widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
#                 # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
#                 # widget.StatusNotifier(),
#                 widget.Systray(),
#                 widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
#                 widget.QuickExit(),
#             ],
#             24,
#             # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
#             # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
#         ),
#         # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
#         # By default we handle these events delayed to already improve performance, however your system might still be struggling
#         # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
#         # x11_drag_polling_rate = 60,
#     ),
# ]
#
# # Drag floating layouts.
# mouse = [
#     Drag([alt], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
#     Drag([alt], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
#     Click([alt], "Button2", lazy.window.bring_to_front()),
# ]
#
# dgroups_key_binder = None
# dgroups_app_rules = []  # type: list
# follow_mouse_focus = True
# bring_front_click = False
# floats_kept_above = True
# cursor_warp = False
# floating_layout = layout.Floating(
#     float_rules=[
#         # Run the utility of `xprop` to see the wm class and name of an X client.
#         *layout.Floating.default_float_rules,
#         Match(wm_class="confirmreset"),  # gitk
#         Match(wm_class="makebranch"),  # gitk
#         Match(wm_class="maketag"),  # gitk
#         Match(wm_class="ssh-askpass"),  # ssh-askpass
#         Match(title="branchdialog"),  # gitk
#         Match(title="pinentry"),  # GPG key password entry
#     ]
# )
# auto_fullscreen = True
# focus_on_window_activation = "smart"
# reconfigure_screens = True
#
# # If things like steam games want to auto-minimize themselves when losing
# # focus, should we respect this or not?
# auto_minimize = True
#
# # When using the Wayland backend, this can be used to configure input devices.
# wl_input_rules = None
#

# Import necessary modules from Qtile
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import os

# Constants
ALT = "mod1"
SUPER = "mod4"
TERMINAL = 'alacritty'
HOME = os.path.expanduser("~")

LAYOUT_THEME = {
    "border_width": 2,
    "margin": 8,
    "border_focus": "#d75f5f",
    "border_normal": "#8f3d3d"
}

WIDGET_DEFAULTS = {
    'font': 'sans',
    'fontsize': 12,
    'padding': 3,
}

# Initialize key bindings
        # Key([ALT], "space", lazy.layout.next(), desc="Move window focus to other window"),
        # Key([alt], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
        # Key([alt], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
        # Key([SUPER], "w", lazy.window.kill(r), desc="Kill focused window"),
        # Key([alt, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
def init_keys():
    return [
        Key([ALT], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([ALT], "j", lazy.layout.down(), desc="Move focus down"),
        Key([ALT], "k", lazy.layout.up(), desc="Move focus up"),
        Key([ALT], "l", lazy.layout.right(), desc="Move focus to right"),
        # -- #
        Key([ALT, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key([ALT, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key([ALT, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
        Key([ALT, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
        # -- #
        Key([ALT, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
        Key([ALT, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
        Key([ALT, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
        Key([ALT, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
        # -- #
        Key([ALT, "e"], lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
        Key([ALT],"f",lazy.window.toggle_fullscreen(),desc="Toggle fullscreen on the focused window"),
        Key([ALT], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
        Key([SUPER], "w", lazy.window.kill(), desc="Kill focused window"),
        Key([SUPER], "space", lazy.spawn(TERMINAL), desc="Launch terminal"),
        # -- #
        Key([ALT, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
        Key([ALT], "d", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    ]

keys = init_keys()

# Initialize workspace groups
def init_groups():
    return [Group(str(i)) for i in range(1, 10)]

groups = init_groups()

# Extend key definitions for workspace switching and window moving
for i in groups:
    keys.extend([
        Key([ALT], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
        Key([ALT, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Move focused window to group {i.name}")
    ])

# Initialize layouts
layouts = [
    layout.Bsp(**LAYOUT_THEME),
    layout.Stack(**LAYOUT_THEME),
    layout.Tile(**LAYOUT_THEME),
]

# Initialize widgets
def init_widgets():
    return [
        widget.CurrentLayout(),
        widget.GroupBox(),
        widget.WindowName(),
        widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
        # widget.Systray(),
    ]

widget_list = init_widgets()

# Initialize screens
screens = [
    Screen(
        top=bar.Bar(widget_list, 24),
    )
]

# Initialize mouse bindings
mouse = [
    Drag([ALT], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Click([ALT], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

# Miscellaneous other settings

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# This is a hack to make the above Python code executable
if __name__ == "__main__":
    pass

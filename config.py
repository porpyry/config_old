from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()
browser = "google-chrome-stable"
editor = "emacs"

keys = [
  # System
  Key([mod, "shift"], "q", lazy.shutdown(),      desc="Shutdown Qtile"),
  Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
  Key([mod], "r", lazy.restart(),                desc="Restart qtile"),
  Key([mod], "w", lazy.window.kill(),            desc="Kill focused window"),
  # Focus
  Key([mod], "h", lazy.layout.left(),   desc="Move focus to left"),
  Key([mod], "l", lazy.layout.right(),  desc="Move focus to right"),
  Key([mod], "j", lazy.layout.down(),   desc="Move focus down"),
  Key([mod], "k", lazy.layout.up(),     desc="Move focus up"),
  Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
  # Move
  Key([mod, "shift"], "h", lazy.layout.shuffle_left(),  desc="Move window to the left"),
  Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
  Key([mod, "shift"], "j", lazy.layout.shuffle_down(),  desc="Move window down"),
  Key([mod, "shift"], "k", lazy.layout.shuffle_up(),    desc="Move window up"),
  Key([mod], "u", lazy.layout.swap_column_left()),
  Key([mod], "i", lazy.layout.swap_column_right()),
  # Size
  Key([mod, "control"], "h", lazy.layout.grow_left(),  desc="Grow window to the left"),
  Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
  Key([mod, "control"], "j", lazy.layout.grow_down(),  desc="Grow window down"),
  Key([mod, "control"], "k", lazy.layout.grow_up(),    desc="Grow window up"),
  Key([mod, "control"], "n", lazy.layout.normalize(),  desc="Reset all window sizes"),
  # Program
  Key([mod], "p", lazy.spawn('rofi -show drun'), desc="Spawn a command using a prompt widget"),
  Key([mod], "Return", lazy.spawn(terminal),     desc="Launch terminal"),
  Key([mod], "n", lazy.spawn(browser),           desc="Launch browser"),
  Key([mod], "e", lazy.spawn(editor),            desc="Launch editor"),
  # Layout
  Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
  # Group
  Key([mod], "s", lazy.screen.toggle_group(), desc="Toggle group"),
  Key([mod], "Right", lazy.screen.next_group(), desc="Next group"),
  Key([mod], "Left", lazy.screen.prev_group(), desc="Prev group"),
  # Audio
  Key([], "XF86AudioRaiseVolume", lazy.spawn("pulsemixer --change-volume +5"), desc="Volume up (pulsemixer)"),
  Key([], "XF86AudioLowerVolume", lazy.spawn("pulsemixer --change-volume -5"), desc="Volume down (pulsemixer)"),
]

groups = [Group(i) for i in "123456789"]
for i in groups:
  keys.extend(
    [
      Key([mod], i.name, lazy.group[i.name].toscreen(),        desc="Switch to group {}".format(i.name)),
      Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc="Move focused window to group {}".format(i.name)),
    ]
  )

mouse = [
  Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
  Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
  Drag([mod, "shift"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
  Click([mod], "Button1", lazy.window.bring_to_front()),
]

layout_theme = {
  "margin": 0,
  "border_width": 1,
  "border_focus": "#ffffff",
  "border_normal": "#000000"
}

layouts = [
  #layout.Spiral(**layout_theme),
  layout.Columns(**layout_theme),
  #layout.Stack(num_stacks=2),
  #layout.Bsp(),
  #layout.MonadTall(**layout_theme),
  #layout.MonadWide(**layout_theme),
  #layout.Matrix(**layout_theme),
  #layout.Max(),
  #layout.RatioTile(),
  #layout.Tile(),
  layout.TreeTab(border_width=4, font="JetBrains Mono", margin_left=0, margin_y=0, padding_left=0, padding_x=0, padding_y=0, panel_width=125, section_bottom=0, section_left=0, section_padding=0, section_top=0, sections=[''], vspace=0),
  #layout.VerticalTile(),
  #layout.Zoomy(margin=4),
  #layout.Floating(**layout_theme),
]

screens = [
  Screen(
    top=bar.Bar(
      [
        widget.GroupBox(highlight_method='line', borderwidth=2, margin=3, disable_drag=True, rounded=False, this_current_screen_border='ffffff'),
        widget.WindowName(),
        widget.CurrentLayout(),
        widget.Systray(),
        widget.Clock(format="%Y-%m-%d (%a) %H:%M"),
      ],
      24,
    ),
  ),
]

auto_fullscreen = False
bring_front_click = False
cursor_warp = False
dgroups_key_binder = None
dgroups_app_rules = []
widget_defaults = dict(
  font="JetBrains Mono",
  fontsize=14,
  padding=3,
)
extension_defaults = widget_defaults.copy()
floating_layout = layout.Floating(
  float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class="confirmreset"),
    Match(wm_class="makebranch"),
    Match(wm_class="maketag"),
    Match(wm_class="ssh-askpass"),
    Match(title="branchdialog"),
    Match(title="pinentry"),
  ]
) # xprop
focus_on_window_activation = "smart"
follow_mouse_focus = True
reconfigure_screens = True
wmname = "LG3D" # java
auto_minimize = True # steam
wl_input_rules = None # wayland

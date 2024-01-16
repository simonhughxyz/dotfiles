# pyright: reportUndefinedVariable = false
#
# Qutebrowser Config
# Simon H Moore <simon@simonhugh.xyz>

import datetime
import os

from datetime import datetime


# ======================
# === General Config ===
# ======================

c.qt.args = ["disable-reading-from-canvas"]
c.hints.chars = "fjkdlsa;"
# c.fonts.hints               = '18 monospace bold'
# c.input.partial_timeout     = 5
c.hints.uppercase = True
c.confirm_quit = ["never"]
c.content.fullscreen.window = True
c.spellcheck.languages = ["de-DE", "en-GB", "en-US"]
c.new_instance_open_target = "tab"
c.url.default_page = "about:blank"
c.url.start_pages = ["about:blank"]
c.zoom.default = 150
c.content.autoplay = False
c.content.mute = True
c.fonts.web.size.minimum = 14
c.editor.command = ["st", "-e", "nvim", "-f", "{file}", "-c", "normal{line}G{column0}l"]
c.content.prefers_reduced_motion = True
c.content.default_encoding = "utf-8"
c.fileselect.handler = "external"
c.fileselect.folder.command = ["st", "-e", "nnn", "-p", "{}"]
c.fileselect.single_file.command = ["st", "-e", "nnn", "-p", "{}"]
c.fileselect.multiple_files.command = ["st", "-e", "nnn", "-p", "{}"]

# Status bar 
c.statusbar.widgets = ["keypress", "url", "scroll", "history", "progress"]


# dark mode
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.darkmode.threshold.background = 150
c.colors.webpage.bg = "#000000"
c.content.user_stylesheets = ["~/.config/qutebrowser/css/custom-dark.css"]

# Downloads

downloads_directory = os.path.expanduser("~/Downloads/" + datetime.now().strftime('%Y'))
if not os.path.isdir(downloads_directory):
    os.makedirs(downloads_directory)
c.downloads.location.directory = downloads_directory
c.downloads.location.prompt = True
c.downloads.location.remember = True
c.downloads.location.suggestion = "both"
c.downloads.open_dispatcher = "xdg-open '{}'"
c.downloads.position = "bottom"
c.downloads.prevent_mixed_content = True
c.downloads.remove_finished = -1

c.aliases = {
    "h": "help",
    "w": "session-save",
    "qa": "quit",
    "wq": "quit --save",
    "cs": "config-source",
    "au": "adblock-update",
    "qr": "spawn --userscript qr",
    "zm": "zoom 100; set",
}

# Search Engines
c.url.searchengines = {
    # Brave
    "DEFAULT": "https://search.brave.com/search?q={}",
    "br": "https://search.brave.com/search?q={}",
    # Searx
    "sx": "https://searx.tiekoetter.com/search?q={}",
    # DuckDuckGO
    "ddg": "https://duckduckgo.com/?q={}",
    # Google
    "go": "http://www.google.com/search?q={}",
    # Google Maps
    "gm": "https://www.google.com/maps/search/{}",
    # Youtube
    "yt": "https://www.youtube.com/results?search_query={}",
    # Invidious
    "in": "https://yewtu.be/search?q={}&page=1",
    # Amazon
    "az": "https://www.amazon.co.uk/s?k={}",
    # Pirate Bay
    "pb": "https://thepiratebay.org/search.php?q={}",
    # Git Hub
    "gh": "https://github.com/search?q={}&type=repositories",
    # Nix Package Search
    "nix": "https://search.nixos.org/packages?channel=unstable&query={}",
    # Scoop Package Search
    "scoop": "https://scoop.sh/#/apps?q={}",
    # Giphy search
    "gif" : "https://giphy.com/search/{}"
}

# leader key
leader = "<Space>"


# ==========================
# === Privacy & Security ===
# ==========================

c.content.javascript.enabled = True
c.content.cookies.accept = "no-3rdparty"
# c.content.cookies.store     = False
c.content.plugins = False
c.content.geolocation = False
c.content.pdfjs = False
c.content.webgl = False
# c.content.javascript.clipboard = False
c.content.headers.referer = "same-domain"
c.content.dns_prefetch = False
c.content.canvas_reading = True  # some websites break when disabled
c.content.headers.do_not_track = False  # can be used to fingerprint
# c.content.webrtc_ip_handling_policy = 'disable-non-proxied-udp'
c.content.hyperlink_auditing = False
c.content.local_storage = True

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.hosts.block_subdomains = True
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist.to/easylist/fanboy-social.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt",
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
]
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
]


# =====================
# === Tabs Config ===
# =====================

c.tabs.show = "switching"
c.tabs.position = "left"
c.tabs.tabs_are_windows = False

# colors
c.colors.tabs.bar.bg = "#000000"
c.colors.tabs.odd.bg = "#000000"
c.colors.tabs.odd.fg = "#ffffff"
c.colors.tabs.even.bg = "#bbbbbb"
c.colors.tabs.even.fg = "#000000"
c.colors.tabs.selected.even.bg = "#bb44cc"
c.colors.tabs.selected.even.fg = "#000000"
c.colors.tabs.selected.odd.bg = "#bb44cc"
c.colors.tabs.selected.odd.fg = "#000000"

config.bind("<tab>", "config-cycle -t tabs.show never always")
config.bind(leader + "b", "cmd-set-text --space :tab-select")
config.bind(leader + ",", "tab-focus last")
config.bind("<Ctrl+j>", "tab-move +")
config.bind("<Ctrl+k>", "tab-move -")

c.colors.hints.bg = "#bb44cc"
c.colors.hints.fg = "#000000"


# ======================
# === Windows Config ===
# ======================

# keybinds
config.bind("we", "cmd-set-text --space :open -w")
config.bind("wo", "open -w")
config.bind("wc", "tab-clone -w")
config.bind("wu", "undo --window")
config.bind("wC", "cmd-set-text :open -w {url:pretty}")
config.bind("wg", "cmd-set-text --space :tab-give")
config.bind("wG", "cmd-set-text --space :tab-give -k")
config.bind("wt", "cmd-set-text --space :tab-take")
config.bind("wT", "cmd-set-text --space :tab-take -k")


# =============================
# === Private Window Config ===
# =============================

# keybinds
config.bind("Pe", "cmd-set-text --space :open -p")
config.bind("Po", "open -p")
config.bind("Pc", "tab-clone -p")
config.bind("PC", "cmd-set-text :open -p {url:pretty}")
config.bind("Pg", "cmd-set-text --space :tab-give -p")
config.bind("PG", "cmd-set-text --space :tab-give -k -p")
config.bind("Pt", "cmd-set-text --space :tab-take")
config.bind("PT", "cmd-set-text --space :tab-take -k -p")


# ======================
# === Other Keybinds ===
# ======================

config.bind("}", "scroll-page 0 0.2")
config.bind("{", "scroll-page 0 -0.2")
config.bind("%", "scroll-to-perc")
config.bind("I", "hint -f inputs normal ;; mode-leave ;; fake-key <Home>")


config.unbind("`")
config.bind("`a", ":zoom 100 ;; mode-enter set_mark ;; zoom 150")
# config.bind('`a', ':zoom 100 ;; set-mark a ;; zoom 150')


# rebinds
config.bind("d", "tab-close")
# config.bind('O', 'set-cmd-text -s :open -w')
config.bind("F", "hint all tab")
config.bind("I", "hint -f inputs normal ")
config.bind("m", "cmd-set-text --space :set-mark")
config.bind("M", "quickmark-save")
config.bind('"', "cmd-set-text --space :quickmark-load")
config.bind("gm", "tab-mute")
config.bind("gc", "tab-clone")
# config.bind('<Escape>', 'mode-leave ;; jseval -q document.activeElement.blur()', mode='insert')
config.bind("<Ctrl+Escape>", "fake-key <Escape>")
config.bind("e", "cmd-set-text --space :open")
config.bind("E", "cmd-set-text --space :open -t")
config.bind("ge", "cmd-set-text --space :open {url:pretty}")
config.bind("gE", "cmd-set-text --space :open -t {url:pretty}")
config.bind("gp", "cmd-set-text --space :open -p ")
config.bind("gP", "cmd-set-text --space :open -p {url:pretty}")



c.aliases['container-open'] = 'spawn --userscript container-open'
c.aliases['container-ls'] = 'spawn --userscript container-ls'
c.aliases['container-add'] = 'spawn --userscript container-add'
c.aliases['container-rm'] = 'spawn --userscript container-rm'


# config.bind(leader + "cd", "set-cmd-text -s :open -p")
#
# onfig.bind('C','spawn --userscript container-open')
# config.bind('<Alt-c>','set-cmd-text -s :spawn --userscript container-open')
# config.bind('<Alt-f>','hint links userscript container-open')
# config.bind('<Alt-f>','hint links userscript container-open')


config.bind("R", "spawn --userscript readability-js")
config.bind(leader + leader, "fake-key " + leader)
config.bind(leader + "o", "set-cmd-text -s :open -p")
config.bind(leader + "vv", 'hint links spawn --detach mpv "{hint-url}"')
config.bind(leader + "vr", 'hint -r links spawn --detach mpv "{hint-url}"')
config.bind(leader + "vu", 'spawn --detach mpv "{url}"')
config.bind(leader + "dd", 'hint links spawn ytdl "{hint-url}"')
config.bind(leader + "dr", 'hint -r links spawn --detach ytdl "{hint-url}"')
config.bind(leader + "du", 'spawn --detach ytdl "{url}"')
config.bind(leader + "ii", 'hint images spawn --detach img -u "{hint-url}"')
config.bind(leader + "ir", 'hint -r images spawn --detach img -u "{hint-url}"')
config.bind(leader + "iu", 'spawn --detach img -u "{url}"')
config.bind(leader + "cc", 'hint links spawn --detach chromium "{hint-url}"')
config.bind(leader + "cr", 'hint -r links spawn --detach chromium "{hint-url}"')
config.bind(leader + "cu", 'spawn --detach chromium "{url}"')
config.bind(leader + "bb", 'hint links spawn --detach brave "{hint-url}"')
config.bind(leader + "br", 'hint -r links spawn --detach brave "{hint-url}"')
config.bind(leader + "bu", 'spawn --detach brave "{url}"')
config.bind(leader + "ff", 'hint links spawn --detach firefox "{hint-url}"')
config.bind(leader + "fr", 'hint -r links spawn --detach firefox "{hint-url}"')
config.bind(leader + "fu", 'spawn --detach firefox "{url}"')
config.bind(leader + "tt", 'hint links spawn --detach tm -a "{hint-url}"')
config.bind(leader + "tr", 'hint -r links spawn --detach tm -a "{hint-url}"')
config.bind(leader + "tu", 'spawn --detach tm -a "{url}"')
config.bind(leader + "qq", "hint links userscript qr")
config.bind(leader + "qu", "spawn --userscript qr")
config.bind(leader + "qr", "hint -r links userscript qr")
config.bind(leader + "r", "spawn --userscript readability-js")


config.bind("<z><l>", "spawn --userscript qute-pass --dmenu-invocation fmenu")
config.bind(
    "<z><u><l>", "spawn --userscript qute-pass --dmenu-invocation fmenu --username-only"
)
config.bind(
    "<z><p><l>", "spawn --userscript qute-pass --dmenu-invocation fmenu --password-only"
)
config.bind(
    "<z><o><l>", "spawn --userscript qute-pass --dmenu-invocation fmenu --otp-only"
)


# load autoconfig.yml
config.load_autoconfig(True)

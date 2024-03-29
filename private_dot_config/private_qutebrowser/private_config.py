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
c.zoom.default = 100
c.content.autoplay = False
c.content.mute = True
c.fonts.web.size.minimum = 16
c.fonts.web.size.default = 18
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
    "w": "session-save -o -n",
    "w!": "session-save -o -n -q",
    "W": "session-save",
    "W!": "session-save -q",
    "e": "session-load",
    "e!": "session-load -t",
    "qa": "quit",
    "wq": "quit --save",
    "cs": "config-source",
    "au": "adblock-update",
    "qr": "spawn --userscript qr",
    "zm": "zoom 100; set",
    "dc": "download-clear",
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
c.content.javascript.clipboard = "none"
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
# === Session Config ===
# =====================

config.bind("sw", "cmd-set-text -s :session-save -o")
config.bind("se", "cmd-set-text -s :session-load")
config.bind("ds", "cmd-set-text -s :session-delete")

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
config.bind(leader + "bb", "tab-focus last")
config.bind(leader + "bf", "cmd-set-text --space :tab-focus")
config.bind(leader + "bw", "cmd-set-text --space :tab-select")
config.bind(leader + ",", "tab-focus last")
config.bind("<Ctrl+j>", "tab-move +")
config.bind("<Ctrl+k>", "tab-move -")

config.bind("e", "cmd-set-text --space :open")
config.bind("E", "cmd-set-text --space :open -t")
config.bind("ge", "cmd-set-text --space :open {url:pretty}")
config.bind("gc", "tab-clone")
config.bind("gC", "cmd-set-text --space :open -t {url:pretty}")
config.bind("gM", "tab-move")

config.unbind("d")
config.bind("dd", "tab-close")
config.bind("df", "tab-close -f")
config.bind("dp", "tab-close -p")
config.bind("dn", "tab-close -n")
config.bind("dD", "tab-only")
config.bind("dF", "tab-only -f")
config.bind("dP", "tab-only -p")
config.bind("dN", "tab-only -n")

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

config.bind("dw", "close")
config.bind("dW", "window-only")

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


# =========================
# === Open URL Keybinds ===
# =========================

# brave
config.bind(leader + "fb", 'hint links spawn --detach brave "{hint-url}"')
config.bind(leader + "rb", 'hint -r links spawn --detach brave "{hint-url}"')
config.bind(leader + "ub", 'spawn --detach brave "{url}"')
# firefox
config.bind(leader + "ff", 'hint links spawn --detach firefox "{hint-url}"')
config.bind(leader + "rf", 'hint -r links spawn --detach firefox "{hint-url}"')
config.bind(leader + "uf", 'spawn --detach firefox "{url}"')
# chromium
config.bind(leader + "fc", 'hint links spawn --detach chromium "{hint-url}"')
config.bind(leader + "rc", 'hint -r links spawn --detach chromium "{hint-url}"')
config.bind(leader + "uc", 'spawn --detach chromium "{url}"')
# mpv
config.bind(leader + "fM", 'hint links spawn --detach mpv "{hint-url}"')
config.bind(leader + "rM", 'hint -r links spawn --detach mpv "{hint-url}"')
config.bind(leader + "uM", 'spawn --detach mpv "{url}"')
# ytdl
config.bind(leader + "fm", 'hint links spawn ytdl "{hint-url}"')
config.bind(leader + "rm", 'hint -r links spawn --detach ytdl "{hint-url}"')
config.bind(leader + "um", 'spawn --detach ytdl "{url}"')
# images
config.bind(leader + "fi", 'hint images spawn --detach img -u "{hint-url}"')
config.bind(leader + "ri", 'hint -r images spawn --detach img -u "{hint-url}"')
config.bind(leader + "ui", 'spawn --detach img -u "{url}"')
config.bind(leader + "ft", 'hint links spawn --detach tm -a "{hint-url}"')
config.bind(leader + "rt", 'hint -r links spawn --detach tm -a "{hint-url}"')
config.bind(leader + "ut", 'spawn --detach tm -a "{url}"')
config.bind(leader + "fq", "hint links userscript qr")
config.bind(leader + "uq", "spawn --userscript qr")
config.bind(leader + "rq", "hint -r links userscript qr")
config.bind(leader + "fr", "hint links spawn --userscript readability {hint-url}")
config.bind(leader + "rr", "hint links -r spawn --userscript readability {hint-url}")
config.bind(leader + "ur", "spawn --userscript readability {url}")


# ================================
# === Container/Profile Config ===
# ================================

c.aliases['container-open'] = 'spawn qbpm launch'
c.aliases['container-add'] = 'spawn qbpm new'
c.aliases['container-list'] = 'spawn --output-messages qbpm list'

config.bind("co", "cmd-set-text -s :container-open")
config.bind("ca", "cmd-set-text -s :container-add")
config.bind("cl", "container-list")

# ================================
# === Enable / Disable Content ===
# ================================

# adblocker
config.bind("cea", "set -p -u {url:host} content.blocking.enabled true")
config.bind("cda", "set -p -u {url:host} content.blocking.enabled false")
config.bind("ceua", "set -p -u {url} content.blocking.enabled true")
config.bind("cdua", "set -p -u {url} content.blocking.enabled false")
# javascript
config.bind("cej", "set -p -u {url:host} content.javascript.enabled true")
config.bind("cdj", "set -p -u {url:host} content.javascript.enabled false")
config.bind("ceuj", "set -p -u {url} content.javascript.enabled true")
config.bind("cduj", "set -p -u {url} content.javascript.enabled false")
# cookies
config.bind("cec", "set -p -u {url:host} content.cookies.accept no-3rdparty")
config.bind("cEc", "set -p -u {url:host} content.cookies.accept all")
config.bind("cdc", "set -p -u {url:host} content.cookies.accept never")
config.bind("ceuc", "set -p -u {url} content.cookies.accept no-3rdparty")
config.bind("cEuc", "set -p -u {url} content.cookies.accept all")
config.bind("cduc", "set -p -u {url} content.cookies.accept never")
# clipboard
config.bind("cey", "set -p -u {url:host} content.javascript.clipboard access")
config.bind("cdy", "set -p -u {url:host} content.javascript.clipboard none")
config.bind("ceuy", "set -p -u {url} content.javascript.clipboard access")
config.bind("cduy", "set -p -u {url} content.javascript.clipboard none")
# images
config.bind("cei", "set -p -u {url:host} content.images true")
config.bind("cdi", "set -p -u {url:host} content.images false")
config.bind("ceui", "set -p -u {url} content.images true")
config.bind("cdui", "set -p -u {url} content.images false")


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

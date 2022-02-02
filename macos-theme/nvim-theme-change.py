import subprocess
from pynvim import attach
import argparse


parser = argparse.ArgumentParser()
parser.add_argument('mode', nargs='?', default='light', type=str)
args = parser.parse_args()
mode = args.mode

servers = subprocess.run(['nvr', '--serverlist'], stdout=subprocess.PIPE)
servers = servers.stdout.splitlines()

for server in servers:
    try:
        nvim = attach('socket', path=server)
        if mode == 'light':
            nvim.command('set background=light')
            nvim.command('colorscheme solarized')
        else:
            nvim.command('set background=dark')
            nvim.command('colorscheme gruvbox')
    except Exception as err:
        print(err)
        continue


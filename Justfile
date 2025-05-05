# Create: 2025/05/05 16:39:29
# Description: aes-256-cbc encryption/decryption
# Ref:
#   1. https://github.com/casey/just
#   2. https://www.nushell.sh/book/
# Author: M.J.

set shell := ['nu', '--no-std-lib', '-m', 'light', '-c']

# The export setting causes all just variables
# to be exported as environment variables.

set export := true
set dotenv-load := true

# If positional-arguments is true, recipe arguments will be
# passed as positional arguments to commands. For linewise
# recipes, argument $0 will be the name of the recipe.

set positional-arguments := true

# Use `just --evaluate` to show env vars

# Used to handle the path separator issue
JUST_FILE_PATH := justfile()
NU_DIR := parent_directory(`(which nu).path.0`)
_s := if os_family() == 'windows' { '\' } else { '/' }
_home_env := if os_family() == 'windows' { 'USERPROFILE' } else { 'HOME' }
# FIXME: A just bug: invalid directory path by invoking invocation_directory
JUST_INVOKE_DIR := replace(replace(invocation_directory(), '/', _s), '\d\', 'D:\')
_query_plugin := if os_family() == 'windows' { 'nu_plugin_query.exe' } else { 'nu_plugin_query' }

# To pass arguments to a dependency, put the dependency
# in parentheses along with the arguments, just like:
# default: (sh-cmd "main")

# List available commands by default
default: _setup
  @just --list --list-prefix "··· "

# 加密配置文件, e.g.: just enc secret encoded
enc in out:
  @openssl enc -aes-256-cbc -a -salt -pbkdf2 -iter 100 -in {{ in }} -out {{ out }}

# 解密配置文件, e.g.: just dec encoded
dec in:
  @openssl enc -d -aes-256-cbc -a -pbkdf2 -iter 100 -in {{ in }}

# 从 Nu v0.61.0 开始插件只需注册一次即可
_setup:
  @plugin add {{ join(NU_DIR, _query_plugin) }};

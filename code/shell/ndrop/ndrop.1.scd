ndrop(1)

# NAME

ndrop - run, show and hide programs on niri

# SYNOPSIS

*ndrop* [OPTIONS] [COMMAND]

# COMMAND 
	The usual command you would run to start the desired program

# OPTIONS

*-c, --class*
	Set classname of the program to be run. Use this if the classname is different from the name of the [COMMAND] and ndrop has not yet a hardcoded replacement.

*-F, --focus*
	Changes the default behaviour: focus the specified program's window and switch to its present workspace if necessary. Do not hide it, if it's already on the current workspace."

*-H, --help*  
	Print help message

*-i, --insensitive*
	Case insensitive partial matching of class names. Can work as a stopgap if a running program is not recognized and a new instance is launched instead. Note: incorrect matches may occur, adding a special handling of the program to *ndrop* (hardcoded or via *-c, --class*) is preferable.

*-o, --online*
	Delay initial launch for up to 20 seconds until internet connectivity is established.

*-v, --verbose*  
	Show notifications regarding the matching process. Try this to figure out why running programs are not matched."

*-V, --version*  
	Print version

# Description

This script emulates the main features of [tdrop](https://github.com/noctuid/tdrop) in niri:

- if the specified program is not running: launch it and bring it to the foreground.
- if the specified program is already running on another workspace: bring it to the current workspace and focus it.
- if the specified program is already on the current workspace: move it to workspace 'special:ndrop', thereby hiding it until called up again by ndrop.

# Multiple instances:

Multiple instances of the same program can be run concurrently, if different class names are assigned to each instance. Presently there is support for the following flags in the [COMMAND] string:

```
-a ('foot' terminal emulator)  
--class (all other programs).
```

# Example bindings in niri config:

```
bind = $mainMod, b, exec, ndrop librewolf  
bind = $mainMod, x, exec, ndrop kitty --class kitty_1  
bind = $mainMod CTRL, x, exec, ndrop kitty --class kitty_2  
bind = $mainMod, c, exec, ndrop foot -a foot_1  
bind = $mainMod CTRL, c, exec, ndrop foot -a foot_2
```

Note: defining a class name is only necessary when running several instances of the same program.

If you want to run a program on boot and have it wait in the background until called up by ndrop you can use this:

```
exec-once = ndrop -b librewolf
```

# Troubleshooting

## Cursor jumps to newly focused windows

Set *no_cursor_warps = true* in *niri.conf* section general

## Further instances of programs are started instead of hiding/unhiding a running instance

If ndrop can't match an already running program and starts a new instance instead, then its class name is most likely different from its command name. For example, the class name of *telegram-desktop* is *org.telegram.desktop* and the class name of *logseq* is *Logseq*.

Run *ndrop -v [COMMAND]* _in the terminal_ to see maximum output for troubleshooting and find out the actual class name. Then use *ndrop -c CLASSNAME* to make it work. *ndrop -i [COMMAND]* might be sufficient, as long as a case insensitive (partial) match is sufficient.

Please report instances of programs with differing class names, so that they can be added to *ndrop*.

## Floating windows don't react to changed arguments

Close the program (don't just hide it with ndrop). The changed arguments are only applied when the program is restarted. 

# License 

Dependencies: bash jq niri  
Part of: https://github.com/hyprwm/contrib  
Author: Schweber (https://github.com/Schweber/ndrop)  
License: AGPL3

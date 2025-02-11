ASCIINEMA
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This filetype plugin provides settings, commands, and syntax highlighting for
asciinema terminal session recordings (\*.cast) in order to tweak and enhance
the recording.

The v2 format uses absolute timestamps (in fractional seconds), so additional
tools are needed to add more delay or speed up sections, and multiple
recordings cannot simply be concatenated.
```
[2.56533, "o", "a"]
[2.676512, "o", "b"]
[2.756698, "o", "c"]
```
This plugin facilitates manual edits by adding a new first column with a +0.42
relative offset, which then takes precedence over the following original
absolute time when writing the buffer:
```
[+2.56533 ,   2.56533 , "o", "a"]
[+0.111182,   2.676512, "o", "b"]
[+0.080186,   2.756698, "o", "c"]
```
By editing the relative offset, durations can be shortened or prolonged
easily. If you want the adaptation to stop at a certain frame, simply remove
the added first column; the absolute timestamp will be used (if necessary
increased to avoid a jump back into the past).

### RELATED WORKS

- https://github.com/hydrargyrum/asciinema-comment is a Python tool that wraps
  the screencast in a screen session to add one reserved blank line, and then
  inserts comments from a subtitles file.
- https://github.com/jdum/asciinema-scene is a Python tool to copy / cut /
  merge / quantize screencasts and edit frames, but it has no dedicated support
  for comments.

USAGE
------------------------------------------------------------------------------

    :AsciinemaInsertMarker [{label}]
                            Insert a specific point on a recording's timeline,
                            which can be used for navigation within the recording
                            or to automate the player. It's inserted after the
                            current frame and appears at the same time.

    :AsciinemaInsertCommentAtCursor {comment}
                            Insert a comment at the recording's current cursor
                            position. It will appear after the current frame and
                            does not modify the cursor position, so any following
                            records will overwrite it (unless they jump
                            elsewhere).

    :AsciinemaInsertCommentAndMarkerAtCursor {comment}
                            Insert both a marker and comment at the recording's
                            current cursor position, to provide commentary on
                            what's about to happen and allow to navigate to it.

    :AsciinemaExtendTimedCommentAtCursor {comment}
    :AsciinemaExtendTimedCommentAndMarkerAtCursor {comment}
                            Insert a comment at the recording's current cursor
                            position, and clear it again after
                            g:asciinema_TimedCommentDuration. Following records
                            are kept untouched, so this increases the overall
                            duration of the recording.

    :AsciinemaInsertTimedCommentAtCursor {comment}
    :AsciinemaInsertTimedCommentAndMarkerAtCursor {comment}
                            Insert a comment at the recording's current cursor
                            position, and clear it again before the next frame
                            happens (but show it no longer than
                            g:asciinema_TimedCommentDuration). The delay between
                            the current and the following frame is reduced
                            accordingly.

    :[{row}[,{col}]]AsciinemaInsertCommentAtPosition {comment}
    :[{row}[,{col}]]AsciinemaInsertCommentAndMarkerAtPosition {comment}
                            Insert a comment at {row}, {col} (first column if
                            omitted) or g:asciinema_DefaultPosition if no
                            address is given. It will appear after the current
                            frame and does not permanently change the cursor
                            position, so any following records will continue as if
                            it weren't there.

    :[{row}[,{col}]]AsciinemaExtendTimedCommentAtPosition {comment}
    :[{row}[,{col}]]AsciinemaExtendTimedCommentAndMarkerAtPosition {comment}
                            Insert a comment at {row}, {col} (first column if
                            omitted) or g:asciinema_DefaultPosition if no
                            address is given, and clear it again after
                            g:asciinema_TimedCommentDuration. Following records
                            are kept untouched, so this increases the overall
                            duration of the recording.

    :[{row}[,{col}]]AsciinemaInsertTimedCommentAtPosition {comment}
    :[{row}[,{col}]]AsciinemaInsertTimedCommentAndMarkerAtPosition {comment}
                            Insert a comment at {row}, {col} (first column if
                            omitted) or g:asciinema_DefaultPosition if no
                            address is given, and clear it again before the next
                            frame happens (but show it no longer than
                            g:asciinema_TimedCommentDuration). The delay
                            between the current and the following frame is
                            reduced accordingly.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-asciinema
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim asciinema*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.2 or higher with +float support.
- Requires Vim 8.1.560 or higher for the :Asciinema\*AtPosition commands.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.046 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

Text that is inserted before / after the passed {comment}; e.g. quotes and/or
ANSI escape sequences for highlighting.

Duration in seconds that a timed comment is shown before it's cleared again.

Minimum duration in seconds to the next frame that
:AsciinemaInsertTimedCommentAtCursor et al. accept, so that the comment is
actually readable. Use :AsciinemaExtendTimedCommentAtCursor et al. if the
next frame follows too quickly.

The default row, col for the :AsciinemaInsertCommentAtPosition commands; the
default is the terminal's upper left corner:

    let g:asciinema_DefaultPosition = [1, 1]

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-asciinema/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### GOAL
First published version.

##### 0.01    09-Feb-2025
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2025 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;

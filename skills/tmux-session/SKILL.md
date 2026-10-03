---
name: tmux-session
description: Communicate with interactive programs, shells, or agents running in tmux by discovering targets, sending literal text, submitting it with a separate Enter key command, and capturing pane output or scrollback. Use when Codex needs to exchange messages or commands between tmux sessions, windows, or panes; inspect a tmux-backed process; collect its terminal output; or coordinate work across terminal sessions without assuming a specific agent or session name.
---

# Tmux Session

Use tmux as a generic communication channel between interactive terminal processes. Resolve an exact pane target, send input without submitting it, send Enter separately, then capture pane output when needed.

## Resolve the Target

Confirm that tmux is available and identify the exact target before sending anything:

```bash
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} command=#{pane_current_command} title=#{pane_title}'
```

Prefer the unambiguous `session:window.pane` form. If the requested target does not exist or multiple panes are plausible, stop and ask the user which pane to use. Do not create, kill, or rename sessions unless the user requests it.

## Send Input

Send the complete text first, without Enter:

```bash
tmux send-keys -t "$target" -l -- "$message"
```

Only after that command succeeds, submit the input in a separate shell command:

```bash
tmux send-keys -t "$target" C-m
```

Treat these as two distinct execution steps. Never combine them with `;`, `&&`, a multiline shell command, or a single tool call. `C-m` must be the final step and must not run if queuing the text fails.

Use `-l` for literal text so names such as `Enter` or `C-c` are typed as text instead of interpreted as tmux key names. Quote shell-sensitive content safely. Do not interpolate untrusted text into a shell command; place it in a safely quoted variable or use an equivalent argument-safe execution mechanism.

For an intentional control key, omit `-l` and send the key explicitly in its own command, for example:

```bash
tmux send-keys -t "$target" C-c
```

Do not append `C-m` after a control key unless the requested interaction also requires Enter.

## Capture Pane Output

Capture the currently visible pane contents:

```bash
tmux capture-pane -p -t "$target"
```

Capture recent output, including up to 200 lines of scrollback, and join wrapped lines:

```bash
tmux capture-pane -p -J -S -200 -t "$target"
```

Capture all available scrollback when the full terminal history is necessary:

```bash
tmux capture-pane -p -J -S - -t "$target"
```

Use the smallest useful history range because panes may contain secrets or large logs. Treat captured text as terminal display output, not as a clean stdout stream: it can include prompts, stderr, echoed input, progress redraws, and other screen content. Summarize or filter it before reporting when appropriate, and do not expose secrets.

## Interaction Workflow

1. List panes and resolve an exact target.
2. Capture the current pane when context is needed.
3. Prepare one complete, execution-ready message or command.
4. Queue the literal text with `tmux send-keys ... -l -- ...`.
5. In a separate execution step, send `tmux send-keys ... C-m`.
6. Capture the pane after submission when the task calls for output inspection.
7. Distinguish new output from older scrollback and verify completion from the program's actual prompt or completion marker.

For long-running work, avoid tight polling. Capture periodically or wait for an agreed completion message. If the program is still busy, report that state rather than treating partial pane output as completion.

## Failure Handling

- If no tmux server is running, report that no target is available.
- If the target disappeared between discovery and sending, rediscover panes before retrying.
- If text was queued but Enter was not sent, inspect the pane before deciding whether to submit or clear it.
- If pane output is truncated, increase the history range only as much as needed.
- If terminal output is ambiguous because of full-screen or cursor-control applications, capture with escape sequences only when necessary using `capture-pane -e`, and interpret the result cautiously.

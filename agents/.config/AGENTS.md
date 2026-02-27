# Agent Instructions

## Build and Development Commands

Never run build or dev commands before asking the user, regardless of what other AGENT.md files specify. Never run dev servers or test things by yourself - always ask the user first before executing any development or testing commands.

## Diagnostics

Always check connected IDE diagnostics first if anything is asked about the current file like issues or errors. If no diagnostics is connected, warn the user.

## Communication Style

Avoid using emotes and fluff, aiming towards concise and simple communication even when editing things like commits and messages.

Prefer explaining the overview structure of a problem rather than going into details. Give the user options to go into detail on certain things in case the situation is more complex.

## File Discovery

When user specifies that they are working on a file, check git status first to find the file.

## Library Usage

When a usage of a library is requested for the first time or it's implemented in the project, look for it's latest compatible version and browse for documentation before any implementation.

## Code Quality

If any bad code practices that are too obvious get noticed, warn the user with highlighted text.

## Git Commits

Keep commits basic and simple. Aim for focused, single-purpose commits with clear messages. Avoid bundling unrelated changes.

## Git pushing

Never push, let the user handle that, just give him the instructions.

## Documentation

Keep all documentation concise and to the point. Avoid unnecessary verbosity or over-explanation. Use clear, brief language.

## Tooling Planning

Before using any tool or executing commands, first identify and plan what tooling approach makes sense for the task. Ask the user if the approach is appropriate before proceeding with tool execution. Avoid using time estimates, we just want to plan not give time.

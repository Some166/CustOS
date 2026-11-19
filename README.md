# custOS

A centralised facility and general-purpose operating system for CC: Tweaked.

## Version 0.1 — server foundation

This first milestone boots a central server, opens a Rednet modem, announces its presence,
and responds to client discovery and status requests. It does not yet provide user accounts,
file sharing, a desktop, or facility controls.

## Hardware

- One Advanced Computer for the central server
- One wired or wireless modem attached to the server
- HTTP enabled in the CC: Tweaked configuration (for future installation/updates)

## Install

Copy the contents of this project onto the server computer, preserving the folder structure.
From the computer's root directory, run:

    server/main.lua

To start it automatically, run:

    edit startup.lua

and enter:

    shell.run("server/main.lua")

## Network protocol

Protocol name: `custos_v1`

Supported requests:
- `DISCOVER` — server replies with `SERVER_INFO`
- `STATUS` — server replies with `STATUS`

Messages are Lua tables sent through Rednet. Clients must treat all server responses as
untrusted data until later authentication and integrity checks are implemented.

## Important security note

The server is the authority for permissions and protected operations. A client must never
be trusted to assert its own clearance or authorisation. CC: Tweaked networking is not
cryptographically secure, so this is a Minecraft roleplay/software project, not a real
security boundary.

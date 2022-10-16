# NixOS Synapse Server

## Requirements

### NixOS
- Installed on remote
- Key authentication for a user named 'nixos'
- doas

### SOPS

- Email
- Discord Token
- Synapse Registration PW

## Post-Install

- Copy `/var/lib/matrix-appservice-discord/discord-registration.yaml` to `/var/lib/matrix-synapse`

## TO-DO

- Nixify post-install
- Move federation behind proxy with .well-known
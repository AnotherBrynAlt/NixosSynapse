{ lib, ... }:
{
  systemd.targets.hyperv-daemons.wantedBy = lib.mkForce [];
  systemd.targets.hyperv-daemons.wants = lib.mkForce [];
}


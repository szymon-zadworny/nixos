{ config, lib, pkgs, ... }:

let
  cfg = config.services.nvidiaPower;
  gpuScript = pkgs.writeShellScriptBin "gpu" (builtins.readFile ./gpu.sh);
in
{
  options.services.nvidiaPower = {
    enable = lib.mkEnableOption "NVIDIA GPU power control";
    busId = lib.mkOption {
      type = lib.types.str;
      description = "PCI Bus ID of the NVIDIA GPU (e.g. 0000:01:00.0)";
    };
    autoDisableOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];

    environment.systemPackages = [ gpuScript ];

    systemd.services.nvidia-power-off = lib.mkIf cfg.autoDisableOnBoot {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${gpuScript}/bin/gpu off";
      };
    };

    systemd.services.nvidia-resume = {
      description = "Restore NVIDIA GPU state after suspend/hibernate";
      after = [ "suspend.target" "hibernate.target" ];
      wantedBy = [ "suspend.target" "hibernate.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${gpuScript}/bin/gpu resume";
      };
    };
  };
}

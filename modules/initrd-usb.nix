{ config, lib, pkgs, ... }:

with lib;

let
  device_info = config.mobile.device.info;
  cfg = config.mobile.boot.stage-1;
  device_name = device_config.name;
  device_config = config.mobile.device;
  system_type = config.mobile.system.type;
in
{
  options.mobile.boot.stage-1.usb = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables USB features.
        For now, only Android-based devices are supported.
      '';
    };
    features = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        `android_usb` features to enable.
      '';
    };
  };
  options.mobile.usb = {
    idVendor = mkOption {
      type = types.str;
      description = ''
        USB vendor ID for the USB gadget.
      '';
    };
    idProduct = mkOption {
      type = types.str;
      description = ''
        USB product ID for the USB gadget.
      '';
    };
    mode = mkOption {
      type = types.nullOr (types.enum [ "android_usb" "gadgetfs" ]);
      default = null;
      description = ''
        The USB gadget implementation the device uses.
      '';
    };
  };

  config = lib.mkIf (config.mobile.usb.mode != null && cfg.usb.enable) {
    boot.specialFileSystems = {
      # This is required for gadgetfs configuration.
      "/sys/kernel/config" = {
        # FIXME: remove once added to <nixpkgs/nixos/modules/tasks/filesystems.nix> specialFSTypes
        device = "configfs";
        fsType = "configfs";
        options = [ "nosuid" "noexec" "nodev" ];
      };
    };

    mobile.boot.stage-1 = lib.mkIf (cfg.usb.enable && (config.mobile.usb.mode != null)) {
      kernel.modules = [
        "configfs"
        "libcomposite"
      ]
      ++ optionals (device_info ? gadgetfs) (
        forEach cfg.usb.features (feature:
          let function = lib.head (lib.splitString "." device_info.gadgetfs.functions."${feature}");
          in "usb_f_${function}"
        )
      );

      usb.features = []
        ++ optional cfg.networking.enable "rndis"
      ;
      tasks = [
        ./stage-1/tasks/usb-gadget-task.rb
      ];
      bootConfig = {
        boot.usb.features = cfg.usb.features;
        boot.usb.functions = mkIf (device_info ? gadgetfs) (builtins.listToAttrs (
          builtins.map (feature: { name = feature; value = device_info.gadgetfs.functions."${feature}"; }) cfg.usb.features
        ));
        usb = {
          inherit (config.mobile.usb) idVendor idProduct mode;
        };
      };
    };
  };
}

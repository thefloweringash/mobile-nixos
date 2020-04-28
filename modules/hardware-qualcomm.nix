{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.mobile.hardware.socs;
in
{
  options.mobile = {
    hardware.socs.qualcomm-apq8064-1aa.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is APQ8064–1AA";
    };
    hardware.socs.qualcomm-msm8953.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is msm8953";
    };
    hardware.socs.qualcomm-msm8939.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is msm8939";
    };
    hardware.socs.qualcomm-msm8974.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is msm8974";
    };
    hardware.socs.qualcomm-msm8996.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is msm8996";
    };
    hardware.socs.qualcomm-msm8998.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is msm8998";
    };
    hardware.socs.qualcomm-sdm660.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is SDM660";
    };
  };

  config = mkMerge [
    {
      mobile = mkIf cfg.qualcomm-msm8939.enable {
        system.system = "aarch64-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
    {
      mobile = mkIf cfg.qualcomm-msm8953.enable {
        system.system = "aarch64-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
    {
      mobile = mkIf cfg.qualcomm-msm8974.enable {
        system.system = "armv7l-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
    {
      mobile = mkIf cfg.qualcomm-msm8996.enable {
        system.system = "aarch64-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
    {
      mobile = mkIf cfg.qualcomm-msm8998.enable {
        system.system = "aarch64-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
    {
      mobile = mkIf cfg.qualcomm-sdm660.enable {
        system.system = "aarch64-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
    {
      mobile = mkIf cfg.qualcomm-apq8064-1aa.enable {
        system.system = "armv7l-linux";
        quirks.qualcomm.msm-fb-refresher.enable = true;
      };
    }
  ];
}

{ config, lib, pkgs, ... }:

let
  kernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };

  # The kernel should be generic and apply to any msm8974 device. To
  # use it with a particular device we need to add the particular dtb
  # to the kernel.
  kernelWithDTB = dtbName: pkgs.runCommand "kernel-with-dtb" {
    passthru.file = "zImage-dtb";
  } ''
    mkdir $out
    ln -s --target-directory=$out ${kernel}/*
    cat ${kernel}/zImage ${kernel}/dtbs/${dtbName}.dtb > $out/zImage-dtb
  '';
in
{
  mobile.boot.stage-1.kernel = {
    modular = true; # TODO: why is this not passthru
    modules = [ "pm8941_pwrkey" "qnoc_msm8974" "rmi_i2c" ];
    # TODO: firmwares = []; ???
  };

  mobile.device.name = "lg-hammerhead";

  # Mostly adapted from postmarketOS
  # https://gitlab.com/postmarketOS/pmaports/-/blob/a7553d6f3c8dcef0af5bda2ca3c71932c7d1dff0/device/testing/device-lg-hammerhead/deviceinfo
  mobile.device.info = rec {
    name = "LG Nexus 5";
    format_version = "0";
    manufacturer = "LG";
    codename = "lg-hammerhead";
    date = "";
    # TODO : make kernel part of options.
    kernel = kernelWithDTB dtb;
    dtb = "qcom-msm8974-lge-nexus5-hammerhead";
    modules_initfs = "pm8941_pwrkey qnoc_msm8974 rmi_i2c";
    arch = "armv7l";
    keyboard = "false";
    external_storage = "false";
    screen_width = "1080";
    screen_height = "1920";
    dev_touchscreen = "";
    dev_touchscreen_calibration = "";
    dev_keyboard = "";
    flash_method = "fastboot";

    kernel_cmdline = lib.concatStringsSep " " [
      "console=tty0"
      "console=ttyMSM0,115200,n8"

      # Using `quiet` fixes early framebuffer init, for stage-1
      "quiet"
    ];

    generate_bootimg = "true";
    # bootimg_qcdt = false;
    flash_offset_base = "0x00000000";
    flash_offset_kernel = "0x00008000";
    flash_offset_ramdisk = "0x2900000";
    flash_offset_second = "0x00f00000";
    flash_offset_tags = "0x02700000";
    flash_pagesize = "2048";

    # TODO : commented out anything that didn't match pmaports deviceinfo

    # ab_partitions = true;
    # vendor_partition = "/dev/disk/by-partlabel/vendor_a";
    # gadgetfs.functions = {
    #   rndis = "gsi.rndis";
    #   # FIXME: This is the right function name, but doesn't work.
    #   # adb = "ffs.usb0";
    # };
  };

  mobile.hardware = {
    soc = "qualcomm-msm8974";
    ram = 1024 * 2;
    screen = {
      width = 1080; height = 1920;
    };
  };

  mobile.system.type = "android";

  # mobile.usb.mode = "gadgetfs";
  # # Google
  # mobile.usb.idVendor = "18D1";
  # # "Nexus 4"
  # mobile.usb.idProduct = "D001";
}

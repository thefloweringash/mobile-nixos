{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "firmware-adreno";

  srcs = let
    owner = "TheMuppets";
    repo = "proprietary_vendor_sony";
    rev = "bf15795df1d1dcd61d37f6215c1eda47e669d54e";
  in lib.mapAttrsToList (name: sha256: fetchurl {
    url = "https://github.com/${owner}/${repo}/raw/${rev}/${name}";
    inherit sha256;
    passthru.basename = baseNameOf name;
  }) {
    "shinano-common/proprietary/etc/firmware/a225_pm4.fw" =
      "1iy46l3avdns4d0ifb4796rmhmx0bacvzr22hrdj7r6022zp8mmk";
    "shinano-common/proprietary/etc/firmware/a225_pfp.fw" =
      "0729gwcdwz6nxqk0wnhvplrkxa7kyc7crm7h9dfqkj3kr2knkwd3";
    "shinano-common/proprietary/etc/firmware/a225p5_pm4.fw" =
      "1krpx92shad68mbg5qyfi5zrv062dhwxsg2d117lmrw4yjx8lsh9";
    "shinano-common/proprietary/etc/firmware/a330_pfp.fw" =
      "1pmmzpqmb9igydm526s21ndgvn97f6pmpv86lvk5c7wnhyr7dvp4";
    "shinano-common/proprietary/etc/firmware/a330_pm4.fw" =
      "005h0iry4k09jblvs8x878lkkhfhz4mwamfp996hpayjkbrvymr0";

    "ivy/proprietary/etc/firmware/a420_pfp.fw" =
      "1ss6knkwqw3f1nkdjx6y6slhc0cnjs0mz64kd0adh22agmlkp8nc";
    "ivy/proprietary/etc/firmware/a420_pm4.fw" =
      "04jmbm7dbv8vpw5m680bq132qzgiqn7zdmaayg9m31lhk8nyvv2j";
  };

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/lib/firmware/qcom
  '' + lib.concatMapStrings (src: ''
    cp ${src} $out/lib/firmware/qcom/${src.basename}
  '') srcs;

  meta = {
    license = lib.licenses.unfree;
  };
}

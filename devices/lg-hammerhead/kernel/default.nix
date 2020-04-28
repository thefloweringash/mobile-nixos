{
  mobile-nixos
, fetchFromGitLab
, kernelPatches ? [] # FIXME
, buildPackages
, dtbTool
}:

let
  inherit (buildPackages) dtc;
in

(mobile-nixos.kernel-builder {
  configfile = ./config.armv7l;

  file = "zImage";
  hasDTB = true;

  version = "5.6.0-rc6";
  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "linux-postmarketos";
    rev = "5e47680b0bbc71dbc093123790951cc81eb2b84e";
    sha256 = "1yw87s99zqdknsx9w7ndvanbhxdxp5ckwdy496638g049syr8dzm";
  };

  # patches = [ ];

  isModular = true;
}).overrideAttrs({ postInstall ? "", postPatch ? "", nativeBuildInputs, ... }: {
  installTargets = [ "zinstall" "modules_install" ];
  nativeBuildInputs = nativeBuildInputs ++ [ dtc ];
  postInstall = postInstall + ''
    mkdir -p "$out/boot"

    # FIXME factor this out properly
    # Copies all potential output files.
    for f in zImage-dtb Image.gz-dtb zImage Image.gz Image; do
      f=arch/arm/boot/$f
      [ -e "$f" ] || continue
      echo "zImage found: $f"
      cp -v "$f" "$out/"
      break
    done

    mkdir -p $out/dtb
    for f in arch/*/boot/dts/*.dtb; do
      cp -v "$f" $out/dtb/
    done
  '';
})

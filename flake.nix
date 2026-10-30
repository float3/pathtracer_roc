{
  description = "A minimal path tracer in Roc";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    lib = nixpkgs.lib;
    # The nightly main.roc is checked against; keep in step with the README and CI.
    nightly = "2026-08-30-34e7489";
    builds = {
      x86_64-linux = {
        name = "linux_x86_64";
        hash = "sha256-pNuXKgP2MN77N46MhiNWOTueXvwiFr6MHJdFlUnitBA=";
      };
      aarch64-linux = {
        name = "linux_arm64";
        hash = "sha256-jXC/26ym73VdKPtFEGCk3JYJ03FoAxujj4zqwE2Hmk4=";
      };
      aarch64-darwin = {
        name = "macos_apple_silicon";
        hash = "sha256-nEII+mAaFxxSKXwndHE9ACj/VJvir1auOefyWJ5gM1w=";
      };
    };
    forAllSystems = f: lib.genAttrs (lib.attrNames builds) (system: f system nixpkgs.legacyPackages.${system});
  in {
    formatter = forAllSystems (_: pkgs: pkgs.alejandra);

    packages = forAllSystems (system: pkgs: {
      roc = pkgs.stdenv.mkDerivation {
        pname = "roc";
        version = "nightly-${nightly}";
        src = pkgs.fetchurl {
          url = "https://github.com/roc-lang/nightlies/releases/download/nightly-${nightly}/roc_nightly-${builds.${system}.name}-${nightly}.tar.gz";
          inherit (builds.${system}) hash;
        };
        sourceRoot = ".";
        nativeBuildInputs = lib.optional pkgs.stdenv.isLinux pkgs.autoPatchelfHook;
        buildInputs = lib.optional pkgs.stdenv.isLinux pkgs.stdenv.cc.cc.lib;
        installPhase = ''
          runHook preInstall
          install -Dm755 "$(find . -type f -name roc | head -1)" $out/bin/roc
          runHook postInstall
        '';
        meta.mainProgram = "roc";
      };
    });

    devShells = forAllSystems (system: pkgs: {
      default = pkgs.mkShell {
        packages = [self.packages.${system}.roc];
      };
    });
  };
}

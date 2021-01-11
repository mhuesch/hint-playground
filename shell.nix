let
  sources = import ./nix/sources.nix;
in

{ pkgs ? import sources.nixpkgs {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # haskell
    cabal-install
    ghc

    # docker containers
    conmon
    podman
    runc
  ];
}

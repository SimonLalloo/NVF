{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      self,
      nixpkgs,
      nvf,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux" # AMD64 Linux
        "aarch64-darwin" # Apple Silicon Mac
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system: {
        default =
          (nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              ./nvf-configuration.nix
            ];
          }).neovim;
      });

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          nvf.nixosModules.default
        ];
      };
    };
}

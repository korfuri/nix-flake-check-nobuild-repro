{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    nixosConfigurations.test = let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      known_hosts_file = pkgs.writeTextFile {
        name = "known_hosts";
        text = "";
      };
    in nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [{
        fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "24.05";
        programs.ssh.knownHostsFiles = [ known_hosts_file ];
      }];
    };
  };
}


{...}:

{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq3HjKp2MZp2Gv8wZK6U="
    ];

    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    http-connections = 25;
    connect-timeout = 10;
    stalled-download-timeout = 60;
  };
}
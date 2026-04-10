{ config, lib, pkgs, google-workspace-cli, ... }:

{
  environment.systemPackages = with pkgs; [
    # Python
    python3
    python3Packages.pip
    pyright

    # JavaScript / Node
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.npm

    # Elixir
    elixir
    erlang
    elixir-ls

    # Zig
    zig
    zls

    # C
    gcc
    gnumake
    cmake
    clang-tools

    # Rust
    rustup
    rust-analyzer

    # Nix
    nil
    nixfmt-rfc-style

    # Google Workspace CLI
    google-workspace-cli.packages.x86_64-linux.default
    google-cloud-sdk

    # General dev tools
    ripgrep
    fd
    fzf
    jq
    tree
    bat
    eza
    lazygit
    lazydocker
    tmux
    docker-compose
  ];
}

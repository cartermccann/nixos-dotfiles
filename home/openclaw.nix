{ config, pkgs, lib, ... }:

let
  baseConfig = ./openclaw/config.json;
  secretsExample = ./openclaw/secrets.json.example;

  # Script to merge base config with local secrets and fix placeholders
  mergeScript = pkgs.writeShellScript "openclaw-merge-config" ''
    set -euo pipefail
    OPENCLAW_DIR="$HOME/.openclaw"
    BASE_CONFIG="${baseConfig}"
    SECRETS_FILE="$OPENCLAW_DIR/secrets.json"
    OUTPUT="$OPENCLAW_DIR/openclaw.json"

    mkdir -p "$OPENCLAW_DIR"

    # Start from base config, replacing home directory placeholder
    ${pkgs.jq}/bin/jq --arg home "$HOME" '
      walk(if type == "string" then gsub("PLACEHOLDER_HOME"; $home) else . end)
    ' "$BASE_CONFIG" > "$OUTPUT.tmp"

    # Merge secrets if they exist
    if [ -f "$SECRETS_FILE" ]; then
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$OUTPUT.tmp" "$SECRETS_FILE" > "$OUTPUT"
      rm "$OUTPUT.tmp"
      echo "openclaw: config merged with secrets"
    else
      mv "$OUTPUT.tmp" "$OUTPUT"
      echo "openclaw: WARNING — no secrets.json found at $SECRETS_FILE"
      echo "openclaw: copy the example and fill in your keys:"
      echo "  cp ${secretsExample} $SECRETS_FILE"
    fi

    chmod 600 "$OUTPUT"
  '';
in
{
  # Ensure jq and nodejs are available
  home.packages = with pkgs; [
    jq
    nodejs
  ];

  # Deploy the secrets example for reference
  home.file.".openclaw/secrets.json.example".source = secretsExample;

  # Merge config on activation
  home.activation.openclawConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${mergeScript}
  '';

  # Systemd user service for openclaw gateway
  systemd.user.services.openclaw-gateway = {
    Unit = {
      Description = "OpenClaw Gateway";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      ExecStart = "${pkgs.nodejs}/bin/node /home/carter/.npm-global/lib/node_modules/openclaw/dist/index.js gateway --port 18789";
      Restart = "always";
      RestartSec = 5;
      KillMode = "process";
      Environment = [
        "PATH=/home/carter/.npm-global/bin:${pkgs.nodejs}/bin:/run/current-system/sw/bin:/usr/bin:/bin"
        "NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache"
        "OPENCLAW_NO_RESPAWN=1"
        "OPENCLAW_GATEWAY_PORT=18789"
        "OPENCLAW_SERVICE_MARKER=openclaw"
        "OPENCLAW_SERVICE_KIND=gateway"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

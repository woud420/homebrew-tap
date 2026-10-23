class Kickstart < Formula
  desc "Deterministic starter repos for humans and coding agents"
  homepage "https://kickstart-cli.org"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
    on_arm do
      url "https://github.com/woud420/kickstart/releases/download/v0.4.6/kickstart-macos-arm64-py3.14.tar.gz"
      sha256 "1f36fff1151cb7ca91ec1cf10c3cf1712a7d16ecf442c02c1cad20b598ece920"
    end
    # Keep metadata loadable on Intel so the architecture requirement explains the failure.
    on_intel do
      url "https://github.com/woud420/kickstart/releases/download/v0.4.6/kickstart-macos-arm64-py3.14.tar.gz"
      sha256 "1f36fff1151cb7ca91ec1cf10c3cf1712a7d16ecf442c02c1cad20b598ece920"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/woud420/kickstart/releases/download/v0.4.6/kickstart-linux-arm64-py3.14.tar.gz"
      sha256 "3fd66b83f4b0e69476d00c5d866380ff473dc06d41f1aa95009a3491f406c847"
    end
    on_intel do
      url "https://github.com/woud420/kickstart/releases/download/v0.4.6/kickstart-linux-x64-py3.14.tar.gz"
      sha256 "e619df8db0d2e52c848077073f0ddc039e136dd5c31789f68965280797666e33"
    end
  end

  def install
    libexec.install Dir["*"]
    # Older releases have no package-manager guard, so keep it in the launcher.
    (bin/"kickstart").write <<~SH
      #!/bin/sh
      command="${1-}"
      if [ "$command" = "--" ]; then command="${2-}"; fi
      case "$command" in
        install|upgrade|uninstall|_managed-layout-handoff)
          echo "Homebrew manages this installation. Use brew upgrade woud420/tap/kickstart or brew uninstall woud420/tap/kickstart." >&2
          exit 1
          ;;
      esac
      exec "#{libexec}/kickstart" "$@"
    SH
  end

  def caveats
    <<~EOS
      Homebrew owns this installation. Use brew upgrade and brew uninstall.
      Release builds enable pseudonymous usage telemetry by default.
      Run kickstart telemetry disable to opt out.
      Remove any older ~/.local/bin/kickstart launcher if it shadows this one.
    EOS
  end

  test do
    ENV["KICKSTART_TELEMETRY_DISABLED"] = "1"
    assert_match version.to_s, shell_output("#{bin}/kickstart version")
    system bin/"kickstart", "create", "lib", "brew-smoke", "--root", testpath, "--lang", "python"
    assert_path_exists testpath/"brew-smoke/.kickstart/scaffold.json"
    %w[install upgrade uninstall _managed-layout-handoff].each do |command|
      assert_match "Homebrew manages", shell_output("#{bin}/kickstart #{command} 2>&1", 1)
      assert_match "Homebrew manages", shell_output("#{bin}/kickstart -- #{command} 2>&1", 1)
    end
  end
end

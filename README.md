# woud420 Homebrew tap

Homebrew distribution for [kickstart](https://github.com/woud420/kickstart),
the deterministic repository scaffolding CLI.

```bash
brew install woud420/tap/kickstart
brew update
brew upgrade woud420/tap/kickstart
brew uninstall woud420/tap/kickstart
```

You can also add the tap explicitly with `brew tap woud420/tap`.

Supported targets: Apple Silicon on macOS 15+, and Linux x86_64/arm64 with
glibc 2.39+ (tested on Ubuntu 24.04). The formula uses tagged release binaries
and verifies SHA-256; Python and CLI dependencies are bundled. Intel macOS
and other platforms use kickstart's source/wheel installation instructions.

Use Homebrew to manage this installation. The public launcher rejects
`kickstart install`, `kickstart upgrade`, and `kickstart uninstall`, including
the internal upgrade handoff. The executable under `libexec` is internal;
invoke the public launcher. An older `~/.local/bin/kickstart` may shadow it:
remove that standalone installation before switching, and check
`command -v kickstart` afterward.

Release builds enable pseudonymous telemetry by default. Run
`kickstart telemetry disable` to opt out. Package smoke tests set
`KICKSTART_TELEMETRY_DISABLED=1`.

## Maintenance

The upstream release workflow generates the formula from all three release
archives and checksums, tests package installation, scaffolding, ownership
guards, upgrade from v0.4.5, and uninstall on each native target, then updates
`Formula/kickstart.rb`. It uses a dedicated token restricted to this repository
with Contents read/write. This tap's own CI verifies direct formula changes.

See the [upstream Homebrew runbook](https://github.com/woud420/kickstart/blob/master/docs/operations/homebrew.md)
for credential setup and manual recovery. The release integration is maintained
in the upstream repository.

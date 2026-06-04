# asdf-starship

[![Main workflow](https://github.com/gr1m0h/asdf-starship/actions/workflows/workflow.yaml/badge.svg)](https://github.com/gr1m0h/asdf-starship/actions/workflows/workflow.yaml)
[![Lint](https://github.com/gr1m0h/asdf-starship/actions/workflows/lint.yaml/badge.svg)](https://github.com/gr1m0h/asdf-starship/actions/workflows/lint.yaml)

[Starship](https://github.com/starship/starship) plugin for the [asdf](https://github.com/asdf-vm/asdf) version manager.

## Install

```shell
asdf plugin add starship https://github.com/gr1m0h/asdf-starship.git
```

## Usage

See the [asdf documentation](https://asdf-vm.com/manage/core.html) for the full
set of commands. The most common ones are:

```shell
# Show all installable versions
asdf list all starship

# Install a specific version
asdf install starship latest
asdf install starship 1.24.0

# Set a version globally (writes to ~/.tool-versions)
asdf set -u starship latest

# Set a version for the current project (writes to ./.tool-versions)
asdf set starship 1.24.0
```

Then add the init script to your shell's config file. See the
[Starship installation guide](https://starship.rs/guide/#%F0%9F%9A%80-installation)
for details.

## Contributing

Contributions are welcome! This plugin is linted with
[shellcheck](https://www.shellcheck.net/) and
[shfmt](https://github.com/mvdan/sh), and tested with
[asdf-vm/actions](https://github.com/asdf-vm/actions).

The required tooling versions are pinned in [`.tool-versions`](./.tool-versions),
so you can install them with asdf:

```shell
asdf install
```

```shell
# Format the shell scripts
./scripts/format.bash

# Lint the shell scripts
./scripts/lint.bash
```

## License

[MIT](./LICENSE)

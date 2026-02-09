# Python project builder

## Dependencies

Requires [uv](https://docs.astral.sh/uv/), [gum](https://github.com/charmbracelet/gum), [colima](https://github.com/abiosoft/colima) and [xc](https://xcfile.dev/).

Uses `uv` to set up the project, [https://www.toptal.com/developers/gitignore](https://www.toptal.com/developers/gitignore) 
to add a `.gitignore`, then adds additional files from the `template` directory using [copier](https://github.com/copier-org/copier).

```sh
brew install uv gum colima xc && brew upgrade uv gum colima xc
```

## Instructions

The `build.sh` script takes 2 arguments:

* Package name
* Package description

```sh
./build.sh "sausages" "Sausages thing" 
```

The user will be prompted if these are not provided.

# Python project builder

## Dependencies

Requires [uv](https://docs.astral.sh/uv/) and [xc](https://xcfile.dev/).

Uses `uv` to set up the project, [https://www.toptal.com/developers/gitignore](https://www.toptal.com/developers/gitignore) 
to add a `.gitignore`, then adds additional files from the `template` directory using [copier](https://github.com/copier-org/copier).

```sh
brew install uv xc && brew upgrade uv xc
```

## Instructions

The `build.sh` script takes 3 arguments:

* Package name
* Package description
* Template location
    * (This argument requires an absolute path. Tip - use `realpath` to get one.)

```sh
./build.sh "sausages" "Sausages thing" `realpath template`
```

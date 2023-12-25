[![marketplace](https://img.shields.io/badge/marketplace-rust--source--coverage-blue?logo=github)](https://github.com/marketplace/actions/rust-source-coverage)
[![CI](https://github.com/lpenz/ghaction-rust-coverage/actions/workflows/ci.yml/badge.svg)](https://github.com/lpenz/ghaction-rust-coverage/actions/workflows/ci.yml)
[![github](https://img.shields.io/github/v/release/lpenz/ghaction-rust-coverage?include_prereleases&label=release&logo=github)](https://github.com/lpenz/ghaction-rust-coverage/releases)
[![docker](https://img.shields.io/docker/v/lpenz/ghaction-rust-coverage?label=release&logo=docker&sort=semver)](https://hub.docker.com/repository/docker/lpenz/ghaction-rust-coverage)

# ghaction-rust-coverage

**ghaction-rust-coverage** is a docker github action that runs rust
tests with source-based coverage enabled. It's essentially a docker
container with nighly rust that runs *cargo test* as described in
[instrument-coverage](https://doc.rust-lang.org/nightly/unstable-book/compiler-flags/instrument-coverage.html).

We get a significant speed-up over other github actions due to the use
of the docker container.

Using source-based in rust has shown better coverage data in my
limited tests, specially when the code uses const generics.


## Usage

This is an example of how this action can be used to run the tests and
upload the results to [coveralls](https://coveralls.io/).

```yml
---
name: CI
on: [ push, pull_request ]
jobs:
  test-coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: docker://lpenz/ghaction-rust-coverage:0.14.0
      - uses: coverallsapp/github-action@v1.1.2
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          path-to-lcov: ./lcov.info
```


### Inputs

- `dependencies_debian`: Debian packages to install before running the tests.
- `working_directory`: `cd` to this directory before running the action.
- `output_type`: output type, one of `html`, `text`, `json` or `lcov`.
- `output_path`: output path.
- `test_args`: arguments to pass to the test - `--nocapture` for example.
- `doctest`: if `true` (the default) the documentation tests are also run.


If neither `output_type` and `output_path` are defined, the action by
default creates an lcov.info file in the current directory.

We are currently using
[cargo-llvm-cov](https://crates.io/crates/cargo-llvm-cov) internally,
more information about the arguments [here](https://crates.io/crates/cargo-llvm-cov).

## Alternatives

- [cargo-llvm-cov](https://crates.io/crates/cargo-llvm-cov) is what we
  use internally.
- [rust-tarpaulin](https://github.com/marketplace/actions/rust-tarpaulin)
- [rust-grcov](https://github.com/marketplace/actions/rust-grcov)
- [grcov-express](https://github.com/marketplace/actions/grcov-express):
  mostly equal to *rust-grcov* above, but using a docker container.


# wn

वन /ʋən/ (forest) of notes built with [Forester](https://www.forester-notes.org/index/).
Published at https://threewisemonkeys-as.github.io/wn/.

## Local use

We use our own forks of [Forester](https://github.com/threewisemonkeys-as/forester)
(branch `wn`) and its [base theme](https://github.com/threewisemonkeys-as/forester-base-theme)
(the `theme` submodule). The fork fixes `forester serve` (backlinks, table of
contents, numbering, search, transclusions) and opens edit links in Zed.

```sh
git clone --recurse-submodules git@github.com:threewisemonkeys-as/wn.git
opam pin add forester git+https://github.com/threewisemonkeys-as/forester.git#wn
forester new --prefix=wn --dest=trees   # create a new tree
forester build                          # output goes to output/wn
```

### Previewing

```sh
scripts/serve-local.sh            # forester serve at http://localhost:8080/
scripts/serve-local.sh --static   # the exact GitHub Pages build, served at http://localhost:8080/
```

Both restart or rebuild when trees, assets, the theme or `forest.local.toml`
change, and open pages reload themselves afterwards. Cmd/Ctrl+K searches trees, Cmd/Ctrl+E edits the current tree.

The built pages are XML styled by XSLT with site-absolute paths, so opening
the files in `output/` directly (`file://`) does not work: browsers refuse to
run XSLT on local files. Serve them over HTTP instead (`--static` does this).

### Private notes

Trees in `private/` are only built by the local preview (`forest.local.toml`).
The directory is gitignored, so they are never pushed or published. Create one
with `forester new --prefix=wn --dest=private`. Public trees must not link to or
transclude private ones, or the published build will fail.

Pushing to `main` rebuilds and deploys the site via GitHub Actions.

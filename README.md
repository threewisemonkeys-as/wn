# wn

A forest of evergreen notes built with [Forester](https://www.forester-notes.org/index/).
Published at https://threewisemonkeys-as.github.io/wn/.

## Local use

```sh
git clone --recurse-submodules git@github.com:threewisemonkeys-as/wn.git
opam install forester.5.0
forester new --prefix=wn --dest=trees   # create a new tree
forester build                          # output goes to output/wn
forester serve                          # preview locally
```

Pushing to `main` rebuilds and deploys the site via GitHub Actions.

Testing nix

```
nix --extra-experimental-features nix-command eval --impure --raw --expr 'with import <nixpkgs> {}; stdenv.cc.cc.lib'
```
Testing nix

```
find /nix/store/*emulator*/ -name 'emulator_main'
```

```
ldd /nix/store/pz5gz7b6hnrkyilakr4sbzclmhrlv1cf-spanner-emulator/bin/emulator_main
        linux-vdso.so.1 (0x00007ffcd0797000)
        libpthread.so.0 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libpthread.so.0 (0x00007f146b31b000)
        libm.so.6 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libm.so.6 (0x00007f146b23b000)
        libstdc++.so.6 => not found
        libgcc_s.so.1 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libgcc_s.so.1 (0x00007f146b221000)
        libc.so.6 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libc.so.6 (0x00007f146b018000)
        /lib64/ld-linux-x86-64.so.2 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib64/ld-linux-x86-64.so.2 (0x00007f146e5ae000)
```

```
nix --extra-experimental-features nix-command eval --impure --raw --expr 'with import <nixpkgs> {}; stdenv.cc.cc.lib'
```
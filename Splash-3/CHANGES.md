Change the top-level Makefile to have a new rule `riscv`.

The new rule builds all the targets with `CC` and `AR` set
to point to the `riscv` toolchain.

We modified the vendored dependencies `glibdumb` 
and `glibps` inside of `radiosity` to be built
and cleaned when the application is.

We finally modified the build of `libtiff` to 
be correctly cleaned and built when `volrend`
is built or cleaned.

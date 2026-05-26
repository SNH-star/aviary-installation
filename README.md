# aviary-installation

This repository serves as a fully worked (containerised) example for the
installation of the [Aviary software package](https://github.com/rhysnewell/aviary)
on a Linux system.

If you are simply attempting to install Aviary on your own system, you should
follow the instructions on the [Aviary website](https://github.com/rhysnewell/aviary).
Instructions there include installing Aviary via conda/mamba, pip, or via the
Docker image at `ghcr.io/snh-star/aviary`. Use those if the intention is to use
Aviary on your data.

The repository here is simply intended to show installation in a containerised
environment free from the Aviary authors' specific computing environment.

To process the example installation, after entering the repository directory,
run the following bash script replacing `RELEASE_VERSION` with the version of
Aviary you wish to install (e.g. 0.12.0):

This will build/download multiple containers and log the output to `*.build.log`
files. The build process will take some time, as it involves downloading and
compiling a number of dependencies. A small dataset is run through each as well
to ensure Aviary not just installs, but also runs.

​```bash
bash compile_and_test_install_methods.bash RELEASE_VERSION
​```

The `*.build.log` files created using this process are available in this
repository.


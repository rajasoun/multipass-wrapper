# multipass-wrapper
Bash Wrapper to Multipass

### Getting Started

Install [pipenv](https://pypi.org/project/pipenv/)
```sh
$ pip3 install pipenv --user
```


```sh
$ git clone https://github.com/rajasoun/multipass-wrapper
$ cd multipass-wrapper
$ pipenv shell
$ pipenv instal
$ pre-commit install
$ pre-commit run --all-files
```

### Wrapper Commands

```sh
$ ./assist setup
Usage: ./assist <command>
Commands:
---------
  setup  -> Setup VM
  up     -> Bring Up VM
  down   -> Bring Down VM
  shell  -> Enter Shell
  status -> Status of all multipass VMs
  clean  -> Clean & Destroy VM
```

# My dotfiles OSX/Linux

## Prerequisite(s)
### Apple

  * Install Apple's CLI tools

```sh
xcode-select --install;
```

### Linux

  * Install git & curl

`apt based distros:`

```sh 
sudo apt-get update;
sudo apt-get upgrade; 
sudo apt-get install git curl;
```

`RPM based distros:`

```sh
sudo yum install git curl;
```

## Caveats(s)
  * For macOS versions <= Catalina:
    * make sure the default shell is set to [`zsh`](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)(`echo $0`)
	  * `zsh` is shipped with Catalina by default
    * homebrew support for these versions is most likely unavailable
    * some packages may not work

## TODO(s)
[`setup.sh`](./setup.sh)
  * Create setup function for linux
  * Create symbolic link function to handle linking of multiple files/directories

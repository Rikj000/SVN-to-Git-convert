# SVN to Git convert

<p align="left">
    <a href="https://github.com/Rikj000/SVN-to-Git-convert/blob/development/LICENSE">
        <img src="https://img.shields.io/github/license/Rikj000/SVN-to-Git-convert?label=License&logo=gnu" alt="GNU General Public License">
    </a> <a href="https://github.com/Rikj000/SVN-to-Git-convert/releases">
        <img src="https://img.shields.io/github/downloads/Rikj000/SVN-to-Git-convert/total?label=Total%20Downloads&logo=github" alt="Total Releases Downloaded from GitHub">
    </a> <a href="https://github.com/Rikj000/SVN-to-Git-convert/releases/latest">
        <img src="https://img.shields.io/github/v/release/Rikj000/SVN-to-Git-convert?include_prereleases&label=Latest%20Release&logo=github" alt="Latest Official Release on GitHub">
    </a> <a href="https://www.iconomi.com/register?ref=zQQPK">
        <img src="https://img.shields.io/badge/ICONOMI-Join-blue?logo=bitcoin&logoColor=white" alt="ICONOMI - The world’s largest crypto strategy provider">
    </a> <a href="https://www.buymeacoffee.com/Rikj000">
        <img src="https://img.shields.io/badge/-Buy%20me%20a%20Coffee!-FFDD00?logo=buy-me-a-coffee&logoColor=black" alt="Buy me a Coffee as a way to sponsor this project!"> 
    </a>
</p>

**Archived** - Superseded by [Rikj000/Ruby-SVN2Git-Docker](https://github.com/Rikj000/Ruby-SVN2Git-Docker)

Simple [Bash](https://www.gnu.org/software/bash/bash.html) script to convert local [SVN (Subversion)](https://subversion.apache.org/) repositories to local [Git](https://git-scm.com/) repositories!

## Dependencies
- [bash](https://archlinux.org/packages/core/x86_64/bash/)
- [coreutils](https://archlinux.org/packages/core/x86_64/coreutils/)
- [subversion](https://archlinux.org/packages/extra/x86_64/subversion/)
- [git](https://archlinux.org/packages/extra/x86_64/git/)
- [git-lfs](https://archlinux.org/packages/extra/x86_64/git-lfs/)

## Installation
1. Create a permanent installation location:
    ```bash
    mkdir -p ~/Documents/Program-Files/;
    ```
2. Clone the [`svn-to-git-convert`](https://github.com/Rikj000/SVN-to-Git-convert) repo locally to the permanent installation location:
    ```bash
    git clone https://github.com/Rikj000/SVN-to-Git-convert.git ~/Documents/Program-Files/SVN-to-Git-convert;
    ```
3. Setup a system link for easy CLI usage:
    ```bash
    sudo ln -s ~/Documents/Program-Files/SVN-to-Git-convert/svn-to-git-convert.sh /usr/bin/svn-to-git-convert;
    ```
4. Checkout the latest release tag:
    ```bash
    svn-to-git-convert -update;
    ```

## Usage
Following is the output of `svn-to-git-convert -h`:
```bash
SVN-to-Git-convert - v1.0.0
Simple "bash" script to convert local SVN (Subversion) repositories to local Git repositories!

Usage:
  svn-to-git-convert [options]

Example:
  svn-to-git-convert -s="/path/to/svn/input/repo" -g="/path/to/git/output/repo"

Optional options:
  -h, -help                   Show this help.
  -u, -update                 Update SVN-to-Git-convert to the latest version.
  -s, -svn_input_dir=<path>   Path to local input SVN repository, defaults to current working directory.
  -g, -git_output_dir=<path>  Path to local output Git repository, defaults to "output" folder above current working directory.
```

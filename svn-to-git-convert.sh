#!/bin/bash
# Author: Rikj000

# Help function
usage() {
    cat << EOF

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
EOF

    exit 0;
}

# Update function
update() {
    echo "Setting up installation directory helpers...";
    INSTALLATION_FILE=$(realpath "$(dirname "$0")/$(basename "$0")");
    INSTALLATION_DIR=$(dirname "$INSTALLATION_FILE");

    echo "Moving to the installation directory... ($INSTALLATION_DIR)";
    cd "$INSTALLATION_DIR/";

    echo "Pulling + switching to latest version...";
    git pull;
    git checkout $(git tag -l | tail -n 1);
    exit;
}

# ANSI text coloring
GREEN='\033[0;32m';
RED='\033[0;31m';
END='\033[m';

# Initialize default input/output directory values
SVN_INPUT_DIR=$(pwd);
GIT_OUTPUT_DIR="$SVN_INPUT_DIR/../output";

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -s=*|-svn_input_dir=*)
        SVN_INPUT_DIR="${arg#*=}";
        shift
        ;;
        -g=*|-git_output_dir=*)
        GIT_OUTPUT_DIR="${arg#*=}";
        shift
        ;;
        -h|-help)
        usage;
        shift
        ;;
        -u|-update)
        update;
        shift
        ;;
        *)
        echo "";
        echo -e "${RED}  🙉  svn-to-git-convert - Illegal argument(s) used!${END}";
        echo "";
        echo "  Please see the 'svn-to-git-convert -help' output below for the correct usage:";
        usage;
        shift # Remove generic argument from processing
        ;;
    esac
done

# SVN to Git convert logic
echo "Setting up SVN + Git migration directory helpers...";
SVN_MIGRATION_DIR='/tmp/svn-migration';
SVN_REPO_DIR="$SVN_MIGRATION_DIR/repo";
SVN_CHECKOUT_DIR="$SVN_MIGRATION_DIR/checkout";

GIT_MIGRATION_DIR='/tmp/git-migration';
GIT_REPO_DIR="$GIT_MIGRATION_DIR/repo";

echo "Creating temporary migration directories...";
mkdir "$SVN_MIGRATION_DIR" "$GIT_MIGRATION_DIR";

echo "Copying the input SVN repository to the migration directory...";
cp -r "$SVN_INPUT_DIR" "$SVN_REPO_DIR";

echo "Checking out the SVN repository at the latest revision... (takes a while)";
svn checkout \
    "file://$SVN_REPO_DIR/@HEAD" \
    "$SVN_CHECKOUT_DIR/";

echo "Moving to the SVN checkout folder...";
cd "$SVN_CHECKOUT_DIR/";

echo "Querying SVN checkout version history for 'authors-file.txt'...";
svn log -q | \
awk -F '|' '/^r/ {gsub(/ /, "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | \
sort -u > "$GIT_MIGRATION_DIR/authors-file.txt";

echo "Moving to the Git migration folder...";
cd "$GIT_MIGRATION_DIR/";

echo "Converting the SVN repository to a Git repository... (takes a while)";
git svn clone \
    "file://$SVN_REPO_DIR/" \
    "$GIT_REPO_DIR" \
    --authors-file="$GIT_MIGRATION_DIR/authors-file.txt" \
    --revision 1:HEAD;

echo "Moving to the new Git repo folder...";
cd "$GIT_REPO_DIR/";

echo "Moving the tags and any remote refs to local branches...";
for t in $(git for-each-ref --format='%(refname:short)' refs/remotes/tags);
    do git tag ${t/tags\//} $t && git branch -D -r $t;
done;

echo "Moving any references under refs/remote and turn them to local branches...";
for b in $(git for-each-ref --format='%(refname:short)' refs/remotes);
    do git branch $b refs/remotes/$b && git branch -D -r $b;
done;

for p in $(git for-each-ref --format='%(refname:short)' | grep @);
    do git branch -D $p;
done;

echo "Removing the temporary migration branch...";
git branch -D git-svn;

echo "Converting any large files to LFS objects...";
git lfs migrate import --everything --above=99MB --yes;

echo "Copying the output Git repository to the output Git directory...";
cp -r "$GIT_REPO_DIR" "$GIT_OUTPUT_DIR";

echo "Cleaning up temporary migration directories...";
yes | rm -r "$SVN_MIGRATION_DIR" "$GIT_MIGRATION_DIR";

echo -e "${GREEN}svn-to-git-convert has been executed to its end!${CLOSE}";

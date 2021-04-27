#!/bin/bash

REPO="https://github.com/benjamin-feron/printeRAcK.git"
GH_PAGES_BRANCH="main"
GH_PAGES_PATH="docs"

show_help () {
  echo "Usage: create-readme-from-gh-pages.sh [OPTIONS] DEST_FILE

  Options:
    -h,--help    Show help"
}

while :; do
  case $1 in
	-h|--help)
	  show_help
  	  exit
	  ;;
	-?*)
	  printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
	  ;;
	*)
	  break
  esac
  shift
done

DEST_FILE="$1"
shift

# Check arguments
if [ -z "$DEST_FILE" ]; then
  printf 'Please specify destination file\n\n'
  show_help
  exit 1
fi

# If DEST_FILE is relative, convert to absolute
if [ "$DEST_FILE" == "${DEST_FILE#/}" ]; then
  DEST_FILE="$(pwd)/$DEST_FILE"
fi

tmp_dir=$(mktemp -d -t pr-XXXXXXXXXX)

cd "$tmp_dir"

git clone -q "$REPO" .
git checkout -q "$GH_PAGES_BRANCH"

cat "$GH_PAGES_PATH/index.md" | sed "s~assets/~docs/assets/~g" > "$DEST_FILE"

rm -Rf "$tmp_dir"

#!/bin/bash

# my script for converting a folder of dot files from gstreamer to png or pdf
# requirement: sudo apt install graphviz
# recommended extension for vscode: vscode-pdf

# input args
DOTFOLDER=${1}
PNG_OR_PDF=${2:-pdf}

# convert to lowercase if not already
FORMAT=`echo $PNG_OR_PDF | awk '{print tolower($0)}'`

# print out for help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Script for converting a folder of dot files from gstreamer to png or pdf"
  echo "  also can handle a single dot file to png or pdf."
  echo "Requires graphviz package (sudo apt install graphviz) "
  echo "Recommended extension for vscode: vscode-pdf"
  echo ""
  echo "Usage: dot2graph [DOTFOLDER] [PNG_OR_PDF]"
  echo "  DOTFOLDER: the folder with dot files that you want to convert"
  echo "  PNG_OR_PDF: what file format to convert the dot file graphs to. default is pdf"
  exit 0
fi

# check if file format argument is valid
if [ $FORMAT != "png" ] && [ $FORMAT != "pdf" ]; then 
  echo "2nd arg PNG_OR_PDF must be \"png\" or \"pdf\""
fi

function dotfile2graph() {
  local dotfile=$1
  local basedir=`dirname $dotfile`
  local newname=`basename $dotfile | awk -F "." '{print $(NF-1)}'`.$FORMAT
  local newpath=$basedir/$newname
  echo "generating graph: $newpath"
  dot -T$FORMAT $dotfile > $newpath
}


# check if file or directory
if [[ -d $DOTFOLDER ]]; then
    echo "$DOTFOLDER is a directory"

    # check if dot folder has dot files
    shopt -s nullglob
    function have_any() {
        [ $# -gt 0 ]
    }
    if ! have_any $DOTFOLDER/*.dot; then 
      echo "no dot files found in $DOTFOLDER"
      exit
    fi 

    # generate graphs in dotfile folder
    for dotfile in $DOTFOLDER/*.dot; do
      dotfile2graph $dotfile
    done

    # move dot files into subfolder
    mkdir -p $DOTFOLDER/dotfiles
    mv $DOTFOLDER/*.dot $DOTFOLDER/dotfiles/

elif [[ -f $DOTFOLDER ]]; then
  echo "$DOTFOLDER is a file"
  dotfile=$DOTFOLDER
    
  # check if extension is .dot
  file_ext=`echo $dotfile | awk -F "." '{print $NF}'`
  if ! [ $file_ext == dot ]; then
    echo "$dotfile is not a dot file. exiting..."
    exit
  fi

  # perform conversion
  dotfile2graph $dotfile
    
else
    echo "$DOTFOLDER is not valid"
    exit 1
fi
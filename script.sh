#!/bin/bash

# (generated by Structorizer 3.32-11)

# TODO: Check and revise the syntax of all expressions!

while :
do
 echo "Display Menu"
 echo "[1] Create File"
 echo "[2] Edit File"
 echo "[3] Rename File"
 echo "[4] Delete File"
 echo "[5] List Files"
 echo "[6] Change Directory"
 echo "[7] Zip File"
 echo "[8] Unzip File"
 echo "[9] Exit Script"
 read choice

 case ${choice} in

  1)
    echo "Create File"
    echo "Enter the Filepath"
    read String filename
    echo "Created new File"
  ;;

  2)
    echo "Edit File"
    echo "Enter the Filepath"
    read String filename
    echo "Open File"
  ;;

  3)
    echo "Rename File"
    echo "Enter the old Filepath"
    read String oldFIlePath
    echo "Enter the new Filepath"
    read String newFilePath
    echo "Moved File"
  ;;

  4)
    echo "Delete File"
    echo "Enter the Filepath"
    read String filepath
    echo "Deleted File"
  ;;

  5)
    echo "List Files"
    echo "Listed Files"
  ;;

  6)
    echo "Change Directory"
    echo "Enter the new Directorypath"
    read String newDirectoryPath
    echo "Changed Directory"
  ;;

  7)
    echo "Zip File"
    echo "Enter path to file that needs to be zipped"
    read String filepath
    echo "File zipped"
  ;;

  8)
    echo "Unzip File"
    echo "Enter path to zip"
    read String filepath
    echo "File unzipped"
  ;;

  9)
    echo "Exit Script"
    echo "Script exitted"
  ;;

  *)
   echo "Please Input a valid option"
  ;;
 esac

done
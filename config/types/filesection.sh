action=$1
targetfile=$2
sourcefile=$3
shift 3

start=$(arguments get start $*)
end=$(arguments get end $*)
ifmissing=$(arguments get ifmissing $*)

file_varname="borkfiles__$(echo "$sourcefile" | base64 | sed -E 's|\+|_|' | sed -E 's|\?|__|' | sed -E 's|=+||')"

case $action in
  desc)
    echo "replaces a section of a file with the source file"
    echo "* filesection target-path source-path [arguments]"
    echo "--start='# Managed, DO NOT EDIT'    line to start with"
    echo "--end='# End Managed'               line to end with"
    echo "--ifmissing=append|prepend|nothing  if section is missing, do this"
    ;;
  status)
    if ! is_compiled && [ ! -f $sourcefile ]; then
      echo "source file doesn't exist: $sourcefile"
      return $STATUS_FAILED_ARGUMENTS
    fi

    bake [ -f $targetfile ] || return $STATUS_MISSING

    # TODO: need to distinguish local platfrom from target platform
    if is_compiled; then
      sourcecontents=$(echo "${!file_varname}" | base64 --decode)
    else
      sourcecontents=$(cat $sourcefile)
    fi
    targetcontents=$(bake sed -n -e '/^'"$start"'$/,/^'"$end"'$/{ /^'"$start"'$/d; /^'"$end"'$/d; p; }' $targetfile)
    if [ "$targetcontents" != "$sourcecontents" ]; then
      echo "expected: $sourcecontents"
      echo "received: $targetcontents"
      return $STATUS_CONFLICT_UPGRADE
    fi

    return 0
    ;;

  install|upgrade)
    if is_compiled; then
      sourcecontents=$(echo "${!file_varname}" | base64 --decode)
    else
      sourcecontents=$(cat $sourcefile)
    fi
    bake sed -n -e "
      /^$start\$/,/^$end\$/{
        /^$start\$/{
          r "<(echo -n "$sourcecontents")"
          b a
        }
        /^$end\$/b a
        d
        :a
      }
      p
    " --in-place $targetfile
    return 0
    ;;

  compile)
    if [ ! -f "$sourcefile" ]; then
      echo "fatal: file '$sourcefile' does not exist!" 1>&2
      exit 1
    fi
    if [ ! -r "$sourcefile" ]; then
      echo "fatal: you do not have read permission for file '$sourcefile'"
      exit 1
    fi
    echo "# source: $sourcefile"
    echo "# md5 sum: $(eval $(md5cmd $platform $sourcefile))"
    echo "$file_varname=\"$(cat $sourcefile | base64)\""
    ;;

  *) return 1 ;;
esac
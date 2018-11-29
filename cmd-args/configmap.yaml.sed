kind: ConfigMap
apiVersion: v1
metadata:
  name: {{.name}}-config 
  namespace: {{.namespace}}
  labels:
    {{.labels.key}}: {{.labels.value}}
data:
  mv.file.sh: |-
    #!/bin/bash
    set -e
    show_help () {
    cat << USAGE
    usage: $0 [ -F SOURCE-PATH ] [ -T DESTINATION-PATH ] 
           [ -c CLEARANCE-OR-NOT ]
        -f : Specify the source path.
        -t : Specify the destination path.
    USAGE
    exit 0
    }
    # Get Opts
    while getopts "hf:t:" opt; do # 选项后面的冒号表示该选项需要参数
        case "$opt" in
        h)  show_help
            ;;
        f)  FROM=$OPTARG
            ;;
        t)  TO=$OPTARG
            ;;
        ?)  # 当有不认识的选项的时候arg为?
            echo "unkonw argument"
            exit 1
            ;;
        esac
    done
    [[ -z $* ]] && show_help
    chk_var () {
    if [ -z "$2" ]; then
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
      sleep 3
      exit 1
    fi
    }
    chk_var -f $FROM
    chk_var -t $TO
    FILES=$(ls ${TO})
    if [[ -z ${FILES} ]]; then
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [WARN] - no files in ${TO}."
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - cp files from ${FROM} to ${TO}.."
      cp -rf ${FROM}/. ${TO}
    else
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - files found in ${TO}, skip."
    fi
    exit 0

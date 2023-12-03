#!/usr/bin/env bash
#/**
# * @link      https://github.com/NRZCode/ProgressBar
# * @license   https://www.gnu.org/licenses/gpl-3.0.txt GNU GENERAL PUBLIC LICENSE
# * @author    NRZ Code <nrzcode@protonmail.com>
# */
version=0.0.1
usage() {
  printf "${*:+$*\n}  %s\n%22s%s\n" \
    'Usage: ProgressBar.sh [-i|--initial NUM] [-m|--message MESSAGE] [-p|--pid PID] [-s|--speed SPEED]' \
    '' '[-t|--total NUM] [-w|--width NUM]'
  cat <<EOM
Options:
  General Options:
    -i, --initial       Initial value percentage
                        (default: 0)
    -h, --help          Print this help text and exit
    -m, --message       Set initial progress text message
                        (default: Progress)
    -p, --pid           Monitora a execução do processo do pid passado encerrando
                        a barra de progresso junto com o encerramento do processo
    -s, --speed         Speed bar progress incremental value.
                        accepts one of values [fast|normal|slow|slowest|zero]
                        (default: slow)
    -t, --total         Total value percentage
                        (default: 100)
    -w, --width         Set progressbar's width
EOM
}

ProgressBar.init() {
  in_array() {
    local needle haystack
    printf -v haystack '%s|' "${@:2}"
    [[ $1 == @(${haystack%|}) ]]
  }

  check_arg_type() {
    # valor de um parâmetro (arg: 3) não pode começar com - 'hifen'
    if [[ -z $3 || "$3" =~ ^- ]]; then
      echo "Opção $2 requer parâmetro." >&2
      return 1
    fi
    case $1 in
      bool) re='^(on|off|true|false|1|0)$';;
      string) re='^[[:print:]]+$';;
      int) re='^[-+]?[[:digit:]]+$';;
      float) re='^[-+]?[0-9]+([.,][0-9]+)?$';;
    esac
    [[ ${3,,} =~ $re ]]
  }

  cleanup() {
    printf '\r\e[KConcluído [100%%]'
    tput cnorm
    rm -fr $tmp
  }
  trap cleanup EXIT INT KILL

  read_stdin() {
    read -t .001
    [[ $? == 1 ]] && return 1
    [[ $REPLY ]] && ProgressBar.setProgress "$REPLY"
    return 0
  }

  ##
  # ProgressBar
  #
  # Progress: [ 67%] [#####################................] [ETA 2m37s]
  #
  ProgressBar.print() {
    local partial=$1 \
          total=${2:-100} \
          msg=${3:-Progress} \
          cols offset p percento pad bar_on bar_off

    cols=${width:-$COLUMNS}
    p=$((partial*100/total))
    percento=$((p > 100 ? 100 : p))
    offset=$((cols-${#msg}-11))

    printf -v pad '%*s' $((percento*offset/100))
    bar_on=${pad// /$bar_char_on}
    printf -v pad '%*s' $((offset-${#bar_on}))
    bar_off=${pad// /$bar_char_off}

    printf "$bar_format\r" "$msg" $percento $bar_on $bar_off
  }

  ProgressBar.run() {
    local msg
    declare -i nivel=${initial:-0}
    pidmain=${pidmain:-$!}
    pidmain=${pidmain:-1}
    total=${total:-100}
    forward=${forward:-$forward_default}
    tput civis
    while ps -p $pidmain > /dev/null; do
      if [[ $forward != 'zero' ]]; then
        nivel=$((++i % forward ? nivel : nivel+1))
      fi

      read_stdin || break
      read -t .001 -u $fdprogress str
      if [[ ${str%% *} =~ ^[0-9]+$ ]]; then
        nivel=${str%% *}
        str="${str#* }"
      fi
      msg="${str:-$msg}"

      ProgressBar.print "$nivel" "$total" "$msg"
    done
  }

  ProgressBar.setProgress() {
    [ $# -gt 0 ] && echo $@ >&${fdprogress}
  }
  export -f ProgressBar.setProgress

  shopt -s extglob
  tmp=$(mktemp -d)
  pipeprogress=$(mktemp -u --tmpdir=$tmp)
  mkfifo $pipeprogress
  exec {fdprogress}<>$pipeprogress
  export fdprogress

  bar_char_on='#'
  bar_char_off='.'
  bar_text_fgcolor='\e[30m'
  bar_text_bgcolor='\e[42m'
  bar_progress_fgcolor='\e[1;37m'
  bar_progress_bgcolor=''
  color_reset='\e[m'
  bar_format="${bar_text_fgcolor}${bar_text_bgcolor}%s: [%3d%%]${color_reset} ${bar_progress_fgcolor}${bar_progress_bgcolor}[%s%s]${color_reset}"
  forward_default=1000
  declare -A speed=(
    [fast]=20
    [normal]=200
    [slow]=1000
    [slowest]=2000
    [zero]=zero
  )
  while [[ $1 ]]; do
    case $1 in
      -i|--initial)
        check_arg_type string $1 $2 || { usage; return 1; }
        initial=$2
        shift 2
        ;;
      -h|--help|help|-\?)
        usage; return;
        ;;
      -m|--message)
        ProgressBar.setProgress "$2"
        shift 2
        ;;
      -p|--pid)
        pidmain=$OPTARG
        ;;
      -s|--speed)
        check_arg_type string $1 $2 || { usage; return 1; }
        if in_array $2 ${!speed[@]}; then
          forward=${speed[$2]}
        fi
        shift 2
        ;;
      -t|--total)
        check_arg_type string $1 $2 || { usage; return 1; }
        total=$2
        shift 2
        ;;
      -w|--width)
        width=$2
        shift 2
        ;;
      -z)
        forward=zero
        shift
        ;;
      *)
        if [[ $1 =~ ^- ]]; then
          ProgressBar.usage "Opção $1 desconhecida (?)"; return 1;
        fi
        args[${#args[@]}]=$1
        shift
    esac
  done
  if [ ${#args[@]} -gt 0 ]; then
    if [ -f "$args" ]; then
      bash "$args" &>${fdprogress} &
    else
      bash -c "${args[*]}" &>${fdprogress} &
    fi
  fi
}

ProgressBar.main() {
  ProgressBar.init "$@"
  ProgressBar.run
}

script=$(realpath $BASH_SOURCE)
dirname=${script%/*}
[ -r "$dirname/.env" ] && source "$dirname/.env"
[ -r "$HOME/.progressbarrc" ] && source "$HOME/.progressbarrc"
[[ $BASH_SOURCE == $0 ]] && ProgressBar.main "$@"

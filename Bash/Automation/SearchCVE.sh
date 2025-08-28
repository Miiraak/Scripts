#!/bin/bash

########################################################################################
#                                                                                      |
#                 ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                |
#                ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                 |
#                ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                 |
#                ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                 |
#                ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                |
#                ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                |
#                ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                |
#                ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                 |
#                       ░    ░   ░     ░           ░  ░     ░  ░░  ░                   |
#                                                                                      |
#     Title        : SearchCVE.sh                                                      |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/Bash/Automation/   |
#     Version      : 2.1                                                               |
#     Category     : Automation                                                        |
#     Target       : None                                                              |
#     Description  : Automated multi CVE search in Metasploit                          |
#                                                                                      |
########################################################################################

show_help() {
    cat << EOF
Usage: $0 [-f <cve_list.txt>] [-t <N>] <CVE-ID>
Options:
  -f <file>    : File containing a list of CVEs, one per line.
  -t <N>       : Number of parallel searches (default: 1).
  -h           : Show this help message.
  <CVE-ID>     : Search for a single CVE provided as argument (e.g., CVE-2022-41741).
Examples:
  $0 -f cve_list.txt             # Search all CVEs in the file
  $0 CVE-2022-41741              # Search for a specific CVE
  $0 -f cve_list.txt -t 5        # Search all CVEs in the file with 5 parallel tasks
EOF
}

# Check for msfconsole
if ! command -v msfconsole >/dev/null 2>&1; then
    echo "[ERROR] Metasploit msfconsole is not installed or not detected."
    exit 1
fi

# Default values
file=""
threads=1
declare -a cves

# Parse arguments
while getopts ":f:t:h" opt; do
    case $opt in
        f) file="$OPTARG";;
        t) threads="$OPTARG";;
        h) show_help; exit 0;;
        \?) echo "[ERROR] Unknown option: -$OPTARG"; show_help; exit 1;;
        :) echo "[ERROR] Option -$OPTARG requires an argument."; show_help; exit 1;;
    esac
done
shift $((OPTIND -1))

# Get CVEs
if [ -n "$file" ]; then
    if [ ! -f "$file" ]; then
        echo "[ERROR] File '$file' not found."
        exit 1
    fi
    mapfile -t cves < "$file"
elif [ $# -gt 0 ]; then
    cves=("$@")
else
    echo "[ERROR] No CVE specified."
    show_help
    exit 1
fi

if ! [[ "$threads" =~ ^[0-9]+$ ]] || [ "$threads" -lt 1 ]; then
    echo "[ERROR] The number of parallel tasks (-t) must be a positive integer."
    exit 1
fi

# Progress bar function
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percent=$((100 * current / total))
    local done=$((width * current / total))
    local left=$((width - done))
    printf "\r["
    for ((i=0; i<done; i++)); do printf "#"; done
    for ((i=0; i<left; i++)); do printf "-"; done
    printf "] %d/%d (%d%%) CVEs searched..." "$current" "$total" "$percent"
}

# Search function (writes result to tmp file, then increments counter)
search_cve() {
    local cve="$1"
    local tmpdir="$2"
    local counterfile="$3"
    local total="$4"
    echo -e "\n========== $cve ==========" > "$tmpdir/$cve.out"
    msfconsole -q -x "search $cve; exit" >> "$tmpdir/$cve.out" 2>&1
    echo -e "------------------------------" >> "$tmpdir/$cve.out"
    # Atomically increment counter
    (
        flock -x 200
        local count=$(cat "$counterfile")
        count=$((count + 1))
        echo "$count" > "$counterfile"
        progress_bar "$count" "$total"
    ) 200>"$counterfile.lock"
}

export -f search_cve
export -f progress_bar

if [ "$threads" -eq 1 ]; then
    total=${#cves[@]}
    counter=0
    for cve in "${cves[@]}"; do
        search_cve "$cve" "/tmp" "/tmp/SearchCVE_counter" "$total"
        counter=$((counter + 1))
        progress_bar "$counter" "$total"
        echo
        cat "/tmp/$cve.out"
        rm "/tmp/$cve.out"
    done
else
    tmpdir=$(mktemp -d)
    counterfile="$tmpdir/counter"
    echo 0 > "$counterfile"
    total=${#cves[@]}
    export tmpdir
    export counterfile
    export total
    progress_bar 0 "$total"
    # Launch searches in parallel
    printf "%s\n" "${cves[@]}" | xargs -P"$threads" -I{} bash -c 'search_cve "$1" "$tmpdir" "$counterfile" "$total"' _ {}
    echo 
    for cve in "${cves[@]}"; do
        cat "$tmpdir/$cve.out"
        rm "$tmpdir/$cve.out"
    done
    rm -r "$tmpdir"
fi

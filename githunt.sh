githunt() {
    # Color definitions (prefixed for clarity)
    local COLOR_RED='\033[0;31m' COLOR_GREEN='\033[0;32m' COLOR_YELLOW='\033[0;33m'
    local COLOR_CYAN='\033[0;36m' COLOR_BLUE='\033[0;34m' COLOR_RESET='\033[0m'

    # Show usage with formatted documentation
    if [ $# -ne 2 ] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo -e "${COLOR_CYAN}Locate file versions across ${COLOR_RED}all branches/tags${COLOR_CYAN} using MD5 hash${COLOR_RESET}"
        echo -e "${COLOR_CYAN}Usage:   ${COLOR_GREEN}${FUNCNAME[0]} <file-path> <target-md5>"
        echo -e "${COLOR_CYAN}Example: ${COLOR_GREEN}${FUNCNAME[0]} config.yml d41d8cd98f00b204e9800998ecf8427e${COLOR_RESET}"
        return 1
    fi

    local file_path="$1" target_hash="$2"
    local commit_data matching_commit newer_commit

    # Validate file existence in repository
    if ! git show HEAD:"$file_path" >/dev/null 2>&1; then
        echo -e "${COLOR_RED}Error: File '${COLOR_YELLOW}${file_path}${COLOR_RED}' not found in repository${COLOR_RESET}" >&2
        return 1
    fi

    # Generate commit timeline with hashes (oldest to newest)
    echo -e "${COLOR_CYAN}Searching ${COLOR_RED}all branches/tags${COLOR_CYAN} for:"
    echo -e "File:   ${COLOR_YELLOW}${file_path}"
    echo -e "${COLOR_CYAN}Target: ${COLOR_GREEN}${target_hash}${COLOR_RESET}"

    commit_data=$(git log --all --reverse --pretty=format:%H -- "$file_path" | while read -r commit; do
        echo "$commit $(git show "$commit":"$file_path" | md5sum | awk '{print $1}')"
    done)

    # Extract matching commit and subsequent version
    read -r matching_commit newer_commit <<< $(echo "$commit_data" | awk -v target="$target_hash" '
        BEGIN { found = 0 }
        $2 == target {
            matching_commit = $1
            found = 1
            next
        }
        found && !processed {
            print matching_commit, $1
            processed = 1
            exit
        }
        { prev_commit = $1 }
        END { if (found && !processed) print matching_commit, "" }
    ')

    # Display results with clear formatting
    echo -e "${COLOR_CYAN}----------------------------------------${COLOR_RESET}"

    if [ -n "$matching_commit" ]; then
        # Format version information
        local version_info=$(git describe --tags "$matching_commit" 2>/dev/null || echo -e "${COLOR_BLUE}untagged${COLOR_RESET}")
        echo -e "Current version: ${COLOR_YELLOW}${matching_commit}${COLOR_RESET} (${COLOR_GREEN}${version_info}${COLOR_RESET})"

        # Show next version if available
        if [ -n "$newer_commit" ]; then
            local next_version=$(git describe --tags "$newer_commit" 2>/dev/null || echo -e "${COLOR_BLUE}untagged${COLOR_RESET}")
            echo -e "   Next version: ${COLOR_YELLOW}${newer_commit}${COLOR_RESET} (${COLOR_GREEN}${next_version}${COLOR_RESET})"
        else
            echo -e "${COLOR_RED}⚠ No newer versions found in any branch${COLOR_RESET}"
        fi
    else
        echo -e "${COLOR_RED}No matching versions found${COLOR_RESET}"
        return 1
    fi
}
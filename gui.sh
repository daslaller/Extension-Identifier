#!/bin/bash

# ANSI color codes
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to display the ASCII art
display_ascii_art() {
    echo -e "${PURPLE}"
    cat << "EOF"
 __  __       _     _ _ __  __    _____ _                   _                   
|  \/  |     | |   (_) |  \/  |  / ____(_)                 | |                  
| \  / | ___ | |__  _| | \  / | | (___  _  __ _ _ __   __ _| |_ _   _ _ __ ___  
| |\/| |/ _ \| '_ \| | | |\/| |  \___ \| |/ _` | '_ \ / _` | __| | | | '__/ _ \ 
| |  | | (_) | |_) | | | |  | |  ____) | | (_| | | | | (_| | |_| |_| | | |  __/ 
|_|  |_|\___/|_.__/|_|_|_|  |_| |_____/|_|\__, |_| |_|\__,_|\__|\__,_|_|  \___| 
                                           __/ |                                
                                          |___/                                 
   _____                      _               
  / ____|                    | |              
 | (___   ___  __ _ _ __ ___| |__   ___ _ __ 
  \___ \ / _ \/ _` | '__/ __| '_ \ / _ \ '__|
  ____) |  __/ (_| | | | (__| | | |  __/ |   
 |_____/ \___|\__,_|_|  \___|_| |_|\___|_|   
EOF
    echo -e "${NC}"
}

# Function to display the menu
display_menu() {
    echo -e "${BLUE}Choose a file identification method:${NC}"
    echo -e "${BLUE}1. Signature-based Identification${NC}"
    echo -e "${BLUE}2. File Command-based Identification${NC}"
    echo -e "${BLUE}3. Quit${NC}"
    echo
    echo -e "${BLUE}Enter your choice (1-3):${NC}"
}

# Function to run a script
run_script() {
    local script_name=$1
    local script_path="$(dirname "$0")/$script_name"

    if [ ! -f "$script_path" ]; then
        echo -e "${PURPLE}Error: Script $script_name not found!${NC}"
        return 1
    fi

    chmod +x "$script_path"
    echo -e "${BLUE}Running $script_name...${NC}"
    echo

    bash "$script_path"

    echo
    echo -e "${GREEN}Script execution completed.${NC}"
    echo -e "${BLUE}Press Enter to continue...${NC}"
    read -r
}

# Main loop
while true; do
    clear
    display_ascii_art
    display_menu

    read -r choice

    case $choice in
        1)
            run_script "identify_files_signatures.sh"
            ;;
        2)
            run_script "identify_files_command.sh"
            ;;
        3)
            echo -e "${PURPLE}Thank you for using MobilX Signature Searcher. Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${PURPLE}Invalid choice. Please try again.${NC}"
            echo -e "${BLUE}Press Enter to continue...${NC}"
            read -r
            ;;
    esac
done
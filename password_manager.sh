#!/bin/bash

# ------------------------------------------------------------
# password_manager.sh
# Main entry point for the Bash Password Manager.
# Loads all modules, parses CLI arguments, initializes the
# master password, and displays the interactive menu.
# ------------------------------------------------------------

VERSION="1.0.0"
DEBUG=false
SHOW_BANNER=true

# Load supporting modules
source src/initialize.sh
source src/passwords.sh
source src/utils.sh

# ------------------------------------------------------------
# parse_arguments()
# Handles command-line flags:
#   --help        Show usage info
#   --version     Show version
#   --debug       Enable debug mode
#   --no-banner   Disable banner display
#   --reset       Clear all data and exit
# ------------------------------------------------------------
parse_arguments() {
    while [[ $# -gt 0 ]]; do

            --help)
                echo "Usage: ./password_manager.sh [options]"
                echo ""
                echo "Options:"
                echo "  --help         Show this help message and exit"
                echo "  --version      Show version information and exit"
                echo "  --debug        Enable debug mode"
                echo "  --no-banner    Start without the banner"
                echo "  --reset        Reset all data and re-run setup"
                exit 0
                ;;

            --version)
                echo "Password Manager v${VERSION}"
                exit 0
                ;;

            --debug)
                DEBUG=true
                shift
                ;;

            --no-banner)
                SHOW_BANNER=false
                shift
                ;;

            --reset|--setup)
                echo "Resetting password manager data..."
                rm -rf data/passwords/*
                rm -f data/.MASTER
                echo "Data cleared. Fresh setup will run on next start."
                exit 0
                ;;

            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
}

# ------------------------------------------------------------
# show_menu()
# Displays the main menu and routes user selections.
# ------------------------------------------------------------
show_menu() {
    echo "Password Manager Menu"
    echo "---------------------"
    echo "1. Add new password"
    echo "2. Get password"
    echo "3. List accounts"
    echo "4. Delete password"
    echo "5. Change master password"
    echo "6. Exit"
    echo ""

    read -p "Choose an option (1–6): " menu_option

    case "$menu_option" in
        1)
            log_debug "User selected: Add new password"
            new_password "$MASTER_PASSWORD"
            echo ""
            sleep 1
            ;;
        2)
            log_debug "User selected: Get password"
            retrieve_password "$MASTER_PASSWORD"
            echo ""
            ;;
        3)
            log_debug "User selected: List accounts"
            echo ""
            list_accounts
            echo ""
            ;;
        4)
            log_debug "User selected: Delete password"
            echo ""
            delete_password
            echo ""
            ;;
        5)
            log_debug "User selected: Change master password"
            echo ""
            change_master_password
            echo ""
            ;;
        6)
            read -p "Are you sure you want to exit? (y/n): " confirm_exit
            case "$confirm_exit" in
                y|Y)
                    echo "Exiting..."
                    sleep 0.5
                    echo "Goodbye!"
                    sleep 1
                    clear
                    exit 0
                    ;;
                n|N)
                    echo "Returning to menu."
                    ;;
                *)
                    echo "Invalid option. Returning to menu."
                    ;;
            esac
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac
}

# ------------------------------------------------------------
# main()
# Parses arguments, initializes the system, and starts the loop.
# ------------------------------------------------------------
main() {
    parse_arguments "$@"

    log_debug "Debug mode enabled"
    log_debug "Banner enabled: $SHOW_BANNER"

    initialize

    while true; do
        clear

        if [[ "$SHOW_BANNER" == true ]]; then
            echo
            echo "             #####################################################################"
            echo "             ###################  Password Manager by Leonard  ###################"
            echo "             #####################################################################"
            echo ""
        fi

        show_menu
    done
}

# Start program
main "$@"

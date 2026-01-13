#!/bin/bash

# ------------------------------------------------------------
# log_debug(message)
# Prints debug messages only when DEBUG=true.
# ------------------------------------------------------------
log_debug() {
    if [[ "$DEBUG" == true ]]; then
        echo "[DEBUG] $1"
    fi
}

list_accounts() {
    if [[ -z "$(ls -A data/passwords 2>/dev/null)" ]]; then
        echo ""
        echo "There are no saved passwords. Please add a password."
        return 1
    fi

    echo "  Accounts:"
    echo "--------------"
    ls -1 data/passwords
    echo ""
    read -p "Press Enter to return to the main menu."
}

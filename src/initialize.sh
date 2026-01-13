#!/bin/bash

# ------------------------------------------------------------
# initialize.sh
# Handles master password creation, verification, and loading.
# This script is sourced by the main password manager.
# ------------------------------------------------------------

# Global variable used across scripts
MASTER_PASSWORD=""

# ------------------------------------------------------------
# initialize()
# Entry point for master password handling.
# - If a master password hash exists, verify it.
# - Otherwise, prompt the user to create one.
# ------------------------------------------------------------
initialize() {
    echo ""
    echo "Welcome to the password manager."
    echo ""

    if [[ -f "data/.MASTER" ]]; then
        check_master_password
    else
        create_master_password
    fi
}

# ------------------------------------------------------------
# create_master_password()
# Prompts the user to create and confirm a master password.
# The password is hashed using:
#   - SHA-512 (openssl passwd -6)
#   - Random salt (openssl rand)
# The resulting hash is stored in data/.MASTER.
# ------------------------------------------------------------
create_master_password() {
    echo "Creating master password..."
    echo ""

    while true; do
        read -sp "Enter master password: " master_password1 && echo
        read -sp "Re-enter master password: " master_password2 && echo
        echo ""

        # Verify both entries match
        if [[ "$master_password1" == "$master_password2" ]]; then
            echo "Passwords match. Initializing..."
            sleep 1
            echo ""

            MASTER_PASSWORD="$master_password1"

            # Generate salted SHA-512 hash and store it
            openssl passwd -6 -salt "$(openssl rand -base64 16)" \
                "$MASTER_PASSWORD" > data/.MASTER

            break
        else
            echo "Passwords do not match. Please try again."
            echo ""
        fi
    done
}

# ------------------------------------------------------------
# get_salt(hash)
# Extracts the salt from a SHA-512 hashed password.
# Hash format: $6$salt$hashvalue
# ------------------------------------------------------------
get_salt() {
    local hash="$1"
    local salt
    salt=$(echo "$hash" | cut -d '$' -f3)
    echo -n "$salt"
}

# ------------------------------------------------------------
# check_master_password()
# Prompts the user to enter the master password.
# The entered password is hashed with the stored salt and
# compared to the saved hash in data/.MASTER.
# Loops until the correct password is entered.
# ------------------------------------------------------------
check_master_password() {
    local password_hash
    local password_salt
    local user_hash

    password_hash=$(cat data/.MASTER)
    password_salt=$(get_salt "$password_hash")

    while true; do
        read -sp "Enter master password: " password && echo
        MASTER_PASSWORD="$password"

        # Hash the user input using the stored salt
        user_hash=$(openssl passwd -6 -salt "$password_salt" "$MASTER_PASSWORD")

        if [[ "$password_hash" == "$user_hash" ]]; then
            break
        else
            echo "Incorrect password. Please try again."
            echo ""
        fi
    done

    return 0
}

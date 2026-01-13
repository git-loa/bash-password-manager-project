#!/bin/bash

# ------------------------------------------------------------
# passwords.sh
# Handles password generation, encryption, decryption,
# storage, retrieval, deletion, and master-password changes.
# This script is sourced by the main password manager.
# ------------------------------------------------------------


# ============================================================
#                 PASSWORD GENERATION & STORAGE
# ============================================================

# ------------------------------------------------------------
# generate_password()
# Generates a secure random password using OpenSSL.
# Output: Base64-encoded 24-byte random string.
# ------------------------------------------------------------
generate_password() {
    local random_password
    random_password=$(openssl rand -base64 24)
    echo -n "$random_password"
}

# ------------------------------------------------------------
# encrypt_password(master_password, plaintext)
# Encrypts a plaintext password using:
#   - AES-256-CBC
#   - PBKDF2 key derivation
#   - 64,000 iterations
#   - Base64 output
# ------------------------------------------------------------
encrypt_password() {
    local master_password="$1"
    local plaintext="$2"

    local encrypted_password
    encrypted_password=$(echo -n "$plaintext" | openssl enc \
        -aes-256-cbc -a -pbkdf2 -iter 64000 -pass pass:"$master_password")

    echo -n "$encrypted_password"
}

# ------------------------------------------------------------
# new_password(master_password)
# Creates a new password entry for a given account.
# - Prompts user for account name
# - Confirms overwrite if account exists
# - Generates a random password
# - Encrypts and stores it in data/passwords/<account>
# ------------------------------------------------------------
new_password() {
    local master_password="$1"
    mkdir -p data/passwords

    while true; do
        read -p "Enter account name (or 'q' to quit): " account_name && echo

        # Quit option
        if [[ "$account_name" == "q" ]]; then
            echo "Returning to main menu..."
            return
        fi

        # Check if account already exists
        if [[ -f "data/passwords/${account_name}" ]]; then
            read -p "A password already exists for '${account_name}'. Overwrite? (y/n): " overwrite
            if [[ "$overwrite" != "y" ]]; then
                echo "Choose a different account name (or enter 'q' to quit)."
                continue
            fi
        fi

        # Confirm account name
        read -p "Confirm account name '${account_name}' (y/n): " confirm
        if [[ "$confirm" != "y" ]]; then
            echo "Let's try again."
            continue
        fi

        # Generate and encrypt password
        local generated_password
        generated_password=$(generate_password)

        local encrypted_password
        encrypted_password=$(encrypt_password "$MASTER_PASSWORD" "$generated_password")

        echo "Saving encrypted password..."
        sleep 1
        echo -n "$encrypted_password" > "data/passwords/${account_name}"
        echo "Saved successfully."

        break
    done
}


# ============================================================
#                 PASSWORD RETRIEVAL & DISPLAY
# ============================================================

# ------------------------------------------------------------
# decrypt_password(master_password, ciphertext)
# Decrypts an encrypted password using the master password.
# ------------------------------------------------------------
decrypt_password() {
    local master_password="$1"
    local ciphertext="$2"

    local decrypted_password
    decrypted_password=$(echo -n "$ciphertext" | openssl enc -d \
        -aes-256-cbc -a -pbkdf2 -iter 64000 -pass pass:"$master_password")

    echo -n "$decrypted_password"
}

# ------------------------------------------------------------
# display_password(password)
# Displays a decrypted password and waits for user confirmation.
# ------------------------------------------------------------
display_password() {
    echo "Password: $1"
    read -p "Press Enter when done viewing password..."
    clear
}

# ------------------------------------------------------------
# retrieve_password(master_password)
# Retrieves and decrypts a stored password for a given account.
# ------------------------------------------------------------
retrieve_password() {
    local master_password="$1"

    # Check if directory is empty
    if [[ -z "$(ls -A data/passwords)" ]]; then
        echo "No passwords saved. Returning to main menu..."
        sleep 1
        clear
        return 1
    fi

    while true; do
        read -p "Enter your account name: " account_name && echo

        if [[ ! -f "data/passwords/${account_name}" ]]; then
            echo "The account '${account_name}' does not exist."
            read -p "Quit? (y/n): " quit && echo
            [[ "$quit" == "y" ]] && return 0
            continue
        fi

        local encrypted_password
        encrypted_password=$(< "data/passwords/${account_name}")

        local decrypted_password
        decrypted_password=$(decrypt_password "$master_password" "$encrypted_password")

        display_password "$decrypted_password"
        break
    done
}


# ============================================================
#                 AUTHENTICATION HELPERS
# ============================================================

# ------------------------------------------------------------
# authenticate_with_master_password(password)
# Verifies a supplied password against the stored master hash.
# Returns:
#   0 = correct
#   1 = incorrect
# ------------------------------------------------------------
authenticate_with_master_password() {
    local master_password="$1"
    local password_hash
    password_hash=$(cat data/.MASTER)

    local password_salt
    password_salt=$(echo "$password_hash" | cut -d '$' -f3)

    local user_hash
    user_hash=$(openssl passwd -6 -salt "$password_salt" "$master_password")

    [[ "$password_hash" == "$user_hash" ]]
}


# ============================================================
#                 PASSWORD DELETION
# ============================================================

# ------------------------------------------------------------
# delete_password()
# Deletes a stored password after:
#   - Authenticating master password (3 attempts)
#   - Confirming account exists
#   - Confirming deletion
# ------------------------------------------------------------
delete_password() {
    local master_password
    local attempts=0
    local max_attempts=3

    # Authenticate user
    while [[ "$attempts" -lt "$max_attempts" ]]; do
        read -sp "Enter master password: " master_password && echo
        if authenticate_with_master_password "$master_password"; then
            break
        fi
        echo "Incorrect master password. Try again."
        attempts=$((attempts + 1))
    done

    if [[ "$attempts" -ge "$max_attempts" ]]; then
        echo "Maximum attempts reached. Returning to main menu..."
        sleep 2
        return 1
    fi

    # Ensure directory is not empty
    if [[ -z "$(ls -A data/passwords)" ]]; then
        echo "No passwords saved. Returning to main menu..."
        sleep 1
        clear
        return 1
    fi

    # Delete account
    while true; do
        read -p "Enter account name to delete (or 'q' to quit): " account_name && echo

        [[ "$account_name" == "q" ]] && return 0

        if [[ ! -f "data/passwords/${account_name}" ]]; then
            echo "The account '${account_name}' does not exist."
            continue
        fi

        read -p "Delete password for '${account_name}'? (y/n): " confirm_delete && echo

        case "$confirm_delete" in
            y|Y)
                rm -f "data/passwords/${account_name}"
                echo "Password for '${account_name}' deleted."
                sleep 2
                return 0
                ;;
            n|N)
                echo "Deletion aborted."
                sleep 2
                return 0
                ;;
            *)
                echo "Invalid option. Try again."
                ;;
        esac
    done
}


# ============================================================
#                 CHANGE MASTER PASSWORD
# ============================================================

# ------------------------------------------------------------
# change_master_password()
# Allows user to:
#   - Authenticate with old master password
#   - Set a new master password
#   - Re-encrypt all stored passwords with the new key
# ------------------------------------------------------------
change_master_password() {
    local old_master_password
    local new_master_password1 new_master_password2
    local new_master_password
    local account_name

    # Authenticate old master password
    read -sp "Enter current master password: " old_master_password && echo
    if ! authenticate_with_master_password "$old_master_password"; then
        echo "Incorrect master password."
        return 1
    fi

    # Prompt for new master password
    echo "Set a new master password."
    while true; do
        read -sp "Enter new master password: " new_master_password1 && echo
        read -sp "Re-enter new master password: " new_master_password2 && echo

        if [[ "$new_master_password1" == "$new_master_password2" ]]; then
            new_master_password="$new_master_password1"
            break
        fi

        echo "Passwords do not match. Try again."
    done

    # Re-encrypt all stored passwords with the new master password
    for account_name in "data/passwords"/*; do
        # Extract filename only
        local filename="${account_name##*/}"

        # Read existing encrypted password
        local encrypted_password
        encrypted_password=$(< "$account_name")

        # Decrypt using old master password
        local decrypted_password
        decrypted_password=$(decrypt_password "$old_master_password" "$encrypted_password")

        # Encrypt using new master password
        local new_encrypted_password
        new_encrypted_password=$(encrypt_password "$new_master_password" "$decrypted_password")

        # Save updated encrypted password back to the correct file
        echo -n "${new_encrypted_password}" > "data/passwords/${filename}"
    done

    # Save new master password hash
    openssl passwd -6 -salt "$(openssl rand -base64 16)" \
        "$new_master_password" > data/.MASTER

    echo "Updating master password..."
    sleep 2
    echo "Master password successfully changed."
    sleep 2
}

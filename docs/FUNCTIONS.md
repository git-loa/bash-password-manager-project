
# 📘 **FUNCTIONS.md**  
### _Documentation of all functions in the Bash Password Manager_

## Overview
This document provides a complete reference for every function defined in the password manager project. It covers purpose, parameters, return values, and file locations.

---

## 📁 **src/initialize.sh**

### ### `initialize()`
**Purpose:**  
Initializes the password manager by checking for an existing master password file.  
If none exists, prompts the user to create one.

**Parameters:**  
None

**Returns:**  
- `0` on success  
- Creates `data/.MASTER` if missing

---

## 📁 **src/passwords.sh**

### ### `generate_password()`
**Purpose:**  
Generates a secure random password using OpenSSL.

**Parameters:**  
None

**Returns:**  
- Base64‑encoded random password (24 bytes)

---

### ### `encrypt_password(master_password, plaintext)`
**Purpose:**  
Encrypts a plaintext password using AES‑256‑CBC with PBKDF2 and 64,000 iterations.

**Parameters:**  
- `master_password` — the encryption key  
- `plaintext` — the password to encrypt  

**Returns:**  
- Base64‑encoded ciphertext

---

### ### `decrypt_password(master_password, ciphertext)`
**Purpose:**  
Decrypts a stored password using the master password.

**Parameters:**  
- `master_password`  
- `ciphertext`  

**Returns:**  
- Decrypted plaintext password

---

### ### `new_password(master_password)`
**Purpose:**  
Creates a new password entry for an account.

**Behavior:**  
- Prompts for account name  
- Confirms overwrite if needed  
- Generates a random password  
- Encrypts and stores it in `data/passwords/<account>`

**Parameters:**  
- `master_password`

**Returns:**  
None

---

### ### `retrieve_password(master_password)`
**Purpose:**  
Retrieves and decrypts a stored password.

**Behavior:**  
- Prompts for account name  
- Validates existence  
- Decrypts and displays password

**Parameters:**  
- `master_password`

**Returns:**  
None

---

### ### `display_password(password)`
**Purpose:**  
Displays a decrypted password and waits for user confirmation.

**Parameters:**  
- `password`

**Returns:**  
None

---

### ### `authenticate_with_master_password(master_password)`
**Purpose:**  
Verifies the supplied master password against the stored hash.

**Parameters:**  
- `master_password`

**Returns:**  
- `0` if correct  
- `1` if incorrect

---

### ### `delete_password()`
**Purpose:**  
Deletes a stored password after authenticating the master password.

**Behavior:**  
- Prompts for master password (3 attempts)  
- Prompts for account name  
- Confirms deletion  

**Parameters:**  
None

**Returns:**  
None

---

### ### `change_master_password()`
**Purpose:**  
Changes the master password and re‑encrypts all stored passwords.

**Behavior:**  
- Authenticates old master password  
- Prompts for new master password  
- Re‑encrypts all entries  
- Updates `data/.MASTER`

**Parameters:**  
None

**Returns:**  
None

---

## 📁 **src/utils.sh**

### ### `log_debug(message)`
**Purpose:**  
Prints debug messages only when `DEBUG=true`.

**Parameters:**  
- `message`

**Returns:**  
None

---

### ### `list_accounts()`
**Purpose:**  
Lists all saved account names.

**Behavior:**  
- Checks if `data/passwords` is empty  
- Prints account names  
- Waits for user input  

**Parameters:**  
None

**Returns:**  
- `1` if no accounts exist  
- `0` otherwise

---

## 📁 **src/password_manager.sh**

### ### `parse_arguments()`
**Purpose:**  
Parses command‑line flags.

**Supported flags:**  
- `--help`  
- `--version`  
- `--debug`  
- `--no-banner`  
- `--reset`  

**Parameters:**  
- All script arguments (`"$@"`)

**Returns:**  
- Exits for help/version/reset  
- Otherwise sets global flags

---

### ### `show_menu()`
**Purpose:**  
Displays the main menu and routes user selections.

**Parameters:**  
None

**Returns:**  
None

---

### ### `main()`
**Purpose:**  
Entry point of the program.

**Behavior:**  
- Parses arguments  
- Initializes system  
- Displays banner (optional)  
- Runs menu loop  

**Parameters:**  
- Script arguments (`"$@"`)

**Returns:**  
Never returns (loops until exit)


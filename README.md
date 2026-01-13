
# Password Manager (Bash)

A lightweight, security‑focused password manager written entirely in Bash.  
It uses strong encryption (AES‑256‑CBC + PBKDF2) and a hashed master password (SHA‑512 crypt) to securely store account passwords on your local machine.

This project demonstrates secure scripting practices, modular Bash design, and CLI tooling — suitable for learning, portfolio building, and experimentation.

---

## Getting Started

This section provides the quickest path to installing, setting up, and running the password manager.

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/password-manager.git
cd password-manager
```

### 2. Make the main script executable

```bash
chmod +x password_manager.sh
```

### 3. Run the setup script (required before first use)

```bash
sudo ./setup.sh
```

The setup script will:

- Create the `password-manager` group  
- Add your user to that group  
- Create the `data/` and `data/passwords/` directories  
- Apply secure permissions  

After running the script, log out and log back in so group membership takes effect.

### 4. Launch the password manager

```bash
./password_manager.sh
```

On first run, you will be prompted to create a master password.

---

## Features

- AES‑256‑CBC encryption for stored passwords  
- PBKDF2 key derivation with 64,000 iterations  
- SHA‑512 crypt hashing for the master password  
- Modular Bash architecture (`src/` folder)  
- CLI flags for automation and scripting  
- Interactive menu interface  
- Secure password generation  
- Ability to change master password  
- Ability to delete stored passwords  
- Optional debug mode  
- Optional banner suppression  
- Fully offline — no network usage  

---

## Project Structure

```
password-manager/
│
├── password_manager.sh        # Main CLI entry point
├── setup.sh                   # Environment and permissions setup
│
├── src/
│   ├── initialize.sh          # Master password setup & verification
│   ├── passwords.sh           # Encryption, decryption, CRUD operations
│   └── utils.sh               # Logging, listing accounts, helpers
│
├── data/                      # Created automatically by setup.sh
│   ├── passwords/             # Encrypted password files
│   └── .MASTER                # Hashed master password
│
└── docs/
    ├── FUNCTIONS.md
    ├── SECURITY.md
    └── CONTRIBUTING.md
```

Note:  
The `data/` directory is not included in the repository. It is created automatically by `setup.sh` with secure permissions.

---

## Usage

Running the program without flags launches the interactive menu:

```bash
./password_manager.sh
```

Menu options:

```
1. Add new password
2. Get password
3. List accounts
4. Delete password
5. Change master password
6. Exit
```

---

## CLI Flags

### Show help

```bash
./password_manager.sh --help
```

### Show version

```bash
./password_manager.sh --version
```

### Enable debug mode

```bash
./password_manager.sh --debug
```

### Disable banner

```bash
./password_manager.sh --no-banner
```

### Reset all data (dangerous)

```bash
./password_manager.sh --reset
```

This deletes all encrypted passwords and the master password hash.

---

## Security Overview

- Master password is hashed using SHA‑512 crypt with a random salt  
- Passwords are encrypted using AES‑256‑CBC  
- Keys are derived using PBKDF2 with 64,000 iterations  
- No plaintext passwords are ever stored  
- Each account has its own encrypted file  

See `docs/SECURITY.md` for full details.

---

## Documentation

- `FUNCTIONS.md` — full function reference  
- `SECURITY.md` — encryption, hashing, threat model  
- `CONTRIBUTING.md` — contribution guidelines  

---

## Requirements

- Bash 4+  
- OpenSSL installed  
- Linux or macOS terminal  

---

## License

This project is licensed under the MIT License.  
See the `LICENSE` file for details.

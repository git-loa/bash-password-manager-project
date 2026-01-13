
### _Security model and considerations for the Bash Password Manager_

## Overview
This document explains the security design of the password manager, including encryption, hashing, storage, and threat considerations.

---

##  Master Password Security

### **Hashing**
The master password is hashed using:

- **SHA‑512 crypt (`openssl passwd -6`)**
- **Random 16‑byte salt**
- Stored in: `data/.MASTER`

This ensures:

- The master password is never stored in plaintext  
- Rainbow‑table attacks are mitigated  
- Hashes differ even for identical passwords  

---

##  Password Encryption

### **Algorithm**
All stored passwords are encrypted using:

- **AES‑256‑CBC**
- **PBKDF2 key derivation**
- **64,000 iterations**
- **Base64 output**

### **Why this matters**
- AES‑256‑CBC is widely trusted  
- PBKDF2 slows brute‑force attacks  
- Iteration count increases computational cost for attackers  

---

##  Storage Layout

```
data/
│
├── .MASTER            # hashed master password
└── passwords/
    ├── github         # encrypted password
    ├── email
    └── ...
```

### **Security properties**
- No plaintext passwords are stored  
- Each account has its own encrypted file  
- Directory structure is simple and auditable  

---

## Threat Model

### **Protected Against**
- Offline theft of encrypted password files  
- Brute‑forcing stored passwords  
- Reading stored passwords without master password  
- Accidental plaintext exposure  

### **Not Protected Against**
- Malware/keyloggers on the user’s machine  
- Shoulder‑surfing  
- Users choosing weak master passwords  
- Bash history leaks if users manually type passwords into commands  
- Physical access to an unlocked terminal  

---

##  Recommendations for Users

- Choose a strong master password  
- Keep the `data/` directory private  
- Do not sync the folder to cloud services without encryption  
- Use a secure terminal environment  
- Avoid running the tool on shared machines  

---

##  Disclaimer
This password manager is a learning project and not intended to replace professional password managers. Use at your own discretion.

### _Guidelines for contributing to the Bash Password Manager_

## Welcome
Thank you for your interest in contributing!  
This project is designed to be simple, educational, and security‑focused. Contributions of all kinds are welcome.

---

##  Project Structure

```
src/
│   initialize.sh
│   passwords.sh
│   utils.sh
password_manager.sh
│
data/
│   passwords/
│   .MASTER
│
docs/
│   FUNCTIONS.md
│   SECURITY.md
│   CONTRIBUTING.md
│
README.md
```

---

##  How to Contribute

### 1. Fork the repository  
Click “Fork” on GitHub.

### 2. Clone your fork  
```
git clone https://github.com/<your-username>/password-manager.git
```

### 3. Create a feature branch  
```
git checkout -b feature/my-improvement
```

### 4. Make your changes  
Follow the coding style:

- Use consistent indentation  
- Quote variables  
- Use `local` inside functions  
- Prefer small, modular functions  

### 5. Test your changes  
Run:

```
./src/password_manager.sh
```

Test:

- Adding passwords  
- Retrieving passwords  
- Changing master password  
- CLI flags (`--help`, `--version`, etc.)  

### 6. Commit your changes  
```
git commit -m "Add feature: <description>"
```

### 7. Push and open a pull request  
```
git push origin feature/my-improvement
```

Then open a PR on GitHub.

---

##  Coding Standards

- Use `shellcheck` to lint scripts  
- Avoid unnecessary subshells  
- Use `[[ ]]` instead of `[ ]`  
- Quote all variable expansions  
- Use descriptive function names  

---

##  Reporting Issues

If you find a bug:

- Open an issue  
- Describe the problem  
- Include steps to reproduce  
- Include your OS and Bash version  

---

##  Thank You
Your contributions help improve the project and make it a stronger learning tool for others.

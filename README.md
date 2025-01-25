# GitHunt 🔍  
*A Git File Version Hunter*  

---

## Features  
- 🕵️ Find file versions across **all branches/tags**  
- 📂 Works for files in any directory structure  
- ⏳ Shows both matching commit and next newer version  
- 🔄 Tracks file renames/moves through history  
- 🔒 MD5 hash verification for precise matching  

---

## Installation  
```bash
# Check your SHELL
echo $SHELL

# Add to your shell profile according to your shell
# Bash
curl -L https://raw.githubusercontent.com/KPvivid/githunt/main/githunt.sh >> ~/.bashrc
source ~/.bashrc

# Zsh
curl -L https://raw.githubusercontent.com/KPvivid/githunt/main/githunt.sh >> ~/.zshrc
source ~/.zshrc

# Fish
curl -L https://raw.githubusercontent.com/KPvivid/githunt/main/githunt.sh >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

---

## Usage  
```bash
githunt <file-path> <target-md5>

# Examples
githunt config.yml d41d8cd98f00b204e9800998ecf8427e
githunt src/app/security.py a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p
```


---

## Why GitHunt?  
Perfect for when you need to:  
- Audit when specific file changes were introduced  
- Track regressions across complex branch histories  
- Verify file integrity through Git's timeline  
- Find hidden versions like a Git detective 🕵️♂️  

*Born from the need to analyze CMS version during security audits, inspired by Ippsec's methodology*

---
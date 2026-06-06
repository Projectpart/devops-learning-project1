# DevOps Learning Project - Git Practice

This repository is created to learn and practice Git commands from beginner to advanced level as part of my DevOps learning journey.

## Repository Setup

### Clone Repository

```bash
git clone <repository-url>
cd devops-learning-project1
```

## Branches Created

### Main Branch

```bash
main
```

### Feature Branches

```bash
feature/day2
feature_new
```

Commands used:

```bash
git checkout -b feature/day2
git checkout -b feature_new
```

Verify branches:

```bash
git branch
```

Output:

```bash
feature/day2
* feature_new
main
```

---

## Git Concepts Practiced

### 1. Checking Status

```bash
git status
```

Shows:

- Current branch
- Modified files
- Untracked files
- Staged files

---

### 2. Staging Files

Add a specific file:

```bash
git add day2.txt
```

Add all files:

```bash
git add .
```

---

### 3. Commit Changes

```bash
git commit -m "Added day2 learning notes"
```

A commit saves a snapshot of the current changes.

---

### 4. View Commit History

```bash
git log
```

Short version:

```bash
git log --oneline
```

Graph view:

```bash
git log --oneline --graph --all
```

---

### 5. Push Changes to GitHub

First push:

```bash
git push -u origin feature_new
```

Subsequent pushes:

```bash
git push
```

---

### 6. Switch Branches

```bash
git checkout main
```

or

```bash
git checkout feature_new
```

---

### 7. Merge Branches

Switch to main:

```bash
git checkout main
```

Merge feature branch:

```bash
git merge feature_new
```

---

### 8. Delete Branches

Delete local branch:

```bash
git branch -d feature_new
```

Delete remote branch:

```bash
git push origin --delete feature_new
```

---

## Git Workflow

```text
Working Directory
       |
       | git add
       ↓
Staging Area
       |
       | git commit
       ↓
Local Repository
       |
       | git push
       ↓
Remote Repository (GitHub)
```

---

## Commands Learned So Far

```bash
git clone
git status
git add
git commit
git push
git pull
git checkout
git checkout -b
git branch
git log
git diff
git merge
git remote -v
```
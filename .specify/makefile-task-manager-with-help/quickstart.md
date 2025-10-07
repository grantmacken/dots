# Quickstart: Makefile Task Manager Verification

**Feature**: Makefile Task Manager with Help Target  
**Purpose**: Manual verification steps to validate feature implementation

## Prerequisites
- In toolbox environment (not host)
- In dotfiles project directory
- Changes deployed via `make delete && make`

## Verification Steps

### 1. Test Default Target Shows Help
**Expected**: Running `make` with no arguments displays help output

```bash
cd ~/Projects/dots
make
```

**Success Criteria**:
- Output shows list of available targets
- Each target has description aligned to right
- Output uses color (cyan for target names)
- No error messages

### 2. Test Explicit Help Target
**Expected**: `make help` shows same output as default

```bash
make help
```

**Success Criteria**:
- Identical output to step 1
- Help target still works explicitly

### 3. Test Tab Completion for Make Targets
**Expected**: Pressing TAB after `make ` suggests available targets

```bash
# In toolbox shell, type (don't press enter):
make <TAB><TAB>
```

**Success Criteria**:
- Shell displays list of available targets
- List includes: help, default, delete, backup_enable, tbx_enable, etc.
- Targets match those shown in help output

### 4. Test Partial Completion
**Expected**: Partial target name completes on TAB

```bash
# Type (don't press enter):
make bac<TAB>
```

**Success Criteria**:
- Completes to `make backup_` (common prefix)
- Pressing TAB again shows: backup_enable, backup_disable, backup_status, backup_test

### 5. Test Help Output Format
**Expected**: Help displays all user-facing targets with descriptions

```bash
make help | grep -E "backup|tbx|help|default"
```

**Success Criteria**:
- All backup_* targets listed
- All tbx_* targets listed
- help and default targets listed
- Internal targets (init, clean_nvim, ai) NOT listed

### 6. Test Completion Persistence After Toolbox Reset
**Expected**: Completion still works after toolbox is recreated

```bash
# Exit toolbox
exit

# On host, remove and recreate toolbox
toolbox rm -f fedora-toolbox-42
toolbox create fedora-toolbox-42

# Enter new toolbox
toolbox enter

# Change to dots directory (if stowed, bashrc should be active)
cd ~/Projects/dots

# Test completion
make <TAB><TAB>
```

**Success Criteria**:
- Completion works in fresh toolbox
- No manual setup required
- bashrc.d/completion.sh loaded automatically

### 7. Test Default Target Still Executes Stow
**Expected**: `make` (default) still performs stow operation

```bash
# First delete existing symlinks
make delete

# Run default (via no arguments)
make
```

**Success Criteria**:
- Output shows "##[ stow dotfiles ]##"
- Stow operations execute
- Completes with "✅ completed task"
- Symlinks created in ~/

### 8. Test Help Shows Updated Description
**Expected**: Default target description clarifies its behavior

```bash
make help | grep "default"
```

**Success Criteria**:
- Description is clear and accurate
- Mentions "install dotfiles" or similar
- More informative than just "stow dotfiles"

## Troubleshooting

### Tab Completion Not Working
**Check 1**: Verify bash-completion installed
```bash
rpm -qa | grep bash-completion
```
Expected: `bash-completion-2.16-1.fc42.noarch` or similar

**Check 2**: Verify completion.sh exists and is sourced
```bash
ls -la ~/.bashrc.d/completion.sh
grep "bash_completion" ~/.bashrc.d/completion.sh
```

**Check 3**: Manually source and test
```bash
source ~/.bashrc.d/completion.sh
make <TAB><TAB>
```

### Help Not Default
**Check**: Verify help is first non-special target
```bash
grep -n "^[a-z].*:" Makefile | head -5
```
Expected: First result should be `help:`

### Missing Descriptions
**Check**: Verify `##` format
```bash
grep "^[a-z].*:.*##" Makefile
```
Expected: All user-facing targets should appear

## Success Confirmation
All 8 verification steps pass ✅

## Rollback Procedure
If verification fails and rollback needed:
```bash
cd ~/Projects/dots
git checkout main
make delete && make
```

---
**Last Updated**: 2025-01-10  
**Linked Files**: spec.md, plan.md

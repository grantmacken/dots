# Phase Reordering: GitHub Actions to Phase 3

**Date**: 2025-11-13  
**Reason**: Test framework deferred, CI/CD provides validation

## Change Summary

Moved **GitHub Actions & Validation** from Phase 6 to Phase 3.

### Old Order
- Phase 0: Research ✅
- Phase 1: Documentation ✅
- Phase 2: Foundational ✅
- Phase 3: User Story 1 (Neovim)
- Phase 4: User Story 2 (Systemd)
- Phase 5: User Story 3 (Git)
- **Phase 6**: GitHub Actions & Validation
- Phase 7: Polish

### New Order
- Phase 0: Research ✅
- Phase 1: Documentation ✅
- Phase 2: Foundational ✅
- **Phase 3: GitHub Actions & Validation** ← MOVED UP
- Phase 4: User Story 1 (Neovim) 
- Phase 5: User Story 2 (Systemd)
- Phase 6: User Story 3 (Git)
- Phase 7: Polish

## Rationale

### Why Move GitHub Actions Earlier?

1. **Test Framework Deferred**: No Neovim test framework in plan (Busted testing deferred)
2. **CI Provides Testing**: GitHub Actions workflow can validate deployment in clean environment
3. **Foundation Validation**: Need to test Phase 0-2 work before building features
4. **Logical Flow**: Foundation → Validation → Features → Polish
5. **Early Feedback**: Catch issues immediately after guards implemented

### Benefits

1. **Validates Foundation**: Phase 2 guards tested in CI before user stories
2. **Clean Environment**: Tests `make init` and `make` without affecting local system
3. **Test-Driven Approach**: CI validates foundation before features
4. **Workflow Established**: Can test future changes easily
5. **Earlier Confidence**: Know foundation works before proceeding

## Task Renumbering

### Phase 3 (GitHub Actions) - Tasks 010-021
- T010-T012: Workflow setup (was T030-T032)
- T013-T017: Makefile target testing (was T033-T037)
- T018-T021: Additional validation (was T038-T041)

### Phase 4 (Neovim) - Tasks 022-029
- T022-T029: Neovim verification (was T010-T017)

### Phase 5 (Systemd) - Tasks 030-035
- T030-T035: Systemd verification (was T018-T024)

### Phase 6 (Git) - Tasks 036-040
- T036-T040: Git workflow (was T025-T029)

### Phase 7 (Polish) - Tasks 041-046
- T041-T046: Documentation (was T041-T047, one task merged)

**Total Tasks**: 46 (unchanged)

## Dependencies Updated

### Before Reordering
```
Phase 2 (Foundation) 
  ↓
Phases 3-5 (User Stories)
  ↓
Phase 6 (GitHub Actions)
  ↓
Phase 7 (Polish)
```

### After Reordering
```
Phase 2 (Foundation) ✅
  ↓
Phase 3 (GitHub Actions) ← Validates foundation
  ↓
Phases 4-6 (User Stories) ← Build on validated base
  ↓
Phase 7 (Polish)
```

## Impact on Current Progress

### Completed (No Change)
- ✅ Phase 0: Research (2/2 tasks)
- ✅ Phase 1: Documentation (3/3 tasks)
- ✅ Phase 2: Foundational (6/6 tasks)

### Next Phase
- ⏳ **Phase 3: GitHub Actions** (12 tasks)
  - Validates all Phase 0-2 work
  - Tests in clean CI environment
  - Establishes automated testing

### Deferred
- Phase 4-6: User Stories (20 tasks total)
- Phase 7: Polish (6 tasks)

## Workflow

### Current State
```
Foundation Complete ✅
  ├─ Toolbox validation
  ├─ Repository guards
  ├─ Conflict detection
  └─ Safety checks in place
```

### Next Step (Phase 3)
```
GitHub Actions Workflow
  ├─ Setup tbx-coding container in CI
  ├─ Run make check-toolbox, check-tools
  ├─ Test make init (validate directories)
  ├─ Test make (stow deployment)
  ├─ Test make verify (all guards)
  └─ Smoke test Neovim launch
```

### Then (Phases 4-6)
```
User Stories (validated foundation)
  ├─ Phase 4: Neovim deployment
  ├─ Phase 5: Systemd orchestration
  └─ Phase 6: Git workflow
```

## Success Criteria

### Phase 3 Complete When:
- ✅ GitHub Actions workflow runs successfully
- ✅ `make init` creates directories in CI
- ✅ `make` deploys dotfiles in CI
- ✅ All guards work in CI environment
- ✅ No conflicts detected
- ✅ Neovim launches successfully

## Files Modified

- `.specify/001-tasks.md` - Phase reordering, task renumbering
- `.specify/phase-reorder.md` - This document

## References

- Original discussion: User requested CI testing before features
- Test framework: Deferred (no Busted framework in plan)
- GitHub Actions: `.github/workflows/default.yml` (exists, needs update)
- Foundation work: Phases 0-2 complete

---

**Reordering Status**: ✅ COMPLETE  
**Next Task**: T010 - Update GitHub Actions workflow  
**Ready to Proceed**: YES

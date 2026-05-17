# DOSBox-X

Source-of-truth copy of the macOS user-level DOSBox-X config plus the
spec it was generated from.

## Files

- `dosbox-x-global-defaults.md` — the spec: which sections / keys to set
  and why. Edit this first when changing the canonical defaults.
- `DOSBox-X.Preferences.initiator` — the original config as it existed on
  the host before any of these defaults were applied. Kept for diffing
  and as a rollback target.
- `DOSBox-X.Preferences` — the current configured state. This is what
  belongs in `~/Library/Preferences/DOSBox-X <version> Preferences` on
  macOS.

The filename on disk is versioned by DOSBox-X (`DOSBox-X 2026.05.02
Preferences` at the time of this commit). The version is dropped here so
the file path is stable across DOSBox-X upgrades; copy it onto the host
under whatever versioned name DOSBox-X currently expects.

## Sync

Push host → repo (after editing in DOSBox-X's UI):

```bash
cp ~/Library/Preferences/"DOSBox-X "*" Preferences" \
   ~/Projects/contento/windows-scripts/dosbox-x/DOSBox-X.Preferences
```

Push repo → host:

```bash
cp ~/Projects/contento/windows-scripts/dosbox-x/DOSBox-X.Preferences \
   ~/Library/Preferences/"DOSBox-X 2026.05.02 Preferences"
```

(Adjust the version string to match whichever DOSBox-X build is installed.)

## Diff against the initiator

```bash
diff -u dosbox-x/DOSBox-X.Preferences.initiator dosbox-x/DOSBox-X.Preferences
```

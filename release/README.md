# Publishing a standalone translation

Each entry in `mods.json` is identified by its `key`. Publish a GitHub Release
with the tag `<key>-v<version>`; for example:

```
generic-mod-config-menu-bg-v0.1.0
```

The Nexus release workflow packages only the matching entry. It refuses to
upload if `nexusPublished` is not `true`, or if the configured Nexus game domain
and `NEXUS_MOD_ID_*` secret do not pass the API preflight.

## Publishing a bundle

A `releaseBundles` entry can publish multiple archives from one GitHub Release.
Use the tag `<bundle-key>-v<version>`; for example:

```
better-crafting-bg-v0.1.0
```

Each bundle member is packaged and uploaded independently. This is useful when
one original Nexus page contains a main mod and optional companion files. A
failure for one archive does not stop the other bundle members from uploading.

## First Nexus file

Create the Nexus mod page first. Then set `nexusPublished` to `true` and add
its site-visible page number as the matching `NEXUS_MOD_ID_*` GitHub secret.
Leave the matching `NEXUS_FILE_ID_*` secret absent.

The first GitHub Release uploads the first Nexus file. Before publishing the
next version, open the Nexus Files page and add its actual file-group ID as the
matching `NEXUS_FILE_ID_*` GitHub secret. Do not copy the temporary
`Created Nexus file ID` value printed by the bootstrap log: Nexus exposes a
different identifier for updating an existing file.

Treat this as a release checklist item. No update tag should be created until
both the page secret (`NEXUS_MOD_ID_*`) and the existing-file secret
(`NEXUS_FILE_ID_*`) are present.

## Nexus file names

Nexus validates the display name used for a new file more strictly than
GitHub does. Keep `fileName` short and use only ASCII letters, digits, spaces,
underscores, apostrophes, parentheses, periods, and hyphens. In particular,
do not use a colon (`:`). The human-facing `label` and the GitHub archive name
may remain more descriptive.

The sole required GitHub secret is `NEXUSMODS_API_KEY`.

# Publishing a standalone translation

Each entry in `mods.json` is identified by its `key`. Publish a GitHub Release
with the tag `<key>-v<version>`; for example:

```
generic-mod-config-menu-bg-v0.1.0
```

The Nexus release workflow packages only the matching entry. It refuses to
upload if `nexusPublished` is not `true`, or if the configured Nexus game domain
and `NEXUS_MOD_ID_*` secret do not pass the API preflight.

## First Nexus file

Create the Nexus mod page first. Then set `nexusPublished` to `true` and add
its site-visible page number as the matching `NEXUS_MOD_ID_*` GitHub secret.
Leave the matching `NEXUS_FILE_ID_*` secret absent.

The first GitHub Release uploads the first Nexus file and prints its ID in the
Actions summary. Add that value as the matching `NEXUS_FILE_ID_*` GitHub secret
before publishing the next version. Future releases update only that file.

The sole required GitHub secret is `NEXUSMODS_API_KEY`.

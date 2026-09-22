# Manual smoke scripts

Ad-hoc scripts for poking a running instance by hand. They are **not** part of
`npm test` — the automated suite lives in [`tests/`](../../tests).

Run them from the project root.

## No server required

These load metadata straight off disk:

```bash
node scripts/manual/testLoader.js
node scripts/manual/testAutocomplete.js
```

## Server required

Start the API first (`npm run dev`), then:

```bash
node scripts/manual/testDocsHtml.js
node scripts/manual/testInvalidLogin.js
```

`testLogin.js` needs real credentials, supplied through the environment so no
password is stored in the repo:

```bash
TEST_LOGIN_USER=admin TEST_LOGIN_PASS=yourpassword node scripts/manual/testLogin.js
```

Optional overrides: `TEST_LOGIN_TENANT` (default `1`), `TEST_LOGIN_PERIOD`
(default `2026`). All of these scripts honour `PORT` from `.env`.

## After a write test

`tests/crud.test.js` with `RUN_WRITE_TESTS=1` creates rows in a real tenant and
removes them again. This is the check that it did:

```bash
node scripts/manual/sweepWriteTests.js
node scripts/manual/sweepWriteTests.js --apply
```

It scans every table a generated screen writes to for rows carrying the
harness's `ZZTEST` marker. The answer should always be zero. `--apply` removes
what it finds, children before masters.

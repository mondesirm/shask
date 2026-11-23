# Shared volume (`/data/shared` in n8n)

This directory is mounted into the n8n container at `/data/shared`.

| Path | Purpose |
| --- | --- |
| `credentials/` | Demo credentials imported once on first boot (`n8n-import`) |
| `workflows/` | Demo workflows imported once on first boot |
| *(your files)* | Drop PDFs and other inputs here for filesystem nodes |

Demo credentials are encrypted with `N8N_ENCRYPTION_KEY=super-secret-key`.
See the root README and `scripts/gen-secrets.sh` before rotating that key.

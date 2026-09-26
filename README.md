# Models

Processed model catalogs derived from [models.dev](https://models.dev/) for use with Toolang.

Catalogs use a flat structure:

```json
{
  "providers": [...],
  "models": [...]
}
```

Each model has a string `provider` containing its provider ID. Model-specific provider overrides, when present, are preserved as `override`.

## Downloads

Latest release:

- [catalog.json](https://github.com/openhat-ai/models/releases/latest/download/catalog.json) — recent models
- [catalog.full.json](https://github.com/openhat-ai/models/releases/latest/download/catalog.full.json) — all models

`catalog.json` includes models matching:

```text
[knowledge > 2025-00; last_updated > 2026-00]
```

These are string comparisons over date-like fields. Providers without matching models are omitted.

`catalog.full.json` contains all providers and models from the upstream catalog.

Toolang does not synchronize with this repository automatically. To use a downloaded catalog, place it at `catalog.json` in the Toolang root or agent home, or select it with the catalog option or environment variable.

## Updates

A GitHub Actions workflow builds and publishes the catalogs daily and can also be triggered manually.

Each release keeps a dated snapshot, while `/releases/latest/download/...` always points to the latest catalogs.

To build locally:

```sh
pip install "tq-json[cli]"

scripts/build.sh           # download from models.dev
scripts/build.sh raw.json  # use an existing catalog
```

## License

The catalog data is derived from [models.dev](https://models.dev/). Its upstream license and notice are retained in `LICENSE`.

The build scripts and workflow are distributed under the MIT License.

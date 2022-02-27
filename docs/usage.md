To use this action, make a file `.github/workflows/confluence.yml`. Here's a template to get started:

```yaml
name: confluence-sync

on:
  pull_request:
  push:
    branches: [main]

jobs:
  confluence:
    runs-on: ubuntu-20.04
    steps:
      - name: Check out a copy of the repo
        if: ${{ !env.ACT }}
        uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Get changed files
        id: changed-files
        uses: tj-actions/changed-files@v17.1
        with:
          files: |
            *.md
          files_ignore: |
            *.tpl.md

      - name: Sync confluence
        uses: hadenlabs/action-confluence-sync@0.1.0
        with:
          confluence_base_url: '${{ secrets.CONFLUENCE_BASE_URL }}'
          confluence_user: '${{ secrets.CONFLUENCE_USER }}'
          confluence_token: '${{ secrets.CONFLUENCE_ACCESS_TOKEN }}'
          files: '${{ steps.changed-files.outputs.all_changed_files }}'
```

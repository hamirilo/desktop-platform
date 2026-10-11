# Changelog

release は `v<major>.<minor>.<patch>` の tag と、この file の `## <version>` の節で行う。各節に「既存のツールで対応が必要な変更」の有無を必ず書く。

## 0.1.0

最初の版。image-library（v0.17.0）と Shelf（0.1.3）で有効だったものを Core Standard にした。

### 内容

- `ai/ONBOARDING.md`：AI agent の唯一の入口
- Core Standard：Governance、Architecture、Security、Distribution、UI
- Optional Standard：ローカル受付、複数ツール同居リポジトリ、トレイ常駐
- Recommendations：Stack、Rust
- Playbook：新しいツールを作る、リリース、アップデートの署名鍵、ブラウザで UI を作る、macOS と Windows の差
- ADR-0001〜0003、`docs/adoption.md`、`templates/`

### 既存のツールで対応が必要な変更

- **Required**：Shelf の `tauri.conf.json` の `csp: null`（[Security](standards/security.md) §1）
- **Adopt going forward**：image-library と Shelf に `CLAUDE.md` と `decisions/project-context.md`、CI に Linter / fmt / clippy（[Adoption Guide](docs/adoption.md) §6）

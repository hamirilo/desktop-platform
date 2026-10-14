# Changelog

release は `v<major>.<minor>.<patch>` の tag と、この file の `## <version>` の節で行う。各節に「既存のツールで対応が必要な変更」の有無を必ず書く。

## 0.4.0

表示を切り替えても操作の位置を変えない、という決まりを UI Standard に足した。stockroom では表示を切り替えるたびにツールバーの行や項目が増減し、手が覚えた場所を毎回探し直すことになっていた。

### 内容

- [UI](standards/ui.md) §10「レイアウトの安定」：どの表示でも使う操作は同じ位置に置き、使えないときは無効表示にする。上位の選択で下位の選択肢を出し入れしない。表示ごとの操作は置き場所を 1 か所に決め、その場所の位置と高さを保つ。ラベルが変わるボタンは幅を固定する
- [ADR-0004](decisions/adr-0004-layout-stability-ahead-of-source.md)：このルールは出どころの実装より先に載せた（ADR-0003 の例外）。stockroom で直したら出どころを差し替える

### 既存のツールで対応が必要な変更

- **Adopt going forward**：新しく作る画面、手を入れる画面から §10 を守る。stockroom は `docs/UI.md` の一覧に沿って順に直す

## 0.3.0

AI モデルのティアを使い分ける決まりを Governance に足した。Web 側の ai-dev-platform にはあった決まりで、デスクトップ側に無かったため、すべての作業が最上位のモデルで行われていた。

### 内容

- [Governance](standards/governance.md) §3.1：AI モデルを Light / Standard / High Performance のティアで使い分ける。具体的なモデル名は Standard に固定せず、各ツールの `CLAUDE.md` に書く
- `templates/CLAUDE.md` の「開発の基準」にモデルの割り当ての例を足した

### 既存のツールで対応が必要な変更

- **Adopt going forward**：ツールの `CLAUDE.md` の「開発の基準」に、ティアごとに使うモデルを 1 行書く（雛形は [templates/CLAUDE.md](templates/CLAUDE.md)）

## 0.2.0

CI の action を Node.js 24 で動く版にそろえる決まりを足した。古い版のままだと、ビルドのたびに「Node.js 20 is deprecated」の警告が出る。

### 内容

- [Distribution](standards/distribution.md) §6：JavaScript の action は Node.js 24 で動く版を使う。`checkout`、`setup-node`、`upload-artifact`、`download-artifact`、`cache`、`rust-cache`、`tauri-action` の版の表と、`setup-node` の `node-version` とは別の話であることを書いた
- この Platform の `check-docs` workflow の `actions/checkout` を `v5` に上げた

### 既存のツールで対応が必要な変更

- **Required**：CI の `actions/checkout@v4`、`actions/setup-node@v4`、`actions/upload-artifact@v4` などを [Distribution](standards/distribution.md) §6 の表の版以上に上げる。Actions の annotation に「Node.js 20 is deprecated」が出ているツールが対象

## 0.1.1

image-library が stockroom に改名したのに合わせて、名前と参照を直した。

### 内容

- すべての Standard、Recommendations、Playbook、ADR、templates の image-library を stockroom に置き換えた。README に旧名とリポジトリの場所を書いた
- `playbook/release.md` の `cargo update -p` を stockroom の crate 名に合わせた
- `playbook/updater-key.md`：鍵のファイル名は改名前のままであることと、owner が違うツールはその owner で鍵を作ることを明記した

### 既存のツールで対応が必要な変更

- なし

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

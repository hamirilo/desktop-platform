# ADR-0002: ルール（desktop-platform）とコード（desktop-base）を 2 つのリポジトリに分ける

**状態**：採用
**日付**：2026-10-11

## 状況

stockroom から切り出す共通コードがある：OS のプロキシ解決（`proxy.rs`）、updater のチェックとダウンロード、ログの配線、single-instance と window-state、`settings.json`、ウィンドウ生成、フロントの `log` / `update` / `titleBar` / `osNotify` / `ime`、テーマトークン、`tauri.conf.json` などの雛形、CI の workflow。Shelf は既に `proxy.rs` を写していて、アプリ名の文字列以外は同じになっている。

これをルールと同じリポジトリに置くか、別にするかを決める。

## 決定

ルールは `desktop-platform`（この リポジトリ、文書だけ）、コードは `desktop-base`（Rust crate、npm package、`template/`、再利用 workflow）に分ける。

desktop-base は **リポジトリの root を npm package、`crate/` を Rust crate** にし、1 つの tag `v*` で両方を固定する。ツールは `Cargo.toml` の `git = ..., tag = ...` と `package.json` の `github:<owner>/desktop-base#v...` で pin する。

## 理由

- 変更の頻度が違う。ルールは滅多に変わらず、コードは切り出すたびに変わる。
- 固定のしかたが違う。ルールは `CLAUDE.md` に参照した tag を書けば足り、コードは Cargo / npm の lockfile で固定する。
- npm の git 依存はリポジトリの root に `package.json` を要求する。文書のリポジトリの root を npm package にするのは分かりにくい。Cargo は名前でサブディレクトリの crate を見つけられるので、`crate/` でよい。
- Web 側の ai-dev-platform と ui-platform の分け方（ルールと実装資産）と同じ形になり、説明が要らない。

退けた案：

- **1 リポジトリ**：solo での運用は楽だが、上の npm の制約と、文書の変更でコードの version が上がる不自然さが残る。
- **workbench の中に base を置く**：workbench 内は path 依存で済むが、stockroom が workbench に依存する向きになる。長く続くなら独立が素直。
- **GitHub Packages に publish**：ui-platform の `application-ui-kit` と同じ形で、後から移れる。最初は git tag 依存で足りる。

## 影響

- desktop-base の最初の中身は、stockroom と Shelf の両方で使っているものだけ：proxy、updater、log の配線、settings、再利用 workflow、template。loopback / MCP / webimport は 2 つ目のツールが必要とするまで stockroom に置く。
- updater のロジックは Rust に寄せ、出口をトレイのメニュー文言（Shelf）と webview へのイベント（stockroom）の 2 つにする。
- 再利用 workflow を private リポジトリ間で呼ぶには、desktop-base の Actions の設定で同じ owner からのアクセスを許可する。
- コマンドは最初は crate から export してツールの `generate_handler!` に並べる。増えてきたら Tauri plugin にする。

## 見直す条件

- ツールが 5 つを超え、desktop-base の破壊的変更を全ツールへ同時に当てるのが負担になった場合（その時は Tauri plugin 化と GitHub Packages を検討）。

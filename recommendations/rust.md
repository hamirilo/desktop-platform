# Rust

`src-tauri/` で使う crate の既定です。掲載条件・拘束力・健全性チェックは [README](README.md) を参照してください。

---

## Tauri plugin

**確認日**：2026-10-11。すべて `tauri-apps/plugins-workspace`（`tauri-plugin-drag` は CrabNebula）の 2 系。使うものは `Cargo.toml`、`package.json`、`capabilities/default.json` の 3 か所に揃えて足す。

| 用途 | plugin | ステータス | 採用 | 備考 |
|---|---|---|---|---|
| OS のダイアログ（確認、ファイル選択） | `tauri-plugin-dialog` | 推奨 | stockroom、Shelf | |
| ログのファイル出力 | `tauri-plugin-log` | 推奨 | stockroom | [Architecture](../standards/architecture.md) §8 の設定で |
| OS の通知 | `tauri-plugin-notification` | 推奨 | stockroom | 10 秒以上の処理の完了 |
| 既定のアプリで開く、Finder / エクスプローラで表示 | `tauri-plugin-opener` | 推奨 | stockroom、Shelf | |
| 再起動（更新後） | `tauri-plugin-process` | 推奨 | stockroom | トレイ常駐は `app.restart()` でよい |
| アプリ内アップデート | `tauri-plugin-updater` | 推奨 | stockroom、Shelf | 必須（[Distribution](../standards/distribution.md) §4） |
| ウィンドウの大きさ・位置の記憶 | `tauri-plugin-window-state` | 推奨 | stockroom | `SIZE \| POSITION \| MAXIMIZED` |
| 二重起動の防止 | `tauri-plugin-single-instance` | 推奨 | stockroom | Builder の **最初** に入れる |
| アプリの外へのドラッグ | `tauri-plugin-drag`（`@crabnebula/tauri-plugin-drag`） | 推奨 | stockroom、Shelf | OS ネイティブのドラッグにはこれが要る |

**使わない**：`tauri-plugin-store`（設定は `settings.json` を自前で読み書きする。[Architecture](../standards/architecture.md) §5）、`tauri-plugin-http`（アプリから URL を取りに行かない。[Security](../standards/security.md) §6）。

---

## SQLite

**既定**：rusqlite（`features = ["bundled"]`） — https://github.com/rusqlite/rusqlite
**ステータス**：推奨 / **確認日**：2026-10-11 / **採用**：stockroom

- `bundled` で SQLite を同梱し、OS のバージョン差を無くす。
- WAL。終了時に書き戻して閉じる（[Architecture](../standards/architecture.md) §6）。
- ORM は使わない。スキーマとクエリは `db.rs` に SQL で書き、テストを同じファイルに置く。
- **使わなくてよい場面**：データが小さい（数百件のパス）。`serde_json` の 1 ファイルでよい（Shelf）。

---

## 画像のデコードとサムネイル

**既定**：image crate（`default-features = false`、使う形式だけ） — https://github.com/image-rs/image
**ステータス**：推奨 / **確認日**：2026-10-11 / **採用**：stockroom

- JPEG / PNG / GIF / WebP / BMP / TIFF は image crate。
- SVG は resvg（`推奨`、同日確認）で長辺を決めてラスタライズ。外部参照は読まない。
- HEIC / HEIF / AVIF は OS のデコーダ（macOS は Image I/O、Windows は WIC と Store の拡張機能）。純 Rust のデコーダを入れない。
- Windows の WebView が表示できない形式（HEIC、TIFF）は表示用の JPEG を別に作る。
- 類似判定は dHash を自前で（`similar.rs`）。

---

## フォント

**既定**：skrifa（解析）、woff2-patched（WOFF2 の展開）、flate2（WOFF）、brotli（展開前のサイズ確認）
**ステータス**：推奨 / **確認日**：2026-10-11 / **採用**：stockroom

- skrifa は resvg が既に使っているので依存が増えない。
- 展開前にヘッダの長さを上限と比べる（[Security](../standards/security.md) §4）。

---

## 並列・ハッシュ・走査・ID

| 用途 | 既定 | ステータス | 採用 |
|---|---|---|---|
| 並列処理（取り込み、サムネイル、書き出し） | rayon | 推奨 | stockroom |
| 重複判定のハッシュ | sha2（SHA-256）+ hex | 推奨 | stockroom |
| フォルダの再帰走査 | walkdir | 推奨 | stockroom |
| ID | uuid（v4） | 推奨 | stockroom |
| 一時ファイル | tempfile | 推奨 | stockroom |

**確認日**：2026-10-11。

---

## クリップボード

**既定**：clipboard-rs — https://github.com/ChurchTao/clipboard-rs
**ステータス**：推奨 / **確認日**：2026-10-11 / **採用**：stockroom

- ファイルと画像データの両方を同時に載せられる。Tauri の clipboard plugin はテキストと画像だけなので使わない。

---

## ローカル HTTP（ブラウザ拡張、MCP）

**既定**：tiny_http — https://github.com/tiny-http/tiny-http
**ステータス**：推奨 / **確認日**：2026-10-11 / **採用**：stockroom

- 1 リクエスト 1 スレッドで足りる規模。tokio / axum / hyper を入れない。
- MCP の JSON-RPC はこの上に自前で書く。`rmcp` などは依存が大きい割に使う部分が少ない。
- 待ち受けと停止は `loopback.rs` に寄せる（[Optional: ローカル受付](../standards/optional/local-server.md)）。

---

## 圧縮ファイルの読み取り

**既定**：zip（`default-features = false`、`deflate-flate2`） — https://github.com/zip-rs/zip2
**ステータス**：推奨 / **確認日**：2026-10-11 / **採用**：stockroom

- Office / iWork の中のプレビューを読むだけ。書き込みはしない。展開後サイズに上限を設ける。

---

## OS の API

| OS | 既定 | 用途 | 採用 |
|---|---|---|---|
| Windows | `windows`（0.62） | WIC、Windows.Data.Pdf、WinHTTP のプロキシ | stockroom、Shelf |
| Windows | `windows-sys` | 軽いフック（キー状態、ウィンドウメッセージ） | Shelf |
| macOS | `objc2-app-kit`、`objc2-foundation`、`block2` | NSApplication、NSPasteboard、ドラッグの検知 | Shelf |
| macOS | `core-foundation-sys` | PAC のプロキシ解決 | stockroom、Shelf |

**確認日**：2026-10-11。`cfg(target_os)` で分け、共通の trait や関数の後ろに隠す。

---

## 非推奨

| もの | 用途 | 理由 | 移行先 |
|---|---|---|---|
| tokio + axum / hyper | ローカル HTTP | 依存とビルド時間が大きく、1 リクエスト 1 スレッドで足りる | tiny_http |
| 純 Rust の HEIC / AVIF デコーダ | 画像 | 特許とビルドの重さ。OS が持っている | OS のデコーダ |
| `tauri-plugin-store` | 設定 | 3 層の置き場（[Architecture](../standards/architecture.md) §5）と合わない | `settings.json` の自前読み書き |

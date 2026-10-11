# Security Standard

デスクトップツールの **信頼境界** は HTTP の認証ではなく、**外から来るファイル**、**Web ビューに読み込むもの**、**127.0.0.1 の待ち受け**、**アップデートの配信** です。ここではその 4 つと、capabilities、ネットワーク、panic を決めます。

## 1. Web ビュー

- `tauri.conf.json` の `app.security.csp` を **必ず設定** する。`null` にしない。既定は次の形：

```json
"csp": {
  "default-src": "'self'",
  "script-src": "'self'",
  "style-src": "'self' 'unsafe-inline'",
  "img-src": "'self' asset: http://asset.localhost data: blob:",
  "font-src": "'self' data:",
  "frame-src": "asset: http://asset.localhost",
  "connect-src": "ipc: http://ipc.localhost",
  "object-src": "'none'",
  "base-uri": "'none'",
  "form-action": "'none'"
}
```

- 開発時に必要な `'unsafe-eval'` と Vite の WebSocket は `devCsp` に分けて書く。本番の CSP に入れない。
- 外のリソースを読み込む機能を足すときは、CSP にその出どころを足す。`*` で開けない。
- リモートの URL をメインウィンドウに読み込まない。Web の内容を見せたいときは別ウィンドウか OS のブラウザ（opener）で開く。

出どころ：stockroom `src-tauri/tauri.conf.json`、commit「CSP を設定する（csp: null をやめる）」。Shelf は `csp: null` のままで、この Standard の最初の Required 差分。

## 2. capabilities

- `src-tauri/capabilities/` にウィンドウごとのファイルを置き、**使う権限だけ** を列挙する。`core:default` に足すのは実際に呼ぶものだけ（`core:window:allow-start-dragging`、`dialog:default` …）。
- 補助ウィンドウ（Shelf の `edge`）には別の capability ファイルを作り、`core:default` だけにする。
- plugin を足したら、その `default` 権限を足す。plugin を外したら権限も外す。

出どころ：stockroom `src-tauri/capabilities/default.json`、Shelf `capabilities/default.json` と `edge.json`。

## 3. asset protocol

- `assetProtocol.scope` は設定ファイルでは **空** にする。
- 表示するファイルは実行時に `asset_protocol_scope().allow_file(path)` で **1 ファイルずつ** 許可する。ディスク全体やホームを開けない。
- ユーザーのデータを 1 つのフォルダで持つツールは、そのフォルダだけを許可してよい。

出どころ：Shelf `src-tauri/src/lib.rs` の `allow_thumbnails`、stockroom `tauri.conf.json`。

## 4. 外から来るファイル

取り込むファイルは **どこから来たか分からない** ものとして扱う。ブラウザ拡張で Web から保存したものも入る。

- ファイルに書かれた大きさ（ヘッダの長さ、zip の展開後サイズ）をそのまま信じず、**上限を設けて読む**。release ビルドは `panic = "abort"` なので、確保の失敗はアプリごと落ちる。
- 拡張子でなく中身で判定する。`.pdf` でも中身が PDF でなければ取り込まない（`<iframe>` でスクリプトが動かないように）。
- SVG の外部参照は読まない。`<image href>` は `data:` URL だけ。
- Web から来たファイルを OS の自動化（Office の変換、Quick Look 以外の外部プロセス）に渡さない。
- 取り込みの受け付け body にも上限を設ける（stockroom は 300 MB）。
- 外からのデータに `unwrap()` を使わない。`Result` で返し、ユーザーに読める形で知らせる。

出どころ：stockroom `docs/ARCHITECTURE.md`「外から来るファイルとセキュリティ」、`src-tauri/src/formats.rs`（`svg_options`）、`files/mod.rs`（`is_pdf`）、`fonts/mod.rs`（WOFF2 の事前チェック）、`webimport.rs`（`MAX_BODY`）。

## 5. ローカル待ち受け

127.0.0.1 で HTTP を待ち受ける場合は [Optional: ローカル受付](optional/local-server.md) に従う。要点は、ループバックだけ、token 必須、`Host` と `Origin` の検査、ペアリングの確認、アプリが動いている間だけ、既定はオフ。

## 6. ネットワーク

- ツールが自分から出る通信は、**updater の feed** と、`decisions/project-context.md` に書いた連携先だけ。テレメトリは送らない。
- プロキシは OS の設定（PAC を含む）をそのまま使う。独自のプロキシ設定画面を作らない。
- Web からのダウンロードが必要なら、ブラウザ拡張にブラウザの Cookie とプロキシ設定で取らせ、アプリは URL を取りに行かない。

出どころ：stockroom `src-tauri/src/proxy.rs`、`src/lib/update.ts`、`webimport.rs` のモジュールコメント。

## 7. アップデートの署名

- 更新ファイルは Tauri Updater の minisign 鍵で署名し、公開鍵を `tauri.conf.json` の `plugins.updater.pubkey` に置く。一致しないものは適用されない。
- `endpoints` は GitHub Releases の https のみ。
- `pubkey` と `endpoints` は人の判断なしに変えない（[Governance](governance.md) §3）。鍵の運用は [アップデートの署名鍵](../playbook/updater-key.md)。

## 8. panic と失敗

- release ビルドは `panic = "abort"`。panic はログに残し（[Architecture](architecture.md) §8）、外からのデータでは起こさない。
- ユーザーに見せるエラーは何が起きて何をすればよいかを日本語で書く。スタックトレースはログにだけ出す。

## 9. 秘密情報

[Governance](governance.md) §6 に従う。

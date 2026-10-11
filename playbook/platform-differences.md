# macOS と Windows の差

片方でだけ起きる問題と、決めてある対処。新しい差に当たったらここに足す。

| 領域 | 差 | 対処 | 出どころ |
|---|---|---|---|
| ドラッグ&ドロップ | Windows では Tauri のファイルドロップ受付と HTML5 DnD が両立しない | アプリ内の DnD は pointer イベントで自前実装 | stockroom README |
| タイトルバー | macOS は Overlay で隠せる。Windows は OS の枠 | macOS だけ `titleBarStyle: "Overlay"` と drag region。Windows は触らない | `src/lib/titleBar.ts` |
| 半透明 | macOS の vibrancy は Windows に無い | `cfg(target_os = "macos")` でサイドバーだけ。Windows は不透明 | `lib.rs` `main_window` |
| メニュー | macOS はアプリメニュー、Windows はウィンドウ上部 | 同じコマンド表から両方を作る。macOS の Edit メニューは標準項目を使う | `src/lib/menuBar.ts` |
| 修飾キー | ⌘ / ⌥ と Ctrl / Alt | コマンド表は `Mod` 表記、表示と README で読み替える | `src/lib/shortcuts.ts` |
| 日本語入力 | macOS の WKWebView は確定の Enter で `isComposing` が false | `keyCode === 229` も見る | `src/lib/ime.ts` |
| HEIC / AVIF | macOS は標準、Windows は Store の拡張機能が要る | OS のデコーダを使い、無いときは README に案内 | README「対応形式」 |
| HEIC / TIFF の表示 | Windows の WebView が表示できない | 表示用の JPEG を `previews/` に作る | `src-tauri/src/formats.rs` |
| PDF / Office のサムネイル | macOS は Quick Look、Windows は PDF だけ `Windows.Data.Pdf` | 作れないときはファイル内のプレビュー、無ければ種類のカード | `src-tauri/src/files/` |
| Office の変換 | Windows だけバックグラウンドで Office に PDF を作らせられる | Web から来たファイルには使わない | `files/win_office.rs` |
| SVG の文字 | Windows に Times New Roman が無いと描かれない | フォント一覧を resvg に渡す | commit「システムに Times New Roman がないと…」 |
| 更新の適用 | Windows はインストーラがアプリを終了させる。macOS は `.app` が差し替わる | Windows は `installMode: "passive"`、macOS は `relaunch` | `src/lib/update.ts` |
| プロキシ | macOS は CFNetwork、Windows は WinHTTP。PAC の評価は updater にできない | `proxy.rs` で OS ごとに解決して updater に渡す | `src-tauri/src/proxy.rs` |
| トレイ常駐 | macOS は Dock に出る。ダイアログが裏に出る | `ActivationPolicy::Accessory`、ダイアログ前に `activateIgnoringOtherApps` | Shelf `lib.rs`、`update.rs` |
| ドラッグ開始の検知 | macOS は NSPasteboard の監視で分かる。Windows に同等の方法が無い | Windows は画面端のウィンドウで代用 | Shelf `drag_watch.rs` |
| コンソール | Windows の release でコンソールが出る | `windows_subsystem = "windows"` | `src-tauri/src/main.rs` |
| Linux（CI） | GTK は枠が付くまで outer size を返さない | `inner_size` に落ちる。Linux は配布しない | Shelf `lib.rs` |
| ログの場所 | `~/Library/Logs/<identifier>/` と `%LOCALAPPDATA%\<identifier>\logs\` | README に両方書く | stockroom README「ログ」 |

# Optional Standard: トレイ常駐

**適用条件**：メニューバー（macOS）/ タスクトレイ（Windows）のアイコンから使い、ウィンドウを常に出しておかないツール（Shelf）。

## ルール

- トレイのメニューは少なくとも「表示 / 非表示」「アップデートを確認…」「終了」を持つ。アイコンの左クリックで表示を切り替え、右クリックでメニュー。tooltip にアプリ名とバージョン。
- **macOS** は `ActivationPolicy::Accessory` にして Dock に出さない。
- ウィンドウの閉じるは **隠すだけ** にし、終了はトレイのメニューから。
- ダイアログを出す前にアプリを前面にする。メニューバーアプリは自分から active にならないので、ダイアログがほかのウィンドウの裏に出る。
- updater は Rust 側で動かし、進捗はトレイのメニュー項目の文言に出す（「ダウンロードしています… 42%」）。トーストを出す場所が無いため。「あとで」で見送った版は、同じ項目を「v`<new>` に更新…」にして、そこから入れられるようにする（[Distribution](../distribution.md) §4.1）。
- 自動の確認は起動の数秒後と、そのあと 24 時間ごと。トレイ常駐はめったに終了されないので、起動時だけでは何日も確認されない。経過は壁時計（`SystemTime`）で測り、1 時間おきに見る。`thread::sleep` はスリープ中に止まるため、1 日まとめて眠ると実際には何日もかかる。「あとで」の版をもう一度聞くのはこの次の確認だけ（[Distribution](../distribution.md) §4.1）。
- 補助ウィンドウ（画面端の細いウィンドウなど）は `decorations: false`、`skip_taskbar`、`focusable: false` にし、別の capability ファイルを持つ。
- ウィンドウの位置はモニタの作業領域と scale factor から計算する。GTK は枠が付くまで outer size を返さないので `inner_size` に落ちる。
- データが小さければ `app_data_dir()` の JSON 1 ファイルでよい。読み込みのたびに存在などの状態を再計算し、ディスクの値を信じない。ユニットテストを同じファイルに置く。
- UI は素の TypeScript でよい（[Stack](../../recommendations/stack.md)）。React を使う規模になったら Standard の本則に戻る。

出どころ：Shelf `src-tauri/src/lib.rs`（`setup_tray`、`create_edge_strip`、`dock_to_right_edge`）、`src-tauri/src/update.rs`（`bring_to_front`、`set_menu`）、`src-tauri/src/shelf.rs`、`capabilities/edge.json`。

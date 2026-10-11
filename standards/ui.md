# UI Standard

デスクトップツールの **見た目と操作の共通ルール** です。Web アプリ向けの Application UI Standard（shadcn/ui、Layout Profile）は使いません。小さなツールが同じ手触りで並ぶことを目的にします。

## 1. テーマ

- **ダークを既定** にする。ウィンドウの `theme` は `"Dark"`、`backgroundColor` はページの背景と同じ色にして起動時の白い一瞬を出さない。
- 色は Tailwind 4 の `@theme` でトークンとして定義し、コンポーネントはトークンだけを使う。

| トークン | 既定 | 用途 |
|---|---|---|
| `--color-bg` | `#1b1c1f` | ウィンドウの背景 |
| `--color-panel` | `#232428` | サイドバー、パネル |
| `--color-raised` | `#2c2d32` | カード、入力欄、ホバー |
| `--color-line` | `#34353b` | 罫線 |
| `--color-fg` | `#e6e6e8` | 文字 |
| `--color-dim` | `#9a9ba3` | 補助の文字 |
| `--color-accent` | `#4c8dff` | 選択、リンク、主ボタン |
| `--color-danger` | `#ef5d5d` | 削除、エラー |
| `--color-success` | `#3ec27f` | 完了 |

- ライトテーマは作らない。必要になったらトークンの差し替えで足す。
- アニメーションは短く（0.2 秒前後）、トーストの出入りと操作の反応にだけ使う。

出どころ：stockroom `src/index.css` の `@theme`、`tauri.conf.json` の window。

## 2. 言語と文言

- UI の文言は日本語。技術用語は英語のままでよい（タグ、フォルダ、PDF）。
- メッセージは短い丁寧体で、何が起きて次に何をすればよいかを書く：「アップデートを確認できませんでした」「最新版です」。
- ドキュメント（README、docs）は常体。
- キーは macOS 表記（⌘、⌥、⇧）で書き、README に「Windows は ⌘ → Ctrl、⌥ → Alt」と 1 行添える。

## 3. キーボード

- 操作はコマンド表から作る（[Architecture](architecture.md) §3）。キーは `"Mod+Shift+R"` の表記で、Mod は macOS で ⌘、Windows で Ctrl。
- 一覧のあるツールは次を揃える：矢印で選択移動、Shift で範囲、⌘A で全選択、Space / Enter で開く、Esc で閉じる・解除、⌘⌫ / Delete でゴミ箱、⌘F で検索、⌘, で設定、`?` でショートカット一覧。
- 1 文字のキー（F、P、B、数字）は一覧の中だけで効かせ、入力欄に文字を打てるようにする。
- 日本語入力の変換中のキーは無視する（`isComposing` / `keyCode 229`）。
- README に「キーボード」の表を置く。

出どころ：stockroom README「キーボード」、`src/lib/shortcuts.ts`、`src/components/ShortcutHelp.tsx`。

## 4. ウィンドウ

- 閉じたときの大きさ・位置・最大化を覚える（`tauri-plugin-window-state`、`SIZE | POSITION | MAXIMIZED`）。フルスクリーンと非表示は覚えない。そのディスプレイが無いときは位置だけ戻さない。
- 最小サイズを決める（stockroom は 900 × 560）。
- 二重起動しない（`tauri-plugin-single-instance`）。2 回目の起動は今のウィンドウを前に出す。
- **macOS** はタイトルバーの帯を無くし（`titleBarStyle: "Overlay"`、`hiddenTitle: true`）、閉じる・最小化・拡大のボタンをページの左上に重ねる。ページは `--titlebar` / `--traffic-lights` の分だけ空け、ツールバーの空いたところとサイドバーの上端を `data-tauri-drag-region` でつかめるようにする。フルスクリーンではボタンが消えるので余白を戻す。
- **Windows** は OS のタイトルバーをそのまま使う。独自のウィンドウ枠を描かない。
- 半透明（vibrancy）は macOS だけ、サイドバーにだけ使ってよい。裏にあるときは不透明にする。

出どころ：stockroom `src-tauri/src/lib.rs`（`main_window`、plugin の配線）、`src/lib/titleBar.ts`、`tauri.conf.json`。

## 5. フィードバック

| 状況 | 出し方 |
|---|---|
| 操作の結果（取り込んだ件数、移動した） | トースト。戻せる操作には「元に戻す」を付ける |
| エラー | トースト（赤）。結果のトーストをエラーの後に出さない |
| 1 秒以上かかる処理 | 進捗バー。途中で取り消せる |
| 10 秒以上かかり、終わったときにウィンドウが前に無い | OS の通知（`tauri-plugin-notification`）。ウィンドウが前にあるときはトーストだけ |
| 評価やお気に入りなどの軽い操作 | 一瞬の HUD |
| 完全削除、ペアリングの許可、更新の適用 | OS のダイアログ（`tauri-plugin-dialog`）。ボタンの文言は動詞で：「更新して再起動」「あとで」 |

- 処理中もウィンドウは固まらない（[Architecture](architecture.md) §4）。
- トーストは画面の右下、同時に出す数は 3 つ程度。

出どころ：stockroom `src/store.ts`（`toast` / `notify`）、`src/components/Toasts.tsx`、`src/components/ActionHud.tsx`、`src/lib/osNotify.ts`。

## 6. ドラッグ&ドロップ

- **アプリの中** の並べ替えやフォルダへのドロップは HTML5 DnD でなく **pointer イベント** で実装する。Windows では Tauri のファイルドロップ受付と HTML5 DnD が両立しない。
- **OS からのドロップ**（Finder / エクスプローラ）は Tauri のファイルドロップイベントで受ける。
- **アプリの外へのドラッグ**（ほかのアプリへ渡す）は `tauri-plugin-drag` で OS ネイティブのドラッグにする。
- ドロップできる場所はドラッグ中に見て分かるようにする（枠の強調、空白の案内）。

出どころ：stockroom README「構成」の注記、`src/components/DragLayer.tsx`。Shelf `src/main.ts`。

## 7. 一覧

- 1 万件でも固まらないよう、仮想スクロールで描く（`@tanstack/react-virtual`）。位置の計算は `lib/layouts.ts` のような純粋関数に寄せ、プレビューと出力で同じ計算を使う。
- 選択は クリック / Shift+クリック / ⌘+クリック / 空白からの範囲ドラッグ の 4 つ。
- 右クリックメニューは 1 段。よく使う小さな操作（回転、お気に入り）はアイコンを横 1 行に並べる。
- グループ分けと並び替えは表示の好みとして `localStorage` に覚える。

出どころ：stockroom `src/components/Grid.tsx`、`src/lib/layouts.ts`、`docs/MENUS.md`。

## 8. アイコン

- UI のアイコンは `lucide-react`。
- アプリのアイコンは `app-icon.svg` をリポジトリに置き、`npx tauri icon app-icon.svg` で `src-tauri/icons/` を生成する。生成物も commit する。

出どころ：Shelf README「構成」。

## 9. 設定とヘルプ

- 設定は ⌘, の 1 つのダイアログにまとめ、「一般」「連携」のようにタブで分ける。散らばらせない。
- ヘルプメニューに「ショートカット一覧」「ログを表示」「アップデートを確認…」を置く。
- 初回起動には「作る / 開く」だけの Welcome 画面を出し、説明書きは最小にする。

出どころ：stockroom `src/components/SettingsDialog.tsx`、`src/components/Welcome.tsx`、`docs/SETTINGS.md`。

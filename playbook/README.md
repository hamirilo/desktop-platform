# Playbook

**どう作る・出す・直すか** の手順です。具体例、command、checklist、troubleshooting を置きます。判断と制約は [Standards](../standards/)、現時点の選択は [Recommendations](../recommendations/) が正本で、ここへ重複して書きません。

| Playbook | 使うとき |
|---|---|
| [新しいツールを作る](new-tool.md) | ツールを 1 つ起こす。置き場所、雛形、最初のリリースまでの checklist |
| [リリース](release.md) | バージョンを上げて配布する。単独リポジトリと同居リポジトリの両方 |
| [アップデートの署名鍵](updater-key.md) | 鍵の生成、保管、Secrets、鍵なしのビルド、作り直し |
| [ブラウザで UI を作る](ui-in-browser.md) | Rust を動かさずに画面だけ作る。モックの保ち方 |
| [macOS と Windows の差](platform-differences.md) | 片方でだけ起きる問題と、決めてある対処 |

Task に必要な Playbook だけを読む。

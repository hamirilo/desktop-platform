# Standards

デスクトップツールで **何を守るか** を決めます。Core はすべてのツールに適用し、Optional はその機能を持つときだけ適用します。区分の基準は [ADR-0003](../decisions/adr-0003-core-and-optional-standards.md) を正とします。

各 Standard は、ルールのあとに **出どころ** を書いています。stockroom と Shelf で実際に守られている実装を指しているので、迷ったらそのファイルを読んでください。

## Core

| Standard | 内容 | 読むとき |
|---|---|---|
| [Governance](governance.md) | Git、AI 利用、機械的 gate、逸脱の記録、秘密情報 | すべての Task |
| [Architecture](architecture.md) | 層と依存の向き、ディレクトリ、コマンド表、IPC、設定とデータの置き場、ログ、テスト、ドキュメント | 実装に触れる Task |
| [Security](security.md) | CSP、capabilities、asset protocol、外から来るファイル、ネットワーク、updater の署名 | 設定ファイル、ファイル入力、通信に触れる Task |
| [Distribution](distribution.md) | 対象 OS、識別子、署名なし配布、アプリ内アップデート、リリース、CI | 配布・リリース・CI に触れる Task |
| [UI](ui.md) | テーマ、言語、キーボード、ウィンドウ、フィードバック、ドラッグ&ドロップ、一覧、レイアウトの安定 | 画面に触れる Task |

## Optional

| Standard | 適用条件 |
|---|---|
| [ローカル受付](optional/local-server.md) | ツールが 127.0.0.1 で HTTP を待ち受ける（ブラウザ拡張、MCP、他アプリ連携） |
| [複数ツール同居リポジトリ](optional/multi-tool-repo.md) | 1 リポジトリに複数のツールを置く |
| [トレイ常駐](optional/tray-app.md) | メニューバー / タスクトレイのアイコンから使うツール |

## 逸脱

Standard から外れる場合は、そのツールの `decisions/` に ADR を残す（[Governance](governance.md) §5）。Recommendation から外れる場合は PR の説明に理由を書けば足りる。

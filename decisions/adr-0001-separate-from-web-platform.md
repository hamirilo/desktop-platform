# ADR-0001: Web アプリ向けの ai-dev-platform と分け、参照も共有もしない

**状態**：採用
**日付**：2026-10-11

## 状況

Django / PostgreSQL / React Islands の Web アプリ開発は `ai-dev-platform`（Standards / Playbook の submodule と Recommendations）で基準を管理している。一方で、image-library を起点に Tauri のデスクトップツールを複数作る予定があり、その基準の置き場が無い。

ai-dev-platform の Architecture Standard は Django、PostgreSQL、認証・認可、container boundary が前提で、デスクトップツールには当てはまらない項目が大半である。また、利用している `jazmf-dx/ai-dev-platform` は upstream（hamirilo）の fork であり、fork では独自の version を切らず内容を増やさない運用（upstream の ADR-0005、release.md）になっている。

## 決定

デスクトップツールの基準は **独立したリポジトリ `desktop-platform`** に置く。ai-dev-platform と ai-dev-standards を参照せず、Governance を含めて自立した内容にする。語彙（Standards / Recommendations / Playbook / Project Context、ONBOARDING、Core / Optional、成熟の段階）と構造だけを揃える。

## 理由

- fork した Platform に内容を足すと、upstream との同期と fork 運用のルールに反する。
- Django 前提の Standard を「デスクトップでは該当なし」で読み替えさせるより、デスクトップの信頼境界（外から来るファイル、127.0.0.1、配信）に合った Standard を書くほうが短く正確になる。
- 語彙を揃えるのは、人と AI が Web と デスクトップを行き来するときに読み方を変えなくて済むため。

退けた案：

- **ai-dev-platform に Project Context の行や `recommendations/desktop.md` を足す**：fork 運用に反する。upstream に提案する価値はあるが、デスクトップの基準の正本にはならない。
- **参照だけ張る（Governance を ai-dev-standards にリンク）**：片方の変更がもう片方に影響し、「別軸」でなくなる。Governance は短いので書き直すほうが安い。

## 影響

- 各デスクトップツールの `CLAUDE.md` は `desktop-platform/ai/ONBOARDING.md` だけを読む。ai-dev-platform の ONBOARDING を併読させない。
- Web と共通の判断（Git、AI 利用、依存の健全性チェック）は両方に書かれる。意図的な重複であり、内容が離れても構わない。
- image-library と workbench は `CLAUDE.md` と `decisions/project-context.md` を持たないので、Adopt going forward で足す。

## 見直す条件

- upstream の ai-dev-platform が「Application 種別」で Standard を切り替える構造になった場合。
- デスクトップツールがサーバーと通信する業務アプリになり、認証・認可の Standard が要る場合。

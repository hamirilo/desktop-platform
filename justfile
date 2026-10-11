set shell := ["bash", "-c"]

# デフォルトタスク
default:
	@just --list

# Markdown のリンク切れチェック（lychee、offline）
check-docs:
	@echo "Running document link checks..."
	lychee "./**/*.md" --offline --no-progress

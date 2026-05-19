#!/usr/bin/env bash
set -euo pipefail

REPO="zixuandai0217/MySkills"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
API_BASE="https://api.github.com/repos/${REPO}/contents"

TARGET_DIR="${1:-.}"

fetch() {
  if command -v curl &>/dev/null; then
    curl -fsSL "$1"
  elif command -v wget &>/dev/null; then
    wget -qO- "$1"
  else
    echo "错误: 需要 curl 或 wget" >&2
    exit 1
  fi
}

download_dir() {
  local api_path="$1"
  local local_base="$2"

  local listing
  listing=$(fetch "${API_BASE}/${api_path}?ref=${BRANCH}")

  echo "$listing" | python3 -c "
import sys, json
for item in json.load(sys.stdin):
    print(item['type'], item['path'])
" | while read -r type path; do
    if [ "$type" = "dir" ]; then
      mkdir -p "${local_base}/${path}"
      download_dir "$path" "$local_base"
    else
      echo "  下载: ${path}"
      mkdir -p "${local_base}/$(dirname "$path")"
      fetch "${RAW_BASE}/${path}" > "${local_base}/${path}"
    fi
  done
}

echo "=== MySkills 安装脚本 ==="
echo "目标目录: $(cd "$TARGET_DIR" && pwd)"
echo ""

echo "[1/2] 下载 AGENTS.md ..."
fetch "${RAW_BASE}/AGENTS.md" > "${TARGET_DIR}/AGENTS.md"
echo "  完成"

echo "[2/2] 下载 .agents/ 目录 ..."
mkdir -p "${TARGET_DIR}/.agents"
download_dir ".agents" "$TARGET_DIR"
echo "  完成"

echo ""
echo "=== 安装完成! ==="
echo "文件已下载到: $(cd "$TARGET_DIR" && pwd)"

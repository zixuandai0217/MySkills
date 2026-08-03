#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-zixuandai0217/MySkills}"
BRANCH="${BRANCH:-main}"
TARBALL_URL="${TARBALL_URL:-https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz}"

TARGET_DIR="${1:-.}"
mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
TMP_DIR="$(mktemp -d)"

# When true, backup existing destinations before overwrite
BACKUP="${BACKUP:-1}"

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "=== MySkills 安装脚本 (tarball 模式) ==="
echo "目标目录: ${TARGET_DIR}"
echo "备份: ${BACKUP}"
echo ""

prepare_destination() {
  local path="$1"
  if [ ! -e "$path" ]; then
    return 0
  fi
  if [ "$BACKUP" != "1" ]; then
    rm -rf "$path"
    return 0
  fi
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  local dest="${path}.bak.${stamp}"
  mv "$path" "$dest"
  echo "  已备份: $path -> $dest"
}

echo "[1/3] 下载仓库归档 ..."
if command -v curl &>/dev/null; then
  curl -fsSL --retry 3 --retry-delay 3 "$TARBALL_URL" -o "${TMP_DIR}/repo.tar.gz"
elif command -v wget &>/dev/null; then
  wget -qO "${TMP_DIR}/repo.tar.gz" "$TARBALL_URL"
else
  echo "错误: 需要 curl 或 wget" >&2
  exit 1
fi
echo "  完成 ($(du -h "${TMP_DIR}/repo.tar.gz" | cut -f1) 已下载)"

echo "[2/3] 解压 ..."
tar -xzf "${TMP_DIR}/repo.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR="${TMP_DIR}/MySkills-${BRANCH}"
if [ ! -d "$EXTRACTED_DIR" ]; then
  EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d ! -path "$TMP_DIR" | head -1)"
fi

if [ ! -d "${EXTRACTED_DIR}/.agents/skills" ]; then
  echo "错误: 归档中未找到 .agents/skills" >&2
  exit 1
fi

echo "[3/3] 安装文件 ..."

if [ -d "${TARGET_DIR}/.agents" ]; then
  prepare_destination "${TARGET_DIR}/.agents"
fi
mkdir -p "${TARGET_DIR}/.agents"
cp -R "${EXTRACTED_DIR}/.agents/skills" "${TARGET_DIR}/.agents/skills"
SKILL_COUNT="$(find "${TARGET_DIR}/.agents/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
echo "  已安装: .agents/skills/ (${SKILL_COUNT} 个技能包)"

echo ""
echo "=== 安装完成! ==="
echo "文件已下载到: ${TARGET_DIR}"
echo ""
if [ -d "${TARGET_DIR}/.agents/skills" ]; then
  echo "已安装的技能包 (.agents):"
  ls "${TARGET_DIR}/.agents/skills/" | sed 's/^/  - /'
fi
echo ""
echo "提示:"
echo "  - 关闭备份: BACKUP=0 bash install.sh"

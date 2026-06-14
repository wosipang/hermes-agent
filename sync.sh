#!/bin/bash
# Hermes 同步脚本 — 从上游拉取更新，合入本地补丁，推到 fork，然后 hermes update
# 用法: ./sync.sh 或 bash sync.sh

set -e
cd "$(dirname "$0")"

echo "=== 1/4 拉取上游 (NousResearch) ==="
git fetch upstream main

echo ""
echo "=== 2/4 合入上游更新 ==="
LOCAL_PATCHES=$(git log origin/main..HEAD --oneline | wc -l)
echo "本地补丁: $LOCAL_PATCHES 个 commit"

git merge upstream/main --no-edit
if [ $? -ne 0 ]; then
    echo "⚠ 有冲突，请手动解决后 git merge --continue"
    exit 1
fi

echo ""
echo "=== 3/4 推到 fork ==="
git push origin main

echo ""
echo "=== 4/4 执行 hermes update ==="
hermes update

echo ""
echo "✓ 同步完成"
git log --oneline -3

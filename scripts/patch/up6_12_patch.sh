#!/bin/bash

# --- 配置 ---
# OpenWrt 源码目录
OPENWRT_DIR="."
# GitHub Pull Request 编号
PR_NUMBER="21010"


# --- 脚本主体 (请勿修改以下内容) ---
# 根据 PR 编号生成相关变量
PATCH_FILE="${PR_NUMBER}.patch"
PATCH_URL="https://github.com/openwrt/openwrt/pull/${PR_NUMBER}.patch"

# 检查脚本是否在 OpenWrt 源码的根目录下运行
if [ ! -f "feeds.conf.default" ]; then
    echo "❌ Error: Please run this script from the root of your OpenWrt source directory."
    exit 1
fi

echo "Downloading patch: ${PATCH_FILE}..."
# 使用 curl 静默下载补丁，但如果发生错误会显示出来
# -sS: 静默模式，但显示错误
# -L:  跟随重定向
# -o:  指定输出文件
curl -sS -L -o "$PATCH_FILE" "$PATCH_URL"

# 检查上一条命令 (curl) 的退出状态码
# 在 shell 中，$? 代表上一条命令的退出状态码，0 通常代表成功
if [ $? -eq 0 ]; then
  echo "✔ Patch downloaded successfully: ${PATCH_FILE}"
else
  echo "❌ Error: Patch download failed. Please clean up any residual files and try again."
  # 如果下载失败，也删除可能已创建的空文件或不完整文件
  rm -f "$PATCH_FILE"
  exit 1
fi

echo "Applying patch..."
# 使用 git apply 命令应用补丁
git apply "$PATCH_FILE"

# 检查 git apply 命令是否成功执行
if [ $? -eq 0 ]; then
  echo "✔ Patch applied successfully!"
  # 任务成功后，清理临时的补丁文件
  rm "$PATCH_FILE"
  echo "✔ Temporary patch file has been removed."
else
  echo "❌ Error: Failed to apply patch. Please check for conflicts."
  echo "  Note: The patch file ${PATCH_FILE} has been kept for manual inspection."
  exit 1
fi

echo "🎉 Script finished successfully."
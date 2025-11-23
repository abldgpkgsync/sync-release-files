#!/bin/bash

set -euo pipefail

echo "🔧 开始安装依赖工具（jq、gh）"

# 更新 apt 源

sudo apt-get update -y

# 安装 jq（解析 JSON）

if ! command -v jq &>/dev/null; then

  sudo apt-get install -y jq

  echo "✅ jq 安装完成"

else

  echo "✅ jq 已存在，跳过安装"

fi

# 安装 GitHub CLI（gh）

if ! command -v gh &>/dev/null; then

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

  echo "deb \[arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt-get update -y

  sudo apt-get install -y gh

  echo "✅ gh 安装完成"

else

  echo "✅ gh 已存在，跳过安装"

fi

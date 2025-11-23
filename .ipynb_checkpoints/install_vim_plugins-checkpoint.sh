#!/bin/bash

# 设置变量
REPO_URL="https://github.com/guoxiangchen/vim-setup.git"
TMP_DIR="$HOME/tmp_vim_repo"
BACKUP_DIR="$HOME/vim_backup"

# 创建临时目录和备份目录
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR" "$BACKUP_DIR"

# 克隆 GitHub 仓库到临时目录
git clone "$REPO_URL" "$TMP_DIR"

# 拷贝 ftplugin 和 UltiSnips 到 ~/.vim/ 并备份
mkdir -p ~/.vim/ftplugin ~/.vim/UltiSnips
cp -r "$TMP_DIR/ftplugin/." ~/.vim/ftplugin/
cp -r "$TMP_DIR/UltiSnips/." ~/.vim/UltiSnips/

mkdir -p "$BACKUP_DIR/ftplugin" "$BACKUP_DIR/UltiSnips"
cp -r "$TMP_DIR/ftplugin/." "$BACKUP_DIR/ftplugin/"
cp -r "$TMP_DIR/UltiSnips/." "$BACKUP_DIR/UltiSnips/"

# 清理临时目录
rm -rf "$TMP_DIR"

 "ftplugin 和 UltiSnips 已安装到 ~/.vim/ 并备份到 ~/vim_backup/"

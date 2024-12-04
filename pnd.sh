#!/bin/bash

# 必要なコマンドのリスト
commands=("grep" "awk" "df" "lsof" "sort" "uniq" "column" "dmidecode")

# コマンドの存在確認
for cmd in "${commands[@]}"; do
    if ! which "$cmd" > /dev/null 2>&1; then
        echo "エラー: $cmd コマンドが見つかりません。"
        exit 1
    fi
done

# サーバー情報の出力
echo -e "## CPU情報"
grep "model name" /proc/cpuinfo | head -1

echo -e "\n## メモリ情報"
awk '/MemTotal/ { printf "合計メモリ: %.2f GB\n", $2 / 1024 / 1024 }' /proc/meminfo

echo -e "\n## ディスク使用量"
df -h

echo -e "\n## リッスンポート"
lsof -i -P -n -l | grep "LISTEN" | awk '{print $1 "," $3 "," $9 "/" $8}' | sort | uniq | column -t -s ","

echo -e "\n## ハードウェア情報"
dmidecode | grep -A 8 "System Information"
echo
dmidecode | grep -A 4 "DDR"

echo -e "\n## BIOS情報"
dmidecode | grep -A 27 "BIOS Information"

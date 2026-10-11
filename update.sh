#!/bin/bash
# ANT tashrif boti — serverda yangilash (GitHubdagi oxirgi versiyani olish)
# Ishga tushirish:   sudo bash /opt/ant_bot/update.sh
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
[ "$(id -u)" -eq 0 ] || { echo "Root sifatida ishga tushiring:  sudo bash $DIR/update.sh"; exit 1; }

if [ -d .git ]; then
    echo "== GitHubdan oxirgi versiya olinmoqda..."
    git config --global --get-all safe.directory 2>/dev/null | grep -qx "$DIR" \
        || git config --global --add safe.directory "$DIR"
    git fetch origin main
    # serverdagi kod har doim GitHubdagi bilan bir xil bo'ladi (.env va baza tegilmaydi)
    git reset --hard origin/main
else
    echo "== Git yo'q: bot faqat qayta ishga tushiriladi"
fi

sed -i 's/\r$//' requirements.txt
venv/bin/pip install -q -r requirements.txt
chown -R antbot:antbot "$DIR"
systemctl restart ant-bot
sleep 6
echo ""
if systemctl is-active --quiet ant-bot; then
    echo "✅ Bot yangilandi va ishlayapti."
else
    echo "❌ Bot ishga tushmadi. Quyidagi yozuvlarni Claude'ga yuboring:"
fi
echo ""
journalctl -u ant-bot -n 10 --no-pager

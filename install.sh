#!/bin/bash
# ANT tashrif boti — Linux serverga o'rnatish (Ubuntu / Debian)
# Ishga tushirish:   sudo bash /opt/ant_bot/install.sh
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
[ "$(id -u)" -eq 0 ] || { echo "Root sifatida ishga tushiring:  sudo bash $DIR/install.sh"; exit 1; }

echo "== 1/5 Kerakli dasturlar o'rnatilmoqda..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -y -qq
apt-get install -y -qq python3 python3-venv git tzdata >/dev/null

echo "== 2/5 Sozlamalar (.env) tekshirilmoqda..."
if [ ! -f .env ]; then
    echo ".env fayli topilmadi — hozir yaratamiz."
    read -rp "  Bot tokeni (BotFather bergan): " TOKEN
    read -rp "  Sizning Telegram ID ingiz (bot egasi): " OWNER
    printf 'BOT_TOKEN=%s\nOWNER_ID=%s\nTIMEZONE=Asia/Tashkent\nDB_PATH=ant_bot.db\n' "$TOKEN" "$OWNER" > .env
fi
# Windows'da yozilgan fayllardagi ortiqcha belgilarni tozalash
sed -i 's/\r$//' .env requirements.txt
sed -i '1s/^\xEF\xBB\xBF//' .env
grep -q '^BOT_TOKEN=..*' .env || { echo "❌ .env faylida BOT_TOKEN yozilmagan"; exit 1; }

echo "== 3/5 Bot kutubxonalari o'rnatilmoqda..."
python3 -m venv venv
venv/bin/pip install -q --upgrade pip
venv/bin/pip install -q -r requirements.txt

echo "== 4/5 Avtomatik ishga tushish sozlanmoqda..."
# bot alohida, cheklangan foydalanuvchi nomidan ishlaydi (xavfsizlik uchun)
id antbot >/dev/null 2>&1 || useradd --system --home-dir "$DIR" --shell /usr/sbin/nologin antbot
chown -R antbot:antbot "$DIR"
chmod 600 .env
cat > /etc/systemd/system/ant-bot.service <<UNIT
[Unit]
Description=ANT tashrif boti
After=network-online.target
Wants=network-online.target

[Service]
User=antbot
WorkingDirectory=$DIR
ExecStart=$DIR/venv/bin/python bot.py
Restart=always
RestartSec=10
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable ant-bot >/dev/null 2>&1
systemctl restart ant-bot

# keyingi yangilanishlar (update.sh) GitHubdan olinishi uchun
if [ -d .git ]; then
    git config --global --get-all safe.directory 2>/dev/null | grep -qx "$DIR" \
        || git config --global --add safe.directory "$DIR"
    git config --global credential.helper store
fi

echo "== 5/5 Tekshirilmoqda..."
sleep 8
echo ""
if systemctl is-active --quiet ant-bot; then
    echo "✅ TAYYOR! Bot serverda ishlayapti."
    echo "   Telegramda sizga «🟢 Bot ishga tushdi» xabari keladi."
else
    echo "❌ Bot ishga tushmadi. Quyidagi yozuvlarni Claude'ga yuboring:"
fi
echo ""
journalctl -u ant-bot -n 10 --no-pager

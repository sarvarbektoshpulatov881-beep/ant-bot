# ANT tashrif-eslatma boti

Operator mijoz bilan gaplashib, tashrif kuni va vaqtini botga kiritadi. Bot sotuvchilar guruhiga:

1. **Darhol** xabar beradi: "🆕 Yangi tashrif belgilandi"
2. **1 kun oldin** eslatadi: "⏰ Mijoz kelishiga 1 kun qoldi"
3. **1 soat oldin** eslatadi: "⏰ Mijoz kelishiga 1 soat qoldi"
4. **Har kuni 09:00 da** bugungi tashriflar ro'yxatini yuboradi

Mijoz kelganda sotuvchi **"✅ Mijoz keldi"** tugmasini bosadi, operatorga ham xabar boradi.
Eslatma vaqtlari `.env` faylida o'zgartiriladi.

## Buyruqlar

| Buyruq | Kim uchun | Nima qiladi |
|---|---|---|
| /yangi | Operator (botga shaxsiy yozishmada) | Yangi tashrif kiritish: mijoz → telefon → sana → vaqt → izoh |
| /bugun | Hamma | Bugungi tashriflar |
| /royxat | Hamma (bekor qilish faqat operatorga) | Kelgusi tashriflar |
| /bekor | Operator | Kiritishni yarmida to'xtatish |
| /id | Hamma | Chat ID ni ko'rsatadi (sozlash uchun) |

Sanani `13.10`, `13-oktabr`, `13 okt` ko'rinishida yozish mumkin yoki "Bugun / Ertaga / Indinga" tugmasini bosish mumkin.
Vaqtni `13:00`, `13.00`, `13;00` yoki shunchaki `13` deb yozish mumkin.
Vaqt o'zgarsa: /royxat dan eskisini bekor qilib, /yangi bilan qaytadan kiriting.

## Sinov uchun kompyuterda ishga tushirish

1. **Python 3.10 yoki yangisini** o'rnating (python.org). Windows da o'rnatishda "Add Python to PATH" belgisini qo'ying.
2. Telegramda **@BotFather** ga yozing → `/newbot` → botga nom bering → **token** ni nusxalab oling.
3. Telegramda **"ANT sotuvchilar"** guruhini oching, sotuvchilarni va botni guruhga qo'shing.
4. Bot papkasida `.env.example` faylini **`.env`** nomi bilan nusxalang va `BOT_TOKEN=` ga tokenni yozing.
5. Papkada terminal (Windows: cmd) ochib:
   ```
   pip install -r requirements.txt
   python bot.py
   ```
6. Guruhda **/id** yozing → chiqqan raqamni (`-100...`) `.env` dagi `SELLERS_CHAT_ID=` ga yozing.
   Operator botga shaxsiy **/id** yozadi → "Sizning ID" raqamini `OPERATOR_IDS=` ga yozing (bir nechta bo'lsa vergul bilan).
7. Botni to'xtating (Ctrl+C) va qayta `python bot.py` qiling.
8. Sinov: operator botga **/yangi** yozib, 2–3 daqiqa keyingi tashrif kiritadi va guruhga xabar kelganini tekshiradi.
   Tez sinash uchun `.env` da vaqtincha `REMINDER_MINUTES=2,1` qo'yish mumkin.

⚠️ Sinov paytida bot faqat kompyuter yoqiq va `python bot.py` ishlab turgan paytda ishlaydi.
Ma'lumotlar `ant_bot.db` faylida saqlanadi, uni o'chirmang.

## Serverga ko'chirish (sinovdan o'tgandan keyin)

Linux serverga (VPS) papkani `.env` va `ant_bot.db` bilan birga ko'chiring, so'ng:

```
sudo apt install -y python3-venv
cd /opt/ant_bot
python3 -m venv venv && venv/bin/pip install -r requirements.txt
```

Bot o'chib qolsa avtomatik qayta yonishi uchun `/etc/systemd/system/ant-bot.service`:

```
[Unit]
Description=ANT tashrif-eslatma boti
After=network-online.target

[Service]
WorkingDirectory=/opt/ant_bot
ExecStart=/opt/ant_bot/venv/bin/python bot.py
Restart=always

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl enable --now ant-bot
sudo systemctl status ant-bot
```

Muhim: bir vaqtda bot faqat **bitta joyda** ishlashi kerak. Serverda yoqishdan oldin kompyuterdagisini to'xtating.

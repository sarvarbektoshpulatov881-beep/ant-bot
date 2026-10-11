# ANT tashrif-eslatma boti

Operator mijozni do'konga taklif qiladi va tashrifini botga kiritadi. Sotuvchilar mijoz kelganda natijani belgilaydi. Bot eslatma beradi, egasiga esa har kuni hisobot yuboradi.

## Rollar

| Rol | Vazifasi |
|---|---|
| 🎧 Operator | Mijoz kiritadi (ism, telefon, hudud, sana, vaqt, izoh, sotuvchi), vaqtni o'zgartiradi, bekor qiladi, kelmagan mijozni qayta taklif qiladi |
| 🛒 Sotuvchi | ✅ Keldi → 🛍 Sotib oldi (summa) / 🚫 Sotib olmadi (sabab), ❌ Kelmadi |
| 👑 Egasi | Hammasi + 📊 Hisobot, 📥 Excel, 👥 jamoani boshqarish |

## Bot nimalarni yuboradi

Hammasi bot ichida ishlaydi, Telegram guruh kerak emas.

- Sotuvchiga (biriktirilgan bo'lsa unga, aks holda barcha sotuvchilarga): yangi tashrif, 1 kun va 1 soat oldin eslatma, vaqtdan 1 soat o'tib "❓ Mijoz keldimi?". Bir sotuvchi belgilasa, boshqalardagi tugmalar o'zi yo'qoladi
- Butun jamoaga: har kuni 09:00 da bugungi ro'yxat
- Operatorga: natija haqida xabar, kelmagan mijoz uchun "Qayta taklif qilish" tugmasi
- Egasiga: har kuni 23:00 da kunlik hisobot (keldi/kelmadi, tushum, eng ko'p xarid qilgan mijozlar, operatorlar, hududlar, sabablar)

## Jamoaga odam qo'shish

👥 Adminlar → **➕ Operator qo'shish** yoki **➕ Sotuvchi qo'shish** → chiqqan havolani xodimga yuboring (bir martalik, 24 soat). Yoki xodim botga /start yozadi, sizga so'rov keladi.

## Fayllar

| Fayl | Nima |
|---|---|
| bot.py | Botning o'zi |
| requirements.txt | Kerakli kutubxonalar |
| .env | Token va sozlamalar (`.env.example` dan nusxa) — hech kimga bermang |
| ant_bot.db | Barcha ma'lumotlar (tashriflar, jamoa) — vaqti-vaqti bilan nusxa oling |
| start_bot.bat | Windows'da avtomatik ishga tushirish (Startup papkasiga qo'yiladi) |
| install.sh | Linux serverga o'rnatish skripti |
| update.sh | Serverda GitHubdan yangilash skripti |

## Windows kompyuterda

1. Python 3.13 o'rnating ("Add python.exe to PATH" belgisi bilan).
2. Papkani `C:\ant_bot\ant_bot` ga qo'ying, `.env` faylida `BOT_TOKEN=` ni to'ldiring.
3. Shu papkada `cmd` → `pip install -r requirements.txt`
4. `start_bot.bat` ni **Windows + R → shell:startup** papkasiga qo'ying va ishga tushiring.
5. Botga birinchi bo'lib **egasi** /start yozadi.

⚠️ Bot faqat **bitta joyda** ishlashi kerak (aks holda "Conflict" xatosi).

## Yangilash (kompyuterda)

Bot oynasini yoping → yangi `bot.py` ni almashtiring → (requirements o'zgargan bo'lsa `pip install -r requirements.txt`) → `start_bot.bat`.
Keyin GitHubga saqlang: `git add .` → `git commit -m "izoh"` → `git push`.

## Zaxira nusxa va tiklash

- Har kuni hisobotdan keyin bot egasiga **bazaning zaxira nusxasini** (`.db` fayl) yuboradi. O'chirish: `.env` da `BACKUP_DAILY=0`.
- Istalgan payt: `/zaxira` yoki 📊 Hisobot → **💾 Zaxira nusxa**.
- **Tiklash:** zaxira faylini botga oddiy fayl qilib yuboring → bot tekshiradi → **✅ Ha, tiklash**. Oldingi baza alohida faylga saqlab qo'yiladi.
- Bot ishga tushganda egasiga «🟢 Bot ishga tushdi — qayerda» xabari keladi. Ikki xil joydan kelsa — bot ikki joyda ishlayapti.

## Linux serverga ko'chirish (Ubuntu 22.04 / 24.04)

Botga faqat chiquvchi internet kerak (api.telegram.org, 443-port). Kiruvchi port ochish shart emas.

1. **Kompyuterdagi botni to'xtating:** «ANT tashrif boti» oynasini yoping va `shell:startup` dagi `start_bot.bat` ni **o'chiring** (aks holda kompyuter yoqilganda yana ishga tushib, server bilan to'qnashadi).
2. **Papkani serverga ko'chiring** (Windows cmd da; `.env` va baza ham birga ketadi):
   ```
   scp -r C:\ant_bot\ant_bot root@SERVER_IP:/opt/
   ```
3. **Serverga kiring va o'rnating:**
   ```
   ssh root@SERVER_IP
   sed -i 's/\r$//' /opt/ant_bot/*.sh
   bash /opt/ant_bot/install.sh
   ```
4. Telegramda «🟢 Bot ishga tushdi» xabari keladi (qayerda: server nomi) → botga `/start` yozib tekshiring.

### Serverda boshqarish

| Nima | Buyruq |
|---|---|
| Holatini ko'rish | `systemctl status ant-bot` |
| Oxirgi yozuvlar (log) | `journalctl -u ant-bot -n 50` |
| Qayta ishga tushirish | `systemctl restart ant-bot` |
| To'xtatish | `systemctl stop ant-bot` |
| GitHubdan yangilash | `bash /opt/ant_bot/update.sh` |

### GitHubdan yangilash (birinchi marta)

Repozitoriy yopiq (Private), shuning uchun server bir marta ruxsat so'raydi:
1. GitHub → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**.
2. **Repository access:** Only select repositories → `ant-bot`. **Permissions → Contents: Read-only**. Generate → tokenni nusxalang.
3. Serverda `bash /opt/ant_bot/update.sh` → **Username:** GitHub login, **Password:** shu token. Keyingi safar so'ramaydi.

## .env sozlamalari (ixtiyoriy)

| Sozlama | Standart | Ma'nosi |
|---|---|---|
| OWNER_ID | — | Bot egasining Telegram ID si (bo'sh bo'lsa — birinchi /start yozgan) |
| REMINDER_MINUTES | 1440,60 | Tashrifdan necha daqiqa oldin eslatish |
| CHECK_AFTER_MINUTES | 60 | Vaqtdan keyin "Mijoz keldimi?" eslatmasi |
| DAILY_SUMMARY_TIME | 09:00 | Jamoaga ertalabki ro'yxat |
| REPORT_TIME | 23:00 | Egasiga kunlik hisobot (va zaxira nusxa) |
| BACKUP_DAILY | 1 | 0 — kunlik zaxira nusxani yubormaslik |

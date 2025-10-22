# 🚀 Инструкция по развертыванию Telegram бота (версия 5.0)

## ✅ Что было исправлено

### 1. **YooKassa оплата теперь РАБОТАЕТ**
- ✅ Полная интеграция с YooKassa API
- ✅ Создание платежей через API
- ✅ Проверка статуса платежа
- ✅ Автоматическая активация подписки после оплаты
- ✅ Уведомления пользователю о статусе оплаты

### 2. **AI-психолог теперь ПОМНИТ диалоги**
- ✅ Новая таблица `conversation_history` в БД
- ✅ Сохранение последних 15 сообщений каждого пользователя
- ✅ Контекст передается в DeepSeek API
- ✅ Кнопка "Очистить историю AI" для начала нового диалога

### 3. **Исправлена ошибка запуска на сервере**
- ✅ Полностью переписан под python-telegram-bot v21+
- ✅ Все хендлеры теперь async/await
- ✅ JobQueue инициализируется через post_init
- ✅ Использование zoneinfo вместо pytz
- ✅ Обновлены импорты: filters, ContextTypes.DEFAULT_TYPE

---

## 📋 Системные требования

- **Python**: 3.9 или выше (обязательно для zoneinfo)
- **OS**: Linux (Ubuntu/Debian рекомендуется)
- **RAM**: минимум 512MB
- **Disk**: минимум 100MB свободного места

---

## 🔧 Установка на сервере

### Шаг 1: Подключение к серверу

```bash
ssh root@your_server_ip
```

### Шаг 2: Обновление системы

```bash
apt update && apt upgrade -y
apt install -y python3 python3-pip python3-venv git
```

### Шаг 3: Создание директории проекта

```bash
mkdir -p /root/telegram_bot
cd /root/telegram_bot
```

### Шаг 4: Загрузка файлов проекта

Вариант А: Если файлы уже есть локально, используйте SCP:

```bash
# На вашем локальном компьютере:
scp -r /home/ubuntu/telegram_bot_fixed/* root@your_server_ip:/root/telegram_bot/
```

Вариант Б: Загрузка через SFTP или любой FTP клиент

Загрузите все файлы из `/home/ubuntu/telegram_bot_fixed/` на сервер в `/root/telegram_bot/`

### Шаг 5: Создание виртуального окружения

```bash
cd /root/telegram_bot
python3 -m venv venv
source venv/bin/activate
```

### Шаг 6: Установка зависимостей

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Шаг 7: Настройка .env файла

Откройте файл .env и заполните обязательные параметры:

```bash
nano .env
```

Минимально необходимые параметры:

```env
BOT_TOKEN=ваш_токен_от_BotFather
DEEPSEEK_API_KEY=ваш_ключ_от_DeepSeek
ADMIN_USER_ID=ваш_telegram_user_id

# YooKassa уже заполнены, но проверьте:
YUKASSA_SHOP_ID=1187960
YUKASSA_SECRET_KEY=live_tojfBk8Lz9MkNFNEV3TEUtCAdhGMHCu9YEI4J67MxCc
```

Сохраните файл: `Ctrl+O`, затем `Enter`, затем `Ctrl+X`

### Шаг 8: Тестовый запуск

```bash
python3 bot.py
```

Если всё работает, увидите:

```
✅ Переменные окружения загружены
✅ База данных инициализирована: bot.db
✅ YooKassa инициализирована
📅 Ежедневная рассылка настроена на 10:00 МСК
✅ Бот успешно запущен!
```

Нажмите `Ctrl+C` для остановки.

---

## 🔄 Настройка автозапуска через systemd

### Шаг 1: Создание systemd сервиса

```bash
nano /etc/systemd/system/telegram_bot.service
```

Вставьте следующее содержимое:

```ini
[Unit]
Description=Telegram Numerology Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/telegram_bot
Environment="PATH=/root/telegram_bot/venv/bin"
ExecStart=/root/telegram_bot/venv/bin/python3 /root/telegram_bot/bot.py
Restart=always
RestartSec=10
StandardOutput=append:/root/telegram_bot/bot.log
StandardError=append:/root/telegram_bot/bot.log

[Install]
WantedBy=multi-user.target
```

Сохраните файл: `Ctrl+O`, `Enter`, `Ctrl+X`

### Шаг 2: Активация сервиса

```bash
# Перезагрузка конфигурации systemd
systemctl daemon-reload

# Включение автозапуска
systemctl enable telegram_bot.service

# Запуск сервиса
systemctl start telegram_bot.service

# Проверка статуса
systemctl status telegram_bot.service
```

### Шаг 3: Управление сервисом

```bash
# Остановка бота
systemctl stop telegram_bot.service

# Перезапуск бота
systemctl restart telegram_bot.service

# Просмотр логов
tail -f /root/telegram_bot/bot.log

# Просмотр логов systemd
journalctl -u telegram_bot.service -f
```

---

## 🔐 Настройка YooKassa Webhook (опционально)

Для автоматического получения уведомлений о платежах:

### Шаг 1: Настройка веб-сервера (если нужен webhook)

YooKassa может отправлять уведомления на ваш сервер. Для этого нужен HTTPS endpoint.

**Вариант А: Использование ngrok (для тестирования)**

```bash
# Установка ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf ngrok-v3-stable-linux-amd64.tgz
./ngrok http 8080
```

Скопируйте HTTPS URL из ngrok и добавьте в личный кабинет YooKassa.

**Вариант Б: Nginx + Certbot (для продакшена)**

```bash
apt install -y nginx certbot python3-certbot-nginx

# Настройте домен и получите SSL сертификат
certbot --nginx -d yourdomain.com
```

### Шаг 2: Настройка webhook в личном кабинете YooKassa

1. Войдите в личный кабинет YooKassa
2. Перейдите в раздел "Интеграция" → "HTTP-уведомления"
3. Добавьте URL: `https://yourdomain.com/yookassa/webhook`
4. Сохраните изменения

**ПРИМЕЧАНИЕ**: В текущей версии бота webhook реализован через проверку статуса по кнопке "Я оплатил". 
Для полноценного webhook потребуется добавить Flask/FastAPI сервер (можно сделать в следующей версии).

---

## 📊 Проверка работы

### 1. Откройте бота в Telegram

Найдите вашего бота: `@digital_psychologia_bot` (или ваш username)

### 2. Отправьте команду `/start`

### 3. Пройдите регистрацию

### 4. Проверьте оплату

- Нажмите "⭐ Оформить PRO подписку"
- Выберите тариф
- Нажмите "💳 Оплатить"
- Выполните оплату
- Вернитесь в бота и нажмите "✅ Я оплатил"
- Подписка должна активироваться автоматически

### 5. Проверьте AI с историей

- Спросите AI что-то
- Задайте уточняющий вопрос
- AI должен помнить предыдущий контекст

---

## 🛠 Обновление бота

### Остановка бота

```bash
systemctl stop telegram_bot.service
```

### Резервное копирование базы данных

```bash
cp /root/telegram_bot/bot.db /root/telegram_bot/bot.db.backup
```

### Замена файлов

Загрузите новые файлы через SCP или SFTP, заменив старые.

### Обновление зависимостей

```bash
cd /root/telegram_bot
source venv/bin/activate
pip install -r requirements.txt --upgrade
```

### Запуск бота

```bash
systemctl start telegram_bot.service
```

---

## 🔍 Решение проблем

### Бот не запускается

```bash
# Проверьте логи
tail -100 /root/telegram_bot/bot.log

# Проверьте статус сервиса
systemctl status telegram_bot.service

# Проверьте .env файл
cat /root/telegram_bot/.env | grep -v "^#"
```

### YooKassa не работает

1. Проверьте YUKASSA_SHOP_ID и YUKASSA_SECRET_KEY в .env
2. Проверьте, что магазин активирован в личном кабинете YooKassa
3. Проверьте логи на наличие ошибок API

```bash
grep "YooKassa" /root/telegram_bot/bot.log
```

### AI не отвечает

1. Проверьте DEEPSEEK_API_KEY в .env
2. Проверьте баланс на DeepSeek: https://platform.deepseek.com/
3. Проверьте логи:

```bash
grep "DeepSeek" /root/telegram_bot/bot.log
```

### База данных повреждена

```bash
# Остановите бота
systemctl stop telegram_bot.service

# Удалите старую БД (она пересоздастся)
rm /root/telegram_bot/bot.db

# Запустите бота
systemctl start telegram_bot.service
```

### История AI не сохраняется

1. Проверьте, что таблица `conversation_history` создана:

```bash
sqlite3 /root/telegram_bot/bot.db "SELECT name FROM sqlite_master WHERE type='table';"
```

Должна быть таблица `conversation_history`.

2. Если нет, удалите БД и перезапустите бота (она пересоздастся с правильной схемой).

---

## 📝 Структура базы данных

### Таблицы:

1. **users** - пользователи бота
2. **subscriptions** - подписки пользователей
3. **usage_stats** - статистика использования
4. **conversation_history** - история диалогов с AI (НОВОЕ)

### Схема conversation_history:

```sql
CREATE TABLE conversation_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    role TEXT,              -- 'user' или 'assistant'
    content TEXT,           -- текст сообщения
    timestamp TEXT,         -- время создания
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

---

## 🎯 Команды администратора

### В Telegram боте:

- `/admin` - админ-панель со статистикой
- `/admin_users` - список всех пользователей
- `/admin_stats` - детальная статистика
- `/grant_pro 123456789 1` - выдать PRO на 1 месяц по user_id
- `/grant_pro @username 12` - выдать PRO на 1 год по username

---

## 🔗 Полезные ссылки

- **Telegram Bot API**: https://core.telegram.org/bots/api
- **Python Telegram Bot**: https://docs.python-telegram-bot.org/
- **DeepSeek API**: https://platform.deepseek.com/docs
- **YooKassa API**: https://yookassa.ru/developers/api

---

## 💡 Рекомендации

1. **Регулярно делайте бэкапы базы данных**:
   ```bash
   cp /root/telegram_bot/bot.db /root/telegram_bot/backups/bot_$(date +%Y%m%d).db
   ```

2. **Мониторьте логи**:
   ```bash
   tail -f /root/telegram_bot/bot.log
   ```

3. **Следите за балансом DeepSeek API**

4. **Настройте ротацию логов** чтобы они не заполнили диск:
   ```bash
   # Создайте файл logrotate
   nano /etc/logrotate.d/telegram_bot
   ```
   
   Содержимое:
   ```
   /root/telegram_bot/bot.log {
       daily
       rotate 7
       compress
       delaycompress
       missingok
       notifempty
   }
   ```

---

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи
2. Проверьте статус сервиса
3. Проверьте .env конфигурацию
4. Убедитесь, что все зависимости установлены

---

## 🎉 Готово!

Ваш бот теперь:
- ✅ Полностью работает на PTB v21+
- ✅ Принимает оплату через YooKassa
- ✅ Помнит диалоги с AI
- ✅ Запускается автоматически через systemd
- ✅ Имеет ежедневные рассылки в 10:00 МСК

**Наслаждайтесь работой бота! 🚀**

# 🔮 Telegram Бот-Нумеролог v5.0

Полнофункциональный Telegram бот для нумерологического анализа с AI-консультантом, поддержкой оплаты через YooKassa и историей диалогов.

---

## 🎯 Основные возможности

### Для всех пользователей (FREE):
- 📊 **Персональный нумерологический анализ** - число сознания, миссии, действия
- 🗂 **Матрица судьбы** - сильные стороны и зоны роста
- 💰 **Финансовый код** - рекомендации по работе с деньгами
- 👤 **Профиль пользователя** - сохранение данных
- 📝 **До 5 запросов в день**

### Для PRO пользователей:
- ✅ **Безлимит запросов** к AI-психологу
- 🤖 **AI с памятью диалога** - запоминает контекст беседы
- ❤️ **Анализ совместимости** с партнёром
- ✨ **Персональные практики** для развития
- 📚 **Личный гайд** по саморазвитию
- 🎬 **Подбор книг и фильмов** под ваш профиль
- 📝 **Мини-тест** для самоанализа
- 📅 **Персональный календарь** на неделю
- 🌅 **Ежедневные прогнозы** в 10:00 МСК

---

## 🚀 Технологии

- **Python 3.9+** - основной язык
- **python-telegram-bot 21+** - работа с Telegram API
- **DeepSeek AI** - AI-консультант с памятью
- **YooKassa API** - приём платежей
- **SQLite** - хранение данных
- **zoneinfo** - работа с часовыми поясами

---

## 📦 Что было исправлено в v5.0

### ✅ YooKassa оплата РАБОТАЕТ
- Полная интеграция с YooKassa API
- Создание платежей через API
- Проверка статуса платежа в реальном времени
- Автоматическая активация подписки
- Уведомления пользователю

### ✅ AI-психолог ПОМНИТ диалоги
- Новая таблица `conversation_history` в БД
- Сохранение последних 15 сообщений
- Контекст передается в DeepSeek API
- Кнопка "Очистить историю AI"

### ✅ Исправлена ошибка запуска
- Полностью переписан под PTB v21+
- Все хендлеры async/await
- JobQueue через post_init
- Обновлены импорты

---

## 📁 Структура проекта

```
telegram_bot_fixed/
├── bot.py                      # Основной файл бота (полностью обновлен)
├── requirements.txt            # Зависимости Python
├── .env                        # Конфигурация (не в git)
├── .env.example               # Пример конфигурации
├── database_schema.sql        # Схема базы данных
├── DEPLOY_INSTRUCTIONS.md     # Подробная инструкция по развертыванию
├── README.md                  # Этот файл
└── bot.db                     # База данных SQLite (создается автоматически)
```

---

## ⚡ Быстрый старт

### 1. Клонирование и установка

```bash
# Перейдите в директорию
cd /home/ubuntu/telegram_bot_fixed

# Создайте виртуальное окружение
python3 -m venv venv
source venv/bin/activate

# Установите зависимости
pip install -r requirements.txt
```

### 2. Настройка .env

Скопируйте `.env.example` в `.env` и заполните:

```env
BOT_TOKEN=ваш_токен_от_BotFather
DEEPSEEK_API_KEY=ваш_ключ_от_DeepSeek
ADMIN_USER_ID=ваш_telegram_user_id

# YooKassa уже заполнены
YUKASSA_SHOP_ID=1187960
YUKASSA_SECRET_KEY=live_tojfBk8Lz9MkNFNEV3TEUtCAdhGMHCu9YEI4J67MxCc
```

### 3. Запуск

```bash
python3 bot.py
```

Для развертывания на сервере смотрите **DEPLOY_INSTRUCTIONS.md**

---

## 🔑 Получение токенов

### Telegram Bot Token
1. Откройте [@BotFather](https://t.me/BotFather) в Telegram
2. Отправьте `/newbot`
3. Следуйте инструкциям
4. Скопируйте токен

### DeepSeek API Key
1. Зарегистрируйтесь на [DeepSeek Platform](https://platform.deepseek.com/)
2. Создайте API ключ
3. Скопируйте ключ

### Ваш User ID
1. Откройте [@userinfobot](https://t.me/userinfobot) в Telegram
2. Отправьте любое сообщение
3. Скопируйте ID

---

## 💳 Настройка YooKassa

1. Войдите в [личный кабинет YooKassa](https://yookassa.ru/)
2. Перейдите в раздел "Интеграция"
3. Скопируйте Shop ID и Secret Key
4. Добавьте их в `.env`
5. Активируйте магазин

**Важно**: Текущие данные YooKassa уже настроены для бота `@digital_psychologia_bot`

---

## 🗄️ База данных

### Таблицы:

- **users** - пользователи бота
- **subscriptions** - подписки
- **usage_stats** - статистика использования
- **conversation_history** - история диалогов AI (НОВОЕ)

Схема БД описана в `database_schema.sql`

---

## 🎮 Команды бота

### Пользовательские:
- `/start` - Начать работу / Регистрация
- `/menu` - Главное меню
- `/help` - Справка
- `/cancel` - Отменить действие

### Администраторские:
- `/admin` - Админ-панель
- `/admin_users` - Список пользователей
- `/admin_stats` - Детальная статистика
- `/grant_pro user_id months` - Выдать PRO

---

## 🔧 Разработка

### Требования:
- Python 3.9+
- pip 21+

### Установка для разработки:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Запуск в режиме разработки:

```bash
python3 bot.py
```

### Проверка синтаксиса:

```bash
python3 -m py_compile bot.py
```

---

## 📊 Архитектура

### Основные компоненты:

1. **Database** - Менеджер SQLite с методами для работы с БД
2. **YooKassaPayment** - Класс для работы с YooKassa API
3. **ask_deepseek_ai** - Функция для запросов к DeepSeek с историей
4. **Нумерологические расчеты** - Функции для вычислений
5. **Обработчики** - Async функции для команд и callback'ов
6. **JobQueue** - Планировщик для ежедневных рассылок

### Async/Await:

Все обработчики используют async/await для неблокирующей работы:

```python
async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Привет!")
```

### История диалогов:

AI запоминает последние 15 сообщений для каждого пользователя:

```python
# Сохранение
db.add_message_to_history(user_id, "user", "Мой вопрос")
db.add_message_to_history(user_id, "assistant", "Ответ AI")

# Загрузка
history = db.get_conversation_history(user_id, limit=10)
```

---

## 🚀 Развертывание

Полная инструкция по развертыванию на сервере: **DEPLOY_INSTRUCTIONS.md**

Краткая версия:

```bash
# На сервере
ssh root@your_server_ip

# Установка
mkdir -p /root/telegram_bot
cd /root/telegram_bot
# Загрузите файлы проекта

# Настройка
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Настройка .env
nano .env

# Создание systemd сервиса
nano /etc/systemd/system/telegram_bot.service

# Запуск
systemctl enable telegram_bot.service
systemctl start telegram_bot.service
```

---

## 📈 Мониторинг

### Просмотр логов:

```bash
# Логи бота
tail -f /root/telegram_bot/bot.log

# Логи systemd
journalctl -u telegram_bot.service -f
```

### Статус сервиса:

```bash
systemctl status telegram_bot.service
```

---

## 🔐 Безопасность

- ✅ `.env` файл не должен быть в git
- ✅ Используйте `chmod 600 .env` для ограничения доступа
- ✅ Регулярно обновляйте зависимости
- ✅ Делайте бэкапы базы данных
- ✅ Используйте HTTPS для webhook'ов

---

## 📝 Лицензия

MIT License - вы можете свободно использовать, изменять и распространять этот код.

---

## 🤝 Поддержка

Если возникли вопросы:

1. Прочитайте `DEPLOY_INSTRUCTIONS.md`
2. Проверьте логи
3. Проверьте статус сервиса
4. Убедитесь, что `.env` заполнен правильно

---

## 🎉 Благодарности

- [python-telegram-bot](https://github.com/python-telegram-bot/python-telegram-bot) - отличная библиотека для Telegram ботов
- [DeepSeek](https://www.deepseek.com/) - мощный AI для консультаций
- [YooKassa](https://yookassa.ru/) - удобная платёжная система

---

## 📌 Changelog

### v5.0 (Текущая версия)
- ✅ Полная интеграция YooKassa
- ✅ История диалогов для AI
- ✅ Переход на PTB v21+
- ✅ Исправлена ошибка JobQueue
- ✅ Использование zoneinfo

### v4.0
- Базовая версия с DeepSeek AI
- FREE/PRO режимы
- Нумерологический анализ

---

**Автор**: Профессиональная разработка для [@digital_psychologia_bot](https://t.me/digital_psychologia_bot)

**Дата**: Октябрь 2025

---

Made with ❤️ and 🔮

-- ================================================
-- СХЕМА БАЗЫ ДАННЫХ ДЛЯ TELEGRAM БОТА
-- Версия: 5.0 с поддержкой истории диалогов
-- ================================================

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY,
    username TEXT,
    name TEXT,
    birthdate TEXT,
    registration_date TEXT,
    state TEXT DEFAULT 'idle',
    language TEXT DEFAULT 'ru',
    daily_requests INTEGER DEFAULT 0,
    last_request_date TEXT,
    daily_forecast_enabled INTEGER DEFAULT 1
);

-- Таблица подписок
CREATE TABLE IF NOT EXISTS subscriptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    subscription_type TEXT,
    start_date TEXT,
    expiry_date TEXT,
    payment_status TEXT,
    payment_id TEXT,
    auto_renew INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Таблица статистики использования
CREATE TABLE IF NOT EXISTS usage_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    action_type TEXT,
    timestamp TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- НОВАЯ ТАБЛИЦА: История диалогов для AI
CREATE TABLE IF NOT EXISTS conversation_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    role TEXT,              -- 'user' или 'assistant'
    content TEXT,           -- текст сообщения
    timestamp TEXT,         -- время создания ISO 8601
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Индекс для быстрого поиска по user_id
CREATE INDEX IF NOT EXISTS idx_conversation_user_id 
ON conversation_history(user_id, timestamp DESC);

-- ================================================
-- ОПИСАНИЕ ТАБЛИЦ
-- ================================================

/*
users:
  - user_id: Telegram user ID (первичный ключ)
  - username: Telegram username (может быть NULL)
  - name: Имя пользователя (из регистрации)
  - birthdate: Дата рождения в формате ДД.ММ.ГГГГ
  - registration_date: Дата регистрации (ISO 8601)
  - state: Состояние бота (idle, awaiting_name, awaiting_birthdate, и т.д.)
  - language: Язык интерфейса (пока только 'ru')
  - daily_requests: Количество запросов сегодня
  - last_request_date: Дата последнего запроса (YYYY-MM-DD)
  - daily_forecast_enabled: Включена ли ежедневная рассылка (1/0)

subscriptions:
  - id: Автоинкремент ID
  - user_id: Ссылка на пользователя
  - subscription_type: Тип подписки (PRO_MONTH, PRO_YEAR)
  - start_date: Дата начала (ISO 8601)
  - expiry_date: Дата окончания (ISO 8601)
  - payment_status: Статус оплаты (succeeded, pending, cancelled)
  - payment_id: ID платежа в YooKassa или ADMIN_GRANT_*
  - auto_renew: Автопродление (1/0)

usage_stats:
  - id: Автоинкремент ID
  - user_id: Ссылка на пользователя
  - action_type: Тип действия (registration_complete, ai_question, и т.д.)
  - timestamp: Время действия (ISO 8601)

conversation_history:
  - id: Автоинкремент ID
  - user_id: Ссылка на пользователя
  - role: Роль отправителя ('user' или 'assistant')
  - content: Текст сообщения
  - timestamp: Время отправки (ISO 8601)
  
  Эта таблица хранит историю диалогов с AI для каждого пользователя.
  Последние 10-15 сообщений используются как контекст для DeepSeek API.
  Автоматически подрезается до 15 последних сообщений на пользователя.
*/

-- ================================================
-- ПРИМЕРЫ ЗАПРОСОВ
-- ================================================

-- Получить последние 10 сообщений пользователя
-- SELECT role, content, timestamp
-- FROM conversation_history
-- WHERE user_id = ?
-- ORDER BY timestamp DESC
-- LIMIT 10;

-- Очистить историю пользователя
-- DELETE FROM conversation_history WHERE user_id = ?;

-- Подрезать историю, оставив последние 15 сообщений
-- DELETE FROM conversation_history
-- WHERE user_id = ? AND id NOT IN (
--     SELECT id FROM conversation_history
--     WHERE user_id = ?
--     ORDER BY timestamp DESC
--     LIMIT 15
-- );

-- Получить статистику по пользователям
-- SELECT 
--     u.user_id,
--     u.name,
--     CASE WHEN EXISTS (
--         SELECT 1 FROM subscriptions s 
--         WHERE s.user_id = u.user_id 
--         AND s.payment_status = 'succeeded' 
--         AND s.expiry_date > datetime('now')
--     ) THEN 'PRO' ELSE 'FREE' END as status,
--     COUNT(DISTINCT ch.id) as message_count
-- FROM users u
-- LEFT JOIN conversation_history ch ON u.user_id = ch.user_id
-- GROUP BY u.user_id;

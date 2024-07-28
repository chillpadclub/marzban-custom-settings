#!/bin/bash

# Указываем все переменные внутри скрипта
BACKUP_ACCESS_DIR="/var/lib/marzban-node/logs_backup" # Директория, которую мы будем бэкапить
BOT_TOKEN=AAAAAAAA:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
CHAT_ID=-11234567899
NODE=RU

# Логгирование для лучшей видимости
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

# Функция для отправки файла в Telegram
send_backup_to_telegram() {
    local file_path="$1"
    curl -F chat_id="$CHAT_ID" -F document=@"$file_path" -F caption="Log from $NODE" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument"
}

# Основная функция бэкапа
backup_files() {
    log "Starting backup..."

    FILE_NAME="backup-$NODE-$(date '+%Y-%m-%d').tar.gz"

    # Создаем tar архив с бэкапом указанной директории и других необходимых файлов
    tar czvf "$FILE_NAME" -C "$(dirname "$BACKUP_ACCESS_DIR")" "$(basename "$BACKUP_ACCESS_DIR")"

    # Отправляем бэкап в Telegram
    send_backup_to_telegram "$FILE_NAME"

    # Удаляем созданный архив
    rm "$FILE_NAME"

    log "Backup completed!"
}

# Запуск функции бэкапа
backup_files > telegram_log_backup.log

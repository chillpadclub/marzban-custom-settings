#!/bin/sh

# Указываем все переменные внутри скрипта
BACKUP_DIR="/root" # Директория, куда будет сохраняться бэкап
CONTAINER_NAME="marzban-mysql-1" # Имя Docker контейнера
DB_NAME="marzban" # Имя базы данных
DB_USER="root" # Пользователь базы данных
DB_PASSWORD="super-pass" # Пароль базы данных
BACKUP_DIRECTORIES="/var/lib/marzban /opt/marzban" # Директории для бэкапа
BOT_TOKEN="123456789:AAAAAAAAAAAAAAAAAAAAAAAAAAAaa"
CHAT_ID="-123456789"
NODE="MAIN"

# Логгирование для лучшей видимости
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

# Функция для отправки файла в Telegram
send_backup_to_telegram() {
    file_path="$1"
    response=$(curl -s -o /dev/null -w "%{http_code}" -F chat_id="$CHAT_ID" -F document=@"$file_path" -F caption="Backup from $NODE" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument")
    if [ "$response" -ne 200 ]; then
        log "Error sending backup to Telegram, response code: $response"
    else
        log "Backup successfully sent to Telegram"
    fi
}

# Основная функция бэкапа
backup() {
    log "Starting backup..."

    BACKUP_FILE="$BACKUP_DIR/backup-$(date '+%Y-%m-%d').sql"
    ARCHIVE_FILE="$BACKUP_DIR/backup-$NODE-$(date '+%Y-%m-%d').tar"

    # Выполняем бэкап базы данных
    if docker exec "$CONTAINER_NAME" /usr/bin/mysqldump -u "$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"; then
        log "Database backup completed: $BACKUP_FILE"
    else
        log "Error creating database backup"
        exit 1
    fi

    # Создаем tar архив с бэкапом базы данных
    if tar -cf "$ARCHIVE_FILE" -C "$BACKUP_DIR" "$(basename "$BACKUP_FILE")"; then
        log "Initial archive created: $ARCHIVE_FILE"
    else
        log "Error creating initial archive"
        exit 1
    fi

    # Добавляем указанные директории в архив
    for dir in $BACKUP_DIRECTORIES; do
        if tar --append --file="$ARCHIVE_FILE" -C / "$dir"; then
            log "Added $dir to archive"
        else
            log "Error adding $dir to archive"
            exit 1
        fi
    done

    # Сжимаем архив
    if gzip -f "$ARCHIVE_FILE"; then
        log "Compressed archive: $ARCHIVE_FILE.gz"
    else
        log "Error compressing archive"
        exit 1
    fi

    # Отправляем бэкап в Telegram
    send_backup_to_telegram "$ARCHIVE_FILE.gz"

    # Удаляем созданные файлы
    rm "$BACKUP_FILE" "$ARCHIVE_FILE.gz"
    log "Backup completed and temporary files removed!"
}

# Запуск функции бэкапа
backup > "$BACKUP_DIR/telegram_db_backup.log" 2>&1

# marzban_backup
1. Скачиваем файл `marz_logs` в `/etc/logrotate.d/`
2. Создаем папку `logs_backup` в `/var/lib/marzban-node/`
3. Скачиваем `telegram_log_backup` в `/var/lib/marzban-node/`
4. Выдаем права на исполнение
`chmod +x /var/lib/marzban/telegram_log_backup.sh`
5. Настраиваем cron:
`crontab -e`
```
0 0 * * * /usr/sbin/logrotate -f /etc/logrotate.d/marz_logs
10 0 * * * /var/lib/marzban/telegram_log_backup.sh
```
В 00:00 будет создаваться ротация логов \
В 00:10 будет отправляться архив бэкапов в телеграм

To Do: \
✅ Backup Logs from Node \
✅ Backup Config from Main /var/lib/marzban & /opt/marzban (certs,xray_config + .env, docker-compose.yml) \
✅ Backup MySQL (docker)

## Бэкап MySQL
docker exec marzban-mysql-1 /usr/bin/mysqldump -u root --password=pass marzban > /root/db_name.sql
Восстановление MySQL
cat /root/db_name.sql | docker exec -i 6be98e2d8af0 /usr/bin/mysql -u root --password=pass marzban

## настройки logrotate
`apt-get install logrotate` Установка logrotate
`nano /etc/logrotate.d/marz_logs` Создаем файл ротации (marz_logs)
`logrotate -f /etc/logrotate.d/marz_logs` Запуск ротации **в ручную** 

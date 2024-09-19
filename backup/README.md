# marzban_backup
## Настройка ротации логов
1. Скачиваем файл `marzban_log` в `/etc/logrotate.d/`
2. Создаем папку `logs_backup` в `/var/lib/marzban-node/`
## Настройка бэкапа и отправки телеграм
3. Скачиваем `backup_node.sh` в `/var/lib/marzban-node/`
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


## Справка
Создание бэкапа MySQL
`docker exec marzban-mysql-1 /usr/bin/mysqldump -u root --password=pass marzban > /root/db_name.sql` \
Восстановление MySQL
`cat /root/db_name.sql | docker exec -i 6be98e2d8af0 /usr/bin/mysql -u root --password=pass marzban`
Проверка Logrotate
`logrotate --force /etc/logrotate.d/marzban_logs`
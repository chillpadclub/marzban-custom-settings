# Настройка заглушки для Marzban

> Эта страница позволяет настроить отображение фейкового сайта на странице Marzban, вместо их заглушки

- Заходим на сервер с marzban и создаем каталоги
```
mkdir /var/lib/marzban/templates && mkdir /var/lib/marzban/templates/home
```
- Переходим в каталог и скачиваем файл: ```index.html```
```
cd /var/lib/marzban/templates/home && wget https://raw.githubusercontent.com/chillpadclub/marzban-custom-settings/main/home/index.html
```
- Открываем скаченный файл ```nano index.html```
- Меняем название сайта на 22 строчке **TITLE**.
- Меняем адрес сайта на 23 строчке **WEBSITE URL**.
```
const title = "Site Title";
const url = "https://www.site.com/";
```
> Некоторые веб-сайты, такие как **Google** , не позволяют встраиваться в ваш веб-сайт.
- Сохраняем изменения ```CTRL + O``` и ```CTRL + X```.
- Теперь редактируем ```.env``` файл в marzban
```
nano /opt/marzban/.env
```
Раскомментируем строуи, сохраняем и выходим:
```
# CUSTOM_TEMPLATES_DIRECTORY="/var/lib/marzban/templates/"
# HOME_PAGE_TEMPLATE="home/index.html"
```
- Сохраняем .env файл и перезапускаем marzban:
```
marzban restart
```
- Теперь вы можете открыть свой домен marzban напрямую без /dashboard и увидеть изменения.
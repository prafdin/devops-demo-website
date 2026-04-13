# DevOps Demo Website

Простой пример того, как Git становится источником правды для всей системы.

## Структура проекта

```
demo-website/
├── .github/workflows/
│   ├── ci.yml # Проверки при создании pull request
│   ├── deploy.yml # Переиспользуемый workflow для деплоя приложения
│   ├── deploy-dev.yml # Вызов деплой workflow для development окружения
│   └── deploy-prod.yml # Вызов деплой workflow для production окружения
├── backend/
│   ├── app.py # Код backend приложения
│   ├── Dockerfile # Файл для сборки бекенд докер имеджа
│   └── requirements.txt # Зависимости backend приложения
├── .dockerignore   # Перечисляем пути до файлов, которые будут игнорироваться докер билдером    
├── docker-compose.yml   # Манифест docker compose для деплоя приложения    
├── Dockerfile   # Файл для сборки фронтенд докер имеджа    
├── index.html      # Основная страница сайта с ракеткой 🚀
├── install-frp.sh # Скрипт установки и настройки frp
├── install-nginx.sh # Скрипт установки nginx
├── nginx.conf      # Конфигурация веб-сервера
├── README.md       # Документация проекта
└── test.sh         # Тестирование ракетки на сайте
```

## Требования к серверу

Для автоматического деплоя сервер должен быть настроен:

- **SSH доступ по ключу** - публичный ключ в `~/.ssh/authorized_keys`
- **Sudo без пароля** - пользователь в группе sudo с `NOPASSWD`
- **Nginx** - установленный и настроенный веб-сервер
- **Директории** - `/var/www/` доступна для записи

## Быстрый запуск

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/prafdin/devops-demo-website.git
   cd devops-demo-website
   ```

2. Установите frp: (токен может измениться!)
   ```bash
   sudo ./install-frp.sh course.prafdin.ru mytoken prafdin 2022
   ```

3. Создайте директорию для приложения и предоставьте доступ к ней на запись для вашего пользователя
```bash
sudo mkdir /opt/app
sudo chown $USER:$USER /opt/app
```

4. Настройте сервер для автоматического деплоя:
   ```bash
   # Создание пары ключей для ssh доступа к ВМ
   ssh-keygen -t rsa
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
      
   # Настройте sudo без пароля для пользователя
   echo "user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user
   ```

5. Настройте GitHub Actions переменные и секреты для `development` и `production` окружения:
   - Variables: DEPLOY_HOST, DEPLOY_USER, DEPLOY_PORT
   - Secrets: SSH_PRIVATE_KEY

6. Сайт должен быть доступен по адресу http://app.prafdin.course.prafdin.ru/

## Замер RPS
Для замера используется инструмент [wg/wrk])(https://github.com/wg/wrk).

Тестирование производительности на примере 10 запросов в секунду (-c10) из одного треда (t1) на протяжении 10 секунд (d10s): 
```bash
wrk -t1 -c10 -d10s http://app.prafdin.course.prafdin.ru//api/info --latency
```
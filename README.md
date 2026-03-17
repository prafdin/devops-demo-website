# DevOps Demo Website

Простой пример того, как Git становится источником правды для всей системы.

## Структура проекта

```
demo-website/
├── .github/workflows/
│   ├── ci.yml # Проверки при создании pull request
│   ├── deploy-dev.yml # Деплой пайплайн для development окружения
│   └── deploy-prod.yml # Деплой пайплайн для production окружения
├── index.html      # Основная страница сайта с ракеткой 🚀
├── nginx.conf      # Конфигурация веб-сервера
├── deploy.sh       # Скрипт автоматического развертывания
├── test.sh         # Тестирование ракетки на сайте
├── install-nginx.sh # Скрипт установки nginx
├── install-frp.sh # Скрипт установки и настройки frp
└── README.md       # Документация проекта
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

2. Установите nginx:
   ```bash
   sudo ./install-nginx.sh
   ```
   
3. Установите frp: (токен может измениться!)
   ```bash
   sudo ./install-frp.sh course.prafdin.ru mytoken prafdin 2022
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
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
├── ansible/
│   ├── ...
│   └── README.md # Документация по запуску Ansible для подготовки сервера
├── backend/
│   ├── app.py # Код backend приложения
│   ├── Dockerfile # Файл для сборки бекенд докер имеджа
│   └── requirements.txt # Зависимости backend приложения
├── .dockerignore   # Перечисляем пути до файлов, которые будут игнорироваться докер билдером    
├── docker-compose.yml   # Манифест docker compose для деплоя приложения    
├── Dockerfile   # Файл для сборки фронтенд докер имеджа    
├── index.html      # Основная страница сайта с ракеткой 🚀
├── nginx.conf      # Конфигурация веб-сервера
├── README.md       # Документация проекта
└── test.sh         # Тестирование ракетки на сайте
```
## Быстрый запуск

1. Подготовьте сервер с помощью Ansible, подробнее см. [ansible/README.md](ansible/README.md)

2. Настройте GitHub Actions переменные и секреты для `development` и `production` окружения:
   - Variables: DEPLOY_HOST, DEPLOY_USER, DEPLOY_PORT
   - Secrets: SSH_PRIVATE_KEY

3. Сайт должен быть доступен по адресу http://app.prafdin.course.prafdin.ru/

## Замер RPS
Для замера используется инструмент [wg/wrk](https://github.com/wg/wrk).

Тестирование производительности на примере 10 запросов в секунду (-c10) из одного треда (t1) на протяжении 10 секунд (d10s): 
```bash
wrk -t1 -c10 -d10s http://app.prafdin.course.prafdin.ru//api/info --latency
```
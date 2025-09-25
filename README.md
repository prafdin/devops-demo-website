# DevOps Demo Website

Простой пример того, как Git становится источником правды для всей системы.

## Структура проекта

```
demo-website/
├── .github/workflows/
│   └── pipeline.yml # GitHub Actions CI/CD pipeline
├── ansible/         # Configuration Management
│   ├── ansible.cfg  # Конфигурация Ansible
│   ├── inventory.yml# Список серверов
│   ├── setup.yml    # Playbook для установки Docker
│   └── deploy.yml   # Playbook для запуска контейнеров
├── packer/          # Infrastructure as Code
│   ├── ...          # Файлы автоустановки Ubuntu
│   └── README.md    # Документация по содержимому packer директории 
├── backend/         # Python Flask API сервис
│   ├── app.py      # Flask приложение с /info endpoint
│   ├── Dockerfile  # Docker образ для backend
│   └── requirements.txt # Python зависимости
├── Dockerfile       # Docker образ для nginx контейнера
├── .dockerignore    # Игнорируемые файлы при сборке образа
├── docker-compose.yml # Docker Compose конфигурация
├── docker-compose.develop.yml # Development настройки
├── index.html      # Основная страница сайта с ракеткой 🚀
├── nginx.conf      # Конфигурация nginx для контейнера
├── test.sh         # Тестирование ракетки на сайте
├── install-frp.sh # Скрипт установки и настройки frp
└── README.md       # Документация проекта
```


## Быстрый запуск
1. [Создайте](packer/README.md) образ виртуальной машины с помощью Packer 
2. Разверните виртуальную машину из созданного образа  
3. Настройте GitHub Actions переменные и секреты:
   - Variables: DEPLOY_HOST, DEPLOY_USER, DEPLOY_PORT
   - Secrets: SSH_PRIVATE_KEY

4. Создайте push событие в репозитории, которое запустит CICD пайплайн и развернет сайт

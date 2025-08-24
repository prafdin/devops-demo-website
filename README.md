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
├── Dockerfile       # Docker образ для nginx контейнера
├── .dockerignore    # Игнорируемые файлы при сборке образа
├── index.html      # Основная страница сайта с ракеткой 🚀
├── nginx.conf      # Конфигурация nginx для контейнера
├── test.sh         # Тестирование ракетки на сайте
├── install-frp.sh # Скрипт установки и настройки frp
└── README.md       # Документация проекта
```

## Требования к серверу

Для автоматического деплоя сервер должен быть настроен:

- **SSH доступ по ключу** - публичный ключ в `~/.ssh/authorized_keys`
- **Sudo без пароля** - пользователь в группе sudo с `NOPASSWD`
- **Python 3** - для выполнения Ansible playbooks  
- **Docker** - будет установлен автоматически через Ansible

## Быстрый запуск

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/prafdin/devops-demo-website.git
   cd devops-demo-website
   ```

2. Установите frp: (токен может измениться!)
   ```bash
   sudo ./install-frp.sh course.prafdin.ru mytoken prafdin
   ```

3. Настройте сервер для автоматического деплоя:
   ```bash
   # Создание пары ключей для ssh доступа к ВМ
   ssh-keygen -t rsa
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
      
   # Настройте sudo без пароля для пользователя
   echo "user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user
   ```

4. Настройте GitHub Actions переменные и секреты:
   - Variables: DEPLOY_HOST, DEPLOY_USER, DEPLOY_PORT
   - Secrets: SSH_PRIVATE_KEY

5. Сайт должен быть доступен по адресу http://app.prafdin.course.prafdin.ru/
#!/bin/bash

# Скрипт деплоя, запускается на GitHub runner
# Копирует файлы на удаленный сервер через SSH/SCP
echo "🚀 Развертывание демо-сайта через CI/CD..."

# Проверяем переменные окружения
if [ -z "$DEPLOY_HOST" ] || [ -z "$DEPLOY_USER" ]; then
    echo "❌ Не установлены переменные окружения:"
    echo "   DEPLOY_HOST - адрес сервера"
    echo "   DEPLOY_USER - пользователь"
    echo "   DEPLOY_PORT - порт SSH (опционально, по умолчанию 22)"
    exit 1
fi

# Устанавливаем порт по умолчанию если не задан
DEPLOY_PORT=${DEPLOY_PORT:-22}
DEPLOY_DIR="/var/www/demo"

# Проверяем наличие файлов для деплоя
if [ ! -f "index.html" ] || [ ! -f "nginx.conf" ]; then
    echo "❌ Не найдены файлы для деплоя: index.html, nginx.conf"
    exit 1
fi


echo "📋 Параметры деплоя:"
echo "   Сервер: $DEPLOY_HOST:$DEPLOY_PORT"
echo "   Пользователь: $DEPLOY_USER"
echo "   Окружение: $ENVIRONMENT"
echo "   Директория: $DEPLOY_DIR"

# Создаем временную директорию на удаленном сервере
WORK_DIR="/tmp/deploy-$(date +%s)"
echo "📁 Создание рабочей директории на сервере: $WORK_DIR"

echo "🔐 Используем SSH Agent для аутентификации"
SSH_OPTIONS="-p $DEPLOY_PORT -o StrictHostKeyChecking=no"

ssh $SSH_OPTIONS "$DEPLOY_USER@$DEPLOY_HOST" \
    "mkdir -p $WORK_DIR"

# Копируем файлы на сервер
echo "📦 Копирование файлов на удаленный сервер..."
scp -P "$DEPLOY_PORT" -o StrictHostKeyChecking=no \
    index.html nginx.conf \
    "$DEPLOY_USER@$DEPLOY_HOST:$WORK_DIR/"

# Разворачиваем на удаленном сервере
echo "⚙️  Развертывание на удаленном сервере..."
ssh $SSH_OPTIONS "$DEPLOY_USER@$DEPLOY_HOST" << EOF
    cd $WORK_DIR
    
    # Проверяем nginx
    if ! command -v nginx &> /dev/null; then
        echo "❌ nginx не установлен на сервере"
        exit 1
    fi
    
    # Создаем директорию для сайта
    sudo mkdir -p $DEPLOY_DIR
    
    # Копируем файлы
    echo "📁 Копируем файлы сайта в $DEPLOY_DIR..."
    sudo cp index.html $DEPLOY_DIR/
    
    # Применяем конфигурацию nginx
    echo "⚙️  Применяем конфигурацию nginx..."
    sudo cp nginx.conf /etc/nginx/sites-available/demo-site
    sudo ln -sf /etc/nginx/sites-available/demo-site /etc/nginx/sites-enabled/
    
    # Проверяем конфигурацию
    echo "🔍 Проверяем конфигурацию nginx..."
    if sudo nginx -t; then
        # Перезапускаем nginx
        echo "🔄 Перезапускаем nginx..."
        sudo systemctl reload nginx
        echo "✅ Развертывание в $ENVIRONMENT завершено успешно!"
        echo "🌐 Директория: $DEPLOY_DIR"
    else
        echo "❌ Ошибка в конфигурации nginx"
        exit 1
    fi
    
    # Очистка временной директории
    cd /
    rm -rf $WORK_DIR
EOF

if [ $? -eq 0 ]; then
    echo "✅ Деплой завершен успешно!"
else
    echo "❌ Ошибка деплоя!"
    exit 1
fi
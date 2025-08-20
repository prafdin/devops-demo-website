#!/bin/bash

ENVIRONMENT=${1:-production}

echo "🚀 Начинаем развертывание демо-сайта..."

# Проверяем, установлен ли nginx
if ! command -v nginx &> /dev/null; then
    echo "❌ nginx не установлен."
    exit 1
fi

if [ "$ENVIRONMENT" = "develop" ]; then
    DEPLOY_DIR="/var/www/demo-test"
    echo "🧪 Развертывание в ТЕСТОВОЕ окружение"
else
    DEPLOY_DIR="/var/www/demo"
    echo "🏭 Развертывание в ПРОДАКШН окружение"
fi

# Создаем директорию для сайта
sudo mkdir -p $DEPLOY_DIR

# Копируем файлы
echo "📁 Копируем файлы сайта в $DEPLOY_DIR..."
sudo cp index.html $DEPLOY_DIR/

# Копируем конфигурацию nginx
echo "⚙️  Применяем конфигурацию nginx..."
sudo cp nginx.conf /etc/nginx/sites-available/demo-site
sudo ln -sf /etc/nginx/sites-available/demo-site /etc/nginx/sites-enabled/

# Проверяем конфигурацию
echo "🔍 Проверяем конфигурацию nginx..."
sudo nginx -t

if [ $? -eq 0 ]; then
    # Перезапускаем nginx
    echo "🔄 Перезапускаем nginx..."
    sudo systemctl reload nginx
    
    echo "✅ Развертывание завершено успешно!"
else
    echo "❌ Ошибка в конфигурации nginx"
    exit 1
fi
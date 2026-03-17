FROM nginx:alpine

# Копируем HTML файл сайта
COPY index.html /usr/share/nginx/html/

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт 80
EXPOSE 80

# Команда по умолчанию (nginx уже запускается автоматически в alpine образе)
CMD ["nginx", "-g", "daemon off;"]
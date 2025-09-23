# Создание образа VM с помощью Packer 

Автоматизация создания образа Ubuntu 24.04 Server с дополнительными настройками.
Логин и пароль (user/P@ssw0rd) устанавливаются по умолчанию и не могут быть заменены в рамках создания образа. Учтите, 
что вход через SSH по паролю выключен, для доступа используйте приватный ключ, который передается в переменной ssh_private_key_file.

## Quick start
```bash
packer init ubuntu-image.pkr.hcl

packer validate ubuntu-image.pkr.hcl

# Сгенерируйте пару SSH ключей или воспользуйтесь существующей парой
ssh-keygen -f ./id_rsa -N "" -t rsa
# Заполните значения переменных в файле vars.json
cp example_vars.json vars.json

packer build -var-file=vars.json ubuntu-image.pkr.hcl
```

## Требования

- [Packer](https://www.packer.io/downloads) >= 1.7
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) >= 6.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) >= 2.9 (установлен на хост-машине)
- Минимум 4GB свободной оперативной памяти
- Минимум 20GB свободного места на диске
- Стабильное интернет-соединение

## Структура
```
packer/
├── ubuntu-image.pkr.hcl      # Основной Packer template
├── example_vars.json         # Шаблон для переменных, которые используются для сборки образа
├── http/                     # Файлы для автоустановки Ubuntu
│   ├── user-data.pkrtpl.hcl  # HCL шаблон Cloud-init конфигурации, подстановка значений происходит на момент работы packer build
│   └── meta-data             # Метаданные инсталляции
│   └── vendor-data           # Метаданные инсталляции
└── README.md                 # Эта документация
```

## Что делает template

1. **Загружает** Ubuntu 24.04 Server ISO
2. **Автоматически устанавливает** систему через cloud-init
3. **Устанавливает Python** для Ansible
4. **Запускает Ansible provisioner** с существующим `ansible/setup.yml` для установки Docker
5. **Проверяет** что Docker работает
6. **Очищает** систему и создает готовый образ

## Результат

После успешной сборки в директории `packer/` появится:
- `ubuntu-docker-demo.ovf` - файл образа
- `ubuntu-docker-demo-disk001.vmdk` - виртуальный диск
- `manifest.json` - манифест сборки

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
ssh-add ./id_rsa
# Заполните значения переменных в файле vars.json
cp example_vars.json vars.json

# Создание базового имеджа с Ubuntu
packer build -var-file=vars.json base-ubuntu-image.pkr.hcl
# Создание предварительно настроенного имеджа с Ubuntu
packer build -var-file=vars.json setup-ubuntu-image.pkr.hcl
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
├── base-ubuntu-image.pkr.hcl       # Packer template для создания базового имеджа
├── setup-ubuntu-image.pkr.hcl      # Packer template для создания преднастроенного имеджа на основании базового имеджа
├── example_vars.json               # Шаблон для переменных, которые используются для сборки образа
├── http/                           # Файлы для автоустановки Ubuntu
│   ├── user-data.pkrtpl.hcl        # HCL шаблон Cloud-init конфигурации, подстановка значений происходит на момент работы packer build
│   └── meta-data                   # Метаданные инсталляции
│   └── vendor-data                 # Метаданные инсталляции
└── README.md                       # Эта документация
```

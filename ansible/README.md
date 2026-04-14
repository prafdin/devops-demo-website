# Подготовка сервера с помощью Ansible
Для подготовки сервера к деплою используйте плейбук [setup.yml](playbooks/setup.yml).
Плейбук выполняет следующие настройки на сервере:
- устанавливает frpc
- настраивает беспарольный sudo доступ для пользователя, а также вход добавляет публичный SSH ключ `~/.ssh/id_rsa.pub` на целевой сервер
- создает необходимые директории на хосте
- устанавливает docker и docker compose

Для запуска воспользуйтесь командой:
```bash
ansible-playbook -i inventory playbooks/setup.yml --limit <host>
```

# Статическое inventory
Статическая часть конфигурации всех хостов заносятся в файл [common.yml](inventory/common.yml).
Использование inventory:
```bash
ansible-inventory -i inventory/common.yml --graph
```

# Динамическое inventory VirtualBox
Для работы динамического inventory [virtualbox.yml](inventory/virtualbox.yml) необходимо чтобы машина удовлетворяла следующим требованиям:
- На машине установлено VBoxLinuxAdditions
- Доступ на машину осуществляется через интерфейс, расположенный во втором сетевом адаптере машины (/VirtualBox/GuestInfo/Net/1/V4/IP)
- Машина имеет в имени подстроку `stand`
- На машину настроен ключевой SSH доступ для юзера `user` 
- На машине оператора установлена CLI утилита для работы с VirtualBox - `VBoxManage`

Использование inventory:
```bash
ansible-inventory -i inventory/virtualbox.yml --graph
```

## Установка VBoxLinuxAdditions

1. Установка билд зависимостей
```bash
sudo apt update
sudo apt install build-essential dkms linux-headers-$(uname -r)
```
2. Подключение Guest Additions
```
Запустите машину, в верхней панели окна машины выберите Devices → Insert Guest Additions CD Image
```
3. Установка
```bash
sudo mkdir /media/cdrom
sudo mount /dev/cdrom /media/cdrom
sudo sh /media/cdrom/VBoxLinuxAdditions.run
```

# Установка зависимостей Ansible
```bash
ansible-galaxy collection install -r requirements.yml
```
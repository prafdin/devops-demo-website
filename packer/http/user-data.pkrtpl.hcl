#cloud-config
autoinstall:
  shutdown: reboot
  version: 1
  locale: en_US.UTF-8
  proxy: http://10.0.2.2:3142/
  keyboard:
    layout: us
  storage:
    layout:
      name: lvm
      encrypted: false
  identity:
    hostname: ubuntu-docker-demo
    username: user
    password: "$6$STCfpsr1/dtlEYHw$ctuCm6SPpoXrngDtJ4JXmrN7ku/sazpbwGGTWoXFzNZjLc0tiYayfffdEbdYdzqzF2hqbeQBIflaHJn5yw9AA."
    # Password: P@ssw0rd (hashed with mkpasswd -m sha-512)
  ssh:
    install-server: true
    allow-pw: false
    authorized-keys:
      - ${authorized_key}
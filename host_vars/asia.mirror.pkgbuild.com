hostname: "archive1.mirror.pkgbuild.com"

ipv4_address: "84.17.57.98"
ipv4_netmask: "/24"
ipv4_gateway: "84.17.57.110"
filesystem: "btrfs"
network_interface: "en*"
system_disks:
  - /dev/sda
  - /dev/sdb
  - /dev/sdc
raid_level: "raid5"
configure_network: true

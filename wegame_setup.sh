#!/bin/bash
# WeGame版本饥荒专用服务器安装配置脚本
# 适用于CentOS系统

set -e

echo "开始配置WeGame版本饥荒专用服务器..."

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用root权限运行此脚本"
    exit 1
fi

# 更新系统
echo "更新系统包..."
yum update -y

# 安装必要的软件包
echo "安装基础软件包..."
yum groupinstall -y "Development Tools"
yum install -y wget curl unzip tar gzip
yum install -y glibc.i686 libstdc++.i686
yum install -y screen htop vim
yum install -y libcurl-devel openssl-devel

# 创建专用用户
echo "创建饥荒服务器专用用户..."
useradd -m -s /bin/bash dstserver
usermod -aG wheel dstserver

# 创建服务器目录结构
echo "创建服务器目录..."
mkdir -p /home/dstserver/dst_server
mkdir -p /home/dstserver/dst_server/bin
mkdir -p /home/dstserver/dst_server/mods
mkdir -p /home/dstserver/dst_server/saves
mkdir -p /home/dstserver/dst_server/logs
mkdir -p /home/dstserver/dst_server/cluster_1
mkdir -p /home/dstserver/dst_server/cluster_1/Master
mkdir -p /home/dstserver/dst_server/cluster_1/Caves
chown -R dstserver:dstserver /home/dstserver/dst_server

# 配置防火墙
echo "配置防火墙..."
systemctl enable firewalld
systemctl start firewalld

# 开放WeGame饥荒服务器端口
firewall-cmd --permanent --add-port=10999/udp  # 主世界
firewall-cmd --permanent --add-port=11000/udp  # 洞穴
firewall-cmd --permanent --add-port=11001/udp  # 备用端口
firewall-cmd --permanent --add-port=8080/tcp   # Web管理界面
firewall-cmd --permanent --add-port=27015/udp  # Steam查询端口
firewall-cmd --reload

# 配置系统优化
echo "配置系统优化..."
cat > /etc/sysctl.d/99-dst-server.conf << EOF
# WeGame饥荒服务器网络优化
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 65536 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_congestion_control = bbr
net.ipv4.ip_forward = 1
EOF

sysctl -p /etc/sysctl.d/99-dst-server.conf

# 配置ulimit
echo "配置用户限制..."
cat > /etc/security/limits.d/99-dst-server.conf << EOF
dstserver soft nofile 65536
dstserver hard nofile 65536
dstserver soft nproc 32768
dstserver hard nproc 32768
EOF

# 禁用不必要的服务
echo "禁用不必要的服务..."
systemctl disable postfix
systemctl disable bluetooth
systemctl disable cups

echo "WeGame版本基础环境配置完成！"
echo "请切换到dstserver用户继续配置服务器文件"
echo "su - dstserver"

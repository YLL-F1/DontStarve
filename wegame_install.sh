#!/bin/bash
# WeGame版本饥荒服务器文件安装脚本
# 支持root用户和dstserver用户运行

set -e

echo "开始安装WeGame版本饥荒服务器文件..."

# 检查用户并设置安装目录
if [ "$USER" = "root" ]; then
    echo "检测到root用户，将安装到 /home/dstserver/"
    INSTALL_USER="dstserver"
    INSTALL_DIR="/home/dstserver"
    STEAM_DIR="/home/dstserver/steamcmd"
    DST_DIR="/home/dstserver/dst_server"
elif [ "$USER" = "dstserver" ]; then
    echo "检测到dstserver用户，将安装到当前用户目录"
    INSTALL_USER="dstserver"
    INSTALL_DIR="/home/dstserver"
    STEAM_DIR="/home/dstserver/steamcmd"
    DST_DIR="/home/dstserver/dst_server"
else
    echo "错误：请以root用户或dstserver用户身份运行此脚本"
    echo "推荐使用root用户运行以获得完整权限"
    exit 1
fi

# 如果以root用户运行，确保dstserver用户存在
if [ "$USER" = "root" ]; then
    if ! id "dstserver" &>/dev/null; then
        echo "创建dstserver用户..."
        useradd -m -s /bin/bash dstserver
        usermod -aG wheel dstserver
    fi
    
    # 设置目录权限
    mkdir -p "$INSTALL_DIR"
    chown -R dstserver:dstserver "$INSTALL_DIR"
fi

# 创建Steam目录
mkdir -p "$STEAM_DIR"
cd "$STEAM_DIR"

# 下载SteamCMD
echo "下载SteamCMD..."
wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz

# 创建SteamCMD更新脚本
cat > "$STEAM_DIR/update_dst.sh" << 'EOF'
#!/bin/bash
# WeGame版本饥荒服务器更新脚本

cd /home/dstserver/steamcmd

# 更新饥荒服务器
./steamcmd.sh +login anonymous +force_install_dir /home/dstserver/dst_server +app_update 343050 validate +quit

echo "WeGame版本饥荒服务器更新完成！"
EOF

chmod +x "$STEAM_DIR/update_dst.sh"

# 首次安装饥荒服务器
echo "首次安装饥荒服务器..."
./steamcmd.sh +login anonymous +force_install_dir "$DST_DIR" +app_update 343050 validate +quit

# 创建服务器配置目录
mkdir -p "$DST_DIR/cluster_1/Master"
mkdir -p "$DST_DIR/cluster_1/Caves"
mkdir -p "$DST_DIR/mods"
mkdir -p "$DST_DIR/saves"
mkdir -p "$DST_DIR/logs"

# 复制配置文件到正确位置
echo "复制配置文件..."
cp "$INSTALL_DIR/cluster.ini" "$DST_DIR/cluster_1/"
cp "$INSTALL_DIR/worldgenoverride.lua" "$DST_DIR/cluster_1/Master/"
cp "$INSTALL_DIR/cave_worldgenoverride.lua" "$DST_DIR/cluster_1/Caves/"
cp "$INSTALL_DIR/modoverrides.lua" "$DST_DIR/cluster_1/"

# 创建服务器令牌文件（需要用户手动添加）
echo "创建服务器令牌文件..."
touch "$DST_DIR/cluster_1/cluster_token.txt"
echo "请将您的服务器令牌粘贴到 $DST_DIR/cluster_1/cluster_token.txt 文件中"

# 设置权限
chmod +x "$DST_DIR/bin/dontstarve_dedicated_server_nullrenderer"
chmod +x "$INSTALL_DIR/dst_server_manager.sh"

# 创建启动脚本
cat > "$DST_DIR/start_server.sh" << 'EOF'
#!/bin/bash
# WeGame版本饥荒服务器启动脚本

DST_DIR="/home/dstserver/dst_server"
CLUSTER_NAME="cluster_1"

cd "$DST_DIR"

# 启动主世界
screen -dmS "dst_master" ./bin/dontstarve_dedicated_server_nullrenderer -console -cluster $CLUSTER_NAME -shard Master

# 等待主世界启动
sleep 5

# 启动洞穴
screen -dmS "dst_caves" ./bin/dontstarve_dedicated_server_nullrenderer -console -cluster $CLUSTER_NAME -shard Caves

echo "WeGame版本饥荒服务器启动完成！"
echo "主世界端口: 10999"
echo "洞穴端口: 11000"
echo "使用 'screen -r dst_master' 查看主世界日志"
echo "使用 'screen -r dst_caves' 查看洞穴日志"
EOF

chmod +x "$DST_DIR/start_server.sh"

# 创建停止脚本
cat > "$DST_DIR/stop_server.sh" << 'EOF'
#!/bin/bash
# WeGame版本饥荒服务器停止脚本

# 停止主世界
screen -S "dst_master" -X quit 2>/dev/null || true

# 停止洞穴
screen -S "dst_caves" -X quit 2>/dev/null || true

# 强制杀死残留进程
pkill -f "dontstarve_dedicated_server_nullrenderer" 2>/dev/null || true

echo "WeGame版本饥荒服务器已停止"
EOF

chmod +x "$DST_DIR/stop_server.sh"

# 如果以root用户运行，设置最终权限
if [ "$USER" = "root" ]; then
    echo "设置最终权限..."
    chown -R dstserver:dstserver "$INSTALL_DIR"
fi

echo "WeGame版本饥荒服务器安装完成！"
echo ""
echo "重要提醒："
echo "1. 请将您的服务器令牌粘贴到 $DST_DIR/cluster_1/cluster_token.txt 文件中"
echo "2. 服务器文件位置: $DST_DIR"
echo "3. 使用 $STEAM_DIR/update_dst.sh 更新服务器"
echo "4. 使用 $INSTALL_DIR/dst_server_manager.sh 管理服务器"
echo "5. 主世界端口: 10999, 洞穴端口: 11000"
echo ""
echo "配置文件说明："
echo "- cluster.ini: 服务器基本配置"
echo "- worldgenoverride.lua: 主世界生成配置"
echo "- cave_worldgenoverride.lua: 洞穴世界生成配置"
echo "- modoverrides.lua: 模组配置"
echo ""
if [ "$USER" = "root" ]; then
    echo "安装完成！现在可以切换到dstserver用户管理服务器："
    echo "su - dstserver"
    echo "cd /home/dstserver"
    echo "./dst_server_manager.sh start"
else
    echo "安装完成！现在可以启动服务器："
    echo "./dst_server_manager.sh start"
fi

#!/bin/bash
# WeGame版本饥荒服务器文件安装脚本
# 以dstserver用户身份运行

set -e

echo "开始安装WeGame版本饥荒服务器文件..."

# 检查用户
if [ "$USER" != "dstserver" ]; then
    echo "请以dstserver用户身份运行此脚本"
    exit 1
fi

# 创建Steam目录
mkdir -p ~/steamcmd
cd ~/steamcmd

# 下载SteamCMD
echo "下载SteamCMD..."
wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz

# 创建SteamCMD更新脚本
cat > ~/steamcmd/update_dst.sh << 'EOF'
#!/bin/bash
# WeGame版本饥荒服务器更新脚本

cd ~/steamcmd

# 更新饥荒服务器
./steamcmd.sh +login anonymous +force_install_dir ~/dst_server +app_update 343050 validate +quit

echo "WeGame版本饥荒服务器更新完成！"
EOF

chmod +x ~/steamcmd/update_dst.sh

# 首次安装饥荒服务器
echo "首次安装饥荒服务器..."
./steamcmd.sh +login anonymous +force_install_dir ~/dst_server +app_update 343050 validate +quit

# 创建服务器配置目录
mkdir -p ~/dst_server/cluster_1/Master
mkdir -p ~/dst_server/cluster_1/Caves
mkdir -p ~/dst_server/mods
mkdir -p ~/dst_server/saves
mkdir -p ~/dst_server/logs

# 复制配置文件到正确位置
echo "复制配置文件..."
cp ~/cluster.ini ~/dst_server/cluster_1/
cp ~/worldgenoverride.lua ~/dst_server/cluster_1/Master/
cp ~/cave_worldgenoverride.lua ~/dst_server/cluster_1/Caves/
cp ~/modoverrides.lua ~/dst_server/cluster_1/

# 创建服务器令牌文件（需要用户手动添加）
echo "创建服务器令牌文件..."
touch ~/dst_server/cluster_1/cluster_token.txt
echo "请将您的服务器令牌粘贴到 ~/dst_server/cluster_1/cluster_token.txt 文件中"

# 设置权限
chmod +x ~/dst_server/bin/dontstarve_dedicated_server_nullrenderer
chmod +x ~/dst_server_manager.sh

# 创建启动脚本
cat > ~/dst_server/start_server.sh << 'EOF'
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

chmod +x ~/dst_server/start_server.sh

# 创建停止脚本
cat > ~/dst_server/stop_server.sh << 'EOF'
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

chmod +x ~/dst_server/stop_server.sh

echo "WeGame版本饥荒服务器安装完成！"
echo ""
echo "重要提醒："
echo "1. 请将您的服务器令牌粘贴到 ~/dst_server/cluster_1/cluster_token.txt 文件中"
echo "2. 服务器文件位置: ~/dst_server"
echo "3. 使用 ~/steamcmd/update_dst.sh 更新服务器"
echo "4. 使用 ~/dst_server_manager.sh 管理服务器"
echo "5. 主世界端口: 10999, 洞穴端口: 11000"
echo ""
echo "配置文件说明："
echo "- cluster.ini: 服务器基本配置"
echo "- worldgenoverride.lua: 主世界生成配置"
echo "- cave_worldgenoverride.lua: 洞穴世界生成配置"
echo "- modoverrides.lua: 模组配置"

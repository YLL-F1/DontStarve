# WeGame版本饥荒专用服务器配置指南

本配置适用于在CentOS系统上搭建WeGame版本的《饥荒联机版》专用服务器。

## 系统要求

- **操作系统**: CentOS 7/8/9
- **内存**: 至少4GB RAM（推荐8GB+）
- **存储**: 至少10GB可用空间
- **网络**: 稳定的网络连接，开放相应端口

## 快速开始

### 1. 系统环境配置

以root用户身份运行系统配置脚本：

```bash
chmod +x centos_setup.sh
./centos_setup.sh
```

### 2. 安装饥荒服务器

**推荐使用root用户安装**（自动创建dstserver用户）：

```bash
chmod +x wegame_install.sh
./wegame_install.sh
```

**或者切换到dstserver用户安装**：

```bash
su - dstserver
chmod +x wegame_install.sh
./wegame_install.sh
```

### 3. 配置服务器令牌

将您的WeGame服务器令牌粘贴到以下文件：

```bash
vim /home/dstserver/dst_server/cluster_1/cluster_token.txt
```

### 4. 启动服务器

**如果使用root用户安装，切换到dstserver用户启动**：

```bash
su - dstserver
cd /home/dstserver
chmod +x dst_server_manager.sh
chmod +x auto_backup.sh
./dst_server_manager.sh start
```

**如果使用dstserver用户安装，直接启动**：

```bash
chmod +x dst_server_manager.sh
chmod +x auto_backup.sh
./dst_server_manager.sh start
```

### 5. 设置自动备份（可选）
```bash
# 设置每天凌晨2点自动备份
crontab -e
# 添加: 0 2 * * * /home/dstserver/auto_backup.sh
```

## 配置文件说明

### cluster.ini
服务器基本配置，包括：
- 游戏模式（生存/无尽/荒野）
- 最大玩家数
- PVP设置
- 服务器名称和描述
- 密码设置

### worldgenoverride.lua
主世界生成配置，包括：
- 世界大小
- 资源丰富度
- 生物数量
- 季节设置
- 特殊事件

### cave_worldgenoverride.lua
洞穴世界生成配置，包括：
- 洞穴大小
- 地下资源
- 洞穴生物
- 地下特殊设置

### modoverrides.lua
模组配置，包含常用模组：
- 服务器信息显示
- 全球定位
- 血量显示
- 快速拾取
- 食物属性显示

## 服务器管理

### 管理脚本使用

```bash
# 启动服务器
./dst_server_manager.sh start

# 停止服务器
./dst_server_manager.sh stop

# 重启服务器
./dst_server_manager.sh restart

# 查看状态
./dst_server_manager.sh status

# 更新服务器
./dst_server_manager.sh update

# 查看日志
./dst_server_manager.sh logs master    # 主世界日志
./dst_server_manager.sh logs caves     # 洞穴日志

# 备份和回档操作
./dst_server_manager.sh backup                    # 创建自动命名备份
./dst_server_manager.sh backup my_backup          # 创建指定名称备份
./dst_server_manager.sh list_backups              # 列出所有备份
./dst_server_manager.sh restore backup_20240101_120000  # 恢复指定备份
```

### 手动管理

```bash
# 启动服务器
cd ~/dst_server
./start_server.sh

# 停止服务器
./stop_server.sh

# 查看运行状态
screen -list

# 进入服务器控制台
screen -r dst_master    # 主世界
screen -r dst_caves     # 洞穴
```

## 网络配置

### 端口说明
- **10999/udp**: 主世界端口
- **11000/udp**: 洞穴端口
- **11001/udp**: 备用端口
- **8080/tcp**: Web管理界面
- **27015/udp**: Steam查询端口

### 防火墙配置
脚本已自动配置防火墙规则，如需手动配置：

```bash
# 开放端口
firewall-cmd --permanent --add-port=10999/udp
firewall-cmd --permanent --add-port=11000/udp
firewall-cmd --permanent --add-port=11001/udp
firewall-cmd --reload
```

## 常见问题

### 1. 服务器无法启动
- 检查服务器令牌是否正确
- 确认端口未被占用
- 查看日志文件排查错误

### 2. 玩家无法连接
- 检查防火墙设置
- 确认端口映射正确
- 验证服务器令牌

### 3. 服务器卡顿
- 检查系统资源使用情况
- 调整世界生成参数
- 减少模组数量

### 4. 更新服务器
```bash
./dst_server_manager.sh stop
./dst_server_manager.sh update
./dst_server_manager.sh start
```

## 性能优化

### 系统优化
- 调整内核参数（已自动配置）
- 设置合适的ulimit值
- 禁用不必要的服务

### 游戏优化
- 合理设置世界大小
- 控制玩家数量
- 选择必要的模组

## 备份与回档

### 手动备份
```bash
# 创建备份
./dst_server_manager.sh backup                    # 自动命名备份
./dst_server_manager.sh backup my_backup          # 指定名称备份

# 查看备份列表
./dst_server_manager.sh list_backups

# 恢复备份
./dst_server_manager.sh restore backup_20240101_120000
```

### 自动备份
```bash
# 设置自动备份（通过crontab）
crontab -e

# 添加以下行实现每小时自动备份
0 * * * * /home/dstserver/auto_backup.sh

# 每天凌晨2点自动备份
0 2 * * * /home/dstserver/auto_backup.sh

# 每周日凌晨3点自动备份
0 3 * * 0 /home/dstserver/auto_backup.sh
```

### 备份管理
- **备份位置**: `~/backups/`
- **备份日志**: `~/backups/backup_log.txt`
- **自动清理**: 自动保留最新10个备份
- **安全机制**: 恢复前会先备份当前存档

## 监控与维护

### 系统监控
```bash
# 查看系统资源
htop

# 查看网络连接
netstat -tuln | grep -E ":(10999|11000)"

# 查看服务器进程
ps aux | grep dontstarve
```

### 日志管理
- 日志文件位置：`~/dst_server/logs/`
- 定期清理旧日志文件
- 监控错误日志

## 技术支持

如遇到问题，请检查：
1. 系统日志：`/var/log/messages`
2. 服务器日志：`~/dst_server/logs/`
3. 防火墙状态：`firewall-cmd --list-all`
4. 网络连接：`netstat -tuln`

## 注意事项

1. **服务器令牌**：必须从WeGame客户端获取有效的服务器令牌
2. **端口冲突**：确保端口10999和11000未被其他程序占用
3. **权限问题**：确保dstserver用户有足够的权限
4. **定期更新**：建议定期更新服务器版本
5. **备份重要**：定期备份存档和配置文件

---

**配置完成！祝您游戏愉快！**

#!/bin/bash
# WeGame版本饥荒专用服务器一键安装脚本
# 支持root用户和普通用户安装

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# 显示欢迎信息
show_welcome() {
    echo "=========================================="
    echo "  WeGame版本饥荒专用服务器一键安装脚本"
    echo "=========================================="
    echo ""
    echo "本脚本将自动完成以下操作："
    echo "1. 配置CentOS系统环境"
    echo "2. 安装饥荒服务器文件"
    echo "3. 配置服务器参数"
    echo "4. 设置自动备份"
    echo ""
    echo "支持安装方式："
    echo "- root用户安装（推荐）"
    echo "- dstserver用户安装"
    echo ""
}

# 检查系统要求
check_system() {
    log_step "检查系统要求..."
    
    # 检查操作系统
    if [ ! -f /etc/redhat-release ]; then
        log_error "此脚本仅支持CentOS系统"
        exit 1
    fi
    
    # 检查是否为root用户
    if [ "$EUID" -eq 0 ]; then
        log_info "检测到root用户，将使用完整权限安装"
        INSTALL_AS_ROOT=true
    else
        log_info "检测到普通用户，将使用当前用户权限安装"
        INSTALL_AS_ROOT=false
    fi
    
    # 检查网络连接
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        log_error "网络连接失败，请检查网络设置"
        exit 1
    fi
    
    log_info "系统检查通过"
}

# 安装系统环境
install_system() {
    log_step "安装系统环境..."
    
    if [ "$INSTALL_AS_ROOT" = true ]; then
        log_info "以root用户安装系统环境"
        chmod +x wegame_setup.sh
        ./wegame_setup.sh
    else
        log_warn "需要root权限安装系统环境"
        log_info "请先运行: sudo ./wegame_setup.sh"
        echo -n "是否已安装系统环境？(y/N): "
        read -r confirm
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            log_error "请先安装系统环境"
            exit 1
        fi
    fi
}

# 安装饥荒服务器
install_dst_server() {
    log_step "安装饥荒服务器..."
    
    chmod +x wegame_install.sh
    ./wegame_install.sh
    
    log_info "饥荒服务器安装完成"
}

# 配置服务器
configure_server() {
    log_step "配置服务器..."
    
    # 设置自动备份
    if [ "$INSTALL_AS_ROOT" = true ]; then
        log_info "设置自动备份..."
        # 为dstserver用户设置crontab
        (crontab -u dstserver -l 2>/dev/null; echo "0 2 * * * /home/dstserver/auto_backup.sh") | crontab -u dstserver -
        log_info "自动备份已设置（每天凌晨2点）"
    else
        log_info "设置自动备份..."
        (crontab -l 2>/dev/null; echo "0 2 * * * /home/dstserver/auto_backup.sh") | crontab -
        log_info "自动备份已设置（每天凌晨2点）"
    fi
}

# 显示完成信息
show_completion() {
    log_step "安装完成！"
    echo ""
    echo "=========================================="
    echo "  安装完成！"
    echo "=========================================="
    echo ""
    echo "重要提醒："
    echo "1. 请将您的服务器令牌粘贴到以下文件："
    if [ "$INSTALL_AS_ROOT" = true ]; then
        echo "   /home/dstserver/dst_server/cluster_1/cluster_token.txt"
    else
        echo "   ~/dst_server/cluster_1/cluster_token.txt"
    fi
    echo ""
    echo "2. 启动服务器："
    if [ "$INSTALL_AS_ROOT" = true ]; then
        echo "   su - dstserver"
        echo "   cd /home/dstserver"
        echo "   ./dst_server_manager.sh start"
    else
        echo "   ./dst_server_manager.sh start"
    fi
    echo ""
    echo "3. 管理服务器："
    echo "   ./dst_server_manager.sh [start|stop|restart|status|backup|restore]"
    echo ""
    echo "4. 查看日志："
    echo "   ./dst_server_manager.sh logs master"
    echo "   ./dst_server_manager.sh logs caves"
    echo ""
    echo "5. 服务器端口："
    echo "   主世界: 10999/udp"
    echo "   洞穴: 11000/udp"
    echo ""
    echo "配置文件位置："
    if [ "$INSTALL_AS_ROOT" = true ]; then
        echo "   /home/dstserver/dst_server/cluster_1/"
    else
        echo "   ~/dst_server/cluster_1/"
    fi
    echo ""
    echo "祝您游戏愉快！"
}

# 主函数
main() {
    show_welcome
    
    # 确认安装
    echo -n "是否继续安装？(y/N): "
    read -r confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log_info "安装已取消"
        exit 0
    fi
    
    check_system
    install_system
    install_dst_server
    configure_server
    show_completion
}

# 执行主函数
main "$@"

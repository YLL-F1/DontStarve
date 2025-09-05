#!/bin/bash
# WeGame版本饥荒专用服务器管理脚本
# 使用方法: ./dst_server_manager.sh [start|stop|restart|status|update|logs|backup|restore|list_backups]

DST_DIR="/home/dstserver/dst_server"
CLUSTER_NAME="cluster_1"
SCREEN_NAME="dst_server"
BACKUP_DIR="/home/dstserver/backups"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# 检查服务器是否运行
is_server_running() {
    screen -list | grep -q "$SCREEN_NAME"
}

# 启动服务器
start_server() {
    log_info "启动饥荒专用服务器..."
    
    if is_server_running; then
        log_warn "服务器已经在运行中"
        return 1
    fi
    
    cd "$DST_DIR"
    
    # 启动主世界
    screen -dmS "${SCREEN_NAME}_master" bash -c "cd $DST_DIR && ./bin/dontstarve_dedicated_server_nullrenderer -console -cluster $CLUSTER_NAME -shard Master"
    
    # 等待主世界启动
    sleep 5
    
    # 启动洞穴
    screen -dmS "${SCREEN_NAME}_caves" bash -c "cd $DST_DIR && ./bin/dontstarve_dedicated_server_nullrenderer -console -cluster $CLUSTER_NAME -shard Caves"
    
    sleep 3
    
    if is_server_running; then
        log_info "服务器启动成功！"
        log_info "主世界端口: 10999"
        log_info "洞穴端口: 11000"
        log_info "使用 'screen -r ${SCREEN_NAME}_master' 查看主世界日志"
        log_info "使用 'screen -r ${SCREEN_NAME}_caves' 查看洞穴日志"
    else
        log_error "服务器启动失败！"
        return 1
    fi
}

# 停止服务器
stop_server() {
    log_info "停止饥荒专用服务器..."
    
    if ! is_server_running; then
        log_warn "服务器未运行"
        return 1
    fi
    
    # 停止主世界
    screen -S "${SCREEN_NAME}_master" -X quit 2>/dev/null || true
    
    # 停止洞穴
    screen -S "${SCREEN_NAME}_caves" -X quit 2>/dev/null || true
    
    # 等待进程完全停止
    sleep 3
    
    # 强制杀死残留进程
    pkill -f "dontstarve_dedicated_server_nullrenderer" 2>/dev/null || true
    
    log_info "服务器已停止"
}

# 重启服务器
restart_server() {
    log_info "重启饥荒专用服务器..."
    stop_server
    sleep 2
    start_server
}

# 查看服务器状态
show_status() {
    log_info "饥荒专用服务器状态:"
    echo "=================================="
    
    if is_server_running; then
        log_info "服务器状态: 运行中"
        
        # 显示主世界状态
        if screen -list | grep -q "${SCREEN_NAME}_master"; then
            log_info "主世界: 运行中"
        else
            log_warn "主世界: 未运行"
        fi
        
        # 显示洞穴状态
        if screen -list | grep -q "${SCREEN_NAME}_caves"; then
            log_info "洞穴: 运行中"
        else
            log_warn "洞穴: 未运行"
        fi
        
        # 显示网络连接
        echo ""
        log_info "网络连接:"
        netstat -tuln | grep -E ":(10999|11000)" | while read line; do
            echo "  $line"
        done
        
    else
        log_warn "服务器状态: 未运行"
    fi
    
    echo "=================================="
}

# 更新服务器
update_server() {
    log_info "更新饥荒专用服务器..."
    
    if is_server_running; then
        log_warn "服务器正在运行，请先停止服务器"
        return 1
    fi
    
    cd /home/dstserver/steamcmd
    ./steamcmd.sh +login anonymous +force_install_dir ~/dst_server +app_update 343050 validate +quit
    
    if [ $? -eq 0 ]; then
        log_info "服务器更新完成！"
    else
        log_error "服务器更新失败！"
        return 1
    fi
}

# 查看日志
show_logs() {
    local shard=${1:-master}
    
    if [ "$shard" = "master" ]; then
        if screen -list | grep -q "${SCREEN_NAME}_master"; then
            log_info "显示主世界日志 (按 Ctrl+A+D 退出):"
            screen -r "${SCREEN_NAME}_master"
        else
            log_error "主世界未运行"
        fi
    elif [ "$shard" = "caves" ]; then
        if screen -list | grep -q "${SCREEN_NAME}_caves"; then
            log_info "显示洞穴日志 (按 Ctrl+A+D 退出):"
            screen -r "${SCREEN_NAME}_caves"
        else
            log_error "洞穴未运行"
        fi
    else
        log_error "无效的分片名称: $shard (使用 master 或 caves)"
    fi
}

# 创建备份
create_backup() {
    local backup_name=${1:-"backup_$(date +%Y%m%d_%H%M%S)"}
    
    log_info "创建服务器备份: $backup_name"
    
    # 创建备份目录
    mkdir -p "$BACKUP_DIR"
    
    # 检查存档目录是否存在
    if [ ! -d "$DST_DIR/$CLUSTER_NAME/save" ]; then
        log_error "存档目录不存在: $DST_DIR/$CLUSTER_NAME/save"
        return 1
    fi
    
    # 停止服务器（如果正在运行）
    local was_running=false
    if is_server_running; then
        log_warn "服务器正在运行，将先停止服务器"
        stop_server
        was_running=true
        sleep 2
    fi
    
    # 创建备份
    local backup_path="$BACKUP_DIR/$backup_name"
    cp -r "$DST_DIR/$CLUSTER_NAME/save" "$backup_path"
    
    if [ $? -eq 0 ]; then
        log_info "备份创建成功: $backup_path"
        
        # 记录备份信息
        echo "$(date): 备份创建 - $backup_name" >> "$BACKUP_DIR/backup_log.txt"
        
        # 如果服务器之前在运行，重新启动
        if [ "$was_running" = true ]; then
            log_info "重新启动服务器..."
            start_server
        fi
    else
        log_error "备份创建失败！"
        return 1
    fi
}

# 恢复备份
restore_backup() {
    local backup_name="$1"
    
    if [ -z "$backup_name" ]; then
        log_error "请指定要恢复的备份名称"
        log_info "使用 '$0 list_backups' 查看可用备份"
        return 1
    fi
    
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [ ! -d "$backup_path" ]; then
        log_error "备份不存在: $backup_path"
        log_info "使用 '$0 list_backups' 查看可用备份"
        return 1
    fi
    
    log_warn "即将恢复备份: $backup_name"
    log_warn "这将覆盖当前存档！"
    echo -n "确认继续？(y/N): "
    read -r confirm
    
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log_info "操作已取消"
        return 0
    fi
    
    # 停止服务器
    if is_server_running; then
        log_info "停止服务器..."
        stop_server
        sleep 2
    fi
    
    # 备份当前存档
    if [ -d "$DST_DIR/$CLUSTER_NAME/save" ]; then
        log_info "备份当前存档..."
        create_backup "current_before_restore_$(date +%Y%m%d_%H%M%S)"
    fi
    
    # 恢复备份
    log_info "恢复备份: $backup_name"
    rm -rf "$DST_DIR/$CLUSTER_NAME/save"
    cp -r "$backup_path" "$DST_DIR/$CLUSTER_NAME/save"
    
    if [ $? -eq 0 ]; then
        log_info "备份恢复成功！"
        log_info "使用 '$0 start' 启动服务器"
        
        # 记录恢复信息
        echo "$(date): 备份恢复 - $backup_name" >> "$BACKUP_DIR/backup_log.txt"
    else
        log_error "备份恢复失败！"
        return 1
    fi
}

# 列出备份
list_backups() {
    log_info "可用备份列表:"
    echo "=================================="
    
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        log_warn "没有找到任何备份"
        return 0
    fi
    
    # 显示备份列表
    ls -la "$BACKUP_DIR" | grep "^d" | awk '{print $9}' | grep -v "^\.$\|^\.\.$" | while read -r backup; do
        if [ -n "$backup" ]; then
            local backup_path="$BACKUP_DIR/$backup"
            local backup_size=$(du -sh "$backup_path" 2>/dev/null | cut -f1)
            local backup_date=$(stat -c %y "$backup_path" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1)
            echo "  $backup (大小: $backup_size, 日期: $backup_date)"
        fi
    done
    
    echo "=================================="
    log_info "使用 '$0 restore <备份名称>' 恢复备份"
    log_info "使用 '$0 backup [备份名称]' 创建新备份"
}

# 显示帮助信息
show_help() {
    echo "WeGame版本饥荒专用服务器管理脚本"
    echo ""
    echo "使用方法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  start        启动服务器"
    echo "  stop         停止服务器"
    echo "  restart      重启服务器"
    echo "  status       查看服务器状态"
    echo "  update       更新服务器"
    echo "  logs         查看日志 (logs master|logs caves)"
    echo "  backup       创建备份 (backup [备份名称])"
    echo "  restore      恢复备份 (restore <备份名称>)"
    echo "  list_backups 列出所有备份"
    echo "  help         显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 start"
    echo "  $0 logs master"
    echo "  $0 status"
    echo "  $0 backup"
    echo "  $0 backup my_backup"
    echo "  $0 list_backups"
    echo "  $0 restore backup_20240101_120000"
}

# 主函数
main() {
    case "$1" in
        start)
            start_server
            ;;
        stop)
            stop_server
            ;;
        restart)
            restart_server
            ;;
        status)
            show_status
            ;;
        update)
            update_server
            ;;
        logs)
            show_logs "$2"
            ;;
        backup)
            create_backup "$2"
            ;;
        restore)
            restore_backup "$2"
            ;;
        list_backups)
            list_backups
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 检查是否以dstserver用户运行
if [ "$USER" != "dstserver" ]; then
    log_error "请以dstserver用户身份运行此脚本"
    exit 1
fi

# 检查服务器目录是否存在
if [ ! -d "$DST_DIR" ]; then
    log_error "服务器目录不存在: $DST_DIR"
    log_error "请先运行安装脚本"
    exit 1
fi

# 执行主函数
main "$@"

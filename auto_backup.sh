#!/bin/bash
# WeGame版本饥荒服务器自动备份脚本
# 建议通过crontab定期执行

DST_DIR="/home/dstserver/dst_server"
CLUSTER_NAME="cluster_1"
BACKUP_DIR="/home/dstserver/backups"
MAX_BACKUPS=10  # 保留的最大备份数量

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 检查服务器是否运行
is_server_running() {
    screen -list | grep -q "dst_server"
}

# 创建自动备份
auto_backup() {
    local backup_name="auto_backup_$(date +%Y%m%d_%H%M%S)"
    
    log_info "开始自动备份: $backup_name"
    
    # 创建备份目录
    mkdir -p "$BACKUP_DIR"
    
    # 检查存档目录是否存在
    if [ ! -d "$DST_DIR/$CLUSTER_NAME/save" ]; then
        log_error "存档目录不存在: $DST_DIR/$CLUSTER_NAME/save"
        return 1
    fi
    
    # 检查存档是否为空
    if [ -z "$(ls -A "$DST_DIR/$CLUSTER_NAME/save" 2>/dev/null)" ]; then
        log_warn "存档目录为空，跳过备份"
        return 0
    fi
    
    # 创建备份
    local backup_path="$BACKUP_DIR/$backup_name"
    cp -r "$DST_DIR/$CLUSTER_NAME/save" "$backup_path"
    
    if [ $? -eq 0 ]; then
        log_info "自动备份创建成功: $backup_path"
        
        # 记录备份信息
        echo "$(date): 自动备份创建 - $backup_name" >> "$BACKUP_DIR/backup_log.txt"
        
        # 清理旧备份
        cleanup_old_backups
        
        return 0
    else
        log_error "自动备份创建失败！"
        return 1
    fi
}

# 清理旧备份
cleanup_old_backups() {
    log_info "清理旧备份，保留最新 $MAX_BACKUPS 个备份"
    
    # 获取所有自动备份，按时间排序
    local backup_count=$(ls -1 "$BACKUP_DIR" | grep "^auto_backup_" | wc -l)
    
    if [ "$backup_count" -gt "$MAX_BACKUPS" ]; then
        local to_delete=$((backup_count - MAX_BACKUPS))
        log_info "需要删除 $to_delete 个旧备份"
        
        # 删除最旧的备份
        ls -1t "$BACKUP_DIR" | grep "^auto_backup_" | tail -n "$to_delete" | while read -r old_backup; do
            if [ -n "$old_backup" ]; then
                log_info "删除旧备份: $old_backup"
                rm -rf "$BACKUP_DIR/$old_backup"
                echo "$(date): 删除旧备份 - $old_backup" >> "$BACKUP_DIR/backup_log.txt"
            fi
        done
    else
        log_info "备份数量未超过限制，无需清理"
    fi
}

# 检查磁盘空间
check_disk_space() {
    local backup_dir_space=$(df "$BACKUP_DIR" | tail -1 | awk '{print $4}')
    local min_space=1048576  # 1GB in KB
    
    if [ "$backup_dir_space" -lt "$min_space" ]; then
        log_error "磁盘空间不足，无法创建备份"
        log_error "可用空间: $(($backup_dir_space / 1024))MB"
        return 1
    fi
    
    return 0
}

# 主函数
main() {
    log_info "开始自动备份检查"
    
    # 检查是否以dstserver用户运行
    if [ "$USER" != "dstserver" ]; then
        log_error "请以dstserver用户身份运行此脚本"
        exit 1
    fi
    
    # 检查服务器目录是否存在
    if [ ! -d "$DST_DIR" ]; then
        log_error "服务器目录不存在: $DST_DIR"
        exit 1
    fi
    
    # 检查磁盘空间
    if ! check_disk_space; then
        exit 1
    fi
    
    # 执行备份
    if auto_backup; then
        log_info "自动备份完成"
        exit 0
    else
        log_error "自动备份失败"
        exit 1
    fi
}

# 执行主函数
main "$@"

#!/bin/bash

# --- 颜色定义 ---
C_RESET='\033[0m'       # 重置所有属性
C_RED='\033[0;31m'       # 红色
C_GREEN='\033[0;32m'     # 绿色
C_YELLOW='\033[0;33m'    # 黄色
C_BLUE='\033[0;34m'      # 蓝色
C_CYAN='\033[0;36m'      # 青色
C_B_RED='\033[1;31m'      # 粗体红色
C_B_GREEN='\033[1;32m'    # 粗体绿色
C_B_YELLOW='\033[1;33m'   # 粗体黄色

# --- 配置 ---
REPO="xuanranran/OpenWRT-X86_64"                                           # 目标 GitHub 仓库
IMAGE_FILENAME_GZ="immortalwrt-x86-64-generic-squashfs-combined-efi.img.gz" # 压缩固件的文件名
IMAGE_FILENAME_IMG="${IMAGE_FILENAME_GZ%.gz}"                             # 解压后的固件文件名
CHECKSUM_FILENAME="sha256sums"                                             # 校验和文件名 (无 .txt 后缀)
TMP_DIR="/tmp"                                                             # 临时文件目录
IMAGE_PATH_GZ="$TMP_DIR/$IMAGE_FILENAME_GZ"                                # 压缩固件的完整路径
IMAGE_PATH_IMG="$TMP_DIR/$IMAGE_FILENAME_IMG"                              # 解压后固件的完整路径
CHECKSUM_PATH="$TMP_DIR/$CHECKSUM_FILENAME"                                # 校验和文件的完整路径
THRESHOLD_KIB=614400                                                       # 保留数据的空间阈值 (600 MiB in KiB)
MEM_THRESHOLD_KIB=1048576                                                  # 运行脚本的最低内存阈值 (1 GiB = 1024*1024 KiB)

# GitHub 访问方式配置（将在用户选择后设置）
GITHUB_PROXY=""  # GitHub 代理前缀

# --- 选择 GitHub 访问方式 ---
select_github_access() {
    echo
    echo -e "${C_CYAN}╔═══════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_CYAN}║${C_RESET}                 ${C_B_YELLOW}[🌐] GitHub 访问方式选择${C_RESET}                    ${C_CYAN}║${C_RESET}"
    echo -e "${C_CYAN}╚═══════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo
    echo -e "${C_CYAN}┌───────────────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET} ${C_B_BLUE}选择下载方式${C_RESET}                                                      ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}├───────────────────────────────────────────────────────────────────────┤${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}                                                                       ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}  ${C_GREEN}1)${C_RESET} ${C_B_GREEN}gh-proxy.com 镜像加速${C_RESET} ${C_YELLOW}(推荐)${C_RESET}                             ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}     ${C_CYAN}•${C_RESET} 适合网络受限环境                                           ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}     ${C_CYAN}•${C_RESET} 下载速度更快                                               ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}                                                                       ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}  ${C_BLUE}2)${C_RESET} GitHub 官方直连                                              ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}     ${C_CYAN}•${C_RESET} 需要稳定的国际网络连接                                     ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}     ${C_CYAN}•${C_RESET} 直接从官方服务器下载                                       ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}│${C_RESET}                                                                       ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}└───────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo
    read -p "$(echo -e "${C_YELLOW}❓ 请选择访问方式 [1-2] (默认: ${C_B_GREEN}1${C_RESET}${C_YELLOW}): ${C_RESET}")" github_choice
    github_choice=${github_choice:-1}
    
    echo
    case "$github_choice" in
        1)
            echo -e "${C_B_GREEN}✓ 已选择：${C_RESET}gh-proxy.com 镜像加速"
            GITHUB_PROXY="https://gh-proxy.com/"
            ;;
        2)
            echo -e "${C_B_GREEN}✓ 已选择：${C_RESET}GitHub 官方直连"
            GITHUB_PROXY=""
            ;;
        *)
            echo -e "${C_YELLOW}⚠ 无效选项，使用默认方式：${C_RESET}gh-proxy.com 镜像加速"
            GITHUB_PROXY="https://gh-proxy.com/"
            ;;
    esac
    echo
}

# --- 退出脚本时清理临时文件 ---
cleanup() {
  # 这个函数会在脚本退出时执行，清理本次运行产生的文件
  echo # 清理前空一行
  echo -e "${C_BLUE}信息：${C_RESET}正在清理本次运行时产生的临时文件..."
  rm -f "$IMAGE_PATH_GZ" "$IMAGE_PATH_IMG" "$CHECKSUM_PATH"
}
# 设置陷阱：当脚本退出时（EXIT信号），执行 cleanup 函数
# trap cleanup EXIT # 升级成功不会执行

# --- 设置：如果任何命令失败则立即退出 ---
# 在依赖项安装/检查步骤中会临时禁用此设置
# set -e

# *** 初始清理 /tmp ***
echo
echo -e "${C_BLUE}信息：${C_RESET}正在清理 /tmp 目录中可能存在的旧固件及校验文件..."
rm -f "$IMAGE_PATH_GZ" "$IMAGE_PATH_IMG" "$CHECKSUM_PATH"
echo -e "${C_YELLOW}警告：${C_RESET}  正在清理 /tmp 目录下所有的 ${C_RED}*.img${C_RESET} 和 ${C_RED}*.gz${C_RESET} 文件！"
/bin/rm -f ${TMP_DIR}/*.img ${TMP_DIR}/*.gz
echo -e "${C_BLUE}信息：${C_RESET}  .img / .gz 文件清理完成。"
echo -e "${C_BLUE}信息：${C_RESET}  正在清理 /tmp 目录下名称含 'upgrade' 或 'update' 的 .sh 脚本..."
/bin/rm -f ${TMP_DIR}/*upgrade*.sh ${TMP_DIR}/*update*.sh
echo -e "${C_BLUE}信息：${C_RESET}  相关 .sh 脚本清理完成。"
echo -e "${C_B_YELLOW}注意：${C_RESET}脚本【不会】清理 ${C_RED}/root${C_RESET} 目录下的任何文件。如有需要请手动清理。"
echo -e "${C_B_GREEN}初始清理完成。${C_RESET}"
# *** 清理结束 ***

echo
echo -e "${C_BLUE}=====================================================================${C_RESET}"
echo -e "${C_BLUE} OpenWRT/ImmortalWrt 自动升级脚本 ${C_RESET}"
echo -e "${C_BLUE}=====================================================================${C_RESET}"
echo

# --- 1. 检查并尝试安装依赖项 (使用字符串代替数组) ---
echo -e "${C_BLUE}--- 步骤 1: 检查并尝试安装依赖项 ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}检查所需工具 (wget, jq, gunzip, awk, sha256sum, lsblk)..."

PKG_MANAGER=""
UPDATE_CMD=""
INSTALL_CMD=""
UBUS_PRESENT=0

# 检测包管理器 (不变)
if command -v opkg >/dev/null 2>&1; then
    PKG_MANAGER="opkg"; UPDATE_CMD="opkg update"; INSTALL_CMD="opkg install";
elif command -v apk >/dev/null 2>&1; then
    PKG_MANAGER="apk"; UPDATE_CMD="apk update"; INSTALL_CMD="apk add";
else
    echo -e "${C_B_RED}错误：${C_RESET}无法检测到 'opkg' 或 'apk' 包管理器。" >&2; exit 1;
fi
echo -e "${C_BLUE}信息：${C_RESET}检测到包管理器: ${C_CYAN}${PKG_MANAGER}${C_RESET}"

if command -v ubus >/dev/null 2>&1; then UBUS_PRESENT=1; fi

update_run=0
# *** 修改点：使用字符串代替数组 ***
missing_pkgs_str=""                 # 空格分隔的待安装包名
missing_cmds_found_initially_str="" # 空格分隔的初始缺失命令名
required_cmds_list="wget jq gunzip awk sha256sum lsblk" # 需要检查的命令列表字符串

echo "信息：正在检查所需的 命令 ($required_cmds_list) 并识别需要安装的 软件包..."
for cmd_to_check in $required_cmds_list; do # 直接迭代字符串列表
    echo -e "${C_BLUE}信息：${C_RESET}  检查 命令 '${C_CYAN}${cmd_to_check}${C_RESET}'..."
    if ! command -v "$cmd_to_check" >/dev/null 2>&1; then
        pkg_name=""
        if [ "$cmd_to_check" == "gunzip" ]; then pkg_name="gzip";
        elif [ "$cmd_to_check" == "sha256sum" ]; then pkg_name="coreutils";
        elif [ "$cmd_to_check" == "lsblk" ]; then pkg_name="lsblk";
        elif [ "$cmd_to_check" == "wget" ] || [ "$cmd_to_check" == "jq" ]; then pkg_name="$cmd_to_check"; fi

        echo -e "  ${C_YELLOW}>> 命令 '$cmd_to_check' 未找到。${C_RESET}"
        # 追加缺失命令到字符串
        [ -n "$missing_cmds_found_initially_str" ] && missing_cmds_found_initially_str="$missing_cmds_found_initially_str "
        missing_cmds_found_initially_str="$missing_cmds_found_initially_str$cmd_to_check"

        if [ -n "$pkg_name" ]; then
            echo -e "     这个命令通常由 软件包 '${C_YELLOW}${pkg_name}${C_RESET}' 提供。"
            # 检查包名是否已在待安装列表字符串中 (使用 grep)
            if ! echo " $missing_pkgs_str " | grep -q " $pkg_name "; then
                 # 追加缺失包名到字符串
                 [ -n "$missing_pkgs_str" ] && missing_pkgs_str="$missing_pkgs_str "
                 missing_pkgs_str="$missing_pkgs_str$pkg_name"
            fi
        else
             echo -e "     这个命令 ('$cmd_to_check') 通常由系统基础包 (如 busybox) 提供。"
        fi
    else
        echo -e "  ${C_GREEN}>> 命令 '$cmd_to_check' 已找到。${C_RESET}"
    fi
done

# --- 尝试安装缺失的软件包 ---
if [ -n "$missing_pkgs_str" ]; then # 检查字符串是否非空
    echo -e "${C_YELLOW}警告：${C_RESET}检测到缺失必需的软件包: ${C_CYAN}${missing_pkgs_str}${C_RESET}"
    echo -e "${C_BLUE}信息：${C_RESET}正在尝试使用 '$PKG_MANAGER' 进行安装 (需要 root 权限和网络)..."
    if [ "$update_run" -eq 0 ]; then
        echo -e "${C_BLUE}信息：${C_RESET}  正在运行软件包列表更新 (${C_CYAN}${UPDATE_CMD}${C_RESET})..."
        set +e; $UPDATE_CMD; update_status=$?; set -e
        if [ $update_status -ne 0 ]; then echo -e "${C_YELLOW}警告：${C_RESET}  软件包列表更新失败 (退出码 $update_status)，但仍尝试安装..."; fi
        update_run=1
    fi
    echo -e "${C_BLUE}信息：${C_RESET}  正在运行安装命令 (${C_CYAN}${INSTALL_CMD} ${missing_pkgs_str}${C_RESET})..."
    set +e; $INSTALL_CMD $missing_pkgs_str; install_status=$?; set -e # 使用包名字符串
    if [ $install_status -ne 0 ]; then echo -e "${C_YELLOW}警告：${C_RESET}  软件包安装命令退出码为 $install_status。"; fi

    # 重新检查依赖项
    echo "信息：正在重新检查依赖项..."
    final_recheck_missing_cmds_str=""
    # 迭代初始缺失的命令字符串
    for cmd_to_recheck in $missing_cmds_found_initially_str; do
        if ! command -v "$cmd_to_recheck" >/dev/null 2>&1; then
             # 检查这个命令对应的包是否在我们尝试安装的列表里
             pkg_to_find=""
             if [ "$cmd_to_recheck" == "gunzip" ]; then pkg_to_find="gzip";
             elif [ "$cmd_to_recheck" == "sha256sum" ]; then pkg_to_find="coreutils";
             elif [ "$cmd_to_recheck" == "lsblk" ]; then pkg_to_find="lsblk";
             elif [ "$cmd_to_recheck" == "wget" ]; then pkg_to_find="wget";
             elif [ "$cmd_to_recheck" == "jq" ]; then pkg_to_find="jq"; fi

             if [ -n "$pkg_to_find" ] && echo " $missing_pkgs_str " | grep -q " $pkg_to_find "; then
                  # 如果是我们尝试安装的包对应的命令，并且现在还找不到，则记录最终缺失
                  [ -n "$final_recheck_missing_cmds_str" ] && final_recheck_missing_cmds_str="$final_recheck_missing_cmds_str "
                  final_recheck_missing_cmds_str="$final_recheck_missing_cmds_str$cmd_to_recheck"
             fi
        fi
    done
    if [ -n "$final_recheck_missing_cmds_str" ]; then
         echo -e "${C_B_RED}错误：${C_RESET}必需的依赖项安装失败或仍然缺失。" >&2
         echo -e "       仍然缺失以下命令: ${C_RED}${final_recheck_missing_cmds_str}${C_RESET}" >&2
         exit 1
     else
         echo -e "${C_B_GREEN}信息：${C_RESET}所有尝试安装的必需软件包似乎都已成功安装。"
     fi
fi

# 最终确认所有命令都存在
echo "信息：依赖项最终检查..."
final_check_missing_cmds_str=""
# *** 修改点：直接迭代命令字符串列表进行最终检查 ***
for cmd_to_verify in $required_cmds_list; do
    if ! command -v "$cmd_to_verify" >/dev/null 2>&1; then
        [ -n "$final_check_missing_cmds_str" ] && final_check_missing_cmds_str="$final_check_missing_cmds_str "
        final_check_missing_cmds_str="$final_check_missing_cmds_str$cmd_to_verify"
    fi
done

if [ -n "$final_check_missing_cmds_str" ]; then # 检查字符串是否非空
    echo -e "${C_B_RED}错误：${C_RESET}脚本运行缺少必要的命令: ${C_RED}${final_check_missing_cmds_str}${C_RESET}" >&2
    exit 1
fi

# 显示依赖项检查总结表格
echo
echo -e "${C_CYAN}┌──────────────────────────┬────────────────────────────────────────────┐${C_RESET}"
echo -e "${C_CYAN}│${C_RESET} ${C_B_BLUE}依赖项检查总结${C_RESET}           ${C_CYAN}│${C_RESET} ${C_B_BLUE}状态${C_RESET}                                   ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}╞══════════════════════════╪════════════════════════════════════════════╡${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "包管理器" "$PKG_MANAGER"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "必需命令" "已找到所有依赖 ($required_cmds_list)"
echo -e "${C_CYAN}└──────────────────────────┴────────────────────────────────────────────┘${C_RESET}"
echo -e "${C_BLUE}--- 步骤 1 完成 ---${C_RESET}"
echo

# 启用严格错误检查
set -e

# --- 2. 显示系统和磁盘信息 ---
echo -e "${C_BLUE}--- 步骤 2: 显示系统信息并检查内存 ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}正在收集当前系统信息..."
echo

# --- 内存检查 (必须 >= 1GiB) ---
echo -e "${C_CYAN}>> 内存检查:${C_RESET}"
mem_total_kib=$(grep '^MemTotal:' /proc/meminfo | awk '{print $2}')

if [ -z "$mem_total_kib" ]; then
    echo -e "  ${C_YELLOW}警告：无法读取总内存大小，跳过内存检查。${C_RESET}"
elif [ "$mem_total_kib" -lt "$MEM_THRESHOLD_KIB" ]; then
    mem_total_mib=$(awk -v total_kib="$mem_total_kib" 'BEGIN { printf "%.0f", total_kib/1024 }')
    echo -e "  ${C_B_RED}错误：系统总内存 (${mem_total_mib} MiB) 低于运行此脚本所需的最低要求 (1024 MiB)。${C_RESET}" >&2
    echo -e "        为避免下载或解压失败，脚本将退出。" >&2
    exit 1
else
    mem_total_mib=$(awk -v total_kib="$mem_total_kib" 'BEGIN { printf "%.0f", total_kib/1024 }')
    echo -e "  ${C_GREEN}内存检查通过 (总计: ${mem_total_mib} MiB)。${C_RESET}"
fi
echo

# --- 显示简化内存信息 ---
echo -e "${C_CYAN}>> 内存信息 (当前):${C_RESET}"
mem_avail_kib=$(grep '^MemAvailable:' /proc/meminfo | awk '{print $2}')

if [ -n "$mem_total_kib" ]; then
    if [ -n "$mem_avail_kib" ]; then
        awk -v total_kib="$mem_total_kib" -v avail_kib="$mem_avail_kib" 'BEGIN { printf "  总计: %.0f MiB / 可用: %.0f MiB\n", total_kib/1024, avail_kib/1024 }'
    else
         awk -v total_kib="$mem_total_kib" 'BEGIN { printf "  总计: %.0f MiB\n", total_kib/1024 }'
         echo -e "  ${C_YELLOW}(无法获取可用内存信息)${C_RESET}"
    fi
else
    echo -e "  ${C_YELLOW}无法从 /proc/meminfo 获取内存信息。${C_RESET}"
fi
echo

# --- 其他系统信息 ---
echo -e "${C_CYAN}>> 设备型号/主板信息:${C_RESET}"
model_info_found=0
if [ $UBUS_PRESENT -eq 1 ]; then
    ubus_output=$(ubus call system board 2>/dev/null);
    if [ -n "$ubus_output" ]; then
        model=$(echo "$ubus_output" | jq -r '.model // empty'); board=$(echo "$ubus_output" | jq -r '.board_name // empty');
        if [ -n "$model" ] || [ -n "$board" ]; then
             echo "  来源: ubus"; [ -n "$model" ] && echo "    型号: $model"; [ -n "$board" ] && echo "    主板: $board"; model_info_found=1;
        else echo -e "  ${C_YELLOW}(ubus 未返回有效型号/主板信息)${C_RESET}"; fi
    else echo -e "  ${C_YELLOW}(ubus 命令执行失败或无输出)${C_RESET}"; fi
fi
if [ $model_info_found -eq 0 ] && [ -f /tmp/sysinfo/model ]; then
    model_sysinfo=$(cat /tmp/sysinfo/model); if [ -n "$model_sysinfo" ]; then echo "  来源: /tmp/sysinfo/model"; echo "    型号: $model_sysinfo"; model_info_found=1; fi
fi
if [ $model_info_found -eq 0 ] && [ -r /proc/device-tree/model ]; then
     model_dt=$(cat /proc/device-tree/model 2>/dev/null | tr -d '\0'); if [ -n "$model_dt" ]; then echo "  来源: /proc/device-tree/model"; echo "    型号: $model_dt"; model_info_found=1; fi
fi
if [ $model_info_found -eq 0 ]; then echo -e "  ${C_YELLOW}无法自动确定设备型号或主板名称。${C_RESET}"; fi
echo

# CPU 信息 (简化)
echo -e "${C_CYAN}>> CPU:${C_RESET}"
grep 'model name' /proc/cpuinfo | head -n1 | sed 's/^model name[[:space:]]*: /  /' || echo -e "  ${C_YELLOW}无法获取 CPU 型号。${C_RESET}"
echo

# 磁盘分区和挂载点信息 (lsblk)
echo -e "${C_CYAN}>> 磁盘分区布局 (lsblk):${C_RESET}"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT 2>/dev/null | sed 's/^/  /' || echo -e "  ${C_YELLOW}警告：${C_RESET}'lsblk' 命令执行失败或未安装。"
echo

# 文件系统使用情况和类型 (df)
echo -e "${C_CYAN}>> 文件系统使用情况 (df -hT):${C_RESET}"
df -hT | sed 's/^/  /' || echo -e "  ${C_YELLOW}无法获取文件系统使用情况。${C_RESET}"
echo

# 系统信息总结表格
echo
echo -e "${C_CYAN}┌──────────────────────────┬────────────────────────────────────────────┐${C_RESET}"
echo -e "${C_CYAN}│${C_RESET} ${C_B_BLUE}系统信息总结${C_RESET}             ${C_CYAN}│${C_RESET} ${C_B_BLUE}详情${C_RESET}                                   ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}╞══════════════════════════╪════════════════════════════════════════════╡${C_RESET}"

# 内存信息
if [ -n "$mem_total_kib" ]; then
    mem_total_mib=$(awk -v total_kib="$mem_total_kib" 'BEGIN { printf "%.0f MiB", total_kib/1024 }')
    if [ -n "$mem_avail_kib" ]; then
        mem_avail_mib=$(awk -v avail_kib="$mem_avail_kib" 'BEGIN { printf "%.0f MiB", avail_kib/1024 }')
        printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "内存" "总计: $mem_total_mib / 可用: $mem_avail_mib"
    else
        printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "内存" "总计: $mem_total_mib"
    fi
else
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_YELLOW}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "内存" "无法获取"
fi

echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"

# 设备型号
if [ $model_info_found -eq 1 ]; then
    if [ -n "$model" ]; then
        # 截断过长的型号名
        if [ ${#model} -gt 42 ]; then
            model_display="${model:0:39}..."
        else
            model_display="$model"
        fi
        printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "设备型号" "$model_display"
    elif [ -n "$model_sysinfo" ]; then
        if [ ${#model_sysinfo} -gt 42 ]; then
            model_display="${model_sysinfo:0:39}..."
        else
            model_display="$model_sysinfo"
        fi
        printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "设备型号" "$model_display"
    else
        printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_YELLOW}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "设备型号" "未知"
    fi
else
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_YELLOW}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "设备型号" "无法确定"
fi

echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"

# /tmp 空间
tmp_size=$(df -h /tmp 2>/dev/null | awk 'NR==2 {print $2}')
tmp_avail=$(df -h /tmp 2>/dev/null | awk 'NR==2 {print $4}')
if [ -n "$tmp_size" ] && [ -n "$tmp_avail" ]; then
    printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_GREEN}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "/tmp 空间" "总计: $tmp_size / 可用: $tmp_avail"
else
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_YELLOW}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "/tmp 空间" "无法获取"
fi

echo -e "${C_CYAN}└──────────────────────────┴────────────────────────────────────────────┘${C_RESET}"

echo -e "${C_BLUE}--- 步骤 2 完成 ---${C_RESET}"
echo

# 选择 GitHub 访问方式
select_github_access

# 启用严格错误检查
set -e

# --- 3. 临时增大 /tmp 分区 ---
echo -e "${C_BLUE}--- 步骤 3: 临时增大 /tmp 分区 ---${C_RESET}"
echo
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_B_YELLOW}[*] /tmp 分区扩容选项${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "  ${C_BLUE}提示：${C_RESET}可以临时将 /tmp 分区扩大到 RAM 的 100%"
echo -e "  ${C_GREEN}• 有助于存储下载和解压的固件文件${C_RESET}"
echo -e "  ${C_YELLOW}• 此更改仅在本次运行期间有效，重启后失效${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "\n${C_BLUE}信息：${C_RESET}/tmp 当前大小:"
df -h /tmp | sed 's/^/  /'
echo
read -p "$(echo -e "${C_YELLOW}❓ 是否临时扩大 /tmp 分区？(Y/n) [默认: ${C_B_GREEN}是${C_RESET}${C_YELLOW}]: ${C_RESET}")" confirm_resize_tmp
confirm_resize_tmp=${confirm_resize_tmp:-Y}  # 默认为Y

if [[ "$confirm_resize_tmp" =~ ^[Yy]$ ]]; then
    echo -e "${C_BLUE}信息：${C_RESET}正在尝试将 /tmp 重新挂载为更大内存（RAM 的 100%）..."
    mount -t tmpfs -o remount,size=100% tmpfs /tmp || echo -e "${C_YELLOW}警告：${C_RESET}重新挂载 /tmp 可能失败或不受支持，继续执行..."
    echo -e "${C_BLUE}信息：${C_RESET}/tmp 扩容后大小:"
    df -h /tmp | sed 's/^/  /'
else
    echo -e "${C_YELLOW}信息：${C_RESET}用户选择跳过 /tmp 分区扩容。"
fi
echo -e "${C_BLUE}--- 步骤 3 完成 ---${C_RESET}"
echo

# --- 4. 获取最新 Release 信息 ---
echo -e "${C_BLUE}--- 步骤 4: 获取最新 Release 信息 ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}正在从 GitHub 仓库 '${C_CYAN}${REPO}${C_RESET}' 获取最新版本信息..."
API_URL="${GITHUB_PROXY}https://api.github.com/repos/$REPO/releases/latest"
RELEASE_INFO=$(wget -qO- --no-check-certificate "$API_URL")
if [ -z "$RELEASE_INFO" ]; then echo -e "${C_B_RED}错误：${C_RESET}无法从 GitHub API 获取版本信息。" >&2; exit 1; fi
RELEASE_TAG=$(echo "$RELEASE_INFO" | jq -r '.tag_name // "未知标签"')
echo -e "${C_BLUE}信息：${C_RESET}找到最新版本标签: ${C_GREEN}${RELEASE_TAG}${C_RESET}"
echo -e "${C_BLUE}--- 步骤 4 完成 ---${C_RESET}"
echo

# --- 5. 查找固件和校验文件 URL ---
echo -e "${C_BLUE}--- 步骤 5: 查找文件 URL ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}正在查找固件 '${C_CYAN}${IMAGE_FILENAME_GZ}${C_RESET}' 和校验文件 '${C_CYAN}${CHECKSUM_FILENAME}${C_RESET}'..."
IMAGE_URL=$(echo "$RELEASE_INFO" | jq -r --arg NAME "$IMAGE_FILENAME_GZ" '.assets[] | select(.name==$NAME) | .browser_download_url')
CHECKSUM_URL=$(echo "$RELEASE_INFO" | jq -r --arg NAME "$CHECKSUM_FILENAME" '.assets[] | select(.name==$NAME) | .browser_download_url')

SKIP_CHECKSUM=0
if [ -z "$IMAGE_URL" ] || [ "$IMAGE_URL" == "null" ]; then echo -e "${C_B_RED}错误：${C_RESET}在版本 '${C_YELLOW}${RELEASE_TAG}${C_RESET}' 中未找到固件文件 '${C_RED}${IMAGE_FILENAME_GZ}${C_RESET}'。" >&2; exit 1; fi
echo -e "${C_BLUE}信息：${C_RESET}找到固件下载链接: ${C_CYAN}${IMAGE_URL}${C_RESET}"
if [ -z "$CHECKSUM_URL" ] || [ "$CHECKSUM_URL" == "null" ]; then echo -e "${C_YELLOW}警告：${C_RESET}未找到校验文件 '${C_YELLOW}${CHECKSUM_FILENAME}${C_RESET}'，将【自动跳过】文件完整性校验。"; SKIP_CHECKSUM=1; else echo -e "${C_BLUE}信息：${C_RESET}找到校验文件下载链接: ${C_CYAN}${CHECKSUM_URL}${C_RESET}"; fi
echo -e "${C_BLUE}--- 步骤 5 完成 ---${C_RESET}"
echo

# --- 6. 下载前确认 ---
echo -e "${C_BLUE}--- 步骤 6: 下载前确认 ---${C_RESET}"
echo
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_B_YELLOW}[↓] 固件下载确认${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo
echo -e "${C_CYAN}┌──────────────────────────┬────────────────────────────────────────────┐${C_RESET}"
echo -e "${C_CYAN}│${C_RESET} ${C_B_BLUE}项目${C_RESET}                     ${C_CYAN}│${C_RESET} ${C_B_BLUE}详情${C_RESET}                                   ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}╞══════════════════════════╪════════════════════════════════════════════╡${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_CYAN}[#]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "版本标签"
echo -e "${C_GREEN}${RELEASE_TAG}${C_RESET}$(printf '%*s' $((42 - ${#RELEASE_TAG})) '') ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_CYAN}[↓]${C_RESET} %-20s ${C_CYAN}│${C_RESET} %-42s ${C_CYAN}│${C_RESET}\\n" "固件文件" "$(basename "$IMAGE_FILENAME_GZ")"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
if [ $SKIP_CHECKSUM -eq 1 ]; then 
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} ${C_YELLOW}%-42s${C_RESET} ${C_CYAN}│${C_RESET}\\n" "校验文件" "未找到"
else 
    printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} %-42s ${C_CYAN}│${C_RESET}\\n" "校验文件" "$(basename "$CHECKSUM_FILENAME")"
fi
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_CYAN}[>]${C_RESET} %-20s ${C_CYAN}│${C_RESET} %-42s ${C_CYAN}│${C_RESET}\\n" "保存路径" "$TMP_DIR"
echo -e "${C_CYAN}└──────────────────────────┴────────────────────────────────────────────┘${C_RESET}"
echo
read -p "$(echo -e "\n${C_YELLOW}❓ 是否开始下载此固件文件？(Y/n) [默认: ${C_B_GREEN}是${C_RESET}${C_YELLOW}]: ${C_RESET}")" confirm_download
confirm_download=${confirm_download:-Y}  # 默认为Y
if [[ ! "$confirm_download" =~ ^[Yy]$ ]]; then echo -e "${C_YELLOW}操作已取消，未下载固件。${C_RESET}"; exit 0; fi
echo

# --- 7. 下载文件 ---
echo -e "${C_BLUE}--- 步骤 7: 下载文件 ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}正在下载压缩固件 '${C_CYAN}${IMAGE_FILENAME_GZ}${C_RESET}' 到 '${C_CYAN}${IMAGE_PATH_GZ}${C_RESET}' ..."
wget --progress=bar:force --no-check-certificate -O "$IMAGE_PATH_GZ" "$IMAGE_URL"
echo -e "${C_B_GREEN}信息：${C_RESET}压缩固件下载完成。"

# 下载校验文件
if [ $SKIP_CHECKSUM -eq 0 ]; then
    echo -e "${C_BLUE}信息：${C_RESET}正在下载校验文件 '${C_CYAN}${CHECKSUM_FILENAME}${C_RESET}' 到 '${C_CYAN}${CHECKSUM_PATH}${C_RESET}' ..."
    set +e; wget -q --no-check-certificate -O "$CHECKSUM_PATH" "$CHECKSUM_URL"; dl_status=$?; set -e
    if [ $dl_status -ne 0 ]; then
        echo -e "${C_YELLOW}警告：${C_RESET}下载校验文件 '${C_YELLOW}${CHECKSUM_FILENAME}${C_RESET}' 失败，将跳过文件完整性校验。"
        rm -f "$CHECKSUM_PATH"; SKIP_CHECKSUM=1;
    else echo -e "${C_B_GREEN}信息：${C_RESET}校验文件下载完成。"; fi
fi
echo -e "${C_BLUE}--- 步骤 7 完成 ---${C_RESET}"
echo

# --- 8. 校验固件完整性 (询问是否执行) ---
echo -e "${C_BLUE}--- 步骤 8: 校验固件完整性 (SHA256) ---${C_RESET}"
if [ $SKIP_CHECKSUM -eq 1 ]; then
    echo -e "${C_YELLOW}信息：由于之前步骤未能找到或下载校验文件，跳过文件完整性校验。${C_RESET}"
else
    echo
    echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "${C_B_YELLOW}[#] 文件完整性校验选项${C_RESET}"
    echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${C_BLUE}提示：${C_RESET}执行 SHA256 校验可以确保固件文件完整性"
    echo -e "  ${C_GREEN}• 推荐执行校验以确保固件未被损坏或篡改${C_RESET}"
    echo -e "  ${C_YELLOW}• 跳过校验可能导致升级失败或系统损坏${C_RESET}"
    echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    read -p "$(echo -e "\n${C_YELLOW}❓ 是否执行 SHA256 固件完整性校验？(Y/n) [默认: ${C_B_GREEN}是${C_RESET}${C_YELLOW}]: ${C_RESET}")" confirm_run_checksum
    confirm_run_checksum=${confirm_run_checksum:-Y}  # 默认为Y

    if [[ "$confirm_run_checksum" =~ ^[Nn]$ ]]; then
        echo -e "${C_YELLOW}信息：用户选择跳过文件完整性校验。${C_RESET}"
        SKIP_CHECKSUM=1
    else
        echo -e "${C_BLUE}信息：${C_RESET}正在校验文件 '${C_CYAN}${IMAGE_FILENAME_GZ}${C_RESET}' 的 SHA256 哈希值..."
        EXPECTED_SUM=$(grep "$IMAGE_FILENAME_GZ" "$CHECKSUM_PATH" | awk '{print $1}')
        if [ -z "$EXPECTED_SUM" ]; then
             echo -e "${C_YELLOW}警告：${C_RESET}在校验文件 '${C_YELLOW}${CHECKSUM_FILENAME}${C_RESET}' 中未能找到固件 '${C_YELLOW}${IMAGE_FILENAME_GZ}${C_RESET}' 的校验信息。跳过校验。"
             SKIP_CHECKSUM=1
        else
            CALCULATED_SUM=$(sha256sum "$IMAGE_PATH_GZ" | awk '{print $1}')
            echo
            echo -e "${C_CYAN}┌──────────────────────────┬────────────────────────────────────────────┐${C_RESET}"
            echo -e "${C_CYAN}│${C_RESET} ${C_B_BLUE}校验项${C_RESET}                   ${C_CYAN}│${C_RESET} ${C_B_BLUE}SHA256 哈希值${C_RESET}                          ${C_CYAN}│${C_RESET}"
            echo -e "${C_CYAN}╞══════════════════════════╪════════════════════════════════════════════╡${C_RESET}"
            printf "${C_CYAN}│${C_RESET} ${C_CYAN}[>]${C_RESET} %-20s ${C_CYAN}│${C_RESET} %-42s ${C_CYAN}│${C_RESET}\\n" "期望值" "$EXPECTED_SUM"
            echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
            printf "${C_CYAN}│${C_RESET} ${C_CYAN}[>]${C_RESET} %-20s ${C_CYAN}│${C_RESET} %-42s ${C_CYAN}│${C_RESET}\\n" "计算值" "$CALCULATED_SUM"
            echo -e "${C_CYAN}└──────────────────────────┴────────────────────────────────────────────┘${C_RESET}"
            echo
            if [ "$EXPECTED_SUM" == "$CALCULATED_SUM" ]; then
                echo -e "${C_B_GREEN}✅ 校验成功！文件完整。${C_RESET}"
            else
                echo; echo -e "${C_B_RED}❌ 错误：SHA256 校验和不匹配！文件可能已损坏或不完整。${C_RESET}"; echo
                read -p "$(echo -e "${C_B_YELLOW}❓ 警告：文件校验失败！是否仍要继续升级？(y/N): ${C_RESET}")" confirm_checksum_fail
                if [[ ! "$confirm_checksum_fail" =~ ^[Yy]$ ]]; then echo -e "${C_YELLOW}操作中止。${C_RESET}"; exit 1; fi
                echo -e "${C_YELLOW}信息：用户选择忽略校验失败并继续。${C_RESET}"
                SKIP_CHECKSUM=1
            fi
        fi
    fi
fi
rm -f "$CHECKSUM_PATH" # 清理校验文件
echo -e "${C_BLUE}--- 步骤 8 完成 ---${C_RESET}"
echo

# --- 9. 解压固件 ---
echo -e "${C_BLUE}--- 步骤 9: 解压固件 ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}正在解压固件 '${C_CYAN}${IMAGE_PATH_GZ}${C_RESET}' -> '${C_CYAN}${IMAGE_PATH_IMG}${C_RESET}' ..."
gunzip "$IMAGE_PATH_GZ"
if [ ! -f "$IMAGE_PATH_IMG" ]; then echo -e "${C_B_RED}错误：${C_RESET}解压后未找到文件 '${C_RED}${IMAGE_PATH_IMG}${C_RESET}'。" >&2; exit 1; fi
echo -e "${C_B_GREEN}信息：${C_RESET}固件解压完成。解压后文件: '${C_CYAN}${IMAGE_PATH_IMG}${C_RESET}'"
ls -lh "$IMAGE_PATH_IMG"
echo -e "${C_BLUE}--- 步骤 9 完成 ---${C_RESET}"
echo

# --- 10. 检查空间并确定升级选项 ---
echo -e "${C_BLUE}--- 步骤 10: 检查空间并确定升级选项 ---${C_RESET}"
echo -e "${C_BLUE}信息：${C_RESET}正在检查 /tmp 可用空间以确定升级选项..."
AVAILABLE_KIB=$(df -k /tmp | awk 'NR==2 {print $4}')

SYSUPGRADE_ARGS=""
KEEP_DATA_ALLOWED=1

if [ -z "$AVAILABLE_KIB" ] || ! [[ "$AVAILABLE_KIB" =~ ^[0-9]+$ ]]; then
    echo -e "${C_YELLOW}警告：${C_RESET}无法准确获取 /tmp 可用空间。将允许用户选择是否保留配置。"
    KEEP_DATA_ALLOWED=1
elif [ "$AVAILABLE_KIB" -lt "$THRESHOLD_KIB" ]; then
    echo -e "${C_YELLOW}警告：${C_RESET}/tmp 可用空间 (${C_YELLOW}${AVAILABLE_KIB}${C_RESET} KiB) 低于所需阈值 (${C_YELLOW}${THRESHOLD_KIB}${C_RESET} KiB)。"
    echo -e "      将强制【${C_B_YELLOW}不保留配置${C_RESET}】数据进行升级 (使用 -n 选项)。"
    SYSUPGRADE_ARGS="-n"; KEEP_DATA_ALLOWED=0;
else
    echo -e "${C_GREEN}信息：${C_RESET}/tmp 可用空间 (${C_GREEN}${AVAILABLE_KIB}${C_RESET} KiB) 充足。"
    KEEP_DATA_ALLOWED=1
fi

if [ "$KEEP_DATA_ALLOWED" -eq 1 ]; then
    echo
    echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "${C_B_YELLOW}[+] 配置数据保留选项${C_RESET}"
    echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${C_BLUE}提示：${C_RESET}您可以选择在升级时保留或清除配置数据"
    echo -e "  ${C_GREEN}• 保留配置${C_RESET} - 升级后保留当前系统设置"
    echo -e "  ${C_YELLOW}• 清除配置${C_RESET} - 升级后恢复为出厂设置"
    echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    read -p "$(echo -e "\n${C_YELLOW}❓ 是否保留配置数据？(Y/n) [默认: ${C_B_GREEN}是${C_RESET}${C_YELLOW}]: ${C_RESET}")" confirm_keep_data
    confirm_keep_data=${confirm_keep_data:-Y}  # 默认为Y
    if [[ "$confirm_keep_data" =~ ^[Nn]$ ]]; then
        echo -e "${C_BLUE}信息：${C_RESET}用户选择【${C_YELLOW}不保留${C_RESET}】配置数据进行升级。"
        SYSUPGRADE_ARGS="-n"
    else
        echo -e "${C_BLUE}信息：${C_RESET}将尝试【${C_GREEN}保留${C_RESET}】配置数据进行升级。"
        SYSUPGRADE_ARGS=""
    fi
fi
echo -e "${C_BLUE}--- 步骤 10 完成 ---${C_RESET}"
echo

# --- 11. 询问可选参数并最终确认 ---
echo -e "${C_BLUE}--- 步骤 11: 配置可选参数并最终确认 ---${C_RESET}"
# 这些变量在后面构建表格时使用，此处不再需要预先构建UPGRADE_INFO字符串

# --- 询问是否强制升级 (-F) ---
FORCE_FLAG=""
echo -e "\n${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_B_RED}[!] 强制升级选项 (-F)${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "  ${C_YELLOW}警告：${C_RESET}'-F' 选项会跳过固件兼容性检查"
echo -e "  ${C_RED}• 使用不兼容的固件可能导致设备变砖！${C_RESET}"
echo -e "  ${C_YELLOW}• 仅在您完全确定固件正确且了解风险时才使用${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
read -p "$(echo -e "\n${C_B_YELLOW}❓ 是否使用强制升级 '-F' 选项？(y/N) [默认: ${C_B_GREEN}否${C_RESET}${C_B_YELLOW}]: ${C_RESET}")" confirm_force
confirm_force=${confirm_force:-N}  # 默认为N
FORCE_FLAG_INFO=""
if [[ "$confirm_force" =~ ^[Yy]$ ]]; then
    echo -e "${C_BLUE}信息：${C_RESET}用户选择【${C_B_RED}使用${C_RESET}】强制 '-F' 选项！"
    FORCE_FLAG="-F"; FORCE_FLAG_INFO="${C_B_RED}是 (-F)${C_RESET}";
else
    echo -e "${C_BLUE}信息：${C_RESET}本次升级将【${C_GREEN}不使用${C_RESET}】强制 '-F' 选项。"
    FORCE_FLAG=""; FORCE_FLAG_INFO="${C_GREEN}否${C_RESET}";
fi

# --- 询问是否详细输出 (-v) ---
VERBOSE_FLAG=""
echo
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_B_YELLOW}[i] 详细日志选项 (-v)${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "  ${C_BLUE}提示：${C_RESET}启用详细输出可查看升级过程的详细信息"
echo -e "  ${C_YELLOW}• 一般用户建议使用默认模式${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
read -p "$(echo -e "\n${C_YELLOW}❓ 是否启用详细输出模式？(y/N) [默认: ${C_B_GREEN}否${C_RESET}${C_YELLOW}]: ${C_RESET}")" confirm_verbose
confirm_verbose=${confirm_verbose:-N}  # 默认为N
VERBOSE_FLAG_INFO=""
if [[ "$confirm_verbose" =~ ^[Yy]$ ]]; then
    echo -e "${C_BLUE}信息：${C_RESET}用户选择【${C_GREEN}启用${C_RESET}】详细输出模式 (-v)。"
    VERBOSE_FLAG="-v"; VERBOSE_FLAG_INFO="${C_GREEN}是 (-v)${C_RESET}";
else
    echo -e "${C_BLUE}信息：${C_RESET}本次升级将【${C_YELLOW}不启用${C_RESET}】详细输出模式。"
    VERBOSE_FLAG=""; VERBOSE_FLAG_INFO="${C_YELLOW}否${C_RESET}";
fi

# --- 最终确认与执行 ---
echo
echo -e "${C_CYAN}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
echo -e "${C_CYAN}║${C_RESET}                   ${C_B_YELLOW}[=] 升级前最终确认${C_RESET}                      ${C_CYAN}║${C_RESET}"
echo -e "${C_CYAN}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
echo

# 构建表格内容
DATA_MODE_INFO=""
if [ "$SYSUPGRADE_ARGS" == "-n" ]; then
    DATA_MODE_INFO="${C_YELLOW}不保留配置 (-n)${C_RESET}"
else
    DATA_MODE_INFO="${C_GREEN}保留配置${C_RESET}"
fi

CHECKSUM_INFO=""
if [ $SKIP_CHECKSUM -eq 1 ]; then
    CHECKSUM_INFO="${C_YELLOW}跳过/未执行${C_RESET}"
else
    CHECKSUM_INFO="${C_GREEN}SHA256 已验证${C_RESET}"
fi

echo -e "${C_CYAN}┌──────────────────────────┬────────────────────────────────────────────┐${C_RESET}"
echo -e "${C_CYAN}│${C_RESET} ${C_B_BLUE}项目${C_RESET}                     ${C_CYAN}│${C_RESET} ${C_B_BLUE}详情${C_RESET}                                   ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}╞══════════════════════════╪════════════════════════════════════════════╡${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_CYAN}[>]${C_RESET} %-20s ${C_CYAN}│${C_RESET} %-42s ${C_CYAN}│${C_RESET}\\n" "固件文件" "$(basename "$IMAGE_PATH_IMG")"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
printf "${C_CYAN}│${C_RESET} ${C_CYAN}[#]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "版本标签"
echo -e "${C_GREEN}${RELEASE_TAG}${C_RESET}$(printf '%*s' $((42 - ${#RELEASE_TAG})) '') ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
# 配置数据行带图标
if [ "$SYSUPGRADE_ARGS" == "-n" ]; then
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[×]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "配置数据"
else
    printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET}" "配置数据"
fi
echo -e "${DATA_MODE_INFO}$(printf '%*s' $((42 - $(echo -e "${DATA_MODE_INFO}" | sed 's/\x1b\[[0-9;]*m//g' | wc -c) + 1)) '') ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
# 强制升级行
if [[ "$FORCE_FLAG_INFO" == *"是"* ]]; then
    printf "${C_CYAN}│${C_RESET} ${C_B_RED}[!]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "强制升级 (-F)"
else
    printf "${C_CYAN}│${C_RESET} ${C_GREEN}[✓]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "强制升级 (-F)"
fi
echo -e "${FORCE_FLAG_INFO}$(printf '%*s' $((42 - $(echo -e "${FORCE_FLAG_INFO}" | sed 's/\x1b\[[0-9;]*m//g' | wc -c) + 1)) '') ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
# 详细输出行
if [[ "$VERBOSE_FLAG_INFO" == *"是"* ]]; then
    printf "${C_CYAN}│${C_RESET} ${C_GREEN}[i]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "详细输出 (-v)"
else
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "详细输出 (-v)"
fi
echo -e "${VERBOSE_FLAG_INFO}$(printf '%*s' $((42 - $(echo -e "${VERBOSE_FLAG_INFO}" | sed 's/\x1b\[[0-9;]*m//g' | wc -c) + 1)) '') ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}├──────────────────────────┼────────────────────────────────────────────┤${C_RESET}"
# 文件校验行
if [ $SKIP_CHECKSUM -eq 1 ]; then
    printf "${C_CYAN}│${C_RESET} ${C_YELLOW}[-]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "文件校验"
else
    printf "${C_CYAN}│${C_RESET} ${C_GREEN}[√]${C_RESET} %-20s ${C_CYAN}│${C_RESET} " "文件校验"
fi
echo -e "${CHECKSUM_INFO}$(printf '%*s' $((42 - $(echo -e "${CHECKSUM_INFO}" | sed 's/\x1b\[[0-9;]*m//g' | wc -c) + 1)) '') ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}└──────────────────────────┴────────────────────────────────────────────┘${C_RESET}"
echo

if [ -z "$SYSUPGRADE_ARGS" ]; then
    echo -e "${C_YELLOW}[*] 提示：${C_RESET}建议提前备份重要数据"
fi
echo -e "${C_B_RED}[!] 警告：${C_RESET}升级过程中请务必保持设备通电，不要中断操作！"
echo
read -p "$(echo -e "${C_B_GREEN}❓ 确认开始执行 sysupgrade 升级？(Y/n) [默认: ${C_B_GREEN}是${C_RESET}]: ${C_RESET}")" confirm_upgrade
confirm_upgrade=${confirm_upgrade:-Y}  # 默认为Y

if [[ "$confirm_upgrade" =~ ^[Yy]$ ]]; then
    # 构造最终执行信息
    MSG_DESC="信息：正在执行 sysupgrade 命令 ("
    FLAG_DESC=""
    [ -n "$FORCE_FLAG" ] && FLAG_DESC="${C_B_RED}强制${C_RESET}${FLAG_DESC}"
    [ -n "$VERBOSE_FLAG" ] && FLAG_DESC="${FLAG_DESC}${FLAG_DESC:+, }${C_GREEN}详细${C_RESET}" # Add comma if needed

    if [ -z "$SYSUPGRADE_ARGS" ]; then DATA_DESC="${C_GREEN}保留数据${C_RESET}"; else DATA_DESC="${C_YELLOW}不保留数据${C_RESET}"; fi
    if [ -n "$FLAG_DESC" ]; then MSG_DESC="${MSG_DESC}${FLAG_DESC}, ${DATA_DESC})..."; else MSG_DESC="${MSG_DESC}${DATA_DESC})..."; fi
    echo -e "$MSG_DESC"

    # 执行命令
    sysupgrade $FORCE_FLAG $VERBOSE_FLAG $SYSUPGRADE_ARGS "$IMAGE_PATH_IMG"

    echo # 换行
    echo -e "${C_B_GREEN}✅ 信息：sysupgrade 命令已执行。如果成功，系统将会重启。${C_RESET}"
    exit 0
else
    echo # 换行
    echo -e "${C_YELLOW}操作已取消。${C_RESET}解压后的固件文件保留在 '${C_CYAN}${IMAGE_PATH_IMG}${C_RESET}'，您可以手动升级或删除它。"
    exit 0
fi

exit 0 # 备用退出点
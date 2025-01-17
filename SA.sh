#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
MODPATH="/data/adb/modules/shz"
[[ ! -e ${MODDIR}/ll/log ]] && mkdir -p ${MODDIR}/ll/log
source "${MODPATH}/scripts/GK.sh"
TTP_AI_IEE_Install=$(realpath "$0")
chmod 755 "$TTP_AI_IEE_Install"
PID=$(lsof -t "$TTP_AI_IEE_Install")
if [ -z "$PID" ]; then
  echo "$( date "+%Y年%m月%d日%H时%M分%S秒") *没有找到该脚本进程*" >> 三星.log
  exit 1
fi
renice -n 19 -p $PID
ionice -c 2 -n 7 -p $PID
km1() {
	echo -e "$@" >>三星.log
	echo -e "$@"
}
km2() {
	echo -e "❗️ $@" >>三星.log
	echo -e "❗️ $@"
}
function log() {
logfile=1000000
maxsize=1000000
if  [[ "$(stat -t $MODDIR/ll/log/三星.log | awk '{print $2}')" -eq "$maxsize" ]] || [[ "$(stat -t $MODDIR/ll/log/三星.log | awk '{print $2}')" -gt "$maxsize" ]]; then
rm -f "$MODDIR/ll/log/三星.log"
fi
}
cd ${MODDIR}/ll/log
[[ -e /sys/devices/virtual/sec/tsp/cmd ]] && {
    echo "$( date "+%Y年%m月%d日%H时%M分%S秒") *设置触控采样为240Hz*" >> 三星.log
    lock_value "/sys/devices/virtual/sec/tsp/cmd" "set_scan_rate,1"
    lock_value "/sys/devices/virtual/sec/tsp/cmd" "set_game_mode,0"
	lock_value "/sys/devices/virtual/sec/tsp/cmd" "set_game_mode,1"
}
while true; do
    log
    screen_status=$(dumpsys window | grep "mScreenOn" | grep true)  
    if [[ "${screen_status}" ]]; then
	echo "$( date "+%Y年%m月%d日%H时%M分%S秒") *📲- 亮屏运行*" >>三星.log
	   [[ -e /sys/devices/virtual/sec/tsp/cmd ]] && {
	    echo "$( date "+%Y年%m月%d日%H时%M分%S秒") *设置触控采样为240Hz*" >> 三星.log
        lock_value "/sys/devices/virtual/sec/tsp/cmd" "set_scan_rate,1"
        lock_value "/sys/devices/virtual/sec/tsp/cmd" "set_game_mode,0"
	    lock_value "/sys/devices/virtual/sec/tsp/cmd" "set_game_mode,1"
        }
    else
        echo "$( date "+%Y年%m月%d日%H时%M分%S秒") *📵- 暗屏状态，跳过优化*" >>三星.log    
    fi
    sleep 15
done

#!/bin/bash

# ╔════════════════════════════════════╗
# ║        ID HACKHUB v1.1             ║
# ║   إعداد تلقائي + تشغيل الأدوات   ║
# ╚════════════════════════════════════╝

# ✅ قائمة الأدوات المطلوبة
tools=("nmap" "hydra" "sqlmap" "msfconsole" "nikto" "dirb" "aircrack-ng" "bettercap")

echo "🔍 فحص وتثبيت الأدوات المطلوبة..."

# ✅ فحص وتثبيت الأدوات
for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "📦 جاري تثبيت: $tool ..."
        if command -v pkg &> /dev/null; then
            pkg install "$tool" -y
        elif command -v apt &> /dev/null; then
            sudo apt install "$tool" -y
        else
            echo "❌ لا يمكن تثبيت $tool: لم يتم العثور على مدير حزم مناسب."
        fi
    else
        echo "✅ $tool مثبت مسبقاً"
    fi
done

echo "🚀 تم تثبيت جميع الأدوات المطلوبة!"
sleep 2

# ✅ بدء القائمة
while true; do
clear
echo "╔═════════════════════════════╗"
echo "║        ID HACKHUB v1.1      ║"
echo "╚═════════════════════════════╝"
echo "[1] Network Scanning (Nmap)"
echo "[2] Brute Force (Hydra)"
echo "[3] Exploitation (Metasploit)"
echo "[4] SQL Injection (sqlmap)"
echo "[5] Web Scan (Nikto/Dirb)"
echo "[6] Wireless Attacks (Aircrack-ng)"
echo "[7] MITM Tools (Bettercap)"
echo "[8] Update All Tools"
echo "[0] Exit"
echo -n "=> Select option: "
read opt

case $opt in

1)
    echo -n "🌐 Target IP/Domain: "
    read target
    nmap -A "$target"
    read -p "اضغط Enter للعودة"
    ;;

2)
    echo -n "🎯 Target IP: "
    read target
    echo -n "🔐 Username: "
    read user
    echo -n "📂 Password List (path): "
    read passlist
    hydra -l "$user" -P "$passlist" "$target" ssh
    read -p "اضغط Enter للعودة"
    ;;

3)
    if [ "$EUID" -ne 0 ]; then
        echo "❗ Metasploit يحتاج صلاحيات root!"
        echo "💡 شغله بـ: sudo ./idhackhub.sh"
    else
        msfconsole
    fi
    read -p "اضغط Enter للعودة"
    ;;

4)
    echo -n "🌍 Target URL: "
    read url
    sqlmap -u "$url" --batch --banner
    read -p "اضغط Enter للعودة"
    ;;

5)
    echo -n "🌐 Target Website: "
    read target
    echo -n "📂 Wordlist path for dirb (or leave blank): "
    read wordlist
    if [ -z "$wordlist" ]; then
        dirb "$target"
    else
        dirb "$target" "$wordlist"
    fi
    read -p "اضغط Enter للعودة"
    ;;

6)
    if [ "$EUID" -ne 0 ]; then
        echo "❗ Aircrack-ng يحتاج صلاحيات root!"
    else
        echo -n "📶 Wireless interface (e.g. wlan0): "
        read iface
        airmon-ng start "$iface"
    fi
    read -p "اضغط Enter للعودة"
    ;;

7)
    if [ "$EUID" -ne 0 ]; then
        echo "❗ Bettercap يحتاج صلاحيات root!"
    else
        bettercap -iface wlan0
    fi
    read -p "اضغط Enter للعودة"
    ;;

8)
    echo "🔄 تحديث الأدوات..."
    if command -v pkg &> /dev/null; then
        pkg update && pkg upgrade -y
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt upgrade -y
    fi
    echo "✅ تم التحديث!"
    read -p "اضغط Enter للعودة"
    ;;

0)
    echo "👋 مع السلامة يا ID"
    exit 0
    ;;

*)
    echo "❌ اختيار غير صحيح"
    read -p "اضغط Enter للمحاولة تاني"
    ;;
esac
done

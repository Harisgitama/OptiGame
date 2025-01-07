#!/bin/bash

# Fungsi untuk menampilkan animasi loading
loading() {
    local pid=$1
    local delay=0.1
    local spinner=( '|' '/' '-' '\' )

    while [ -d /proc/$pid ]; do
        for i in "${spinner[@]}"; do
            echo -ne "\rInstalling... $i"
            sleep $delay
        done
    done
    echo -ne "\r                    \r"  # Hapus garis loading setelah selesai
}

# Fungsi untuk menjalankan perintah di latar belakang dengan animasi loading
run_with_loading() {
    local command=$1
    bash -c "$command" >/dev/null 2>&1 &  # Jalankan perintah di latar belakang tanpa log
    local pid=$!
    loading $pid
    wait $pid
}

# Header instalasi
echo "===================================="
echo "     Setup Dependensi dan Tools     "
echo "===================================="
sleep 1

# Memperbarui dan meng-upgrade paket
echo -e "\nMemperbarui dan meng-upgrade paket..."
run_with_loading "pkg update -y && pkg upgrade -y"
echo "Pembaruan dan upgrade selesai."

# Menginstal Python3
echo -e "\nMenginstal Python3..."
run_with_loading "pkg install python3 -y"
echo "Python3 berhasil diinstal."

# Menginstal Figlet
echo -e "\nMenginstal Figlet..."
run_with_loading "pkg install figlet -y"
echo "Figlet berhasil diinstal."

# Daftar dependensi Python
dependencies=(
    "requests"
    "screeninfo"
    "rich"
)

# Menginstal dependensi Python
echo -e "\nMenginstal dependensi Python..."
for dep in "${dependencies[@]}"; do
    echo -e "\nMenginstal $dep..."
    run_with_loading "pip install $dep --quiet"
    echo "$dep berhasil diinstal."
done

# Pesan instalasi selesai
figlet "Instalasi Selesai"
echo "===================================="
echo " Semua dependensi dan tools telah terpasang."
echo "===================================="

# Tunggu input sebelum keluar
read -p "Tekan Enter untuk keluar..."

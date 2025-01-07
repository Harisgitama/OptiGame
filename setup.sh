#!/bin/bash

# Fungsi untuk animasi loading sederhana
loading() {
    echo -n "Loading"
    while true; do
        for i in '.' '..' '...'; do
            echo -ne "$i\b\b\b"
            sleep 0.5
        done
    done
}

# Fungsi untuk memastikan animasi loading berhenti
stop_loading() {
    kill "$1" 2>/dev/null
    wait "$1" 2>/dev/null
    echo -e "\n"
}

# Menampilkan header instalasi
echo "===================================="
echo "   Instalasi Dependensi dan Tools   "
echo "===================================="

# Memberi jeda untuk kesan proses awal
sleep 1

# Memperbarui dan meng-upgrade paket
echo -e "\nMemperbarui paket Termux..."
pkg update -y && pkg upgrade -y

# Menginstal Python3
echo -e "\nMenginstal Python3..."
pkg install python3 -y

# Daftar dependensi Python
dependencies=(
    "screeninfo"
    "requests"
    "rich"
)

# Menginstal dependensi Python
echo -e "\nMengunduh dan menginstal dependensi Python..."
for dep in "${dependencies[@]}"; do
    echo -e "\nInstalasi $dep..."
    # Jalankan loading sebagai background process
    loading &
    loader_pid=$!
    pip install "$dep" --quiet
    stop_loading "$loader_pid"  # Hentikan loading setelah instalasi selesai
    echo "$dep berhasil diinstal."
done

# Menginstal android-tools
echo -e "\nMenginstal android-tools..."
pkg install android-tools -y

# Menginstal figlet
echo -e "\nMenginstal figlet..."
pkg install figlet -y

# Menampilkan pesan instalasi selesai dengan figlet
echo -e "\n===================================="
figlet "Instalasi Selesai!"
echo "   Semua dependensi dan tools telah terpasang."
echo "===================================="

# Menunggu input untuk keluar
read -p "Tekan Enter untuk keluar..."

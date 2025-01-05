
# Dosya yolları
file_path="/home/btu59030/Masaüstü/Odev3"
user_file="/home/btu59030/Masaüstü/Odev3/Linux_Zenity_Envanter_Sistemi/repo/kullanici.csv"
depo_file="/home/btu59030/Masaüstü/Odev3/Linux_Zenity_Envanter_Sistemi/repo/depo.csv"
log_file="/home/btu59030/Masaüstü/Odev3/Linux_Zenity_Envanter_Sistemi/repo/log.csv"

# Disk kullanım bilgilerini toplamak için değişken
info_text=""

# Disk kullanımı kontrol fonksiyonu
function get_disk_usage() {
    local file=$1
    local name=$(basename "$file") # Dosya ismini al
    if [ -e "$file" ]; then
        local usage=$(du -sh "$file" 2>/dev/null | awk '{print $1}')
        info_text+="$name: $usage\n"
    else
        info_text+="$name: Mevcut değil\n"
    fi
}

 (
        echo "0"
        sleep 1
        echo "# Öğeler alınıyor..."
        echo "50"
        echo "# Hesaplanıyor..."
        sleep 1
        echo "100"
    ) | zenity --progress --title="İşlem Durumu" --text="Diskte kullanılan alanlar..." --percentage=0 --auto-close --width=300

# Her dosyanın disk kullanımını kontrol et
get_disk_usage "$file_path"
get_disk_usage "$user_file"
get_disk_usage "$depo_file"
get_disk_usage "$log_file"

# Sonucu göster
zenity --info --title="Disk Kullanımı" --text="$info_text"  --width=150 --height=150



# Kaynak dosyaları ve hedef dizini tanımlayın
veri_file="./repo/depo.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Dosya bulunamazsa hata mesajı gösterir.
if [ ! -f "$veri_file" ]; then
    zenity --error --title="Hata" --text="CSV dosyası bulunamadı"
    exit
fi

# Başlık satırını al
baslik=$(head -n 1 "$veri_file" | awk -F',' '{printf "%-30s %-30s %-30s %-30s %-30s ", $1, $2, $3, $4, $5}')

# Veri satırlarını al
data=$(awk -F',' 'NR>1 {printf "%-30s %-30s %-30s %-30s %-30s \n", $1, $2, $3, $4, $5}' "$veri_file")

full_data="$baslik\n$data"

# Veriler boşsa hata göster
if [ -z "$data" ]; then
    zenity --error --title="Uyarı" --text="CSV dosyasında veri bulunamadı!"
    echo "$(date),1007,$username,NO INFO">> "$log_file"
    exit
fi

# İlerleme çubuğunu göster
(
    echo "0" ; sleep 2
    echo "50" ; echo "# Veriler hazırlanıyor..." ; sleep 2
    echo "100" ; echo "# İşlem tamamlandı."
) | zenity --progress --title="İşlem Durumu" --text="Veriler işleniyor..." --percentage=0 --auto-close


# Ürün listesini kullanıcıya göster
zenity --text-info --title="CSV Verileri" --width=700 --height=1000 --filename=<(echo -e "$full_data")


# Log dosyasının yolu
log_file="./repo/log.csv"

# Log dosyasının varlığını kontrol et
if [ ! -f "$log_file" ]; then
    zenity --error --title="Hata" --text="Log dosyası bulunamadı!"
    exit 1
fi

# Log dosyasını uygun formatta oku
log_data=$(awk -F',' 'NR==1 {print "Tarih, Hata No, Kullanıcı, Mesaj\n-----------------------------------------------------------------------------------------------------------------------"} 
    NR>1 {printf "%s, %s, %s, %s\n", $1, $2, $3, $4}' "$log_file")

# Log dosyasında kayıt yoksa bilgi mesajı göster
if [ -z "$log_data" ]; then
    zenity --info --title="Bilgi" --text="Log dosyasında hiçbir kayıt bulunamadı!"
    exit 0
fi

# Logları Zenity ile göster
zenity --text-info \
    --title="Log Kayıtları" \
    --width=600 \
    --height=400 \
    --filename=<(echo "$log_data")



# Kaynak dosyaları ve hedef dizini tanımlayın
user_file="/home/btu59030/Masaüstü/Odev3/repo/kullanici.csv"
depo_file="/home/btu59030/Masaüstü/Odev3/repo/depo.csv"
BACKUP_DIR="/home/btu59030/Masaüstü/Yedekler"

# Hedef dizin var mı, kontrol edin; yoksa oluşturun
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Yedekleme dizini oluşturuldu: $BACKUP_DIR"
fi

# Yedekleme dosyasının adı
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Kaynak dosyaların varlığını kontrol edin
if [ ! -e "$user_file" ]; then
    zenity --error --text="Kaynak dosya mevcut değil: $user_file"
    exit 1
fi

if [ ! -e "$depo_file" ]; then
    zenity --error --text="Kaynak dosya mevcut değil: $depo_file"
    exit 1
fi

# İşlem durumu için bir ilerleme çubuğu gösteriyoruz
    (
  	echo "0"
        sleep 1
        echo "# Yedeklenecek dosya bilgileri alınıyor..." ; 
        echo "50"
        echo "# Bilgiler işleniyor..."
        sleep 1
        echo "100"
    ) | zenity --progress --title="İşlem Durumu" --text="Yedekleme tamamlanıyor..." --percentage=0 --auto-close
    

# Yedekleme işlemini gerçekleştirin
tar -czf "$BACKUP_FILE" "$user_file" "$depo_file" 2>/dev/null

# İşlem başarıyla tamamlandı mı kontrol edin
if [ $? -eq 0 ]; then
    zenity --info --title="Yedekleme Başarılı" --text="Yedekleme tamamlandı:\n$BACKUP_FILE"
else
    zenity --error --title="Yedekleme Başarısız" --text="Yedekleme sırasında bir hata oluştu!"
    exit 1
fi


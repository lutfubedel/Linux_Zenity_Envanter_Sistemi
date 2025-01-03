# Kaynak dosyaları ve hedef dizini tanımlayın
data_file="./repo/depo.csv" 
log_file="./repo/log.csv" 
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"} 

# Kullanıcıdan silmek istediği ürünün adını girmesini iste
deleted_product=$(zenity --entry --title="Ürün Silme" --text="Lütfen silmek istediğiniz ürünün ismini giriniz")

# Kullanıcı işlemden vazgeçerse çıkış yap
if [ $? -ne 0 ]; then
    echo "Kullanıcı işlemden vazgeçti"
    exit 1
fi

# Ürün dosyada mevcut mu kontrol et
if grep -q "^.*,${deleted_product},.*$" "$data_file"; then
    # Kullanıcıdan silme işlemi için onay al
    zenity --question --title="Onay" --text="Bu ürünü silmek istediğinize emin misiniz?"
    if [ $? -eq 0 ]; then # Kullanıcı onay verdiyse
        (
            echo "0" ; sleep 2
            echo "# Silme işlemi hazırlanıyor..." ; sleep 2
            echo "50" ; sleep 2 
            sed -i "/^.*,${deleted_product},.*$/d" "$data_file" 
            echo "# Ürün siliniyor..." ; sleep 2
            echo "100" 
        ) | zenity --progress --title="İşlem Durumu" --text="Ürün silme işlemi devam ediyor..." --percentage=0 --auto-close

        # Eğer silme işlemi başarılı olduysa bilgi mesajı göster
        if [ $? -eq 0 ]; then
            zenity --info --title="Ürün Silindi" --text="Ürün başarıyla silindi"
        fi
    else
        # Kullanıcı silme işlemini iptal ederse bilgi mesajı göster
        zenity --info --title="İşlem İptal Edildi" --text="Ürün silme işlemi iptal edildi."
    fi
else
    # Ürün bulunamadığında log kaydı oluştur ve hata mesajı göster
    echo "$(date),1006,$username,No Item" >> "$log_file"
    zenity --error --title="Hata" --text="Ürün bulunamadı"
fi


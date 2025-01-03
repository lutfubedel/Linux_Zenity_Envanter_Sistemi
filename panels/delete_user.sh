
# Kaynak dosyaları ve hedef dizini tanımlayın
user_file="./repo/kullanici.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Kullanıcıdan silmek istediği kullanıcının adını girmesini iste
deleted_user=$(zenity --entry --title="Kullanıcı Silme" --text="Lütfen silmek istediğiniz kullanıcının ismini giriniz")

# Kullanıcı işlemden vazgeçerse çıkış yap
if [ $? -ne 0 ]; then
        echo "Kullanıcı işlemden vazgeçti"
        exit 1
fi

# Kullanıcı dosyada mevcut mu kontrol et
if grep -q "^.*,${deleted_user},.*$" "$user_file"; then
    # Kullanıcıdan silme işlemi için onay al
    zenity --question --title="Onay" --text="Bu kullanıcıyı silmek istediğinize emin misiniz?"
    if [ $? -eq 0 ]; then
    	(
            echo "0" ; sleep 2
            echo "# Silme işlemi hazırlanıyor..." ; sleep 2
            echo "50" ; sleep 2
            sed -i "/^.*,${deleted_user},.*$/d" "$user_file"
            echo "# Kullanıcı siliniyor..." ; sleep 2
            echo "100"
        ) | zenity --progress --title="İşlem Durumu" --text="Kullanıcı silme işlemi devam ediyor..." --percentage=0 --auto-close

	# Eğer silme işlemi başarılı olduysa bilgi mesajı göster
	if [ $? -eq 0 ]; then
            zenity --info --title="Kullanıcı Silindi" --text="Kullanıcı başarıyla silindi"
        fi
    else
        # Kullanıcı silme işlemini iptal ederse bilgi mesajı göster
        zenity --info --title="İşlem İptal Edildi" --text="Kullanıcı silme işlemi iptal edildi."
    fi
else
    # Kullanıcı bulunamadığında log kaydı oluştur ve hata mesajı göster
    echo "$(date),1006,$username,NO ITEM">> "$log_file"
    zenity --error --title="Hata" --text="Kullanıcı bulunamadı"
fi


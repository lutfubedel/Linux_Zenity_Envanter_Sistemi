user_file="./repo/kullanici.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Kullanıcıdan şifresini sıfırlamak istediği kullanıcı adını girmesini iste
user_reset=$(zenity --entry --title="Kullanıcı Şifre Sıfırlama" --text="Lütfen şifresini sıfırlamak istediğiniz kullanıcının ismini giriniz : ")

# Kullanıcı işlemi iptal ettiyse çıkış yap
if [ $? -ne 0 ]; then
    echo "Kullanıcı işlemden vazgeçti"
    exit 1
fi

# Kullanıcının veri dosyasında var olup olmadığını kontrol et
if grep -q ",${user_reset}," "$user_file"; then
    # Kullanıcıdan şifre bilgilerini girmesini iste
    form_reset=$(zenity --forms --title="Şifre güncelleniyor" \
        --text="Lütfen kullanıcının şifre bilgilerini giriniz:" \
        --separator="," \
        --add-password="Eski Şifre : " \
        --add-password="Yeni Şifre : " \
        --add-password="Şifre Tekrar : " )

    # Kullanıcı formu iptal ettiyse çıkış yap
    if [ $? -ne 0 ]; then
        echo "Kullanıcı işlemden vazgeçti"
        exit 1
    fi

    # İşlem durumu göstergesi
    (
        echo "0"
        sleep 1
        echo "# İstenilen kullanıcı aranıyor..."
        echo "50"
        echo "# Kullanıcı bulundu..."
        sleep 1
        echo "100"
    ) | zenity --progress --title="İşlem Durumu" --text="Şifre güncelleniyor..." --percentage=0 --auto-close --width=300

    # Formdan yeni değerleri oku
    IFS="," read -r old_pass new_pass pass_again <<< "$form_reset"

    # Yeni şifrelerin eşleşip eşleşmediğini kontrol et
    if [ "$new_pass" != "$pass_again" ]; then
    	echo "$(date),1008,$username,NO MATCH">> "$log_file"
        zenity --error --title="Hata" --text="Yeni şifreler eşleşmiyor!"
        exit 1
    fi

    # Eski şifreyi bul ve doğrula
    user_line=$(grep ",${user_reset}," "$user_file")
    stored_pass=$(echo "$user_line" | awk -F',' '{print $5}')

    if [ "$stored_pass" != "$old_pass" ]; then
    	echo "$(date),1008,$username,NO MATCH">> "$log_file"
        zenity --error --title="Hata" --text="Eski şifre hatalı!"
        exit 1
    fi

    # Kullanıcı dosyasındaki şifreyi güncelle
    updated_line=$(echo "$user_line" | awk -F',' -v new_pass="$new_pass" 'BEGIN{OFS=","}{$5=new_pass; print}')
    sed -i "s|$user_line|$updated_line|" "$user_file"

    zenity --info --title="Başarılı" --text="Şifre başarıyla güncellendi."
else
    # Kullanıcı bulunamazsa hata mesajı göster
    zenity --error --title="Hata" --text="Kullanıcı bulunamadı!"
    echo "$(date),1006,$username,NO MATCH">> "$log_file"
    exit 1
fi


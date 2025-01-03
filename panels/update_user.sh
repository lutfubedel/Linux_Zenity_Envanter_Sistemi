#!/bin/bash

user_file="./repo/kullanici.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Kullanıcıdan güncellemek istediği kullanıcı adını girmesini iste
updated_user=$(zenity --entry --title="Kullanıcı Bilgisi Güncelleme" --text="Lütfen güncellemek istediğiniz kullanıcı adını giriniz:")

# Kullanıcı giriş işlemini iptal ettiyse çıkış yap
if [ $? -ne 0 ]; then
    echo "Kullanıcı işlemden vazgeçti"
    exit 1
fi

# Kullanıcının veri dosyasında var olup olmadığını kontrol et
if grep -q ",${updated_user}," "$user_file"; then
    # Kullanıcıdan yeni bilgileri al (Ad, Soyad, Rol, Parola)
    form_user=$(zenity --forms --title="Kullanıcı Güncelleniyor" \
        --text="Lütfen kullanıcının yeni bilgilerini giriniz:" \
        --separator="," \
        --add-entry="Ad : " \
        --add-entry="Soyad : " \
        --add-combo="Rol : " --combo-values="user|admin" \
        --add-password="Parola :")

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
    ) | zenity --progress --title="İşlem Durumu" --text="Güncelleniyor..." --percentage=0 --auto-close --width=300
    
    # Yeni değerleri formdan oku
    IFS="," read -r new_name new_surname new_role new_pass <<< "$form_user"

    # Veri dosyasındaki kullanıcıyı güncelle
    sed -i "/^.*,${updated_user},.*$/s/\(^[^,]*,\)\([^,]*,[^,]*,[^,]*,[^,]*\),\([^,]*\)/\1${new_name},${new_surname},${new_role},${new_pass},\3/" "$user_file"

    # Kullanıcıya güncellemenin başarılı olduğunu bildir
    zenity --info --title="Kullanıcı Güncellendi" --text="Kullanıcı başarıyla güncellendi"
else
    # Kullanıcı bulunamadıysa hata mesajı göster
    echo "$(date),1006,$username,NO ITEM">> "$log_file"
    zenity --error --title="Hata" --text="Kullanıcı bulunamadı"
fi


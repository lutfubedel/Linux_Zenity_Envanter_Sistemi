#!/bin/bash

# Kullanıcı adı ve rol bilgisi çevresel değişkenlerden alınıyor
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}
role=${USER_ROLE:-"Bilinmeyen Rol"}

log_file="./repo/log.csv"

# Bekleme fonksiyonu
bekleme_ekrani() {
    (
        echo "0"
        sleep 1
        echo "# Giriş işlemine hazırlanıyor..."
        echo "50"
        echo "# Geçiş Yapılıyor..."
        sleep 1
        echo "100"
    ) | zenity --progress --title="İşlem Durumu" --text="Geçiş Yapılıyor..." --percentage=0 --auto-close --width=300
}

while true; do
    # Ana menü oluşturma
    islem=$(zenity --list \
        --title="Ürün Yönetim Paneli" \
        --text="Kullanıcı: $username\nRol: $role\n\nBir işlem seçin:" \
        --column="İşlemler" \
        "Ürün Ekle" \
        "Ürün Güncelle" \
        "Ürün Sil" \
        "Ürünleri Listele" \
        "Kullanıcı Yönetimi" \
        "Program Yönetimi" \
        "Rapor" \
        "Çıkış" \
        --width=500 --height=400)

    # Kullanıcı çıkışı kontrolü
    if [ $? -eq 1 ] || [ "$islem" == "Çıkış" ]; then
        zenity --question --text="Programdan çıkmak istediğinize emin misiniz?" --width=200
        if [ $? -eq 0 ]; then
            zenity --info --text="Çıkış Başarılı." --width=200
            exit
        fi
    fi

    # Seçilen işlem için mesaj gösterme
    case $islem in
        "Ürün Ekle")
            bekleme_ekrani
            if [ "$role" == "admin" ]; then
                bash ./panels/add_product.sh
            else
                zenity --error --text="Bu işlem için yetkiniz bulunmamaktadır"
                echo "$(date),1002,$username,UNAUTHORIZED OPERATION" >> "$log_file"
            fi
            ;;
        "Ürün Güncelle")
            bekleme_ekrani
            if [ "$role" == "admin" ]; then
                bash ./panels/update_product.sh
            else
                echo "$(date),1002,$username,UNAUTHORIZED OPERATION" >> "$log_file"
                zenity --error --text="Bu işlem için yetkiniz bulunmamaktadır"
            fi
            ;;
        "Ürün Sil")
            bekleme_ekrani
            if [ "$role" == "admin" ]; then
                bash ./panels/delete_product.sh
            else
                echo "$(date),1002,$username,UNAUTHORIZED OPERATION" >> "$log_file"
                zenity --error --text="Bu işlem için yetkiniz bulunmamaktadır"
            fi
            ;;
        "Ürünleri Listele")
            bekleme_ekrani
            bash ./panels/list_products.sh
            ;;
        "Kullanıcı Yönetimi")
            bekleme_ekrani
            if [ "$role" == "admin" ]; then
                bash ./panels/user_managment.sh
            else
                echo "$(date),1002,$username,UNAUTHORIZED OPERATION" >> "$log_file"
                zenity --error --text="Bu işlem için yetkiniz bulunmamaktadır"
            fi
            ;;
        "Program Yönetimi")
            bekleme_ekrani
            if [ "$role" == "admin" ]; then
                bash ./panels/program_managment.sh
            else
                echo "$(date),1002,$username,UNAUTHORIZED OPERATION" >> "$log_file"
                zenity --error --text="Bu işlem için yetkiniz bulunmamaktadır"
            fi
            ;;
        "Rapor")
            bekleme_ekrani
            bash ./panels/reports.sh
            ;;
    esac
done


#!/bin/bash

# Kullanıcı ve log dosyalarının yolu
csv_file="./repo/kullanici.csv"
log_file="./repo/log.csv"

# Kullanıcı dosyasını kontrol et
if [ ! -f "$csv_file" ]; then
    zenity --error --title="Hata" --text="Kullanıcı Dosyası Bulunamadı"
    exit 1
fi

while true; do
    # Kullanıcı adı ve şifreyi al
    user_pass=$(zenity --forms --title="Giriş Yap" --text="Kullanıcı adı ve şifrenizi giriniz" \
    --add-entry="Kullanıcı Adı" --add-password="Şifre")
    exit_code=$?

    # Kullanıcı giriş ekranından çıkarsa
    if [ $exit_code -ne 0 ]; then
        zenity --question --text="Programdan çıkmak istediğinize emin misiniz?" --width=200
    	if [ $? -eq 0 ]; then
        	zenity --info --text="Çıkış başarılı." --width=200
        	exit
        fi
    fi

    # Kullanıcı adı ve şifreyi ayır
    username=$(echo "$user_pass" | cut -d "|" -f1)
    password=$(echo "$user_pass" | cut -d "|" -f2)

    # Kullanıcı adı kontrolü
    if [ -z "$username" ]; then
        zenity --error --title="Hata" --text="Kullanıcı adı boş bırakılamaz"
        continue
    fi

    # CSV'de kullanıcıyı ara
    user_data=$(awk -F, -v uname="$username" '$2 == uname {print $0}' "$csv_file")
    if [ -n "$user_data" ]; then
        # Kullanıcı durumunu al
        user_status=$(echo "$user_data" | cut -d "," -f6)

        # Hesap blokluysa çıkış yap
        if [ "$user_status" == "blocked" ]; then
            zenity --error --title="Hata" --text="Hesabınız bloke edilmiştir."
            exit 1
        fi

        # Şifre kontrolü
        attempts=1
        while [ $attempts -lt 3 ]; do
            stored_password=$(echo "$user_data" | cut -d "," -f5)
	    
	    (
            echo "0"
            sleep 1
            echo "# Giriş işlemine hazırlanıyor..." ; 
            echo "50"
            echo "# Şifre Kontrol ediliyor..."
            sleep 1
            echo "100"
        ) | zenity --progress --title="İşlem Durumu" --text="Kontrol devam ediyor..." --percentage=0 --auto-close
        
	    # Girilen şifre doğruysa menüye yönlendir
            if [ "$password" == "$stored_password" ]; then
                zenity --info --title="Başarılı" --text="Giriş başarılı."

                # Kullanıcı rolünü al ve ortam değişkenlerine aktar
                user_role=$(echo "$user_data" | cut -d "," -f4)
                export LOGGED_IN_USER="$username"
                export USER_ROLE="$user_role"

                # Menü paneline yönlendir
                bash ./panels/menu.sh
                exit 0
            else
                attempts=$((attempts + 1))
                zenity --error --title="Hata" --text="Şifre hatalı. Kalan hakkınız: $((4 - attempts))"
                
                # Şifreyi tekrar al
                user_pass=$(zenity --forms --title="Giriş Yap" --text="Kullanıcı adı ve şifrenizi giriniz" \
                --add-entry="Kullanıcı Adı" --add-password="Şifre")
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    exit 0
                fi
                username=$(echo "$user_pass" | cut -d "|" -f1)
                password=$(echo "$user_pass" | cut -d "|" -f2)
                user_data=$(awk -F, -v uname="$username" '$2 == uname {print $0}' "$csv_file")
            fi
        done

        # 3 deneme başarısız olursa hesabı blokla
        if [ $attempts -eq 3 ]; then
            sed -i "/^.*,$username,.*/s/active/blocked/" "$csv_file"
            error_code=1001
            echo "$(date),$error_code,$username,ACCOUNT_BLOCKED">> "$log_file"
            zenity --error --title="Hata" --text="Şifre deneme hakkınız bitti. Hesabınız bloke edildi."
        fi
        exit 1
    else
        zenity --error --title="Hata" --text="Kullanıcı Bulunamadı! Tekrar deneyin."
    fi
done


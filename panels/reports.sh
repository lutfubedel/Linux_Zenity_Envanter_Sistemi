
# Kullanıcı adı ve rol bilgisi çevresel değişkenlerden alınıyor
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}
role=${USER_ROLE:-"Bilinmeyen Rol"}

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
        --title="Rapor Paneli" \
        --text="Kullanıcı: $username\nRol: $role\n\nBir işlem seçin:" \
        --column="İşlemler" \
        "Stokta Azalan Ürünleri Göster" \
        "Stokta Fazla Bulunan Ürünleri Göster" \
	"Geri" \
        --width=500 --height=400)

	# Kullanıcı çıkışı kontrolü
    if [ $? -eq 1 ] || [ "$islem" == "Geri" ]; then
    	zenity --question --text="Programdan çıkmak istediğinize emin misiniz?" --width=200
    	if [ $? -eq 0 ]; then
        	zenity --info --text="Programdan çıkılıyor." --width=200
       		exit
        else
        	zenity --info --text="Çıkış iptal edildi." --width=200
        fi
    fi

    # Seçilen işlem için mesaj gösterme
    case $islem in
        "Stokta Azalan Ürünleri Göster")
        	bekleme_ekrani
        	bash ./panels/show_less_product.sh
            ;;
        "Stokta Fazla Bulunan Ürünleri Göster")
        	bekleme_ekrani
        	bash ./panels/show_more_product.sh
            ;;
    esac
done

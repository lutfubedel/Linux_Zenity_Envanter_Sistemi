
data_file="./repo/depo.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Kullanıcıdan güncellemek istediği ürünün adını girmesini iste
updated_product=$(zenity --entry --title="Ürün Güncelleme" --text="Lütfen güncellemek istediğiniz ürünün adını giriniz:")

# Kullanıcı giriş işlemini iptal ettiyse çıkış yap
if [ $? -ne 0 ]; then
        echo "Kullanıcı işlemden vazgeçti"
        exit 1
fi

# Ürünün veri dosyasında var olup olmadığını kontrol et
if grep -q "^.*,${updated_product},.*$" "$data_file"; then
        # Kullanıcıdan yeni stok miktarı ve birim fiyatı bilgilerini al
        form_product=$(zenity --forms --title="Ürün Güncelleme" \
        --text="Lütfen güncellemek istediğiniz ürünün yeni değerlerini giriniz:" \
        --separator="," \
        --add-entry="Stok Miktarı" \
        --add-entry="Birim Fiyatı")

        # Kullanıcı formu iptal ettiyse çıkış yap
        if [ $? -ne 0 ]; then
                 echo "Kullanıcı işlemden vazgeçti"
                 exit 1
        fi
        
        # İşlem durumu göstergesi
        (
            echo "0"
            sleep 1
            echo "# İstenilen ürün aranıyor..."
            echo "50"
            echo "# Ürün bulundu..."
            sleep 1
            echo "100"
        ) | zenity --progress --title="İşlem Durumu" --text="Güncelleniyor..." --percentage=0 --auto-close --width=300

        # Yeni stok miktarı ve fiyat değerlerini oku
        IFS="," read -r new_stock_amount new_price <<< "$form_product"

        # Veri dosyasındaki ürünü güncelle
        sed -i "/^.*,${updated_product},.*$/s/\(^[^,]*,[^,]*,[^,]*,\)[^,]*,[^,]*\(\)/\1${new_stock_amount},${new_price}/" "$data_file"

        # Kullanıcıya ürünün güncellendiğini bildir
        zenity --info --title="Ürün Güncellendi" --text="Ürün başarıyla güncellendi"
else
        # Ürün bulunamadıysa kullanıcıya hata mesajı göster
        echo "$(date),1006,$username,NO ITEM">> "$log_file"
        zenity --error --title="Hata" --text="Ürün bulunamadı"
fi


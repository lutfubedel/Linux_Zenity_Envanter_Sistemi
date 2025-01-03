
# Ürün dosyasının yolu
product_file="./repo/depo.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Stok miktarı 50'nin altında olan ürünleri bul
low_stock_products=$(awk -F',' '$4 < 50 && NR > 1 {print $2 " - Stok: " $4}' "$product_file")

if [ -z "$low_stock_products" ]; then
    echo "$(date),1006,$username,NO ITEM">> "$log_file"
    zenity --info --title="Bilgi" --text="Stok miktarı 50'nin altında olan hiçbir ürün bulunamadı!"
    exit 0
fi

  (
  	echo "0"
        sleep 1
        echo "# Ürünler aranıyor..." ; 
        echo "50"
        echo "# Bilgiler işleniyor..."
        sleep 1
        echo "100"
    ) | zenity --progress --title="İşlem Durumu" --text="Bilgiler getiriliyor..." --percentage=0 --auto-close

# Kullanıcıya düşük stok ürünlerini tek bir mesaj kutusunda göster
zenity --info \
    --title="Düşük Stok Ürünleri" \
    --text="Stok miktarı 50'nin altında olan ürünler:\n\n$low_stock_products"

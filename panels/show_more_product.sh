
# Ürün dosyasının yolu
product_file="./repo/depo.csv"
log_file="./repo/log.csv"
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}

# Stok miktarı 50'nin altında olan ürünleri bul
more_stock_products=$(awk -F',' '$4 > 1000 && NR > 1 {print $2 " - Stok: " $4}' "$product_file")

if [ -z "$more_stock_products" ]; then
    echo "$(date),1006,$username,NO ITEM">> "$log_file"
    zenity --info --title="Bilgi" --text="Stok miktarı 1000'nin üstünde olan hiçbir ürün bulunamadı!"
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
    --title="Yüksek Stoklu Ürünleri" \
    --text="Stok miktarı 1000'in üstünde olan ürünler:\n\n$more_stock_products"


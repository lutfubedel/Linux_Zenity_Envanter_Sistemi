
# Kaynak dosyaları ve hedef dizini tanımlayın
depo_file="./repo/depo.csv" # Ürün bilgilerini tutan dosya
log_file="./repo/log.csv" # Log kayıtlarını tutan dosya
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"} # Oturum açmış kullanıcı adı, yoksa "Bilinmeyen Kullanıcı"

# Eğer depo dosyası varsa ve boş değilse, son ID'yi alıp bir artırıyoruz
if [ -f "$depo_file" ] && [ -s "$depo_file" ]; then
	last_id=$(tail -n 1 "$depo_file" | cut -d"," -f1)
	new_id=$((last_id+1))
else
	new_id=1 # Eğer dosya yoksa veya boşsa, ID 1 olarak başlar
fi

# Ürün bilgilerini almak için bir form oluşturuyoruz
form_product=$(zenity --forms --title="Ürün Bilgileri" \
	--text="Lütfen eklemek istediğiniz ürünün bilgilerini giriniz : " \
	--separator="," \
	--add-entry="Ürün Adı" \
	--add-entry="Kategori" \
	--add-entry="Stok Miktarı" \
	--add-entry="Birim Fiyatı")

# Kullanıcı formu iptal ettiyse işlem sonlandırılır
if [ $? -ne 0 ]; then
	echo "Kullanıcı işlemden vazgeçti"
	exit 1
fi

# Formdan alınan bilgileri değişkenlere atıyoruz
IFS="," read -r product_name category stock_amount price <<< "$form_product"

# Aynı ürün adıyla başka bir kaydın olup olmadığını kontrol ediyoruz
if grep -q "^.*,${product_name},.*$" "$depo_file"; then
    error_code=1004
    echo "$(date),$error_code,$username,SAME NAME" >> "$log_file" # Loglama
    zenity --error --text="Bu ürün adıyla başka bir kayıt bulunmaktadır. Lütfen farklı bir ad giriniz."
    exit 1
fi

# Stok miktarı ve fiyatın geçerli olup olmadığını kontrol ediyoruz
if ! [[ "$stock_amount" =~ ^[1-9][0-9]*$ || "$price" =~ ^[1-9][0-9]*$ ]]; then
    error_code=1005
    echo "$(date),$error_code,$username,NEGATIVE NUMBER" >> "$log_file" # Loglama
    zenity --error --text="Geçersiz giriş! Lütfen stok miktarı ve birim fiyatı için 0'dan büyük sayılar girin."
    exit 1
fi

# Ürün adı ve kategorinin boşluk içermediğinden emin oluyoruz
if [[ "$product_name" =~ \  || "$category" =~ \  ]]; then
    error_code=1003
    echo "$(date),$error_code,$username,WRONG NAME TYPE" >> "$log_file" # Loglama
    zenity --error --text="Hata: Ürün adı ve kategori boşluk içermemelidir. Lütfen geçerli değerler girin."
    exit 1
fi

# İşlem durumu için bir ilerleme çubuğu gösteriyoruz
(
  	echo "0" 
        sleep 1
        echo "# Yeni Ürün bilgileri alınıyor..."; 
        echo "50" 
        echo "# Bilgiler işleniyor..."
        sleep 1
        echo "100"
) | zenity --progress --title="İşlem Durumu" --text="Yeni ürün eklendi..." --percentage=0 --auto-close

# Yeni ürün bilgilerini dosyaya ekliyoruz
new_row="$new_id,$product_name,$category,$stock_amount,$price"
echo "$new_row" >> "$depo_file"

# Kullanıcıya başarı mesajı gösteriyoruz
zenity --info --title="İşlem Başarılı" --text="Yeni ürün eklendi"




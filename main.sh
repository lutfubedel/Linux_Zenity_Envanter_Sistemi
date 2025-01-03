
# Dosya yollarını tanımla
csv_files=(
    "./repo/depo.csv"
    "./repo/kullanici.csv"
    "./repo/log.csv"
)

# Dosyaların varlığını kontrol et yoksa oluştur
for file in "${csv_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Dosya Bulunamadı, oluşturuluyor: $file"
        touch "$file"
    else
        echo "Dosya Mevcut: $file"
    fi
done

# kullanici.csv ve depo.csv dosyasının yolu
kullanici_file="./repo/kullanici.csv"
depo_file="./repo/depo.csv"

# kullanici.csv dosyası boşsa başlangıç için bir admin ekle
if [ -f "$kullanici_file" ] && [ ! -s "$kullanici_file" ]; then
    echo "id,username,lastname,role,password,situation" > "$kullanici_file"
    echo "1,admin,admin,admin,123,active" >> "$kullanici_file"
    echo "Kullanici verileri eklendi: admin, 123, yonetici"
else
    echo "$kullanici_file zaten dolu veya mevcut değil."
fi

# depo.csv dosyası boşsa başlıkları ekle
if [ -f "$depo_file" ] && [ ! -s "$depo_file" ]; then
    echo "id,name,category,stock,price" > "$depo_file"
else
    echo "$depo_file zaten dolu veya mevcut değil"
fi

bash ./panels/login.sh





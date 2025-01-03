
user_file="./repo/kullanici.csv"  # Kullanıcı dosyasının yolu
log_file="./repo/log.csv"         # Log dosyasının yolu
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"}  # Giriş yapan kullanıcı

# "blocked" durumunda olan kullanıcıları bul
blocked_users=$(awk -F',' '$6 ~ /blocked/ {print $2}' "$user_file")

if [ -z "$blocked_users" ]; then
    zenity --info --title="Bilgi" --text="Blocked durumda hiçbir kullanıcı bulunamadı!"
    exit 0
fi

# Kullanıcıya blocked durumundaki hesapları göster ve seçim yapmasını iste
selected_user=$(zenity --list \
    --title="Blocked Hesaplar" \
    --text="Lütfen durumunu değiştirmek istediğiniz hesabı seçin:" \
    --column="Kullanıcı Adı" \
    $blocked_users)

# Kullanıcı seçim yapmazsa çık
if [ -z "$selected_user" ]; then
    zenity --info --title="Bilgi" --text="Hiçbir hesap seçilmedi. Çıkış yapılıyor."
    exit 0
fi

# Durumunu "active" olarak güncelle
user_line=$(grep ",${selected_user}," "$user_file")
updated_line=$(echo "$user_line" | awk -F',' 'BEGIN{OFS=","}{$6="active"; print}')
sed -i "s|$user_line|$updated_line|" "$user_file"

# Kullanıcıya bilgi ver
zenity --info --title="Başarılı" --text="Seçtiğiniz kullanıcının hesabı aktive edildi."




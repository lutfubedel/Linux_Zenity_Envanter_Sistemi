user_file="./repo/kullanici.csv" 
log_file="./repo/log.csv" 
username=${LOGGED_IN_USER:-"Bilinmeyen Kullanıcı"} 

# Eğer kullanıcı dosyası varsa ve boş değilse, son ID'yi alıp bir artırıyoruz
if [ -f "$user_file" ] && [ -s "$user_file" ]; then
	last_id=$(tail -n 1 "$user_file" | cut -d"," -f1)
	new_id=$((last_id+1))
else
	new_id=1
fi

# Yeni kullanıcı bilgilerini almak için bir form oluşturuyoruz
form_product=$(zenity --forms --title="Yeni Kullanıcı Ekleme Paneli" \
    --text="Lütfen eklemek istediğiniz kullanıcının bilgilerini giriniz:" \
    --separator="," \
    --add-entry="Ad" \
    --add-entry="Soyad" \
    --add-combo="Rol" --combo-values="user|admin" \
    --add-password="Parola")

# Kullanıcı formu iptal ettiyse işlem sonlandırılır
if [ $? -ne 0 ]; then
	echo "Kullanıcı işlemden vazgeçti"
	exit 1
fi

# Formdan alınan bilgileri değişkenlere atıyoruz
IFS="," read -r user_name user_lastname user_role user_password <<< "$form_product"

# Ad, soyad ve parolada boşluk kontrolü yapıyoruz
if [[ "$user_name" =~ \  || "$user_lastname" =~ \  || "$user_password" =~ \  ]]; then
    error_code=1003
    echo "$(date),$error_code,$username,WRONG NAME TYPE" >> "$log_file" # Hatalı giriş loglanır
    zenity --error --text="Hata: Kullanıcı adı, soyadı ve parola boşluk içermemelidir. Lütfen geçerli değerler girin."
    exit 1
fi

# Aynı kullanıcı adı olup olmadığını kontrol ediyoruz
if grep -q "^.*,${user_name},.*$" "$user_file"; then
    error_code=1004
    echo "$(date),$error_code,$username,SAME NAME" >> "$log_file" # Tekrarlayan kullanıcı adı loglanır
    zenity --error --text="Bu kullanıcı adıyla başka bir kayıt bulunmaktadır. Lütfen farklı bir ad giriniz."
    exit 1
fi

# İşlem durumu için bir ilerleme çubuğu gösteriyoruz
(
  	echo "0" 
        sleep 1
        echo "# Yeni kullanıcı bilgileri alınıyor..."; 
        echo "50"
        echo "# Bilgiler işleniyor..."
        sleep 1
        echo "100" 
) | zenity --progress --title="İşlem Durumu" --text="Yeni kullanıcı eklendi..." --percentage=0 --auto-close

# Yeni kullanıcı bilgilerini dosyaya ekliyoruz
new_row="$new_id,$user_name,$user_lastname,$user_role,$user_password,"active""
echo "$new_row" >> "$user_file"

# Kullanıcıya başarı mesajı gösteriyoruz
zenity --info --title="İşlem Başarılı" --text="Yeni kullanıcı eklendi"


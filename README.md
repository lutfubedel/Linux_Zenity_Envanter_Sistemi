# Zenity ile Basit Envanter Yönetim Sistemi

Bu proje, Zenity araçlarını kullanarak basit bir envanter yönetim sistemi geliştirme amacı taşımaktadır. Proje, kullanıcı dostu bir grafik arayüz sağlar ve ürün ekleme, listeleme, güncelleme, silme gibi temel envanter yönetim işlemlerini destekler.

## Özellikler

- **Kullanıcı Rolleri:**
  - **Yönetici:** Ürün ekleme, güncelleme, silme ve kullanıcı yönetimi.
  - **Kullanıcı:** Ürünleri görüntüleme ve rapor alma.

- **Temel İşlevler:**
  - Ürün ekleme, listeleme, güncelleme, silme.
  - Raporlama:
    - Stokta azalan ürünler.
    - En yüksek stok miktarına sahip ürünler.
  - Kullanıcı yönetimi: Yeni kullanıcı ekleme, listeleme, güncelleme, silme.
  - Program yönetimi: Diskteki alanı görüntüleme, yedekleme, hata kayıtlarını gösterme.

- **Hata Yönetimi:**
  - Hatalı girişler için kullanıcıya uyarı mesajı ve `log.csv` dosyasına kayıt.
  - Kritik işlemler için onay mekanizması.
  - Şifre yönetimi ve kullanıcı hesap kilitleme.

## Kullanım

### Ana Menü
- **Ürün Ekle:** Yeni ürün bilgilerini girin ve sisteme ekleyin.
- **Ürün Listele:** Mevcut ürünleri görüntüleyin.
- **Ürün Güncelle:** Ürün bilgilerini güncelleyin.
- **Ürün Sil:** Bir ürünü envanterden kaldırın.
- **Rapor Al:** Belirtilen kriterlere göre rapor oluşturun.
- **Kullanıcı Yönetimi:** Kullanıcı ekleyin, listeleyin, güncelleyin veya silin.
- **Program Yönetimi:** Disk alanını kontrol edin, yedekleme yapın veya hata kayıtlarını görüntüleyin.

### Ekran Görüntüleri
Projenin kullanımına dair bazı ekran görüntüleri aşağıda yer almaktadır:

#### Kullanıcı Girişi:
![Ana Menü](./images/ss_1.png)

#### Ana Menü:
![Ürün Ekleme](./images/ss_2.png)

#### Ürün Ekleme:
![Hata Mesajları](./images/ss_3.png)

#### Hata Mesaj Örneği:
![Hata Mesajları](./images/ss_4.png)

#### Log Listesi Görünümü:
![Hata Mesajları](./images/ss_5.png)

#### Düşük Stoklu Ürünler:
![Hata Mesajları](./images/ss_6.png)

## Kullanım Videosu

Proje kullanım videosunu aşağıdaki bağlantıya tıklayarak izleyebilirsiniz:  
[Proje Kullanım Videosu](https://youtu.be/qzfu569VkOs)

## Projenin Github Sayfası

Projenin kaynak kodlarına aşağıdaki bağlantıdan ulaşabilirsiniz:
[Proje Github Sayfası](https://github.com/lutfubedel/Linux_Zenity_Envanter_Sistemi)

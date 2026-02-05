# Dünya Genelindeki İşten Çıkarmalar - Veri Temizleme Projesi (MySQL)

## Proje Özeti
Bu projede, küresel şirketlerin işten çıkarma verilerini içeren ham bir veri seti üzerinde kapsamlı veri temizleme işlemleri gerçekleştirdim. Projenin temel amacı; dağınık, yanlış formatlanmış ve eksik verilerden oluşan ham veri setini, Keşifsel Veri Analizi (EDA) için hazır, yapılandırılmış ve temiz bir formata dönüştürmektir.

**Veri Kaynağı:** [Alex The Analyst - Layoffs Dataset](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)

## Kullanılan Teknolojiler ve Teknikler
* **Veritabanı:** MySQL Workbench
* **Dil:** SQL
* **Temel Teknikler:** CTE (Common Table Expressions), Window Functions (`ROW_NUMBER`), Self-Join, Veri Standardizasyonu, Şema Modifikasyonu.

---

## Veri Temizleme Süreci Adımları

### 1. Staging (Aşamalandırma) Tablosu Oluşturma
Ham veriyi korumak amacıyla bir `layoffs_staging` tablosu oluşturuldu. Bu, temizleme sürecinde yapılabilecek hatalara karşı ham verinin orijinal halini saklamak için en iyi uygulama (best practice) yöntemidir.

### 2. Duplicate Verilerin Kaldırılması
Veri setinde benzersiz bir kimlik (ID) bulunmadığı için, tüm sütunlar üzerinden `ROW_NUMBER()` fonksiyonunu kullanarak tekrar eden satırlar tespit edildi.
* **Yöntem:** Bir **CTE** kullanarak `row_num > 1` olan satırlar belirlendi ve verileri temizlenmiş nihai aşama tablosuna aktarıldı.

### 3. Veri Standardizasyonu
* **Şirket İsimleri(company):** `TRIM()` fonksiyonu ile isimlerdeki gereksiz boşluklar temizlendi.
* **Sektör (Industry) Gruplama:** "Crypto", "CryptoCurrency" gibi farklı şekillerde yazılmış sektör isimlerini tek bir "Crypto" başlığı altında birleştirdim.
* **Ülke İsimleri(country):** "United States." gibi sonunda nokta bulunan hatalı ülke yazımlarını `TRIM(TRAILING '.' ...)` ile düzelterek grup analizlerine hazır hale getirildi.
* **Tarih Dönüşümü:** `TEXT` formatındaki tarih verilerini, `STR_TO_DATE()` kullanarak gerçek `DATE` formatına dönüştürüldü.

### 4. Eksik ve Boş Değerlerin (Nulls & Blanks) İşlenmesi
* Bazı şirketlerin eksik olan sektör bilgilerini, aynı şirketin diğer kayıtlarından **Self-Join** yaparak dolduruldu.
* Hem `total_laid_off` hem de `percentage_laid_off` değerleri boş olan (analitik bir değer sunmayan) satırlar temizlendi.

### 5. Şema Optimizasyonu
Temizlik işlemi bittikten sonra, duplicate kayıtları bulmak için yardımcı olarak eklenen `row_num` sütununu kaldırarak tabloyu analiz aşamasına hazır hale getirildi.

---

## Nasıl Kullanılır?
1. `layoffs.csv` dosyasını MySQL ortamınıza içe aktarın.
2. `01_Data_Cleaning.sql` dosyasındaki sorguları adım adım çalıştırın.
3. Temizlenmiş veri seti `layoffs_staging2` tablosunda kullanıma hazır olacaktır.

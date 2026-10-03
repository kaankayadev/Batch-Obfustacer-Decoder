Absolutely. I’ll keep it **natural and simple**, like your other GitHub READMEs, not overly professional or AI-looking.

```markdown
# Batch Obfuscator

Windows Batch ile yaptığım bir **Batch Obfuscator / De-Obfuscator** projesi.

Bu program bir `.bat` dosyasındaki harf ve rakamları değişken isimleriyle değiştirerek kodun okunmasını zorlaştırıyor. Daha sonra oluşturulan obfuscated dosyayı tekrar analiz edip eski haline döndürmeye çalışıyor.

## Özellikler

- `.bat` dosyasını obfuscate eder.
- Obfuscation için kullanıcıdan bir TAG alır.
- Harf ve rakamları otomatik olarak değişkenlere dönüştürür.
- Aynı karakter için aynı değişkeni kullanır.
- Boşluk ve özel karakterleri değiştirmez.
- Oluşturulan obfuscated dosyayı tekrar decode edebilir.
- Decode işlemi sırasında kullanılan TAG'i otomatik olarak bulur.
- Obfuscation sözlüğünü otomatik olarak hafızaya alır.
- Menü üzerinden obfuscation veya decode işlemi seçilebilir.

## Nasıl Çalışıyor?

Program açıldığında iki seçenek bulunuyor:

```text
[1] Bat dosyasını obfuscate et
[2] Bat dosyasını decode et
[3] Çıkış
```

### Obfuscation

Öncelikle obfuscate edilecek dosyanın isminin `main.bat` olması gerekiyor.

Program dosyayı satır satır okuyor ve her satırı karakter karakter işliyor.

Örneğin bir satırda:

```text
echo Hello123
```

gibi bir içerik varsa, program geçerli harf ve rakamları kendi oluşturduğu değişkenlerle değiştirebiliyor.

Program aynı karakteri tekrar gördüğünde yeni bir değişken oluşturmak yerine daha önce oluşturduğu değişkeni kullanıyor.

Oluşturulan değişkenler obfuscated dosyanın başında bir sözlük olarak tutuluyor.

### Decode

Decode işleminde obfuscated dosyanın isminin `sifreli.bat` olması gerekiyor.

Program önce dosyayı analiz ederek kullanılan TAG'i buluyor.

Daha sonra obfuscation sırasında oluşturulan değişkenleri okuyup hafızaya alıyor.

Son olarak obfuscated kod satırlarını tek tek inceleyerek değişkenleri tekrar gerçek karakterlere çevirmeye çalışıyor.

Sonuç olarak:

```text
cozulmus.bat
```

dosyası oluşturuluyor.

## Kullanılan Batch Konuları

Bu projeyi yaparken özellikle şu Batch konularını kullandım:

- `for /f`
- `for /L`
- `for`
- `if`
- `if defined`
- `if not defined`
- `set /p`
- `set /a`
- `setlocal enabledelayedexpansion`
- `call`
- `goto`
- `exit /b`
- `findstr`
- `type`
- Değişken substring işlemleri
- Dinamik değişken oluşturma
- Değişkenleri değişken olarak kullanma
- Dosya okuma ve yazma
- Geçici dosya kullanımı
- String değiştirme
- `errorlevel` kontrolü

## Proje Mantığı

Obfuscation tarafında temel mantık:

```text
BAT dosyası
     ↓
Satır satır oku
     ↓
Karakter karakter ayır
     ↓
Harf / rakam mı?
     ↓
Daha önce sözlükte var mı?
   ↙             ↘
 Evet             Hayır
  ↓                 ↓
Mevcut değişken   Yeni değişken oluştur
   ↘             ↙
      Obfuscated kod
           ↓
      sifreli.bat
```

Decode tarafında ise bunun tersi uygulanıyor:

```text
sifreli.bat
     ↓
TAG'i bul
     ↓
Sözlüğü oku
     ↓
Kod satırlarını oku
     ↓
Obfuscated değişkenleri bul
     ↓
Gerçek karakterleri geri koy
     ↓
cozulmus.bat
```

## Örnek

Program bir karakteri örneğin:

```text
A
```

şeklinde alıp sözlükte:

```bat
set "PASS_1=A"
```

şeklinde saklayabilir.

Kod içerisinde ise:

```bat
%PASS_1%
```

kullanılır.

Decode işlemi sırasında `%PASS_1%` tekrar:

```text
A
```

haline getirilmeye çalışılır.

## Amaç

Bu projeyi **Batch scripting, string işlemleri, dinamik değişkenler ve dosya işleme** konularını daha ileri seviyede öğrenmek için yaptım.

Özellikle bir `.bat` dosyasını sadece çalıştırmak yerine, dosyanın içeriğini okuyup karakter karakter işleyerek başka bir Batch dosyası oluşturmayı denemek istedim.

## Not

Bu proje gerçek anlamda güçlü bir güvenlik veya şifreleme sistemi değildir.

Amaç daha çok **Batch kodunun okunmasını zorlaştırmak ve obfuscation mantığını öğrenmek**.

Aynı zamanda decode işlemiyle oluşturulan obfuscation yapısının tekrar analiz edilmesini ve tersine çevrilmesini deniyorum.

Bu proje Batch öğrenme sürecimde yaptığım daha gelişmiş projelerden biridir.
```
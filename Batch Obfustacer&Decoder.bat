@echo off
chcp 65001 >nul
color 0D
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════╗
echo ║      OBFUSTACE/DECODE TOOL       ║
echo ╚══════════════════════════════════╝
echo ╔══════════════════════════════════╗
echo ║ [1] Bat dosyasını obfustace et   ║
echo ║ [2] Bat dosyasını decode et      ║
echo ║ [3] Çıkış                        ║
echo ╚══════════════════════════════════╝
echo.
set /p "secim=Seciminizi yapin (1-3): "
if "%secim%"=="3" goto exit
if "%secim%"=="2" goto decode
if "%secim%"=="1" goto obfustace

:obfustace
@echo off
title Kaan - Dinamik Obfuscator
color 0A

set "INPUT=main.bat"
set "OUTPUT=sifreli.bat"
set "TEMP_KOD=temp_kod.txt"

echo Şifrelenecek dosyanın ismini main.bat olarak değiştirin.
echo Şifreleme sonrasında sifreli.bat dosyası oluşacaktır.
set /p "TAG=Obfuscation Tag (orn: PASS): "
if "!TAG!"=="" set "TAG=OBF"
set "TAG=!TAG: =_!"

:: Eski dosyalari temizle
if exist "%OUTPUT%" del "%OUTPUT%"
if exist "%TEMP_KOD%" del "%TEMP_KOD%"

if not exist "%INPUT%" (
    echo Şifrelenecek dosya bulunamadı!
    echo Dosya ismini düzletip (main.bat) tekrar deneyin.
    timeout /t 2 >nul
    exit
)

:: Sifreli dosyanin en ust basligini yazdir
echo @echo off > "%OUTPUT%"
echo :: Obfuscated by Kaan >> "%OUTPUT%"

set "SAYAC=0"
set "SOZLUK_SATIRI="

:: 1. SATIRLARI OKUMA DONGUSU
for /f "usebackq delims=" %%A in ("%INPUT%") do (
    set "SATIR=%%A"
    set "YENI_SATIR="
    
    :: Satiri harf harf islemek icin alt motora gonder
    call :HARF_MOTORU
    
    :: Sifrelenmis satiri gecici dosyaya yaz
    echo !YENI_SATIR! >> "%TEMP_KOD%"
)

:: 2. BIRLESTIRME ASAMASI
echo !SOZLUK_SATIRI! >> "%OUTPUT%"
type "%TEMP_KOD%" >> "%OUTPUT%"
del "%TEMP_KOD%"

echo Islem Basarili! sifreli.bat dosyasini kontrol et.
pause
exit

:: -----------------------------------------------------
:: ALT MOTOR: HARF HARF KESME VE SIFRELEME BOLUMU
:: -----------------------------------------------------
:HARF_MOTORU
:: Satir bittiyse (bosaldiysa) ana donguye geri don
if "!SATIR!"=="" goto :eof

:: Ilk harfi al ve satirdan sil
set "HARF=!SATIR:~0,1!"
set "SATIR=!SATIR:~1!"

:: CMD cokmesin diye sadece gecerli karakterleri sifreleyecegiz
set "HARF_GECERLI=0"
for %%L in (a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9) do (
    if "!HARF!"=="%%L" set "HARF_GECERLI=1"
)

if "!HARF_GECERLI!"=="1" (
    :: Eger harf daha once sozluge eklenmediyse:
    if not defined ksnfk_!HARF! (
        set /a SAYAC+=1
        set "ksnfk_!HARF!=%TAG%_!SAYAC!"
        
        :: Sozlugu dosyaya alt alta yazmak yerine tek satirda biriktiriyoruz (& ile)
        set "EKLENECEK=set "%TAG%_!SAYAC!=!HARF!"&"
        set "SOZLUK_SATIRI=!SOZLUK_SATIRI!!EKLENECEK!"
    )
    
    :: Harfin sifreli adini bul ve yeni satira ekle
    for %%H in ("!HARF!") do set "DEGISKEN_ADI=!ksnfk_%%~H!"
    set "YENI_SATIR=!YENI_SATIR!%%!DEGISKEN_ADI!%%"
) else (
    :: Bosluk veya sembol ise, sifrelemeden oldugu gibi ekle
    set "YENI_SATIR=!YENI_SATIR!!HARF!"
)

goto :HARF_MOTORU

:decode
@echo off
title Kaan - De-Obfuscator (Sifre Cozucu)
color 0C

set "INPUT=sifreli.bat"
set "OUTPUT=cozulmus.bat"

echo Sifreli dosyanin ismini sifreli.bat olarak değiştirin.
echo Cozulmus dosya cozulmus.bat olarak olusacaktir.

if not exist "%INPUT%" (
    echo Decode edilecek dosya(sifreli.bat) bulunamadı.
    echo Dosya ismini kontrol ediniz.
    timeout /t 2 >Nul
    exit
)

:: Eski dosyalari temizle
if exist "%OUTPUT%" del "%OUTPUT%"
if exist "temp_sozluk.bat" del "temp_sozluk.bat"

echo Sifreli dosya analiz ediliyor...

:: 1. ADIM: TAG'I OTOMATIK ALGILAMA (Pattern Recognition)
set "TAG="
for /f "usebackq tokens=1 delims=_" %%X in (`type "%INPUT%" ^| findstr /c:"set \"""`) do (
    if "!TAG!"=="" (
        set "RAW=%%X"
        :: 'set "' kismini kirpip atiyoruz, geriye sadece TAG kaliyor
        set "TAG=!RAW:*set "=!"
    )
)

if "!TAG!"=="" (
    echo HATA: Dosya icinde hicbir TAG bulunamadi. Bu dosya sifreli olmayabilir!
    pause
    exit
)
echo Bulunan Sifreleme TAG'i: [ !TAG! ]

:: 2. ADIM: SOZLUGU HAFIZAYA ALMA
:: Sadece "set "TAG_" iceren satirlari bulup temp dosyaya atiyoruz
type "%INPUT%" | findstr /c:"set \"!TAG!_" > temp_sozluk.bat
call temp_sozluk.bat
del temp_sozluk.bat
echo Sozluk hafizaya alindi. Sifreler cozuluyor...

:: 3. ADIM: SIFRELI SATIRLARI COZME (Asil Dongu)
for /f "usebackq delims=" %%A in ("%INPUT%") do (
    set "SATIR=%%A"
    
    :: Eger satir "set "TAG_" iceriyorsa bu bir sozluk kelimesidir, es gec.
    echo !SATIR! | findstr /c:"set \"!TAG!_" >nul
    if !ERRORLEVEL! NEQ 0 (
        
        :: Eger satir yorum veya echo off ise de es gec (Dogrudan kaydet)
        echo !SATIR! | findstr /c:"@echo off" >nul
        if !ERRORLEVEL! NEQ 0 (
            echo !SATIR! | findstr /c:"::" >nul
            if !ERRORLEVEL! NEQ 0 (
                
                :: BURASI SIFRELI KOD SATIRIDIR! SIMDI COZECEGIZ.
                :: Alfabemizde maksimum 75 karakter vardi, 1'den 75'e kadar tariyoruz
                for /L %%N in (1, 1, 75) do (
                    
                    :: Eger bu degisken (Orn: TAG_1) hafizada varsa:
                    if defined !TAG!_%%N (
                        
                        :: Aranan kelime: %TAG_1%
                        set "ARANAN=%%!TAG!_%%N%%"
                        
                        :: Gercek Harf: e
                        for %%V in ("!TAG!_%%N") do set "GERCEK_HARF=!%%~V!"
                        
                        :: Icerideki butun %TAG_1%'leri 'e' ile degistir (Replace)
                        for %%R in ("!ARANAN!") do set "SATIR=!SATIR:%%~R=!GERCEK_HARF!!"
                    )
                )
            )
        )
        :: Cozulmus veya atlanmis satiri Cikti dosyasina yazdir
        echo !SATIR! >> "%OUTPUT%"
    )
)

echo Islem Basarili! cozulmus.bat dosyasini kontrol et.
timeout /t 2 >nul
exit

:exit
timeout /t 1 >nul
exit
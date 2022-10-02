Otomatik Isitme Tarama Testi version 0.1
-----
Soner Türüdü / PhD Student - UMCG / dBSPLab
-----

Test hakkinda bilgilendirme
-----
1- Oncelikle testi calistirdiktan sonra katilimci isminin girilmesi isteniyor
 
2- Katilimci ismi girildikten sonra test sirasiyla 250 Hz'den baslayip 8000 Hz'e kadar devam ediyor. Bu kismi kod satirindan degistirebilirsiniz. degerleri kHz olarak yazmayi unutmayin.
 
3- Tum frekanslarda ilk uyaran -5te gelip, 5er dB'lik adimlarla artip azaliyor. Burayi da ilgili kod satirindan degistirebilir, mesela 0 dan baslatip 10dBlik adimlarla testi daha cabuk bitirebilirsiniz fakat guvenilirligine dikkat ediniz.
 
4- Eger 3 adet evet yaniti yani 3 farkli siddette sesleri duydugumuzu belirttiysek median hesabindan dogru yanitlar kucukten buyuge siralanip ortadaki deger esik kabul ediliyor. Yani -5te evet deyip, tekrar -5'te hayir dedikten sonra 0'da evet, -5te hayir, 0 da hayir, 5te evet diyince 3 adet evet almis oluyoruz. Fakat -5'te 0'da ve 5'te aldigimiz icin bu yanitlari median hesabindan esigi 0 olarak belirliyoruz. Ayni sekilde mesela 20 de 2 kere cevap alip 3. evet yanitini 30da alirsak, yine 20 20 30 diye siralayacagi icin daha guvenilir olan 20'yi esik kabul ederiz. Bu yontem isitme taramasi icin gayet ideal ve dogru gorunmekte. Bu staircase metodunu degistirebilirsiniz. Kodlamadaki amacim matlab kodlarinin yapacaginiz projeler icin mantigini gosterebilmek ve kendinize gore gelistirmeler yapabilmeniz.

5- Bazi testlerde esikler mode ya da mean hesaplamasi ile bulunuyor. Ben median ile esik belirlemek istedim. Mesela mode kullanilirsa 3 adet verilen cevaptan en sik tekrar edileni cevap olarak alir. Ancak 3 farkli cevap gelirse algoritmaya bunu tanitmadikca en dusuk seviyede verilen yaniti, isitme esigi olarak alacaktir. Mean ise duyulan esiklerin ortalamasini alir. Fakat bu odyogram uzerinde gosterimde 5er dB'lik adimlara uymayacagi icin dogru gorunmeyecektir.

6- Test sirasinda once Sag kulaktan baslaniyor, daha sonra sol kulaga geciliyor. Burayi isterseniz ilgili kodlardan degistirebilirsiniz.

7- Sag kulak bittikten sonra sol kulaga gecerken herhangi bir tusa basmaniz isteniyor

8- Sol kulakta da tum frekanslar test edildikten sonra veriler ve odyogram sonuclar klasorune kayit ediliyor. 

9- Oncelikle Sonuclar klasorunuz yoksa, yazilim kendi kendine olusturuyor. Olusturduktan sonra Sonuclar klasorunde test sonuclarina ait kulak yonu, frekans, dB, Tekrar, Secim, Yanit Suresi parametrelerini iceren txt dosyasi ile isitme sonucu (odyogram) png olarak eklenmis oluyor. Ayrica Sonuclar klasorunun disina da txt bilgileri json dosyasi olarak kaydediliyor.

Notlar: 
----
*Test sirasinda deneme sesine iptal dersek asagida bize Testi iptal etmek isteyip istemedigimiz sorulacak. Burada Evet yazarak testi iptal edebilirsiniz. Bazen yanlislikla testten cikilabiliyor. Bunun onune gecmek icin 'Evet' yazilmasini istedim. Ancak teste cabuk devam edebilmek icin de sadece H yazarak teste devam edebilirsiniz.

*Testi iptal etmedikten sonra ayni esige dondugunuzde, daha onceki staircase sifirlanmis oluyor. Mesela 250 Hz'de 2 adet evet yaniti verdiniz ve daha sonra yanlislikla testi iptal etmek istediniz. Fakat H diyerek teste geri dondunuz. Teste geri dondukten sonra staircase metodu sifirlanarak tekrar -5ten uyaran gonderimine basliyor.

Test icerisindeki kodlara dair bazi notlar
-----
Tic ile mevcut zamani kaydederiz, toc ile gecen sureyi hesaplariz

Questdlg, sorular icin diyalog kutusu acar

Strcmpi(a1,a2) kodunda a1 ile a2yi harflerin yazimi bakimindan karsilastiririz

Isempty ile degiskene atanan deger bos mu degil mi karar veririz. Bos ise 1, degil ise 0 degeri alir. ~isempty ise tersidir

flaglari debug test icin kullaniyoruz o yuzden kullanimini ogrenmek degerli 

input ile kullanicidan bir girdi istiyoruz

length ise mesela frekans_listesi = [0.25 0.5] ise length 2 oluyor. 2 farkli deger aldigi icin. Eger 0.25 0.5 1 yapsaydik length 3 olacakti.


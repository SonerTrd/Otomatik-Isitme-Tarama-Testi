%% ==========================================
% Date 2022-10-02
% Otomatik Isitme Tarama Testi version 0.1
% Soner Türüdü
% sonerturudu.com
% github/SonerTrd
% dBSPLab
% PhD Student - UMCG
% ==========================================

%% Test hakkinda bilgilendirme
% 1- Oncelikle testi calistirdiktan sonra katilimci isminin girilmesi isteniyor
% 2- Katilimci ismi girildikten sonra test sirasiyla 250 Hz'den baslayip 8000 Hz'e kadar devam ediyor. Bu kismi kod satirindan degistirebilirsiniz. degerleri kHz olarak yazmayi unutmayin.
% 3- Tum frekanslarda ilk uyaran -5te gelip, 5er dB'lik adimlarla artip azaliyor. Burayi da ilgili kod satirindan degistirebilir, mesela 0 dan baslatip 10dBlik adimlarla testi daha cabuk bitirebilirsiniz fakat guvenilirligine dikkat ediniz.
% 4- Eger 3 adet evet yaniti yani 3 farkli siddette sesleri duydugumuzu
% belirttiysek median hesabindan dogru yanitlar kucukten buyuge siralanip ortadaki deger esik kabul ediliyor. 
% Yani -5te evet deyip, tekrar -5'te hayir dedikten sonra 0'da evet, -5te hayir, 0 da hayir, 5te evet diyince 3 adet evet almis oluyoruz. Fakat -5'te 0'da ve 5'te aldigimiz icin bu yanitlari median hesabindan esigi 0 olarak belirliyoruz.
% Ayni sekilde mesela 20 de 2 kere cevap alip 3. evet yanitini 30da alirsak, yine 20 20 30 diye siralayacagi icin daha guvenilir olan 20'yi esik kabul ederiz. Bu yontem isitme taramasi icin gayet ideal ve dogru gorunmekte.
% Bu staircase metodunu degistirebilirsiniz. Kodlamadaki amacim matlab kodlarinin yapacaginiz projeler icin mantigini gosterebilmek ve kendinize gore gelistirmeler yapabilmeniz.
% 5- Bazi testlerde esikler mode ya da mean hesaplamasi ile bulunuyor. Ben median ile esik belirlemek istedim. Mesela mode kullanilirsa 3 adet verilen cevaptan en sik tekrar edileni cevap olarak alir. Ancak 3 farkli cevap gelirse algoritmaya bunu tanitmadikca en dusuk seviyede verilen yaniti, isitme esigi olarak alacaktir. Mean ise duyulan esiklerin ortalamasini alir. Fakat bu odyogram uzerinde gosterimde 5er dB'lik adimlara uymayacagi icin dogru gorunmeyecektir.
% 6- Test sirasinda once Sag kulaktan baslaniyor, daha sonra sol kulaga geciliyor.
% Burayi isterseniz ilgili kodlardan degistirebilirsiniz.
% 7- Sag kulak bittikten sonra sol kulaga gecerken herhangi bir tusa basmaniz isteniyor
% 8- Sol kulakta da tum frekanslar test edildikten sonra veriler ve odyogram sonuclar klasorune kayit ediliyor. 
% 9- Oncelikle Sonuclar klasorunuz yoksa, yazilim kendi kendine olusturuyor. Olusturduktan sonra Sonuclar klasorunde test sonuclarina ait kulak yonu, frekans, dB, Tekrar, Secim, Yanit Suresi parametrelerini iceren txt dosyasi ile isitme sonucu (odyogram) png olarak eklenmis oluyor.
% Ayrica Sonuclar klasorunun disina da txt bilgileri json dosyasi olarak kaydediliyor.
% Notlar: 
% **Test sirasinda deneme sesine iptal dersek asagida bize Testi iptal etmek isteyip istemedigimiz sorulacak. 
% Burada Evet yazarak testi iptal edebilirsiniz.
% Bazen yanlislikla testten cikilabiliyor. Bunun onune gecmek icin 'Evet' yazilmasini istedim. Ancak teste cabuk devam edebilmek icin de sadece H yazarak teste devam edebilirsiniz.
% ***Testi iptal etmedikten sonra ayni esige dondugunuzde, daha onceki staircase sifirlanmis oluyor. Mesela 250 Hz'de 2 adet evet yaniti verdiniz ve daha sonra yanlislikla testi iptal etmek istediniz. Fakat H diyerek teste geri dondunuz. Teste geri dondukten sonra staircase metodu sifirlanarak tekrar -5ten uyaran gonderimine basliyor.

%% Test icerisindeki kodlara dair bazi notlar
% Tic ile mevcut zamani kaydederiz, toc ile gecen sureyi hesaplariz
% Questdlg, sorular icin diyalog kutusu acar
% Strcmpi(a1,a2) kodunda a1 ile a2yi harflerin yazimi bakimindan karsilastiririz
% Isempty ile degiskene atanan deger bos mu degil mi karar veririz. Bos ise 1, degil ise 0 degeri alir. ~isempty ise tersidir
% flaglari debug test icin kullaniyoruz o yuzden kullanimini ogrenmek degerli 
% input ile kullanicidan bir girdi istiyoruz
% length ise mesela frekans_listesi = [0.25 0.5] ise length 2 oluyor. 2 farkli deger aldigi icin. Eger 0.25 0.5 1 yapsaydik length 3 olacakti.
% ==========================================

%% Kullanicinin degistirebilecegi ayarlar
cikti_klasoru = './sonuclar/'; % Sonuclarin kaydedilecegi klasoru seciyoruz
frekans_listesi =  [0.5 1 2 4]; % Hangi frekanslarda test yapilsin?
isitme_esik_list = -5 : 5 : 85; % Isitme testinde -5 dB den taramaya baslanir, 5 dB'lik adimlarla 60 dB'ye kadar gider
kulakyonu = {'Sag', 'Sol'}; % kulakyonu degiskenine Sol ve Sag kulagi tanimliyoruz
renk = {'r' 'b'}; % Test sonunda cizdirilecek Odyogramda sol ve sag kulak renkleri --> b blue, r red
orneklem = 48000; % Orneklem sayisi
maksimumcikis = 85; % Maksimum cikis seviyesi
dogru_sayisi = 3; % Test sirasinda 3 adet dogru cevap alinca esik belirliyor ve diger uyarana geciyoruz
intertoneinterval = 0.15; % Saf ses gonderirken iki adet 'bip' arasindaki sure
rms_level = 0.7; % rms degeri. Bu degeri simdilik sabit birakabilirsiniz. 
                 % Maksimum cikisi 80-85 yaparsaniz daha dogru sonuc alabilirsiniz.
secim_1 = 'Evet'; % Saf ses sunulduktan sonra verilen cevap, 1.secim Evet
secim_2 = 'Hayir'; % Saf ses sunulduktan sonra verilen cevap, 2.secim Hayir
secim_def_degeri = secim_2; % Karsimiza evet ve hayir secenekleri geldiginde hayir daha belirgin olacak

flag_enable_gui = 1;

durdurma = 'on'; % durdurma komutu
soru_katilimci = 'gelen sesleri duydunuz mu?'; % Katilimciya sorulacak soru. Acilan penceredeki yazi.
soru_baslik = 'Lutfen cevaplayin'; % Cevap almak icin. Bu karsimiza kucuk pencere acilinca yukarida gorunuyor.
kulaklararasigecis = 'Diger kulaga gecmek icin bir tusa basiniz'; % Bir kulak bittikten sonra digerine gecerken verilen uyari
sutunisimleri = ... % Verileri kaydederken kullanacagimiz sutunlarin isimleri
    {
    'kulak';
    'frekans';
    'dB'
    'Tekrar';
    'Secim';
    'Yanit Suresi';
    };

flag_debug = 0;

%% test baslangici

flag_0 = 0;
flag_1 = 1;

% Kullanici ismini aliyoruz
if flag_debug==0
    katilimci = input('Isminizi giriniz: ', 's');
    if isempty(katilimci)
        % Eger katilimci cevap vermezse default bir isim belirliyoruz
        katilimci = 'Katilimci';
    end
else
    katilimci = 'test';
end

kulaksayisi = length(kulakyonu); % Sag ve sol kulaklarin sayisini belirtiyoruz
freksayisi = length(frekans_listesi); % kac tane frekansi olcecegiz?
siddet_sayi = length(isitme_esik_list); % kac adet saf ses sunuluyor? -5 ten 60a kadar 5 dB lik adimlarla 14.
kulakfreksayisi = [kulaksayisi freksayisi]; % Sag ve Sol 2 kulak, Eger 0.25 ve 0.5te test yaptiysak 2 de frekans sayisi
esikler = zeros(kulakfreksayisi); % kulakfreksayisina gore esikleri alip 0 matrisi olusturuyoruz
isitilenlist = zeros([kulakfreksayisi dogru_sayisi]); % Kullanicinin verdigi dogru yanitlari cekmek icin 0 matrisi olusturuyoruz.
sutunsayisi = length(sutunisimleri); % sonuc tablosuna ait parametrelere basliyoruz
mevcut_deneme_sonucu = zeros(1,sutunsayisi); % her bir deneme yani uyaran icin sutun sayisi belirleyip 0 matrisi olusturuyoruz.
aa = 1; % aa ile sonuc tablosuna kac adet veri girildigini hesapliyoruz

%% Cikti dosyalarinin olusturulmasi

% Kayit dosyasinin ismini olusturmak icin saat ve tarih bilgilerini aliyoruz
saat = clock;
tarihsaat = sprintf('%s_%.2d_%.2d_%.2d',date,saat(4),saat(5),round(saat(6)));

% Eger cikti klasoru yoksa olusturmasini istiyoruz
if ~(exist(cikti_klasoru,'dir'))
    mkdir(cikti_klasoru);
end

% dosya isimlerini json olarak ve txt olarak kaydediyoruz
if flag_debug==0
    kayitdosyaismi = [katilimci '_' tarihsaat '.json'];
else
    kayitdosyaismi = [katilimci '.txt'];
end
cikti_dosya_ismi = [katilimci];

% verileri kaydetmek icin dosyayi acma
kayitacma = fopen([cikti_klasoru '/' kayitdosyaismi],'w');

if flag_debug==0
    cikti_dosya_sekli = [cikti_klasoru '/' tarihsaat '/' ];
    
    % sistemden aldigimiz tarih ve saat bilgileriyle klasor olusturuyoruz
    if ~(exist(cikti_dosya_sekli,'dir'))
        mkdir(cikti_dosya_sekli);
    end
else
    cikti_dosya_sekli = cikti_yeri;
end

% verileri girmek icin tarih ve saat bilgileri iceren dosyayi aciyoruz
ciktiacma = fopen([cikti_dosya_sekli '/' cikti_dosya_ismi '_' tarihsaat '.txt'],'w');

% Tum verileri yazdiriyoruz
for cc = 1:sutunsayisi
    fprintf(ciktiacma,'%s \t', sutunisimleri{cc});
end
fprintf(ciktiacma,'\n\n');

%% testin duraklatilmasi islevi ayarlaniyor
pause(durdurma);

% her iki kulak icin de tekrar ediyor 1:1 sol, 1:2 sag
for kulakdongusu = 1:kulaksayisi
    
    kulak = kulakyonu{kulakdongusu};
    
    % tum frekanslar icin tekrar etmesini istiyoruz
    for frekansdongu = 1:freksayisi
        
        % mevcut frekans bilgisini aliyor
        mevcut_frekans = frekans_listesi(frekansdongu)*1000;
        
        % test asamasi icin saf ses uretiyor
        orijinal_uyaran = uyaran_olustur(mevcut_frekans, kulak, orneklem);
        
        if flag_debug==0

            % uyaran yukleniyor. Burada audioplayer kullandim
            player = audioplayer(orijinal_uyaran, orneklem);

            % uretilen saf sesi oynatiyor
            playblocking(player);

            % Katilimciya sesleri gonderdigimize dair bilgi veriyoruz
            % Eger katilimci hayir sesler gelmedi diyorsa iptal surecine geciyoruz
            if flag_enable_gui
                alinan_cevap = questdlg(['' kulak ' kulaginiza duyabileceginiz seviyede saf sesler gonderildi'], ...
                    soru_baslik, 'Devam','Iptal','Devam');
                
                if strcmp(alinan_cevap, 'Iptal')
                    yanit = 0;
                else
                    yanit = 1;
                end
            else
                kullanici_yanit = input(['' kulak ' kulaginiza duyabileceginiz seviyede saf sesler gonderildi'],'s');
                
                if (strcmpi(kullanici_yanit,'H') || strcmpi(kullanici_yanit,'Hayir'))
                    yanit = 0;
                else
                    yanit = 1;
                end
            end
            
            %% Eger katilimcidan bir yanit alamazsak testi iptal edebilmesi icin kod satiri
            if yanit==0
                disp ' ';
                amac = input('Testi iptal etmek mi istiyorsunuz? Evet or [H]: ', 's');
                if isempty(amac)
                    % default bir deger atiyoruz
                    amac = 'n';
                end
                if strcmpi('Evet',amac)
                    disp('Iptal ediliyor..');
                    fclose(hlog_file);
                    fclose(ciktiacma);
                    return; % programi kapatiyoruz
                else
                    disp('Devam ediliyor..');
                    disp ' ';
                end
            end
        end
        
        % burada tekrar sayacini sifirliyoruz
        tekrar = 0;
        
        % isitilen seviyeleri ayarliyoruz. Hangi siddetlerde cevap alindi?
        isitilen_seviye = repmat(max(isitme_esik_list),dogru_sayisi, 1);
        
        %% donguyu baslatma
        bb = 1; cc = 1;
        
        % Tum isitme seviyelerini (-5 0 10 15..) dolasir
        while (bb <= siddet_sayi)
            
            % mevcut isitme siddetini al
            mevcut_siddet = isitme_esik_list(bb);
            % maksimum output a gelince esitle ve bitir
            if mevcut_siddet > maksimumcikis
                mevcut_siddet = maksimumcikis;
            end
            
            disp(['Kulak: ' kulak ' Frekans: ' num2str(mevcut_frekans) ' Deneme: ' num2str(cc)]);
            
            % mevcut deneme parametrelerini kaydetme
            mevcut_deneme_sonucu(1) = kulakdongusu;
            mevcut_deneme_sonucu(2) = mevcut_frekans;
            mevcut_deneme_sonucu(3) = mevcut_siddet;
            mevcut_deneme_sonucu(4) = tekrar;
            
            % parametreleri kaydetme
            fprintf(kayitacma, 'Kulak: %s Frekans: %d dB HL: %d\n', kulak, mevcut_frekans, mevcut_siddet);
            
            %% uyaran olusturulmasi
            
            % kazancin hesaplanmasi
            kazanc = 10^((mevcut_siddet - maksimumcikis)/20);
            
            % en uygun kazanc seviyesine gore uyaran duzenleniyor
            uyaran = orijinal_uyaran * kazanc;
            
            if flag_debug==0
                
                % uyaran yukleniyor
                player = audioplayer(uyaran, orneklem);
                
                % uyaran oynatiliyor
                playblocking(player);
                
            end
            
            %% Kullanicidan yanit alma kismi (sayac)
            
            % yanit suresini ayarlamak icin tic ile sure basliyor
            t = tic;
            
            if flag_debug==0
                
                % kullanicidan gelen cevabi aliyoruz
                if flag_enable_gui
                    alinan_cevap = questdlg(['' kulak ' kulaginiza ' soru_katilimci], ...
                        ['Deneme: ' num2str(cc) ' ' soru_baslik], secim_1,secim_2,secim_def_degeri);
                    
                    % kaydedilen yaniti string e ceviriyoruz
                    if strcmp(alinan_cevap, secim_1)
                        yanit = 1;
                    elseif strcmp(alinan_cevap, secim_2)
                        yanit = 2;
                    else
                        yanit = 0; % kullanici yanit vermezse 0 degeri atandi
                    end
                else
                    kullanici_yanit = input([soru_katilimci '  Evet (1) or Hayir (2)?: '],'s');
                    
                    % kullanicidan alinan cevap standart bir degiskene ataniyor
                    if (strcmpi(kullanici_yanit,'E') || strcmpi(kullanici_yanit,'1'))
                        alinan_cevap = secim_1;
                        yanit = 1;
                    elseif (strcmpi(kullanici_yanit,'H') || strcmpi(kullanici_yanit,'2'))
                        alinan_cevap = secim_2;
                        yanit = 2;
                    elseif isempty(kullanici_yanit)
                        alinan_cevap = ''; % kullanici yanit vermediginde bos kisim
                        yanit = 0;
                    else
                        alinan_cevap = '?';
                        yanit = -1; % bos ya da gecersiz yanit
                    end
                end
                
            else
               % Burasi hata ayiklama ile ilgili rastgele bir deger atama kismi
                rastgele_secim = (rand(1) > (0.1 + tekrar/4) ) + 1;
                if rastgele_secim(1)==1
                    alinan_cevap = secim_1;
                else
                    alinan_cevap = secim_2;
                end
                yanit = rastgele_secim(1);
            end
            
            % Burada toc ile yanit suresini saymayi birakiyoruz
            yanit_suresi = toc(t);
            
            % mevcut denemeye ait verileri kaydet
            mevcut_deneme_sonucu(end-1) = yanit;
            
            % mevcut denemeye ait verileri kaydet
            mevcut_deneme_sonucu(end) = yanit_suresi;
            
            % verilen yanitlara ait verileri aliyoruz
            if flag_debug
                disp(['Cevap: ' alinan_cevap '   Yanit Suresi: ' num2str(yanit_suresi,'%.3f') ' s']);
            end
            
            % kullaniciya ait veriyi yazdiriyoruz
            fprintf(kayitacma,'Verilen yanit: %s \nYanit Suresi: %.3f s\n',alinan_cevap,yanit_suresi);
            
            %% her denemeye ait verilerin kayit edilmesi
            
            % aa ile 1. satirdan baslanarak, her denemeye ait sonuclar
            % aliniyor ve o anki verilere (mevcut_deneme_sonucu) kaydediliyor.
            sonuc_tablosu(aa,:) = mevcut_deneme_sonucu;
            
            % ara degerler verisetine ekleniyor.
            fprintf(ciktiacma,'%.4g\t',mevcut_deneme_sonucu);
            
            fprintf(ciktiacma,'\n');
            fprintf(kayitacma,'\n');
            
            %% Tekrar mantigi
            
            if yanit == 1
                
                isitilen_seviye(tekrar+1) = mevcut_siddet;
                
                % Tum tekrarlar tamamlandi mi?
                if tekrar == (dogru_sayisi-1)
                    % ilgili frekans icin testi durdur
                    break;
                else
                    % tekrarlama kismi
                    tekrar = tekrar + 1;
                    
                    % Burada eger 0 dan 5 e geldiysek test esnasinda 1
                    % yaparak tekrar 0 a inmesini sagliyoruz. Eger 2
                    % yaparsak -5 e dusup test oradan devam edecek.
                    bb = bb - 1;
                    
                    % index pozitif mi test ettik
                    if (bb < 1)
                        bb = 1;
                    end
                end
            elseif yanit >= 1
                % sayaca donduk
                bb = bb + 1;
            end
            
            % sayaclar
            cc = cc + 1;
            aa = aa + 1;
            
            %% Katilimci herhangi bir yanit vermediginde, testi bitirmek istediginde; testi sonlandirma kismi
            if yanit==0
                disp ' ';
                % disp('To continue, Press F5. To exit, press Shift+F5'); keyboard;
                amac = input('Testi iptal etmek mi istiyorsunuz? Evet or [H]: ', 's');
                if isempty(amac)
                    % assign default answer
                    amac = 'n';
                end
                if strcmpi('Evet',amac)
                    disp('Iptal ediliyor..');
                    fclose(kayitacma);
                    fclose(ciktiacma);
                    return; % exit the program
                else
                    disp('Devam ediliyor..');
                    disp ' ';
                end
            end
        end
        
        %% Saf ses esiklerinin hesaplanmasi
        
        % Ilgili frekansta isitilen siddetlerin kaydedilmesi
        isitilenlist(kulakdongusu, frekansdongu, :) = isitilen_seviye;
        
        % Burada 'Evet' yaniti verilen 3 adet siddet kucukten buyuge siralaniyor ve ortadaki esik olarak belirleniyor. 
        % Ancak bazi calismalarda esikler mode ya da mean ile de belirlenebiliyor. Bu kisinin yaklasimina gore degisir.
        esikler(kulakdongusu, frekansdongu) = median(isitilen_seviye);
        
    end
    
    %% Odyogram cizdirme kismi 
    % Bu kisma ait bilgileri daha once Matlab'de odyogram olusturma videosunda da anlatmistim
    % Farkli olarak plot yerine semilogx kullandim, cunku 250 500 1 ile 1 2 4 8 kHzlerin grafige yayilimini dogru bulmadim
    % plot ile cizdirirseniz anlasilacaktir
    if mod(kulakdongusu,2)
        h_fig = figure('position',[850 100 800 400],'visible','off');
        h_fig.WindowState = 'maximized';
    end
    
    subplot(1,2,kulakdongusu);

    if kulakdongusu == 1
        semilogx(frekans_listesi, esikler(kulakdongusu,:), [renk{kulakdongusu} 'o-'])
        elseif kulakdongusu ==2
        semilogx(frekans_listesi, esikler(kulakdongusu,:), [renk{kulakdongusu} 'x-'])
    end 

    xlabel('Frekans (kHz)');
    ylabel('Isitme Seviyesi (dB HL)');
    title([kulak ' kulak']);
    axis tight;
    grid on;
    set(gca, 'YDir','reverse')
    ylim([-10 60]);
    set(gca,'XTick',frekans_listesi);
    xlim([min(frekans_listesi)-0.1 max(frekans_listesi)+1]);
    set(gca,'XTickLabel',string(frekans_listesi));

    if mod(kulakdongusu,2)==0
        saveas(h_fig, [cikti_dosya_sekli '/' cikti_dosya_ismi '_odyogram'], 'png');
        close(h_fig);
        disp(['Odyogrami buraya yazdir: ' cikti_dosya_sekli]);
    end
    %% kulaklar arasindaki gecisi gosteriyor
    disp ' ';
    fprintf(kayitacma,'\n\n');
    
    if mod(kulakdongusu,2) && flag_debug==0
        % mesaji goster
        disp(kulaklararasigecis);
        
        % kullanici hazir olana kadar testi durdurur
        pause;
        
    end
end

% testin sonunda cikti ve kayit dosyalarini kapatir
fclose(kayitacma);
fclose(ciktiacma);

%% Bu fonksiyon ile akustik uyaranlari uretiyoruz
function uyaran = uyaran_olustur(safses_frekans, kulak, orneklem_sayisi)

uyaran_suresi = 0.30; % gelen uyaranin suresi (sn)
intertoneinterval = 0.15; % intertoneinterval(sn)
rms_level = 0.7; % uyaranlarin RMS seviyesini ayarliyoruz
% Deneme esnasinda kac tane ton gonderilsin? bip bip
saf_ses_sunum_sayisi = 2; % Burayi 3 de yapabilirsiniz, tercihe bagli
if nargin < 3 
    orneklem_sayisi = 48000; % default orneklem sayisi
end

if nargin < 2
    kulak = 'Sag'; 
end

if nargin < 1
    safses_frekans = 1000; % deneme uyaraninin frekansi
end

onset_duration = 20; % her uyaran icin onset/offset suresinin ayarlanmasi (ms)

%% Tone yapisiyla ilgili degiskenler
% Buradan sonrasi genel test ayarlari 
t_vec = (0 : 1/orneklem_sayisi : uyaran_suresi - 1/orneklem_sayisi); % zaman indekslerini hesapliyor
std_tone = sin(2*pi * safses_frekans * t_vec); % standart saf sesi hesaplar
std_tone = rms_level * std_tone/std(std_tone); % standart saf sese ait rms leveli hesaplar
std_tone = window_adsr(std_tone, orneklem_sayisi, onset_duration); % standart saf sese ait baslangic ve onset suresi ayarlanir

%%  Uyaranin yapisiyla ilgili degiskenler
int_tone_gap = zeros(round(intertoneinterval * orneklem_sayisi),1);
uyaran = [repmat([std_tone; int_tone_gap], saf_ses_sunum_sayisi-1, 1); std_tone];
% stereo donusturme
if strcmpi(kulak,'Sol')
    uyaran = [uyaran zeros(length(uyaran),1)];
elseif strcmpi(kulak,'Sag')
    uyaran = [zeros(length(uyaran),1) uyaran];
end

end

function out_data = window_adsr(data, orneklem_sayisi, window_ms)
%% default degerler, hata ayiklama kismi

if nargin < 2
    % orneklem hizi (Hz)
    orneklem_sayisi = 44100;
end

if nargin < 3
    % ses bozunum suresi
    window_ms = 10;
end

if nargin < 1
    % hata yonetimi
    disp('Hata: Gecersiz girdi');
    return;
end

%% ======================================
if size(data, 1) < size(data, 2)
    n_ch = size(data, 1);
    dat_len = size(data, 2);
    out_data = data.';
else
    n_ch = size(data, 2);
    dat_len = size(data, 1);
    out_data = data;
end

if n_ch > 2
    disp('Uyari: desteklenmeyen veri')
end

win_len = round(window_ms / 1000 * orneklem_sayisi);
hann_win = ( 1 - cos(linspace(0, 2*pi, 2*win_len).') )/2;

%% =====================================
for ch = 1:n_ch
    onset_win = hann_win(1:win_len);
    out_data(1:win_len, ch) = out_data(1:win_len, ch) .* onset_win;
    start_indx = dat_len - win_len + 1;
    offset_win = hann_win(win_len+1:end);
    out_data(start_indx:dat_len, ch) = out_data(start_indx:dat_len, ch) .* offset_win;
end

end



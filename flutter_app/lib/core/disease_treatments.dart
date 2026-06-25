// Tedavi önerileri veri tabanı.
// Her giriş modelin döndürdüğü rawLabel ile eşleşir.
// Domates leke grubu (Bacterial_spot / Early_blight / Target_Spot /
// Septoria_leaf_spot) model tarafından "Tomato___Spot_Disease" olarak
// birleştirildiğinden o anahtar ayrıca dahil edilmiştir.

class TreatmentInfo {
  final String displayName; // Türkçe hastalık adı
  final String description; // 1-2 cümle açıklama
  final List<String> treatments; // Tedavi adımları
  final List<String> prevention; // Önleme yöntemleri
  final String severity; // 'healthy' | 'low' | 'medium' | 'high'

  const TreatmentInfo({
    required this.displayName,
    required this.description,
    required this.treatments,
    required this.prevention,
    required this.severity,
  });
}

class DiseaseTreatments {
  DiseaseTreatments._();

  /// [rawLabel] modelin döndürdüğü ham etiket (ör. "Apple___Apple_scab").
  /// Eşleşme bulunamazsa null döner.
  static TreatmentInfo? forLabel(String rawLabel) =>
      _data[rawLabel];

  // ─── Veri ─────────────────────────────────────────────────────────────────

  static const Map<String, TreatmentInfo> _data = {

    // ── ELMA ────────────────────────────────────────────────────────────────
    'Apple___Apple_scab': TreatmentInfo(
      displayName: 'Elma Karaleke (Apple Scab)',
      description:
          'Venturia inaequalis mantarının neden olduğu, yaprak ve meyvelerde '
          'koyu, kadifemsi lekeler bırakan fungal bir hastalıktır.',
      severity: 'medium',
      treatments: [
        'Erken dönemde captan veya mankozeb içerikli fungisit uygulayın.',
        'Myclobutanil veya trifloxystrobin içerikli sistemik fungisitler de etkilidir.',
        'Hastalıklı yaprak ve meyveleri toplayıp imha edin.',
        'Belirtiler görüldüğünde 7-10 günde bir ilaçlamayı tekrarlayın.',
      ],
      prevention: [
        'Düşen yaprakları bahçeden uzaklaştırın (kışlayan sporları yok eder).',
        'Taç içine hava sirkülasyonunu artırmak için budama yapın.',
        'Dirençli elma çeşitlerini tercih edin.',
        'Sulama suyunun yapraklara değmesinden kaçının.',
      ],
    ),

    'Apple___Black_rot': TreatmentInfo(
      displayName: 'Elma Kara Çürüklük (Black Rot)',
      description:
          'Botryosphaeria obtusa mantarından kaynaklanan; meyvelerde kara çürüklük, '
          'dallarda kanser yarası oluşturan bir hastalıktır.',
      severity: 'high',
      treatments: [
        'Enfekteli dal ve meyveleri hemen budayıp imha edin.',
        'Captan veya thiophanate-methyl içerikli fungisit uygulayın.',
        'Kanser lezyonlarını temiz bir bıçakla kazıyın, yarayı bakırlı macunla kapatın.',
        'Hasat sonrası kalan meyve ve dalları bahçeden temizleyin.',
      ],
      prevention: [
        'Ölü dal ve mümifiye meyveleri düzenli olarak kaldırın.',
        'Budama aletlerini %10 çamaşır suyu ile dezenfekte edin.',
        'Ağaç gövdesindeki yaraları fungisitli macunla koruyun.',
        'Yeterli gübre ve sulama ile bitkinin direncini artırın.',
      ],
    ),

    'Apple___Cedar_apple_rust': TreatmentInfo(
      displayName: 'Elma-Sedir Pası (Cedar Apple Rust)',
      description:
          'Gymnosporangium juniperi-virginianae mantarı; elma ve sedir/ardıç '
          'ağaçları arasında döngü yapan iki ev sahipli bir pas hastalığıdır.',
      severity: 'medium',
      treatments: [
        'Myclobutanil veya propiconazole içerikli fungisit kullanın.',
        'Tomurcuk patlamasından itibaren 10-14 günde bir ilaçlama yapın.',
        'Yakın çevredeki sedir/ardıç ağaçlarındaki portakal renkli galları kesin.',
        'Şiddetli enfeksiyonda yaprakları toplayıp imha edin.',
      ],
      prevention: [
        'Mümkünse 300 metrede sedir veya ardıç bulundurmayın.',
        'Pasa dayanıklı elma çeşitleri dikin.',
        'Bahar yağmurları öncesi önleyici fungisit uygulayın.',
      ],
    ),

    'Apple___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Elma',
      description: 'Yaprak hastalık belirtisi taşımıyor. Bitkinin sağlığını '
          'korumak için rutin bakımı sürdürün.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Düzenli budama ile taç içi hava sirkülasyonunu sağlayın.',
        'İhtiyaca göre dengeli NPK gübrelemesi yapın.',
        'Yapraklara değmeden toprak seviyesinde sulayın.',
        'Düşen yaprak ve meyveleri bahçeden kaldırın.',
      ],
    ),

    // ── KİRAZ ───────────────────────────────────────────────────────────────
    'Cherry_(including_sour)___Powdery_mildew': TreatmentInfo(
      displayName: 'Kiraz Un Küfü (Powdery Mildew)',
      description:
          'Podosphaera clandestina mantarının neden olduğu; genç yaprak ve '
          'sürgünlerde beyaz pudra görünümlü örtü oluşturan hastalıktır.',
      severity: 'medium',
      treatments: [
        'Potasyum bikarbonat veya kükürt bazlı fungisit uygulayın.',
        'Neem yağı erken aşamada etkili bir organik seçenektir.',
        'Myclobutanil içerikli sistemik fungisitler ilerlemiş enfeksiyonda kullanılabilir.',
        'Ağır enfekte sürgünleri keserek imha edin.',
      ],
      prevention: [
        'Budama ile gölgelenmeyi ve nem tutmayı azaltın.',
        'Azot gübrelemesini aşırıya kaçırmayın (aşırı büyüme hastalığa davetiye çıkarır).',
        'Sabah sulayın; akşam sulama yaprak yüzeyini uzun süre ıslak tutar.',
        'Dirençli çeşit kullanmayı değerlendirin.',
      ],
    ),

    'Cherry_(including_sour)___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Kiraz',
      description: 'Yaprak hastalık belirtisi taşımıyor. Rutin bakımla sağlığı koruyun.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Yıllık budama ile taç içine ışık ve hava sağlayın.',
        'Derin ama seyrek sulama tercih edin.',
        'Bahardaki don riskine karşı küçük ağaçları koruyun.',
        'Düşen yaprak ve meyveleri kaldırın.',
      ],
    ),

    // ── MISIR ───────────────────────────────────────────────────────────────
    'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot': TreatmentInfo(
      displayName: 'Mısır Cercospora Yaprak Lekesi (Gray Leaf Spot)',
      description:
          'Cercospora zeae-maydis mantarının neden olduğu; dikdörtgen şekilli, '
          'gri-kahve renkli şerit lekeleri yaprakta oluşturan fungal hastalık.',
      severity: 'medium',
      treatments: [
        'Propiconazole, azoxystrobin veya trifloxystrobin+propiconazole karışımı fungisit uygulayın.',
        'Belirtiler erken görüldüğünde tepelenme döneminde ilaçlama yapın.',
        'Ağır enfekte yaprakları uzaklaştırın.',
      ],
      prevention: [
        'Dönüşümlü ekim yapın; mısırı aynı tarlaya üst üste ekmekten kaçının.',
        'Hasattan sonra sapları parçalayıp toprağa gömün.',
        'Cercospora\'ya dayanıklı mısır çeşitleri kullanın.',
        'Fazla azot gübrelemesinden kaçının.',
      ],
    ),

    'Corn_(maize)___Common_rust_': TreatmentInfo(
      displayName: 'Mısır Ortak Pası (Common Rust)',
      description:
          'Puccinia sorghi mantarından kaynaklanan; yapraklarda oval, kırmızı-kahve '
          'renkli uredini pustülleri oluşturan hastalık.',
      severity: 'medium',
      treatments: [
        'Tepelenme öncesi mancozeb veya azoxystrobin içerikli fungisit uygulayın.',
        'Erken aşama enfeksiyonlarda kükürt bazlı ilaçlar kullanılabilir.',
        'Enfekte yaprakları toplayıp imha edin.',
      ],
      prevention: [
        'Pasa dayanıklı mısır çeşitleri tercih edin.',
        'Yeterli bitki aralığı ile hava sirkülasyonunu sağlayın.',
        'Yüksek nem döneminde önleyici ilaçlama yapın.',
        'Dönüşümlü ekim uygulayın.',
      ],
    ),

    'Corn_(maize)___Northern_Leaf_Blight': TreatmentInfo(
      displayName: 'Mısır Kuzey Yaprak Yanıklığı (Northern Leaf Blight)',
      description:
          'Exserohilum turcicum mantarının neden olduğu; uzun, puro şekilli, '
          'gri-yeşil lezyonlar oluşturan önemli mısır hastalığı.',
      severity: 'high',
      treatments: [
        'Propiconazole veya mancozeb içerikli fungisit püskürtün.',
        'İlaçlamayı tepelenme öncesinde veya erken belirtilerde yapın.',
        'Şiddetli enfeksiyonda 14 günde bir tekrarlayın.',
      ],
      prevention: [
        'Dirençli mısır çeşitleri yetiştirin.',
        'Hasattan sonra mısır artıklarını toprağa gömün veya yakın.',
        'Dönüşümlü ekim ile hastalık baskısını kırın.',
        'Sulama suyunun yapraklara değmesinden kaçının.',
      ],
    ),

    'Corn_(maize)___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Mısır',
      description: 'Yaprak hastalık belirtisi taşımıyor. İyi tarım uygulamalarını sürdürün.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Dengeli NPK gübrelemesi yapın.',
        'Yeterli bitki aralığı ile hava sirkülasyonu sağlayın.',
        'Sulama suyunu toprak seviyesinden verin.',
        'Hasattan sonra tarla artıklarını temizleyin.',
      ],
    ),

    // ── ASMA ────────────────────────────────────────────────────────────────
    'Grape___Black_rot': TreatmentInfo(
      displayName: 'Asma Kara Çürüklük (Black Rot)',
      description:
          'Guignardia bidwellii mantarından kaynaklanan; meyveleri siyah '
          'buruşuk "mümiye"ye dönüştüren yıkıcı fungal hastalık.',
      severity: 'high',
      treatments: [
        'Myclobutanil, captan veya mancozeb içerikli fungisit uygulayın.',
        'Tomurcuk patlamasından meyve olgunlaşmasına dek 10-14 günde bir ilaçlayın.',
        'Tüm mümifiye meyveleri asmadan ve yerden toplayıp imha edin.',
        'Enfekteli sürgün ve yaprakları budayın.',
      ],
      prevention: [
        'Kış budamasında hastalıklı kısımları temizleyin.',
        'Asmanın iyi havalanması için terbiye sistemini düzenleyin.',
        'Yapraklara değen sulama sistemlerinden kaçının.',
        'Düşen yaprakları bahçeden uzaklaştırın.',
      ],
    ),

    'Grape___Esca_(Black_Measles)': TreatmentInfo(
      displayName: 'Asma Esca / Kara Kızamık (Esca)',
      description:
          'Birden fazla fungal etmenin (Phaeomoniella, Phaeoacremonium vb.) '
          'neden olduğu; odun dokusunu çürüten karmaşık bir asma hastalığı.',
      severity: 'high',
      treatments: [
        'Kimyasal tedavisi bulunmamaktadır; ağır hastalıklı omcaları sökün.',
        'Ölü ve enfekte odun dokusunu derin budayarak temizleyin.',
        'Budama yaralarını fungisitli macun veya thiophanate-methyl ile derhal kapatın.',
        'Hafif belirtili omcalarda yaprak ve meyve yükünü azaltın.',
      ],
      prevention: [
        'Budama aletlerini kullanımlar arasında %70 alkol veya sodyum hipoklorit ile steril edin.',
        'Budama yaralanmalarını en aza indirin, yavaş kapanan büyük yüzeyleri macunlayın.',
        'Esca stresini artıran aşırı kuraklık ve dondan koruyun.',
        'Yeni dikimde sertifikalı, hastalıksız fidan kullanın.',
      ],
    ),

    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)': TreatmentInfo(
      displayName: 'Asma Yaprak Yanıklığı (Isariopsis Leaf Spot)',
      description:
          'Pseudocercospora vitis mantarının neden olduğu; yaprak üstünde '
          'koyu kenarlı kahve lekeler oluşturan fungal hastalık.',
      severity: 'medium',
      treatments: [
        'Bakır oksiklorür veya captan içerikli fungisit uygulayın.',
        'Belirtiler görüldüğünde 7-10 günde bir tekrarlayın.',
        'Ağır enfekte yaprakları keserek yakın.',
      ],
      prevention: [
        'Bağda yeterli hava sirkülasyonu için yaprak seyreltmesi yapın.',
        'Alttan sulama tercih edin.',
        'Sonbaharda düşen yaprakları toplayın.',
        'Bakır içerikli kış ilaçlaması (uyurgezer dönemi) koruyucu etki sağlar.',
      ],
    ),

    'Grape___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Asma',
      description: 'Yaprak hastalık belirtisi taşımıyor. Koruyucu bakımı sürdürün.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Kış budamasını zamanında yapın ve yaraları macunlayın.',
        'Yazın yaprak seyreltmesiyle hava sirkülasyonu sağlayın.',
        'Damla veya yüzey sulama tercih edin.',
        'Hasat sonrası bağ artıklarını temizleyin.',
      ],
    ),

    // ── ŞEFTALI ─────────────────────────────────────────────────────────────
    'Peach___Bacterial_spot': TreatmentInfo(
      displayName: 'Şeftali Bakteriyel Leke (Bacterial Spot)',
      description:
          'Xanthomonas arboricola pv. pruni bakterisinin neden olduğu; '
          'yaprak, dal ve meyvelerde su emmiş lekeler, delikler ve çatlaklar oluşturan hastalık.',
      severity: 'medium',
      treatments: [
        'Bakır bazlı bakterisit (bakır hidroksit, bakır oksiklorür) uygulayın.',
        'Oxytetracycline içerikli antibiyotik spreyler bazı bölgelerde kullanılabilir.',
        'Enfekte dal ve yaprakları keserek imha edin.',
        '10-14 günde bir ilaçlamayı tekrarlayın.',
      ],
      prevention: [
        'Bakteriyel lekeye dayanıklı şeftali çeşitleri seçin.',
        'Yağmur suyu ve sulama suyunun yapraklara çarpmasını azaltın.',
        'Budama aletlerini dezenfekte edin.',
        'Rüzgar perdeleri kurarak yaralanmayı azaltın.',
      ],
    ),

    'Peach___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Şeftali',
      description: 'Yaprak hastalık belirtisi taşımıyor. Rutin bakımla sağlığı koruyun.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Yıllık budama ile sıkışık taç yapısını açın.',
        'Kış sonunda bakırlı uyurgezer ilaçlaması yapın.',
        'Hastalık baskısı yüksek dönemlerde yapraklara su değdirmeyin.',
        'Gübre ve sulamayı dengeli tutun.',
      ],
    ),

    // ── BİBER ───────────────────────────────────────────────────────────────
    'Pepper,_bell___Bacterial_spot': TreatmentInfo(
      displayName: 'Biber Bakteriyel Leke (Bacterial Spot)',
      description:
          'Xanthomonas euvesicatoria\'nın neden olduğu; yaprakta su emmiş, '
          'sarı halkalı lekeler ve erken yaprak dökümü oluşturan bakteri hastalığı.',
      severity: 'medium',
      treatments: [
        'Bakır hidroksit veya bakır oktanoat içerikli bakterisit uygulayın.',
        'Bakır + mancozeb kombinasyonu etkinliği artırır.',
        'Enfekte bitki artıklarını hemen uzaklaştırın.',
        'İlaçlamayı 7 günde bir yağmur sonrasında tekrarlayın.',
      ],
      prevention: [
        'Sertifikalı, hastalıksız tohum kullanın.',
        'Yukarıdan sulama yerine damla sulama tercih edin.',
        'En az 2 yıllık ekim nöbeti yapın (domates/patlıcan/biber sırası kırmak).',
        'Fideler için temiz toprak ve tepsi kullanın.',
      ],
    ),

    'Pepper,_bell___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Biber',
      description: 'Yaprak hastalık belirtisi taşımıyor. Kültürel bakımı sürdürün.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Meyve yükü ağır dallara destek verin.',
        'Sabah saatlerinde sulayın; akşam yapraklarda nem kalmasın.',
        'Azot gübrelemesini aşırıya kaçırmayın.',
        'Böcek zararlılarını kontrol altında tutun (virüs vektörlerine dikkat).',
      ],
    ),

    // ── PATATES ─────────────────────────────────────────────────────────────
    'Potato___Early_blight': TreatmentInfo(
      displayName: 'Patates Erken Yanıklık (Early Blight)',
      description:
          'Alternaria solani mantarının neden olduğu; yapraklarda hedef tahtası '
          'görünümlü (halkalı) kahve-siyah lekeler bırakan fungal hastalık.',
      severity: 'medium',
      treatments: [
        'Chlorothalonil, mancozeb veya azoxystrobin içerikli fungisit uygulayın.',
        'Belirtiler görüldüğünde 7-10 günde bir ilaçlamayı tekrarlayın.',
        'Ağır enfekte alt yaprakları temizleyin.',
        'Toprağa kalsiyum ve magnezyum takviyesi yapın (besin eksikliği hastalığı kolaylaştırır).',
      ],
      prevention: [
        'Sertifikalı, yumru hastalıklarından arınmış tohum yumru kullanın.',
        'Ekim nöbeti uygulayın (3-4 yıl).',
        'Taç içinde hava dolaşımı sağlayacak yeterli bitki aralığı bırakın.',
        'Alttan sulama yapın; yaprakları ıslak tutmayın.',
      ],
    ),

    'Potato___Late_blight': TreatmentInfo(
      displayName: 'Patates Geç Yanıklık (Late Blight)',
      description:
          'Phytophthora infestans\'ın neden olduğu; yaprak, sap ve yumrularda '
          'ilerleyici çürümelere yol açan yıkıcı bir su küfü hastalığı.',
      severity: 'high',
      treatments: [
        'Metalaxyl-M (mefenoxam) içerikli fungisitleri hemen uygulayın.',
        'Chlorothalonil veya bakır bazlı önleyici ilaçlar da kullanılabilir.',
        'Ağır enfekte bitkileri kökten söküp uzaklaştırın; kompostlamayın.',
        'Yumru hasadını erken yapın, enfekte bitkilerle temas ettirmeyin.',
      ],
      prevention: [
        'Sertifikalı tohum yumru kullanın.',
        'Yüksek riskli dönemlerde (serin ve yağışlı hava) önleyici ilaçlamaya başlayın.',
        'Bitkilerin tepesine su değdirmeyin.',
        'Dayanıklı çeşitler tercih edin.',
        'Eski yumruları tarlada bırakmayın.',
      ],
    ),

    'Potato___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Patates',
      description: 'Yaprak hastalık belirtisi taşımıyor. İyi tarım uygulamalarını sürdürün.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Ekim nöbeti uygulayın.',
        'Havadar ve iyi drene olan toprak tercih edin.',
        'Aşırı azot gübrelemesinden kaçının.',
        'Colorado böceği gibi zararlıları düzenli kontrol edin.',
      ],
    ),

    // ── ÇİLEK ───────────────────────────────────────────────────────────────
    'Strawberry___Leaf_scorch': TreatmentInfo(
      displayName: 'Çilek Yaprak Yanıklığı (Leaf Scorch)',
      description:
          'Diplocarpon earlianum mantarının neden olduğu; yaprak üstünde mor '
          'kenarlı küçük lekeler bırakan ve ağır enfeksiyonda yaprak kenarlarını '
          'kavurmuş görünüme getiren fungal hastalık.',
      severity: 'medium',
      treatments: [
        'Captan veya myclobutanil içerikli fungisit uygulayın.',
        'Enfekte yaprakları dikkatli şekilde toplayıp imha edin.',
        '10-14 günde bir ilaçlamayı tekrarlayın.',
        'Gerekirse azoxystrobin içerikli sistemik fungisit deneyin.',
      ],
      prevention: [
        'Dayanıklı çilek çeşitleri tercih edin.',
        'Yapraklara değen sulama sistemlerinden kaçının.',
        'Çilek yatağında nem tutan yabancı otu temizleyin.',
        'Her yıl yenileme dikimi ile eski ve enfekte bitkileri değiştirin.',
      ],
    ),

    'Strawberry___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Çilek',
      description: 'Yaprak hastalık belirtisi taşımıyor. Rutin bakımla sağlığı koruyun.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Damla sulama veya siper sulama kullanın; yaprakları ıslak bırakmayın.',
        'Yatağın havasını açık tutmak için gereksiz yaprakları temizleyin.',
        '2-3 yılda bir yenileme dikimi yapın.',
        'Mulen veya saman malç ile nem dengesini koruyun.',
      ],
    ),

    // ── DOMATES ─────────────────────────────────────────────────────────────
    // Model bu dört hastalığı "Tomato___Spot_Disease" altında birleştirir.
    'Tomato___Spot_Disease': TreatmentInfo(
      displayName: 'Domates Leke Hastalığı (Spot Disease)',
      description:
          'Bacterial_spot, Early_blight, Target_Spot ve Septoria_leaf_spot '
          'hastalıklarının görsel olarak çok benzediğinden birleştirilen grubu. '
          'Bakteri veya mantar kaynaklı olup yaprakta çeşitli leke örüntüleri oluşturur.',
      severity: 'medium',
      treatments: [
        'Bakır bazlı fungisit/bakterisit (bakır hidroksit) uygulayın; hem bakteri hem mantara karşı etkilidir.',
        'Chlorothalonil veya mancozeb mantar kökenli lekelerde etkilidir.',
        'Enfekte yaprakları keserek imha edin.',
        '7-10 günde bir ilaçlamayı yağış sonrasında tekrarlayın.',
        'Belirtiler ağırlaşıyorsa mutlaka uzman tanısı (PCR veya laboratuvar) yaptırın.',
      ],
      prevention: [
        'Sertifikalı, hastalıksız tohum ve fide kullanın.',
        'Damla sulama tercih edin; yaprakları ıslak bırakmayın.',
        'Ekim nöbeti uygulayın (2-3 yıl).',
        'Yoğun dikim yapmayın; yeterli hava sirkülasyonu sağlayın.',
        'Budama aletlerini dezenfekte edin.',
      ],
    ),

    'Tomato___Late_blight': TreatmentInfo(
      displayName: 'Domates Geç Yanıklık (Late Blight)',
      description:
          'Phytophthora infestans\'ın neden olduğu; yaprak, sap ve meyvelerde '
          'hızla yayılan su emmiş koyu kahve lezyonlar oluşturan yıkıcı hastalık.',
      severity: 'high',
      treatments: [
        'Metalaxyl-M (mefenoxam) veya cymoxanil içerikli fungisit hemen uygulayın.',
        'Bakır oksiklorür de önleyici ve tedavi edici olarak kullanılabilir.',
        'Ağır enfekte bitkileri çıkarıp toprağa gömün veya yakın.',
        'İlaçlamayı 5-7 günde bir serin ve yağışlı havalarda tekrarlayın.',
      ],
      prevention: [
        'Sertifikalı fide ve tohum kullanın.',
        'Tarlada eski domates veya patates artığı bırakmayın.',
        'Yapraklara değen sulama sistemlerinden kaçının.',
        'Yüksek risk döneminde önleyici bakır ilaçlaması yapın.',
      ],
    ),

    'Tomato___Leaf_Mold': TreatmentInfo(
      displayName: 'Domates Yaprak Küfü (Leaf Mold)',
      description:
          'Passalora fulva mantarının neden olduğu; yaprak altında zeytin yeşili-kahve '
          'kadifemsi küf örtüsü ile üstte sararma oluşturan örtü altı hastalığı.',
      severity: 'medium',
      treatments: [
        'Bakır bazlı veya chlorothalonil içerikli fungisit uygulayın.',
        'Trifloxystrobin veya azoxystrobin içerikli sistemik fungisitler etkilidir.',
        'Ağır enfekte yaprakları temizleyin.',
        'Seradadaki nemi %85\'in altında tutun.',
      ],
      prevention: [
        'Sera havalandırmasını artırın; aşırı nem hastalığın temel nedenidir.',
        'Damla sulama kullanın.',
        'Bitkiler arasında yeterli mesafe bırakın.',
        'Yaprak küfüne dayanıklı domates çeşitleri kullanın.',
      ],
    ),

    'Tomato___Spider_mites Two-spotted_spider_mite': TreatmentInfo(
      displayName: 'Domates Kırmızı Örümcek Akarı (Spider Mites)',
      description:
          'Tetranychus urticae\'nin neden olduğu; yaprak altında ince ağlar örerek '
          'özsu emen, yaprağa sarı-bronz noktalama görünümü veren zararlı.',
      severity: 'medium',
      treatments: [
        'Abamectin, bifenazate veya etoxazole içerikli akarisit uygulayın.',
        'Bitkiler üzerine güçlü su sıkarak akar koloni yoğunluğunu düşürün.',
        'Neem yağı veya bitkisel sabun organik bir seçenektir.',
        'Şiddetli enfeksiyonda farklı etki mekanizmalı iki akarisiti dönüşümlü kullanın.',
      ],
      prevention: [
        'Kuru ve sıcak koşullar akar popülasyonunu hızla artırır; düzenli sulama yapın.',
        'Phytoseiidae familyasından doğal düşmanları (yırtıcı akar) koruyun.',
        'Toz ve kuru koşulların birikmesini önleyin.',
        'Erken dönem kolonileri fark etmek için yaprak altını düzenli kontrol edin.',
      ],
    ),

    'Tomato___Tomato_Yellow_Leaf_Curl_Virus': TreatmentInfo(
      displayName: 'Domates Sarı Yaprak Kıvırcıklık Virüsü (TYLCV)',
      description:
          'Bemisia tabaci (beyazsinek) tarafından taşınan; genç yapraklarda '
          'sararma ve kıvırcıklık, meyve tutumunda ciddi kayıp oluşturan virüs.',
      severity: 'high',
      treatments: [
        'Virüs için doğrudan kimyasal tedavi yoktur; enfekte bitkiler mümkün olduğunca erken sökülüp imha edilmelidir.',
        'Beyazsinekle mücadele için imidacloprid, thiamethoxam veya pyriproxyfen kullanın.',
        'Sarı yapışkan tuzak kurarak beyazsinek popülasyonunu izleyin.',
        'Bitkileri reflektif malç ile kaplayın (beyazsineği uzak tutar).',
      ],
      prevention: [
        'TYLCV\'ye dayanıklı domates çeşitleri kullanın.',
        'Fide aşamasında beyazsinekle mücadeleye başlayın.',
        'Tarlaya giriş noktalarına böcek ağı (50-mesh) gerili tünel/sera kurun.',
        'Yabancı otların beyazsineğe konakçılık etmesini önlemek için yabancı otu kontrol altında tutun.',
      ],
    ),

    'Tomato___Tomato_mosaic_virus': TreatmentInfo(
      displayName: 'Domates Mozaik Virüsü (ToMV)',
      description:
          'Mekanik yolla (kontamine aletler, el teması) ve yaprak bitleriyle '
          'yayılan; yapraklarda mozaik renk değişimi ile bitki gelişimini '
          'duraksatan virüs hastalığı.',
      severity: 'high',
      treatments: [
        'Virüs için doğrudan kimyasal tedavi bulunmamaktadır.',
        'Enfekte bitkileri derhal sökün ve imha edin; kompostlamayın.',
        'Tarlada çalışırken elleri ve aletleri %10 sodyum fosfat veya %3 sodyum hipoklorit ile sterilize edin.',
        'Sigara içmeden önce elleri yıkayın (tütün mozaik virüsüyle çapraz enfeksiyon riski).',
      ],
      prevention: [
        'Sertifikalı, hastalıksız tohum ve fide kullanın.',
        'ToMV\'ye dayanıklı çeşit tercih edin.',
        'Tarla giriş-çıkışında ayakkabı dezenfeksiyonu uygulayın.',
        'Yaprak bitleriyle mücadele edin (vektör kontrolü).',
        'Tütün kullanan çalışanlar için özel hijyen protokolü oluşturun.',
      ],
    ),

    'Tomato___healthy': TreatmentInfo(
      displayName: 'Sağlıklı Domates',
      description: 'Yaprak hastalık belirtisi taşımıyor. Koruyucu kültürel önlemleri sürdürün.',
      severity: 'healthy',
      treatments: [],
      prevention: [
        'Bitkileri düzenli olarak destekleyin ve aşırı yüklenmeden koruyun.',
        'Damla sulama tercih edin; yaprakları ıslak bırakmayın.',
        'Azot gübrelemesini dengeli tutun.',
        'Zararlı ve hastalık belirtilerini haftada en az bir kez kontrol edin.',
      ],
    ),
  };
}

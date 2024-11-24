import 'package:get/get.dart';

class Languages extends Translations {
  static bool isRTL(String languageCode) {
    const rtlLanguages = {'ar', 'fa', 'ku', 'tk'};
    return rtlLanguages.contains(languageCode);
  }

  @override
  Map<String, Map<String, String>> get keys => {

    'ar': {
      'login': 'تسجيل الدخول',
      'welcome_back': 'مرحبا بعودتك! نحن سعداء بعودتك مرة أخرى. يرجى إدخال بياناتك لتسجيل الدخول إلى حسابك',
      'phone_number': 'رقم الهاتف',
      'password': 'كلمة المرور',
      'forgot_password': 'هل نسيت كلمة السر؟',
      'no_account': 'ليس لدي حساب، إنشاء حساب الآن',
      'enter': 'الدخول',
      'error': 'خطأ',
      'success': 'نجاح',
      'enter_phone_password': 'يرجى إدخال رقم الهاتف وكلمة المرور',
      'login_success': 'تم تسجيل الدخول بنجاح',
      'login_failed': 'فشل تسجيل الدخول',
      'server_error': 'خطا في معلومات الاتصال  ',
      'unexpected_error': 'حدث خطأ غير متوقع',
      'crowd_medicine': 'طب الحشود',
      'crowd_medicine_desc':
      'تقدم ميزة الرعاية الصحية للزائرين في ذلك خدمات طبية متخصصة تهدف إلى تلبية احتياجات الزوار اثناء رحلتهم',
      'medical_consultation': 'ميزة الاستشارة الطبية',
      'medical_consultation_desc':'تتيح ميزة الاستشارة الطبية للزائرين التواصل مع الأطباء عن بعد للحصول على نصائح صحية و استشارات متخصصة في مختلف المجالات الطبية',
      'medical_centers': 'المراكز الطبية و المستشفيات القريبة',
      'medical_centers_desc':
      'التعرف على أقرب المراكز الصحية عبر خريطة تفاعلية مع معلومات تفصيلية حول الخدمات المقدمة وأرقام التواصل',
      'skip': 'تخطي',
      'next': 'التالي',
      'start_now': 'ابدأ الآن',
      'language': 'العربية',
      'new_registration': 'تسجيل جديد',
      'create_account_easily': 'أنشئ حسابك بسهولة من خلال ملء بياناتك الكاملة',
      'personal_info': 'المعلومات الشخصية',
      'contact_info': 'معلومات الحساب',
      'medical_info': 'المعلومات الطبية',
      'emergency_contact': 'جهة الاتصال في حالات الطوارئ',
      'finish': 'إنهاء',
      'fill_required_fields': 'يرجى ملء جميع الحقول المطلوبة',
      'registration_success': 'تم التسجيل بنجاح',
      'username': 'اسم المستخدم',
      'email': 'البريد الإلكتروني',
      'enter_password': 'أدخل كلمة المرور',
      'invalid_phone': 'رقم هاتف غير صالح',
      'first_name': 'الاسم الأول',
      'middle_name': 'اسم الأب',
      'last_name': 'اللقب',
      'choose_country': 'اختر الدولة',
      'country': 'الدولة',
      'province': 'المحافظة',
      'district': 'القضاء',
      'alley': 'المحلة',
      'house': 'رقم الدار',
      'countries_error': 'خطأ في تحميل قائمة الدول',
      'birth_date': 'تاريخ الميلاد',
      'day': 'اليوم',
      'month': 'الشهر',
      'year': 'السنة',
      'gender': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'other_country': 'أخرى',
      'iraq': 'العراق',
      'blood_type': 'فصيلة الدم',
      'allergies': 'الحساسية',
      'chronic_diseases': 'الأمراض المزمنة',
      'emergencyContactPage.fullName': 'الاسم الكامل',
      'emergencyContactPage.selectCountry': 'اختر البلد',
      'emergencyContactPage.country': 'البلد',
      'emergencyContactPage.province': 'المحافظة',
      'emergencyContactPage.district': 'القضاء',
      'emergencyContactPage.alley': 'المحلة',
      'emergencyContactPage.house': 'رقم الدار',
      'emergencyContactPage.relationship': 'صلة القرابة',
      'emergencyContactPage.phoneNumber': 'رقم الهاتف',
      'emergencyContactPage.iraq': 'العراق',
      'emergencyContactPage.other_country': 'دولة أخرى',
      'emergencyContactPage.father': 'الأب',
      'emergencyContactPage.mother': 'الأم',
      'emergencyContactPage.brother': 'الأخ',
      'emergencyContactPage.sister': 'الأخت',
      'emergencyContactPage.son': 'الابن',
      'emergencyContactPage.daughter': 'البنت',
      'emergencyContactPage.husband': 'الزوج',
      'emergencyContactPage.wife': 'الزوجة',
      'emergencyContactPage.other': 'أخرى',
      'emergencyContactPage.countriesError': 'خطأ في تحميل قائمة الدول',
      'emergencyContactPage.noCountries': 'لا توجد دول متاحة',
      'diagnosis_notes': 'التشخيص\nوالملاحظات',
      'medications_list': 'AMPICILLIN\nAMPHOTERICIN\nAMPICILLIN',
      'my_medications': 'الأدوية المصروفة لي',
    },

    'fa': {
      'crowd_medicine': 'پزشکی جمعیت',
      'crowd_medicine_desc':
      'ارائه خدمات مراقبت های بهداشتی به زائران شامل خدمات پزشکی تخصصی برای رفع نیازهای زائران در طول سفر آنها',
      'medical_consultation': 'ویژگی مشاوره پزشکی',
      'medical_consultation_desc':
      'امکان ارتباط از راه دور با پزشکان برای دریافت توصیه های بهداشتی و مشاوره تخصصی در زمینه های مختلف پزشکی',
      'medical_centers': 'مراکز پزشکی و بیمارستان های نزدیک',
      'medical_centers_desc':
      'شناسایی نزدیکترین مراکز بهداشتی از طریق نقشه تعاملی با اطلاعات دقیق در مورد خدمات ارائه شده و شماره های تماس',
      'skip': 'رد کردن',
      'next': 'بعدی',
      'start_now': 'شروع کنید',
      'language': 'فارسی',
      'login': 'ورود به سیستم',
      'welcome_back': 'خوش آمدید! از دیدن مجدد شما خوشحالیم. لطفاً برای ورود به حساب کاربری خود، اطلاعات خود را وارد کنید',
      'phone_number': 'شماره تلفن',
      'password': 'رمز عبور',
      'forgot_password': 'رمز عبور را فراموش کرده‌اید؟',
      'no_account': 'حساب کاربری ندارید؟ همین حالا ثبت نام کنید',
      'enter': 'ورود',
      'error': 'خطا',
      'success': 'موفقیت',
      'enter_phone_password': 'لطفاً شماره تلفن و رمز عبور را وارد کنید',
      'login_success': 'ورود با موفقیت انجام شد',
      'login_failed': 'ورود ناموفق بود',
      'server_error': 'اتصال به سرور ناموفق بود',
      'unexpected_error': 'خطای غیرمنتظره رخ داد',
      'new_registration': 'ثبت نام جدید',
      'create_account_easily': 'با پر کردن اطلاعات کامل خود به راحتی حساب کاربری خود را ایجاد کنید',
      'personal_info': 'اطلاعات شخصی',
      'contact_info': 'اطلاعات تماس',
      'medical_info': 'اطلاعات پزشکی',
      'emergency_contact': 'تماس اضطراری',
      'finish': 'پایان',
      'fill_required_fields': 'لطفاً تمام فیلدهای ضروری را پر کنید',
      'registration_success': 'ثبت نام با موفقیت انجام شد',
      // Existing translations...
      'username': 'نام کاربری',
      'email': 'ایمیل',
      'enter_password': 'رمز عبور را وارد کنید',
      'invalid_phone': 'شماره تلفن نامعتبر',
      'first_name': 'نام',
      'middle_name': 'نام پدر',
      'last_name': 'نام خانوادگی',
      'choose_country': 'کشور را انتخاب کنید',
      'country': 'کشور',
      'province': 'استان',
      'district': 'شهرستان',
      'alley': 'محله',
      'house': 'شماره خانه',
      'countries_error': 'خطا در بارگیری لیست کشورها',
      'birth_date': 'تاریخ تولد',
      'day': 'روز',
      'month': 'ماه',
      'year': 'سال',
      'gender': 'جنسیت',
      'male': 'مرد',
      'female': 'زن',
      'other_country': 'دیگر',
      'iraq': 'عراق',
      'blood_type': 'گروه خونی',
      'allergies': 'حساسیت‌ها',
      'chronic_diseases': 'بیماری‌های مزمن',
      'emergencyContactPage.fullName': 'نام کامل',
      'emergencyContactPage.selectCountry': 'کشور را انتخاب کنید',
      'emergencyContactPage.country': 'کشور',
      'emergencyContactPage.province': 'استان',
      'emergencyContactPage.district': 'شهرستان',
      'emergencyContactPage.alley': 'محله',
      'emergencyContactPage.house': 'شماره خانه',
      'emergencyContactPage.relationship': 'نسبت',
      'emergencyContactPage.phoneNumber': 'شماره تلفن',
      'emergencyContactPage.iraq': 'عراق',
      'emergencyContactPage.other_country': 'کشور دیگر',
      'emergencyContactPage.father': 'پدر',
      'emergencyContactPage.mother': 'مادر',
      'emergencyContactPage.brother': 'برادر',
      'emergencyContactPage.sister': 'خواهر',
      'emergencyContactPage.son': 'پسر',
      'emergencyContactPage.daughter': 'دختر',
      'emergencyContactPage.husband': 'شوهر',
      'emergencyContactPage.wife': 'همسر',
      'emergencyContactPage.other': 'دیگر',
      'emergencyContactPage.countriesError': 'خطا در بارگیری لیست کشورها',
      'emergencyContactPage.noCountries': 'هیچ کشوری در دسترس نیست',
      'diagnosis_notes': 'تشخیص\nو یادداشت‌ها',
      'medications_list': 'AMPICILLIN\nAMPHOTERICIN\nAMPICILLIN',
      'my_medications': 'داروهای من',
    },
    'ku': {
      // كوردي
      'crowd_medicine': 'پزیشکی جەماوەر',
      'crowd_medicine_desc':
      'دابینکردنی خزمەتگوزاری تەندروستی بۆ سەردانکەران لەوانە خزمەتگوزاری پزیشکی تایبەت بۆ پڕکردنەوەی پێداویستیەکانی سەردانکەران لە کاتی گەشتەکەیاندا',
      'medical_consultation': 'تایبەتمەندی ڕاوێژکاری پزیشکی',
      'medical_consultation_desc':
      'ڕێگە دەدات بە سەردانکەران پەیوەندی بکەن لەگەڵ پزیشکان لە دوورەوە بۆ وەرگرتنی ئامۆژگاری تەندروستی و ڕاوێژی پسپۆڕی لە بوارە جیاوازەکانی پزیشکیدا',
      'medical_centers': 'نزیکترین ناوەندە پزیشکی و نەخۆشخانەکان',
      'medical_centers_desc':
      'ناسینەوەی نزیکترین ناوەندی تەندروستی لە ڕێگەی نەخشەی کارلێکەرەوە لەگەڵ زانیاری وردەکاری دەربارەی خزمەتگوزاریە پێشکەشکراوەکان و ژمارەکانی پەیوەندیکردن',
      'skip': 'تێپەڕاندن',
      'next': 'دواتر',
      'start_now': 'دەست پێ بکە',
      'language': 'كوردي',
      'login': 'چوونە ژوورەوە',
      'welcome_back': 'بەخێربێیتەوە! دڵخۆشین بە بینینەوەت. تکایە زانیاریەکانت بنووسە بۆ چوونە ژوورەوەی هەژمارەکەت',
      'phone_number': 'ژمارەی تەلەفۆن',
      'password': 'وشەی تێپەڕ',
      'forgot_password': 'وشەی تێپەڕت لەبیرکردووە؟',
      'no_account': 'هەژمارت نییە؟ ئێستا دروستی بکە',
      'enter': 'چوونە ژوورەوە',
      'error': 'هەڵە',
      'success': 'سەرکەوتن',
      'enter_phone_password': 'تکایە ژمارەی تەلەفۆن و وشەی تێپەڕ بنووسە',
      'login_success': 'چوونە ژوورەوە سەرکەوتوو بوو',
      'login_failed': 'چوونە ژوورەوە سەرکەوتوو نەبوو',
      'server_error': 'پەیوەندی بە ڕاژەوە سەرکەوتوو نەبوو',
      'unexpected_error': 'هەڵەیەکی چاوەڕواننەکراو ڕوویدا',
      'new_registration': 'تۆمارکردنی نوێ',
      'create_account_easily': 'به‌ئاسانی هه‌ژماره‌که‌ت دروست بکه‌ له‌ڕێگه‌ی پڕکردنه‌وه‌ی زانیارییه‌ته‌واوه‌کانت',
      'personal_info': 'زانیاری کەسی',
      'contact_info': 'زانیاری پەیوەندی',
      'medical_info': 'زانیاری پزیشکی',
      'emergency_contact': 'پەیوەندی کاتی تەنگانە',
      'finish': 'تەواو',
      'fill_required_fields': 'تکایە هەموو خانەکان پڕ بکەوە',
      'registration_success': 'تۆمارکردن سەرکەوتوو بوو',
      // Existing translations...
      'username': 'ناوی بەکارهێنەر',
      'email': 'ئیمەیل',
      'enter_password': 'وشەی نهێنی بنووسە',
      'invalid_phone': 'ژمارەی مۆبایل نادروستە',
      'first_name': 'ناوی یەکەم',
      'middle_name': 'ناوی باوک',
      'last_name': 'ناوی خێزان',
      'choose_country': 'وڵات هەڵبژێرە',
      'country': 'وڵات',
      'province': 'پارێزگا',
      'district': 'قەزا',
      'alley': 'گەڕەک',
      'house': 'ژمارەی خانوو',
      'countries_error': 'هەڵە لە بارکردنی لیستی وڵاتەکان',
      'birth_date': 'بەرواری لەدایکبوون',
      'day': 'ڕۆژ',
      'month': 'مانگ',
      'year': 'ساڵ',
      'gender': 'ڕەگەز',
      'male': 'نێر',
      'female': 'مێ',
      'other_country': 'تر',
      'iraq': 'عێراق',
      'blood_type': 'جۆری خوێن',
      'allergies': 'هەستیاری',
      'chronic_diseases': 'نەخۆشی درێژخایەن',
      'emergencyContactPage.fullName': 'ناوی تەواو',
      'emergencyContactPage.selectCountry': 'وڵات هەڵبژێرە',
      'emergencyContactPage.country': 'وڵات',
      'emergencyContactPage.province': 'پارێزگا',
      'emergencyContactPage.district': 'قەزا',
      'emergencyContactPage.alley': 'گەڕەک',
      'emergencyContactPage.house': 'ژمارەی خانوو',
      'emergencyContactPage.relationship': 'پەیوەندی',
      'emergencyContactPage.phoneNumber': 'ژمارەی تەلەفۆن',
      'emergencyContactPage.iraq': 'عێراق',
      'emergencyContactPage.other_country': 'وڵاتی تر',
      'emergencyContactPage.father': 'باوک',
      'emergencyContactPage.mother': 'دایک',
      'emergencyContactPage.brother': 'برا',
      'emergencyContactPage.sister': 'خوشک',
      'emergencyContactPage.son': 'کوڕ',
      'emergencyContactPage.daughter': 'کچ',
      'emergencyContactPage.husband': 'مێرد',
      'emergencyContactPage.wife': 'ژن',
      'emergencyContactPage.other': 'تر',
      'emergencyContactPage.countriesError': 'هەڵە لە بارکردنی لیستی وڵاتەکان',
      'emergencyContactPage.noCountries': 'هیچ وڵاتێک بەردەست نییە',
      'diagnosis_notes': 'دەستنیشانکردن\nو تێبینیەکان',
      'medications_list': 'AMPICILLIN\nAMPHOTERICIN\nAMPICILLIN',
      'my_medications': 'دەرمانەکانی من',
    },
    'tk': {
      'crowd_medicine': 'كوتله طبي',
      'crowd_medicine_desc':
      'زیارتچیلر اوچون ساغلیق خذمتلری، زیارتچیلرین سیاحتلری اثناسینده احتیاجلرینی قارشیلاماق اوچون اختصاصلی طبی خذمتلر',
      'medical_consultation': 'طبی مشورت اوزللیغی',
      'medical_consultation_desc':
      'زیارتچیلرین مختلف طبی ساحه‌لرده اختصاصلی مشورت و صحی توصیه‌لر آلماق اوچون دوكتورلر ایله اوزاقدان ارتباط قورماسینی ساغلار',
      'medical_centers': 'یاقین طبی مركزلر و خسته‌خانه‌لر',
      'medical_centers_desc':
      'تقدیم ائدیلن خذمتلر و تماس نمره‌لری حقینده تفصیللی معلومات ایله اینتراكتیو خریطه واسطه‌سیله ان یاقین صحی مركزلری تانیماق',
      'skip': 'كئچ',
      'next': 'سونراكی',
      'start_now': 'ایندی باشلا',
      'language': 'تركماني',
      'login': 'گیریش',
      'welcome_back': 'خوش گلدیڭیز! سیزی یئنه گؤرمکدن خوشحالیق. حسابیڭیزا گیرمک اوچون معلوماتلاریڭیزی داخل ائدین',
      'phone_number': 'تلفن نؤمره‌سی',
      'password': 'شیفره',
      'forgot_password': 'شیفره‌نی اونوتدوڭوز؟',
      'no_account': 'حسابیڭیز یوخدور؟ ایندی یارادین',
      'enter': 'گیریش',
      'error': 'خطا',
      'success': 'باشاریلی',
      'enter_phone_password': 'لطفاً تلفن نؤمره‌سی و شیفره‌نی داخل ائدین',
      'login_success': 'گیریش باشاریلی اولدو',
      'login_failed': 'گیریش باشاریسیز اولدو',
      'server_error': 'سئروئر ایله باغلانتی باشاریسیز اولدو',
      'unexpected_error': 'گؤزلنیلمز خطا باش وئردی',
      'new_registration': 'تازه قئيد',
      'create_account_easily': 'دولی معلوماتلاریڭیزی دولدورماق آرقالی حسابیڭیزی آڭساتلیق بیلن دؤرەدیڭ',

      'personal_info': 'شخصی معلومات',
      'contact_info': 'ارتباط معلوماتی',
      'medical_info': 'طبی معلومات',
      'emergency_contact': 'تعجیلی تماس',
      'finish': 'بیتیر',
      'fill_required_fields': 'طلب ادیلن ساحه‌لری دولدورین',
      'registration_success': 'ثبت نام اوغورلی بولدی',
      'username': 'قوللانیجی آدی',
      'email': 'ایمیل',
      'enter_password': 'شیفره‌نی داخل ائدین',
      'invalid_phone': 'یالڭیش تلفن نومره‌سی',
      'first_name': 'آد',
      'middle_name': 'آتاڭیزیڭ آدی',
      'last_name': 'فامیلیا',
      'choose_country': 'یورت سایلاڭ',
      'country': 'یورت',
      'province': 'ولایت',
      'district': 'اترап',
      'alley': 'کؤچه',
      'house': 'اؤی نومری',
      'countries_error': 'یورتلار لیستینی یوکلمکده یالڭیشلیق',
      'birth_date': 'دوغلان گونی',
      'day': 'گون',
      'month': 'آی',
      'year': 'ییل',
      'gender': 'جنس',
      'male': 'ارکک',
      'female': 'آیال',
      'other_country': 'باشغا',
      'iraq': 'عراق','blood_type': 'غان گروپی',
      'allergies': 'آللرگیالار',
      'chronic_diseases': 'خرونیکی کسللر',
      'emergencyContactPage.fullName': 'دولی آد',
      'emergencyContactPage.selectCountry': 'یورت سایلاڭ',
      'emergencyContactPage.country': 'یورت',
      'emergencyContactPage.province': 'ولایت',
      'emergencyContactPage.district': 'اتراپ',
      'emergencyContactPage.alley': 'کؤچه',
      'emergencyContactPage.house': 'اؤی نومری',
      'emergencyContactPage.relationship': 'غاریندشلیق',
      'emergencyContactPage.phoneNumber': 'تلفن نومری',
      'emergencyContactPage.iraq': 'عراق',
      'emergencyContactPage.other_country': 'باشغا یورت',
      'emergencyContactPage.father': 'آتا',
      'emergencyContactPage.mother': 'انه',
      'emergencyContactPage.brother': 'دوغان',
      'emergencyContactPage.sister': 'اوغولغیز',
      'emergencyContactPage.son': 'اوغول',
      'emergencyContactPage.daughter': 'غیز',
      'emergencyContactPage.husband': 'آدام',
      'emergencyContactPage.wife': 'آیال',
      'emergencyContactPage.other': 'باشغا',
      'emergencyContactPage.countriesError': 'یورتلار لیستینی یوکلمکده یالڭیشلیق',
      'emergencyContactPage.noCountries': 'هیچ یورت الیتر دأل',
      'diagnosis_notes': 'کسل آنیقلاما\nو بللیکلر',
      'medications_list': 'AMPICILLIN\nAMPHOTERICIN\nAMPICILLIN',
      'my_medications': 'منیڭ درمانلاریم',
    },
    'en': {
      'crowd_medicine': 'Crowd Medicine',
      'crowd_medicine_desc':
      'Providing healthcare services for visitors including specialized medical services aimed at meeting visitors\' needs during their journey',
      'medical_consultation': 'Medical Consultation Feature',
      'medical_consultation_desc':
      'Allows visitors to communicate remotely with doctors to obtain health advice and specialized consultations in various medical fields',
      'medical_centers': 'Nearby Medical Centers and Hospitals',
      'medical_centers_desc':
      'Identify the nearest health centers through an interactive map with detailed information about services provided and contact numbers',
      'skip': 'Skip',
      'next': 'Next',
      'start_now': 'Start Now',
      'language': 'English',
      'login': 'Login',
      'welcome_back': 'Welcome back! We\'re glad to see you again. Please enter your credentials to login to your account',
      'phone_number': 'Phone Number',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'no_account': 'Don\'t have an account? Create one now',
      'enter': 'Enter',
      'error': 'Error',
      'success': 'Success',
      'enter_phone_password': 'Please enter phone number and password',
      'login_success': 'Login successful',
      'login_failed': 'Login failed',
      'server_error': 'Server connection failed',
      'unexpected_error': 'An unexpected error occurred',
      'new_registration': 'New Registration',
      'create_account_easily': 'Create your account easily by filling in your complete information',
      'personal_info': 'Personal Information',
      'contact_info': 'Contact Information',
      'medical_info': 'Medical Information',
      'emergency_contact': 'Emergency Contact',
      'finish': 'Finish',
      'fill_required_fields': 'Please fill all required fields',
      'registration_success': 'Registration successful',
      'username': 'Username',
      'email': 'Email',
      'enter_password': 'Enter Password',
      'invalid_phone': 'Invalid phone number',
      'first_name': 'First Name',
      'middle_name': 'Middle Name',
      'last_name': 'Last Name',
      'choose_country': 'Choose Country',
      'country': 'Country',
      'province': 'Province',
      'district': 'District',
      'alley': 'Alley',
      'house': 'House Number',
      'countries_error': 'Error loading countries list',
      'birth_date': 'Birth Date',
      'day': 'Day',
      'month': 'Month',
      'year': 'Year',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'other_country': 'Other',
      'iraq': 'Iraq',
      'blood_type': 'Blood Type',
      'allergies': 'Allergies',
      'chronic_diseases': 'Chronic Diseases',
      'emergencyContactPage.fullName': 'Full Name',
      'emergencyContactPage.selectCountry': 'Select Country',
      'emergencyContactPage.country': 'Country',
      'emergencyContactPage.province': 'Province',
      'emergencyContactPage.district': 'District',
      'emergencyContactPage.alley': 'Alley',
      'emergencyContactPage.house': 'House Number',
      'emergencyContactPage.relationship': 'Relationship',
      'emergencyContactPage.phoneNumber': 'Phone Number',
      'emergencyContactPage.iraq': 'Iraq',
      'emergencyContactPage.other_country': 'Other Country',
      'emergencyContactPage.father': 'Father',
      'emergencyContactPage.mother': 'Mother',
      'emergencyContactPage.brother': 'Brother',
      'emergencyContactPage.sister': 'Sister',
      'emergencyContactPage.son': 'Son',
      'emergencyContactPage.daughter': 'Daughter',
      'emergencyContactPage.husband': 'Husband',
      'emergencyContactPage.wife': 'Wife',
      'emergencyContactPage.other': 'Other',
      'emergencyContactPage.countriesError': 'Error loading countries list',
      'emergencyContactPage.noCountries': 'No countries available',
      'diagnosis_notes': 'Diagnosis and Notes',  // English
      'medications_list': 'AMPICILLIN\nAMPHOTERICIN\nAMPICILLIN',
      'my_medications': 'My Medications',

    },
  };

}
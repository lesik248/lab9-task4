import 'package:flutter/widgets.dart';

class AppL10n {
  AppL10n(this.locale);
  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('be'),
  ];

  static AppL10n of(BuildContext context) =>
      Localizations.of<AppL10n>(context, AppL10n) ?? AppL10n(const Locale('en'));

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'app_title': 'Grodno Buses Pro',
      'auth_title': 'Sign in',
      'auth_email': 'Email',
      'auth_password': 'Password',
      'auth_signin': 'Sign in',
      'auth_signup_hint': 'Use any email and password (min 4 chars)',
      'auth_invalid': 'Invalid credentials',
      'home_title': 'Dashboard',
      'home_card_cities': 'Cities',
      'home_card_cities_desc': 'Browse Grodno region cities',
      'home_card_bookings': 'Bookings',
      'home_card_bookings_desc': 'My recent bus tickets',
      'home_card_weather': 'Weather',
      'home_card_weather_desc': 'Forecast for selected city',
      'home_card_settings': 'Settings',
      'home_card_settings_desc': 'Theme, cache, language',
      'tab_home': 'Home',
      'tab_cities': 'Cities',
      'tab_bookings': 'Bookings',
      'tab_settings': 'Settings',
      'cities_title': 'Cities',
      'cities_add': 'Add city',
      'cities_empty': 'No cities yet. Add some from the catalogue.',
      'cities_remove': 'Remove',
      'cities_dialog_title': 'Add city',
      'cities_dialog_hint': 'Pick a city to add to your favourites',
      'city_detail_title': 'City',
      'city_detail_coords': 'Coordinates: {lat}, {lon}',
      'city_weather_open': 'Open weather',
      'city_book': 'Book a ticket',
      'bookings_title': 'My bookings',
      'bookings_empty': 'No bookings yet.',
      'bookings_new': 'New booking',
      'bookings_from': 'From',
      'bookings_to': 'To',
      'bookings_date': 'Date',
      'bookings_save': 'Save',
      'weather_title': 'Weather: {city}',
      'weather_temp': 'Temperature: {t} °C',
      'weather_humidity': 'Humidity: {h}%',
      'weather_desc': 'Conditions: {d}',
      'weather_offline': 'Offline data (cached)',
      'weather_chart_title': '24h forecast',
      'settings_title': 'Settings',
      'settings_theme': 'Theme',
      'settings_theme_system': 'System',
      'settings_theme_light': 'Light',
      'settings_theme_dark': 'Dark',
      'settings_language': 'Language',
      'settings_clear_cache': 'Clear cache',
      'settings_cache_cleared': 'Cache cleared',
      'settings_version': 'App version: {v}',
      'settings_signout': 'Sign out',
      'error_generic': 'Something went wrong: {e}',
      'notification_booked': 'Booking saved',
      'notification_booked_body': '{from} → {to} on {date}',
    },
    'ru': {
      'app_title': 'Автобусы Гродно Pro',
      'auth_title': 'Вход',
      'auth_email': 'Email',
      'auth_password': 'Пароль',
      'auth_signin': 'Войти',
      'auth_signup_hint': 'Введите любой email и пароль (минимум 4 символа)',
      'auth_invalid': 'Неверные учетные данные',
      'home_title': 'Главная',
      'home_card_cities': 'Города',
      'home_card_cities_desc': 'Города Гродненской области',
      'home_card_bookings': 'Бронирования',
      'home_card_bookings_desc': 'Мои билеты',
      'home_card_weather': 'Погода',
      'home_card_weather_desc': 'Прогноз для города',
      'home_card_settings': 'Настройки',
      'home_card_settings_desc': 'Тема, кеш, язык',
      'tab_home': 'Главная',
      'tab_cities': 'Города',
      'tab_bookings': 'Билеты',
      'tab_settings': 'Настройки',
      'cities_title': 'Города',
      'cities_add': 'Добавить город',
      'cities_empty': 'Список пуст. Добавьте город из каталога.',
      'cities_remove': 'Удалить',
      'cities_dialog_title': 'Добавить город',
      'cities_dialog_hint': 'Выберите город из каталога',
      'city_detail_title': 'Город',
      'city_detail_coords': 'Координаты: {lat}, {lon}',
      'city_weather_open': 'Открыть погоду',
      'city_book': 'Забронировать билет',
      'bookings_title': 'Мои билеты',
      'bookings_empty': 'Билетов пока нет.',
      'bookings_new': 'Новый билет',
      'bookings_from': 'Откуда',
      'bookings_to': 'Куда',
      'bookings_date': 'Дата',
      'bookings_save': 'Сохранить',
      'weather_title': 'Погода: {city}',
      'weather_temp': 'Температура: {t} °C',
      'weather_humidity': 'Влажность: {h}%',
      'weather_desc': 'Условия: {d}',
      'weather_offline': 'Данные из кеша (офлайн)',
      'weather_chart_title': 'Прогноз на 24 часа',
      'settings_title': 'Настройки',
      'settings_theme': 'Тема',
      'settings_theme_system': 'Системная',
      'settings_theme_light': 'Светлая',
      'settings_theme_dark': 'Тёмная',
      'settings_language': 'Язык',
      'settings_clear_cache': 'Очистить кеш',
      'settings_cache_cleared': 'Кеш очищен',
      'settings_version': 'Версия приложения: {v}',
      'settings_signout': 'Выйти',
      'error_generic': 'Произошла ошибка: {e}',
      'notification_booked': 'Билет сохранён',
      'notification_booked_body': '{from} → {to} на {date}',
    },
    'be': {
      'app_title': 'Аўтобусы Гродна Pro',
      'auth_title': 'Уваход',
      'auth_email': 'Email',
      'auth_password': 'Пароль',
      'auth_signin': 'Увайсці',
      'auth_signup_hint': 'Увядзіце любы email і пароль (мінімум 4 сімвалы)',
      'auth_invalid': 'Няправільныя дадзеныя',
      'home_title': 'Галоўная',
      'home_card_cities': 'Гарады',
      'home_card_cities_desc': 'Гарады Гродзенскай вобласці',
      'home_card_bookings': 'Браніраванні',
      'home_card_bookings_desc': 'Мае білеты',
      'home_card_weather': 'Надвор\'е',
      'home_card_weather_desc': 'Прагноз для горада',
      'home_card_settings': 'Налады',
      'home_card_settings_desc': 'Тэма, кэш, мова',
      'tab_home': 'Галоўная',
      'tab_cities': 'Гарады',
      'tab_bookings': 'Білеты',
      'tab_settings': 'Налады',
      'cities_title': 'Гарады',
      'cities_add': 'Дадаць горад',
      'cities_empty': 'Спіс пусты. Дадайце горад з каталога.',
      'cities_remove': 'Выдаліць',
      'cities_dialog_title': 'Дадаць горад',
      'cities_dialog_hint': 'Абярыце горад з каталога',
      'city_detail_title': 'Горад',
      'city_detail_coords': 'Каардынаты: {lat}, {lon}',
      'city_weather_open': 'Адкрыць надвор\'е',
      'city_book': 'Забраніраваць білет',
      'bookings_title': 'Мае білеты',
      'bookings_empty': 'Білетаў пакуль няма.',
      'bookings_new': 'Новы білет',
      'bookings_from': 'Адкуль',
      'bookings_to': 'Куды',
      'bookings_date': 'Дата',
      'bookings_save': 'Захаваць',
      'weather_title': 'Надвор\'е: {city}',
      'weather_temp': 'Тэмпература: {t} °C',
      'weather_humidity': 'Вільготнасць: {h}%',
      'weather_desc': 'Умовы: {d}',
      'weather_offline': 'Дадзеныя з кэшу (афлайн)',
      'weather_chart_title': 'Прагноз на 24 гадзіны',
      'settings_title': 'Налады',
      'settings_theme': 'Тэма',
      'settings_theme_system': 'Сістэмная',
      'settings_theme_light': 'Светлая',
      'settings_theme_dark': 'Цёмная',
      'settings_language': 'Мова',
      'settings_clear_cache': 'Ачысціць кэш',
      'settings_cache_cleared': 'Кэш ачышчаны',
      'settings_version': 'Версія прыкладання: {v}',
      'settings_signout': 'Выйсці',
      'error_generic': 'Адбылася памылка: {e}',
      'notification_booked': 'Білет захаваны',
      'notification_booked_body': '{from} → {to} на {date}',
    },
  };

  String t(String key, {Map<String, Object?>? args}) {
    final lang = locale.languageCode;
    final bundle = _strings[lang] ?? _strings['en']!;
    var value = bundle[key] ?? _strings['en']![key] ?? key;
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v?.toString() ?? '');
      });
    }
    return value;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppL10n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppL10n.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppL10n> load(Locale locale) async => AppL10n(locale);

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => false;
}

import 'package:flutter/material.dart';
import 'app_es.dart';
import 'app_en.dart';

/// Base class for all localizations. Add a new language by:
/// 1. Create lib/l10n/app_XX.dart extending AppLocalizations
/// 2. Add the Locale to supportedLocales in app.dart
/// 3. Add a case to AppLocalizationsDelegate._load
abstract class AppLocalizations {
  // ── General ─────────────────────────────────────────────────────────────
  String get appName;

  // ── Navigation ──────────────────────────────────────────────────────────
  String get navDashboard;
  String get navAgenda;
  String get navClientes;
  String get navServicios;
  String get navContabilidad;
  String get navAjustes;

  // ── Common actions ───────────────────────────────────────────────────────
  String get actionSave;
  String get actionCancel;
  String get actionDelete;
  String get actionEdit;
  String get actionAdd;
  String get actionConfirm;
  String get actionClose;
  String get actionSearch;
  String get actionAccept;

  // ── Common labels ────────────────────────────────────────────────────────
  String get labelName;
  String get labelEmail;
  String get labelPhone;
  String get labelAddress;
  String get labelNotes;
  String get labelPrice;
  String get labelDate;
  String get labelTime;
  String get labelTotal;
  String get labelStatus;
  String get labelNever;
  String get labelYes;
  String get labelNo;

  // ── Validation ───────────────────────────────────────────────────────────
  String get validationRequired;
  String get validationInvalidEmail;

  // ── Login ────────────────────────────────────────────────────────────────
  String get loginTitle;
  String get loginUser;
  String get loginPassword;
  String get loginButton;
  String get loginError;

  // ── Dashboard ────────────────────────────────────────────────────────────
  String get dashTitle;
  String get dashAppointmentsToday;
  String get dashMonthlyRevenue;
  String get dashUnpaidTotal;
  String get dashActiveBonuses;
  String get dashNoAppointmentsToday;
  String get dashRevenueVsExpenses;
  String get dashTopClients;
  String get dashTopServices;
  String get dashUnpaidRecent;
  String get dashNoData;
  // ignore: non_constant_identifier_names
  String dashMonthLabel(String month, String year);

  // ── Agenda ───────────────────────────────────────────────────────────────
  String get agendaTitle;
  String get agendaNewAppointment;
  String get agendaEditAppointment;
  String get agendaDeleteAppointment;
  String get agendaConfirmDelete;
  String get agendaClient;
  String get agendaService;
  String get agendaStart;
  String get agendaEnd;
  String get agendaPaid;
  String get agendaUnpaid;
  String get agendaMarkPaid;
  String get agendaExtras;
  String get agendaAddExtra;
  String get agendaNoAppointments;
  String get agendaAppointmentCreated;
  String get agendaAppointmentUpdated;
  String get agendaAppointmentDeleted;

  // ── Clients ──────────────────────────────────────────────────────────────
  String get clientsTitle;
  String get clientsSearch;
  String get clientsNew;
  String get clientsEdit;
  String get clientsDelete;
  String get clientsConfirmDelete;
  String get clientsCreated;
  String get clientsUpdated;
  String get clientsDeleted;
  String get clientsNoResults;
  String get clientsFicha;
  String get clientsLastVisit;
  String get clientsTotalSpent;
  String get clientsHistory;
  String get clientsBonos;

  // ── Services ─────────────────────────────────────────────────────────────
  String get servicesTitle;
  String get servicesNew;
  String get servicesEdit;
  String get servicesDelete;
  String get servicesConfirmDelete;
  String get servicesCreated;
  String get servicesUpdated;
  String get servicesDeleted;
  String get servicesDuration;
  String get servicesNoResults;

  // ── Accounting ───────────────────────────────────────────────────────────
  String get accountingTitle;
  String get accountingIncome;
  String get accountingExpenses;
  String get accountingBalance;
  String get accountingNewExpense;
  String get accountingExpenseCreated;
  String get accountingExpenseDeleted;
  String get accountingCategory;
  String get accountingDescription;
  String get accountingNoMovements;
  String get accountingFilterAll;
  String get accountingFilterIncome;
  String get accountingFilterExpenses;

  // ── Bonos ────────────────────────────────────────────────────────────────
  String get bonosTitle;
  String get bonosNew;
  String get bonosActive;
  String get bonosCobrado;
  String get bonosReconocido;
  String get bonosDiferido;
  String get bonosSessions;
  // ignore: non_constant_identifier_names
  String bonosSessionsUsed(int used, int total);

  // ── Settings ─────────────────────────────────────────────────────────────
  String get settingsTitle;
  String get settingsAppearance;
  String get settingsCompany;
  String get settingsNotifications;
  String get settingsRegional;
  String get settingsDataBackup;
  String get settingsSystem;
  String get settingsDarkTheme;
  String get settingsFont;
  String get settingsTextSize;
  String get settingsTextSmall;
  String get settingsTextMedium;
  String get settingsTextLarge;
  String get settingsCompanyName;
  String get settingsAddress;
  String get settingsPhone;
  String get settingsEmail;
  String get settingsEmployees;
  String get settingsLogoAdd;
  String get settingsLogoRemove;
  String get settingsAlertUnpaid;
  String get settingsAlertAppointments;
  String get settingsAlertInactiveClients;
  String get settingsInactiveDays;
  String get settingsLanguage;
  String get settingsDateFormat;
  String get settingsCurrency;
  String get settingsExportBackup;
  String get settingsImportBackup;
  String get settingsLastBackup;
  String get settingsBackupFrequency;
  String get settingsBackupNow;
  String get settingsBackupRestored;
  String get settingsResetTitle;
  String get settingsResetConfirm;
  String get settingsResetBody;
  String get settingsColorBrand;
  String get settingsColorAuto;
  String get settingsColorManual;
  String get settingsColorSecondary;
  String get settingsColorTertiary;
  // ignore: non_constant_identifier_names
  String settingsBackupFrequencyLabel(int days);

  // ── Lookup ───────────────────────────────────────────────────────────────
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['es', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'es':
      default:
        return AppLocalizationsEs();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

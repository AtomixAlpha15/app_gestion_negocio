import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  // ── General ─────────────────────────────────────────────────────────────
  @override String get appName => 'Business Manager';

  // ── Navigation Menu ──────────────────────────────────────────────────────
  @override String get navMenu => 'Menu';
  @override String get navMenuExpand => 'Expand menu';
  @override String get navMenuCollapse => 'Collapse menu';
  @override String get navUser => 'User';
  @override String get navHome => 'Home';

  // ── Navigation ──────────────────────────────────────────────────────────
  @override String get navDashboard => 'Dashboard';
  @override String get navAgenda => 'Schedule';
  @override String get navClientes => 'Clients';
  @override String get navServicios => 'Services';
  @override String get navContabilidad => 'Accounting';
  @override String get navAjustes => 'Settings';

  // ── Common actions ───────────────────────────────────────────────────────
  @override String get actionSave => 'Save';
  @override String get actionCancel => 'Cancel';
  @override String get actionDelete => 'Delete';
  @override String get actionEdit => 'Edit';
  @override String get actionAdd => 'Add';
  @override String get actionConfirm => 'Confirm';
  @override String get actionClose => 'Close';
  @override String get actionSearch => 'Search';
  @override String get actionAccept => 'Accept';

  // ── Common labels ────────────────────────────────────────────────────────
  @override String get labelName => 'Name';
  @override String get labelEmail => 'Email';
  @override String get labelPhone => 'Phone';
  @override String get labelAddress => 'Address';
  @override String get labelNotes => 'Notes';
  @override String get labelPrice => 'Price';
  @override String get labelDate => 'Date';
  @override String get labelTime => 'Time';
  @override String get labelTotal => 'Total';
  @override String get labelStatus => 'Status';
  @override String get labelNever => 'Never';
  @override String get labelYes => 'Yes';
  @override String get labelNo => 'No';

  // ── Validation ───────────────────────────────────────────────────────────
  @override String get validationRequired => 'This field is required';
  @override String get validationInvalidEmail => 'Invalid email address';

  // ── Login ────────────────────────────────────────────────────────────────
  @override String get loginTitle => 'Sign in';
  @override String get loginUser => 'Username';
  @override String get loginPassword => 'Password';
  @override String get loginButton => 'Sign in';
  @override String get loginError => 'Incorrect username or password';

  // ── Dashboard ────────────────────────────────────────────────────────────
  @override String get dashTitle => 'Dashboard';
  @override String get dashAppointmentsToday => 'Appointments today';
  @override String get dashMonthlyRevenue => 'Revenue this month';
  @override String get dashUnpaidTotal => 'Unpaid';
  @override String get dashActiveBonuses => 'Active packages';
  @override String get dashNoAppointmentsToday => 'No appointments today';
  @override String get dashRevenueVsExpenses => 'Revenue vs Expenses';
  @override String get dashTopClients => 'Top clients';
  @override String get dashTopServices => 'Top services';
  @override String get dashUnpaidRecent => 'Recent unpaid';
  @override String get dashNoData => 'No data';
  @override String dashMonthLabel(String month, String year) => '$month $year';

  // ── Agenda ───────────────────────────────────────────────────────────────
  @override String get agendaTitle => 'Schedule';
  @override String get agendaNewAppointment => 'New appointment';
  @override String get agendaEditAppointment => 'Edit appointment';
  @override String get agendaDeleteAppointment => 'Delete appointment';
  @override String get agendaConfirmDelete => 'Delete this appointment?';
  @override String get agendaClient => 'Client';
  @override String get agendaService => 'Service';
  @override String get agendaStart => 'Start';
  @override String get agendaEnd => 'End';
  @override String get agendaPaid => 'Paid';
  @override String get agendaUnpaid => 'Unpaid';
  @override String get agendaMarkPaid => 'Mark as paid';
  @override String get agendaExtras => 'Extras';
  @override String get agendaAddExtra => 'Add extra';
  @override String get agendaNoAppointments => 'No appointments for this day';
  @override String get agendaAppointmentCreated => 'Appointment created';
  @override String get agendaAppointmentUpdated => 'Appointment updated';
  @override String get agendaAppointmentDeleted => 'Appointment deleted';

  // ── Clients ──────────────────────────────────────────────────────────────
  @override String get clientsTitle => 'Clients';
  @override String get clientsSearch => 'Search client…';
  @override String get clientsNew => 'New client';
  @override String get clientsEdit => 'Edit client';
  @override String get clientsDelete => 'Delete client';
  @override String get clientsConfirmDelete => 'Delete this client? This action cannot be undone.';
  @override String get clientsCreated => 'Client created';
  @override String get clientsUpdated => 'Client updated';
  @override String get clientsDeleted => 'Client deleted';
  @override String get clientsNoResults => 'No results';
  @override String get clientsFicha => 'Profile';
  @override String get clientsLastVisit => 'Last visit';
  @override String get clientsTotalSpent => 'Total spent';
  @override String get clientsHistory => 'History';
  @override String get clientsBonos => 'Packages';
  @override String get clientsCardTitle => 'Client profile';
  @override String get clientsCardData => 'Client data';
  @override String get clientsSummary => 'Client summary';
  @override String get clientsUnpaidAppointments => 'Unpaid appointments';
  @override String get clientsNoHistoryYet => 'No history yet.';
  @override String get clientsNoAppointmentsRecorded => 'No appointments recorded.';
  @override String get clientsChangeImage => 'Change image';
  @override String get clientsRemoveImage => 'Remove image';

  // ── Services ─────────────────────────────────────────────────────────────
  @override String get servicesTitle => 'Services';
  @override String get servicesNew => 'New service';
  @override String get servicesEdit => 'Edit service';
  @override String get servicesDelete => 'Delete service';
  @override String get servicesConfirmDelete => 'Delete this service? This action cannot be undone.';
  @override String get servicesCreated => 'Service created';
  @override String get servicesUpdated => 'Service updated';
  @override String get servicesDeleted => 'Service deleted';
  @override String get servicesDuration => 'Duration (min)';
  @override String get servicesNoResults => 'No services';
  @override String get servicesSearch => 'Search service...';
  @override String get servicesAddImage => 'Add image';
  @override String get servicesChangeImage => 'Change image';
  @override String get servicesRemoveImage => 'Remove image';
  @override String get servicesPrice => 'Price (€)';
  @override String get servicesDescription => 'Description';
  @override String get servicesExtrasSection => 'Extras for this service:';
  @override String get servicesAddExtra => 'Add extra';
  @override String get servicesEditExtra => 'Edit Extra';
  @override String get servicesExtraName => 'Extra name';
  @override String get servicesExtraPrice => 'Price (€)';
  @override String get servicesInvalidPrice => 'Invalid price';
  @override String get servicesInvalidDuration => 'Invalid duration';
  @override String get servicesInvalidData => 'Invalid data';

  // ── Accounting ───────────────────────────────────────────────────────────
  @override String get accountingTitle => 'Accounting';
  @override String get accountingIncome => 'Income';
  @override String get accountingExpenses => 'Expenses';
  @override String get accountingBalance => 'Balance';
  @override String get accountingNewExpense => 'New expense';
  @override String get accountingExpenseCreated => 'Expense recorded';
  @override String get accountingExpenseDeleted => 'Expense deleted';
  @override String get accountingCategory => 'Category';
  @override String get accountingDescription => 'Description';
  @override String get accountingNoMovements => 'No transactions';
  @override String get accountingFilterAll => 'All';
  @override String get accountingFilterIncome => 'Income';
  @override String get accountingFilterExpenses => 'Expenses';
  @override String get accountingPaymentMethodCash => 'Cash';
  @override String get accountingPaymentMethodBizum => 'Bizum';
  @override String get accountingPaymentMethodCard => 'Card';
  @override String get accountingPaymentMethodOther => 'Other';
  @override String get accountingPaymentMethodUnpaid => 'Unpaid';
  @override String get accountingRevenue => 'Revenue';
  @override String get accountingProfit => 'Profit';
  @override String get accountingSummary => 'Summary';
  @override String get accountingMonthSummary => 'Monthly summary';
  @override String get accountingFilters => 'Filters';
  @override String get accountingPaymentMethod => 'Payment method';
  @override String get accountingClient => 'Client';
  @override String get accountingAllClients => 'All';
  @override String get accountingService => 'Service';
  @override String get accountingAllServices => 'All';
  @override String get accountingPeriod => 'Period';
  @override String get accountingMonth => 'Month';
  @override String get accountingYear => 'Year';
  @override String get accountingTabIncome => 'Income';
  @override String get accountingTabExpenses => 'Expenses';
  @override String get accountingNoExpenses => 'No expenses this month';
  @override String get accountingAnnualSummary => 'Annual summary';

  // ── Bonos ────────────────────────────────────────────────────────────────
  @override String get bonosTitle => 'Packages';
  @override String get bonosNew => 'New package';
  @override String get bonosActive => 'Active';
  @override String get bonosCobrado => 'Charged';
  @override String get bonosReconocido => 'Recognized';
  @override String get bonosDiferido => 'Deferred';
  @override String get bonosSessions => 'Sessions';
  @override String bonosSessionsUsed(int used, int total) => '$used / $total sessions';
  @override String get bonosCreateTitle => 'Create package';
  @override String get bonosServiceLabel => 'Service';
  @override String get bonosNameLabel => 'Name';
  @override String get bonosNameOptional => 'Name (optional)';
  @override String get bonosSessionsLabel => 'Sessions:';
  @override String get bonosPriceLabel => 'Package price (€) (optional)';
  @override String get bonosNoDueDate => 'No expiration';
  @override String get bonosDueDate => 'Expires:';
  @override String get bonosChooseDate => 'Choose date';
  @override String get bonosSelectService => 'Select a service';
  @override String get bonosCreateButton => 'Create';
  @override String get bonosPaymentMethod => 'Payment method';
  @override String get bonosPaymentMethodLabel => 'Payment method';
  @override String get bonosHistory => 'Package history';
  @override String get bonosAddPayment => 'Add payment';

  // ── Settings ─────────────────────────────────────────────────────────────
  @override String get settingsTitle => 'Settings';
  @override String get settingsAppearance => 'Appearance';
  @override String get settingsCompany => 'Company';
  @override String get settingsNotifications => 'Notifications';
  @override String get settingsRegional => 'Regional';
  @override String get settingsDataBackup => 'Data & backup';
  @override String get settingsSystem => 'System';
  @override String get settingsDarkTheme => 'Dark theme';
  @override String get settingsFont => 'Font';
  @override String get settingsTextSize => 'Text size';
  @override String get settingsTextSmall => 'Small';
  @override String get settingsTextMedium => 'Medium';
  @override String get settingsTextLarge => 'Large';
  @override String get settingsCompanyName => 'Company name';
  @override String get settingsAddress => 'Address';
  @override String get settingsPhone => 'Phone';
  @override String get settingsEmail => 'Email';
  @override String get settingsEmployees => 'Employees';
  @override String get settingsLogoAdd => 'Add logo';
  @override String get settingsLogoRemove => 'Remove logo';
  @override String get settingsAlertUnpaid => 'Unpaid alerts';
  @override String get settingsAlertAppointments => 'Appointment reminders';
  @override String get settingsAlertInactiveClients => 'Inactive clients';
  @override String get settingsInactiveDays => 'Inactivity days';
  @override String get settingsLanguage => 'Language';
  @override String get settingsDateFormat => 'Date format';
  @override String get settingsCurrency => 'Currency';
  @override String get settingsExportBackup => 'Export backup';
  @override String get settingsImportBackup => 'Import backup';
  @override String get settingsLastBackup => 'Last backup';
  @override String get settingsBackupFrequency => 'Auto-backup frequency';
  @override String get settingsBackupNow => 'Backup now';
  @override String get settingsBackupRestored => 'Backup restored';
  @override String get settingsResetTitle => 'Reset settings?';
  @override String get settingsResetConfirm => 'Reset';
  @override String get settingsResetBody => 'All settings will be reset to their default values. This action cannot be undone.';
  @override String get settingsColorBrand => 'Brand color';
  @override String get settingsColorAuto => 'Auto palette';
  @override String get settingsColorAutoDesc => 'Generates secondary and tertiary from base color';
  @override String get settingsColorManual => 'Manual colors';
  @override String get settingsColorSecondary => 'Secondary color';
  @override String get settingsColorTertiary => 'Tertiary color';
  @override String get settingsColorPrimary => 'Base color';
  @override String get settingsPrimaryPreview => 'Primary';
  @override String get settingsSecondaryPreview => 'Secondary';
  @override String get settingsTertiaryPreview => 'Tertiary';
  @override String get settingsSurfacePreview => 'Surface';
  @override String get settingsEmployeesDesc => 'For per-employee scheduling (coming soon)';
  @override String get settingsInactiveDaysLabel => 'Days without visit';
  @override String get settingsInactiveClientsDesc => '';
  @override String get settingsAlertUnpaidDesc => 'Alert when a client has pending payments';
  @override String get settingsAlertAppointmentsDesc => 'Notify before each scheduled appointment';
  @override String get settingsDaysInactivity => 'Days without visit';
  @override String get settingsCancelButton => 'Cancel';
  @override String get settingsSaveButton => 'Save';
  @override String get settingsLogoDontHave => 'No logo';
  @override String get settingsLogoUploaded => 'Logo uploaded';
  @override String get settingsLogoUploadedDesc => 'Uploaded successfully';
  @override String get settingsUnsavedChanges => 'Unsaved changes';
  @override String get settingsDiscardConfirm => 'Discard changes?';
  @override String get settingsBackupFrequencyDays => '${0} days';
  @override String get settingsResetConfirmMsg => 'All settings will be reset to their default values.';
  @override String get settingsRestoreDefaults => 'Restore defaults';
  @override String get settingsRestoreDefaultsWarning => 'You will lose all your visual, company and notification settings. Data (clients, appointments, etc.) will not be affected.';
  @override String get settingsRestoreDefaultsSuccess => 'Settings restored';
  @override String get settingsPickColor => 'Select color';
  @override String get settingsPreviewLabel => 'Preview';
  @override String get settingsCompanyLogo => 'Company logo';
  @override String get settingsNoAddress => 'No address';
  @override String get settingsNoPhone => 'No phone';
  @override String get settingsNoEmail => 'No email';
  @override String get settingsDaysWithoutVisit => 'Days without visit';
  @override String get settingsDaysSliderLabel => 'days';
  @override String get settingsBackupCancelled => 'Export cancelled';
  @override String get settingsSavedAt => 'Saved at:';
  @override String get settingsBackupSuccess => 'Local backup created (Backups folder).';
  @override String get settingsBackupError => 'Could not import backup';
  @override String get settingsImportSuccess => 'Backup restored';
  @override String get settingsImportSuccessMessage => 'The backup was restored successfully.\nRestart the app to apply all changes.';
  @override String get settingsImportError => 'Could not import backup';
  @override String get settingsEditEmployees => 'Number of employees';
  @override String get settingsEmployeeInput => 'Employees';
  @override String settingsBackupFrequencyLabel(int days) => 'Every $days day${days == 1 ? '' : 's'}';
}

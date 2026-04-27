import 'app_localizations.dart';

class AppLocalizationsEs extends AppLocalizations {
  // ── General ─────────────────────────────────────────────────────────────
  @override String get appName => 'Gestión Negocio';

  // ── Navigation Menu ──────────────────────────────────────────────────────
  @override String get navMenu => 'Menú';
  @override String get navMenuExpand => 'Expandir menú';
  @override String get navMenuCollapse => 'Contraer menú';
  @override String get navUser => 'Usuario';
  @override String get navHome => 'Inicio';

  // ── Navigation ──────────────────────────────────────────────────────────
  @override String get navDashboard => 'Inicio';
  @override String get navAgenda => 'Agenda';
  @override String get navClientes => 'Clientes';
  @override String get navServicios => 'Servicios';
  @override String get navContabilidad => 'Contabilidad';
  @override String get navAjustes => 'Ajustes';

  // ── Common actions ───────────────────────────────────────────────────────
  @override String get actionSave => 'Guardar';
  @override String get actionCancel => 'Cancelar';
  @override String get actionDelete => 'Eliminar';
  @override String get actionEdit => 'Editar';
  @override String get actionAdd => 'Añadir';
  @override String get actionConfirm => 'Confirmar';
  @override String get actionClose => 'Cerrar';
  @override String get actionSearch => 'Buscar';
  @override String get actionAccept => 'Aceptar';

  // ── Common labels ────────────────────────────────────────────────────────
  @override String get labelName => 'Nombre';
  @override String get labelEmail => 'Correo';
  @override String get labelPhone => 'Teléfono';
  @override String get labelAddress => 'Dirección';
  @override String get labelNotes => 'Notas';
  @override String get labelPrice => 'Precio';
  @override String get labelDate => 'Fecha';
  @override String get labelTime => 'Hora';
  @override String get labelTotal => 'Total';
  @override String get labelStatus => 'Estado';
  @override String get labelNever => 'Nunca';
  @override String get labelYes => 'Sí';
  @override String get labelNo => 'No';

  // ── Validation ───────────────────────────────────────────────────────────
  @override String get validationRequired => 'Este campo es obligatorio';
  @override String get validationInvalidEmail => 'Correo no válido';

  // ── Login ────────────────────────────────────────────────────────────────
  @override String get loginTitle => 'Iniciar sesión';
  @override String get loginUser => 'Usuario';
  @override String get loginPassword => 'Contraseña';
  @override String get loginButton => 'Entrar';
  @override String get loginError => 'Usuario o contraseña incorrectos';

  // ── Dashboard ────────────────────────────────────────────────────────────
  @override String get dashTitle => 'Inicio';
  @override String get dashAppointmentsToday => 'Citas hoy';
  @override String get dashMonthlyRevenue => 'Ingresos este mes';
  @override String get dashUnpaidTotal => 'Impagos';
  @override String get dashActiveBonuses => 'Bonos activos';
  @override String get dashNoAppointmentsToday => 'Sin citas hoy';
  @override String get dashRevenueVsExpenses => 'Ingresos vs Gastos';
  @override String get dashTopClients => 'Top clientes';
  @override String get dashTopServices => 'Top servicios';
  @override String get dashUnpaidRecent => 'Impagos recientes';
  @override String get dashNoData => 'Sin datos';
  @override String dashMonthLabel(String month, String year) => '$month $year';

  // ── Agenda ───────────────────────────────────────────────────────────────
  @override String get agendaTitle => 'Agenda';
  @override String get agendaNewAppointment => 'Nueva cita';
  @override String get agendaEditAppointment => 'Editar cita';
  @override String get agendaDeleteAppointment => 'Eliminar cita';
  @override String get agendaConfirmDelete => '¿Eliminar esta cita?';
  @override String get agendaClient => 'Cliente';
  @override String get agendaService => 'Servicio';
  @override String get agendaStart => 'Inicio';
  @override String get agendaEnd => 'Fin';
  @override String get agendaPaid => 'Pagado';
  @override String get agendaUnpaid => 'Pendiente';
  @override String get agendaMarkPaid => 'Marcar pagado';
  @override String get agendaExtras => 'Extras';
  @override String get agendaAddExtra => 'Añadir extra';
  @override String get agendaNoAppointments => 'Sin citas para este día';
  @override String get agendaAppointmentCreated => 'Cita creada';
  @override String get agendaAppointmentUpdated => 'Cita actualizada';
  @override String get agendaAppointmentDeleted => 'Cita eliminada';

  // ── Clients ──────────────────────────────────────────────────────────────
  @override String get clientsTitle => 'Clientes';
  @override String get clientsSearch => 'Buscar cliente…';
  @override String get clientsNew => 'Nuevo cliente';
  @override String get clientsEdit => 'Editar cliente';
  @override String get clientsDelete => 'Eliminar cliente';
  @override String get clientsConfirmDelete => '¿Eliminar este cliente? Esta acción no se puede deshacer.';
  @override String get clientsCreated => 'Cliente creado';
  @override String get clientsUpdated => 'Cliente actualizado';
  @override String get clientsDeleted => 'Cliente eliminado';
  @override String get clientsNoResults => 'Sin resultados';
  @override String get clientsFicha => 'Ficha';
  @override String get clientsLastVisit => 'Última visita';
  @override String get clientsTotalSpent => 'Total gastado';
  @override String get clientsHistory => 'Historial';
  @override String get clientsBonos => 'Bonos';
  @override String get clientsCardTitle => 'Ficha de cliente';
  @override String get clientsCardData => 'Datos del cliente';
  @override String get clientsSummary => 'Resumen del cliente';
  @override String get clientsUnpaidAppointments => 'Citas impagadas';
  @override String get clientsNoHistoryYet => 'Sin historial aún.';
  @override String get clientsNoAppointmentsRecorded => 'Sin citas registradas.';
  @override String get clientsChangeImage => 'Cambiar imagen';
  @override String get clientsRemoveImage => 'Quitar imagen';

  // ── Services ─────────────────────────────────────────────────────────────
  @override String get servicesTitle => 'Servicios';
  @override String get servicesNew => 'Nuevo servicio';
  @override String get servicesEdit => 'Editar servicio';
  @override String get servicesDelete => 'Eliminar servicio';
  @override String get servicesConfirmDelete => '¿Eliminar este servicio? Esta acción no se puede deshacer.';
  @override String get servicesCreated => 'Servicio creado';
  @override String get servicesUpdated => 'Servicio actualizado';
  @override String get servicesDeleted => 'Servicio eliminado';
  @override String get servicesDuration => 'Duración (min)';
  @override String get servicesNoResults => 'Sin servicios';
  @override String get servicesSearch => 'Buscar servicio...';
  @override String get servicesAddImage => 'Añadir imagen';
  @override String get servicesChangeImage => 'Cambiar imagen';
  @override String get servicesRemoveImage => 'Quitar imagen';
  @override String get servicesPrice => 'Precio (€)';
  @override String get servicesDescription => 'Descripción';
  @override String get servicesExtrasSection => 'Extras para este servicio:';
  @override String get servicesAddExtra => 'Añadir extra';
  @override String get servicesEditExtra => 'Editar Extra';
  @override String get servicesExtraName => 'Nombre del extra';
  @override String get servicesExtraPrice => 'Precio (€)';
  @override String get servicesInvalidPrice => 'Precio inválido';
  @override String get servicesInvalidDuration => 'Duración inválida';
  @override String get servicesInvalidData => 'Datos inválidos';

  // ── Accounting ───────────────────────────────────────────────────────────
  @override String get accountingTitle => 'Contabilidad';
  @override String get accountingIncome => 'Ingresos';
  @override String get accountingExpenses => 'Gastos';
  @override String get accountingBalance => 'Balance';
  @override String get accountingNewExpense => 'Nuevo gasto';
  @override String get accountingExpenseCreated => 'Gasto registrado';
  @override String get accountingExpenseDeleted => 'Gasto eliminado';
  @override String get accountingCategory => 'Categoría';
  @override String get accountingDescription => 'Descripción';
  @override String get accountingNoMovements => 'Sin movimientos';
  @override String get accountingFilterAll => 'Todos';
  @override String get accountingFilterIncome => 'Ingresos';
  @override String get accountingFilterExpenses => 'Gastos';
  @override String get accountingPaymentMethodCash => 'Efectivo';
  @override String get accountingPaymentMethodBizum => 'Bizum';
  @override String get accountingPaymentMethodCard => 'Tarjeta';
  @override String get accountingPaymentMethodOther => 'Otro';
  @override String get accountingPaymentMethodUnpaid => 'Impagado';
  @override String get accountingRevenue => 'Facturado';
  @override String get accountingProfit => 'Beneficio';
  @override String get accountingSummary => 'Resumen';
  @override String get accountingMonthSummary => 'Resumen mensual';
  @override String get accountingFilters => 'Filtros';
  @override String get accountingPaymentMethod => 'Método de pago';
  @override String get accountingClient => 'Cliente';
  @override String get accountingAllClients => 'Todos';
  @override String get accountingService => 'Servicio';
  @override String get accountingAllServices => 'Todos';
  @override String get accountingPeriod => 'Período';
  @override String get accountingMonth => 'Mes';
  @override String get accountingYear => 'Año';
  @override String get accountingTabIncome => 'Ingresos';
  @override String get accountingTabExpenses => 'Gastos';
  @override String get accountingNoExpenses => 'No hay gastos este mes';
  @override String get accountingAnnualSummary => 'Resumen anual';

  // ── Bonos ────────────────────────────────────────────────────────────────
  @override String get bonosTitle => 'Bonos';
  @override String get bonosNew => 'Nuevo bono';
  @override String get bonosActive => 'Activo';
  @override String get bonosCobrado => 'Cobrado';
  @override String get bonosReconocido => 'Reconocido';
  @override String get bonosDiferido => 'Diferido';
  @override String get bonosSessions => 'Sesiones';
  @override String bonosSessionsUsed(int used, int total) => '$used / $total sesiones';
  @override String get bonosCreateTitle => 'Crear bono';
  @override String get bonosServiceLabel => 'Servicio';
  @override String get bonosNameLabel => 'Nombre';
  @override String get bonosNameOptional => 'Nombre (opcional)';
  @override String get bonosSessionsLabel => 'Sesiones:';
  @override String get bonosPriceLabel => 'Precio bono (€) (opcional)';
  @override String get bonosNoDueDate => 'Sin caducidad';
  @override String get bonosDueDate => 'Caduca:';
  @override String get bonosChooseDate => 'Elegir fecha';
  @override String get bonosSelectService => 'Selecciona un servicio';
  @override String get bonosCreateButton => 'Crear';
  @override String get bonosPaymentMethod => 'Método de pago';
  @override String get bonosPaymentMethodLabel => 'Método de pago';
  @override String get bonosHistory => 'Historial de bonos';
  @override String get bonosAddPayment => 'Añadir pago';

  // ── Settings ─────────────────────────────────────────────────────────────
  @override String get settingsTitle => 'Ajustes';
  @override String get settingsAppearance => 'Apariencia';
  @override String get settingsCompany => 'Empresa';
  @override String get settingsNotifications => 'Notificaciones';
  @override String get settingsRegional => 'Regional';
  @override String get settingsDataBackup => 'Datos y backup';
  @override String get settingsSystem => 'Sistema';
  @override String get settingsDarkTheme => 'Tema oscuro';
  @override String get settingsFont => 'Tipografía';
  @override String get settingsTextSize => 'Tamaño de texto';
  @override String get settingsTextSmall => 'Pequeño';
  @override String get settingsTextMedium => 'Mediano';
  @override String get settingsTextLarge => 'Grande';
  @override String get settingsCompanyName => 'Nombre de empresa';
  @override String get settingsAddress => 'Dirección';
  @override String get settingsPhone => 'Teléfono';
  @override String get settingsEmail => 'Correo';
  @override String get settingsEmployees => 'Empleados';
  @override String get settingsLogoAdd => 'Añadir logo';
  @override String get settingsLogoRemove => 'Quitar logo';
  @override String get settingsAlertUnpaid => 'Alertas de impagos';
  @override String get settingsAlertAppointments => 'Recordatorios de citas';
  @override String get settingsAlertInactiveClients => 'Clientes inactivos';
  @override String get settingsInactiveDays => 'Días de inactividad';
  @override String get settingsLanguage => 'Idioma';
  @override String get settingsDateFormat => 'Formato de fecha';
  @override String get settingsCurrency => 'Moneda';
  @override String get settingsExportBackup => 'Exportar copia de seguridad';
  @override String get settingsImportBackup => 'Importar copia de seguridad';
  @override String get settingsLastBackup => 'Último backup';
  @override String get settingsBackupFrequency => 'Frecuencia de backup automático';
  @override String get settingsBackupNow => 'Crear backup ahora';
  @override String get settingsBackupRestored => 'Copia restaurada';
  @override String get settingsResetTitle => '¿Restablecer ajustes?';
  @override String get settingsResetConfirm => 'Restablecer';
  @override String get settingsResetBody => 'Se restablecerán todos los ajustes a sus valores por defecto. Esta acción no se puede deshacer.';
  @override String get settingsColorBrand => 'Color de marca';
  @override String get settingsColorAuto => 'Paleta automática';
  @override String get settingsColorAutoDesc => 'Genera secundario y terciario desde el color base';
  @override String get settingsColorManual => 'Colores manuales';
  @override String get settingsColorSecondary => 'Color secundario';
  @override String get settingsColorTertiary => 'Color terciario';
  @override String get settingsColorPrimary => 'Color base';
  @override String get settingsPrimaryPreview => 'Primario';
  @override String get settingsSecondaryPreview => 'Secundario';
  @override String get settingsTertiaryPreview => 'Terciario';
  @override String get settingsSurfacePreview => 'Surface';
  @override String get settingsEmployeesDesc => 'Para agendas por empleado (próximamente)';
  @override String get settingsInactiveDaysLabel => 'Días sin visita';
  @override String get settingsInactiveClientsDesc => '';
  @override String get settingsAlertUnpaidDesc => 'Avisar cuando un cliente tiene pagos pendientes';
  @override String get settingsAlertAppointmentsDesc => 'Notificar antes de cada cita programada';
  @override String get settingsDaysInactivity => 'Días sin visita';
  @override String get settingsCancelButton => 'Cancelar';
  @override String get settingsSaveButton => 'Guardar';
  @override String get settingsLogoDontHave => 'No hay logo';
  @override String get settingsLogoUploaded => 'Logo subido';
  @override String get settingsLogoUploadedDesc => 'Subido correctamente';
  @override String get settingsUnsavedChanges => 'Cambios sin guardar';
  @override String get settingsDiscardConfirm => '¿Descartar cambios?';
  @override String get settingsBackupFrequencyDays => '${0} días';
  @override String get settingsResetConfirmMsg => 'Se restablecerán todos los ajustes a sus valores por defecto.';
  @override String get settingsRestoreDefaults => 'Restablecer valores por defecto';
  @override String get settingsRestoreDefaultsWarning => 'Se perderán todos tus ajustes visuales, de empresa y notificaciones. Los datos (clientes, citas, etc.) no se verán afectados.';
  @override String get settingsRestoreDefaultsSuccess => 'Ajustes restablecidos';
  @override String get settingsPickColor => 'Seleccionar color';
  @override String get settingsPreviewLabel => 'Vista previa';
  @override String get settingsCompanyLogo => 'Logo de empresa';
  @override String get settingsNoAddress => 'Sin dirección';
  @override String get settingsNoPhone => 'Sin teléfono';
  @override String get settingsNoEmail => 'Sin email';
  @override String get settingsDaysWithoutVisit => 'Días sin visita';
  @override String get settingsDaysSliderLabel => 'días';
  @override String get settingsBackupCancelled => 'Exportación cancelada';
  @override String get settingsSavedAt => 'Guardado en:';
  @override String get settingsBackupSuccess => 'Backup local creado (carpeta Backups).';
  @override String get settingsBackupError => 'No se pudo importar el backup';
  @override String get settingsImportSuccess => 'Copia restaurada';
  @override String get settingsImportSuccessMessage => 'Se restauró la copia correctamente.\nReinicia la app para aplicar todos los cambios.';
  @override String get settingsImportError => 'No se pudo importar el backup';
  @override String get settingsEditEmployees => 'Número de empleados';
  @override String get settingsEmployeeInput => 'Empleados';
  @override String settingsBackupFrequencyLabel(int days) => 'Cada $days día${days == 1 ? '' : 's'}';
}

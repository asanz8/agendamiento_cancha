// GENERATED FILE, do not edit!
import 'package:i18n/i18n.dart' as i18n;
	String get _languageCode => 'en';
	String _plural(int count, {String? zero, String? one, String? two, String?few, String? many, String? other}) =>
	i18n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _ordinal(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
	i18n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _cardinal(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
	i18n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);

class HomePageMsg {
String get locale => "en";
String get languageCode => "en";
	const HomePageMsg();
	String get appbar_title => """Agendamiento""";
	String get new_agenda_tooltip => """Nueva agenda""";
	String get delete_agenda => """Eliminar agenda""";
	String get delete_agenda_alert_title => """¿Desea eliminar la siguiente agenda?""";
	String get success_delete_agenda => """Agenda eliminada""";
	String get empty_list_title => """Todavía no tienes canchas agendadadas""";
	String get empty_list_subtitle => """Una vez hayas agendado una cancha y una fecha podrás ver la reserva aquí.""";
	String get list_agenda_header => """Fechas agendadas""";
}


Map<String, String> get homePageMsgMap => {
	"""appbar_title""": """Agendamiento""",
	"""new_agenda_tooltip""": """Nueva agenda""",
	"""delete_agenda""": """Eliminar agenda""",
	"""delete_agenda_alert_title""": """¿Desea eliminar la siguiente agenda?""",
	"""success_delete_agenda""": """Agenda eliminada""",
	"""empty_list_title""": """Todavía no tienes canchas agendadadas""",
	"""empty_list_subtitle""": """Una vez hayas agendado una cancha y una fecha podrás ver la reserva aquí.""",
	"""list_agenda_header""": """Fechas agendadas""",
};

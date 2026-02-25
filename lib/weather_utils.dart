String getWeatherIcon(int code) {
  if (code == 0) return "☀️";
  if (code <= 3) return "⛅";
  if (code <= 48) return "🌫️";
  if (code <= 67) return "🌧️";
  if (code <= 77) return "❄️";
  if (code <= 82) return "🌧️";
  if (code <= 95) return "⛈️";
  return "☁️";
}

String getDay(String date) {
  DateTime parsed = DateTime.parse(date);

  List days = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  return days[parsed.weekday - 1];
}
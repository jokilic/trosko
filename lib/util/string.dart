String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String getGreeting(DateTime dateTime) => switch (dateTime.hour) {
  >= 5 && < 12 => 'Good morning',
  >= 12 && < 17 => 'Good afternoon',
  >= 17 && < 22 => 'Good evening',
  _ => 'Good night',
};

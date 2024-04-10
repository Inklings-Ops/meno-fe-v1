List<Map> passwordStrengthRules = [
  {
    'name': 'A minimum of 8 characters',
    'rule': (String text) => RegExp('.{8,}').hasMatch(text)
  },
  {
    'name': 'At least one capital letter',
    'rule': (String text) => RegExp('(?=.*[A-Z])').hasMatch(text)
  },
  {
    'name': 'At least one number',
    'rule': (String text) => RegExp('(?=.*[0-9])').hasMatch(text)
  },
  {
    'name': 'At least one special character',
    'rule': (String text) => RegExp('(?=.*[@\$!%*?&])').hasMatch(text)
  },
];

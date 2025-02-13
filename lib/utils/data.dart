List<Map<String, dynamic>> levelOneTasks = [
  {
    'room': 'Nurse Room',
    'task': 'Get the pillow and get food.',
    'isDone': currentItems.contains('Pillow') && currentItems.contains('Food')
        ? true
        : false,
  },
  {
    'room': 'Doctor Room',
    'task': 'Get the medicine prescriptions.',
    'isDone': currentItems.contains('Medicine Prescriptions') ? true : false,
  },
  {
    'room': 'Medtech Room',
    'task':
        'Check the patient’s vital signs\n(blood pressure, heart rate,\nand temperature).',
    'isDone': currentItems.contains('Vital Signs Equipment') ? true : false,
  },
  {
    'room': 'Pharmacy Room',
    'task': 'Get the prescribed medicine.',
    'isDone': currentItems.contains('Prescribed Medicine (2)') ? true : false,
  },
];

List currentItems = [];

List<String> levelOneRequiredItems = [
  'Pillow',
  'Food',
  'Medicine Prescriptions',
  'Vital Signs Equipment',
  'Prescribed Medicine (2)',
];

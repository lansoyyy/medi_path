List<Map<String, dynamic>> levelOneTasks = [
  {
    'room': 'Nurse Room',
    'task': 'Get the pillow and get food.',
    'isDone': false,
  },
  {
    'room': 'Doctor Room',
    'task': 'Get the medicine prescriptions.',
    'isDone': false,
  },
  {
    'room': 'Medtech Room',
    'task':
        'Check the patient’s vital signs\n(blood pressure, heart rate,\nand temperature).',
    'isDone': false,
  },
  {
    'room': 'Patients Room',
    'task': 'Assist the patient in sitting\nup and provide water.',
    'isDone': false,
  },
  {
    'room': 'Pharmacy Room',
    'task': 'Get the prescribed medicine.',
    'isDone': false,
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

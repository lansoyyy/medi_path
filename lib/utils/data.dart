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
List<String> levelOneRequiredItems = [
  'Pillow',
  'Food',
  'Medicine Prescriptions',
  'Vital Signs Equipment',
  'Prescribed Medicine (2)',
];

List<Map<String, dynamic>> levelTwoTasks = [
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
  {
    'room': 'Medtech Room',
    'task': 'Get the x-ray of the patient.',
    'isDone': currentItems.contains('X-Ray') ? true : false,
  },
  {
    'room': 'Patients Room',
    'task': "Get the patient's pulse rate",
    'isDone': currentItems.contains('Oximeter') ? true : false,
  },
];
List<String> levelTwoRequiredItems = [
  'Pillow',
  'Food',
  'Medicine Prescriptions',
  'Vital Signs Equipment',
  'Prescribed Medicine (2)',
  'X-Ray',
  'Oximeter'
];

List currentItems = [];

int currentLevel = 1;
int character = 1;

List<String> patientGreetings = [
  "Hello there! Thanks for coming to check on me. I’ve got a few things that need sorting out—hope you can help!",
  "Hi... I’m feeling a bit off, and I’m not sure what’s wrong. There’s a list of things that need to be done—can you take a look?",
  "Hey! Took you long enough! Just kidding. I’ve got a little to-do list here—let’s see if you can work your magic.",
  "Thank you for coming! I’ve got a few things that need attention, and I’d really appreciate your help.",
  "Hi! I’ve been feeling a bit strange lately. There’s a list of things that need to be done—maybe you can figure out what’s going on?",
  "Well, well, look who’s here! I’ve got a little challenge for you—let’s see if you can tackle my to-do list.",
  "Hello, dear. It’s so nice to see you. I’ve got a few things that need sorting out—would you mind helping me?",
  "Hi! I don’t feel very good. There’s a list of things to do—can you help me feel better?",
  "Thank goodness you’re here! I’ve got a whole list of things that need fixing. I hope you’re up for the challenge!",
  "Um... hi. I’m not sure what’s wrong, but there’s a list of things that need to be done. Maybe you can help?",
  "Hello? Oh, you’re here to help? That’s good. I’ve got a list of things that need attention—I’m not sure where to start.",
  "Hey... thanks for stopping by. I’ve been feeling really run down. There’s a list of things to do—think you can help me out?",
  "Hi! I’m so glad you’re here. I’ve got a list of things that need to be done—let’s get started!"
];

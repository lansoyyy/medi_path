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

List<Map<String, dynamic>> levelThreeTasks = [
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
        'Check the patient\'s vital signs\n(blood pressure, heart rate,\nand temperature).',
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
  {
    'room': 'Doctor Room',
    'task': 'Get the surgical equipment for emergency procedure.',
    'isDone': currentItems.contains('Surgical Kit') ? true : false,
  },
  {
    'room': 'Pharmacy Room',
    'task': 'Get the emergency injection medication.',
    'isDone': currentItems.contains('Emergency Injection') ? true : false,
  },
  {
    'room': 'Nurse Room',
    'task': 'Get the patient monitoring system.',
    'isDone': currentItems.contains('Patient Monitor') ? true : false,
  },
];
List<String> levelThreeRequiredItems = [
  'Pillow',
  'Food',
  'Medicine Prescriptions',
  'Vital Signs Equipment',
  'Prescribed Medicine (2)',
  'X-Ray',
  'Oximeter',
  'Surgical Kit',
  'Emergency Injection',
  'Patient Monitor'
];

List<Map<String, dynamic>> levelFourTasks = [
  {
    'room': 'Nurse Room',
    'task': 'Get pillow and get food.',
    'isDone': currentItems.contains('Pillow') && currentItems.contains('Food')
        ? true
        : false,
  },
  {
    'room': 'Doctor Room',
    'task': 'Get medicine prescriptions.',
    'isDone': currentItems.contains('Medicine Prescriptions') ? true : false,
  },
  {
    'room': 'Medtech Room',
    'task':
        'Check the patient\'s vital signs\n(blood pressure, heart rate,\nand temperature).',
    'isDone': currentItems.contains('Vital Signs Equipment') ? true : false,
  },
  {
    'room': 'Pharmacy Room',
    'task': 'Get the prescribed medicine.',
    'isDone': currentItems.contains('Prescribed Medicine (2)') ? true : false,
  },
  {
    'room': 'Medtech Room',
    'task': 'Get x-ray of the patient.',
    'isDone': currentItems.contains('X-Ray') ? true : false,
  },
  {
    'room': 'Patients Room',
    'task': "Get the patient's pulse rate",
    'isDone': currentItems.contains('Oximeter') ? true : false,
  },
  {
    'room': 'Doctor Room',
    'task': 'Get the surgical equipment for emergency procedure.',
    'isDone': currentItems.contains('Surgical Kit') ? true : false,
  },
  {
    'room': 'Pharmacy Room',
    'task': 'Get the emergency injection medication.',
    'isDone': currentItems.contains('Emergency Injection') ? true : false,
  },
  {
    'room': 'Nurse Room',
    'task': 'Get the patient monitoring system.',
    'isDone': currentItems.contains('Patient Monitor') ? true : false,
  },
  {
    'room': 'Reception',
    'task': 'Get the patient medical records and history.',
    'isDone': currentItems.contains('Medical Records') ? true : false,
  },
  {
    'room': 'Doctor Room',
    'task': 'Prepare the operating room for surgery.',
    'isDone': currentItems.contains('Operating Room Setup') ? true : false,
  },
  {
    'room': 'Pharmacy Room',
    'task': 'Get the specialized medication kit.',
    'isDone':
        currentItems.contains('Specialized Medication Kit') ? true : false,
  },
];
List<String> levelFourRequiredItems = [
  'Pillow',
  'Food',
  'Medicine Prescriptions',
  'Vital Signs Equipment',
  'Prescribed Medicine (2)',
  'X-Ray',
  'Oximeter',
  'Surgical Kit',
  'Emergency Injection',
  'Patient Monitor',
  'Medical Records',
  'Operating Room Setup',
  'Specialized Medication Kit'
];

List<Map<String, String>> medicalNotebookEntries = [
  {
    'id': 'Pillow',
    'title': 'Pillow',
    'category': 'Nurse Room',
    'description':
        'Used to support the patient and keep them comfortable in bed.'
  },
  {
    'id': 'Food',
    'title': 'Patient Meal',
    'category': 'Nurse Room',
    'description': 'Provides nutrition and energy to help the patient recover.'
  },
  {
    'id': 'Medicine Prescriptions',
    'title': 'Medicine Prescriptions',
    'category': 'Doctor Room',
    'description':
        'Lists the medicines, doses, and schedules ordered by the doctor.'
  },
  {
    'id': 'Vital Signs Equipment',
    'title': 'Vital Signs Equipment',
    'category': 'Medtech Room',
    'description':
        'Tools used to measure blood pressure, heart rate, and temperature.'
  },
  {
    'id': 'Prescribed Medicine (2)',
    'title': 'Prescribed Medicine',
    'category': 'Pharmacy Room',
    'description': 'Medicines prepared by the pharmacy according to the order.'
  },
  {
    'id': 'X-Ray',
    'title': 'X-Ray Image',
    'category': 'Medtech Room',
    'description':
        'A special picture that shows bones and some organs inside the body.'
  },
  {
    'id': 'Oximeter',
    'title': 'Pulse Oximeter',
    'category': 'Patients Room',
    'description':
        'A small device placed on a finger to measure oxygen level and pulse.'
  },
  {
    'id': 'Surgical Kit',
    'title': 'Surgical Kit',
    'category': 'Nurse Room',
    'description':
        'A set of sterile instruments used by the surgical team during operations.'
  },
  {
    'id': 'Emergency Injection',
    'title': 'Emergency Injection',
    'category': 'Pharmacy Room',
    'description':
        'A fast-acting medicine given by injection during urgent situations.'
  },
  {
    'id': 'Patient Monitor',
    'title': 'Patient Monitor',
    'category': 'Nurse Room',
    'description':
        'A screen that continuously shows vital signs like heart rate and oxygen.'
  },
  {
    'id': 'Operating Room Setup',
    'title': 'Operating Room Setup',
    'category': 'Nurse Room',
    'description':
        'The preparation of tools, machines, and sterile area before surgery.'
  },
  {
    'id': 'Specialized Medication Kit',
    'title': 'Specialized Medication Kit',
    'category': 'Pharmacy Room',
    'description':
        'A collection of special medicines prepared for a specific procedure.'
  },
  {
    'id': 'Medical Records',
    'title': 'Medical Records',
    'category': 'Reception',
    'description':
        'Documents that contain the patient history, diagnoses, and treatments.'
  },
  {
    'id': 'nurse',
    'title': 'Nurse',
    'category': 'Medical Staff',
    'description':
        'A healthcare professional who closely cares for patients every day.'
  },
  {
    'id': 'doctor',
    'title': 'Doctor',
    'category': 'Medical Staff',
    'description':
        'A medical professional who examines patients and plans treatments.'
  },
  {
    'id': 'virus',
    'title': 'Virus',
    'category': 'Disease',
    'description':
        'A tiny germ that can enter the body and cause infectious illnesses.'
  },
  {
    'id': 'oxygen',
    'title': 'Oxygen',
    'category': 'Breathing Support',
    'description':
        'A gas that every cell in the body needs to stay alive and healthy.'
  },
  {
    'id': 'pharmacy',
    'title': 'Pharmacy',
    'category': 'Hospital Area',
    'description':
        'The area where medicines are prepared, checked, and given to patients.'
  },
  {
    'id': 'surgery',
    'title': 'Surgery',
    'category': 'Procedure',
    'description':
        'A medical operation where doctors work inside the body to fix a problem.'
  },
  {
    'id': 'vitals',
    'title': 'Vital Signs',
    'category': 'Monitoring',
    'description':
        'Important measurements such as heart rate, temperature, and breathing.'
  },
  {
    'id': 'tablet',
    'title': 'Tablet Medicine',
    'category': 'Medication Form',
    'description':
        'A small solid dose of medicine that is swallowed with water.'
  },
  {
    'id': 'capsule',
    'title': 'Capsule Medicine',
    'category': 'Medication Form',
    'description':
        'Medicine inside a small shell that dissolves inside the stomach.'
  },
];

List<String> unlockedNotebookIds = [];

void unlockNotebookItem(String id) {
  if (!unlockedNotebookIds.contains(id)) {
    unlockedNotebookIds.add(id);
  }
}

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

import 'dart:io';

class Student {
  final String name;
  final Map<String, int> grades;

  Student(this.name, this.grades);

  double get averageGrade {
    if (grades.isEmpty) return 0;
    return grades.values.reduce((a, b) => a + b) / grades.length;
  }

  int get countOfFives => grades.values.where((grade) => grade == 5).length;
}

void main() {
  // Данные журнала: студент -> предмет -> оценка.
  final students = <Student>[
    Student('Иванов Иван', {
      'Математика': 5,
      'Русский язык': 5,
      'Программирование': 5,
      'История': 4,
      'Английский язык': 5,
    }),
    Student('Петров Пётр', {
      'Математика': 4,
      'Русский язык': 4,
      'Программирование': 5,
      'История': 4,
      'Английский язык': 3,
    }),
    Student('Сидорова Анна', {
      'Математика': 5,
      'Русский язык': 5,
      'Программирование': 4,
      'История': 5,
      'Английский язык': 5,
    }),
    Student('Кузнецов Алексей', {
      'Математика': 3,
      'Русский язык': 4,
      'Программирование': 3,
      'История': 2,
      'Английский язык': 4,
    }),
    Student('Смирнова Мария', {
      'Математика': 5,
      'Русский язык': 5,
      'Программирование': 5,
      'История': 5,
      'Английский язык': 5,
    }),
    Student('Волков Дмитрий', {
      'Математика': 2,
      'Русский язык': 3,
      'Программирование': 4,
      'История': 3,
      'Английский язык': 2,
    }),
    Student('Орлова Елена', {
      'Математика': 4,
      'Русский язык': 5,
      'Программирование': 4,
      'История': 5,
      'Английский язык': 4,
    }),
    Student('Морозов Никита', {
      'Математика': 3,
      'Русский язык': 3,
      'Программирование': 3,
      'История': 4,
      'Английский язык': 3,
    }),
  ];

  printHeader('ЖУРНАЛ УСПЕВАЕМОСТИ ГРУППЫ');
  print('Количество студентов: ${students.length}');
  print('Количество предметов: ${students.first.grades.length}');
  print('');

  printSection('1. ГРУППИРОВКА СТУДЕНТОВ ПО СРЕДНЕМУ БАЛЛУ');

  final excellent = <Student>[];
  final good = <Student>[];
  final others = <Student>[];

  for (final student in students) {
    final average = student.averageGrade;

    // 4.5 и выше — отличники.
    // От 3.5 до 4.5 (не включая 4.5) — хорошисты.
    // Ниже 3.5 — остальные.
    if (average >= 4.5) {
      excellent.add(student);
    } else if (average >= 3.5) {
      good.add(student);
    } else {
      others.add(student);
    }
  }

  printStudentCategory('Отличники (средний балл >= 4.5)', excellent);
  printStudentCategory('Хорошисты (3.5 <= средний балл < 4.5)', good);
  printStudentCategory('Остальные (средний балл < 3.5)', others);

  printSection('2. СКОЛЬКО РАЗ ВСТРЕЧАЕТСЯ КАЖДАЯ ОЦЕНКА');

  final gradeCount = <int, int>{2: 0, 3: 0, 4: 0, 5: 0};

  for (final student in students) {
    for (final grade in student.grades.values) {
      gradeCount[grade] = (gradeCount[grade] ?? 0) + 1;
    }
  }

  for (final grade in [2, 3, 4, 5]) {
    print('Оценка $grade: ${gradeCount[grade]} раз(а)');
  }

  printSection('3. СТУДЕНТЫ, ПОЛУЧИВШИЕ 5 ПО КАЖДОМУ ПРЕДМЕТУ');

  final subjects = students.first.grades.keys.toList();

  for (final subject in subjects) {
    final studentsWithFive = students
        .where((student) => student.grades[subject] == 5)
        .map((student) => student.name)
        .toList();

    print('$subject:');
    if (studentsWithFive.isEmpty) {
      print('  Никто не получил 5');
    } else {
      for (final name in studentsWithFive) {
        print('  - $name');
      }
    }
  }

  printSection('4. ПРЕДМЕТЫ, ПО КОТОРЫМ НЕТ НИ ОДНОЙ ДВОЙКИ');

  final subjectsWithoutTwos = subjects.where((subject) {
    return students.every((student) => student.grades[subject] != 2);
  }).toList();

  if (subjectsWithoutTwos.isEmpty) {
    print('Таких предметов нет.');
  } else {
    for (final subject in subjectsWithoutTwos) {
      print('- $subject');
    }
  }

  printSection('5. ПРЕДМЕТ С НАИБОЛЬШИМ КОЛИЧЕСТВОМ ДВОЕК');

  final twosBySubject = <String, int>{};

  for (final subject in subjects) {
    twosBySubject[subject] = students
        .where((student) => student.grades[subject] == 2)
        .length;
  }

  final maxTwos = twosBySubject.values.reduce((a, b) => a > b ? a : b);
  final subjectsWithMaxTwos = twosBySubject.entries
      .where((entry) => entry.value == maxTwos)
      .map((entry) => entry.key)
      .toList();

  if (maxTwos == 0) {
    print('Двоек в журнале нет.');
  } else {
    for (final subject in subjectsWithMaxTwos) {
      print('$subject — $maxTwos двоек');
    }
  }

  printSection('6. СТУДЕНТЫ С НАИБОЛЬШИМ КОЛИЧЕСТВОМ ПЯТЁРОК');

  final maxFives = students
      .map((student) => student.countOfFives)
      .reduce((a, b) => a > b ? a : b);

  final studentsWithMaxFives =
      students.where((student) => student.countOfFives == maxFives).toList();

  for (final student in studentsWithMaxFives) {
    print('${student.name} — $maxFives пятёрок');
  }

  printSection('7. ПРЕДМЕТЫ С ОЦЕНКАМИ НИЖЕ 4');

  for (final student in students) {
    final badSubjects = student.grades.entries
        .where((entry) => entry.value < 4)
        .map((entry) => '${entry.key} (${entry.value})')
        .toList();

    if (badSubjects.isEmpty) {
      print('${student.name}: оценок ниже 4 нет.');
    } else {
      print('${student.name}: ${badSubjects.length} предмет(а) с оценкой ниже 4');
      for (final subject in badSubjects) {
        print('  - $subject');
      }
    }
  }

  printSection('8. ВСЕ ПАРЫ «СТУДЕНТ — ПРЕДМЕТ», ПО КОТОРЫМ СТОИТ 5');

  var pairNumber = 1;

  for (final student in students) {
    for (final entry in student.grades.entries) {
      if (entry.value == 5) {
        print('$pairNumber. ${student.name} — ${entry.key}');
        pairNumber++;
      }
    }
  }

  printSection('СРЕДНИЕ БАЛЛЫ ВСЕХ СТУДЕНТОВ');

  for (final student in students) {
    print('${student.name}: ${student.averageGrade.toStringAsFixed(2)}');
  }

  print('\nАнализ журнала завершён.');
}

void printHeader(String title) {
  print('=' * 70);
  print(title);
  print('=' * 70);
}

void printSection(String title) {
  print('\n${'-' * 70}');
  print(title);
  print('-' * 70);
}

void printStudentCategory(String title, List<Student> students) {
  print('\n$title:');

  if (students.isEmpty) {
    print('  Нет студентов.');
    return;
  }

  for (final student in students) {
    print(
      '  - ${student.name} '
      '(средний балл: ${student.averageGrade.toStringAsFixed(2)})',
    );
  }
}

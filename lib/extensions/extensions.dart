import 'dart:io';

// 1. String Extension: Palindrome kontrolü
extension PalindromeExtension on String {
  bool get isPalindrome {
    String cleaned = this.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return cleaned == cleaned.split('').reversed.join('');
  }
}

// 2. Int Extension: Asal Sayı Kontrolü
extension PrimeExtension on int {
  bool get isPrime {
    if (this <= 1) return false;
    for (int i = 2; i <= this / 2; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }
}

// 3. DateTime Extension: İki tarih arasındaki gün sayısını hesaplama
extension DateTimeExtension on DateTime {
  int daysBetween(DateTime other) {
    return this.difference(other).inDays.abs();
  }
}

// 4. Bool Extension: Mantıksal Deyim
extension BoolExtension on bool {
  bool and(bool other) => this && other;
  bool or(bool other) => this || other;
  bool not() => !this;
}

// 5. Set Extension: Yinelenen elemanları kaldırma
extension SetExtension<T> on Set<T> {
  Set<T> removeDuplicates() {
    return this.toSet();
  }
}

// 6. Map Extension: Aile üyeleri soyadına göre grupla
extension MapExtension on Map<String, String> {
  Map<String, List<String>> groupBySurname() {
    Map<String, List<String>> surnameGroups = {};
    this.forEach((name, surname) {
      if (!surnameGroups.containsKey(surname)) {
        surnameGroups[surname] = [];
      }
      surnameGroups[surname]?.add(name);
    });
    return surnameGroups;
  }
}

void main() {
  // Kullanıcıdan sayı almak için
  print("Bir sayı giriniz:");
  String? input = stdin.readLineSync();

  if (input != null) {
    int number = int.tryParse(input) ?? 0;

    // Sayının asal olup olmadığını kontrol etme
    if (number.isPrime) {
      print("$number sayısı asal bir sayıdır.");
    } else {
      print("$number sayısı asal bir sayı değildir.");
    }
  } else {
    print("Geçersiz giriş.");
  }

  // String palindrome kontrolü
  String testString = "A man a plan a canal Panama";
  print("Is palindrome: ${testString.isPalindrome}");

  // DateTime: Gün farkı hesaplama
  DateTime date1 = DateTime(2023, 01, 01);
  DateTime date2 = DateTime(2023, 02, 01);
  print("Days between: ${date1.daysBetween(date2)}");

  // Bool extension örnekleri
  bool boolValue1 = true;
  bool boolValue2 = false;
  print("True AND False: ${boolValue1.and(boolValue2)}");
  print("True OR False: ${boolValue1.or(boolValue2)}");
  print("NOT True: ${boolValue1.not()}");

  // Set extension: Yinelenen elemanları kaldırma
  Set<int> testSet = {1, 2, 3, 3, 4, 5, 5};
  print("Set without duplicates: ${testSet.removeDuplicates()}");

  // Map extension: Soyadına göre grupla
  Map<String, String> familyMembers = {
    "John": "Doe",
    "Jane": "Doe",
    "Mike": "Smith",
    "Alice": "Johnson"
  };
  print("Grouped by surname: ${familyMembers.groupBySurname()}");
}

class NeonAcademyMember {
  final String name;
  int? motivationLevel;

  NeonAcademyMember({required this.name, this.motivationLevel});
}

// 1. increaseMotivation
void increaseMotivation(NeonAcademyMember member, int amount) {
  if (member.motivationLevel == null) {
    member.motivationLevel = 1;
  } else {
    member.motivationLevel = member.motivationLevel! + amount;
  }
}

// 2. guard let gibi motivasyon durumunu yazdır
void printMotivationMessage(NeonAcademyMember member) {
  final motivation = member.motivationLevel;
  if (motivation == null) {
    print("This member has no motivation level set");
    return;
  }

  if (motivation > 5) {
    print("This member is highly motivated");
  } else {
    print("This member is moderately motivated");
  }
}

// 3. Motivasyon seviyesine göre açıklama döndür
String motivationStatus(int? motivationLevel) {
  if (motivationLevel == null) return "Not motivated at all";
  if (motivationLevel > 5) return "Highly motivated";
  if (motivationLevel > 2) return "Moderately motivated";
  return "Not motivated at all";
}

// 4. Nil coalescing gibi: null ise 0 döndür
int getMotivationOrZero(NeonAcademyMember member) {
  return member.motivationLevel ?? 0;
}

// 5. if let gibi: mevcut motivasyon varsa hedefi geçti mi?
bool isMotivatedEnough(NeonAcademyMember member, int targetLevel) {
  final level = member.motivationLevel;
  if (level == null) return false;
  return level >= targetLevel;
}

void main() {
  // Üye oluştur
  final member = NeonAcademyMember(name: "Sarah");

  // Başlangıç durumu
  print("\n--- Başlangıç ---");
  print("Motivasyon seviyesi: ${member.motivationLevel}");
  printMotivationMessage(member);

  // Motivasyonu artır
  print("\n--- Motivasyon Artışı ---");
  increaseMotivation(member, 3);
  print("Yeni motivasyon: ${member.motivationLevel}");
  printMotivationMessage(member);

  // Tekrar artır
  print("\n--- Tekrar Artış ---");
  increaseMotivation(member, 4);
  print("Yeni motivasyon: ${member.motivationLevel}");
  printMotivationMessage(member);

  // Motivasyon durumu yorumla
  print("\n--- Motivasyon Durumu (Fonksiyon) ---");
  print("Durum: ${motivationStatus(member.motivationLevel)}");

  // Nil coalescing kontrolü
  print("\n--- Motivasyon ya da Sıfır ---");
  print("Gerçek motivasyon: ${getMotivationOrZero(member)}");

  // Hedef motivasyon kontrolü
  print("\n--- Hedef Motivasyon Karşılaştır ---");
  print("5'e eşit ya da fazla mı? ${isMotivatedEnough(member, 5)}");
  print("10'a eşit ya da fazla mı? ${isMotivatedEnough(member, 10)}");
}

class ContactInformation {
  String phoneNumber;
  String email;

  ContactInformation({required this.phoneNumber, required this.email});
}

class NeonAcademyMember {
  String fullName;
  String title;
  String horoscope;
  String memberLevel;
  String homeTown;
  int age;
  ContactInformation contactInformation;

  NeonAcademyMember({
    required this.fullName,
    required this.title,
    required this.horoscope,
    required this.memberLevel,
    required this.homeTown,
    required this.age,
    required this.contactInformation,
  });
}


void printMemberNames(List<NeonAcademyMember> members) {
  for (var member in members) {
    print(member.fullName);
  }
}


void removeThirdMember(List<NeonAcademyMember> members) {
  print("Before removing the third member:");
  printMemberNames(members);


  if (members.length >= 3) {
    members.removeAt(2);
  }

  print("After removing the third member:");
  printMemberNames(members);
}


void sortMembersByAge(List<NeonAcademyMember> members) {
  members.sort((a, b) => b.age.compareTo(a.age));
  print("Members sorted by age (largest to smallest):");
  printMemberNames(members);
}


void sortMembersByName(List<NeonAcademyMember> members) {
  members.sort((a, b) => b.fullName.compareTo(a.fullName));
  print("Members sorted by name (Z-A):");
  printMemberNames(members);
}


void filterMembersByAge(List<NeonAcademyMember> members, int ageLimit) {
  var filteredMembers = members.where((member) => member.age > ageLimit).toList();
  print("Members older than $ageLimit:");
  printMemberNames(filteredMembers);
}


void countIOSDevelopers(List<NeonAcademyMember> members) {
  var iosCount = members.where((member) => member.title == 'IOS Developer').length;
  print("Total number of iOS Developers: $iosCount");
}


void addNewMember(List<NeonAcademyMember> members) {
  ContactInformation newMemberContact = ContactInformation(
    phoneNumber: '111-222-3333',
    email: 'mentor@example.com',
  );

  NeonAcademyMember newMember = NeonAcademyMember(
    fullName: 'Mentor Name',
    title: 'Mentor',
    horoscope: 'Sagittarius',
    memberLevel: 'Expert',
    homeTown: 'Global',
    age: 40,
    contactInformation: newMemberContact,
  );

  members.add(newMember);
  print("After adding a new member:");
  printMemberNames(members);
}


void removeMembersByLevel(List<NeonAcademyMember> members, String level) {
  members.removeWhere((member) => member.memberLevel == level);
  print("After removing members with level $level:");
  printMemberNames(members);
}


void findOldestMember(List<NeonAcademyMember> members) {
  var oldestMember = members.reduce((a, b) => a.age > b.age ? a : b);
  print("The oldest member is: ${oldestMember.fullName}, Age: ${oldestMember.age}");
}


void findLongestNameMember(List<NeonAcademyMember> members) {
  var longestNameMember = members.reduce((a, b) => a.fullName.length > b.fullName.length ? a : b);
  print("The member with the longest name is: ${longestNameMember.fullName}, Length: ${longestNameMember.fullName.length}");
}


void groupMembersByHoroscope(List<NeonAcademyMember> members) {
  var horoscopeGroups = <String, List<NeonAcademyMember>>{};

  for (var member in members) {
    if (!horoscopeGroups.containsKey(member.horoscope)) {
      horoscopeGroups[member.horoscope] = [];
    }
    horoscopeGroups[member.horoscope]!.add(member);
  }

  horoscopeGroups.forEach((horoscope, group) {
    print("Members with horoscope $horoscope:");
    printMemberNames(group);
  });
}


void findMostCommonHometown(List<NeonAcademyMember> members) {
  var hometownCount = <String, int>{};

  for (var member in members) {
    hometownCount[member.homeTown] = (hometownCount[member.homeTown] ?? 0) + 1;
  }

  var mostCommonTown = hometownCount.entries.reduce((a, b) => a.value > b.value ? a : b);
  print("The most common hometown is: ${mostCommonTown.key}");
}


void calculateAverageAge(List<NeonAcademyMember> members) {
  var totalAge = members.fold<int>(0, (sum, member) => sum + member.age);
  var averageAge = totalAge / members.length;
  print("The average age of members is: $averageAge");
}


void printContactInfo(List<NeonAcademyMember> members) {
  var contactInfos = members.map((member) => member.contactInformation.email).toList();
  print("Contact information (emails) of all members:");
  contactInfos.forEach(print);
}


void sortMembersByLevel(List<NeonAcademyMember> members) {
  members.sort((a, b) => b.memberLevel.compareTo(a.memberLevel));
  print("Members sorted by memberLevel (highest to lowest):");
  printMemberNames(members);
}

void printContactInfoByTitle(List<NeonAcademyMember> members, String title) {
  // Aynı unvana sahip üyeleri filtrele (küçük harf duyarsız karşılaştırma)
  var filteredMembers = members.where((member) =>
  member.title.toLowerCase() == title.toLowerCase()).toList();

  // Filtered üyeleri yazdıralım
  print("Filtered members with title '$title':");
  filteredMembers.forEach((member) {
    print(member.fullName);  // Üyelerin isimlerini yazdırıyoruz
  });

  // Filtrelenen üyelerin telefon numaralarını alalım
  var contactInfos = filteredMembers.map((member) => member.contactInformation.phoneNumber).toList();

  // Telefon numaralarını yazdıralım
  print("Phone numbers of all members with title '$title':");

  // Eğer filterlenmiş üyeler varsa, yazdırma işlemine geçelim
  if (contactInfos.isEmpty) {
    print("No members found with the title '$title'.");
  } else {
    contactInfos.forEach((phoneNumber) {
      print(phoneNumber);
    });
  }
}


void main() {
  ContactInformation member1Contact = ContactInformation(
    phoneNumber: '123-456-789110',
    email: 'member1@example.com',
  );

  ContactInformation member2Contact = ContactInformation(
    phoneNumber: '098-765-4321',
    email: 'member2@example.com',
  );
  ContactInformation member3Contact = ContactInformation(
    phoneNumber: '012-7652-43212',
    email: 'member3@example.com',
  );
  ContactInformation member4Contact = ContactInformation(
    phoneNumber: '092118-72165-43321',
    email: 'member4@example.com',
  );

  NeonAcademyMember member1 = NeonAcademyMember(
    fullName: 'Alice Smith',
    title: 'Flutter Developer',
    horoscope: 'Leo',
    memberLevel: 'Advanced',
    homeTown: 'New York',
    age: 30,
    contactInformation: member1Contact,
  );

  NeonAcademyMember member2 = NeonAcademyMember(
    fullName: 'Bob Johnson',
    title: 'UI/UX Developer',
    horoscope: 'Virgo',
    memberLevel: 'Intermediate',
    homeTown: 'Los Angeles',
    age: 25,
    contactInformation: member2Contact,
  );

  NeonAcademyMember member3 = NeonAcademyMember(
    fullName: 'Doruk Alan',
    title: 'IOS Developer',
    horoscope: 'Leo',
    memberLevel: 'Advanced',
    homeTown: 'Istanbul',
    age: 23,
    contactInformation: member3Contact,
  );

  NeonAcademyMember member4 = NeonAcademyMember(
    fullName: 'Asım Ağda',
    title: 'Flutter Developer',
    horoscope: 'Leo',
    memberLevel: 'Advanced',
    homeTown: 'New York',
    age: 50,
    contactInformation: member4Contact,
  );

  List<NeonAcademyMember> members = [member1, member2, member3, member4];

  removeThirdMember(members);
  sortMembersByAge(members);
  sortMembersByName(members);
  filterMembersByAge(members, 24);
  countIOSDevelopers(members);
  addNewMember(members);
  removeMembersByLevel(members, "Intermediate");
  findOldestMember(members);
  findLongestNameMember(members);
  groupMembersByHoroscope(members);
  findMostCommonHometown(members);
  calculateAverageAge(members);
  printContactInfo(members);
  sortMembersByLevel(members);
  printContactInfoByTitle(members, 'Flutter Developer');
}

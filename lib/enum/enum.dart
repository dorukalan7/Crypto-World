enum Team {
  FlutterDevelopment,
  UIUXDesign,
  IOSTeam,
  BackendTeam,
}


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
  Team team;

  NeonAcademyMember({
    required this.fullName,
    required this.title,
    required this.horoscope,
    required this.memberLevel,
    required this.homeTown,
    required this.age,
    required this.contactInformation,
    required this.team,
  });
}


List<NeonAcademyMember> getMembersByTeam(List<NeonAcademyMember> members, Team team) {
  return members.where((member) => member.team == team).toList();
}


void printMemberNamesByTeam(List<NeonAcademyMember> members, Team team) {
  var teamMembers = getMembersByTeam(members, team);
  print("Members in the ${team.toString().split('.').last} Team:");
  teamMembers.forEach((member) => print(member.fullName));
}


void printTeamMemberCount(List<NeonAcademyMember> members) {
  var teamCount = <Team, int>{};

  for (var member in members) {
    teamCount[member.team] = (teamCount[member.team] ?? 0) + 1;
  }

  print("Number of members in the UI/UX Design Team: ${teamCount[Team.UIUXDesign]}");
  print("Number of members in the Flutter Development Team: ${teamCount[Team.FlutterDevelopment]}");
  print("Number of members in the iOS Development Team: ${teamCount[Team.IOSTeam]}");
  print("Number of members in the Backend Team: ${teamCount[Team.BackendTeam]}");
}


void printTeamDescription(NeonAcademyMember member) {
  switch (member.team) {
    case Team.FlutterDevelopment:
      print("This member is a skilled Flutter developer.");
      break;
    case Team.UIUXDesign:
      print("This member is a talented designer.");
      break;
    case Team.IOSTeam:
      print("This member is a skilled iOS Developer.");
      break;
    case Team.BackendTeam:
      print("This member is a great backend developer.");
      break;
    default:
      print("This member is a great contributor.");
  }
}


void printMembersOlderThanAge(List<NeonAcademyMember> members, Team team, int ageLimit) {
  var teamMembers = getMembersByTeam(members, team);
  var olderMembers = teamMembers.where((member) => member.age > ageLimit).toList();
  print("Members older than $ageLimit in the ${team.toString().split('.').last} Team:");
  olderMembers.forEach((member) => print(member.fullName));
}


void promoteMemberBasedOnTeam(NeonAcademyMember member) {
  switch (member.team) {
    case Team.FlutterDevelopment:
      print("${member.fullName} is promoted to Senior Flutter Developer");
      break;
    case Team.UIUXDesign:
      print("${member.fullName} is promoted to Lead Designer");
      break;
    case Team.IOSTeam:
      print("${member.fullName} is promoted to Senior iOS Developer");
      break;
    case Team.BackendTeam:
      print("${member.fullName} is promoted to Senior Backend Developer");
      break;
    default:
      print("${member.fullName} is promoted to a higher role");
  }
}


void calculateAverageAge(List<NeonAcademyMember> members, Team team) {
  var teamMembers = getMembersByTeam(members, team);
  if (teamMembers.isEmpty) {
    print("No members in the ${team.toString().split('.').last} Team.");
    return;
  }
  var totalAge = teamMembers.fold<int>(0, (sum, member) => sum + member.age);
  var averageAge = totalAge / teamMembers.length;
  print("The average age of members in the ${team.toString().split('.').last} Team is: $averageAge");
}


void printTeamMessage(Team team) {
  switch (team) {
    case Team.FlutterDevelopment:
      print("The Flutter Development Team is the backbone of our academy.");
      break;
    case Team.UIUXDesign:
      print("The UI/UX Design Team is the face of our academy.");
      break;
    case Team.IOSTeam:
      print("The iOS Development Team is the mobile powerhouse of our academy.");
      break;
    case Team.BackendTeam:
      print("The Backend Team powers the infrastructure of our academy.");
      break;
    default:
      print("This team is a valuable contributor to the academy.");
  }
}


List<ContactInformation> getContactInformationByTeam(List<NeonAcademyMember> members, Team team) {
  var teamMembers = getMembersByTeam(members, team);
  return teamMembers.map((member) => member.contactInformation).toList();
}


void printMemberAgeAndTeamInfo(NeonAcademyMember member) {
  switch (member.team) {
    case Team.FlutterDevelopment:
      if (member.age > 23) {
        print("${member.fullName} is a seasoned Flutter developer.");
      } else {
        print("${member.fullName} is a rising star in Flutter development.");
      }
      break;
    case Team.UIUXDesign:
      if (member.age < 24) {
        print("${member.fullName} is a rising star in the design world.");
      } else {
        print("${member.fullName} is a seasoned designer.");
      }
      break;
    default:
      print("${member.fullName} is a valuable member.");
  }
}

void printTeamBasedMessage(NeonAcademyMember member) {
  switch (member.team) {
    case Team.FlutterDevelopment:
      print("${member.fullName} is a skilled Flutter developer.");
      break;
    case Team.UIUXDesign:
      print("${member.fullName} is a talented designer.");
      break;
    case Team.IOSTeam:
      print("${member.fullName} is a skilled iOS developer.");
      break;
    case Team.BackendTeam:
      print("${member.fullName} is a great backend developer.");
      break;
    default:
      print("${member.fullName} is a great contributor.");
  }
}


void main() {
  ContactInformation member1Contact = ContactInformation(phoneNumber: '123-456-789110', email: 'member1@example.com');
  ContactInformation member2Contact = ContactInformation(phoneNumber: '098-765-4321', email: 'member2@example.com');
  ContactInformation member3Contact = ContactInformation(phoneNumber: '012-7652-43212', email: 'member3@example.com');
  ContactInformation member4Contact = ContactInformation(phoneNumber: '092118-72165-43321', email: 'member4@example.com');

  NeonAcademyMember member1 = NeonAcademyMember(
    fullName: 'Alice Smith',
    title: 'Flutter Developer',
    horoscope: 'Leo',
    memberLevel: 'Advanced',
    homeTown: 'New York',
    age: 30,
    contactInformation: member1Contact,
    team: Team.FlutterDevelopment,
  );

  NeonAcademyMember member2 = NeonAcademyMember(
    fullName: 'Bob Johnson',
    title: 'UI/UX Developer',
    horoscope: 'Virgo',
    memberLevel: 'Intermediate',
    homeTown: 'Los Angeles',
    age: 25,
    contactInformation: member2Contact,
    team: Team.UIUXDesign,
  );

  NeonAcademyMember member3 = NeonAcademyMember(
    fullName: 'Doruk Alan',
    title: 'IOS Developer',
    horoscope: 'Leo',
    memberLevel: 'Advanced',
    homeTown: 'Istanbul',
    age: 23,
    contactInformation: member3Contact,
    team: Team.IOSTeam,
  );

  NeonAcademyMember member4 = NeonAcademyMember(
    fullName: 'Asım Ağda',
    title: 'Flutter Developer',
    horoscope: 'Leo',
    memberLevel: 'Advanced',
    homeTown: 'New York',
    age: 50,
    contactInformation: member4Contact,
    team: Team.FlutterDevelopment,
  );

  List<NeonAcademyMember> members = [member1, member2, member3, member4];

  printMemberNamesByTeam(members, Team.FlutterDevelopment);
  printTeamMemberCount(members);
  printMembersOlderThanAge(members, Team.FlutterDevelopment, 25);
  promoteMemberBasedOnTeam(member1);
  calculateAverageAge(members, Team.FlutterDevelopment);
  printTeamMessage(Team.FlutterDevelopment);
  var contactInfo = getContactInformationByTeam(members, Team.FlutterDevelopment);
  contactInfo.forEach((contact) => print("Phone: ${contact.phoneNumber}, Email: ${contact.email}"));
  printMemberAgeAndTeamInfo(member1);
  printTeamBasedMessage(member1);
  printTeamBasedMessage(member2);
}

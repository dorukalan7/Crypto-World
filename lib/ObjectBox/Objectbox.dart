import 'package:objectbox/objectbox.dart';

@Entity()
class CoralFragment {
  int id;

  String title;
  String species;
  String date;
  String details;

  CoralFragment({
    this.id = 0,
    required this.title,
    required this.species,
    required this.date,
    required this.details,
  });
}

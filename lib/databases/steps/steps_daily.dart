import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class Steps_Daily {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  //step value
  final int steps;

  //when the step was recorded
  final DateTime dateTime;

  //patient id
  final String patient; 

  //Default constructor
  Steps_Daily({this.id, required this.steps, required this.dateTime, required this.patient});
  
}//Todo
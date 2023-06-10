import 'package:project_app/databases/steps_daily.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class StepDao {
  //Query #0: SELECT -> this allows to obtain all the entries of the Steps_Daily table of a certain date
  @Query('SELECT * FROM Steps_Daily WHERE dateTime between :startTime and :endTime ORDER BY dateTime ASC')
  Future<List<Steps_Daily>> findStepsbyDate(DateTime startTime, DateTime endTime);

  //Query #1: SELECT -> this allows to obtain all the entries of the steps_daily table
  @Query('SELECT * FROM Steps_Daily')
  Future<List<Steps_Daily>> findAllSteps();

  //Query #2: INSERT -> this allows to add a row in the table
  @insert
  Future<void> insertSteps(Steps_Daily steps_daily); // void ensures that the results are not returned

  //Query #3: DELETE -> this allows to delete a row from the table
  @delete
  Future<void> deleteSteps(Steps_Daily steps_daily);

}//TodoDao
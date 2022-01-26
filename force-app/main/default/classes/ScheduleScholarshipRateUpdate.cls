public class ScheduleScholarshipRateUpdate implements Schedulable{
	 public void execute(SchedulableContext sc) {
     	ScholarshipRate sr = new ScholarshipRate();
	 	Id batchId = Database.executeBatch(sr);
     }
}
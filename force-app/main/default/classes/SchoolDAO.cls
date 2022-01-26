public class SchoolDAO {
    
    public static Map<Id, Decimal> getStudentPerformance(Set<Id> studentIds) {     
        Map<Id, Decimal> studentAverageGrade = new Map<Id, Decimal>();
        for (Student__c curStu : [
        		SELECT Average_Grade__c 
                FROM Student__c 
                WHERE Id in: studentIds
        		]) {
           studentAverageGrade.put(curStu.Id, curStu.Average_Grade__c); 
        }
        System.debug(studentAverageGrade);
        return studentAverageGrade;    
    }
    
    /* Fast test 1:
    Set<Id> studId = new Set<Id>{'a010900001Y0rRqAAJ', 'a010900001XzrW4AAJ'};
	SchoolDAO.getStudentPerformance(studId);
	*/	

    public static Map<Id, Integer> getClassAttendance() {
        Map<Id, Integer> numberOfStudents = new Map<Id, Integer>();
        for (AggregateResult ar : [
            	SELECT Class_Enrollment__c.Class__r.Id, COUNT(Student__c)
				FROM Class_Enrollment__c
				GROUP BY Class_Enrollment__c.Class__r.Id
        	]){
                numberOfStudents.put((Id)ar.get('Id'), (Integer)ar.get('expr0'));
        }
       	System.Debug(numberOfStudents);
        return numberOfStudents;
    }
    
    
    
    public static List<Class_Enrollment__c> getTopStudents(Id classId) {
        List<Class_Enrollment__c> topStudents = [
            	SELECT Student__c, Grade__c 
            	FROM Class_Enrollment__c 
            	WHERE Class_Enrollment__c.class__r.Id =: classId
            	ORDER BY Grade__c DESC LIMIT 10    
        		];
        System.debug(topStudents);
        return topStudents;
    }
	/*	Fast Test 3:
		Id classId = 'a000900000GmIscAAF';
		SchoolDAO.getTopStudents(classId);
    */
    public static List<Student__c> getStudentsWithScholarship(Id classId) {
        List<String> Scholarships = new List<String> {'Regular', 'Increased', 'Academic'};
        List<Id> hasScholarshipId = new List<Id>();
        for (Class_Enrollment__c curEnr :  [
             	SELECT Class_Enrollment__c.Student__r.Id
             	FROM Class_Enrollment__c
             	WHERE Class_Enrollment__c.Class__c =: classId
             	AND Class_Enrollment__c.Student__r.Scholarship__c in: Scholarships 
        	]){
        	hasScholarshipId.add(curEnr.Student__r.Id);                                
        }
        List<Student__c> hasScholarship = [
            SELECT Student__c.Id, Name
            FROM Student__c
            WHERE Student__c.Id in: hasScholarshipId
        ];
        System.Debug(hasScholarship);
        return hasScholarship;
    }
    /* Fast Test 4:
      Id classId = 'a000900000GmIscAAF';
      SchoolDAO.getStudentsWithScholarship(classId);
	*/
}
public class SchoolService {

    // Create class enrollment for given class and student.

    public static void enrollStudentToClass (Id studentId, Id classId) {
        Class_Enrollment__c newClassEnr = new Class_Enrollment__c(Student__c = studentId, Class__c = classId);
        try {
            insert newClassEnr;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    //Set grade based on given class and student.

    public void setGrade (Id studentId, Id classId, Integer grade) {
        Class_Enrollment__c classEnrtoUpdate = [SELECT Grade__c                                // Write the limit on creating
                                                FROM Class_Enrollment__c                                // junction wich use already
                                                WHERE Student__c =: studentId       // related class and student
                                                AND Class__c =: classId];
        classEnrToUpdate.Grade__c = grade;
            update classEnrToUpdate;
        
    }

    //Set grade for given class enrollment.

    public void setGrade (Id classEnrollmentId, Integer grade) {
        Class_Enrollment__c classEnrtoUpdate = [SELECT Grade__c
                                                FROM Class_Enrollment__c
                                                WHERE Id =: classEnrollmentId];
        classEnrToUpdate.Grade__c = grade;
        try {
            update classEnrToUpdate;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    //Assign academic scholarship to a given student.

    public static void setAcademicScholarship (Id studentId) {
        Student__c studentToUpdate = [SELECT Scholarship__c
                                      FROM Student__c
                                      WHERE Id =: studentId];
        if (studentToUpdate != null){
            studentToUpdate.Scholarship__c = 'Academic';
            update studentToUpdate;
    	}
    }

    /*  Calculate if the student has a scholarship by the results of the year.
        In order to have a scholarship, students must have an average grade between 71 and 87 of all attended classes.
        In order to have increased scholarship, students must have an average grade higher than 88 of all attended classes.
        If at least one class enrollment has no grade - a scholarship cannot be assigned yet.
    */

    public static void recalculateScholarship(Id studentId) {
        String scholarship ;
        List<Class_Enrollment__c> classEnrol = new List<Class_Enrollment__c>([SELECT Student__c, Grade__c, Student__r.Average_Grade__c
                              FROM Class_Enrollment__c
                              WHERE Student__c =: studentId AND CreatedDate = THIS_YEAR
                              ORDER BY Grade__c NULLS FIRST
                              LIMIT 1]);

            if (classEnrol.isEmpty() || classEnrol[0].Grade__c == null) {
                System.debug('A scholarship cannot be assigned yet.');
                return ;
            }
            Decimal averageGrade = classEnrol[0].Student__r.Average_Grade__c;  

            if (averageGrade >= 71.0) {
                scholarship = 'Regular';
                if (averageGrade >= 88.0) {
                    scholarship = 'Increased';
                }
            } else {
                System.debug('Average Grade is lower then 71');
                scholarship = 'Unassigned';
            }

            Student__c studentToUpdate = classEnrol[0].Student__r;
            studentToUpdate.Scholarship__c = scholarship;
            update studentToUpdate;
            
    }
}
public with sharing class ClassEnrollmentTriggerHandler {
    
    //The system should prevent creating more than one Class Enrollment for the same Class and Student.

   public static void validateRelation (List<Class_Enrollment__c> enrollFromTrigger) {
       Set<Id> studentIds = new Set<Id>();
       for (Class_Enrollment__c ce : enrollFromTrigger) {
      	  studentIds.add(ce.Student__c);
       }
       List<Class_Enrollment__c> exEnroll = [ SELECT Id, Student__r.Id, Class__r.Id   //select existed Class_Enrollment
      										 FROM Class_Enrollment__c
      										 WHERE Student__c IN: studentIds];
       for (Class_Enrollment__c tr : enrollFromTrigger) {
           for (Class_Enrollment__c ex : exEnroll) {     
               if (tr.Student__c == ex.Student__r.Id && tr.Class__c == ex.Class__r.Id) {
                   tr.Class__c.addError('The student is already studying in this class!');
               }
           }
       }
   }
    
   //The system should prevent creating Class Enrollment if the Student's Year of Study is not one of the Class's Year of Study.
    
   public static void validateYearOfStudy(List<Class_Enrollment__c> enrollFromTrigger) {
       Set<Id> studentIds = new Set<Id>();
       Set<Id> classIds = new Set<Id>();
       for (Class_Enrollment__c ce : enrollFromTrigger) {
           studentIds.add(ce.Student__c);
           classIds.add(ce.Class__c);
       }
       Map<Id, Student__c> studentsMap = new Map<Id, Student__c> ([
               SELECT Id, Year_of_Study__c
               FROM Student__c
               WHERE Id IN:studentIds
       ]);
       Map<Id, Class__c> classesMap = new Map<Id, Class__c>([
               SELECT Id, Year_of_Study__c
               FROM Class__c
               WHERE Id IN:classIds
       ]);

       for (Class_Enrollment__c tr : enrollFromTrigger) {
           Class__c classYears = classesMap.get(tr.Class__c);
           Student__c studentYear = studentsMap.get(tr.Student__c);
           List<String> classYearsSplt = classYears.Year_of_Study__c.split(';');
           if (!classYearsSplt.contains(studentYear.Year_of_Study__c)) {
               tr.Class__c.addError('A student cannot study in this class in the current year of study');
           }
       }
   }

}
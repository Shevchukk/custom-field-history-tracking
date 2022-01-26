public with sharing class StudentWithScholarshipsController {
    @AuraEnabled
    public static List<Student__c> getStudentsWithScholarship (Integer limitList) {
        return [SELECT Id, Name, Year_of_Study__c, Email__c, Average_Grade__c, Scholarship__c
                FROM Student__c
                WHERE Scholarship__c != 'Unassigned'
                ORDER BY Average_Grade__c DESC
                LIMIT :limitList];
    }

}
@RestResource(UrlMapping='/TopFiveStudents/*')
global with sharing class StudentConrollerREST {

    @HttpGet
    global static List<Student__c> getTopStudents() {
        return [SELECT Id, Name, Average_Grade__c FROM Student__c ORDER BY Average_Grade__c DESC LIMIT 5 ];
    }

}
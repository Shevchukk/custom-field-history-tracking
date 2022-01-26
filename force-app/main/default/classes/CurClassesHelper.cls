public with sharing class CurClassesHelper {

    @AuraEnabled(Cacheable=true)
    public static List<Class_Enrollment__c> getClasses(Id curRecordId) {
        String curYear = String.valueOf(System.today().year());

        return [SELECT Class__r.Name, Class__r.Subject__c, Grade__c
                FROM Class_Enrollment__c
                WHERE Class__r.Year__c =:curYear  AND Student__c =: curRecordId];
    }
}
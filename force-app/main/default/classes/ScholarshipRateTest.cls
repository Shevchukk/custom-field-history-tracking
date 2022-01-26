@isTest
private with sharing class ScholarshipRateTest {
    @testSetup
    static void setup() {
        List<Student__c> students = new List<Student__c>();
        List<String> scholar = new List<String>{'Unassigned', 'Regular', 'Increased', 'Academic'};
        for (Integer i = 0; i < 200; i++) {
                Integer s = Math.mod(i,4);
                students.add(new Student__c(name = 'Student ' + i, Year_of_Study__c = '5',
                        Scholarship__c = scholar[s] ));//s must be from 0 to 3;
        }
        insert students;

    }
    @isTest static void butchTest() {
        Integer rate = 0;
        Test.startTest();
        ScholarshipRate ts = new ScholarshipRate();
        Id batchId = Database.executeBatch(ts);
        Test.stopTest();
        System.assertEquals(50,
            [SELECT COUNT() FROM Student__c WHERE Scholarship_Rate__c = :rate ],
                'Class should return 50 records');
    }

}
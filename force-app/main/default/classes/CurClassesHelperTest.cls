@IsTest
private class CurClassesHelperTest {

    @TestSetup static void setup() {
        Student__c s1 = new Student__c(Name = 'Student 1', Year_of_Study__c = '3', Average_Grade__c = 5);

        insert s1;

        Class__c c1 = new Class__c(Subject__c = 'Algebra', Year_of_Study__c = '3', Year__c = '2021');
        Class__c c2 = new Class__c(Subject__c = 'Biology', Year_of_Study__c = '3', Year__c = '2021');
        insert new List<Class__c>{c1, c2};

        Class_Enrollment__c e1 = new Class_Enrollment__c(Class__c = c1.Id , Student__c = s1.Id , Grade__c = 5);
        Class_Enrollment__c e2 = new Class_Enrollment__c(Class__c = c2.Id , Student__c = s1.Id , Grade__c = 77);


        insert new List<Class_Enrollment__c>{e1, e2};
    }
    @IsTest
    static void getClassesTest() {
        Test.startTest();
        Id testRecordId = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0).Id;
        List<Class_Enrollment__c> actualResult = CurClassesHelper.getClasses(testRecordId);
        Test.stopTest();

        System.assertEquals(
                2,
                actualResult.size(),
                'CurClassesHelper.getClasses should return 2 classes'
        );
    }
}
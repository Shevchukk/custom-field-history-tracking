@IsTest
private class StudentWithScholarshipsControllerTest {
    @TestSetup static void setup() {
        Student__c s1 = new Student__c(Name = 'Student 1', Year_of_Study__c = '3', Average_Grade__c = 5, Scholarship__c = 'Regular');
        Student__c s2 = new Student__c(Name = 'Student 2', Year_of_Study__c = '3', Average_Grade__c = 5, Scholarship__c = 'Increased');
        Student__c s3 = new Student__c(Name = 'Student 3', Year_of_Study__c = '3', Average_Grade__c = 5, Scholarship__c = 'Academic');
        insert new List<Student__c>{
                s1, s2, s3
        };
    }

    @IsTest
    static void getStudentsWithScholarshipTest() {
        Test.startTest();
        List<Student__c> actualResult = StudentWithScholarshipsController.getStudentsWithScholarship(3);
        Test.stopTest();

        System.assertEquals(
            3,
            actualResult.size(),
            'StudentWithScholarshipsController.getStudentsWithScholarship should return 3 students'
            );
    }
}
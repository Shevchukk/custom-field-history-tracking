@isTest 
private class ClassEnrollmentTriggerTest {
    
    @TestSetup static void setup() {
		Student__c s1 = new Student__c(Name = 'Student 1', Year_of_Study__c = '3');
    	Class__c c1 = new Class__c(Subject__c = 'Algebra', Year_of_Study__c = '3');
        Class__c c2 = new Class__c(Subject__c = 'Biology', Year_of_Study__c = '1;2');
        Class__c c3 = new Class__c(Subject__c = 'Geometry', Year_of_Study__c = '3');
        insert s1;
        insert new List<Class__c>{c1, c2, c3};
        Class_Enrollment__c e1 = new Class_Enrollment__c(Class__c = c1.Id , Student__c = s1.Id , Grade__c = 58);
        insert e1;
    }
    
    //positive test
    @isTest static void withoutDuplicateRelationInTrigger() {   
        DmlException unexpectedException;
        test.startTest();
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        Class__c classC3 = [SELECT Id FROM Class__c WHERE Subject__c = 'Geometry'].get(0);
        Class_Enrollment__c classEnrollmetOnTrigger = new Class_Enrollment__c(Class__c = classC3.Id , Student__c = studentS1.Id , Grade__c = 95);
        try {
            insert classEnrollmetOnTrigger;
        } catch (DmlException e) {
            unexpectedException = e;
        }
		test.StopTest();
        
        System.assertEquals( 
            null, 
            unexpectedException,
            'The record should be saved'
        );
    } 
    
     // negative test
     @isTest static void preventDuplicateRelationTrigger() { 
        DmlException expectedException;
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        Class__c classC1 = [SELECT Id FROM Class__c WHERE Subject__c = 'Algebra'].get(0);
        Class_Enrollment__c classEnrollmetOnTrigger = new Class_Enrollment__c(Class__c = classC1.Id , Student__c = studentS1.Id , Grade__c = 95);
         test.startTest();
        try {
            insert classEnrollmetOnTrigger;
        } catch (DmlException e) {
            expectedException = e;
        }
		test.StopTest();
        
        System.assertNotEquals(
            null,
            expectedException, 
            'The record can`t be duplicated'
        );
    }
    
    
    //positive test
    @isTest static void validYearOfStudyInTrigger() {   
        DmlException unexpectedException;
        test.startTest();
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        Class__c classC3 = [SELECT Id FROM Class__c WHERE Subject__c = 'Geometry'].get(0);
        Class_Enrollment__c classEnrollmetOnTrigger = new Class_Enrollment__c(Class__c = classC3.Id , Student__c = studentS1.Id , Grade__c = 95);
        try {
            insert classEnrollmetOnTrigger;
        } catch (DmlException e) {
            unexpectedException = e;
        }
		test.StopTest();
        
        System.assertEquals( 
            null, 
            unexpectedException, 
            'The record should be saved'
        );
    }
    
    //negative test
    @isTest static void invalidYearOfStudyInTrigger() {
        DmlException expectedException;
        test.startTest();
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        Class__c classC2 = [SELECT Id FROM Class__c WHERE Subject__c = 'Biology'].get(0);
        Class_Enrollment__c classEnrollmetOnTrigger = new Class_Enrollment__c(Class__c = classC2.Id , Student__c = studentS1.Id , Grade__c = 95);
        try {
            insert classEnrollmetOnTrigger;
        } catch (DmlException e) {
            expectedException = e;
        }
		test.StopTest();
        
        System.assertNotEquals(
            null, 
            expectedException, 
            'Must be exception'
        );
    }
}
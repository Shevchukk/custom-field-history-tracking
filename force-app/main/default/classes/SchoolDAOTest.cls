@isTest
private class SchoolDAOTest {
    
    @testSetup static void setup() {
        Student__c s1 = new Student__c(Name = 'Student 1', Year_of_Study__c = '3', Scholarship__c = 'Regular');
        Student__c s2 = new Student__c(Name = 'Student 2', Year_of_Study__c = '3', Scholarship__c = 'Unassigned');
        insert new List<Student__c>{s1, s2};
        
		Class__c c1 = new Class__c(Subject__c = 'Algebra', Year_of_Study__c = '3');
        Class__c c2 = new Class__c(Subject__c = 'Biology', Year_of_Study__c = '3');
        insert new List<Class__c>{c1, c2};
            
        Class_Enrollment__c e1 = new Class_Enrollment__c(Class__c = c1.Id , Student__c = s1.Id , Grade__c = 56);
        Class_Enrollment__c e2 = new Class_Enrollment__c(Class__c = c1.Id , Student__c = s2.Id , Grade__c = 32);
        Class_Enrollment__c e3 = new Class_Enrollment__c(Class__c = c2.Id , Student__c = s1.Id , Grade__c = 87);
        Class_Enrollment__c e4 = new Class_Enrollment__c(Class__c = c2.Id , Student__c = s2.Id , Grade__c = 73);
        insert new List<Class_Enrollment__c>{e1, e2, e3, e4};
    }
    
    
    @isTest static void getStudentPerformanceTest() {
        
        Test.startTest();
        Set<Id> studentIds = (new Map<Id, Student__c>([SELECT Id FROM Student__c])).keySet();
        Map<Id, Decimal> actualResult = SchoolDAO.getStudentPerformance(studentIds);
        Test.stopTest();
            
        System.assertEquals( 
            71.5, 
            actualResult.values().get(0), 
            'SchoolDAO.getStudentPerformance is working incorrectly'
        );
        System.assertEquals( 
            52.5, 
            actualResult.values().get(1), 
            'SchoolDAO.getStudentPerformance is working incorrectly'
        );
    }
    
    
    @isTest static void getClassAttendanceTest() {
        
        Test.startTest();
        Map<Id, Integer> actualResult = SchoolDAO.getClassAttendance();
        Test.stopTest();
            
        System.assertEquals( 
            2, 
            actualResult.values().get(0), 
            'SchoolDAO.getClassAttendanceTest is working incorrectly'
        );
        System.assertEquals( 
            2, 
            actualResult.values().get(1), 
            'SchoolDAO.getStudentPerformance is working incorrectly'
        );
    }
    
    
    @isTest static void getTopStudentsTest() {
        
        Test.startTest();
        Class__c classC1 = [SELECT Id FROM Class__c WHERE Subject__c = 'Algebra'].get(0);
        List<Class_Enrollment__c> actualResult = SchoolDAO.getTopStudents(classC1.Id);
        Test.stopTest();
        
        System.assertEquals( 
            56, 
            actualResult.get(0).grade__c, 
            'SchoolDAO.getTopStudents is working incorrectly'
        );
        System.assertEquals( 
            32, 
            actualResult.get(1).grade__c, 
            'SchoolDAO.getTopStudents is working incorrectly'
        );
    }
    
    @isTest static void getStudentsWithScholarshipTest() {
        
        Test.startTest();
        Class__c classC1 = [SELECT Id FROM Class__c WHERE Subject__c = 'Algebra'].get(0);
        List<Student__c> actualResult = SchoolDAO.getStudentsWithScholarship(classC1.Id);
        Test.stopTest();
        
        System.assertEquals( 
            'Student 1',
            actualResult.get(0).name, 
            'SchoolDAO.getTopStudents is working incorrectly'
        );
        
    }
    

}
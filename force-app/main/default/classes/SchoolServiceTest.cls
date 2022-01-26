@isTest private class SchoolServiceTest {
    
    @testSetup static void setup() {
        Student__c s1 = new Student__c(Name = 'Student 1', Year_of_Study__c = '3', Average_Grade__c = 5);
        Student__c s2 = new Student__c(Name = 'Student 2', Year_of_Study__c = '3', Average_Grade__c = 77);
        Student__c s3 = new Student__c(Name = 'Student 3', Year_of_Study__c = '3', Average_Grade__c = 89);
        Student__c s4 = new Student__c(Name = 'Student 4', Year_of_Study__c = '3', Average_Grade__c = null);
        Student__c s5 = new Student__c(Name = 'Student 5', Year_of_Study__c = '3'); 
        insert new List<Student__c>{s1, s2, s3, s4, s5};
        
		Class__c c1 = new Class__c(Subject__c = 'Algebra', Year_of_Study__c = '3');
        Class__c c2 = new Class__c(Subject__c = 'Biology', Year_of_Study__c = '3');
        insert new List<Class__c>{c1, c2};
            
        Class_Enrollment__c e1 = new Class_Enrollment__c(Class__c = c1.Id , Student__c = s1.Id , Grade__c = 5);
        Class_Enrollment__c e2 = new Class_Enrollment__c(Class__c = c1.Id , Student__c = s2.Id , Grade__c = 77);
        Class_Enrollment__c e3 = new Class_Enrollment__c(Class__c = c2.Id , Student__c = s3.Id , Grade__c = 89);
        Class_Enrollment__c e4 = new Class_Enrollment__c(Class__c = c2.Id , Student__c = s4.Id , Grade__c = NULL);
        
        insert new List<Class_Enrollment__c>{e1, e2, e3, e4};
    }
    
    //positive test
    @isTest static void enrollStudentToClassTest() {
        
        Test.startTest();
        Student__c studentS5 = [SELECT Id FROM Student__c WHERE Name = 'Student 5'].get(0);
        Class__c classC1 = [SELECT Id FROM Class__c WHERE Subject__c = 'Algebra'].get(0);
        SchoolService.enrollStudentToClass(studentS5.Id, classC1.Id);
        List<Class_Enrollment__c> actualResult = [
            SELECT Class__c, Student__c 
            FROM Class_Enrollment__c
            WHERE Class__c =: classC1.Id
            AND  Student__c =: studentS5.Id
        ];
        Test.stopTest();
            
        System.assertEquals( 
            1, 
            actualResult.size(), 
            'School.Service.getStudentPerformance is working incorrectly.'
        );
    }
    
    //negative test
    @isTest static void enrollStudentToClassWrongValueTest() {
        
        Test.startTest();
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        Class__c classC1 = [SELECT Id FROM Class__c WHERE Subject__c = 'Algebra'].get(0);
        SchoolService.enrollStudentToClass(studentS1.Id, classC1.Id);
        List<Class_Enrollment__c> actualResult = [
            SELECT Class__c, Student__c 
            FROM Class_Enrollment__c
            WHERE Class__c =: classC1.Id
            AND  Student__c =: studentS1.Id
        ];
        Test.stopTest();
            
        System.assertEquals( 
            1,
            actualResult.size(), 
            'Class should return empty list'
        );

    }
    
    
    //positive test                                 
    @isTest static void setGradeUsingStudentAndClassTest() {  //+create the negative test
        
        Test.startTest();
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        Class__c classC1 = [SELECT Id FROM Class__c WHERE Subject__c = 'Algebra'].get(0);
        SchoolService setMaxGrade = new SchoolService();
        setMaxGrade.setGrade(studentS1.Id, classC1.Id, 100);
        List<Class_Enrollment__c> actualResult = [
            SELECT Grade__c 
            FROM Class_Enrollment__c
            WHERE Class__c =: classC1.Id
            AND  Student__c =: studentS1.Id
        ];
        Test.stopTest();
            
        System.assertEquals( 
            100, 
            actualResult.get(0).Grade__c, 
            'SchoolService.setGrade is working incorrectly'
        );
    }

    
    
    //positive test
    @isTest static void setGradeUsingClassEnrollmentTest() {
        
        Test.startTest();
        Class_Enrollment__c classEnrollmentCe1 = [
            SELECT Id 
            FROM Class_Enrollment__c 
            WHERE Student__r.Name = 'Student 1'
        	AND Class__r.Subject__c = 'Algebra'
        ].get(0);
        SchoolService setMaxGrade = new SchoolService();
        setMaxGrade.setGrade(classEnrollmentCe1.Id, 100);
        List<Class_Enrollment__c> actualResult = [
            SELECT Grade__c 
            FROM Class_Enrollment__c
            WHERE Id =: classEnrollmentCe1.Id
        ];
        Test.stopTest();
            
        System.assertEquals( 
            100, 
            actualResult.get(0).Grade__c, 
            'SchoolService.setGrade is working incorrectly'
        );
    }
    
    //negtaive test
    @isTest static void setGradeUsingClassEnrollmentWrongValueTest() {
        
        Test.startTest();
        Class_Enrollment__c classEnrollmentCe1 = [
            SELECT Id 
            FROM Class_Enrollment__c 
            WHERE Student__r.Name = 'Student 1'
        	AND Class__r.Subject__c = 'Algebra'
        ].get(0);
        SchoolService setMaxGrade = new SchoolService();
        setMaxGrade.setGrade(classEnrollmentCe1.Id, -128);
        Class_Enrollment__c actualResult = [
            SELECT Grade__c 
            FROM Class_Enrollment__c
            WHERE Id =: classEnrollmentCe1.Id
        ].get(0);
        Test.stopTest();
            
        System.assertEquals( 
            5,
            actualResult.Grade__c,
            'SchoolService.setGrade is working incorrectly'
        );
    }
    
    //positive test
    @isTest static void setAcademicScholarshipTest() {
        
        Test.startTest();
        Student__c studentS1 = [SELECT Id FROM Student__c WHERE Name = 'Student 1'].get(0);
        SchoolService.setAcademicScholarship(studentS1.Id);
        Student__c actualResult = [
            SELECT Scholarship__c
            FROM Student__c
            WHERE Id =: studentS1.Id
        ].get(0);
        Test.stopTest();
            
        System.assertEquals( 
            'Academic', 
            actualResult.Scholarship__c,
            'School.Service.setAcademicScholarship is working incorrectly.'
        );
    }

    
    //positive test
    @isTest static void recalculateScholarshipValueUnasignedTest() {    
        
        Test.startTest();
        List<Student__c> students = [SELECT Id FROM Student__c ORDER BY Name];
        SchoolService.recalculateScholarship(students.get(0).Id);         
        List<Student__c> actualResult = [
            SELECT Scholarship__c
            FROM Student__c
            ORDER BY Name
        ];
        Test.stopTest();
        
        System.assertEquals( 
            'Unassigned',
            actualResult.get(0).Scholarship__c, 
            'School.Service.recalculateScholarship is working incorrectly.'
        );
    }
    
    //positive test
    @isTest static void recalculateScholarshipValueRegularTest() {    
        
        Test.startTest();
        List<Student__c> students = [SELECT Id FROM Student__c ORDER BY Name];
        SchoolService.recalculateScholarship(students.get(1).Id);           
        List<Student__c> actualResult = [
            SELECT Scholarship__c
            FROM Student__c
            ORDER BY Name
        ];
        Test.stopTest();
        
        System.assertEquals( 
            'Regular', 
            actualResult.get(1).Scholarship__c, 
            'School.Service.recalculateScholarship is working incorrectly.'
        );
    }
    
    //positive test
    @isTest static void recalculateScholarshipValueIncreasedTest() {    
        
        Test.startTest();
        List<Student__c> students = [SELECT Id FROM Student__c ORDER BY Name];
        SchoolService.recalculateScholarship(students.get(2).Id);
        List<Student__c> actualResult = [
            SELECT Scholarship__c
            FROM Student__c
            ORDER BY Name
        ];
        Test.stopTest();
        
        System.assertEquals( 
            'Increased', 
            actualResult.get(2).Scholarship__c, 
            'School.Service.recalculateScholarship is working incorrectly.'
        );    
    }

    //negative test
    @isTest static void recalculateScholarshipValueNullTest() {

        Test.startTest();
        List<Student__c> students = [SELECT Id FROM Student__c ORDER BY Name];
        SchoolService.recalculateScholarship(students.get(3).Id);
        List<Student__c> actualResult = [
                SELECT Scholarship__c
                FROM Student__c
                ORDER BY Name
        ];
        Test.stopTest();

        System.assertNotEquals(
                'Increased',
                actualResult.get(3).Scholarship__c,
                'School.Service.recalculateScholarship is working incorrectly.'
        );
    }

}
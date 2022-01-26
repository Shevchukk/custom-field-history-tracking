@isTest
private class PlatformTriggerTest {
    
    @isTest
    //PositiveTest
    private static void updatePlatformNamePositiveTest() {
        Id AccId = createTestAccountWithContacts(1);
        Test.StartTest();
        createTestPlatform(1, AccId, 20);
        Test.StopTest();

        List<Platform__c> result = [SELECT Name FROM Platform__c];
        String excpectedResult = 'TestPlatform 0 AcmeTest';

        System.assertEquals(1, result.size(), 'Test should create  1 platform');
        System.assertEquals(excpectedResult, result[0].Name, 'Platform have incorect Name');
        //System.debug('Test End');
    }

    @isTest
    //NegativeTest
    private static void updatePlatformNameNegativeTest() {
        
        Test.StartTest();
        createTestAccountWithContacts(1);
        Test.StopTest();

        List<Platform__c> result = new List<Platform__c>([SELECT Name FROM Platform__c]);
        String excpectedResult = 'TestPlatform 0 AcmeTest';
        System.assertNotEquals(1, result.size(), 'Test should`nt create platform');
        //System.debug('Test End');
    }

    @isTest
    //BulkTest
    private static void updatePlatformNameBulkTest() {
        Id AccId = createTestAccountWithContacts(2);
        Test.StartTest();
        System.debug('DML Rows ' + Limits.getDmlRows());
        createTestPlatform(20, AccId, 30);
        Test.StopTest();

        List<Platform__c> result = [SELECT Name FROM Platform__c];
        String excpectedResult = 'TestPlatform 19 AcmeTest';
        
        System.assertEquals(20, result.size(), 'Test should create  20 platform');
        System.assertEquals(excpectedResult, result[19].Name, 'Platform have incorect Name');
        //System.debug('Test End');
        
    }

    @isTest
    //PositiveTest
    private static void createPlatformContactsTest() {
        Id AccId = createTestAccountWithContacts(5);
        Test.StartTest();
        createTestPlatform(1, AccId, 10);
        Test.StopTest();
        
        List<Platform__c> pResult = [SELECT Name FROM Platform__c];
        List<Platform_Contact__c> pcResult= [SELECT Id From Platform_Contact__c];
        String excpectedResult = 'TestPlatform 0 AcmeTest';

        System.assertEquals(1, pResult.size(), 'Test should create  1 platform');
        System.assertEquals(excpectedResult, pResult[0].Name, 'Platform have incorect Name');
        System.assertEquals(5, pcResult.size(), 'Test should create  5 platform contacts');
        //System.debug('Test End');
        System.debug('DML Rows ' + Limits.getDmlRows());

    }

    @isTest
    //NegativeTest
    private static void createPlatformContactsNegativeTest() {
        String excpetedErrorMsg = 'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Sorry, the number of contacts in this account exceeds this platform\'s limit: [Account__c]';
        Id AccId = createTestAccountWithContacts(10);
        Test.StartTest();
        try {
            createTestPlatform(1, AccId, 5);
        } catch (DMLException exc) {
            Exception error = exc;
            String errorMessage = exc.getMessage();
            System.assertEquals(excpetedErrorMsg, errorMessage, 'Unexcpected Error');
            System.assertNotEquals(error, null, 'Should be an Error');  
        }
        Test.StopTest();

        List<Platform__c> pResult = new List<Platform__c>([SELECT Name FROM Platform__c]);
        List<Platform_Contact__c> pcResult = new List<Platform_Contact__c>([SELECT Id From Platform_Contact__c]);
        
        System.assertNotEquals(1, pResult.size(), 'Test shouldn`t create  any platform');
        System.assertNotEquals(5, pcResult.size(), 'Test shouldn`t create platform contacts');
        //System.debug('Test End');
    }

    @isTest
    //BulkTest
    private static void createPlatformContactsBulkTest() {
        Id AccId = createTestAccountWithContacts(10);
        Test.StartTest();
        createTestPlatform(20, AccId, 201);
        Test.StopTest();

        List<Platform__c> pResult = [SELECT Name FROM Platform__c];
        List<Platform_Contact__c> pcResult= [SELECT Id FROM Platform_Contact__c];
        String excpectedResult = 'TestPlatform 19 AcmeTest';
        System.debug('DML Rows ' + Limits.getDmlRows());

        System.assertEquals(20, pResult.size(), 'Test should create  50 platform');
        System.assertEquals(excpectedResult, pResult[19].Name, 'Platform have incorect Name');
        System.assertEquals(200, pcResult.size(), 'Test should create 200 platform contacts');
        //System.debug('Test End');
    }
    


    public static Id createTestAccountWithContacts(Integer CountOfContacts) {
        Account testAcc = new Account(
            Name = 'AcmeTest'
        );
        insert testAcc;
        List<Contact> conToCreate = new List<Contact>();
        for(Integer i=0; i < CountOfContacts; i++) {
            Contact testCon = new Contact(
                AccountId = testAcc.Id,
                LastName = 'TestContact ' + i
            );
            conToCreate.add(testCon);
        }
        insert conToCreate;
        return testAcc.Id;
    }


    public static void createTestPlatform(Integer CountOfPlatforms, Id AccId, Integer ContactCapacity) {
        List<Platform__c> PLatformToCreate = new List<Platform__c>();
        for(Integer i=0; i < CountOfPLatforms; i++) {
            Platform__c testPlatforms = new Platform__c(
                Name = 'TestPlatform ' + i,
                Account__c = AccId,
                Contact_Capacity__c = ContactCapacity
            );
            PLatformToCreate.add(testPlatforms);
        }
        insert PLatformToCreate;
    }
}
@isTest
private class TrackActivityTest {
    
    @isTest
    private static void trackFieldsChangesTest() {
        createTestAccount(1);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'forTest', Email='newuserfortest@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Jonson', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles', UserName='newuserfortest@testorg.com');
        List<Account> changedAccs = new List<Account>();
        for (Account acc : [SELECT Name FROM Account]) {
            acc.Name += ' changed';
            changedAccs.add(acc);
        }

        Test.startTest();
        System.runAs(u){
            update changedAccs;
        }        
        List<ActivityHistory__c> result = [SELECT FieldName__c, NewValue__c, OldValue__c, SobjectName__c, Who__r.Name FROM ActivityHistory__c];
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Query should return 1 object');
        System.assertEquals('Name', result[0].FieldName__c, 'FieldName__c should be \'Name\'');
        System.assertEquals('TestAcc 0 changed', result[0].NewValue__c, 'NewValue__c should be \'TestAcc 0 changed\'');
        System.assertEquals('TestAcc 0', result[0].OldValue__c, 'OldValue__c should be \'TestAcc 0\'');
        System.assertEquals('Account', result[0].SobjectName__c, 'SobjectName__c should be \'Account\'');
        System.assertEquals('Jonson', result[0].Who__r.Name, 'Who__c should be \'Jonson\'');
    }

    //bulkTest
    @isTest
    private static void trackFieldsChangesBulkTest() {
        createTestAccount(200);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'forTest', Email='newuserfortest@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Jonson', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles', UserName='newuserfortest@testorg.com');
        List<Account> changedAccs = new List<Account>();
        for (Account acc : [SELECT Name FROM Account]) {
            acc.Name += ' changed';
            changedAccs.add(acc);
        }

        Test.startTest();
        System.runAs(u){
            update changedAccs;
        }        
        List<ActivityHistory__c> result = [SELECT FieldName__c, NewValue__c, OldValue__c, SobjectName__c, Who__r.Name FROM ActivityHistory__c];
        Test.stopTest();

        System.assertEquals(200, result.size(), 'Query should return 1 object');
        System.assertEquals('Name', result[0].FieldName__c, 'FieldName__c should be \'Name\'');
        System.assertEquals('TestAcc 0 changed', result[0].NewValue__c, 'NewValue__c should be \'TestAcc 0 changed\'');
        System.assertEquals('TestAcc 0', result[0].OldValue__c, 'OldValue__c should be \'TestAcc 0\'');
        System.assertEquals('Account', result[0].SobjectName__c, 'SobjectName__c should be \'Account\'');
        System.assertEquals('Jonson', result[0].Who__r.Name, 'Who__c should be \'Jonson\'');
    }




    private static void createTestAccount (Integer countOfAccount) {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < countOfAccount; i++) {
            Account acc = new Account(
                Name = ('TestAcc ' + i )
            );
            accs.add(acc);
        }
        insert accs;
    }
}

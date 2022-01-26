@isTest
private class LastChangesHelperTest {
    
    //Positive test
    @isTest
    static void getActivityHistoryTest() {

        Id accId = createTestActivity(1);
        Test.startTest();
        List<ActivityHistory__c> result = LastChangesHelper.getActivityHistory(accId);
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Query should return only one object');
        System.assertNotEquals(null, result[0].CreatedDate, 'Object should contain CreatedDate field');
    }


    //bulk test
    @isTest
    static void getActivityHistoryBulkTest() {

        Id accId = createTestActivity(200);
        Test.startTest();
        List<ActivityHistory__c> result = LastChangesHelper.getActivityHistory(accId);
        Test.stopTest();

        System.assertEquals(100, result.size(), 'Query should return 100 object');
        System.assertNotEquals(null, result[0].CreatedDate, 'Object should contain CreatedDate field');
    }
    
    private static Id createTestActivity (Integer countOfActivity) {
        Account acc = new Account(
            Name = 'TestAcc'
        );
        insert acc;
        List<ActivityHistory__c> ahList = new List<ActivityHistory__c>();
        for (Integer i = 0; i< countOfActivity; i++) {
            Integer j = i++;
            ActivityHistory__c ahTest = new ActivityHistory__c (
                SobjectId__c = acc.Id,
                FieldName__c = 'Name',
                OldValue__c = 'Acc ' + i,
                NewValue__c = 'Acc ' + j
            );
            ahList.add(ahTest);
        }
        insert ahList;
        return acc.Id;
    }
}


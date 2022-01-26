global with sharing class LastChangesHelper {
     
    @AuraEnabled(Cacheable=true)
    global static List<ActivityHistory__c> getActivityHistory(Id currentRecordId){
        return [
            SELECT CreatedDate, FieldName__c, OldValue__c, NewValue__c, Who__r.Name
            FROM ActivityHistory__c
            WHERE SobjectId__c =: currentRecordId
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
        ];
    }
}

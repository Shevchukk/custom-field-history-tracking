public with sharing class TrackActivity {
    
    public static void trackFieldsChanges(List<SObject> oldObjects, List<SObject> newObjects) {
        List<ActivityHistory__c> trackToCreate = new List<ActivityHistory__c>();
        String objectType = String.valueOf(newObjects[0].getSObjectType());
        for (String field : [SELECT FieldSetName__c FROM ActivityHistorySetting__mdt WHERE SobjectName__c =: objectType].FieldSetName__c.split(',')) {
            Schema.SObjectField f = Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap().get(field);
            for(SObject oldObj : oldObjects) {
                for(SObject newObj : newObjects) {
                    if(oldObj.Id == newObj.Id && oldObj.get(f) != newObj.get(f)) {
                        ActivityHistory__c noteChange = new ActivityHistory__c(
                            SobjectId__c = oldObj.Id,
                            SobjectName__c = String.valueOf(objectType),
                            FieldName__c = String.valueOf(f),
                            OldValue__c = String.valueOf(oldObj.get(f)),
                            NewValue__c = String.valueOf(newObj.get(f)),
                            Who__c = UserInfo.getUserId() 
                        );
                        trackToCreate.add(noteChange);
                    }
                }
            }
        }
        insert trackToCreate;                                                                          
    }    
}

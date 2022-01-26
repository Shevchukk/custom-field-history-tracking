trigger PlatformTrigger on Platform__c ( after insert) {

    /*if(Trigger.isBefore) {
        PlatformTriggerHandler.checkPlatformBeforeInsert(Trigger.newMap);
    }*/
    
    if(Trigger.isAfter && Trigger.isInsert) {
        PlatformTriggerHandler.updatePlatformName(Trigger.newMap);
        PlatformTriggerHandler.createPlatformContacts(Trigger.newMap);
    }
    
}
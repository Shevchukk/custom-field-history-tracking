public with sharing class PlatformTriggerHandler {
    
    public static void updatePlatformName(Map<Id, Platform__c> platforms) {
        List<Platform__c> platformsToUpdate = new List<Platform__c>([SELECT Name, Account__r.Name FROM Platform__c WHERE Id IN: platforms.keySet()]);
        for (Platform__c platform : platformsToUpdate) {
            platform.name += ' ' + platform.Account__r.Name;    
        }
        update platformsToUpdate;
    }

    public static void createPlatformContacts(Map<Id, Platform__c> platformMap) {

        List<Platform_Contact__c> pcToCreate = new List<Platform_Contact__c>();
        Set<Id> accId = new Set<Id>();

        List<Platform__c> platforms = new List<Platform__c>([SELECT Id, Account__c FROM Platform__c WHERE Id IN :platformMap.keySet()]);
        for(Platform__c p : platforms) {
            accId.add(p.Account__c);
        }
        checkPlatformBeforeInsert(accId);
        List<Contact> contacts = new List<Contact>([SELECT Id, AccountId FROM Contact WHERE AccountId IN: AccId]);                                                                                                  
        for(Platform__c pl : platforms) {
            for(Contact con : contacts) {
                if(pl.Account__c == con.AccountId) {
                    Platform_Contact__c pc = new Platform_Contact__c(
                        Platform__c = pl.Id,
                        Contact__c = con.Id
                    );
                    pcToCreate.add(pc);
                }   
            }
        }
        insert pcToCreate;
        System.debug('Inserted' + pcToCreate);    
    }

    private static void checkPlatformBeforeInsert(Set<Id> AccId) {
        AggregateResult[] contactPerId = [SELECT COUNT(Id)cnt, AccountId FROM Contact WHERE AccountId IN: accId GROUP BY AccountId];
        for(sObject platformToCheck : trigger.new) {
            for(AggregateResult c : contactPerId) {
                if((c.get('AccountId') == ((Platform__c)platformToCheck).Account__c) && (((Platform__c)platformToCheck).Contact_Capacity__c < (Integer)c.get('cnt'))) {
                    ((Platform__c)platformToCheck).Account__c.addError(Label.PlatformCreateError);
                }
            }
        }
    }

}
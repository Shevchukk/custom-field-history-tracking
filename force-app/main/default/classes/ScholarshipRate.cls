public class ScholarshipRate implements Database.Batchable<sObject>, Database.Stateful {

    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Scholarship__c, Scholarship_Rate__c FROM Student__c'
        );
    }

    public void execute(Database.BatchableContext bc, List<Student__c> scope) {
        for (Student__c s : scope) {
            switch on s.Scholarship__c {
                when 'Unassigned' {
                    s.Scholarship_Rate__c = 0;
                }
                when 'Regular' {
                    s.Scholarship_Rate__c = 100;
                }
                when 'Increased' {
                    s.Scholarship_Rate__c = 125;
                }
                when 'Academic' {
                    s.Scholarship_Rate__c = 150;
                }
            }
            recordsProcessed++;
            
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(recordsProcessed + ' records processed.');

    }
}
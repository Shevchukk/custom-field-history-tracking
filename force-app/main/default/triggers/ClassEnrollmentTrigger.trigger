trigger ClassEnrollmentTrigger on Class_Enrollment__c (before insert) {
    if (Trigger.isBefore) {
		ClassEnrollmentTriggerHandler.validateRelation(Trigger.new);
        ClassEnrollmentTriggerHandler.validateYearOfStudy(Trigger.new);
    }
}
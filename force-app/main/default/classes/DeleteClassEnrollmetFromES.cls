public with sharing class DeleteClassEnrollmetFromES {
    @AuraEnabled
    public static void deleteCE (Id recordId){

        System.Debug('Uviyshow');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://avenga-school.herokuapp.com/delete-record');
        request.setMethod('DELETE');
        request.setHeader('recordId', recordId);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
             delete [SELECT Id FROM Class_Enrollment__c WHERE Id = :recordId];
        } else {
           throw new BadRequestException('Bad request');
        }
    }

    public class BadRequestException extends Exception {

    }
}
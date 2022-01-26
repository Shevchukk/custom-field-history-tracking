import { LightningElement, wire, api } from 'lwc';
import getActivityHistory from '@salesforce/apex/LastChangesHelper.getActivityHistory';


const columns = [
    { label: 'Date', fieldName: 'CreatedDate', type: 'date' },
    { label: 'Field', fieldName: 'FieldName__c', type: 'text' },
    { label: 'Old Value', fieldName: 'OldValue__c', type: 'text' },
    { label: 'New Value', fieldName: 'NewValue__c', type: 'text' },
    { label: 'Changed By', fieldName: 'Who__c', type: 'text' },

];

export default class LastChanges extends LightningElement {
    @api recordId;
    activity;
    columns = columns;
    @wire(getActivityHistory, {currentRecordId: '$recordId'})
    wiredRecords({ data, error }) {
        if(data) {
            this.activity = [];
            data.forEach(row => {
                let rowData = {};
                if(row.Who__r) {
                    rowData.Who__c = row.Who__r.Name;
                }
                rowData.CreatedDate = row.CreatedDate;
                rowData.FieldName__c = row.FieldName__c;
                rowData.OldValue__c = row.OldValue__c;
                rowData.NewValue__c = row.NewValue__c;
                this.activity.push(rowData);
            });
        } else if (error) {
            console.log(error);
        }
    }
}
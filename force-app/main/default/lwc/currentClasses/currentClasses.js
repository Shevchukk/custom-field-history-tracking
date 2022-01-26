import { LightningElement, wire, api } from 'lwc';
import getClasses from '@salesforce/apex/CurClassesHelper.getClasses';
import deleteCE from '@salesforce/apex/DeleteClassEnrollmetFromES.deleteCE';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { refreshApex } from '@salesforce/apex';



const columns = [
    { label: 'Class Name', fieldName: 'Name', type: 'text' },
    { label: 'Subject', fieldName: 'Subject__c', type: 'text' },
    { label: 'Grade', fieldName: 'Grade__c', type: 'decimal' },
    {type: "button", typeAttributes: {
            label: 'Delete',
            name: 'delete',
            title: 'Delete',
            disabled: false,
            value: 'delete',
            iconPosition: 'right'
        }}
];

export default class BasicDatatable extends LightningElement {
    @api recordId;
    data;
    columns = columns;
    //wiredDataResult;
    //@track data;
    @wire(getClasses, { curRecordId: '$recordId' })
    wiredClasses({ data }) {
        //this.wiredDataResult = data;
        if (data) {
            this.data = [];
            data.forEach(row => {
                let rowData = {};
                if (row.Class__r)
                {
                    rowData.Name = row.Class__r.Name;
                    rowData.Subject__c = row.Class__r.Subject__c;
                }
                rowData.Grade__c = row.Grade__c;
                rowData.Id = row.Id;
                this.data.push(rowData);
            }) ;
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    handleDeleteAction(event) {
        const row = event.detail.row.Id;
        deleteCE({recordId: row}).then(() => {
            this.showToast('Success','Record was deleted', 'success');
            //return refreshApex(this.wiredDataResult);
        }).catch(error => {
            this.showToast('Error', 'Error', 'error')
        });
    }


}
import {LightningElement, api} from 'lwc';
import deleteCE from '@salesforce/apex/DeleteClassEnrollmetFromES.deleteCE';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class DeleteCERecord extends LightningElement {
    @api recordId;
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    deleteRecord() {
        deleteCE({recordId: this.recordId}).then(() => {
            this.showToast('Success','Record was deleted', 'success');
        }).catch(error => {
            this.showToast('Error', 'Error', 'error')
        });
    }
}
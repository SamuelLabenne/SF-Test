import { LightningElement, api, wire, track } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import { getListUi, updateRecord, getRecordNotifyChange } from 'lightning/uiListApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { refreshApex } from '@salesforce/apex';

export default class ContactLwc extends LightningElement {

/*     fields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD];

    @api recordId;
    @api objectApiName; */

    @track contacts;
    @track error;
    draftValues = {};

    @wire(getListUi, { objectApiName: CONTACT_OBJECT, listViewApiName: 'AllContacts' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.records.records;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    handleFieldChange(event) {
        const contactId = event.target.dataset.id;
        const field = event.target.dataset.field;
        const value = event.target.value;

        if (!this.draftValues[contactId]) {
            this.draftValues[contactId] = { fields: { Id: contactId } };
        }
        this.draftValues[contactId].fields[field] = value;
    }

    async saveChanges() {
        //const recordsToUpdate = Object.values(this.draftValues);
        const recordsToUpdate = [];
        for (const key in this.draftValues) {
            recordsToUpdate.push(this.draftValues[key]);
        }
        console.log("rec to update: "  , JSON.stringify(recordsToUpdate));
        console.log('Draft Values Before Update:', JSON.stringify(this.draftValues));

        try {
            console.log("try block");
            const updatePromises = recordsToUpdate.map(record => updateRecord(record));
/*             const updatePromises = recordsToUpdate.map(record => {
                // Ensure each record has a fields property
                if (!record.fields) {
                    return Promise.reject(new Error('Record does not have a fields property.'));
                }
                return updateRecord(record);
            }); */
            console.log("promises:" , updatePromises);
            await Promise.all(updatePromises);

            this.draftValues = {}; // Clear draft values after saving
            //getRecordNotifyChange(recordsToUpdate.map(record => record.fields.Id));
            await refreshApex(this.contacts); // Refresh list to show updates
            
        } catch (error) {
            console.error('Error updating records:', error);
        }
    }
}
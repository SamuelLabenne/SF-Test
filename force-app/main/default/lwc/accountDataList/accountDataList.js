import { LightningElement, track, wire } from 'lwc';
import getAccountData from '@salesforce/apex/AccountDataController.getAccountData';

export default class AccountDataList extends LightningElement {
    @track accountData = [];
    @track error;

    @wire(getAccountData)
    wiredAccountData({ error, data }) {
        if (data) {
            this.accountData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accountData = undefined;
        }
    }
}
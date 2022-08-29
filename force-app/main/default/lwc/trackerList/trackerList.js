import { LightningElement, api, wire } from 'lwc';
import getProgressTrackerObjectSettings from '@salesforce/apex/ProgressTrackerController.getProgressTrackerObjectSettings'
import { getRecord } from 'lightning/uiRecordApi';
//import apexUpdateRecord from '@salesforce/apex/Controller.apexUpdateRecord';

export default class TrackerList extends LightningElement {
    @api trackerObjects;
    @api recordId;
    @api objectApiName;
    @wire(getRecord, { recordId: '$recordId', fields: ['Account.Name']})
    wireRecord({data}) {
        this.getTrackerObjectSettings();
    }


    trackerId;
    trackerObjectSettings;
    reset = true;
    
    connectedCallback() {
        this.getTrackerObjectSettings();
    }

    async handler() {
        //await apexUpdateRecord(this.recordId);

        // Notify LDS that you've changed the record outside its mechanisms.
        console.log('recognized');
    }
  

    /* Should get called on connectedcallback based on the admin's selection -> Thinking this wil probably need to be passed an ID */
    getTrackerObjectSettings() {
        this.reset = false;

        getProgressTrackerObjectSettings({ObjectSettingId: this.trackerObjects, recordId: this.recordId})
        .then(result => {
            this.trackerObjectSettings = JSON.parse(result);   
            this.reset = true; 
            console.log(this.trackerObjectSettings);
        }).catch(error => {
            console.error(error);
        })
    }
}
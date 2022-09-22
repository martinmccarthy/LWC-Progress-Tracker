import { LightningElement, api, wire } from 'lwc';
import getProgressTrackerObjectSettings from '@salesforce/apex/ProgressTrackerController.getProgressTrackerObjectSettings'
import { getRecordNotifyChange, getRecord } from 'lightning/uiRecordApi';

export default class TrackerList extends LightningElement {
    @api trackerObjects; // Defined in XML file -> Admin selects this
    @api recordId; // Id of the Record Page we are on
    @api objectApiName; // Object API Name of the Record Page we are on (ex: Opportunity, Account, etc.)

    trackerObjectSettings;
    reset = true; // used to set the UI anytime we change it
    
    /*  Takes the recordId from the record page this component is located on and uses it to check if we change any of the record's
        fields. If we end up updating the record then we want to refresh our component's data. */
    @wire(getRecord, {recordId: '$recordId', fields: ['Id']})
    wiredRecord({data}) {
        if(data) {
            this.getTrackerObjectSettings();
        }
    }

    /*  Get data on page load */
    connectedCallback() {
        this.getTrackerObjectSettings();
    }
  
    /* Calls to apex class and gets the tracker object setting to be passed down to the child component. */
    getTrackerObjectSettings() {
        this.reset = false;
        getProgressTrackerObjectSettings({ObjectSettingId: this.trackerObjects, recordId: this.recordId})
        .then(result => {
            console.log(result);
            this.trackerObjectSettings = JSON.parse(result);   
            this.reset = true; 
            console.log(this.trackerObjectSettings);
        }).catch(error => {
            console.error(error);
        })

        getRecordNotifyChange([{recordId: this.recordId}]);
    }
}
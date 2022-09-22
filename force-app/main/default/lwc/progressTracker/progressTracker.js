import { LightningElement, api } from 'lwc';

export default class ProgressTracker extends LightningElement {
    @api progressTrackerObjectSetting;

    /* Arranges the ProgressTrackerFieldSettings into an order list so they display properly to the UI  */
    get orderedFieldSettings() {
        var parsedSettings = JSON.parse(JSON.stringify(this.progressTrackerObjectSetting)).listProgressTrackerFieldSettings;
        var orderedFieldSettings = new Array(parsedSettings.length);
        for(let i = 0; i < parsedSettings.length; i++) {
            orderedFieldSettings[parsedSettings[i].intOrder - 1] = parsedSettings[i];
        }
        return orderedFieldSettings;
    }

    get trackerObjectName() {
        return JSON.parse(JSON.stringify(this.progressTrackerObjectSetting)).strName;
    }
}
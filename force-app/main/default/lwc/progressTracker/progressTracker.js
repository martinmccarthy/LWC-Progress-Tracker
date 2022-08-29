import { LightningElement, api } from 'lwc';

export default class ProgressTracker extends LightningElement {
    @api trackerObject;

    get orderedFieldSettings() {
        var parsedSettings = JSON.parse(JSON.stringify(this.trackerObject)).fieldSettings;
        var orderedFieldSettings = new Array(parsedSettings.length);
        for(let i = 0; i < parsedSettings.length; i++) {
            orderedFieldSettings[parsedSettings[i].order - 1] = parsedSettings[i];
        }
        return orderedFieldSettings;
    }

    get trackerObjectName() {
        //console.log(JSON.parse(JSON.stringify(this.trackerObject)));
        return JSON.parse(JSON.stringify(this.trackerObject)).name;
    }
}
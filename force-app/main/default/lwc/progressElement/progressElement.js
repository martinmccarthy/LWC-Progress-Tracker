import { LightningElement, api } from 'lwc';

export default class ProgressElement extends LightningElement {
    @api fieldSetting;

    /* This getter returns the class of the list element based on if it is complete or active */
    get taskClass() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        if(parsedSetting.isComplete === true) {
            return 'slds-progress__item slds-is-completed';
        }
        if(parsedSetting.isComplete === false && parsedSetting.isActive === true) {
            return 'slds-progress__item slds-is-active';
        }
        return 'slds-progress__item';
    }

    get isCompleted() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        if(parsedSetting.isActive === true && parsedSetting.isComplete === true) return true;
        return false;
    }
    get isActive() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        
        if(parsedSetting.isActive === true && parsedSetting.isComplete === false) return true;
        return false;
    }

    
    get orderedResources() {
        var parsedSettings = JSON.parse(JSON.stringify(this.fieldSetting));
        var resources = parsedSettings.resources;
        var orderedResources = new Array(resources.length);
        for(let i = 0; i < resources.length; i++) {
            orderedResources[resources[i].order - 1] = resources[i];
        }
        return orderedResources;
    }
}
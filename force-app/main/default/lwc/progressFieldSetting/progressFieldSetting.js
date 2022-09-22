import { LightningElement, api } from 'lwc';

export default class ProgressElement extends LightningElement {
    @api fieldSetting;

    /* This getter returns the class of the list element based on if it is complete or active */
    get taskClass() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        if(parsedSetting.boolIsComplete === true) {
            return 'slds-progress__item slds-is-completed';
        }
        if(parsedSetting.boolIsComplete === false && parsedSetting.boolIsActive === true) {
            return 'slds-progress__item slds-is-active';
        }
        return 'slds-progress__item';
    }

    /* These two getters just determine how we are going to display the elements in the HTML based on their boolean characteristics */
    get isCompleted() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        if(parsedSetting.boolIsActive === true && parsedSetting.boolIsComplete === true) return true;
        return false;
    }
    get isActive() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        
        if(parsedSetting.boolIsActive === true && parsedSetting.boolIsComplete === false) return true;
        return false;
    }

    /* Orders ProgressTrackerResources before passing them down that way when we iterate through we display them correctly from this component */
    get orderedResources() {
        var parsedSetting = JSON.parse(JSON.stringify(this.fieldSetting));
        var resources = parsedSetting.listProgressTrackerResources;
        var orderedResources = new Array(resources.length);
        for(let i = 0; i < resources.length; i++) {
            orderedResources[resources[i].intOrder - 1] = resources[i];
        }
        
        return orderedResources;
    }
}
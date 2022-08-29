global class TrackerPicklist extends VisualEditor.DynamicPickList{
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('', '');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        List<Progress_Tracker_Object_Setting__mdt> objectSettings = [SELECT Id, Label FROM Progress_Tracker_Object_Setting__mdt];
        VisualEditor.DynamicPickListRows objectList = new VisualEditor.DynamicPickListRows();

        for(Progress_Tracker_Object_Setting__mdt objectSetting : objectSettings) {
            String IdStr = '' + objectSetting.Id;
            VisualEditor.DataRow objectChoice = new VisualEditor.DataRow(objectSetting.Label, IdStr);
            objectList.addRow(objectChoice);
        }
    
        return objectList;
    }
}
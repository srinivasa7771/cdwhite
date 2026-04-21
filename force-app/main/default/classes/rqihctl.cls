public class rqihctl{
    public Id rqiId {get; set;}
    public cHistories[] histories;
    public Static final Map<String, Schema.SObjectField> RqIFieldmap = Schema.SObjectType.g_reqitem__c.fields.getMap();
    public Static final List<Schema.PicklistEntry> fieldPicklistValues = g_reqitem__History.Field.getDescribe().getPicklistValues();
    public rqihctl() {rqiId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));}

public List<cHistories> getHistories() {
    list<cHistories> histories = new list<cHistories>();
    String prevDate = '';
    for (g_reqitem__History cHistory : [Select CreatedDate, CreatedBy.Name, CreatedBy.Id, Field, NewValue, OldValue from g_reqitem__History where  ParentId= :rqiId order by CreatedDate desc]) {
      if ((cHistory.newValue == null && cHistory.oldValue == null) || (cHistory.newValue != null && !(string.valueOf(cHistory.newValue).startsWith('005') || string.valueOf(cHistory.newValue).startsWith('00G'))) || (cHistory.oldValue != null && !(string.valueOf(cHistory.oldValue).startsWith('005') || string.valueOf(cHistory.oldValue).startsWith('00G')))) {
        cHistories tempHistory = new cHistories();
            /* Set the Date and who performed the action */
            if (String.valueOf(cHistory.CreatedDate) != prevDate) {
                tempHistory.theDate = String.valueOf(cHistory.CreatedDate);
                tempHistory.who = cHistory.CreatedBy.Name;
                tempHistory.userId = cHistory.CreatedBy.Id;
            }
            else{ tempHistory.theDate = ''; tempHistory.who = ''; tempHistory.userId = cHistory.CreatedBy.Id; }
            prevDate = String.valueOf(cHistory.CreatedDate);

            /* Get the field label*/
            String fieldLabel = rqihctl.returnFieldLabel(String.valueOf(cHistory.Field));

            /* Set the Action value */
            if (String.valueOf(cHistory.Field) == 'created') { /* on Creation*/
                tempHistory.action = 'Created.';
            }
            else if (cHistory.OldValue != null && cHistory.NewValue == null) { /* when deleting a value from a field */
            /* Format the Date and if there's an error, catch it and re */
               try {
                   tempHistory.action = 'Deleted ' + Date.valueOf(cHistory.OldValue).format() + ' in <b>' + fieldLabel + '</b>.';
               }
               catch (Exception e) {
                   tempHistory.action = 'Deleted ' + String.valueOf(cHistory.OldValue) + ' in <b>' + fieldLabel + '</b>.';
               }
            }
            else{ /* all other scenarios */
                String fromText = '';
                if (cHistory.OldValue != null) {
                    try{
                        fromText = ' from ' + Date.valueOf(cHistory.OldValue).format();
                    }
                    catch (Exception e) {
                        fromText = ' from ' + String.valueOf(cHistory.OldValue);
                    }
                }
                String toText = '';
                if (cHistory.OldValue != null) {
                   try { toText = Date.valueOf(cHistory.NewValue).format(); } catch (Exception e) { toText = String.valueOf(cHistory.NewValue); }
                }
                if (cHistory.OldValue == null && cHistory.newValue != null) {
                   try {  fromText = ''; toText = Date.valueOf(cHistory.NewValue).format(); } catch (Exception e) { toText = String.valueOf(cHistory.NewValue); }
                }
                if (toText != '' && fromText!='')
                    tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                else if (toText != '' && fromText=='')
                    tempHistory.action = 'Set <b>' + fieldLabel + '</b>' + ' to <b>' + toText + '</b>.';
                else
                    tempHistory.action = 'Changed <b>' + fieldLabel;
            }

            /* Add to the list */
            histories.add(tempHistory);
        }
    }
    return histories;
}

/* Function to return Field Label of a Request Item field given a Field API name */
public Static String returnFieldLabel(String fieldName) {
    if (rqihctl.RqIFieldmap.containsKey(fieldName)) return rqihctl.RqIFieldmap.get(fieldName).getDescribe().getLabel();
    else{
        for (Schema.PicklistEntry pickList : fieldPicklistValues) {
            if (pickList.getValue() == fieldName) {
                if (pickList.getLabel() != null) return pickList.getLabel();
                else return pickList.getValue();
            }
        }
    }
    return '';
}
/* Inner Class to store the detail of the request item histories */
public class cHistories {
    public String theDate {get; set;}
    public String who {get; set;}
    public Id userId {get; set;}
    public String action {get; set;}
}
}
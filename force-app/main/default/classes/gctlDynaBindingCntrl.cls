public class gctlDynaBindingCntrl {
    public g_req__c dummyReq {get; set;}
    public Map<String, String> mapFieldsByName {get; set;}
    public List<String> lstFieldNames {get; set;}
    public Map<String, List<String>> mapFieldNames {get; set;}
    public String fieldsJSON {get; set;}
    public String displayStyle {get; set;}
    public Boolean bShowPrint {get; set;}
    public String columnWidth {get; set;}
    public Boolean ispu{get;set;}

    public gctlDynaBindingCntrl() {
        loadData();
    }

    public void loadData() {
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        displayStyle = 'block'; columnWidth='4';
        String reqID=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id')); //a0E0I00000eRcwSUAS
        if (String.isBlank(reqID)) {return;}

        dummyReq = new g_req__c();
        String attQry = '';

        // list to maintain the order of the fields on the component
        lstFieldNames = new List<String>();
        mapFieldNames = new Map<String, List<String>>();
        list<g_req__c> lstDummyReq = [Select id, name, srvc__c, srvc__r.stg__c from g_req__c where id=:reqID];
        if (lstDummyReq == null || lstDummyReq.size()==0) {return;}

        List<String> allFlds = new List<String>();
        mapFieldsByName = new Map<String, String>();
        g_Srvc__c gs = [Select id, name, uid__c, stg__r.id, stg__r.name, stg__r.formFields__c, stg__r.dfjs__c from g_Srvc__c where id=:lstDummyReq[0].srvc__c];

        // default display type onLoad
        Set<String> displayHide = new Set<String>{'ltp', 'lts', 'ltc', '050', '051', '052'};
        if (displayHide.contains(gs.uid__c)) { displayStyle='none';}

        // show print link on detail page
        Set<String> showLetters = new Set<String>{'ltp', 'lts', 'ltc', 'ltn'};
        if (showLetters.contains(gs.uid__c)) { bShowPrint=true; }

        // handle the number of columns
        Set<String> showCol = new Set<String>{'050', '051', '052'};
        if (showCol.contains(gs.uid__c)) { columnWidth='6'; }

        if (String.isBlank(gs.stg__r.formFields__c)) {return;}

        fieldsJSON = gs.stg__r.dfjs__c;
        allFlds = gs.stg__r.formFields__c.split(';');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('g_req__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (String fld : allFlds) {
            List<String> brkFld = new List<String>();
            if (fld.contains('=')) {
                brkFld = fld.split('=');
                mapFieldsByName.put(brkFld[0].trim(), brkFld[1]);
                lstFieldNames.add(brkFld[0].trim());
            }else{
                fld = fld.trim();
                if (fieldMap.get(fld)!=null) {
                    mapFieldsByName.put(fld, fieldMap.get(fld).getDescribe().getLabel());
                    lstFieldNames.add(fld);
                }
            }
        }

        // get all request field values to be displayed
        String allQueryfields = '';
        for (String fld : mapFieldsByName.keySet()) {if (fld.equalsIgnoreCase('xoca__c')) {continue;} allQueryfields += ', ' + fld;}

        String query = 'Select Id, name, STA__c, AP__c, xoca__c, i_STA__c, srvc__r.uid__c' + String.escapeSingleQuotes(allQueryfields) +
            ', (select id from Attachments limit 1) FROM g_req__c WHERE Id = :reqID';
        System.debug('Query : ' + query);
        dummyReq = Database.query(query);

    }

}
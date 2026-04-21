public class gctlDynaBindingCntrl_adhoc {
    public g_req__c dummyReq {get; set;}
    public Map<String, String> mapFieldsByName {get; set;}
    public List<String> lstFieldNames {get; set;}
    public Map<String, List<String>> mapFieldNames {get; set;}
    public String fieldsJSON {get; set;}
    public String displayStyle {get; set;}
    public Boolean bShowPrint {get; set;}
    public String columnWidth {get; set;}
    public Boolean ispu{get;set;}

    public gctlDynaBindingCntrl_adhoc() {
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        displayStyle = 'block'; columnWidth='4';
        String reqID=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id')); //a0E0I00000eRcwSUAS
        if (String.isBlank(reqID)) {return;}

        dummyReq = new g_req__c();
        String attQry = '';

        // list to maintain the order of the fields on the component
        lstFieldNames = new List<String>();
        mapFieldNames = new Map<String, List<String>>();
        list<g_req__c> lstDummyReq = [Select id, name, srvc__r.uid__c, srvc__c, xadtx1__c, xadtx3__c, xadtx4__c, xadtx2__c, srvc__r.stg__c from g_req__c where id=:reqID];
        system.debug('lstDummyReq -- '+lstDummyReq);
        if (lstDummyReq == null || lstDummyReq.size()==0) {return;}
        else
            dummyReq=lstDummyReq[0];
         system.debug('dummyReq -- '+dummyReq);
        List<String> allFlds = new List<String>();

    }

}
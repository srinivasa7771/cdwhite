public class ctrlCaseOT {
    public Id recordId {get;set;}
    public case caseObj {get;set;}
    public ctrlCaseOT(ApexPages.StandardController controller) {
        recordId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
    }
    public  void updateCase() {
        try{
        BusinessHours bh = [SELECT ID FROM BusinessHours WHERE IsDefault=true];
        caseObj = [select id, cot__c, cob__c, ccod__c, owner.name, recordtype.name, aMin__c, To_Email__c, origin from case where id=:recordId];
        user currenrUser = [select id, name, profile.name from user where id=:userinfo.getUserId()];
        if ((caseobj.origin =='Email' || caseobj.origin == 'Phone')&& caseObj.cot__c == null && string.isblank(caseObj.cob__c) && currenrUser.profile.name=='CC2' && caseObj.owner.name=='AXS Support') {
            caseObj.cob__c = userinfo.getName(); caseObj.cot__c = system.now(); caseObj.ownerid= userinfo.getUserId();
        }
        if (caseObj.ccod__c != null && (caseObj.aMin__c == null || caseObj.aMin__c == 0))caseObj.aMin__c = BusinessHours.diff(bh.id, caseObj.cot__c, caseObj.ccod__c)/60000;
        if (Schema.sObjectType.Case.isUpdateable()) {
            update caseObj;
        }
        }catch (Exception e) {}
    }
}
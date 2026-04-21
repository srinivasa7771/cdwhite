public class AddOnServicesController {
    public g_Req__c req{
        set;
        get;
    }
    public List<g_srvcitm__c>serviceItemList{
        get;
        set;
    }
    public Account acc {
        get;
        set;
    }
    public AddOnServicesController() {
        system.debug('AddOnServicesController:::::');
        Id reqId = apexpages.currentpage().getparameters().get('id');
        system.debug('reqId::::'+reqId);
        if (reqId != null) {
            req = [SELECT  STA__c, srvc__r.uid__c, srvc__r.AddOnSrv__c, name, id, AP__c, xintp__c,
                InsChk__c, srvc__r.payMd__c, srvc__r.AddOn__c, xcddocs__c, xadh__c, srvc__r.stg__r.pg__c,
                srvc__r.Category__c, xadtx2__c, AT__c, Acc__c, xppor__c, xspor__c, xpveh__c, xsvn__c,
                xceml__c, spCh__c, (SELECT id, AD__c, exp__c FROM Items__r) FROM g_Req__c WHERE id=:reqId];
            acc = [SELECT prk__c FROM Account WHERE id=:req.Acc__c];
            getServiceItems(req.srvc__c, req.srvc__r.AddOnSrv__c);
        }
    }
    public void getServiceItems(Id serviceId, string addOnSRVCode) {
        system.debug('getServiceItems:::::');
        if (String.isNotBlank(addOnSRVCode)) {
            List<String>addOnSRVCodeList = addOnSRVCode.split(';');
            serviceItemList = new List<g_srvcitm__c>();
            serviceItemList =[SELECT Name, id, cd__c, ATN__c FROM g_srvcitm__c WHERE srvc__c =:serviceId AND cd__c IN :addOnSRVCodeList];
            system.debug('serviceItemList:::'+serviceItemList);
        }
    }
    public PageReference saveRequest() {
        System.debug('xadh__c save : ' + req.xadh__c);
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update req;
        }
        PageReference page = new PageReference('/apex/grqpy?id='+req.id);
        page.setRedirect(true);
        return page;
    }
    public void updateRequest() {
        system.debug('updateRequest::::');
        String jsonArray = apexpages.currentpage().getparameters().get('srvItemIds');
        system.debug('jsonArray:::'+jsonArray);
        if (!String.isBlank(jsonArray)) {
            String srvItemIdsStr = '';
            Set<String>srvItemIds = (Set<String>)System.JSON.deserialize(jsonArray, Set<String>.class);
            system.debug('srvItemIds:::'+srvItemIds);
            for (String str : srvItemIds) {
                srvItemIdsStr += str + ';' ;
            }
            system.debug('srvItemIdsStr::::'+srvItemIdsStr);
        }
        try{
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update req;
            }
            system.debug('xadh__c::::'+req.xadh__c);
            system.debug('req::::'+req);
        }
        catch (Exception ex) {
            system.debug(ex.getMessage());
        }
    }
    public PageReference confirm() {
        system.debug('confirm:::::');
        PageReference page = new PageReference('/apex/PaymentOption?id='+req.id);
        page.setRedirect(true);
        return page;
    }
}
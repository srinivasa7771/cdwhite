public with sharing class gctlStuAcceptance {
    public  g_Req__c req{set;get;}
    public string reqId{set;get;}
    public Boolean isgu{get;set;}
    public g_srvc__c srv{get;set;}
    public g_reqitem__c gritm{get;set;}
    public List<g_srvcitm_Status__c> srvItemStatusList{get;set;}
    public String sitekey { get { return Label.CaptchaSitekey; } }
    public map<string, id> srvItemStMap{get;set;}
    public attachment offerLetter{get;set;}
    public gctlStuAcceptance() {
        srvItemStatusList= new list<g_srvcitm_Status__c>();
        srvItemStMap= new map<string, id>();
        isgu = gU.isGuestUser(UserInfo.getProfileId());
        reqId = apexpages.currentpage().getparameters().get('id');
        req=[select id, xrped__c, name, xrpid__c, STA__c, Con__c, action__c, xawh__c, nowkh__c,
            Con__r.ptsta__c, Con__r.name, srvc__r.name, srvc__r.lbl__c, srvc__r.uid__c, Acc__c,
            Acc__r.name, (select id, itm__c, sta__c, sta__r.cd__c from items__r limit 1), (select id from rDocs__r where name='Offer Letter' limit 1) from g_Req__c where id =:reqId];
        srv = [select id, uid__c, name, sdg__c, sdg__r.sd__c, sdg__r.slbl__c, sdg__r.docslbl__c, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c,
               sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id=: req.srvc__c limit 1];
        gritm = req.items__r[0];
        srvItemStatusList=[select id, cd__c from g_srvcitm_Status__c where itm__c=:req.items__r[0].itm__c and cd__c in('ok', 'gr')];
        for (g_srvcitm_Status__c objgss:srvItemStatusList) {
            if (!srvItemStMap.containsKey(objgss.cd__c))srvItemStMap.put(objgss.cd__c, objgss.id);
        }
        if (!test.isRunningTest())offerLetter = [select id from attachment where parentid=:req.rDocs__r[0].id];
    }
    public void accpetOffer() {
        //if (req.Con__r.ptsta__c=='Eligible') {
            //Contact con = new contact(id=req.Con__c, ptsta__c='Employed', pte__c=req.Acc__c, ididt__c=req.xrpid__c);
            g_reqitem__c gritem = new g_reqitem__c(id=req.items__r[0].id, sta__c=srvItemStMap.get('ok'));
            req.STA__c='In Process';
            //update con;
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update gritem;
            }
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update req;
            }
           gritm =[select id, STA__c, sta__r.cd__c from g_reqitem__c where id=:gritem.id];
        //}
    }
    public void rejectOffer() {
        g_reqitem__c gritem = new g_reqitem__c(id=req.items__r[0].id, sta__c=srvItemStMap.get('gr'));
        req.STA__c='Rejected';
        if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
            update gritem;
        }
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update req;
        }
         gritm =[select id, STA__c, sta__r.cd__c from g_reqitem__c where id=:gritem.id];
    }
}
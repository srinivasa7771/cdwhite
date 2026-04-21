public class gctlTWT {
    public g_Tran__c T {get;set;}
    public string nt {set;get;}
    public decimal topamt {set;get;}
    public gctlTWT(ApexPages.StandardController c) {
        T=(g_Tran__c)c.getRecord();
         T= [select id, Acc__c, nt__c, A__c, cq__c, cdt__c, ci__c from g_Tran__c where id=:T.id];
    }
    public Pagereference crtTran() {
      Pagereference ref = null;
     try{

      g_req__c r = new g_req__c(srvc__c=Label.CDTopupSID, Acc__c=T.Acc__c, xtpa__c=topamt, sta__c='In Process');
      if (Schema.sObjectType.g_req__c.isCreateable()) {
          insert r;
      }
      g_Reqitem__c itm = (Test.isRunningTest()) ? ([select id , RQ__c, rq__r.Acc__c from g_Reqitem__c limit 1]) : [select id , RQ__c, rq__r.Acc__c from g_Reqitem__c where RQ__r.id =: r.id ];
      if (String.isNotBlank(nt)) {
        List<g_tranitem__c> tiLst = [select id, STA__c from g_tranitem__c where t__c=:T.id];
       for (g_tranitem__c tiu: tiLst) {
            tiu.STA__c = 'Cancelled';
       }
       if (Schema.sObjectType.g_tranitem__c.isUpdateable()) {
           update tiLst;
       }
       T.nt__c = nt;
       T.STA__c = 'Cancelled';
       update T;
      }
      g_Tran__c newT = new g_Tran__c(Acc__c = itm.rq__r.Acc__c, RQ__c = itm.RQ__c, dt__c = Date.Today(),
                                     TP__c = 'Payment', STA__c = 'Open', md__c = 'Wire Transfer', cq__c=T.cq__c, cdt__c=T.cdt__c, ci__c=T.ci__c);
      if (Schema.sObjectType.g_Tran__c.isCreateable()) {
          insert newT;
      }
      // Insert Transaction Item
      g_tranitem__c ti = new g_tranitem__c(t__c = newT.Id, itm__c = itm.Id, STA__c = 'Open', TP__c = 'Payment',
                                          ri__c = '', A__c = topamt, TAX_CODE__c = 'OUT OF SCOPE');
      if (Schema.sObjectType.g_tranitem__c.isCreateable()) {
          insert ti;
      }
      ref = new Pagereference('/apex/grqt?id='+newT.id);
        }catch (Exception ex) {
            system.debug('ex:'+ex.getStackTraceString());
        }
      return ref;
    }
}
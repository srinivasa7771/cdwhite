global class BatchDEGRec implements Database.Batchable < sObject >,Database.AllowsCallouts {
    public String queryString;
    public String mm;
    public BatchDEGRec() {   
       /* String status='Open';
        String pm='Credit / Debit Card';
       Datetime t = Datetime.now().addMinutes(-30);
      queryString='Select Id,Name,STA__c,TP__c,A__c,md__c,gwrf__c,gwcd__c,gwdt__c,gwmsg__c,Acc__r.adx__c, Acc__r.bg__c,Acc__r.Name,Acc__r.BillingStreet, Acc__r.BillingPostalCode,Acc__r.lc__c, RQ__r.Full_Name__c,RQ__r.Acc__r.Name,RQ__r.xaloc__c, RQ__r.CreatedBy.Name,RQ__r.Zone__c,RQ__r.rmob__c,RQ__r.xbn__c,RQ__r.xbrnd__c, RQ__c,RQ__r.xfpc__c,RQ__r.AP__c,RQ__r.xtpa__c, RQ__r.Name,RQ__r.STA__c, RQ__r.srvc__c,RQ__r.srvc__r.Name,RQ__r.srvc__r.uid__c,RQ__r.AOP__c, RQ__r.srvc__r.stg__r.apx__c,RQ__r.CreatedDate, (select id,A__c,exp__c,itm__c,itm__r.exp__c, itm__r.xcawb__c,itm__r.itm__r.Name,itm__r.itm__r.lbl__c,itm__r.sta__c,itm__r.sta__r.Courier_Stage__c,itm__r.sta__r.cd__c,itm__r.xcasc__c,itm__r.xcub__c ,itm__r.xcco__c from Items__r where isDeleted=false order by itm__r.itm__r.ord__c) from g_Tran__c WHERE sta__c=\''+status+'\''+'  and md__c=\''+pm+'\''+' and createddate>=Today and Last_Modified_Since__c>=30 LIMIT 200'; 
       */
        
        String status='Open';
        String pm='Credit / Debit Card';
        String pm2='Credit Card';
        Datetime t = Datetime.now().addMinutes(-30);
        queryString='Select Id,niord__c,Name,STA__c,TP__c,A__c,md__c,gwrf__c,gwcd__c,gwdt__c,gwmsg__c,Acc__r.adx__c, Acc__r.bg__c,Acc__r.Name,Acc__r.BillingStreet, Acc__r.BillingPostalCode,Acc__r.lc__c, RQ__r.Full_Name__c,RQ__r.Acc__r.Name,RQ__r.xaloc__c, RQ__r.CreatedBy.Name,RQ__r.Zone__c,RQ__r.rmob__c,RQ__r.xcawp__c,RQ__r.xcddocs__c,RQ__r.xbn__c,RQ__r.xbrnd__c, RQ__c,RQ__r.xfpc__c,RQ__r.AP__c,RQ__r.xtpa__c, RQ__r.Name,RQ__r.STA__c, RQ__r.srvc__c,RQ__r.srvc__r.Name,RQ__r.srvc__r.uid__c,RQ__r.AOP__c, RQ__r.srvc__r.stg__r.apx__c,RQ__r.CreatedDate, (select id,A__c,exp__c,itm__c,itm__r.exp__c, itm__r.xcawb__c,itm__r.itm__r.Name,itm__r.itm__r.lbl__c,itm__r.sta__c,itm__r.sta__r.Courier_Stage__c,itm__r.sta__r.cd__c,itm__r.xcasc__c,itm__r.xcub__c ,itm__r.xcco__c from Items__r where isDeleted=false order by itm__r.itm__r.ord__c) from g_Tran__c WHERE sta__c=\''+status+'\''+' and (md__c=\''+pm+'\''+' or md__c=\''+pm2+'\''+ ') and Last_Modified_Since__c>=30 order by CreatedDate desc LIMIT 200'; 
    }    
    public Database.QueryLocator start(Database.BatchableContext bc) {return Database.getQueryLocator(queryString);}
    /*public void execute(Database.BatchableContext bc, list<g_Tran__c>  trans) { greccc cls = new greccc(); List<greccc.TranSTA> stas=new List<greccc.TranSTA>(); Set<String> tids = new Set<String>(); Map<String, greccc.TranSTA> repMap = new Map<String, greccc.TranSTA>(); for(g_Tran__c t : trans){ greccc.TranSTA tt=cls.checkTrn(t.Id); repMap.put(tt.Id,tt); } System.debug('repMap: ' + repMap + ' ***  trans : ' + trans); cls.updateTransactions(repMap,trans); }*/
    public void execute(Database.BatchableContext bc, list < g_Tran__c > trans) { greccc cls = new greccc(); /*List < greccc.TranSTA > stas = new List < greccc.TranSTA > ();*/ Set < String > tids = new Set < String > (); Map < String, greccc.PaymentRes > repMap = new Map < String, greccc.PaymentRes > (); for (g_Tran__c t: trans) { greccc.PaymentRes tt = cls.getPaymentResponse(t.gwrf__c); if (String.isNotBlank(tt.STATE)) { repMap.put(t.Id, tt); } } System.debug('repMap: ' + repMap + ' ***  trans : ' + trans); cls.updateTransactions(repMap, trans); }
    public void finish(Database.BatchableContext bc) {}
}
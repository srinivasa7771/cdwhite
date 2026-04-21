public class BatchDEGRecAuth implements Database.Batchable < sObject >, Database.AllowsCallouts {
   public String queryString;
    public String mm;
    public  List<String> tlst;
    public BatchDEGRecAuth() {
        String status='Completed';
        String pm='Credit / Debit Card';
        String pm2='Credit Card';
        queryString='Select Id, niord__c, Name, STA__c, TP__c, A__c, md__c, gwrf__c, gwcd__c, gwdt__c, gwmsg__c from g_Tran__c WHERE TP__c=\'Payment\' and niord__c=\'\' and  sta__c=\''+
            status+'\''+' and (md__c=\''+pm+'\''+' or md__c=\''+pm2+'\''+ ') and CreatedDate = LAST_N_DAYS:100';
    }
    public BatchDEGRecAuth(String tr) {
        tlst = tr.split(', ');
        String status='Completed';
        String pm='Credit / Debit Card';
        String pm2='Credit Card';
        queryString='Select Id, niord__c, Name, STA__c, TP__c, A__c, md__c, gwrf__c, gwcd__c, gwdt__c, gwmsg__c from g_Tran__c WHERE name=:tlst and TP__c=\'Payment\' and niord__c=\'\' and  sta__c=\''+
            status+'\''+' and (md__c=\''+pm+'\''+' or md__c=\''+pm2+'\''+ ')';
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {return Database.getQueryLocator(queryString);}
    public void execute(Database.BatchableContext bc, list < g_Tran__c > trans) {
    greccc cls = new greccc();
    List <g_Tran__c> tlst = new List <g_Tran__c>();
    Map < String, greccc.PaymentRes > repMap = new Map < String, greccc.PaymentRes > ();
    for (g_Tran__c t: trans) {
        greccc.PaymentRes rt = cls.getPaymentResponse(t.gwrf__c);
        if (rt.MESSAGECODE == '00' && (rt.STATE).touppercase() == 'CAPTURED' && (rt.THREEDS_STATUS).touppercase() == 'SUCCESS') {
             t.niord__c = t.gwrf__c;t.gwrf__c = rt.AUTHCODE;tlst.add(t);
        }
    }
     if (tlst != null && !tlst.isEmpty())
       if (Schema.sObjectType.g_Tran__c.isUpdateable()) {
           update tlst;
       }

}
    public void finish(Database.BatchableContext bc) {}
}
/***
* apex contoller  to call  to intitaie specfic call from transction object
**/

public class gctlFUPushRepInv {
    public String respx{set;get;}

     public gctlFUPushRepInv() {}

        public void createFuInv() {
        String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        gtFussionWs.createInvoiceFu(wid);
        }

        public void createFuRep() {
        String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        gtFussionWs.createReceiptFu(wid);
        }

        public void createFuDM() {
        String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        gtFussionWs.createDebitMemoFu(wid);
        }

        public void cmDmappRep() {
        String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        gtFussionWs.CMDMApplicationFu(wid);
        }

        public void createYardiInv() {
        String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        gTYardiInvCreation.yardiInvCreation(wid);
        }

    public void createYardiBankAcc() {String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id')); gTYardiInvCreation.createBankAccinYardi(wid);}
    public void checkBalance() {
        Double balance=0.0;
        String wid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        String pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
        String typ = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('typ'));
        String resp= gtFussionWs.checkBalance(pid, typ);
        respx=resp;
        BalanceChkResp bresp= (BalanceChkResp) JSON.deserialize(resp, BalanceChkResp.class);
        if (bresp.STATUS=='Error') {
            balance=0.0;
        }
        else{
            balance= bresp.CUST_BAL_UNAPP;
        }
        g_reqitem__c ri =new g_reqitem__c(id=wid, xofub__c=balance);
        if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
            update ri;
        }
    }

}
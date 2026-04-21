/*  Batch class for refunding the customer deposit account. If the refund payment method is 'Customer deposit, '
 *  the amount will be topped up.
 *  If the payment method is 'Cash only, ' a credit memo will be generated
*/
global with sharing class BatchRefundTransOraFu  implements Database.Batchable < sObject > , Database.AllowsCallouts {

     public String invtype='NA';
     public String queryString='';
     public Static final String CD='Customer Deposit';
     public Static final String CASH='Cash';
     public boolean isTestClass=false;
      global BatchRefundTransOraFu(String tid) {
        queryString='Select Id, DMStatus__c, isinvoiceIntegrated__c, Invoice_Resp__c, BU_Inv__c, CMDMAPPRes__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Refund\' and sta__c=\'Open\' and md__c=\'Customer Deposit\' and fwf__c=true and id=\'' +
            tid + '\' and isDeleted=false and  dt__c != null  and cdm__c=null';
      }
      global BatchRefundTransOraFu(String sdt, String edt) {
         queryString='Select Id, DMStatus__c, isinvoiceIntegrated__c, Invoice_Resp__c, BU_Inv__c, CMDMAPPRes__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Refund\' and sta__c=\'Open\'  and md__c in (\'Customer Deposit\', \'Cash\') and fwf__c=true  and isDeleted=false and cdm__c=null and dt__c != null and dt__c>=' +
             sdt + ' and dt__c<=' + edt;
      }

      global Database.QueryLocator start(Database.BatchableContext BC) {
         system.debug('query::' + queryString);
         return Database.getQueryLocator(queryString);
        }

      global void execute(Database.BatchableContext BC, List < g_tran__c > lst) {
        g_tran__c trans=lst[0];
        boolean processOk=true;
        /* check if any vat  issues */
          List<g_TranItem__c> itmLsit=[select id, STA__c, noissue__c, name, itm__r.itm__r.cd__c  from g_TranItem__c where T__r.id=:trans.id];
          for (g_TranItem__c itm:itmLsit) {
            if (itmLsit != null && itmLsit.Size()>0 && (!itm.noissue__c ||  trans.A__c == 0 || itm.itm__r.itm__r.cd__c=='sd') ) {
              processOk=false;
            }

          }
            /* only if CM DM Not created*/
            if ((processOk && trans.md__C == CD && String.isEmpty(trans.Invoice_Resp__c) && String.isEmpty(trans.BU_Inv__c) && !trans.isinvoiceIntegrated__c && !trans.isReceiptIntegrated__c) || isTestClass) {
                gtFussionWs.createInvoiceFu(trans.id);
            }
            /* for payment mode cash only credit memo */
            else  if ((processOk && trans.md__C == CASH && String.isEmpty(trans.Invoice_Resp__c) && String.isEmpty(trans.BU_Inv__c) && !trans.isinvoiceIntegrated__c) || isTestClass) {
              gtFussionWs.createCreditMemoFu(trans.id);
            }
            /*if CM DM is success  and APP  not applied*/
            else if ((String.isEmpty(trans.CMDMAPPRes__c) && trans.md__c == CD && trans.DMStatus__c=='Success') || isTestClass) {
                gtFussionWs.CMDMApplicationDmyRecpFu(trans.id);
                String tid=trans.id;
                trans= [Select Id, Name, isinvoiceIntegrated__c, isReceiptIntegrated__c, CMDMAPPRes__c,
                    STA__c, Srv_Code__c, dt__c, A__c, md__c, Invoice_Resp__c, CMCustomerTransactionId__c,
                    Receipt_Resp__c, BU_Inv__c, Acc__c, Acc__r.park__c, TP__c, op__r.Name From g_tran__c where id=:tid and isDeleted=false][0];
                String cmdmResp=trans.CMDMAPPRes__c;
                String recpResp=trans.Receipt_Resp__c;
                /* check if CM DM applied  and  receipt created and update  customer balance */
                if ((!String.isEmpty(cmdmResp) && !cmdmResp.contains('error') && !recpResp.contains('error'))|| isTestClass) {
                    Savepoint sp = null;
                    Boolean tpAD = trans.TP__c == 'Refund' && trans.STA__c != 'Completed'  && trans.md__c == 'Customer Deposit';
                    try {
                        sp = Database.setSavepoint();
                        /*update the status of transaction items status as complete */
                        for (g_TranItem__c i: itmLsit) {i.STA__c='Completed';}

                        if (!itmLsit.isEmpty()) {update itmLsit;}
                        /*update the status of transaction status as complete */
                        trans.STA__c = 'Completed';
                        if (Schema.sObjectType.g_tran__c.isUpdateable()) {
                            update trans;
                        }
                        if (tpAD) {
                            Account A = [select id, adx__c, topupsr__c from Account where isDeleted = false and id =: trans.Acc__c];
                            A.topupsr__c =(A.topupsr__c == null ||  A.topupsr__c == 0.0) ? trans.A__c : A.topupsr__c + trans.A__C;
                            if (Schema.sObjectType.Account.isUpdateable()) {
                                update A;
                            }
                        }
                        } catch (exception ex) {
                            if (sp != null) {
                                Database.rollback(sp);
                            }
                        }

                }

            }

}

     public void finish(Database.BatchableContext bc) {}

}
global class BatchTransctionOraFu implements Database.Batchable < sObject > , Database.AllowsCallouts {
 public String queryString;
 public String invoice_or_receipt='NA';
 public String invtype='NA';
    global BatchTransctionOraFu(String tid) {
      queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where id=\'' +
          tid + '\'and TP__c=\'Payment\' and sta__c=\'Completed\' and isIntegrated__c=false and isDeleted=false';
    }
    global BatchTransctionOraFu(String sdt, String edt) {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isIntegrated__c=false and isDeleted=false and  dt__c != null and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
    }
    global BatchTransctionOraFu(String sdt, String edt, boolean backlog) {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isIntegrated__c=false and isDeleted=false and Need_to_be_checked__c=true and  dt__c != null and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
    }
    global BatchTransctionOraFu(String sdt, String edt, boolean backlog, String srvCode) {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isIntegrated__c=false and isDeleted=false and Need_to_be_checked__c=true and  Srv_Code__c=\'' +
            srvCode + '\' and  dt__c != null and dt__c>=' + sdt + ' and dt__c<=' + edt;
    }
    global BatchTransctionOraFu(String sdt, String edt, String srvCode) {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isIntegrated__c=false and isDeleted=false and  dt__c != null and Srv_Code__c=\'' +
            srvCode + '\' and dt__c>=' + sdt + ' and dt__c<=' + edt;
    }

    global BatchTransctionOraFu(String sdt, String edt, String srvCode, String specfic) {
        invoice_or_receipt=specfic;
        if (invoice_or_receipt=='ONLY_RECEIPT') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isReceiptIntegrated__c=false and isDeleted=false and  dt__c != null and  md__c in(\'Cash\', \'Credit / Debit Card\', \'Wire Transfer\', \'Credit Card\') and Srv_Code__c=\'' +
            srvCode + '\' and dt__c>=' + sdt + ' and dt__c<=' + edt;
        }else if (invoice_or_receipt=='ONLY_INVOICE') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isinvoiceIntegrated__c=false and isDeleted=false and  dt__c != null and Srv_Code__c=\'' +
            srvCode + '\' and dt__c>=' + sdt + ' and dt__c<=' + edt;
        }
    }

      global BatchTransctionOraFu(String sdt, String edt, String srvCode, String specfic, String cc) {
        invoice_or_receipt=specfic;
        if (invoice_or_receipt=='ONLY_RECEIPT') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isReceiptIntegrated__c=false and isDeleted=false and  dt__c != null and  md__c in(\'Cash\', \'Credit / Debit Card\', \'Wire Transfer\', \'Credit Card\')  and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
        }else if (invoice_or_receipt=='ONLY_INVOICE') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isinvoiceIntegrated__c=false and isDeleted=false and  dt__c != null and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
        }

    }

    global BatchTransctionOraFu(String sdt, String edt, String srvCode, String itype, Date dt) {
        invoice_or_receipt='ONLY_INVOICE';
        invtype=itype;
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isinvoiceIntegrated__c=false and isDeleted=false and Srv_Code__c=\'' +
            srvCode + '\'  and  dt__c != null and dt__c>=' + sdt + ' and dt__c<=' + edt;
    }

     /* not bundled service */
     global BatchTransctionOraFu(String sdt, String edt, String srvCode, String specfic, String cc, integer x) {
        invoice_or_receipt=specfic;
        if (invoice_or_receipt=='ONLY_RECEIPT') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isReceiptIntegrated__c=false and isDeleted=false and  dt__c != null and  md__c in(\'Cash\', \'Credit / Debit Card\', \'Wire Transfer\', \'Credit Card\') and  Srv_Code__c not in (\'208\', \'216\', \'322\', \'154\', \'159\', \'225\', \'156\', \'150\', \'tad\', \'tbg\')  and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
        }else if (invoice_or_receipt=='ONLY_INVOICE') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isinvoiceIntegrated__c=false and isDeleted=false and  dt__c != null and  md__c in (\'Cash\', \'Credit / Debit Card\', \'Wire Transfer\', \'Credit Card\', \'Customer Deposit\') and  Srv_Code__c not in (\'208\', \'216\', \'322\', \'154\', \'159\', \'225\', \'156\', \'150\', \'tad\', \'tbg\')  and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
        }
     }

    /* only cdbg bgcd demit memo creation */
    global BatchTransctionOraFu(String sdt, String edt, String srvCode, String specfic, integer cc, integer x) {
        invoice_or_receipt=specfic;
        if (invoice_or_receipt=='DM') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isinvoiceIntegrated__c=false and isDeleted=false and  dt__c != null and  md__c in (\'Customer Deposit\') and  Srv_Code__c  in (\'tbg\')  and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
        }
        if (invoice_or_receipt=='DUMMY_RECEIPT') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isReceiptIntegrated__c=false  and isDeleted=false and  dt__c != null and DMStatus__c=\'Success\' and  md__c in(\'Customer Deposit\') and  Srv_Code__c  in (\'tbg\')  and dt__c>=' +
            sdt + ' and dt__c<=' + edt;
        }
     }
    /* only cdbg bgcd demit memo creation */
    global BatchTransctionOraFu(String sdt, String edt, String srvCode, String specfic, String tid, integer cc, integer x) {
        invoice_or_receipt=specfic;
        if (invoice_or_receipt=='DM') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isinvoiceIntegrated__c=false and isDeleted=false and  dt__c != null and  md__c in (\'Customer Deposit\') and  Srv_Code__c  in (\'tbg\') and  id=\'' +
            tid + '\'  and dt__c>=' + sdt + ' and dt__c<=' + edt;
        }
        if (invoice_or_receipt=='DUMMY_RECEIPT') {
        queryString='Select Id, isinvoiceIntegrated__c, isReceiptIntegrated__c, NIORDID__c, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where TP__c=\'Payment\' and sta__c=\'Completed\' and isReceiptIntegrated__c=false  and isDeleted=false and  dt__c != null and  md__c in(\'Customer Deposit\') and  Srv_Code__c  in (\'tbg\') and  id=\'' +
            tid + '\' and dt__c>=' + sdt + ' and dt__c<=' + edt;
        }
     }
    global Database.QueryLocator start(Database.BatchableContext BC) {

       system.debug('query::' + queryString);
        return Database.getQueryLocator(queryString);
    }
     global void execute(Database.BatchableContext BC, List < g_tran__c > lst) {
         g_tran__c trans=lst[0];
         boolean processOk=true;

  List<g_TranItem__c> itm=[select id, noissue__c, name  from g_TranItem__c where T__r.id=:trans.id limit 1];
         if (itm != null && itm.Size()>0 && (!itm[0].noissue__c ||  trans.A__c == 0)) {
             processOk=false;
         }

         if (trans.md__c=='Credit Card' || trans.md__c=='Credit / Debit Card') {
             greccc cls = new greccc();
             greccc.PaymentRes tt = cls.getPaymentResponse(trans.NIORDID__c);
             if (tt.AMOUNT != trans.A__c) {processOk=false;}
           }

         if (processOk) {
          if (invoice_or_receipt=='NA') {
                     if (trans.md__c=='Customer Deposit' && (trans.Srv_Code__c!='tad' && trans.Srv_Code__c!='tbg')) {
                          gtFussionWs.createInvoiceFu(trans.id);
                     }else if (trans.md__c!='Customer Deposit' && (trans.Srv_Code__c=='tad' || trans.Srv_Code__c=='tbg')) {
                         gtFussionWs.createReceiptFu(trans.id);
                     }
                     else if (trans.md__c!='Customer Deposit' && (trans.Srv_Code__c!='tad' && trans.Srv_Code__c!='tbg')) {
                         gtFussionWs.createReceiptInvFu(trans.id);
                     }
                } else if (invoice_or_receipt=='ONLY_RECEIPT'|| invoice_or_receipt=='DUMMY_RECEIPT') {
                        gtFussionWs.createReceiptFu(trans.id);
                 }else if (invoice_or_receipt=='ONLY_INVOICE') {
                     if (invtype=='AXS' || invtype=='BU') {gtFussionWs.createInvoiceFu(trans.id, invtype);}
                     else {gtFussionWs.createInvoiceFu(trans.id);}
                 }
                 /* for cdbg bgcd*/
                  else if (invoice_or_receipt=='DM') {
                        gtFussionWs.createDebitMemoFu(trans.id);
                 }

        }

     }

    public void finish(Database.BatchableContext bc) {}

}
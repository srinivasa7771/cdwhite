public class rfc {
    public Boolean showOutputs{get;set;}
    public String ReceiptNo{get;set;}
    public String packageChoosen{get;set;}
    public Decimal amt{get;set;}
    public String refNo{get;set;}
    public String mobileNo{get;set;}
    public String emailAdd{get;set;}
    public String sigName{get;set;}
    public String notes{get;set;}
     public String pMtd{get;set;}
     public String bnkNM{get;set;}
    public Account acc;
    public rfc(ApexPages.StandardController ctrl) {
        List<String> fieldsToget = new List<String>{'adb__c', 'bgb__c'};
            if (!Test.isRunningTest()) {
                ctrl.addFields(fieldsToget);
            }
        acc = (account)ctrl.getRecord();
        Account ac = [select id, name, bandb__r.banm__c, bandb__r.bcode__c, bandb__r.Branch_Name__c, bandb__r.bnbId__c from account where id=:acc.id limit 1];
        bnkNM = ac.bandb__r.banm__c;
        String pMtd = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('pMtd'));
        if (string.isNotBlank(pMtd)) {
            showOutputs = true;
            packageChoosen = pMtd=='Customer Deposit'?'DEP':'BG';
            mobileNo = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('mb'));
            String amount = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('amt'));
            amt = Decimal.valueOf(amount);
            ReceiptNo = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('rcNo'));
            refNo = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('rfno'));
            emailAdd = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('em'));
            sigName = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('sgNm'));
            notes = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('nt'));
        }
    }
    public PageReference generateRefund() {
        String accId = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('id'));
           g_req__c rq=new g_req__c();
        try{

          String pMtd = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('pMtd'));

 if (string.isNotBlank(pMtd)) {
     showOutputs = true;
     packageChoosen = pMtd=='Customer Deposit'?'DEP':'BG';
     mobileNo = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('mb'));
     String amount = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('amt'));
     amt = Decimal.valueOf(amount);
     ReceiptNo = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('rcNo'));
     refNo = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('rfno'));
     emailAdd = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('em'));
     sigName = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('sgNm'));
     notes = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('nt'));
 }

         pMtd=packageChoosen;

         rq.srvc__c =Label.CUSTOMER_REFUND;
         rq.STA__c='Under Review';
         rq.Acc__c=accId;
         rq.xadh__c='rf;';
         rq.xtpa__c=amt;
         rq.xvtyp__c=pMtd;
         rq.xceml__c=emailAdd;
         rq.rmob__c=mobileNo;
         if (Schema.sObjectType.g_req__c.isCreateable()) {
             insert rq;
         }

         g_Tran__c T=new g_Tran__c(); T.md__c='Wire Transfer'; T.Acc__c=accId; T.RQ__c=rq.id; T.TP__c='Refund'; T.STA__c='Open'; insert T;

            g_Tran__c TT=[Select id, Name, Acc__r.ORACLE_PARTY_ID__c    from g_Tran__c where id=:T.id limit 1];

             // packageChoosen='BG';
           packageChoosen=packageChoosen=='Customer Deposit'?'DEP':'BG';
           String tdy=String.ValueOf(system.today());
           notes=notes+'Client email id:'+emailAdd+'--client mobile number:'+mobileNo;
           String xx='{"REFUND_AMOUNT":'+amt+', "REFUND_TYPE":"'+packageChoosen+'", "REFUND_DATE":"'+tdy+'", "ACCOUNT_NUMBER":"'+
               TT.Acc__r.ORACLE_PARTY_ID__c+'", "ACCOUNTING_DATE":"'+tdy+'", "REFUND_PAYMENT_METHOD":"NULL", "REFUND_REFERENCE_ID":"'+
               TT.Name+'", "REMITTANCE_MESSAGE_1":"'+notes+'", "REMITTANCE_MESSAGE_2":"'+notes+'"}';
           rq.xadtx1__c=xx;
           if (Schema.sObjectType.g_req__c.isUpdateable()) {
               update rq;
           }

            Account ac=[select id, adrfi__c, bgrfi__c from Account  where id=:accId limit  1];
            if (rq.xvtyp__c=='Customer Deposit') {
                ac.adrfi__c=ac.adrfi__c != null?ac.adrfi__c+amt:amt;
            }
            if (rq.xvtyp__c=='Bank Guarantee') {
                ac.bgrfi__c=ac.bgrfi__c != null?ac.bgrfi__c+amt:amt;
            }
            update ac;

            g_reqitem__c ri=[select id, xrramt__c, xtrf__c from g_reqitem__c where RQ__c=:rq.id limit 1];
            g_TranItem__c ti=new g_TranItem__c(); ti.T__c=T.id; ti.itm__c=ri.id; ti.STA__c='Open'; ti.Tp__c='Refund'; ti.TAX_CODE__c='Refund'; ti.A__c=amt; insert ti;

            ri.xrramt__c=amt;
            ri.xtrf__c=pMtd;
            update ri;

           // gtFussionWs.voidCreateRefund(xx, TT.id);
                 }catch (Exception e) {
                     gu.AddErrorMsg(e);
                     return null;
                    }
         return new PageReference('/apex/grqSInfo?id=' + rq.Id);
    }

    public PageReference generatePDF() {
        PageReference ref = null;
        system.debug('amt::'+amt);
        //packageChoosen = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('paymentMethod'));
        system.debug('packageChoosen::'+packageChoosen);
        refNo = '';
        if (amt == null || amt == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Sorry Amount cannot be blank or zero.'));
        }
        else if (amt != null && amt > 0 && (packageChoosen == null || packageChoosen=='')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Please choose the Method of payment.'));
        }
        else if ((packageChoosen == 'Customer Deposit' && amt > acc.adb__c) || (packageChoosen == 'Bank Guarantee' && amt > acc.bgb__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Sorry '+packageChoosen +' does not have enough Balance . Balance Remaining : '+acc.bgb__c));
            amt = 0;
        }

        else{
            showOutputs = true;
            DateTime currentDate = System.Now();
            refNo += (String.valueOf(currentDate.year())).subString(2, 4);
            refNo += String.valueOf(currentDate.month());
            refNo += String.valueOf(currentDate.day())+'-';
            refNo += String.valueOf(currentDate.hour());
            refNo += String.valueOf(currentDate.minute());
            refNo += String.valueOf(currentDate.second())+'-';
            refNo += String.valueOf(currentDate.millisecond()) ;

        }
        ref = new PageReference('/apex/rfForm');
        ref.getParameters().put('pMtd', packageChoosen);
        ref.getParameters().put('mb', mobileNo);
        ref.getParameters().put('amt', String.valueOf(amt));
        ref.getParameters().put('id', acc.id);
        ref.getParameters().put('rcNo', ReceiptNo);
        ref.getParameters().put('rfno', refNo);
        ref.getParameters().put('em', emailAdd);
        ref.getParameters().put('sgNm', sigName);
        ref.getParameters().put('nt', notes);
        ref.setRedirect(true);

        return ref;
    }
}
public class gctlqrlstr {

    public g_Req__c rq {get;set;}
    public list<StatusHistory>  stahis;
    public list<Courier_History__c> cstahis;
    //Public list<g_Tran__c> rqtrans {get;set;}
    public list<g_Tran__c> rqtransLst {get;set;}
    public boolean paydone{get;set;}
    public boolean updateFlg{get;set;}

    public List<SelectOption> getStsLst() {
        List<SelectOption> op = new List<SelectOption>();
        op.add(new SelectOption('Open', 'Open'));
        op.add(new SelectOption('Cancelled', 'Cancelled'));
        op.add(new SelectOption('Completed', 'Completed'));
        return op;
    }

    public gctlqrlstr() {
        system.debug('In >> gctlqrlstr 1');
        rqtransLst = getRqtrans();
        system.debug('rqtransLst >> '+rqtransLst);
        updateFlg=false;
    }
    public gctlqrlstr(ApexPages.StandardController controller) {

    }

    public list<g_Tran__c>  getRqtrans() {
        system.debug('In >> getRqtrans');
        string rqid = '';
        if (rq != null)
            rqid = rq.id;

        if ( String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('id')) != null &&  String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('id')) != '') {
            rqid = apexpages.currentpage().getparameters().get('id');
        }

        if ( String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('ref')) != null &&  String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('ref')) != '') {
           // rqid = prcssPayRef( Apexpages.currentPage().getParameters().get('ref'));
        }

        list<g_Tran__c>  rqtrans =  database.query(Label.qryTrn+' where RQ__c=\''+rqid+'\' and isDeleted=false LIMIT 999');

       if (rqtrans == null) rqtrans =new list<g_Tran__c>();
       return rqtrans;
   }

   public PageReference updateTran() {
       updateFlg=true;
       return null;
   }
   public PageReference cancelTran() {
       updateFlg=false;
       return null;
   }
   public PageReference saveTran() {
        system.debug('In >> updateTran');
        system.debug('rqtransLst >>'+ rqtransLst);
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rqtransLst;
        }
        updateFlg=false;
        return null;
    }

    public pagereference editModeRq() {
            system.debug('/apex/grqtopup?id='+rq.id+'&cn=tad&m=e');
          PageReference pageRef = new PageReference('/apex/grqtopup?id='+rq.id+'&cn=tad&m=e');
           // PageReference pageRef = new PageReference('www.google.com');
             pageRef.setRedirect(true);
                return pageRef;
    }

   public list<StatusHistory>  getStahis() {
       string rqid = '';
        if (rq != null)
            rqid = rq.id;
        else{
            rqid = apexpages.currentpage().getparameters().get('id');
        }
       list<StatusHistory> shLst = new list<StatusHistory>();

       if (shLst == null || shLst.isEmpty()) {
          List<g_itmHistorySTA__c> stLst =  database.query(Label.qrySH+' where RQ__c=\''+rqid+'\' and isDeleted=false order by itm__r.itm__r.ord__c, CreatedDate LIMIT 999');
           if (stLst != null && !stLst.isEmpty()) {
               for (g_itmHistorySTA__c st : stLst) {
                   StatusHistory sth = new StatusHistory();
                   if (st.Duration__c != null) {
                       List<string> lst = string.valueOf(st.Duration__c).split('.');
                       if (lst != null && lst.size() >1) {
                           decimal hr = decimal.valueOf(lst[0]);
                           string min = lst[1].substring(0, 2);
                           if (hr != 0 && min != '00' )
                             sth.dur = hr+ ' hrs :'+min+' min';
                           else if (hr != 0 && min == '00')
                             sth.dur = hr+ ' hrs';
                           else
                              sth.dur = min+' min';
                       }
                       else if (lst != null && lst.size() == 1)
                         sth.dur = lst[0]+ ' hrs';
                   }
                   sth.sh = st;
                   shLst.add(sth);
               }
           }
       }

       if (shLst == null) shLst =new list<StatusHistory>();
       return shLst;
   }
    public list<Courier_History__c>  getCstahis() {
        string rqid = '';
        if (rq != null)
            rqid = rq.id;
        else{
            rqid = apexpages.currentpage().getparameters().get('id');
        }
        if (cstahis == null || cstahis.isEmpty()) {
          cstahis =  database.query(Label.qryCH+' where Courier_req__c=\''+rqid+'\' and isDeleted=false LIMIT 999'); }
       if (cstahis == null) cstahis =new list<Courier_History__c>();
       return cstahis;
   }
    public class StatusHistory{
        Public string dur {set;get;}
        public  g_itmHistorySTA__c sh {set;get;}

    }

  public Boolean  prcssPayRef(String ref) {
        Set<Id> riIds = new Set<Id>();
       if (ref == null || ref == '') {gU.AddErrorMsg(Label.msgNoTns);return false;}

       list<g_Tran__c>  rqtrans =  database.query(Label.qryTrn+' where  gwrf__c=\''+ref+'\' and isDeleted=false LIMIT 999');

        system.debug('rqtrans::'+rqtrans);
        if (rqtrans.size()!=1) {gU.AddErrorMsg(Label.msgNoTns);return false;}
        g_Tran__c T = rqtrans[0];
        Id rqid = T.RQ__c;

        return true;
  }
}
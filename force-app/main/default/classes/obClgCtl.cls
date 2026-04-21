public class obClgCtl {
    public Task tsk {set;get;}
    public g_req__c req {set;get;}
    public string prk {set;get;}
    public string cltp {set;get;}
    public string rmdDt {set;get;}
    public date accClsDt {set;get;}
    public string reason {set;get;}
    public string logCtg {set;get;}
    public boolean extFlg {set;get;}
    public List<CallLog> clgLst {set;get;}
    public List<AccWrp> dupAccLst {set;get;}

    public obClgCtl() {
        String rId = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('rid'));
        tsk = new Task();
        cltp = '';//rmd
        extFlg = false;
        clgLst = new List<CallLog>();
        dupAccLst = new List<AccWrp>();
        req = [select id, name, xcreson__c, xcebr__c, srvc__c, acc__c, Full_Name__c, xcfn__c,
            xcln__c, xaccbrand__c, nt__c, xceml__c, xcmob__c, ldmob__c, cldt__c, clcnt__c, onhold__c,
            acc__r.name, acc__r.park__c, acc__r.ccrm_sfid__c, acc__r.ORACLE_PARTY_ID__c, acc__r.os__c,
            acc__r.createddate, (select id, Status from Tasks where Status='Open') from g_req__c where id=:rId];
        prk = '/css/brand-'+req.acc__r.park__c+'.css';

        for (Task tsk : [select id, owner.name, Status, Log_Reasons__c, IsReminderSet, createddate, ReminderDateTime, Description from Task where whatid=:req.id order by createddate desc]) {
            CallLog cl =  new CallLog();
            cl.description = tsk.Description;
            cl.logReason = tsk.Log_Reasons__c;
            cl.rmddt = (tsk.ReminderDateTime != null) ? date.valueOf(tsk.ReminderDateTime) : null;
            cl.cldt = date.valueOf(tsk.createddate);
            cl.owner = tsk.owner.name;
            cl.rmdFlg = tsk.IsReminderSet;
            clgLst.add(cl);
        }
        for (g_req__c rq : [select id, name, xcreson__c, xcebr__c, srvc__c, acc__c, Full_Name__c,
            xcfn__c, xcln__c, xaccbrand__c, nt__c, xceml__c, xcmob__c, ldmob__c, acc__r.name,
            acc__r.ccrm_sfid__c, acc__r.ORACLE_PARTY_ID__c from g_req__c where Service_Code__c ='322' and acc__r.lc__c !=:Label.Onboarding_Account_LC and id!=:req.id and sta__c in ('Draft',
                'Open') and xceml__c=:req.xceml__c and ldmob__c=:req.ldmob__c and AP__c=0 ]) {
            AccWrp acc = new AccWrp();
            acc.nm = rq.Full_Name__c;
            acc.prk = rq.xaccbrand__c;
            acc.em = rq.xceml__c;
            acc.ph = rq.ldmob__c;
            acc.accid = rq.Acc__c;
            acc.rqid = rq.id;
            acc.partyId = rq.acc__r.ORACLE_PARTY_ID__c;
            acc.crmAccId = rq.acc__r.ccrm_sfid__c;
            acc.isSel = false;
            dupAccLst.add(acc);
            system.debug('dupAccLst11::');
        }

            Date accExtDt = (GDRFAUtil.noOfWorkingDays((req.Acc__r.createddate).date(), 21)).date();
            accClsDt = (GDRFAUtil.noOfWorkingDays((req.Acc__r.createddate).date(), 31)).date();
            Date tdt = Date.today();
            if (tdt  > accExtDt) {
               extFlg = true;
            }

        system.debug('dupAccLst::'+dupAccLst.size());

    }
    public PageReference crtTask() {
        PageReference ref = null;
        g_req__c rqUpd = new g_req__c(id=req.id);
        if (req.tasks != null && !req.tasks.isEmpty() ) {
            List<Task> tskLst = req.tasks;
            for (Task t : tskLst) {
                t.Status = 'Completed';
            }
            if (Schema.sObjectType.Task.isUpdateable()) {
                update tskLst;
            }
        }
        datetime clgdt = null;
        Date dt = null;
        tsk.Subject = 'Call Log for SR#'+req.name;
        tsk.Priority = 'Normal';
        tsk.Log_Reasons__c = logCtg;
        tsk.OwnerId = Userinfo.getUserId();
        tsk.WhatId = req.id;
        rqUpd.clcnt__c = (req.clcnt__c == null) ? 1 : (req.clcnt__c + 1);
        if (String.isNotBlank(rmdDt)) {
            dt = GDRFAUtil.strDate(rmdDt);
            rqUpd.cldt__c = (GDRFAUtil.noOfWorkingDays(dt, 1)).date();
        }
        else{
            if (rqUpd.clcnt__c > 2)
             rqUpd.cldt__c = null;
            else
             rqUpd.cldt__c = (GDRFAUtil.noOfWorkingDays((req.Acc__r.createddate).date(), 22)).date();
        }
        if (String.isNotBlank(logCtg) && logCtg == 'Contacted and assigned to PRM') {
            rqUpd.xcebr__c = true;
        }
        else
           rqUpd.xcebr__c = false;
       if (String.isNotBlank(cltp) && cltp == 'rmd') {
                tsk.IsReminderSet = true;
                tsk.Status = 'Open';
                Time t = Datetime.now().time();
                tsk.ReminderDateTime = datetime.newInstance(dt, t);
                rqUpd.onhold__c = true;
       }
       else{
            tsk.Status = 'Completed';
           rqUpd.onhold__c = false;
        }
        if (Schema.sObjectType.Task.isCreateable()) {
            insert tsk;
        }
        List<ws_call__c> wslst = new List<ws_call__c>();
        if (cltp == 'cn') {
            system.debug('reason::'+reason);
            AccWrp acc = new AccWrp();
            acc.nm = req.Full_Name__c;
            acc.prk = req.xaccbrand__c;
            acc.em = req.xceml__c;
            acc.ph = req.ldmob__c;
            acc.isSel = true;
            acc.partyId = req.acc__r.ORACLE_PARTY_ID__c;
            acc.crmAccId = req.acc__r.ccrm_sfid__c;
            acc.accid = req.Acc__c;
            acc.rqid = req.id;
            dupAccLst.add(acc);
            List<id> accIdLst = new List<id>();
            List<id> rqIdLst = new List<id>();
            for (AccWrp a : dupAccLst) {
                system.debug('acc:'+a.nm+'Sel::'+a.isSel);
                if (a.isSel) {
                    accIdLst.add(a.accid);
                    rqIdLst.add(a.rqid);
                    ws_call__c ws = new ws_call__c();
                    ws.rq_jsn__c = '{ "methodName": "canelaccount", "data": [ { "ccrmAccountId": "'+a.crmAccId+'", "oraclePartyId": "'+
                        a.partyId+'", "accountStatus": "Cancelled", "reason": "'+reason+'", "category": "Spam" } ] }';
                    ws.intsts__c = 'Ready for Integration';
                    ws.pmid__c = a.crmAccId;
                    ws.ws_typ__c = 'Onboarding';
                    ws.mtd_nm__c = 'updateCRMStatus';
                    wslst.add(ws);
                   /* String rqJs = '{ "methodName": "canelaccount", "data": [ { "ccrmAccountId": "'+a.crmAccId+'", "oraclePartyId": "'+a.partyId+'", "accountStatus": "Cancelled", "reason": "'+reason+'", "category": "Spam" } ] }';
                    system.debug('rq body::'+rqJs);
                    grqWsOnboard.cancelAccount(rqJs);*/
                }
            }

            grqWsOnboard.updateUsrAccess(accIdLst);
            if (wslst != null && !wslst.isEmpty()) {
                if (Schema.sObjectType.ws_call__c.isCreateable()) {
                    insert wslst;
                }
            }
            grqWsOnboard.closeOnbAcc(rqIdLst, accIdLst, req.srvc__c);
        }
        else
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update rqUpd;
            }

        ref = new PageReference('/'+req.id);
        ref.setRedirect(true);
        return null;
    }
    public class CallLog{
        public Date cldt {set;get;}
        public Date rmddt {set;get;}
        public string description {set;get;}
        public string logReason {set;get;}
        public string owner {set;get;}
        public boolean rmdFlg {set;get;}
    }
    public class AccWrp{
        public string nm {set;get;}
        public string prk {set;get;}
        public string em {set;get;}
        public string ph {set;get;}
        public string crmAccId {set;get;}
        public string partyId {set;get;}
        public id accid {set;get;}
        public id rqid {set;get;}
        public boolean isSel {set;get;}

    }

}
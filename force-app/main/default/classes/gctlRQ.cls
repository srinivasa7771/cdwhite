public with sharing class gctlRQ  {
    public String empid{get;set;}
    public String encid{get;set;}
    public String sid{get;set;}
    public String pid{get;set;}
    public String iid{get;set;}
    public Boolean isgu{get;set;}
    public Boolean Test{get;set;}
    public string cn{get;set;}
    public string section{get;set;}
    public string rqNo{get;set;}
    public g_Req__c rq{get;set;}
    public User U {get;set;}

    public gctlRQ () {}
    public gctlRQ (ApexPages.StandardController c) {

        if (String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'))!=null) {
            rq = [select Id, Name, xuvdet__c, xfb__c, srvc__c, srvc__r.uid__c, srvc__r.stg__c,
                srvc__r.stg__r.pg__c, i_STA__c, AUP__c, os__c from g_Req__c where id=: String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'))];
            rqNo=rq.Name;
        }
        if (rq != null && rq.id != null) {}
        section = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sc'));
    }
    @TestVisible
    private g_Srvc__c getSrvc(String cd) {
        if (cd == null) {
            return null;
        }
        list<g_Srvc__c> srvcs = [Select id, stg__c, stg__r.pg__c From g_Srvc__c where uid__c=:cd limit 1];
        if (srvcs.size() <=0) {
            return null;
        }
        return srvcs[0];
    }
    @TestVisible
    private PageReference getPage(String md) {
        PageReference p;
        U = [select Id, accountid, contact.account.id, contact.account.os__c, contact.account.Prk__c, contact.account.Type
             from User where id =: UserInfo.getUserId() limit 1
            ];
        system.debug('usr>>' + U);
        /* if (U != null && U.contact.account.os__c != null && U.contact.account.os__c=='Completed') {
p = new PageReference('/apex/gpmIn5');
}
else{*/

        isgu = gu.isGuestUser(userInfo.getProfileId());
        if (isgu) {
            empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));

            encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
            sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
            pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
            iid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        }
        if (md == null) {
            return null;
        }
        if (md == 'n') {
            String sc = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('c'));
            cn = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('cn'));
            if (sc == null) {
                return null;
            }
            g_Srvc__c s = getSrvc(sc);
            if (s == null) {
                return null;
            }
            if (s.stg__c == null) {
                return null;
            }
            if (s.stg__r.pg__c == null) {
                return null;
            }
            if ((sc == gu.csStr('ParkingActivation') || sc == gu.csStr('ParkingLostCard') || sc == gu.csStr('ParkingModification')) && cn != null) {
                p = new PageReference('/apex/' + s.stg__r.pg__c + '?sid=' + s.Id + '&cn=' + cn);
            }

            else {
                p = new PageReference('/apex/' + s.stg__r.pg__c + '?sid=' + s.Id);
            }
        } else {
            /*if (isgu && iid != null) {
rq = [select Id, srvc__c, damsgs__c, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.bopg__c, AOP__c, AP__c from g_Req__c where id =: iid];
p = new PageReference('/apex/' + rq.srvc__r.stg__r.pg__c + '?id=' + iid + '&empid=' + empid + '&enc=' + encid + '&sid=' + sid + '&pid=' + pid);
return p;
}*/
            rq = [select Id, xuvdet__c, AUP__c, os__c, xvtyp__c, Name, damsgs__c, xcawp__c, xmloc__c,
                STA__c, srvc__c, srvc__r.uid__c, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.bopg__c,
                i_STA__c, AP__c, AOP__c, srvc__r.sdg__c, Acc__r.clt__c from g_Req__c where id =: rq.id];
            /*MS 1.1*/
            /*MS 1.1*/
            if (rq.srvc__c == null) {
                return null;
            }
            if (rq.srvc__r.stg__c == null) {
                return null;
            }
            if (rq.srvc__r.stg__r.pg__c == null) {
                return null;
            }
            if (!isgu) {
                if (rq.srvc__r.stg__r.bopg__c == null) {
                    system.debug('rq.srvc__r.UID__c --' + rq.srvc__r.UID__c + ' && rq.STA__c --' + rq.STA__c);
                    system.debug('status1');
                    if ((rq.srvc__r.UID__c == '159' || rq.srvc__r.UID__c == '149' || rq.srvc__r.UID__c == '152') && (rq.STA__c == 'Open' || rq.STA__c == 'Under Review')) p = new PageReference('/apex/grqStatus?id=' +
                        rq.Id + '&m=' + md);
                    else if (rq.srvc__r.UID__c == 'crf') p = new PageReference('/apex/grqStatus?id=' + rq.Id + '&m=' + md);
                    /* defaulted to status page for Customer Refund service for all statuses */ else if ((rq.srvc__r.UID__c == 'gv' || rq.srvc__r.UID__c == '071') && rq.STA__c == 'Draft') p = new PageReference('/grqsdr?sid=' + rq.srvc__r.sdg__c + '&id=' + rq.id + '&d=n');
                    else if (rq.srvc__r.UID__c == '208' && rq.xcawp__c && rq.AP__c == 0 && rq.xmloc__c && rq.damsgs__c != 'Make corrections to the application') {
                        system.debug('status2');
                        p = new PageReference('/apex/' + rq.srvc__r.stg__r.pg__c + '?id=' + rq.Id + '&m=' + md);
                        system.debug('after status 2');
                    }
                    else if (rq.AP__c > 0 || rq.AOP__c > 0 || ((rq.srvc__r.UID__c == 'vfs' || rq.srvc__r.UID__c == '327' || rq.srvc__r.UID__c == '150' || rq.srvc__r.UID__c == '149' || rq.srvc__r.UID__c == '152' || rq.srvc__r.UID__c == '154' || rq.srvc__r.UID__c == '159' || rq.srvc__r.UID__c == '220' || rq.srvc__r.UID__c == '135' || rq.srvc__r.UID__c == '155' || rq.srvc__r.UID__c == '148' || rq.srvc__r.UID__c == '136' || rq.srvc__r.UID__c == 'uae' || rq.srvc__r.UID__c == 'apt' || rq.srvc__r.UID__c == 'dnc' || rq.srvc__r.UID__c == '208' || rq.srvc__r.UID__c == 'ltp' || rq.srvc__r.UID__c == 'uma' || rq.srvc__r.UID__c == '922') && (rq.STA__c == 'Under Review' || rq.STA__c == 'Cancelled' || rq.STA__c == 'Rejected' || rq.STA__c == 'In Process' || rq.STA__c == 'Completed' || rq.damsgs__c == 'Make corrections to the application'))) {
                        p = new PageReference('/apex/grqStatus?id=' + rq.Id + '&m=' + md);
                        /*MS 1.1 start*/ if (rq.srvc__r.UID__c == '216' && rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' && (rq.AUP__c > 0 || rq.os__c != 'CCL Accepted')) {
                            p = new PageReference('/apex/lerqob?id=' + rq.Id);
                        }
                        /*MS 1.1 end*/ if (rq.srvc__r.UID__c == '156' && !checkAllCardsPaid(rq.xuvdet__c) && !(rq.STA__c == 'Cancelled' || rq.STA__c == 'Rejected' || rq.STA__c == 'Completed') ) {
                            p = new PageReference('/apex/' + rq.srvc__r.stg__r.pg__c + '?id=' + rq.Id + '&m=' + md);
                        }
                        else if (rq.srvc__r.UID__c == '156') {
                            p = new PageReference('/apex/grqStatus?id=' + rq.Id + '&m=' + md);
                        }
                    }
                    else if ((rq.STA__c == 'Cancelled' || rq.STA__c == 'Rejected' || rq.STA__c == 'Completed')) p = new PageReference('/apex/grqStatus?id=' + rq.Id + '&m=' + md);
                    else {
                        system.debug('status3');
                        system.debug('rq.srvc__r.UID__c --' + rq.srvc__r.UID__c + ' && rq.STA__c --' + rq.STA__c);
                        p = new PageReference('/apex/' + rq.srvc__r.stg__r.pg__c + '?id=' + rq.Id + '&m=' + md);
                        system.debug('after status3');
                    }
                }
                else {
                    system.debug('status 4');
                    p = new PageReference('/apex/' + rq.srvc__r.stg__r.bopg__c + '?id=' + rq.Id + '&m=' + md);
                    system.debug('after status 4');
                }
            }
            else {
                if (rq.AP__c > 0 || rq.AOP__c > 0 || (rq.STA__c == 'Under Review' || rq.STA__c == 'Cancelled' || rq.STA__c == 'Rejected' || rq.STA__c == 'In Process' || rq.STA__c == 'Completed' || rq.damsgs__c == 'Make corrections to the application')) {
                    p = new PageReference('/apex/grqiStatus?id=' + rq.Id + '&empid=' + empid + '&enc=' + encid + '&sid=' + sid + '&pid=' + pid + '&m=' + md);
                    system.debug('status5');
                }
                else {
                    p = new PageReference('/apex/' + rq.srvc__r.stg__r.pg__c + '?id=' + rq.id + '&empid=' + empid + '&enc=' + encid + '&sid=' + sid + '&pid=' + pid + '&m=' + md);
                    system.debug('status6');
                }
            }
        }
        gU.checkNav();

        system.debug('page-- '+p);
        return p;
    }
    public void updateItemSTA() {
        list<g_reqitem__c> Itms = new list<g_reqitem__c>();
        boolean isReqCompleted = false;
        List<g_reqitem__c> itmIds=[SELECT Id, RQ__c, sta__c, sta__r.Next_Status__c, sta__r.Next_Status__r.rqSTA__c,
            itm__c, itm__r.cd__c from g_reqitem__c where RQ__c =:rq.id and sta__r.isfn__c=true and isdeleted=false order by createdDate desc];
        System.debug('updateItemSTA - <itmIds> : ' + itmIds);
        if (!itmIds.isEmpty() && itmIds.size()>0) {
            for (g_reqitem__c i:itmIds ) {
                i.sta__c=i.sta__r.Next_Status__c;
                if ((i.sta__r.Next_Status__c != null && i.sta__r.Next_Status__r.rqSTA__c == 'Completed') || (i.itm__r.cd__c == 'ai' && i.sta__r.Next_Status__c != null) ) {
                    rq.STA__c = i.sta__r.Next_Status__r.rqSTA__c;
                    isReqCompleted = true;
                }
                Itms.add(i);
            }
        }
        if (!Itms.isEmpty() && Itms.size()>0) {
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update Itms;
            }
            if (isReqCompleted) {
                /*rq.STA__c='Completed';
                */ update rq;
            }
        }
    }
    public PageReference nP() {try{return getPage('n');}catch (exception ex) {gu.AddErrorMsg(ex); return null;}}
    public PageReference vP() {try{return getPage('v');}catch (exception ex) {gu.AddErrorMsg(ex); return null;}}
    public PageReference eP() {try{return getPage('e');}catch (exception ex) {gu.AddErrorMsg(ex); return null;}}

    public Boolean checkAllCardsPaid(String xuvdet) {
        if (String.isBlank(xuvdet)) {
            return false;
        }
        try {
            Map<String, Object> xuvdetMap = (Map<String, Object>) JSON.deserializeUntyped(xuvdet);
            List<Object> cardsList = (List<Object>) xuvdetMap.get('cardslist');
            if (cardsList == null || cardsList.isEmpty()) {
                return false;
            }
            for (Object cardObj : cardsList) {
                Map<String, Object> card = (Map<String, Object>) cardObj;
                Boolean isPaid = (card.containsKey('isPaid')) ? (Boolean) card.get('isPaid') : false;
                if (isPaid == null || !isPaid) {
                    return false;
                }
            }
            return true;
        }
        catch (Exception e) {
            return false;
        }
    }
}
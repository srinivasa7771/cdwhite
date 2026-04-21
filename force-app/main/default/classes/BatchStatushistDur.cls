global class BatchStatushistDur implements Database.Batchable < sObject > {
    public String queryString;
    public static Boolean isBatchUpdate = false;
    private static BusinessHours bsHour;
    public BatchStatushistDur() {
    }
    global BatchStatushistDur(String rqno) {
        this();
        queryString = 'select id from g_req__c where name=\'' + rqno + '\'';
        system.debug(queryString);
    }
    /* global BatchStatushistDur(String srvcds, String sdt, String edt) {
        this();
        queryString = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and srvc__r.uid__c  in : uidLst  and xfpc__c != null and xfpdd__c>=' + sdt + ' and xfpdd__c<=' + edt;
        system.debug(queryString);
    }
    */ global BatchStatushistDur(String sdt, String edt) {
        this();
        queryString = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and srvc__r.uid__c in (\'001\', \'002\', \'004\', \'040\', \'003\', \'020\', \'021\', \'078\', \'076\', \'106\', \'601\', \'640\', \'620\', \'603\', \'903\') and xfpc__c != null and xfpdd__c>=' +
            sdt + ' and xfpdd__c<=' + edt;
        system.debug(queryString);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List < g_req__c > scope) {
        try {
            system.debug('getQueryLocator1');
            if (bsHour == null) {
                bsHour = [SELECT Id FROM BusinessHours WHERE id =: gU.csStr('BH')];
            }
            List < g_itmHistorySTA__c > mdLst = [select id, RQ__r.srvc__r.uid__c, itm__r.itm__r.cd__c,
                f__r.cd__c, t__r.cd__c, cd__c, name, statype__c, exp__c, estE__c, staowner__c, SLA_Action__c,
                acts__c, actE__c, sla__c, Duration__c, f__r.staown__c, f__r.slaa__c, f__r.statype__c,
                f__r.slaN__c, f__r.slaXP__c from g_itmHistorySTA__c where RQ__r.id =: scope[0].id order by createddate];
            List < g_itmHistorySTA__c > newRPLST = new List < g_itmHistorySTA__c > ();
            for (g_itmHistorySTA__c rp: mdLst) {
                DateTime startDt = rp.acts__c;
                DateTime endDt = rp.actE__c;
                boolean rpflg = false;
                if (rp.itm__r.itm__r.cd__c == 'ep' && !rpflg && rp.t__r.cd__c == 'if') {
                    List < g_itmHistorySTA__c > epLst = [select id,
                        actE__c from g_itmHistorySTA__c where RQ__r.id =: scope[0].id and itm__r.itm__r.cd__c = 'ofl' and t__r.cd__c in ('ok') order by createddate desc limit 1 ];
                    if (epLst != null && !epLst.isEmpty() && endDt >= epLst[0].actE__c) {
                        startDt = epLst[0].actE__c;
                        rp.acts__c = startDt;
                        rpflg = true;
                    }
                }
                else if (rp.itm__r.itm__r.cd__c == 'rp' && rp.t__r.cd__c == 'if') {
                    List < g_itmHistorySTA__c > iaLst = [select id,
                        actE__c from g_itmHistorySTA__c where RQ__r.id =: scope[0].id and((itm__r.itm__r.cd__c = 'ia' and t__r.cd__c in ('ok',
                        'ebr', 'ebn')) or(itm__r.itm__r.cd__c = 'rp' and t__r.cd__c = 'v') or (itm__r.itm__r.cd__c = 'rp' and t__r.cd__c = 'ics')) order by createddate desc limit 1];
                    if (iaLst != null && !iaLst.isEmpty() && endDt >= iaLst[0].actE__c) {
                        startDt = iaLst[0].actE__c;
                        rp.acts__c = startDt;
                    }
                    else if (iaLst != null && !iaLst.isEmpty() && endDt < iaLst[0].actE__c) {
                        startDt = endDt;
                        rp.acts__c = startDt;
                    }
                }
                else if ((rp.itm__r.itm__r.cd__c == 'md' || rp.itm__r.itm__r.cd__c == 'moh') && rp.f__r.cd__c == 'fi') {
                    List < g_itmHistorySTA__c > rpLst = [select id,
                        actE__c from g_itmHistorySTA__c where RQ__r.id =: scope[0].id and((itm__r.itm__r.cd__c = 'ai' and t__r.cd__c in ('dr')) or(itm__r.itm__r.cd__c = 'la' and t__r.cd__c = 'ii')) order by createddate desc limit 1];
                    if (rpLst != null && !rpLst.isEmpty() && endDt >= rpLst[0].actE__c) {
                        startDt = rpLst[0].actE__c;
                        rp.acts__c = startDt;
                    }
                    else if (rpLst != null && !rpLst.isEmpty() && endDt < rpLst[0].actE__c) {
                        startDt = endDt.addHours(-26);
                        rp.acts__c = startDt;
                    }
                }
                else if (rp.itm__r.itm__r.cd__c == 'ia' && (rp.f__r.cd__c == 'n' || rp.f__r.cd__c == 'rv')) {
                    List < g_itmHistorySTA__c > mLst = [select id,
                        actE__c from g_itmHistorySTA__c where RQ__r.id =: scope[0].id and((itm__r.itm__r.cd__c = 'md' and t__r.cd__c = 'ok') or(itm__r.itm__r.cd__c = 'rp' and t__r.cd__c = 'v')  or(itm__r.itm__r.cd__c = 'la' and t__r.cd__c = 'ok') or(itm__r.itm__r.cd__c = 'ai' and t__r.cd__c = 'ok')) order by createddate desc limit 1];
                    if (mLst != null && !mLst.isEmpty() && endDt >= mLst[0].actE__c) {
                        startDt = mLst[0].actE__c;
                        rp.acts__c = startDt;
                    }
                    else if (mLst != null && !mLst.isEmpty() && endDt < mLst[0].actE__c) {
                        startDt = endDt;
                        rp.acts__c = startDt;
                    }
                }
                Double cd = calDuration(bsHour.id, rp.acts__c, rp.actE__c);
                rp.cd__c = cd;
                rp.Duration__c = cd;
                newRPLST.add(rp);
            }
            if (Schema.sObjectType.g_itmHistorySTA__c.isUpdateable()) {
                update newRPLST;
            }
        }
        catch (Exception e) {
            system.debug('getQueryLocator2');
            system.debug(e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
    public decimal calDuration(String bhid, datetime st, datetime et) {
        Integer toHour = 3600000;
        Decimal d = 0;
        d = ((Double) BusinessHours.diff(bhid, st, et)) / toHour;
        return d;
    }
}
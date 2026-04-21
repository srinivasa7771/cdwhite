global class BatchStatushistUpdate implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global String query;
    global BatchStatushistUpdate(String sdt, String edt, boolean uid) {
        query = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and STA__c in (\'Open\', \'Under Review\', \'In Process\') and srvc__r.uid__c in (\'220\', \'208\', \'200\', \'dnc\') and xfpc__c != null and xfpdd__c>=' +
            sdt + ' and xfpdd__c<=' + edt;
    }
    global BatchStatushistUpdate(String rqno) {
        query = 'select id from g_req__c where name=\'' + rqno + '\'';
    }
    global BatchStatushistUpdate(integer nohrs) {
        query = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and srvc__r.uid__c not in (\'ltc\', \'ltp\', \'lts\', \'tad\', \'tbg\') and xfpc__c != null and Last_Modified_Since__c <=' +
            nohrs;
    }
    global BatchStatushistUpdate(String srvcode, String sdt, String edt) {
        query = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and srvc__r.uid__c=\'' + srvcode + '\' and xfpc__c != null and xfpdd__c>=' + sdt + ' and xfpdd__c<=' + edt;
    }
    global BatchStatushistUpdate(String sdt, String edt) {
        query = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and srvc__r.uid__c not in (\'ltc\', \'ltp\', \'lts\', \'tad\', \'tbg\') and xfpc__c != null and xfpdd__c>=' +
            sdt + ' and xfpdd__c<=' + edt;
    }
    global BatchStatushistUpdate(String sdt, String edt, integer nohrs) {
        query = 'select id from g_req__c where Acc__r.name != \'test identity 1\' and STA__c in (\'Open\', \'Under Review\', \'In Process\') and srvc__r.uid__c not in (\'ltc\', \'ltp\', \'lts\', \'tad\', \'tbg\') and xfpc__c != null and xfpdd__c>=' +
            sdt + ' and xfpdd__c<=' + edt;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query::' + query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < g_req__c > scope) {
        List < g_itmHistorySTA__c > istaUpdateLst = new List < g_itmHistorySTA__c > ();
        Set < String > srvNew = new Set < String > (Label.UIDSrvNew.split(', '));
        Set < String > srvRen = new Set < String > (Label.UIDSrvRenTransfer.split(', '));
        map < id, g_itmHistorySTA__c > stsMp = new map < id, g_itmHistorySTA__c > ();
        Boolean expFlg = false;
        BusinessHours mBH = [SELECT Id FROM BusinessHours WHERE id =: gU.csStr('BH')];
        Integer toHour = 3600000;
        List < g_reqitem__c > riLst = [select id, xcsla__c, dtsc__c, dtsecls__c, itm__r.cd__c,
            sta__r.slaXP__c, sta__r.slaN__c, sta__r.Tp__c, sta__r.slaa__c, ismlu__c, dtic__c,
            exp__c, First_Payment__c, fpd__c, RQ__c, RQ__r.expflg__c, RQ__r.srvc__r.uid__c, RQ__r.xfpc__c,
            (select id, cd__c, name, statype__c, exp__c, estE__c, staowner__c, SLA_Action__c,
            acts__c, actE__c, sla__c, Duration__c, f__r.staown__c, f__r.slaa__c, f__r.statype__c,
            f__r.slaN__c, f__r.slaXP__c from Status_History__r order by createddate) from g_reqitem__c where rq__c =: scope[0].id];
        for (g_reqitem__c ri: riLst) {
            List < g_itmHistorySTA__c > istaLst = ri.Status_History__r;
            integer i = 0;
            for (g_itmHistorySTA__c iSta: istaLst) {
                iSta.staowner__c = iSta.f__r.staown__c;
                iSta.SLA_Action__c = iSta.f__r.slaa__c;
                iSta.statype__c = iSta.f__r.statype__c;
                if (iSta.f__r.slaa__c == 'Standard' || iSta.f__r.slaa__c == 'Auto' || iSta.f__r.slaa__c == 'Parallel') expFlg = ri.RQ__r.expflg__c;
                else expFlg = ri.exp__c;
                iSta.exp__c = expFlg;
                iSta.sla__c = expFlg ? iSta.f__r.slaXP__c : iSta.f__r.slaN__c;
                iSta.estE__c = BusinessHours.add(mBH.id, iSta.acts__c, toHour * ((Long)(iSta.sla__c)));
                if (i == 0) stsMp.put(ri.id, iSta);
                else istaUpdateLst.add(iSta);
                i = i + 1;
            }
        }
        Decimal duration = 0;
        DateTime tdy = DateTime.now();
        DateTime ristartDate = null;
        Boolean excludeSLA = true;
        for (g_reqitem__c ri: riLst) {
            excludeSLA = true;
            if (stsMp != null && stsMp.containsKey(ri.id)) {
                g_itmHistorySTA__c hsta = stsMp.get(ri.id);
                if (srvNew.contains(ri.RQ__r.srvc__r.uid__c) && (hsta.f__r.slaa__c == 'Standard' || hsta.f__r.slaa__c == 'Auto' || hsta.f__r.slaa__c == 'Parallel')) {
                    if (ri.itm__r.cd__c == 'ep') {
                        List < g_itmHistorySTA__c > oflStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ofl' and t__r.cd__c in ('ok') ];
                        if (oflStah != null && !oflStah.isEmpty()) {
                            hsta.acts__c = oflStah[0].createddate;
                        }
                        else hsta.acts__c = ri.RQ__r.xfpc__c;
                        ristartDate = hsta.acts__c;
                        duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                    }
                    else if (ri.itm__r.cd__c == 'la') {
                        List < g_itmHistorySTA__c > epStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ep' and t__r.cd__c in ('ii',
                            'dc', 'ok', 'okk') ];
                        if (epStah != null && !epStah.isEmpty()) {
                            if (ri.First_Payment__c > epStah[0].createddate) hsta.acts__c = ri.First_Payment__c;
                            else hsta.acts__c = epStah[0].createddate;
                            ristartDate = hsta.acts__c;
                            duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                        }
                    }
                    else if (ri.itm__r.cd__c == 'ai') {
                        /*List<g_itmHistorySTA__c> epStah = [select id, createddate from g_itmHistorySTA__c where RQ__c=:ri.RQ__c and itm__r.itm__r.cd__c = 'ep' and t__r.cd__c = 'ii'];
                        if (epStah != null && !epStah.isEmpty()) {
                            hsta.acts__c = epStah[0].createddate;
                            ristartDate =hsta.acts__c;
                            hsta.sla__c = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                        }
                    */ }
                    else if (ri.itm__r.cd__c == 'md' || ri.itm__r.cd__c == 'moh') {
                        List < g_itmHistorySTA__c > laStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'la' and t__r.cd__c = 'ii' ];
                        if (laStah != null && !laStah.isEmpty()) {
                            hsta.acts__c = laStah[0].createddate;
                            ristartDate = hsta.acts__c;
                            duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                        }
                        List < g_itmHistorySTA__c > aiStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ai' and t__r.cd__c = 'dr' ];
                        if (aiStah != null && !aiStah.isEmpty()) {
                            hsta.acts__c = aiStah[0].createddate;
                            ristartDate = hsta.acts__c;
                            duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                        }
                    }
                    else if (ri.itm__r.cd__c == 'ia') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        if (mdStah != null && !mdStah.isEmpty()) {
                            hsta.acts__c = mdStah[0].createddate;
                            ristartDate = hsta.acts__c;
                            duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                        }
                    }
                    else if (ri.itm__r.cd__c == 'rp') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        Datetime mdFitDt = null;
                        Datetime iafiDt = null;
                        if (mdStah != null && !mdStah.isEmpty()) mdFitDt = mdStah[0].createddate;
                        List < g_itmHistorySTA__c > iaStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ia' and t__r.cd__c in ('fi',
                            'ok', 'okk', 'ebr', 'ebn') ];
                        if (iaStah != null && !iaStah.isEmpty()) iafiDt = iaStah[0].createddate;
                        if ((mdFitDt != null && iafiDt != null && mdFitDt > iafiDt) || (mdFitDt != null && iafiDt == null)) hsta.acts__c = mdFitDt;
                        else if ((mdFitDt != null && iafiDt != null && mdFitDt <= iafiDt) || (iafiDt != null && mdFitDt == null)) hsta.acts__c = iafiDt;
                        ristartDate = hsta.acts__c;
                        duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                    }
                }
                else if (srvRen.contains(ri.RQ__r.srvc__r.uid__c) && (hsta.f__r.slaa__c == 'Standard' || hsta.f__r.slaa__c == 'Auto' || hsta.f__r.slaa__c == 'Parallel')) {
                    if (ri.itm__r.cd__c == 'md' || ri.itm__r.cd__c == 'moh') {
                        hsta.acts__c = ri.RQ__r.xfpc__c;
                        ristartDate = hsta.acts__c;
                        duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                    }
                    else if (ri.itm__r.cd__c == 'ia') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        if (mdStah != null && !mdStah.isEmpty()) {
                            hsta.acts__c = mdStah[0].createddate;
                            ristartDate = hsta.acts__c;
                            duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                        }
                    }
                    else if (ri.itm__r.cd__c == 'rp' || ri.itm__r.cd__c == 'rt' || ri.itm__r.cd__c == 'trp') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        Datetime mdFitDt = null;
                        Datetime iafiDt = null;
                        if (mdStah != null && !mdStah.isEmpty()) mdFitDt = mdStah[0].createddate;
                        List < g_itmHistorySTA__c > iaStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ia' and t__r.cd__c in ('fi',
                            'ok', 'okk', 'ebn', 'ebr') ];
                        if (iaStah != null && !iaStah.isEmpty()) iafiDt = iaStah[0].createddate;
                        if ((mdFitDt != null && iafiDt != null && mdFitDt > iafiDt) || (mdFitDt != null && iafiDt == null)) hsta.acts__c = mdFitDt;
                        else if ((mdFitDt != null && iafiDt != null && mdFitDt <= iafiDt) || (iafiDt != null && mdFitDt == null)) hsta.acts__c = iafiDt;
                        ristartDate = hsta.acts__c;
                        duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                    }
                }
                else if (ri.RQ__r.srvc__r.uid__c == '220' && ri.itm__r.cd__c == 'ddd') {
                    List < g_itmHistorySTA__c > stah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('cdr',
                        'dsr', 'dr', 'xyz') and t__r.cd__c in ('pc', 'ca') order by createddate desc limit 1];
                    if (stah != null && !stah.isEmpty()) {
                        hsta.acts__c = stah[0].createddate;
                    }
                    else {
                        hsta.acts__c = ri.RQ__r.xfpc__c;
                    }
                    ristartDate = hsta.acts__c;
                    duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                }
                else {
                    if (ri.First_Payment__c != null) {
                        hsta.acts__c = ri.First_Payment__c;
                        ristartDate = hsta.acts__c;
                        duration = calDuration(mBH.id, hsta.acts__c, hsta.actE__c);
                    }
                }
                if (duration < 0) duration = 0;
                hsta.cd__c = duration;
                if (hsta.acts__c != null) hsta.estE__c = BusinessHours.add(mBH.id, hsta.acts__c, toHour * ((Long)(hsta.sla__c)));
                istaUpdateLst.add(hsta);
                excludeSLA = false;
            }
            else {
                if (srvNew.contains(ri.RQ__r.srvc__r.uid__c)) {
                    if (ri.itm__r.cd__c == 'ep') {
                        List < g_itmHistorySTA__c > oflStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ofl' and t__r.cd__c in ('ok') ];
                        if (oflStah != null && !oflStah.isEmpty()) {
                            ristartDate = oflStah[0].createddate;
                        }
                        else ristartDate = ri.RQ__r.xfpc__c;
                        excludeSLA = false;
                    }
                    else if (ri.itm__r.cd__c == 'la') {
                        List < g_itmHistorySTA__c > epStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ep' and t__r.cd__c in ('ii',
                            'dc', 'ok', 'okk') ];
                        if (epStah != null && !epStah.isEmpty()) {
                            if (ri.First_Payment__c > epStah[0].createddate) ristartDate = ri.First_Payment__c;
                            else ristartDate = epStah[0].createddate;
                            excludeSLA = false;
                        }
                    }
                    else if (ri.itm__r.cd__c == 'ai') {
                    }
                    else if (ri.itm__r.cd__c == 'md' || ri.itm__r.cd__c == 'moh') {
                        List < g_itmHistorySTA__c > laStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'la' and t__r.cd__c = 'ii' ];
                        if (laStah != null && !laStah.isEmpty()) {
                            ristartDate = laStah[0].createddate;
                            excludeSLA = false;
                        }
                        List < g_itmHistorySTA__c > aiStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ai' and t__r.cd__c = 'dr' ];
                        if (aiStah != null && !aiStah.isEmpty()) {
                            ristartDate = aiStah[0].createddate;
                            excludeSLA = false;
                        }
                    }
                    else if (ri.itm__r.cd__c == 'ia') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        if (mdStah != null && !mdStah.isEmpty()) {
                            ristartDate = mdStah[0].createddate;
                            excludeSLA = false;
                        }
                    }
                    else if (ri.itm__r.cd__c == 'rp') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        Datetime mdFitDt = null;
                        Datetime iafiDt = null;
                        if (mdStah != null && !mdStah.isEmpty()) mdFitDt = mdStah[0].createddate;
                        List < g_itmHistorySTA__c > iaStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ia' and t__r.cd__c in ('fi',
                            'ok', 'okk', 'ebr', 'ebn') ];
                        if (iaStah != null && !iaStah.isEmpty()) iafiDt = iaStah[0].createddate;
                        if ((mdFitDt != null && iafiDt != null && mdFitDt > iafiDt) || (mdFitDt != null && iafiDt == null)) {
                            ristartDate = mdFitDt;
                            excludeSLA = false;
                        }
                        else if ((mdFitDt != null && iafiDt != null && mdFitDt <= iafiDt) || (iafiDt != null && mdFitDt == null)) {
                            ristartDate = iafiDt;
                            excludeSLA = false;
                        }
                    }
                }
                else if (srvRen.contains(ri.RQ__r.srvc__r.uid__c)) {
                    if (ri.itm__r.cd__c == 'md' || ri.itm__r.cd__c == 'moh') {
                        ristartDate = ri.RQ__r.xfpc__c;
                        excludeSLA = false;
                    }
                    else if (ri.itm__r.cd__c == 'ia') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        if (mdStah != null && !mdStah.isEmpty()) {
                            ristartDate = mdStah[0].createddate;
                            excludeSLA = false;
                        }
                    }
                    else if (ri.itm__r.cd__c == 'rp' || ri.itm__r.cd__c == 'rt' || ri.itm__r.cd__c == 'trp') {
                        List < g_itmHistorySTA__c > mdStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c in ('md', 'moh') and t__r.cd__c = 'ok'];
                        Datetime mdFitDt = null;
                        Datetime iafiDt = null;
                        if (mdStah != null && !mdStah.isEmpty()) mdFitDt = mdStah[0].createddate;
                        List < g_itmHistorySTA__c > iaStah = [select id, createddate from g_itmHistorySTA__c where RQ__c =: ri.RQ__c and itm__r.itm__r.cd__c = 'ia' and t__r.cd__c in ('fi',
                            'ok', 'okk', 'ebn', 'ebr') ];
                        if (iaStah != null && !iaStah.isEmpty()) iafiDt = iaStah[0].createddate;
                        if ((mdFitDt != null && iafiDt != null && mdFitDt > iafiDt) || (mdFitDt != null && iafiDt == null)) {
                            ristartDate = mdFitDt;
                            excludeSLA = false;
                        }
                        else if ((mdFitDt != null && iafiDt != null && mdFitDt <= iafiDt) || (iafiDt != null && mdFitDt == null)) {
                            ristartDate = iafiDt;
                            excludeSLA = false;
                        }
                    }
                }
                else {
                    if (ri.First_Payment__c != null) {
                        ristartDate = ri.First_Payment__c;
                        excludeSLA = false;
                    }
                }
                if (ristartDate != null) ri.dtsc__c = ristartDate;
            }
            if (ri.sta__r.Tp__c == 'Completed' || ri.sta__r.Tp__c == 'Cancelled' || ri.sta__r.Tp__c == 'Rejected') excludeSLA = true;
            ri.xcsla__c = excludeSLA;
            ri.ismlu__c = true;
            if (ristartDate != null) ri.dtic__c = ristartDate;
            if (ri.dtsc__c != null) {
                expFlg = ri.RQ__r.expflg__c;
                Double exOrNrDate = expFlg ? ri.sta__r.slaXP__c : ri.sta__r.slaN__c;
                ri.dtsecls__c = BusinessHours.add(mBH.id, ri.dtsc__c, toHour * ((Long)(exOrNrDate)));
            }
        }
        if (Schema.sObjectType.g_itmHistorySTA__c.isUpdateable()) { if (istaUpdateLst != null && !istaUpdateLst.isEmpty()) update istaUpdateLst; }
        if (Schema.sObjectType.g_reqitem__c.isUpdateable()) { if (riLst != null && !riLst.isEmpty()) update riLst; }
    }
    global void finish(Database.BatchableContext BC) {
    }
    public decimal calDuration(String bhid, datetime st, datetime et) {
        Integer toHour = 3600000;
        Decimal d = 0;
        d = ((Double) BusinessHours.diff(bhid, st, et)) / toHour;
        return d;
    }
}
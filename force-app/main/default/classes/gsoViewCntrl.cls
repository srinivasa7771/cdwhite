public class gsoViewCntrl {
    public String selCatg {
        get;
        set;
    }
    public String srvcName {
        get;
        set;
    }
    public String selItm {
        get;
        set;
    }
    public String selStat {
        get;
        set;
    }
    public String zone {
        get;
        set;
    }
    Public class RequestItems {
        public g_reqitem__c ri {
            get;
            set;
        }
        public integer duration {
            get;
            set;
        }
        public String slaStatus {
            get;
            set;
        }
        public Datetime dateofAction {
            get;
            set;
        }
    }
    public Transient List < g_reqitem__c > reqItmList {
        get;
        set;
    }
    public Transient List < RequestItems > reqItmwrpList {
        get;
        set;
    }
    public Transient List < RequestItems > finalListRqItm {
        get;
        set;
    }
    public Transient map < String, g_reqitem__c > mapRefReqItm {
        get;
        set;
    }

    public Map < String, String > itmList {
        get;
        set;
    }
    public List < selectOption > categoryOption {
        get;
        set;
    }
    public List < selectOption > itemOptions {
        get;
        set;
    }
    public List < selectOption > statusOptions {
        get;
        set;
    }

    public List < selectOption > getCatOpt() {
        categoryOption = new List < selectOption > ();
        return categoryOption;
    }
    public List < selectOption > getItmOpt() {
        itemOptions = new List < selectOption > ();
        String cat;
        if (selCatg != null && selCatg != '') {
            cat = selCatg.split(', ')[0];
        }
        itmList = new Map < String, String > ();
        itemOptions.add(new SelectOption('', '--None--'));

        for (g_srvcitm__c fc: [select cd__c, Name from g_srvcitm__c where srvc__r.uid__c =: cat and actv__c = true order by ord__c]) {
            if (itmList.isEmpty()) {
                itemOptions.add(new SelectOption(fc.cd__c, fc.Name));
                itmList.put(fc.Name, fc.cd__c);
            } else if (!itmList.containsKey(fc.Name)) {
                itemOptions.add(new SelectOption(fc.cd__c, fc.Name));
                itmList.put(fc.Name, fc.cd__c);
            }

        }
        return itemOptions;
    }

    public PageReference getItms() {
        System.debug('===selCatg=='+selCatg);
        srvcName = '';
        if (selCatg == 'EID') {
            finalListRqItm = new List < RequestItems > ();
            srvcName =  'EID';
            reqItmwrpList = new List < RequestItems > ();
            for (g_Req__c req:[Select id, (Select Id,
                itm__r.cd__c, Medical_Fit_Date__c, exp__c,
                nt__c, Payment_Duration__c, RQ__r.expflg__c,
                name, Assigned_User__c, RQ__r.xcamdt__c,
                RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c,
                RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c,
                itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c,
                RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                RQ__r.Service_Code__c, RQ__r.Sponser_Name_Auto__c,
                RQ__r.Con__r.Spon__c from Items__r where sta__r.cd__c in ('ok',
                'n') and  itm__r.cd__c in ('md', 'ia')) From g_Req__c Where STA__c = 'Under Review' and CreatedDate = LAST_N_DAYS: 365 ]) {
                Boolean isDHACompleted = false;
                Boolean isEIDInNew = false;
                RequestItems obj = new RequestItems();
                for (g_reqitem__c ri: req.Items__r) {
                    if (ri.itm__r.cd__c == 'md' && ri.sta__r.cd__c == 'ok') {
                        isDHACompleted = true;
                        obj.ri = ri;
                    }
                    if (ri.itm__r.cd__c == 'ia' && ri.sta__r.cd__c == 'n') {
                        isEIDInNew = true;
                    }
                    if (ri.Payment_Duration__c != null) obj.duration = Math.round(ri.Payment_Duration__c);
                    else obj.duration = 0;
                }
                if (isDHACompleted && isEIDInNew) {
                    reqItmwrpList.add(obj);
                }
            }
            finalListRqItm.addAll(reqItmwrpList);
        }
        else{
            getItmOpt();
        /*selCatg*/ }
        return null;
    }

    public List < selectOption > getStsOpt() {
        statusOptions = new List < selectOption > ();
        return statusOptions;
    }

    public PageReference queryReq() {
        srvcName = '';
        List < g_reqitem__c > reqItmListNP = new List < g_reqitem__c > ();
        reqItmwrpList = new List < RequestItems > ();
        List < g_reqitem__c > notreqItmList = new List < g_reqitem__c > ();
        finalListRqItm = new List < RequestItems > ();
        system.debug('Inside');
        String serviceName;
        String cat, itmcd, stscd, newStsCd;
        List < string > cdList = new List < string > ();
        List < string > itmcdList = new List < string > ();
        List < string > stscdList = new List < string > ();
        cat = selCatg;
        itmcd = selItm;
        stscd = selStat;
        system.debug('cat>>' + cat);
        if (!String.isBlank(selStat)) {
            stscd = selStat;
        }
        If(!String.ISBLANK(cat)) cdList = cat.split(', ');
        If(!String.ISBLANK(itmcd)) itmcdList = itmcd.split(', ');
        If(!String.ISBLANK(stscd)) stscdList = stscd.split(', ');
        mapRefReqItm = new map < String, g_reqitem__c > ();
        map < String, g_reqitem__c > notInmapRefReqItm = new map < String, g_reqitem__c > ();
        system.debug('cdList2>>' + cdList.size());
        if (cdList != null && cdList.size() > 0) {
            system.debug('cdList 2>>' + cdList);
            g_Srvc__c s = [select name from g_Srvc__c where uid__c in: cdList limit 1];
            if (s != null) {
                serviceName = (s.Name).toUpperCase();
            }
        }
        system.debug('ccdListat>>' + cdList);
        system.debug('itmcdList>>' + itmcdList);
        system.debug('stscdList>>' + stscdList);
        system.debug('serviceName>>' + serviceName);
        notreqItmList = [Select Id, name, RQ__r.Name, STA__r.Tp__c, STA__c, STA__r.cd__c,
            STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('eca',
            'eci', 'exn', 'exu', 'ofl') and STA__r.cd__c not in ('ok', 'ii',
                'dc') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and STA__r.Tp__c = 'Open' and CreatedDate = LAST_N_DAYS: 365 ];
        IF(notreqItmList.size() > 0) {
            for (g_reqitem__c rqItm: notreqItmList) {
                notInmapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
            }
        }
        BusinessHours mBH = [SELECT Id FROM BusinessHours WHERE id =: gU.csStr('BH')];
        Integer toHour = 3600000;
        if (cdList.contains('DFV')) {
            srvcName =  'DFV';
            Map<String, List<g_reqitem__c>> sponserMoreThanTwo = new Map<String, List<g_reqitem__c>>();
            for (g_reqitem__c ri: [Select Id, exp__c, nt__c, Payment_Duration__c, RQ__r.expflg__c,
                name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c,
                RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Service_Code__c,
                RQ__r.Sponser_Name_Auto__c, RQ__r.Con__r.Spon__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' and CreatedDate = LAST_N_DAYS: 365 Order By RQ__r.Sponser_Name_Auto__c ]) {
                if (sponserMoreThanTwo.containskey(ri.RQ__r.Con__r.Spon__c)) {
                    sponserMoreThanTwo.get(ri.RQ__r.Con__r.Spon__c).add(ri);
                }
                else{
                    sponserMoreThanTwo.put(ri.RQ__r.Con__r.Spon__c, new List<g_reqitem__c>{
                    ri}
                    );
                }
            }
            for (String sponser : sponserMoreThanTwo.keySet()) {
                if (sponserMoreThanTwo.get(sponser).size()>1) {
                    System.debug('===sponserMoreThanTwo==='+sponserMoreThanTwo.get(sponser));
                    for (g_reqitem__c ri : sponserMoreThanTwo.get(sponser)) {
                        /*decimal dt1 = Date.today().daysBetween((ri.RQ__r.xfpc__c).date());
                        */ RequestItems obj = new RequestItems();
                        obj.ri = ri;
                        if (ri.Payment_Duration__c != null) obj.duration = Math.round(ri.Payment_Duration__c);
                        else obj.duration = 0;
                        obj.dateofAction = ri.RQ__r.xfpc__c;
                        reqItmwrpList.add(obj);
                    }
                }
            }
        }
        else if (itmcd.contains('la')) {
            reqItmList = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c = 'ep' and STA__r.cd__c in ('ok',
                'ii', 'dc') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ];
            IF(reqItmList.size() > 0) {
                for (g_reqitem__c rqItm: reqItmList) {
                    if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
                        mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                    }
                }
            }
            Map < String, g_reqitem__c > epMp = new Map < String, g_reqitem__c > ();
            for (g_reqitem__c ri: [select id, EP_Issue_Date__c, Ep_Duration__c, First_Payment__c,
                RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and AP__c > 0 and RQ__r.Name in: mapRefReqItm.keySet() and itm__r.cd__c = 'ep' and RQ__r.Account_Name__c != 'test identity 1' ]) {
                epMp.put(ri.RQ__r.name, ri);
                system.debug('r::' + ri.RQ__r.name + ';' + ri.Ep_Duration__c);
            }
            /*reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ for (g_reqitem__c ri: [Select Id, exp__c, nt__c, RQ__r.expflg__c,
                Status_Duration__c, dtsc__c, name, Assigned_User__c, Payment_Duration__c,
                Ep_Duration__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c,
                itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: mapRefReqItm.keySet() and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                Datetime epIssuedate = null;
                Datetime laDt = null;
                RequestItems obj = new RequestItems();
                obj.ri = ri;
                if (ri.STA__r.cd__c == 'rv' && epMp != null && epMp.containskey(ri.RQ__r.Name) && epMp.get(ri.RQ__r.Name).Ep_Duration__c != null) {
                    if (epMp.get(ri.RQ__r.Name).Ep_Duration__c != null) obj.duration = Math.round(epMp.get(ri.RQ__r.Name).Ep_Duration__c);
                    else obj.duration = 0;
                    obj.dateofAction = epMp.get(ri.RQ__r.Name).EP_Issue_Date__c;
                }
                else {
                    if (ri.Status_Duration__c != null) obj.duration = Math.round(ri.Status_Duration__c);
                    else obj.duration = 0;
                    obj.dateofAction = ri.dtsc__c;
                }
                reqItmwrpList.add(obj);
                /* if (epMp != null && epMp.containskey(ri.RQ__r.Name)) epIssuedate =  epMp.get(ri.RQ__r.Name);
                if (epIssuedate != null && ri.First_Payment__c != null && ri.First_Payment__c > epIssuedate) laDt = ri.First_Payment__c;
                else laDt  =  epIssuedate;
                system.debug('ri::'+ri.RQ__r.Name+';'+laDt);
                Datetime dt1 = Datetime.now();
                decimal duration = calDuration(mBH.id, laDt, dt1);
                RequestItems obj = new RequestItems();
                obj.ri = ri;
                obj.duration = Math.round(duration);
                reqItmwrpList.add(obj);
            */ }
        }
        else if (itmcd.contains('moh')) {
            reqItmList = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c = 'ia' and STA__r.cd__c in ('ok',
                'okk', 'ebr') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ];
            IF(reqItmList.size() > 0) {
                for (g_reqitem__c rqItm: reqItmList) {
                    if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
                        mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                    }
                }
            }
            Map < String, g_reqitem__c > laMp = new Map < String, g_reqitem__c > ();
            Map < String, g_reqitem__c > aiMp = new Map < String, g_reqitem__c > ();
            for (g_reqitem__c ri: [select id, LA_Issue_Date__c, LA_Duration__c, First_Payment__c,
                RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and RQ__r.name in: mapRefReqItm.keySet() and itm__r.cd__c = 'la' and RQ__r.Account_Name__c != 'test identity 1' and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ]) {
                laMp.put(ri.RQ__r.name, ri);
            }
            for (g_reqitem__c ri: [select id, createddate, AI_Duration__c,
                First_Payment__c, RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and RQ__r.name in: mapRefReqItm.keySet() and itm__r.cd__c = 'ai' and RQ__r.Account_Name__c != 'test identity 1' and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ]) {
                /*decimal duration = Date.today().daysBetween((ri.createddate).date());
                */ aiMp.put(ri.RQ__r.name, ri);
            }
            /*reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in:cdList  and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and RQ__r.AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ for (g_reqitem__c ri: [Select Id, exp__c, nt__c, RQ__r.expflg__c,
                name, Status_Duration__c, dtsc__c, Assigned_User__c, RQ__r.xcamdt__c,
                RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c,
                RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name,
                RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c,
                RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                    RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: mapRefReqItm.keySet() and RQ__r.AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                Datetime laIssuedate = null;
                Datetime aiIssuedate = null;
                Decimal mdDt = 0;
                RequestItems obj = new RequestItems();
                if (laMp != null && laMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = laMp.get(ri.RQ__r.Name).LA_Issue_Date__c;
                    if (laMp.get(ri.RQ__r.Name).LA_Duration__c != null) obj.duration = Math.round(laMp.get(ri.RQ__r.Name).LA_Duration__c);
                    else obj.duration = 0;
                }
                else if (aiMp != null && aiMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = aiMp.get(ri.RQ__r.Name).createddate;
                    obj.duration = Math.round(aiMp.get(ri.RQ__r.Name).AI_Duration__c);
                }
                /*Datetime dt1 = Datetime.now();
                decimal duration = calDuration(mBH.id, mdDt, dt1);
                */ obj.ri = ri;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('md') && ((serviceName.contains('RENEWAL')) || (serviceName.contains('TRANSFER')))) {
            for (g_reqitem__c ri: [Select Id, exp__c, nt__c, Payment_Duration__c, RQ__r.expflg__c,
                name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c,
                RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                    RQ__r.Service_Code__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' and CreatedDate = LAST_N_DAYS: 365 ]) {
                /*decimal dt1 = Date.today().daysBetween((ri.RQ__r.xfpc__c).date());
                */ RequestItems obj = new RequestItems();
                obj.ri = ri;
                if (ri.Payment_Duration__c != null) obj.duration = Math.round(ri.Payment_Duration__c);
                else obj.duration = 0;
                obj.dateofAction = ri.RQ__r.xfpc__c;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('md') && (!(serviceName.contains('RENEWAL')) && !(serviceName.contains('TRANSFER')))) {
            system.debug('serviceName.=' + serviceName);
            reqItmListNP = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('ia') and STA__r.cd__c in ('rv',
                'v', 'n', 'dr') and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' and CreatedDate = LAST_N_DAYS: 365 ];
            reqItmList = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('la') and STA__r.cd__c in ('ii',
                'dr') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' and CreatedDate = LAST_N_DAYS: 365 ];
            IF(reqItmList.size() > 0) {
                for (g_reqitem__c rqItm: reqItmList) {
                    mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                }
            }
            IF(reqItmListNP.size() > 0) {
                for (g_reqitem__c rqItm: reqItmListNP) {
                    mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                }
            }
            /* reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in:itmcdList and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ Map < String, g_reqitem__c > laMp = new Map < String, g_reqitem__c > ();
            Map < String, g_reqitem__c > aiMp = new Map < String, g_reqitem__c > ();
            for (g_reqitem__c ri: [select id, LA_Issue_Date__c, LA_Duration__c, First_Payment__c,
                RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and RQ__r.name in: mapRefReqItm.keySet() and itm__r.cd__c = 'la' and RQ__r.Account_Name__c != 'test identity 1' and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ]) {
                laMp.put(ri.RQ__r.name, ri);
            }
            for (g_reqitem__c ri: [select id, createddate, AI_Duration__c,
                First_Payment__c, RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and RQ__r.name in: mapRefReqItm.keySet() and itm__r.cd__c = 'ai' and RQ__r.Account_Name__c != 'test identity 1' and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ]) {
                /*decimal duration = Date.today().daysBetween((ri.createddate).date());
                */ aiMp.put(ri.RQ__r.name, ri);
            }
            for (g_reqitem__c ri: [Select Id, exp__c, nt__c, RQ__r.expflg__c, name, Assigned_User__c,
                RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c,
                RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                    RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: mapRefReqItm.keySet() and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                RequestItems obj = new RequestItems();
                if (laMp != null && laMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = laMp.get(ri.RQ__r.Name).LA_Issue_Date__c;
                    if (laMp.get(ri.RQ__r.Name).LA_Duration__c != null) obj.duration = Math.round(laMp.get(ri.RQ__r.Name).LA_Duration__c);
                    else obj.duration = 0;
                }
                else if (aiMp != null && aiMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = aiMp.get(ri.RQ__r.Name).createddate;
                    obj.duration = Math.round(aiMp.get(ri.RQ__r.Name).AI_Duration__c);
                }
                /*Datetime dt1 = Datetime.now();
                decimal duration = calDuration(mBH.id, mdDt, dt1);
                */ obj.ri = ri;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('ia')) {
            reqItmListNP = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('md',
                'moh') and STA__r.cd__c not in ('n') and STA__r.Tp__c in ('Open',
                    'Completed') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') order by createddate desc Limit 1000];
            IF(reqItmListNP.size() > 0) {
                for (g_reqitem__c rqItm: reqItmListNP) {
                    if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
                        mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                    }
                }
            }
            Map < String, g_reqitem__c > mdMp = new Map < String, g_reqitem__c > ();
            for (g_reqitem__c ri: [select id, Medical_FormIssued_Date__c, Mdfi_Duration__c, First_Payment__c,
                RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and RQ__r.name in: mapRefReqItm.keySet() and itm__r.cd__c in ('md',
                    'moh') and RQ__r.Account_Name__c != 'test identity 1' and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') order by createddate desc Limit 1000 ]) {
                mdMp.put(ri.RQ__r.name, ri);
            }
            /*reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ for (g_reqitem__c ri: [Select Id, exp__c, nt__c, RQ__r.expflg__c,
                name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c,
                itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: mapRefReqItm.keySet() and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                Decimal laDt = null;
                RequestItems obj = new RequestItems();
                if (mdMp != null && mdMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = mdMp.get(ri.RQ__r.Name).Medical_FormIssued_Date__c;
                    if (mdMp.get(ri.RQ__r.Name).Mdfi_Duration__c != null) obj.duration = Math.round(mdMp.get(ri.RQ__r.Name).Mdfi_Duration__c);
                    else obj.duration = 0;
                }
                /*Datetime dt1 = Datetime.now();
                decimal duration = calDuration(mBH.id, laDt, dt1);
                */ obj.ri = ri;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('rp') || itmcd.contains('trp') || itmcd.contains('rt')) {
            reqItmListNP = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('md',
                'moh') and STA__r.cd__c in ('ok') and STA__r.Tp__c in ('Completed') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') order by createddate desc Limit 1000];
            IF(reqItmListNP.size() > 0) {
                for (g_reqitem__c rqItm: reqItmListNP) {
                    if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
                        mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                    }
                }
            }
            Map < String, g_reqitem__c > mdMp = new Map < String, g_reqitem__c > ();
            for (g_reqitem__c ri: [select id, Medical_Fit_Date__c, MedicalFit_Duration__c, First_Payment__c,
                RQ__r.name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and RQ__r.name in: mapRefReqItm.keySet() and itm__r.cd__c in ('md',
                    'moh') and RQ__r.Account_Name__c != 'test identity 1' and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') order by createddate desc Limit 1000 ]) {
                mdMp.put(ri.RQ__r.name, ri);
            }
            /*reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ for (g_reqitem__c ri: [Select Id, exp__c, nt__c, RQ__r.expflg__c,
                name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c,
                itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: mapRefReqItm.keySet() and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                Decimal laDt = null;
                RequestItems obj = new RequestItems();
                if (mdMp != null && mdMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = mdMp.get(ri.RQ__r.Name).Medical_Fit_Date__c;
                    if (mdMp.get(ri.RQ__r.Name).MedicalFit_Duration__c != null) obj.duration = Math.round(mdMp.get(ri.RQ__r.Name).MedicalFit_Duration__c);
                    else obj.duration = 0;
                }
                /*Datetime dt1 = Datetime.now();
                decimal duration = calDuration(mBH.id, laDt, dt1);
                */ obj.ri = ri;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('ai')) {
            reqItmList = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c = 'ep' and STA__r.cd__c in ('ok',
                'ii', 'dc') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and CreatedDate = LAST_N_DAYS: 365 ];
            IF(reqItmList.size() > 0) {
                for (g_reqitem__c rqItm: reqItmList) {
                    if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
                        mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                    }
                }
            }
            for (g_reqitem__c ri: [Select Id, exp__c, nt__c, AI_Duration__c, RQ__r.expflg__c,
                createddate, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: mapRefReqItm.keySet() and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by createddate desc Limit 1000 ]) {
                /*Datetime laDt = ri.createddate;
                Datetime dt1 = Datetime.now();
                */ /*  decimal duration = Date.today().daysBetween((ri.createddate).date());
                decimal duration = calDuration(mBH.id, laDt, dt1);
                */ RequestItems obj = new RequestItems();
                obj.ri = ri;
                obj.duration = Math.round(ri.AI_Duration__c);
                obj.dateofAction = ri.createddate;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('uae')) {
            /*reqItmList=[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in ('uae') and STA__r.cd__c in('rv', 'v', 'n', 'dr')  and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ for (g_reqitem__c ri: [Select Id, exp__c, nt__c, RQ__r.expflg__c,
                createddate, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c,
                RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c,
                STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('uae') and STA__r.cd__c in ('rv',
                    'v', 'n', 'dr') and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                RequestItems obj = new RequestItems();
                obj.ri = ri;
                obj.duration = 0;
                obj.dateofAction = ri.createddate;
                reqItmwrpList.add(obj);
            }
        }
        else if (itmcd.contains('cx')) {
            /*system.debug('--------reqItmList.size  cxcxcx--' + reqItmList.size());
            */ reqItmList = [Select Id, name, RQ__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('cx') and STA__r.cd__c in ('rv',
                'v', 'n', 'sip', 'svc', 'sac', 'pp', 'sd') and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1'];
            set < String > ReqLst = new set < String > ();
            Map < String, g_reqDoc__c > rMp = new Map < String, g_reqDoc__c > ();
            system.debug('reqItmList.size--' + reqItmList.size());
            IF(reqItmList.size() > 0) {
                for (g_reqitem__c rqItm: reqItmList) {
                    mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                }
                system.debug('mapRefReqItm.size--' + mapRefReqItm.size());
                List < g_reqDoc__c > docsList = [Select name, RQ__r.Name, ats__c,
                    lastmodifieddate from g_reqDoc__c where RQ__r.Name in: mapRefReqItm.keySet() and Name = 'Cancellation Exit Form/Copy of new visa/Immigration Print out' and ats__c > 0 ];
                IF(docsList.size() > 0) {
                    for (g_reqDoc__c rqD: docsList) {
                        ReqLst.add(String.ValueOf(rqD.RQ__r.Name));
                        /*decimal duration = Date.today().daysBetween((rqD.lastmodifieddate).date());
                        */ rMp.put(String.ValueOf(rqD.RQ__r.Name), rqD);
                    }
                }
            }
            system.debug('reqItmList.size--' + reqItmList.size());
            /*reqItmList = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: ReqLst and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by createddate ];
            */ for (g_reqitem__c ri: [Select Id, name, exp__c, nt__c, RQ__r.expflg__c,
                Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c,
                itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c,
                RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and RQ__r.Name in: ReqLst and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by createddate ]) {
                Decimal laDt = null;
                /* Datetime dt1 = Datetime.now();
                */ RequestItems obj = new RequestItems();
                if (rMp != null && rMp.containskey(ri.RQ__r.Name)) {
                    obj.dateofAction = rMp.get(ri.RQ__r.Name).lastmodifieddate;
                    integer duration = Math.round(Date.today().daysBetween((rMp.get(ri.RQ__r.Name).lastmodifieddate).date()));
                    if (duration > 0) duration = (duration * 8);
                    else duration = 8;
                    obj.duration = duration;
                }
                /*decimal duration = calDuration(mBH.id, laDt, dt1);
                */ obj.ri = ri;
                reqItmwrpList.add(obj);
            }
        }
        else {
            /*reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in:cdList  and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and (AP__c>0) and (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
            */ for (g_reqitem__c ri: [Select Id, name, exp__c, nt__c, Payment_Duration__c,
                RQ__r.expflg__c, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                RQ__r.SLA_Status__c, RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c,
                RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c,
                STA__r.Name, First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in: itmcdList and STA__r.cd__c in: stscdList and(AP__c > 0) and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') and RQ__r.Account_Name__c != 'test identity 1' order by First_Payment__c asc Limit 1000 ]) {
                /* Datetime laDt = ri.RQ__r.xfpc__c;
                Datetime dt1 = Datetime.now();
                decimal duration = calDuration(mBH.id, laDt, dt1);
                */ /*decimal duration = Date.today().daysBetween((ri.RQ__r.xfpc__c).date());
                */ RequestItems obj = new RequestItems();
                obj.ri = ri;
                if (ri.Payment_Duration__c != null) obj.duration = Math.round(ri.Payment_Duration__c);
                else obj.duration = 0;
                obj.dateofAction = ri.RQ__r.xfpc__c;
                reqItmwrpList.add(obj);
            }
        }
        finalListRqItm.addAll(reqItmwrpList);
        getItmOpt();
        return null;
    }

    /* public decimal calDuration(String bhid, datetime st, datetime et) {
Integer toHour = 3600000;
Decimal d = 0;
if (st == null)
st = datetime.now();
d = (((Double) BusinessHours.diff(bhid, st, et)) / toHour) / 6 ;
return d;
}*/

}
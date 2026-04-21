public class lstViewCntVFS {
    public String selCatg {
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
    public Transient List < g_reqitem__c > reqItmList {
        get;
        set;
    }
    public Transient List < g_reqitem__c > finalListRqItm {
        get;
        set;
    }
    public Transient map < String, g_reqitem__c > mapRefReqItm {
        get;
        set;
    }
    public String selectedStatus { get; set; }

    public Map<Id, String> mapReqItem_country {get; set;}

    List < selectOption > categoryOption;
    List < selectOption > itemOptions;
    List < selectOption > statusOptions;
    public List < selectOption > getCatOpt() {
        categoryOption = new List < selectOption > ();
        return categoryOption;
    }
    public List < selectOption > getItmOpt() {
        return itemOptions;
    }
    public List < selectOption > getStsOpt() {
        statusOptions = new List < selectOption > ();
        return statusOptions;
    }
    public PageReference queryReq() {

    this.selectedStatus = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selectedStatus'));
    String selectedStatusValue = this.selectedStatus;
    system.debug('RETURNED STATUS' + selectedStatus);
    reqItmList = new List < g_reqitem__c > ();
    finalListRqItm = new List < g_reqitem__c > ();
    system.debug('Inside');
    String cat, itmcd, stscd, newStsCd;
    List < string > cdList = new List < string > ();
    List < string > stscdList = new List < string > ();
    List < string > itmcdList = new List < string > ();
    cat = selCatg;
    system.debug('cat-->' + cat);
    if (!String.isBlank(selItm)) { if (selItm != 'rpr') { itmcd = selItm; } else { if (selCatg.contains('Renewal')) { itmcd = 'rp'; } } system.debug('itmcd--->' + itmcd); }
    if (!String.isBlank(selStat)) {
        stscd = selStat;
    }
    system.debug('stscd---->' + stscd);
    If(!String.ISBLANK(cat))
    cdList = cat.split(', ');
    If(!String.ISBLANK(itmcd))
    itmcdList = itmcd.split(', ');
    If(!String.ISBLANK(stscd))
    stscdList = stscd.split(', ');

    system.debug('cdList' + cdList);
    system.debug('itmcdList' + itmcdList);
    system.debug('stscdList:: ' + stscdList);
    List < String > embCodes = new List < String > {
        'inl',
        'inb'
    };
    if (itmcdList.contains('att')) {
            String str = 'att';
        {
            system.debug('atts');
            reqItmList = [Select Id, Service_Name__c, Rq__r.xadtx3__c, First_Payment__c, RQ__r.xcnc__c,
                name, Assigned_User__c, RQ__r.SLA_Status__c, rq__r.xbrnd__c, RQ__r.xcddocs__c, RQ__r.xmgr__c,
                itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c,
                RQ__r.Name, RQ__r.Created_Date__c, RQ__r.xfpdd__c, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c,
                RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.STA__c != 'Completed' AND RQ__r.xdrv__c = false AND ap__C > 0 AND RQ__r.Service_Code__c = '200' AND Rq__r.Account_Name__c != 'test identity 1' and AP__c > 0 and Rq__r.Item_Count__c > 1 AND itm__r.cd__c = 'att' and STA__r.cd__c in: stscdList Limit 1000 ];
        }
        } else if (itmcdList.contains('vfs')) {
            String str = 'vfs';
        {
            system.debug('first query');
            system.debug('selectedStatusValue' + selectedStatusValue);
            system.debug('statuscodelist ' + stscdList);
            if (selectedStatusValue != 'All') {
                system.debug('first1 query');
                reqItmList = [SELECT Id,  Service_Name__c, First_Payment__c, RQ__r.xcnc__c, name,
                    Assigned_User__c, RQ__r.SLA_Status__c, rq__r.xbrnd__c, RQ__r.xcddocs__c, RQ__r.xmgr__c,
                    itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c,
                    RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xfpdd__c, RQ__r.Created_Date__c, RQ__r.prio__c,
                    RQ__r.xmloc__c, Rq__r.xadtx3__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                    RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name FROM g_reqitem__c WHERE itmCd__c = 'vfs' AND RQ__r.Service_Code__c IN('vfs',
                    '002', '004', '078', '304', '021', '020', '040', '303', '001', '003', '028', '026',
                    '081', '308', '015', '025', '027', '080', '307', '010', '189', '191', '193', '188',
                    '190', '192', '050', '053', '313', '140', '141', '013', '312', '006', '311', '138',
                    '139', '012', '310', '005') AND Rq__r.Account_Name__c != 'test identity 1' and AP__c > 0 AND RQ__r.STA__c =: selectedStatusValue ORDER BY CreatedDate DESC Limit 999 ];
            }
            else {
                system.debug('first2 query');
                system.debug('selectedStatusValue2' + selectedStatusValue);
                reqItmList = [SELECT Id,  Service_Name__c, First_Payment__c, RQ__r.xcnc__c, name,
                    Assigned_User__c, RQ__r.SLA_Status__c, rq__r.xbrnd__c, RQ__r.xcddocs__c, RQ__r.xmgr__c,
                    itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c,
                    RQ__r.Name, RQ__r.STA__c, RQ__r.xfpdd__c, RQ__r.Con__c, RQ__r.Created_Date__c, RQ__r.prio__c,
                    RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                    RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name, Rq__r.xadtx3__c FROM g_reqitem__c WHERE itmCd__c = 'vfs' AND RQ__r.Service_Code__c IN('vfs',
                    '002', '004', '078', '304', '021', '020', '040', '303', '001', '003', '028', '026',
                    '081', '308', '015', '025', '027', '080', '307', '010', '189', '191', '193', '188',
                    '190', '192', '050', '053', '313', '140', '141', '013', '312', '006', '311', '138',
                    '139', '012', '310', '005') AND Rq__r.Account_Name__c != 'test identity 1' and AP__c > 0 ORDER BY CreatedDate DESC Limit 999 ];
            }
        }
        } else if (!itmcdList.isEmpty()) {
            String str = itmcdList[0];
        {
            system.debug('second query');
            reqItmList = [Select Id, Service_Name__c, First_Payment__c, RQ__r.xcnc__c, name, Assigned_User__c,
                RQ__r.SLA_Status__c, rq__r.xbrnd__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.xfpdd__c,
                RQ__r.Created_Date__c, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c,
                RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                STA__c, STA__r.cd__c, STA__r.Name, Rq__r.xadtx3__c from g_reqitem__c where RQ__r.STA__c != 'Completed' AND RQ__r.xdrv__c = false AND ap__C > 0 AND RQ__r.Service_Code__c = 'ltc' AND Rq__r.Account_Name__c != 'test identity 1' and Rq__r.Item_Count__c > 1 AND itm__r.cd__c in: embCodes and STA__r.cd__c in: stscdList AND RQ__r.STA__c =: selectedStatusValue Limit 1000 ];
        }
    }

    system.debug('reqItmList' + reqItmList);
    mapRefReqItm = new map < String, g_reqitem__c > ();
    String include;
    String exclude;
    IF(reqItmList.size() > 0) {
        for (g_reqitem__c rqItm: reqItmList) {
            mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
            if (rqItm.itm__r.ilv__c != null && String.IsBlank(include)) include = rqItm.itm__r.ilv__c;
            if (rqItm.itm__r.elv__c != null && String.IsBlank(exclude)) exclude = rqItm.itm__r.elv__c;
        }
    }
    List < String > lst1;
    List < String > lst2;
    map < String, List < String >> inmapLst1 = new map < String, List < String >> ();
    map < String, List < String >> exmapLst2 = new map < String, List < String >> ();
    set < string > includeStatusList = new set < string > ();
    List < g_reqitem__c > newListRqItm = new List < g_reqitem__c > ();

    if (String.isNotBlank(include) || String.isNotBlank(exclude)) {
        if (String.isNotBlank(include)) lst1 = include.split(';');
        if (String.isNotBlank(exclude)) lst2 = exclude.split(';');
        if (lst1 != null && lst1.size() != 0) {
            for (String str: lst1) {
                List < String > nwLst = str.split(':');
                if (inmapLst1.containsKey(nwLst[0])) {
                    List < String > statusList = inmapLst1.get(nwLst[0]);
                    statusList.add(nwLst[1]);
                    inmapLst1.put(nwLst[0], statusList);
                }
                else {
                    inmapLst1.put(nwLst[0], new List < String > {
                    nwLst[1] }
                    );
                }
                includeStatusList.add(nwLst[0]);
            }
        }
        if (lst2 != null && lst2.size() != 0) {
            for (String str: lst2) {
                List < String > nwLst = str.split(':');
                if (exmapLst2.containsKey(nwLst[0])) {
                    List < String > oldList = exmapLst2.get(nwLst[0]);
                    oldList.add(nwLst[1]);
                    exmapLst2.put(nwLst[0], oldList);
                }
                else {
                    exmapLst2.put(nwLst[0], new List < String > {
                    nwLst[1] }
                    );
                }
                includeStatusList.add(nwLst[0]);
            }
        }
        List < String > getallStatus = new List < String > ();
        string itmCode;
        If(String.isBlank(exclude)) {
            for (String sts: includeStatusList) {
                if (inmapLst1.containsKey(sts)) {
                    for (String s: inmapLst1.get(sts)) {
                        getallStatus.add(s);
                    }
                }
            }
        }
        If(String.isNotBlank(exclude)) {
            for (String sts: includeStatusList) {
                if (exmapLst2.containsKey(sts)) {
                    for (String s: exmapLst2.get(sts)) {
                        getallStatus.add(s);
                    }
                }
            }
        }
        If(String.isBlank(exclude)) {
            system.debug('third query');
            newListRqItm = [Select Id, name, itmCd__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                RQ__c, RQ__r.Name, RQ__r.xfpdd__c, RQ__r.Created_Date__c, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where itmCd__c in: inmapLst1.keySet() and sta__r.cd__c not in: getallStatus and RQ__r.Name in: mapRefReqItm.keySet()];
        }
        else {
            system.debug('query nbre4');
            newListRqItm = [Select Id, name, itmCd__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                RQ__c, RQ__r.Name, RQ__r.xfpdd__c, RQ__r.Created_Date__c, RQ__r.STA__c, RQ__r.Con__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c, STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where itmCd__c in: exmapLst2.keySet() and sta__r.cd__c in: getallStatus and RQ__r.Name in: mapRefReqItm.keySet()];
        }
        map < String, g_reqitem__c > toRemovemapRefReqItm = new map < String, g_reqitem__c > ();
        for (g_reqitem__c rqItm: newListRqItm) {
            toRemovemapRefReqItm.put(rqItm.RQ__r.Name, rqItm);
        }
        if (String.isBlank(exclude)) {
            for (g_reqitem__c rqItm: newListRqItm) {
                toRemovemapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                if ((mapRefReqItm.containsKey(rqItm.RQ__r.Name))) {
                    mapRefReqItm.remove(rqItm.RQ__r.Name);
                }
            }
            for (g_reqitem__c rqItm: reqItmList) {
                if (mapRefReqItm.containsKey(rqItm.RQ__r.Name)) {
                    finalListRqItm.add(mapRefReqItm.get(rqItm.RQ__r.Name));
                }
            }
        }
        else if (String.isNotBlank(exclude)) {
            for (g_reqitem__c rqItm: reqItmList) {
                if ((mapRefReqItm.containsKey(rqItm.RQ__r.Name)) && toRemovemapRefReqItm.containsKey(rqItm.RQ__r.Name)) {
                    finalListRqItm.add(mapRefReqItm.get(rqItm.RQ__r.Name));
                }
            }
        }
    }

    if (finalListRqItm.size() == 0) {
        finalListRqItm.addAll(reqItmList);
    }
            mapReqItem_country = new Map<Id, String>();
            system.debug('finallistitem' + finalListRqItm);
            for (g_reqitem__c reqitm: finalListRqItm) {
     system.debug('reqitemforloop' + reqitm);
     if (reqitm.Rq__r != null && reqitm.Rq__r.xadtx3__c != null) {
         String jsonString = reqitm.Rq__r.xadtx3__c;
         jsonString = jsonString.replaceAll('\n', '').replaceAll('\r', '');
         system.debug('jsonstring' + jsonString);
         Map < String, Object > jsonObj = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);
         system.debug('jsonObj' + jsonObj);
         String countryname = (String) jsonObj.get('country');
         mapReqItem_country.put(reqitm.Id, countryname);
     } else {
         mapReqItem_country.put(reqitm.Id, '');
     }
 }
    return null;
}

}
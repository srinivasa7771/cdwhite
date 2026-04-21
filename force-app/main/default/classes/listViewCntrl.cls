public class listViewCntrl {
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
       reqItmList = new List < g_reqitem__c > ();
       finalListRqItm = new List < g_reqitem__c > ();
       system.debug('Inside');
       String cat, itmcd, stscd, newStsCd;
       List < string > cdList = new List < string > ();
       List < string > itmcdList = new List < string > ();
       List < string > stscdList = new List < string > ();
       cat = selCatg;
       system.debug('cat>>' + cat);
       if (!String.isBlank(selItm)) {
           if (selItm != 'rpr') {
               itmcd = selItm;
           }
           else {
               if (selCatg.contains('Renewal')) {
                   itmcd = 'rp';
               }
           }
       }
       if (!String.isBlank(selStat)) {
           stscd = selStat;
       }
       if (selItm == 'av' || selItm == 'hse' || selItm == 'bdm' || selItm == 'sec') {
           stscd = 'rv, ok';
       }
       If(!String.ISBLANK(cat)) cdList = cat.split(', ');
       If(!String.ISBLANK(itmcd)) itmcdList = itmcd.split(', ');
       If(!String.ISBLANK(stscd)) stscdList = stscd.split(', ');
       system.debug('cdList' + cdList);
       system.debug('itmcdList' + itmcdList);
       system.debug('stscdList' + stscdList);
       if (!(String.ISBLANK(selCatg) && String.ISBLANK(selItm))) if (itmcd.contains('drkhda')) {
           reqItmList = [Select Id, name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.xcamdt__c,
               RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
               itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
               RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
               RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c,
                   STA__r.Name from g_reqitem__c where RQ__r.xdrv__c = true AND RQ__r.Service_Code__c in: cdList and RQ__r.tsrv__c = false and itm__r.cd__c = 'dr' and(RQ__r.AP__c > 0 or(RQ__r.AOP__c = 0 and RQ__r.AUP__c = 0)) and STA__r.cd__c in: stscdList and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') Limit 1000 ];
       }
       else if (itmcd.contains('psf')) {
           reqItmList = [Select Id, name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.xcamdt__c,
               RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
               itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
               RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
               RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c,
                   STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c =: cat and itm__r.cd__c = 'dr' and RQ__r.xpmsle__c = true and STA__r.cd__c in: stscdList and RQ__r.STA__c in ('Under Review',
               'In Process') Limit 1000 ];
       }
       else if (itmcd.contains('dr') && String.isNotBlank(cat) && cat != '220') {
           /*stscdList = new List < String > {
           'vwp', 'ok', 'c', 'xc', 'rc' }
           ;
           */ reqItmList = [Select Id, name, Assigned_User__c, SLA_Flag_Status__c,
               RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c, RQ__r.xcddocs__c,
               RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
               itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
               RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
               RQ__r.NationalityPassport__c, RQ__r.xfpc__c, STA__c, STA__r.cd__c,
               STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c =: cat and itm__r.cd__c = 'dr' and(((RQ__r.AP__c > 0) or(RQ__r.xmloc__c = true)) and STA__r.cd__c in: stscdList) and RQ__r.sta__c in ('Under Review',
               'In Process') and RQ__r.docsUploaded__c > 0 limit 1000 ];
       }
       else {
           if (String.isNotBlank(cat) && cat == '220') {
               String clause1 = ' and ((AP__c>0 and RQ__r.STA__c=\'Open\') or (RQ__r.STA__c =\'In Process\' or RQ__r.STA__c =\'Under Review\')) ';
               if (String.isNotBlank(stscd) && stscd.contains('all_')) {
                   clause1 = ' and (RQ__r.STA__c=\'Open\' or RQ__r.STA__c =\'In Process\' or RQ__r.STA__c =\'Under Review\') ';
               }
               String qry = 'Select Id, name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.SLA_Status__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, rq__r.xbrnd__c, rq__r.bprk__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c  in:cdList and RQ__r.tsrv__c=false and itm__r.cd__c in:itmcdList  and (AP__c>0 or (AOP__c=0 and AD__c=0)) and STA__r.cd__c in:stscdList ' +
                   String.escapeSingleQuotes(clause1) + ' and RQ__r.Account_Name__c!=\'test identity 1\' and (NOT   RQ__r.i_STA__c  like \'%Requires Correction%\') Limit 1000';
               reqItmList = (List < g_reqitem__c > ) Database.query(qry);
           }
           else if (String.isNotBlank(cat) && cat == '200') {
               String qry = 'Select Id, name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.SLA_Status__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, rq__r.xbrnd__c, rq__r.bprk__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c  in:cdList and itm__r.cd__c in:itmcdList  and (((RQ__r.AP__c>0 or (RQ__r.AOP__c=0  and RQ__r.AUP__c=0)) and  STA__r.cd__c in:stscdList ) )';
               System.debug('###### qry : ' + qry);
               reqItmList = (List < g_reqitem__c > ) Database.query(qry);
           }
           else if (String.isNotBlank(cat) && cat == 'ltc') {
               String qry = '';
               if (itmcd.contains('inb') || itmcd.contains('inl')) qry = 'Select Id, name, Assigned_User__c, RQ__r.SLA_Status__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, rq__r.xbrnd__c, rq__r.bprk__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c  in:cdList and itm__r.cd__c in:itmcdList  and (((RQ__r.AP__c>0 or (RQ__r.AOP__c=0  and RQ__r.AUP__c=0)) and  STA__r.cd__c = \'md\' ) )';
               else qry = 'Select Id, name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.SLA_Status__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, rq__r.xbrnd__c, rq__r.bprk__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c  in:cdList and itm__r.cd__c in:itmcdList  and (((RQ__r.AP__c>0 or (RQ__r.AOP__c=0  and RQ__r.AUP__c=0)) and  STA__r.cd__c in:stscdList ) )';
               System.debug('###### qry : ' + qry);
               reqItmList = (List < g_reqitem__c > ) Database.query(qry);
           }
           else if (String.isNotBlank(cat) && cat == 'dnc') {
               String qry ='Select Id, RQ__r.Name, Name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.SLA_Status__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, rq__r.xbrnd__c, rq__r.bprk__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c  in :cdList  and itm__r.cd__c in :itmcdList  and RQ__r.AP__c>0  and  STA__r.cd__c in :stscdList  and ( RQ__r.STA__c =\'Open\' or RQ__r.STA__c =\'In Process\' or RQ__r.STA__c =\'Under Review\') and (NOT RQ__r.i_STA__c  like \'%Docs Required%\')  and RQ__r.xfpdd__c > 2020-11-01 order by Assigned_User__c     Limit 1000';
               System.debug('###### qry : ' + qry);
               reqItmList = (List < g_reqitem__c > ) Database.query(qry);
           }
           else {
               String qry = 'Select Id, name, Assigned_User__c, SLA_Flag_Status__c, RQ__r.SLA_Status__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, rq__r.xbrnd__c, rq__r.bprk__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.xmloc__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.xdrv__c=false AND RQ__r.Service_Code__c  in:cdList and RQ__r.tsrv__c=false and itm__r.cd__c in:itmcdList  and (((RQ__r.AP__c>0 or (RQ__r.AOP__c=0  and RQ__r.AUP__c=0)) and  STA__r.cd__c in:stscdList ) or ( RQ__r.xmloc__c=true  and RQ__r.STA__c =\'Under Review\' and STA__r.cd__c=\'n\' and RQ__r.AP__c=0))';
               if (selCatg.contains('apt') && String.isNotBlank(zone)) {
                   qry += 'and rq__r.bprk__c=\'' + String.escapeSingleQuotes(zone) + '\'';
               }
               qry += 'and ( RQ__r.STA__c =\'In Process\' or RQ__r.STA__c =\'Under Review\') Limit 1000';
               System.debug('###### qry : ' + qry);
               reqItmList = (List < g_reqitem__c > ) Database.query(qry);
               /*reqItmList = [Select Id, name, Assigned_User__c, RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c  in:cdList  and itm__r.cd__c in:itmcdList  and (AP__c>0 or (AOP__c=0 and AD__c=0)) and STA__r.cd__c in:stscdList and (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') Limit 1000];
           */ }
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
               newListRqItm = [Select Id, name, SLA_Flag_Status__c, itmCd__c, itm__r.ilv__c, itm__r.elv__c,
                   itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c,
                   RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                   STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where itmCd__c in: inmapLst1.keySet() and RQ__r.tsrv__c = false and sta__r.cd__c not in: getallStatus and RQ__r.Name in: mapRefReqItm.keySet()];
           }
           else {
               newListRqItm = [Select Id, name, SLA_Flag_Status__c, itmCd__c, itm__r.ilv__c, itm__r.elv__c,
                   itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c,
                   RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                   STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where itmCd__c in: exmapLst2.keySet() and sta__r.cd__c in: getallStatus and RQ__r.tsrv__c = false and RQ__r.Name in: mapRefReqItm.keySet()];
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
       if (finalListRqItm.size() == 0) finalListRqItm.addAll(reqItmList);
       return null;
   }
}
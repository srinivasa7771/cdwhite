public class gsolistViewCntrl {
    public String selCatg { get; set; }
    public String selItm { get; set; }
    public String selStat { get; set; }
    public String zone { get; set; }

    public Transient  List<g_reqitem__c> reqItmList{get;set;}
    public Transient  List<g_reqitem__c> finalListRqItm{get;set;}
    public Transient map<String, g_reqitem__c> mapRefReqItm {get;set;}

   public Map<String, String> itmList { get; set; }
   public List<selectOption> categoryOption { get; set; }
   public  List<selectOption> itemOptions { get; set; }
   public List<selectOption> statusOptions { get; set; }

    public List<selectOption> getCatOpt() {
        categoryOption = new List<selectOption>();
        return categoryOption;
    }
    public List<selectOption> getItmOpt() {
        itemOptions = new List<selectOption>();
             String cat;
            if (selCatg != null && selCatg!='') {
                cat=selCatg.split(', ')[0];
            }
        itmList=new Map<String, String>();
             itemOptions.add(new SelectOption('', '--None--'));

             for (g_srvcitm__c fc : [select cd__c, Name from g_srvcitm__c where srvc__r.uid__c=:cat and actv__c=true order by ord__c]) {
                 if (itmList.isEmpty()) {
                 itemOptions.add(new SelectOption(fc.cd__c, fc.Name));
                 itmList.put(fc.Name, fc.cd__c);
                 }else if (!itmList.containsKey(fc.Name)) {
                 itemOptions.add(new SelectOption(fc.cd__c, fc.Name));
                 itmList.put(fc.Name, fc.cd__c);
                 }

             }
        return itemOptions;
    }

      public PageReference getItms() {
        //selCatg
   getItmOpt();
        return null;
    }

    public List<selectOption> getStsOpt() {
        statusOptions = new List<selectOption>();
        return statusOptions;
    }
     public PageReference queryReq() {

       List<g_reqitem__c> reqItmListNP = new List<g_reqitem__c>();
        reqItmList = new List<g_reqitem__c>();
        List<g_reqitem__c> notreqItmList = new List<g_reqitem__c>();
        finalListRqItm = new List<g_reqitem__c>();
        system.debug('Inside');
         String serviceName;
        String cat, itmcd, stscd, newStsCd;
        List<string> cdList = new List<string>();
        List<string> itmcdList = new List<string>();
        List<string> stscdList = new List<string>();
        cat=selCatg;

         itmcd =selItm;
         stscd =selStat;
        system.debug('cat>>'+cat);

        if (!String.isBlank(selStat)) { stscd =selStat;}

        If(!String.ISBLANK(cat)) cdList = cat.split(', ');
        If(!String.ISBLANK(itmcd)) itmcdList = itmcd.split(', ');
        If(!String.ISBLANK(stscd)) stscdList = stscd.split(', ');
        mapRefReqItm = new map<String, g_reqitem__c>();
        map<String, g_reqitem__c> notInmapRefReqItm = new map<String, g_reqitem__c>();
          system.debug('cdList2>>'+cdList.size());
         if (cdList != null && cdList.size()>0) {
             system.debug('cdList 2>>'+cdList);
            g_Srvc__c s= [select name from g_Srvc__c where uid__c in: cdList limit 1];
             if (s != null) {
                 serviceName=(s.Name).toUpperCase();
             }

         }
           system.debug('ccdListat>>'+cdList);
          system.debug('itmcdList>>'+itmcdList);
          system.debug('stscdList>>'+stscdList);
          system.debug('serviceName>>'+serviceName);

           notreqItmList =[Select Id, name, RQ__r.Name, STA__r.Tp__c , STA__c, STA__r.cd__c,
               STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in:cdList and itm__r.cd__c='ep' and STA__r.cd__c in('ok',
               'ii', 'dc') and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and STA__r.Tp__c='Open' and CreatedDate =LAST_N_DAYS:365];

           IF(notreqItmList.size()>0) { for (g_reqitem__c rqItm :notreqItmList ) {notInmapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);} }

         if (itmcd.contains('la')) {
            reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in:cdList and itm__r.cd__c='ep' and STA__r.cd__c in('ok',
                'ii', 'dc') and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and CreatedDate =LAST_N_DAYS:365];
             IF(reqItmList.size()>0) { for (g_reqitem__c rqItm :reqItmList ) {
                 if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
             mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);} }}
               reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                   RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                   itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                   RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                   RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                   First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
         }

        else if (itmcd.contains('moh')) {
             reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                 RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                 itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                 RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                 RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in:cdList  and itm__r.cd__c ='ia' and STA__r.cd__c in('ok',
                 'okk', 'ebr') and AP__c>0 and (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and CreatedDate =LAST_N_DAYS:365];
             IF(reqItmList.size()>0) { for (g_reqitem__c rqItm :reqItmList ) {
                 if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
             mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);} }}
               reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                   RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                   itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                   RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                   RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                   First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in:cdList  and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and RQ__r.AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
         }

            else if (itmcd.contains('md') && ((serviceName.contains('RENEWAL')) || (serviceName.contains('TRANSFER')))) {
             reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                 RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                 itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                 RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                 RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c,
                     STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in:itmcdList and STA__r.cd__c in:stscdList  and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and RQ__r.Account_Name__c!='test identity 1'  and CreatedDate =LAST_N_DAYS:365];
             }else if (itmcd.contains('md') && (!(serviceName.contains('RENEWAL')) && !(serviceName.contains('TRANSFER')))) {
             system.debug('serviceName.='+serviceName);
             reqItmListNP=[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                 RQ__r.SLA_Status__c, RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c,
                 itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c,
                 RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                 RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in ('ia') and STA__r.cd__c in('rv',
                 'v', 'n', 'dr')  and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1'  and CreatedDate =LAST_N_DAYS:365];
             reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                 RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                 itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                 RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                 RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in ('la') and STA__r.cd__c in('ii',
                 'dr') and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' and CreatedDate =LAST_N_DAYS:365];
            IF(reqItmList.size()>0) { for (g_reqitem__c rqItm :reqItmList ) {mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);} }
            IF(reqItmListNP.size()>0) { for (g_reqitem__c rqItm :reqItmListNP ) {mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);} }
               reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                   RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                   itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                   RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                   RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                   First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in:itmcdList and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
         }
         else if (itmcd.contains('ia')) {
             reqItmListNP = [Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c,
                 RQ__r.SLA_Status__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                 itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                 RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c,
                 STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where RQ__r.Service_Code__c in: cdList and itm__r.cd__c in ('md',
                 'moh') and STA__r.cd__c  not in ('n') and STA__r.Tp__c in ('Open',
                     'Completed') and AP__c > 0 and(RQ__r.STA__c = 'Open' or RQ__r.STA__c = 'In Process' or RQ__r.STA__c = 'Under Review') order by createddate desc Limit 1000];
             IF(reqItmListNP.size() > 0) {
                 for (g_reqitem__c rqItm: reqItmListNP) {
                     if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
                         mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                     }
                 }
             }
             reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                 RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                 itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                 RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                 RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                 First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
         }
         else if (itmcd.contains('ai')) {
             reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                 RQ__r.xcddocs__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c, itm__r.ilv__c, itm__r.elv__c,
                 itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.xmloc__c,
                 RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c, RQ__r.NationalityPassport__c,
                 RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in:cdList and itm__r.cd__c='ep' and STA__r.cd__c in('ok',
                 'ii', 'dc') and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and CreatedDate =LAST_N_DAYS:365];
             IF(reqItmList.size()>0) { for (g_reqitem__c rqItm :reqItmList ) {
                 if (!notInmapRefReqItm.containsKey(String.ValueOf(rqItm.RQ__r.Name))) {
             mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);} }}
               reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                   RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                   itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                   RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                   RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                   First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : mapRefReqItm.keySet() and AP__c>0 and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by createddate desc Limit 1000];

         }
         else if (itmcd.contains('uae')) {
             reqItmList=[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                 RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                 itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                 RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                 RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                 First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in ('uae') and STA__r.cd__c in('rv',
                 'v', 'n', 'dr')  and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
         }
        else if (itmcd.contains('cx')) {
            system.debug('--------reqItmList.size  cxcxcx--'+reqItmList.size());
            reqItmList=[Select Id, name, RQ__r.Name from g_reqitem__c where  RQ__r.Service_Code__c in :cdList  and itm__r.cd__c in ('cx') and STA__r.cd__c in('rv',
                'v', 'n', 'sip', 'svc', 'sac')  and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and RQ__r.Account_Name__c!='test identity 1'];
            set<String> ReqLst=new set<String>();
            system.debug('reqItmList.size--'+reqItmList.size());
            IF(reqItmList.size()>0) {
                for (g_reqitem__c rqItm :reqItmList ) {
                    mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                }
                system.debug('mapRefReqItm.size--'+mapRefReqItm.size());
                List<g_reqDoc__c> docsList=    [Select name,
                    RQ__r.Name, ats__c from g_reqDoc__c where RQ__r.Name in: mapRefReqItm.keySet() and Name='Cancellation Exit Form/Copy of new visa/Immigration Print out' and ats__c>0];
                IF(docsList.size()>0) {
                    for (g_reqDoc__c rqD :docsList ) {
                        ReqLst.add(String.ValueOf(rqD.RQ__r.Name));
                    }
                }
            }
            system.debug('reqItmList.size--'+reqItmList.size());
            reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
                RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
                itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
                RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
                RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
                First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in :cdList and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and RQ__r.Name in : ReqLst and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review')  and RQ__r.Account_Name__c!='test identity 1' order by createddate ];
        }
         else{
         reqItmList =[Select Id, name, Assigned_User__c, RQ__r.xcamdt__c, RQ__r.xcamc__c, RQ__r.SLA_Status__c,
             RQ__r.xcp__c, RQ__r.xcnc__c, RQ__r.Full_Name__c, RQ__r.xmgr__c, itmCd__c, RQ__r.Group__c,
             itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name, RQ__c, RQ__r.Name, RQ__r.STA__c,
             RQ__r.Con__c, RQ__r.xmloc__c, RQ__r.prio__c, RQ__r.Account_Name__c, RQ__r.Service__c,
             RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c, STA__r.Name,
             First_Payment__c, RQ__r.Con__r.eid__c from g_reqitem__c where  RQ__r.Service_Code__c in:cdList  and itm__r.cd__c in:itmcdList  and STA__r.cd__c in:stscdList and (AP__c>0) and (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and RQ__r.Account_Name__c!='test identity 1' order by First_Payment__c asc Limit 1000];
         }

            finalListRqItm.addAll(reqItmList);
         getItmOpt();
        return null;
     }

}
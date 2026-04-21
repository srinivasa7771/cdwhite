public class gctlDEDCmp {
  public string accId {set;get;}
    public g_Req__c rqDraft {get;set;}
    public string rqTp      {get;set;}
    public Boolean isEdit    {get;set;} public Boolean isView    {get;set;}
    public string isActChange {set;get;}
    private list<ActInfo> ActList {get; set;}
    public list<ActSelInfo> ActSelList {get; set;}

    public list<string> selActNmLst {set;get;}
    public set<Id> ActivitySelectedSet {set;get;}
    public Integer ActSelectedCount {get; set;}
    // selection and filter
    public list<String> AlphaList {get; set;}
    public String AlphaFilter {get; set;}
    public String SearchName {get; set;}
    private String SaveSearchName;
    private String QueryAct;
    public String stradd {get;set;}
   // public List<ActSelInfo> lst{get;set;}

    // display sort and number
    public String RecPerPage {get; set;}
    public list<SelectOption> RecPerPageOption {get; set;}
    public String SortFieldSave;

  public gctlDEDCmp() {
     // lst = new List<ActSelInfo>();
    stradd = '';
      activitySelectedSet = new set<Id>();ActList = new list<ActInfo>(); ActSelList = new list<ActSelInfo>();selActNmLst = new List<string>();

      //records for page initialization
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10', '10'));
        RecPerPageOption.add(new SelectOption('25', '25'));
        RecPerPageOption.add(new SelectOption('50', '50'));
        RecPerPageOption.add(new SelectOption('100', '100'));
        RecPerPageOption.add(new SelectOption('200', '200'));
        RecPerPage = '10'; //default records per page
        //getSelectedAct();
        // initialization alpha list
        AlphaList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'};
            SortFieldSave = SortField;

        // alpha filter, use page parameter or set default to all
        if (apexpages.currentpage().getparameters().get('alpha') == null) {
            AlphaFilter = 'All';
        } else {AlphaFilter = apexpages.currentpage().getparameters().get('alpha');
        }

        // list generation
        BuildQuery();
   }

    public List<ActSelInfo> getSelectedAct() {
        List<ActSelInfo>  lst = new List<ActSelInfo>();

        if (rqDraft != null && rqDraft.amsgs__c != null) {
            List<string> actMsgLst = rqDraft.amsgs__c.split(';');
            for (DED_Activity__c act : [select id, name from DED_Activity__c where id=:actMsgLst]) {
                lst.add(new ActSelInfo(true, act.name, act.id));
            }
            system.debug('JJJ New ActivitySelectedSet '+ ActivitySelectedSet);
            System.debug('JJJ New Lst '+ lst);
        }
        return  lst;
    }

    public void activityChange() {

         ActList = new list<ActInfo>();
        ActivitySelectedSet = new set<Id>();
        selActNmLst = new list<String>(); ActSelList = new list<ActSelInfo>();
           List<seg__c> segLst  = new List<seg__c>();

        if (Test.isRunningTest()) {
          isActChange='actyes'  ;
            rqTp='n';
        }
      /**   if (Test.isRunningTest()) {
                segLst = [select id, act__c, IsActive__c from seg__c where IsActive__c=:true order by seg__c];
         }else{**/
        segLst = [select id, name, act__c, IsActive__c from seg__c where acct__c=:accId and IsActive__c=:true order by seg__c];
       //  }
        if (segLst != null && !segLst.isEmpty()) {

            for (seg__c seg : segLst) {
               // if (seg.IsActive__c == true) {
                ActSelInfo selAct = new ActSelInfo(true, seg.act__c, seg.id); if (String.isBlank(stradd)) {  stradd = seg.id+';'; }
                else{stradd =  stradd +seg.id+';'; } ActSelList.add(selAct);selActNmLst.add(seg.act__c);
            }
           // rqDraft.xadh__c = stradd;
           // system.debug('JJJ rqDraft.xadh__c ' +rqDraft.xadh__c );
        }

        if (isActChange == 'actyes' || rqTp == 'n') {
        //records for page initialization
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10', '10'));
        RecPerPageOption.add(new SelectOption('25', '25'));
        RecPerPageOption.add(new SelectOption('50', '50'));
        RecPerPageOption.add(new SelectOption('100', '100'));
        RecPerPageOption.add(new SelectOption('200', '200'));
        RecPerPage = '10'; //default records per page

        // initialization alpha list
        AlphaList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'};
            SortFieldSave = SortField;

        // alpha filter, use page parameter or set default to all
        if (apexpages.currentpage().getparameters().get('alpha') == null) {
            AlphaFilter = 'All';
        } else { AlphaFilter = apexpages.currentpage().getparameters().get('alpha');
        }
        if (isActChange == 'actyes')
          rqDraft.InsChk__c =true;
        else
          rqDraft.InsChk__c =false;
        // list generation
        BuildQuery();
            }

    }

    /***
    * StdSetControllerAct - paging through the DED_Activity__c list
    ***/
    public ApexPages.StandardSetController StdSetControllerAct {
        get {
            system.debug('QueryAct::'+QueryAct);
            if (StdSetControllerAct == null) {StdSetControllerAct = new ApexPages.StandardSetController(Database.getQueryLocator(QueryAct));
                // sets the number of records in each page set
                StdSetControllerAct.setPageSize(Integer.valueOf(RecPerPage));
            }return StdSetControllerAct;
        }
        set;
    }

    /***
    * getCurrentActList - return an DED_Activity__c list for the table
    ***/
    public list<ActInfo> getCurrentActList() {
        UpdateActivitySelectedSet();
        BuildQuery();
        ActList = new list<ActInfo>();

        system.debug('**rqDraft.xuvdet__c:: '+rqDraft.xuvdet__c);

        for (DED_Activity__c a : (list<DED_Activity__c>)StdSetControllerAct.getRecords()) {
            Boolean bIsSel = false;
            if (rqDraft != null && String.isNotBlank(rqDraft.xuvdet__c) && rqDraft.xuvdet__c.contains(a.Id)) {
                bIsSel= true;
            }else if (ActivitySelectedSet.contains(a.Id)) {
                bIsSel = true;
            }
            ActList.add(new ActInfo(a, bIsSel));
        }
        system.debug('JJJ ActList'+ActList);
        return ActList;

    }

    /***
    * UpdateActivitySelectedSet - add/remove DED_Activity__cs from the selected DED_Activity__c id list
    ***/
    public void UpdateActivitySelectedSet() {
        system.debug('ActivitySelectedSet::'+ActivitySelectedSet);
        for (ActInfo a : ActList ) {
            if (a.isSel == true) {
                ActivitySelectedSet.add(a.act.Id);
            } else {
                if (ActivitySelectedSet.contains(a.act.Id)) { ActivitySelectedSet.remove(a.act.Id);}
            }
        }
        system.debug('ActivitySelectedSet1::'+ActivitySelectedSet);

        system.debug('ActivitySelectedSet2::'+ActivitySelectedSet);
        ActSelectedCount = ActivitySelectedSet.size();

        // code commented by sachin while developing ded noc and this is handled in page level
        /**String str = '';
        for (String str1 : ActivitySelectedSet) str = str+str1+';';
        rqDraft.amsgs__c  = str;
        system.debug('rqDraft.amsgs__c::'+rqDraft.amsgs__c);
        **/
    }

    /***
    * ClearActivitySelectedSet - remove selected DED_Activity__cs and initialize counter
    ***/
    public PageReference ClearAll() {
    ActList.clear(); ActivitySelectedSet.clear(); rqDraft.amsgs__c = ''; ActSelectedCount = 0; SearchName = ''; SaveSearchName = ''; AlphaFilter = 'All'; BuildQuery();  return null;
    }

    /***
    * SearchAct - set search criteria fields and refresh DED_Activity__c table
    ***/
    public PageReference SearchAct() {
        SaveSearchName = SearchName;
        BuildQuery();
        return null;
    }

    /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() {
        StdSetControllerAct = null;
        String QueryWhere = '';

        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) { AlphaFilter = 'All'; }

        QueryAct = 'SELECT Id, Name, DED_Activity_Name_Arabic__c, DED_Activity_Code__c, ISIC_Code__c ' +
            ' FROM DED_Activity__c';

        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' + String.escapeSingleQuotes(SortField) +
                ' > \'Z\') AND (NOT ' +  String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } else if (AlphaFilter != 'All') {QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')' );}
        else if (AlphaFilter == 'All') {QueryWhere = ' WHERE Is_Active__c=true AND name not in:selActNmLst ';}

        if (SaveSearchName != null) { QueryWhere = BuildWhere(QueryWhere, ' (Name LIKE \'%' + String.escapeSingleQuotes(SaveSearchName) + '%\')');}

        QueryAct += QueryWhere;

        QueryAct += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.valueOf(SortDirection) + ' LIMIT 10000';

        system.debug('QueryAct:' + QueryAct);
    }

    /***
    * BuildWhere - build soql string for where criteria
    ***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') { return ' WHERE Is_Active__c=true AND name not in:selActNmLst AND ' + Cond; } else {  return QW + ' AND ' + Cond;}
    }

    /***
    * SortDirection - return sort direction. Default ascending(asc)
    ***/
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }

    /***
    * SortField - return sort by field. Default to Name
    ***/
    public String SortField {
        get { if (SortField == null) {SortField = 'Name'; } return SortField;  }
        set;
    }

    /***
    * SortToggle - toggles the sorting of query from asc<-->desc
    ***/
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {SortDirection = 'asc';AlphaFilter = 'All'; SortFieldSave = SortField;}
        // run the query again
        BuildQuery();
    }

    public PageReference saveActivity() {
       /* String str = '';
        for (DED_Activity__c act : [select id, name from DED_Activity__c where id=:ActivitySelectedSet])
         str = str+act.name+';';
        rqDraft.amsgs__c  = str;*/
        return null;
    }
    public class ActSelInfo{
      public boolean isSel {set;get;}       public string name {set;get;}   public string selid {set;get;}
        public ActSelInfo(boolean isS, string nm, string sid) { isSel = isS;name = nm;selid = sid;
        }
    }
    public class ActInfo{
     public boolean isSel {set;get;} Public DED_Activity__c  act {set;get;}
       // sub-class initialization
        public ActInfo(DED_Activity__c a, Boolean chk) {
            act = a;
            isSel = chk;
        }
    }
}
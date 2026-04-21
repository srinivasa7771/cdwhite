/**************************************************************************************************
@Version History
* Version    Date            Name            Description
* 1.0         Initial          DHAM                        Initial Draft
* 1.1         25-07-2024       Prateek Jangir              Added method updateEncriptedQRCodeLink to update encriped URL to a field.
**************************************************************************************************/
public with sharing class gctlReq_L {
    public String empid {
        get;
        set;
    }
    public String encid {
        get;
        set;
    }
    public String sid {
        get;
        set;
    }
    public String pid {
        get;
        set;
    }
    public boolean sancflag {
        get;
        set;
    }
    public String sanc {
        get;
        set;
    }
    public String ddaReqStatus {
        get;
        set;
    }
    public String regOfficeDcca {
        get;
        set;
    }
    public String newRegOffDcca {
        get;
        set;
    }
    public Boolean freelancerFlag {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }
    public Boolean isgu {
        get;
        set;
    }
    public List < Contact > lc {
        get;
        set;
    }
    public g_Req__c rq {
        get;
        set;
    }
    public g_Srvc__c srv {
        get;
        set;
    }
    public Account Acc {
        get;
        set;
    }
    public gu.pgMode md {
        get;
        set;
    }
    public String pt {
        get;
        set;
    }
    public String pDsc {
        get;
        set;
    }
    public String pg {
        get;
        set;
    }
    public Boolean pgHide {
        get;
        set;
    }
    public Boolean exstDpd {
        get;
        set;
    }
    public Boolean isSpActive {
        get;
        set;
    }
    public String spInsTp {
        get;
        set;
    }
    public Contact mngr {
        get;
        set;
    }
    public List < seg__c > allSeg {
        get;
        set;
    }
    public String leaseDt {
        get;
        set;
    }
    public String price {
        get;
        set;
    }
    public Boolean brodcastFlag {
        get;
        set;
    }
    List < string > newDocToCreat {
        get;
        set;
    }
    public Boolean fine30Flag {
        get;
        set;
    }
    public Boolean fine60Flag {
        get;
        set;
    }
    public Boolean fine90Flag {
        get;
        set;
    }
    public Integer fine30amount {
        get;
        set;
    }
    public Integer fine60amount {
        get;
        set;
    }
    public Integer fine90amount {
        get;
        set;
    }
    public List < loc__c > regOffnew {
        get;
        set;
    }
    public Boolean spFlaf {
        get;
        set;
    }
    public String strpriceMap {
        get;
        set;
    }
    public User usr {
        get;
        set;
    }
    public List < String > actvList {
        get;
        set;
    }
    public boolean showBtn {
        get;
        set;
    }
    Static final string COI = 'Certificate of Incorporation';
    Static final string AOA = 'Articles of Association';
    Static final string CCN = 'Certificate of Company Name Change';
    Static final string FREELANCER = 'Freelancer Permit';
    Static final string COMM_LIC = 'Commercial License';
    Static final string CERT_BRANCH = 'Certificate of Branch Registration';
    public grqWsDccaGetService.ActivityLocations allAct {
        get;
        set;
    }
    public Transient List < grqWsDccaGetService.Locations > dccalocList {
        get;
        set;
    }
    public Transient List < grqWsDccaGetService.Activities > dccaActList {
        get;
        set;
    }
    public Transient List < grqWsDccaGetService.Records > tecomLeaseList {
        get;
        set;
    }
    public Transient List < grqWsDccaGetService.Records > tecomd3LeaseList {
        get;
        set;
    }
    public Transient List < grqWsDccaGetService.Records > d3LeaseList {
        get;
        set;
    }
    public Transient List < grqWsDccaGetService.Records > crmAgrList {
        get;
        set;
    }
    public map < String, Integer > priceMap {
        get;
        set;
    }
    public map < String, Integer > chanTMap {
        get;
        set;
    }
    public map < String, Integer > addMainOffMap {
        get;
        set;
    } /*/public map<String,List<String>> newmapLoc {get;set;} */
    public map < String, List < String >> newmapLoc {
        get;
        set;
    }
    public map < String, String > agreeLocMap2 {
        get;
        set;
    }
    public map < String, List < String > > finalAgreeLoc {
        get;
        set;
    }
    public map < String, String > dccaStatusMap {
        get;
        set;
    }
    public boolean amedFlag {
        get;
        set;
    }
    public String agreeNoAmd {
        get;
        set;
    }
    public Transient Map < String, String > mapAct {
        get;
        set;
    }
    public Transient Map < String, String > mapprc {
        get;
        set;
    }
    grqWsDccaGetService.ActivityLocations actLoc {
        get;
        set;
    }
    public gctlInsComp gctlInsComp {
        get;
        set;
    }
    public string grsPrem {
        get;
        set;
    }
    public string vatAmt {
        get;
        set;
    }
    public string fnlPrem {
        get;
        set;
    }
    public String insRqTp {
        get;
        set;
    }
    @TestVisible public string lcl {
        get {
            return UserInfo.getLocale();
        }
    }
    public list < mbr > mbrs {
        get;
        set;
    }
    public integer mbrCnt {
        get;
        set;
    }
    public List < ParkingM.ParkingDetail > lst_pd {
        get;
        set;
    }
    public String cn {
        get;
        set;
    }
    @TestVisible public static String searchNum {
        get;
        set;
    }
    public Boolean st {
        get;
        set;
    }
    public Boolean isCon {
        get;
        set;
    }
    public List < SelectOption > locList {
        get;
        set;
    }
    public String selectedLoc {
        get;
        set;
    }
    public List < SelectOption > locList2 {
        get;
        set;
    }
    public String selectedLoc2 {
        get;
        set;
    }
    public List < seg__c > seg {
        get;
        set;
    }
    public Boolean segflag {
        get;
        set;
    }
    public Boolean locflag {
        get;
        set;
    }
    public Boolean incubflag {
        get;
        set;
    }
    public Boolean brnchincubflag {
        get;
        set;
    }
    public Boolean fzllcflag {
        get;
        set;
    }
    public map < String, String > agreeLocMap {
        get;
        set;
    }
    public static String gApiToken {
        get;
        set;
    } /*/### */
    public Map < String, String > sItmByCode {
        set;
        get;
    }
    public class lostDocWrap {
        public boolean selected {
            get;
            set;
        }
        public String nameOfDoc {
            get;
            set;
        }
        public Integer noOfDoc {
            get;
            set;
        }
        public lostDocWrap(String nameOfDoc, Integer noOfDoc, boolean selected) {
            this.nameOfDoc = nameOfDoc;
            this.noOfDoc = noOfDoc;
            if (selected == null) {
                this.selected = false;
            } else this.selected = selected;
        }
    }
    public list < lostDocWrap > tcopylist {
        get;
        set;
    }
    public void accde() {}
    public gctlReq_L() {}
    public pageReference loadCompanies() {
        List < Account > accList = new List < Account > ();
        if (string.isblank(rq.id)) {
            accList = [select id, lcsta__c from account where lc__c =: usr.contact.account.lc__c limit 1];
        } else {
            accList = [select id, lcsta__c from account where lc__c =: rq.Lic__c limit 1];
        }
        if (!accList.isEmpty() && (accList[0].lcsta__c == 'License Cancelled' || accList[0].lcsta__c == 'License Under Cancellation')) {
            PageReference pageRef = new PageReference('/AccessDenied?msg=licStat');
            return pageRef;
        }
        return null;
    }
    public gctlReq_L(ApexPages.StandardController c) {
        sItmByCode = new Map < String, String > ();
        rq = (g_Req__c) c.getRecord();
        st = true;
        mngr = new Contact();
        amedFlag = false;
        md = new gu.pgMode();
        segflag = false;
        locflag = false;
        incubflag = false;
        brnchincubflag = false;
        fzllcflag = false;
        freelancerFlag = false;
        tcopylist = new list < lostDocWrap > ();
        ispu = gu.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
        mbrs = new list < mbr > ();
        mbrCnt = 0;
        pgHide = false;
        allSeg = new List < seg__c > ();
        locList = new List < SelectOption > ();
        locList2 = new List < SelectOption > ();
        seg = new List < seg__c > ();
        allAct = new grqWsDccaGetService.ActivityLocations();
        dccalocList = new List < grqWsDccaGetService.Locations > ();
        dccaActList = new List < grqWsDccaGetService.Activities > ();
        tecomLeaseList = new List < grqWsDccaGetService.Records > ();
        d3LeaseList = new List < grqWsDccaGetService.Records > ();
        actLoc = new grqWsDccaGetService.ActivityLocations();
        crmAgrList = new List < grqWsDccaGetService.Records > ();
        dccaStatusMap = new map < String, String > ();
        sancflag = false;
        newDocToCreat = new List < string > ();
        fine30Flag = false;
        fine60Flag = false;
        fine90Flag = false;
        spFlaf = false;
        regOffnew = new List < loc__c > ();
        newmapLoc = new map < String, List < String >> ();
        agreeLocMap = new map < String, String > ();
        agreeLocMap2 = new map < String, String > ();
        finalAgreeLoc = new map < String, List < String >> ();
        init();
        if (srv != null && (srv.uid__c == '208') && (rq.id == null || (rq != null && rq.STA__c == 'Open' && rq.AP__c == 0))) {
            LoadAllLocSeg(true);
        }
        if (srv != null && (srv.uid__c == 'ltc' || srv.uid__c == 'apt')) {
            loadLocations();
            loadSegAct();
        }
        if (srv != null && (srv.uid__c == '200' || srv.uid__c == '201')) {
            makeTrueCopyList();
        }
    }
    @RemoteAction public Static String getArabicName(String uName) {
        String ArbName;
        system.debug('inisde getarabic');
        if (String.isBlank(gApiToken)) {
            gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        }
        system.debug('gApiToken' + gApiToken);
        system.debug('uName' + uName);
        ArbName = GDRFAUtil.engToArabicStr(uName, gApiToken);
        system.debug('ArbName' + ArbName);
        return ArbName; /*String gApiToken='eyJhbGciOiJIUzI1NiIsImtpZCI6IkY3QzdERTM0N0FFNEI5OEUyNDQ4NjMyQjk4Qzc0NjQ0M0Y2OUFDMjBEODc0MDU1RjVFMTBDQjRFRTI0QjZDMUQiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiI4NUQ2NUNENzY2ODMxMzM0RjY0QzZCQTQ0OUNDM0I4OTc2NDkxREI2QjIzRDZENzgwNDQ2RUU5QzBCMTIxNzc4IiwianRpIjoiZUhuVVdWYUY5dy9VdlJWaTc3NGw1eHIzMlZqTmVBSG95aUpiWmduTEdVbmF1MmJxRTE1L1JjSHh1MmlxVThUUjFtMExLNCt1YTB3a0hSZHcyalc1MUEiLCJ1c2VyUHVibGljSWQiOiIyNjNjZGU4Mi1lZGRlLTRlMGQtOGE5Ni1lN2I4YzMyNjVhMjciLCJ1c2VybmFtZSI6InRscXlwMTMiLCJyb2xlIjoiZWRucmQiLCJlbWFpbCI6ImRlcGVuZGVudHZpc2FAYXhzLmFlIiwiaXNJbmRpdmlkdWFsIjoiRmFsc2UiLCJ1c2VyVHlwZSI6ImVzdGFibGlzaG1lbnQiLCJlc3RhYl9jb2RlIjoiMjIwMDAwNjQiLCJhcGlrZXkiOiJ1elhJUUhyZ2hMY3ZlNUEwWTNTMTl1Ukg2SUtYOVAwSyIsImVzdGFiX3BpZCI6Ijk3ZGE1MTgwLTE1Y2QtNDE1Ny1iOTVkLWUwODMxZjFmNWY1MSIsImlzRnJlZVpvbmUiOiJGYWxzZSIsIm5iZiI6MTYwNzQ2MTIyMSwiZXhwIjoxNjA3NTQ3NjIxLCJpYXQiOjE2MDc0NjEyMjEsImlzcyI6IkU5RTY4ODhDRjMxRkYzRDBBNEY4QzQ4NjI4RUMyODg5MDkzNjQ4MjAzQTQ3QjVENkRBMEYxM0VCMDJCN0U2NTAiLCJhdWQiOiIzNEMwQTFGNTE1OTY3RTNGMTc3NDkwOEI3RThDNTQzNjkyOTZBMUNBOEY1RkM2NEU0MDdGQzhFMkQwOTQ1QjlBIn0.zQHnKguDpxe5K6DdqX1d4f4vMJIXngm2jiLLBXG-65w'; */
    }
    public Static Contact updateContactDetails(Contact con) {
        system.debug('gu.csStr Con_SalSr' + gu.csStr('Con_SalSrv'));
        List < String > srvuidLst = gu.csStr('Con_SalSrv').split(';');

        List < g_req__c > rqLst = [select id, xcmbs__c, xcma__c, xcmta__c, xcmoa__c, lastmodifieddate from g_req__c where con__c =: con.id and acc__c =: con.accountid and STA__c in ('Under Review', 'In Process', 'Completed') and xcmbs__c != null and xcmbs__c != 0 and srvc__r.uid__c =: srvuidLst order by createddate desc limit 1];
        if (rqLst != null && !rqLst.isEmpty() && (con.luas__c == null || rqLst[0].lastmodifieddate > con.luas__c)) {
            con.mbs__c = rqLst[0].xcmbs__c;
            con.ma__c = rqLst[0].xcma__c;
            con.mta__c = rqLst[0].xcmta__c;
            con.moa__c = rqLst[0].xcmoa__c;
            con.luas__c = date.today();
        }
        return con;
    }
    @future(callout = true) public Static void updateArabicName(String conId) {
        System.debug('<updateArabicName> conId: ' + conID);
        List < Contact > lstCon = [Select firstname, middlename, lastname, fnar__c, mnar__c, lnar__c, accountid, mbs__c, ma__c, mta__c, moa__c, luas__c from contact where id =: conId];
        if (lstCon != null && lstCon.size() > 0) {
            gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
            Boolean updateCon = false;
            if (String.isNotBlank(lstCon[0].firstname) && (String.isBlank(lstCon[0].fnar__c) || (String.isNotBlank(lstCon[0].fnar__c) && (lstCon[0].fnar__c).length() < 2))) {
                String arStr = GDRFAUtil.engToArabicStr(lstCon[0].firstname, gApiToken);
                System.debug('<updateArabicName> fnar__c: ' + arStr);
                lstCon[0].fnar__c = String.isNotBlank(arStr) ? arStr : '';
                updateCon = true;
            }
            if (String.isNotBlank(lstCon[0].middlename) && (String.isBlank(lstCon[0].mnar__c) || (String.isNotBlank(lstCon[0].mnar__c) && (lstCon[0].mnar__c).length() < 2))) {
                /*if (String.isNotBlank(lstCon[0].middlename) && (String.isBlank(lstCon[0].mnar__c) ) ) {*/
                String arStr = GDRFAUtil.engToArabicStr(lstCon[0].middlename, gApiToken);
                System.debug('<updateArabicName> mnar__c: ' + arStr);
                lstCon[0].mnar__c = String.isNotBlank(arStr) ? arStr : '';
            }
            if (String.isNotBlank(lstCon[0].lastname) && (String.isBlank(lstCon[0].lnar__c) || (String.isNotBlank(lstCon[0].lnar__c) && (lstCon[0].lnar__c).length() < 2))) {
                /*if (String.isNotBlank(lstCon[0].lastname) && String.isBlank(lstCon[0].lnar__c)) {*/
                String arStr = GDRFAUtil.engToArabicStr(lstCon[0].lastname, gApiToken);
                System.debug('<updateArabicName> lnar__c: ' + arStr);
                lstCon[0].lnar__c = String.isNotBlank(arStr) ? arStr : '';
                updateCon = true;
            }
            lstCon[0] = updateContactDetails(lstCon[0]); /*if (updateCon) {*/
            update lstCon[0]; /*}*/
        }
    }
    public void makeTrueCopyList() {
        Schema.DescribeSObjectResult objSchema = g_Req__c.sObjectType.getDescribe();
        Map < String, Schema.SObjectField > fieldMap = objSchema.fields.getmap();
        List < Schema.Picklistentry > fld = fieldmap.get('xnld__c').getDescribe().getpicklistValues();
        List < String > pickList = new List < String > ();
        String docField = rq.xtcdl__c;
        map < String, String > mapDocFld = new map < String, String > ();
        if (docField != null) {
            List < String > lst1 = docField.split(';'); /*brnchincubflag fzllcflag*/
            for (String str: lst1) {
                List < String > lst2 = str.split(':');
                mapDocFld.put(lst2[0], lst2[1]);
            }
        }
        for (Schema.Picklistentry pl: fld) {
            if (rq.xtcdl__c == null) {
                tcopylist.add(new lostDocWrap(pl.getValue(), 0, false));
            } else {
                If(docField.contains(pl.getValue()) && docField != null) {
                    tcopylist.add(new lostDocWrap(pl.getValue(), Integer.ValueOf(mapDocFld.get(pl.getValue())), true));
                } else {
                    if (md.isView == false) tcopylist.add(new lostDocWrap(pl.getValue(), 0, false));
                }
            }
        }
        system.debug('tcopylist ' + tcopylist.size());
        for (integer i = 0; i < tcopylist.size(); i++) {
            system.debug('Removal of value ' + i + '-' + tcopylist[i].nameOfDoc);
            if (brnchincubflag == true || fzllcflag == true) {
                if (brnchincubflag == true && i < tcopylist.size()) {
                    system.debug(i + '-' + 'tcopylist-' + tcopylist.size());
                    If(tcopylist[i].nameOfDoc == COI) {
                        tcopylist.remove(i);
                        i--;
                    } else If(tcopylist[i].nameOfDoc == AOA) {
                        tcopylist.remove(i);
                        i--;
                    } else If(tcopylist[i].nameOfDoc == CCN) {
                        tcopylist.remove(i);
                        i--;
                    } else If(tcopylist[i].nameOfDoc == FREELANCER) {
                        tcopylist.remove(i);
                        i--;
                    } else If(tcopylist[i].nameOfDoc == COMM_LIC && srv.uid__c == '201') {
                        tcopylist.remove(i);
                        i--;
                    }
                } else if (fzllcflag == true) {
                    If(tcopylist[i].nameOfDoc == CERT_BRANCH) {
                        tcopylist.remove(i);
                        i--;
                    } else If(tcopylist[i].nameOfDoc == COMM_LIC && srv.uid__c == '201') {
                        tcopylist.remove(i);
                        i--;
                    } else If(tcopylist[i].nameOfDoc == FREELANCER) {
                        tcopylist.remove(i);
                        i--;
                    }
                }
            } else if (freelancerFlag == true) {
                If(tcopylist[i].nameOfDoc != 'Freelancer Permit') {
                    tcopylist.remove(i);
                    i--;
                }
            }
        }
    }
    private void init() {
        try {
            if (rq.id == null) {
                md.setNew();
                loadData(true);
                validate(true);
            } else {
                md.getPgParam();
                loadData(false);
                validate(true);
            }
        } catch (exception ex) {
            System.Debug('** Exception:' + ex.getStackTraceString());
            pgHide = true;
        }
    }
    public void dsgu() {
        rq.dsgu__c = true;
        update rq;
    }
    public pagereference authenticateUser() {
        empid = ApexPages.currentPage().getParameters().get('empid');
        encid = ApexPages.currentPage().getParameters().get('enc');
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pagereference pg = null;
        if (gu.isGuestUser(userInfo.getProfileId())) {
            System.debug('** Is Guest User');
            if (((empid == '' || empid == null || encid == '' || encid == null || !DEG_Checksum(empid, encid))) && !Test.isRunningTest()) {
                pg = new pagereference('/apex/AccesDeniedPage');
            }
        } else {
            return null;
        }
        return pg;
    }
    public void loadAccAllLocSeg() {
        getAcc();
        setDCCAReqValues(rq);
        LoadAllLocSeg(true);
    }
    public void loadDpdtSec() {}
    private void loadData(Boolean isnw) {
        try {
            sid = ApexPages.currentPage().getParameters().get('sid');
            pid = ApexPages.currentPage().getParameters().get('pid');
            String rc = ApexPages.currentPage().getParameters().get('rc');
            cn = ApexPages.currentPage().getParameters().get('cn');
            if (rc != null) gu.AddInfoMsg(Label.msgCrcResp);
            if (isnw) {
                if (sid == null) {
                    gu.addWarningMsg(Label.msgInvReqPg);
                    pgHide = true;
                    return;
                }
                rq.srvc__c = ApexPages.CurrentPage().getParameters().get('sid');
                srv = [select id, uid__c, name, sdg__r.sd__c, sdg__r.docslbl__c, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id =: rq.srvc__c limit 1];
                if (isgu) {
                    /*/ only if guest users */
                    List < Account > accs = [select id, lcsta__c, Name, Phone, adb__c, bgb__c, bgnr__c, onar__c, lrd__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, sncNt__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c from Account where id =: System.Label.TecomAccnt]; /*/ 0012000001DbKS9 */
                    if (accs != null && accs.size() > 0) {
                        rq.Acc__c = accs[0].id;
                        acc = accs[0];
                    }
                } /*/ for interal requests */
                if (isgu) {
                    empid = ApexPages.currentPage().getParameters().get('empid');
                    pid = ApexPages.currentPage().getParameters().get('pid');
                    encid = ApexPages.currentPage().getParameters().get('enc');
                    sid = ApexPages.currentPage().getParameters().get('sid');
                    if ((isgu && empid == null) || !isgu) {} else if (pid != null && pid != '') {
                        lc = [select id, name, Photo_ID__c, rol__c, rp__c, rped__c from Contact where Id =: pid order by rped__c];
                        rq.Con__c = lc[0].id;
                    } else if ((empid == '' || empid == null || !DEG_Checksum(empid, encid)) && isgu) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Access Denied.'));
                    } else {
                        lc = [select id, name, Photo_ID__c, rol__c, rp__c, rped__c from Contact where Spon__r.idtxt__c =: empId order by rped__c];
                        rq.Con__c = lc[0].id;
                    }
                }
            }
            if (!isnw) {
                rq = (g_Req__c) Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false'); /*//rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.stsq__c + ' where id=\'' + rq.id + '\' and isDeleted = false'); // exstDpd = false; // if(rq != null && rq.id!=null){ string dpdServiceName = Label.dpdSrvcNames;   if(dpdServiceName.contains(',')){   for(string s : dpdServiceName.split(',')){  exstDpd = rq.srvc__r.Name.contains(s.Trim())  ? rq.xard__c : false;  }   }else {exstDpd = rq.srvc__r.Name.contains(dpdServiceName)  ? rq.xard__c : false;} }  */
                if (rq.reqMbrs__r != null) {
                    for (g_reqMbr__c m: rq.reqMbrs__r) {
                        mbrs.add(new mbr(m));
                    }
                    mbrCnt = mbrs.size();
                }
                Acc = rq.acc__r;
                srv = rq.srvc__r;
                getAcc(); /* for licence renewal requests start*/
                if ((srv.uid__c == '208') && Acc.lcsta__c == 'License Under Renewal') {
                    if (rq.xcawp__c) {
                        LoadAllLocSeg(false);
                    } else {
                        LoadAllLocSeg(true);
                    }
                    setDCCAReqValues(rq);
                }
                if ((srv.uid__c == '208') && Acc.lcsta__c == 'License Under Renewal' && rq.STA__c != 'Completed' && rq.STA__c != 'Rejected' && rq.STA__c != 'Cancelled') {
                    if (rq.xcawp__c) {
                        LoadAllLocSeg(false);
                    } else {
                        LoadAllLocSeg(true);
                    }
                    setDCCAReqValues(rq);
                } /* for licence renewal requests end*/
            } else {
                rq.conrol__c = srv.conrol__c;
                rq.consta__c = srv.consta__c;
                rq.sprrole__c = srv.sprrole__c;
                rq.sprsta__c = srv.sprsta__c;
                rq.STA__c = 'Draft';
            }
            if (ispu && !isgu) {
                /*/## && isnw */
                usr = [select id, contact.account.Legal_Framework__c, contact.account.Name, contact.account.Email__c, contact.account.Phone, MobilePhone, accountid, contact.account.id, contact.account.adb__c, contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c, contact.account.lcsta__c, contact.account.lctp__c, contact.account.vctemp__c from User where id =: UserInfo.getUserId() limit 1]; /*/User usr = [select id,contact.account.Name,contact.account.Email__c,contact.account.Phone,MobilePhone,accountid,contact.account.id,contact.account.adb__c,contact.account.xcuzn__c,contact.account.xcublg__c,contact.account.bgb__c,contact.account.bgnr__c,contact.account.bg__c,contact.account.loc__c,contact.account.Type,contact.account.Prk__c,contact.account.lcsnc__c,contact.account.lcsncnt__c,contact.account.lcedt__c,contact.account.psasnc__c,contact.account.psasncnt__c,contact.account.ecsnc__c,contact.account.ecsncnt__c,contact.account.cosnc__c,contact.account.cosncnt__c,contact.account.bgsnc__c,contact.account.bgsncnt__c,contact.account.snc__c,contact.account.info__c,contact.account.vestd__c,contact.account.vbtemp__c,contact.account.vbvv__c,contact.account.lc__c,contact.account.ORACLE_PARTY_ID__c,contact.account.lcsta__c,contact.account.lctp__c,contact.account.vctemp__c from User where id='00520000003dROY' limit 1]; */
                if (isnw) {
                    Acc = usr.contact.account;
                    rq.acc__c = Acc.Id;
                    rq.xaloc__c = acc.loc__c;
                    rq.rmob__c = usr.MobilePhone;
                    rq.xbrnd__c = acc.xcuzn__c;
                    rq.xbn__c = acc.xcublg__c;
                    rq.xceml__c = usr.contact.account.Email__c;
                    rq.xoln__c = usr.contact.account.Phone;
                }
                getAcc();
                if (srv.uid__c == '208') {
                    LoadAllLocSeg(true);
                    setDCCAReqValues(rq);
                }
                if (srv.uid__c == 'ltc' || srv.uid__c == '200' || srv.uid__c == '201') {
                    loadSegAct();
                    string acclegalFramework = Label.acclegalFramework;
                    string accFzLLClegalFramework = Label.accFzLLClegalFramework;
                    String accbranchlegalFramework = label.accbranchlegalFramework;
                    String acclegalFrameworkFreelancer = label.acclegalFrameworkFreelancer;
                    if (Acc.Legal_Framework__c != null && (acclegalFramework.contains(Acc.Legal_Framework__c) || accbranchlegalFramework.contains(Acc.Legal_Framework__c) || acclegalFrameworkFreelancer.contains(Acc.Legal_Framework__c))) {
                        incubflag = true;
                        if (accbranchlegalFramework.contains(Acc.Legal_Framework__c)) {
                            brnchincubflag = true;
                        }
                        if (accFzLLClegalFramework.contains(Acc.Legal_Framework__c)) {
                            fzllcflag = true;
                        }
                        if (acclegalFrameworkFreelancer.contains(Acc.Legal_Framework__c)) {
                            freelancerFlag = true;
                        }
                    }
                }
            }
            pt = srv.lbl__c;
            pDsc = srv.dsc__c;
            pg = srv.stg__r.pg__c;
            Set < String > uids = new Set < String > {
                '045',
                '047',
                '119',
                '162',
                '198',
                '199',
                '046',
                '120',
                '212'
            };
            if (uids.contains(srv.uid__c)) {
                getInsTp(); /*/Insurance, added by SH */
            }
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()+'' + ex.getLineNumber());
            System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS' + msg))).toUpperCase();
        System.debug('** eCd:' + eCd);
        System.debug('** encText:' + encText);
        return eCd == encText;
    }
    private void getAcc() {
        Acc = [select id, dedlic__c, lcsta__c, Name, Legal_Framework__c, lrd__c, onar__c, Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, (Select Id, acct__c, act__c, act_type__c, bus_unit__c, dcca_id__c, lic__c, or_prty__c, seg__c, sDate__c from aseg__r), (Select Id, Loc__c, IsActive__c, agrno__c, acc__c, bu__c, IsMain__c, IsSub__c, ls_end__c, ls_std__c, active__c, rpi__c, Is_frzn__c from aloc__r where IsActive__c = true) from Account where id =: rq.Acc__c limit 1];
    }
    private Boolean okDccaRen {
        get {
            if (rq.Id == null && (srv.uid__c == '208')) {
                if (Acc.lcedt__c != null && Date.today().daysBetween(Acc.lcedt__c) > 90) {
                    return false;
                }
            }
            return true;
        }
    }
    public PageReference assignAccount() {
        System.debug('req.acc:: ' + rq.acc__c); /*Acc = req.acc__c;*/
        if (rq.acc__c != null) {
            getAcc();
            if (srv != null && srv.uid__c == 'ltc' && Acc != null) {
                string acclegalFramework = Label.acclegalFramework;
                string accFzLLClegalFramework = Label.accFzLLClegalFramework;
                String accbranchlegalFramework = label.accbranchlegalFramework;
                String acclegalFrameworkFreelancer = label.acclegalFrameworkFreelancer;
                if (Acc.Legal_Framework__c != null && (acclegalFramework.contains(Acc.Legal_Framework__c) || accbranchlegalFramework.contains(Acc.Legal_Framework__c) || acclegalFrameworkFreelancer.contains(Acc.Legal_Framework__c))) {
                    incubflag = true;
                    if (accbranchlegalFramework.contains(Acc.Legal_Framework__c)) {
                        brnchincubflag = true;
                    }
                    if (accFzLLClegalFramework.contains(Acc.Legal_Framework__c)) {
                        fzllcflag = true;
                    }
                    if (acclegalFrameworkFreelancer.contains(Acc.Legal_Framework__c)) {
                        freelancerFlag = true;
                    }
                }
            }
        }
        return null;
    }
    private Boolean licSTA {
        get {
            if (rq.Id == null && (srv.uid__c == '208')) {
                if (Acc.lcsta__c == 'License Under Suspension' || Acc.lcsta__c == 'License Under Cancellation' || Acc.lcsta__c == 'License Cancelled' || Acc.lcsta__c == 'Company Under Repossession') {
                    return false;
                }
                return true;
            }
            return true;
        }
    }
    private void validate(Boolean isNew) {
        if (pg != gu.pageURL) {
            pgHide = true;
            gu.addWarningMsg(Label.msgInvReqPg);
        } /*/ if(isNew&&ispu&&hasSanctions){pgHide=true;} */
        if (!accesssOk) {
            pgHide = true;
        }
        if (isNew && ispu && !licSTA) {
            gu.addWarningMsg('Licence Renewal cannot be processed as current licence status is ' + Acc.lcsta__c);
            pgHide = true;
        }
        if (isNew && ispu && !okDccaRen) {
            Date d = Acc.lcedt__c;
            String dt = DateTime.newInstance(d.year(), d.month(), d.day()).format('dd/MM/YYYY');
            gu.addWarningMsg('Licence is valid till (' + dt + '), you can apply for renewal 90 days before expiry.');
            pgHide = true;
        }
        gU.checkNav();
    }
    public void LoadAllLocSeg(Boolean isShwloc) {
        grDDAReq ddaRq = new grDDAReq();
        ddaRq.Acc = Acc;
        ddaRq.rq = rq;
        ddaRq.LoadAllLocSeg(isShwloc);
        allAct = ddaRq.allAct;
        dccalocList = ddaRq.dccalocList;
        dccaActList = ddaRq.dccaActList;
        tecomLeaseList = ddaRq.tecomLeaseList;
        tecomd3LeaseList = ddaRq.tecomd3LeaseList;
        d3LeaseList = ddaRq.d3LeaseList;
        crmAgrList = ddaRq.crmAgrList;
        addMainOffMap = ddaRq.addMainOffMap;
        agreeLocMap = ddaRq.agreeLocMap;
        agreeLocMap2 = ddaRq.agreeLocMap2;
        agreeNoAmd = ddaRq.agreeNoAmd;
        amedFlag = ddaRq.amedFlag;
        dccaStatusMap = ddaRq.dccaStatusMap;
        regOfficeDcca = ddaRq.regOfficeDcca;
        leaseDt = ddaRq.leaseDt;
        newmapLoc = ddaRq.newmapLoc;
        finalAgreeLoc = ddaRq.finalAgreeLoc;
        newRegOffDcca = ddaRq.newRegOffDcca;
        mapAct = ddaRq.mapAct;
        mapprc = ddaRq.mapprc;
        rq = ddaRq.rq;
    }
    public void setDCCAReqValues(g_Req__c rq) {
        grqDDAReqdta ddaRq = new grqDDAReqdta();
        ddaRq.Acc = Acc;
        ddaRq.rq = rq;
        ddaRq.tecomLeaseList = tecomLeaseList; /*/leaseDt='01-05-2019'; */
        ddaRq.leaseDt = leaseDt;
        ddaRq.setDCCAReqValues();
        regOffnew = ddaRq.regOffnew;
        priceMap = ddaRq.priceMap;
        if (priceMap != null && !priceMap.isEmpty()) {
            strpriceMap = String.valueOf((priceMap.keySet()));
        } else {
            strpriceMap = '';
        }
        chanTMap = ddaRq.chanTMap;
        addMainOffMap = ddaRq.addMainOffMap;
        brodcastFlag = ddaRq.brodcastFlag;
        ddaReqStatus = ddaRq.ddaReqStatus;
        fine30Flag = ddaRq.fine30Flag;
        fine60Flag = ddaRq.fine60Flag;
        fine90Flag = ddaRq.fine90Flag;
        fine30amount = ddaRq.fine30amount;
        fine60amount = ddaRq.fine60amount;
        fine90amount = ddaRq.fine90amount;
        sanc = ddaRq.sanc;
        sancflag = ddaRq.sancflag;
        spFlaf = ddaRq.spFlaf;
        rq = ddaRq.rq;
        rq.xcfn__c = ddaRq.mangerName;
        rq.xcfnar__c = ddaRq.mangerNameA;
        rq.xcln__c = ddaRq.managerNation;
        rq.xclnar__c = ddaRq.managerNationA;
        rq.xdei__c = ddaRq.idRec;
        rq.xeng__c = ddaRq.shareHldType;
    } /*Account Act and Seg */
    public void loadSegAct() {
        system.debug('calling Segflag' + segflag);
        List < seg__c > segList = new List < seg__c > ();
        if (Acc != null && Acc.aseg__r != null && Acc.aseg__r.size() > 0) {
            segList = Acc.aseg__r;
            String allseg = Label.RamadanSegments;
            string allAct = Label.RamadanActivity;
            allseg = allseg.toLowerCase();
            allAct = allAct.toLowerCase();
            for (seg__c s: segList) {
                String seg;
                String act;
                if (s.seg__c != null && s.act__c != null) {
                    seg = s.seg__c;
                    act = s.act__c;
                    seg = seg.toLowerCase();
                    act = act.toLowerCase();
                    if (allseg.contains(seg) && allAct.contains(act)) {
                        segflag = true;
                        break;
                    }
                }
            }
        } else {
            segflag = true;
        }
        system.debug('JJ Value of Segflag' + segflag);
    } /*Account loaction */
    public List < String > strLocList {
        get;
        set;
    }
    public void loadLocations() {
        List < loc__c > loc = new List < loc__c > ();
        strLocList = new List < String > ();
        if (Acc != null && Acc.aloc__r.size() > 0) {
            loc = Acc.aloc__r;
            system.debug('Account loc' + loc);
            if (loc.size() > 0) {
                /*locList.add(new SelectOption('', '--NONE--')); locList2.add(new SelectOption('', '--NONE--'));*/
                for (loc__c l: loc) {
                    /*/&& l.rpi__c==False */
                    if (l.rpi__c == false) {
                        locList.add(new SelectOption(l.Loc__c, l.Loc__c));
                    }
                    locList2.add(new SelectOption(l.Loc__c, l.Loc__c));
                    strLocList.add(l.Loc__c);
                }
            }
        } else locflag = true;
    }
    public Boolean hasSanctions {
        get {
            if (rq.Id == null && srv.uid__c != '208') {
                grqH.rH h = new grqH.rH();
                return !h.BC(rq, srv, Acc);
            } else if (rq.Id != null && srv.uid__c != '208') {
                grqH.rH h = new grqH.rH();
                return !h.AC(rq, srv, Acc);
            }
            return false;
        }
    }
    @TestVisible private Boolean accesssOk {
        get {
            Boolean acsOk = gu.canReqSrvc(rq.srvc__c, false, null);
            if (!acsOk) {
                if (md.isNew) {
                    gu.addWarningMsg(Label.msgNoPrivilege);
                } else {
                    md.setView();
                    gu.addInfoMsg(Label.msgReadOnly);
                }
            }
            return acsOk;
        }
    }
    private void upsertR(String sta) {
        /*/ try{ */
        rq.STA__c = sta;
        upsert rq; /*/update rq; */
        upsertMbrs(); /*/ }catch(Exception e){system.debug(e.getStackTraceString());} */
    }
    @TestVisible private Boolean cancelItms() {
        map < String, Id > mapSTA = new map < String, Id > ();
        for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: rq.srvc__c and cd__c = 'xc']) {
            mapSTA.put(s.itm__r.cd__c, s.Id);
        }
        list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c from g_reqitem__c where RQ__c =: rq.Id and isDeleted = false and sta__r.Tp__c = 'Open'];
        list < g_reqitem__c > toUpdate = new list < g_reqitem__c > ();
        for (g_reqitem__c i: items) {
            if (mapSTA.get(i.itm__r.cd__c) == null) {
                gu.AddErrorMsg(Label.msgNFSTAC);
                return false;
            }
            i.sta__c = mapSTA.get(i.itm__r.cd__c);
            toUpdate.add(i);
        }
        if (toUpdate.size() > 0) {
            update toUpdate;
        }
        return true;
    }
    private void upsertMbrs() {
        if (mbrs.size() > 0) {
            list < g_reqMbr__c > toUpsert = new list < g_reqMbr__c > ();
            for (mbr m: mbrs) {
                m.adjust(rq);
                toUpsert.add(m.m);
            }
            if (toUpsert.size() > 0) {
                upsert toUpsert;
            }
        }
    }
    public PageReference saveDraft() {
        String oldSTA = rq.STA__c;
        try {
            upsertR('Draft');
            return (new ApexPages.StandardController(rq)).edit(); /* String nxtPage = ApexPages.currentPage().getParameters().get('nextPage');*/ /*if(nxtPage!=null && nxtPage == 'grqins'){ rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false');return null;}else return (new ApexPages.StandardController(rq)).edit();*/
        } catch (DMLException exDML) {
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('** Exception:' + exDML.getDmlMessage(i));
                    gu.AddErrorMsg(Label.msgException + '3');
                }
            }
            return null;
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            rq.STA__c = oldSTA;
            return null;
        }
    }
    public PageReference saveOpen() {
        system.debug('JJ check fields' + rq.xadh__c + 'second Value InsChk__c' + rq.InsChk__c);
        Map < String, String > vResp = validateVehicle();
        if (vResp.get('ResponseCode') != '0') {
            gu.AddErrorMsg(vResp.get('errMessage'));
            return null;
        }
        String oldSTA = rq.STA__c;
        if (srv != null && (srv.uid__c == '200' || srv.uid__c == '201')) {
            if (md.isNew || md.isEdit) {
                rq.xtcdl__c = null;
            }
            for (integer i = 0; i < tcopylist.size(); i++) {
                if (tcopylist[i].selected == true) {
                    if (rq.xtcdl__c == null) {
                        rq.xtcdl__c = tcopylist[i].nameOfDoc + ':' + tcopylist[i].noOfDoc + ';';
                    } else {
                        rq.xtcdl__c = rq.xtcdl__c + tcopylist[i].nameOfDoc + ':' + tcopylist[i].noOfDoc + ';';
                    }
                }
            }
        } /*/tcopylist */
        try {
            if (md.isNew && !ispu) {
                getAcc();
            }
            if (srv.uid__c == '204' && srv.uid__c == '205' && hasSanctions) {
                return null;
            }
            String staToUpdate = 'Open';
            if (srv.uid__c == 'apt' || ((srv.uid__c == 'ltp' && rq.xltr__c == 'Temporary work permit NOC'))) {
                staToUpdate = 'Under Review';
            }
            if (rq.xltr__c == 'Dubai Custom NOC') {
                dnValidations();
            }
            upsertR(staToUpdate);
            system.debug('uid:' + srv.uid__c + ' ltrType:' + rq.rtacn__c + ' ltr:' + rq.xltr__c);
            if (srv.uid__c == 'ltc' && rq.rtacn__c == 'English' && (rq.xltr__c == 'Certificate of incumbency(FZ LLC)' || rq.xltr__c == 'Certificate of incumbency (Branch)')) {
                gctlReq_L.callSegAct(usr.contact.account.lc__c);
            }
            if (srv.uid__c == 'ltc' || srv.uid__c == 'ltn') {
                updateEncriptedQRCodeLink(rq); /*1.1 */
            }
            if (!string.isBlank(rq.xnt__c)) {
                account acc = new account();
                acc.id = rq.acc__c;
                acc.nt__c = rq.xnt__c;
                update acc;
                gctlReq_L.callSegAct(usr.contact.account.lc__c);
            }
            if (srv.uid__c == 'ltp') {
                updateArabicName(rq.con__c);
                updateEncriptedQRCodeLink(rq); /*1.1 */
            }
            String nxtPage = ApexPages.currentPage().getParameters().get('nextPage');
            if (srv.uid__c == 'apt' && ispu) {
                nxtPage = 'grqsinfo';
            } /* sh AccessPermit, skip items page for pu*/
            if (srv.uid__c == '206') {
                return new PageReference('/apex/spg?id=' + rq.Id + '&cn=' + srv.uid__c);
            }
            if (srv.uid__c == gu.csStr('ParkingCancellation') || srv.uid__c == gu.csStr('ParkingDeact')) {
                if (processParking()) {
                    return new PageReference('/apex/spg?id=' + rq.Id + '&cn=' + srv.uid__c);
                } else {
                    nxtPage = 'grqpy';
                }
            }
            system.debug('nxtPage::' + nxtPage);
            if (srv.uid__c == 'ltc' && rq.xltr__c == 'Permit for Catering Service') {
                nxtPage = 'lrqup';
            }
            if (srv.uid__c == 'ltp' && !nD && rq.xltr__c == 'Temporary work permit NOC') {
                nxtPage = 'grqSInfo';
            } else if (srv.uid__c == 'ltp' && nD && rq.xltr__c == 'Temporary work permit NOC') {
                nxtPage = 'lrqup';
            }
            if (nxtPage != null) {
                system.debug('nxtPage1::' + nxtPage);
                return (new pagereference('/apex/' + nxtPage + '?id=' + rq.Id));
            }
            if (isgu) return (new pagereference('/apex/grqeii?id=' + rq.Id + '&empid=' + empid + '&enc=' + encid + '&sid=' + sid + '&pid=' + pid));
            else return (new pagereference('/apex/grqei?id=' + rq.Id));
        } catch (DMLException exDML) {
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('**DML Exception:' + exDML.getDmlMessage(i));
                    if (ispu) {
                        gu.AddErrorMsg(Label.msgException);
                    } else {
                        gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'DML Exception: ' + exDML.getStackTraceString());
                    } /*/gu.AddErrorMsg(Label.msgException+'4'); */
                }
            }
            return null;
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            rq.STA__c = oldSTA;
            return null;
        }
    }
    @future(callout = true) public static void callSegAct(string licNO) {
        List < Account > accList = new List < Account > ([select id, nt__c, lc__c from Account where lc__c =: licNO limit 1]);
        if (!accList.isEmpty()) grqWsOnboard.accInfoNew(grqWsOnboard.getlicinfo(accList[0].lc__c, ''));
    }
    public void dnValidations() {
        actvList = new List < string > ();
        grqWsOnboard.AccInfo accInfo = grqWsOnboard.getlicinfo(usr.contact.account.lc__c, '');
        if (accInfo.actLst != null && !accInfo.actLst.isEmpty() && accInfo != null) {
            for (grqWsOnboard.ActInfo a: accInfo.actLst) {
                actvList.add(a.actName);
            }
        }
        if (rq.xltr__c != 'Dubai Custom NOC') {
            pgHide = false;
            ApexPages.getMessages().clear();
        }
        if (!actvList.isEmpty()) {
            string allActvities = string.join(actvList, ',');
            system.debug('---allActvities---' + allActvities);
            if ((!allActvities.contains('Manufacturing') && !(allActvities.contains('Import and Re-Export') || allActvities.contains('Import/Re-export')) && !allActvities.contains('Portal')) || usr.contact.account.Legal_Framework__c == 'Freelancer') {
                pgHide = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Your company does not have valid activities for NOC');
                ApexPages.addMessage(myMsg);
            } else if ((usr.contact.account.lcsta__c != 'License Issued' && usr.contact.account.lcsta__c != 'License Under Renewal') || hassanctions) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Your company cannot apply for NOC');
                ApexPages.addMessage(myMsg);
                pgHide = true;
            }
        } else if (actvList == null || actvList.isEmpty()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Your company does not have valid activities for NOC');
            ApexPages.addMessage(myMsg);
            pgHide = true;
        }
    }
    public PageReference save() {
        try {
            upsertR(rq.STA__c);
            return (new ApexPages.StandardController(rq)).view();
        } catch (DMLException exDML) {
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('** Exception:' + exDML.getDmlMessage(i));
                    gu.AddErrorMsg(Label.msgException);
                }
            }
            return null;
        } catch (exception ex) {
            System.Debug('** Exception:' + ex);
            gu.AddErrorMsg(Label.msgException);
            return null;
        }
    }
    public PageReference saveBO() {
        system.debug('saveBO::::::::::');
        try {
            system.debug('rq.xcpip__c -- ' + rq.xcpip__c);
            upsert rq;
        } catch (DMLException exDML) {
            system.debug('** exDML.getDmlType(i) : ' + exDML.getNumDml());
            gu.AddErrorMsg('** exDML.getDmlType(i) : ' + exDML.getNumDml() + ' **StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION: ' + StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);
            return null;
        }
        system.debug('Back office updated req:::::::::' + rq);
        return null;
    }
    public PageReference CancelR() {
        if (ispu) {
            Savepoint sp = null;
            String oldSTA = rq.STA__c;
            try {
                If((rq.STA__c != 'Draft' && rq.STA__c != 'Open') || rq.AP__c > 0 || rq.AOP__c > 0) {
                    gu.AddWarningMsg(Label.msgReqnoCancel);
                    return null;
                }
                sp = Database.setSavePoint();
                upsertR('Cancelled');
                if (!cancelItms()) {
                    Database.rollback(sp);
                    rq.STA__c = oldSTA;
                    return null;
                } /*//return (new ApexPages.StandardController(rq)).view(); */
                return new PageReference('/grqstatus?id=' + rq.id);
            } catch (DMLException exDML) {
                if (sp != null) {
                    Database.rollback(sp);
                }
                for (Integer i = 0; i < exDML.getNumDml(); i++) {
                    if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                        System.Debug('** Exception:' + exDML.getDmlMessage(i));
                        gu.AddErrorMsg(Label.msgException);
                    }
                }
                rq.STA__c = oldSTA;
                return null;
            } catch (exception ex) {
                if (sp != null) {
                    Database.rollback(sp);
                }
                gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
                rq.STA__c = oldSTA;
                return null;
            }
        } /*/add second id for M */
        else if (UserInfo.getProfileId() == '00e20000001Ajl3' || UserInfo.getProfileId() == '00e20000001Ajl3AAC' || UserInfo.getProfileId() == '00e20000001mIim' || UserInfo.getProfileId() == '00e20000001mIimAAE' || UserInfo.getProfileId() == '00e28000001sbAlAAI') {
            if (rq.AOP__c > 0) {
                gu.AddErrorMsg('Request has open payments. Please close the payments before proceeding.');
                return null;
            }
            Savepoint sp = null;
            String oldSTA = rq.STA__c;
            try {
                sp = Database.setSavePoint();
                upsertR('Cancelled');
                if (rq.AP__c > 0) {
                    if (!cancelItms()) {
                        Database.rollback(sp);
                        rq.STA__c = oldSTA;
                        return null;
                    }
                } else {
                    if (!cancelItms()) {
                        Database.rollback(sp);
                        rq.STA__c = oldSTA;
                        return null;
                    }
                } /*/ return (new ApexPages.StandardController(rq)).view(); */
                return new PageReference('/grqstatus?id=' + rq.id);
            } catch (DMLException exDML) {
                if (sp != null) {
                    Database.rollback(sp);
                }
                for (Integer i = 0; i < exDML.getNumDml(); i++) {
                    if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                        System.Debug('** Exception:' + exDML.getDmlMessage(i));
                        gu.AddErrorMsg(Label.msgException);
                    }
                }
                rq.STA__c = oldSTA;
                return null;
            } catch (exception ex) {
                if (sp != null) {
                    Database.rollback(sp);
                }
                gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
                rq.STA__c = oldSTA;
                return null;
            }
        } else {
            gu.AddErrorMsg('Invalid operation.');
            return null;
        } /*/return null; */
    }
    public Boolean nD {
        get {
            if (rq.rDocs__r == null) {
                return false;
            }
            for (g_reqDoc__c d: [select id, upOk__c from g_reqDoc__c where RQ__c =: rq.id]) {
                if (!d.upOk__c) {
                    return true;
                }
            }
            return false;
        }
    }
    public PageReference accLocInfo() {
        List < loc__c > locLst = [select id, bu__c, Bldg__c, plt__c, offno__c, flr__c, acc__r.lcidt__c, acc__r.Type, acc__r.lcedt__c from loc__c where acc__c =: rq.Acc__c and active__c = true order by createddate desc limit 1];
        if (locLst != null && !locLst.isEmpty()) {
            if (locLst[0].acc__r.Type != Label.msgDEDAccType) {
                gu.AddErrorMsg(Label.msgDEDAcc);
                return null;
            }
            rq.xbtnm__c = locLst[0].Bldg__c;
            rq.xcstrt__c = locLst[0].plt__c;
            rq.xcln__c = locLst[0].offno__c + ',' + locLst[0].flr__c;
            rq.xceididt__c = locLst[0].acc__r.lcidt__c;
            rq.xceidedt__c = locLst[0].acc__r.lcedt__c;
        }
        return null;
    }
    public PageReference CancelRBO() {
        return null;
    }
    public class mbr {
        public g_reqMbr__c m {
            get;
            set;
        }
        public Boolean isnw {
            get {
                return m.Id == null;
            }
        }
        public mbr(g_reqMbr__c mvar) {
            m = mvar;
        }
        public void adjust(g_Req__c r) {
            m.RQ__c = r.Id;
            m.Name = (m.fnm__c == null ? '' : m.fnm__c) + (m.lnm__c == null ? '' : m.lnm__c);
        }
    }
    public Map < String, Integer > el {
        get;
        set;
    }
    public List < ParkingM.AddPark > lstAddparks {
        get;
        set;
    }
    public string needApproval {
        get;
        set;
    }
    public Decimal amnt {
        get;
        set;
    }
    public static String pdMsg {
        get;
        set;
    }
    public Boolean hdCnt {
        get;
        set;
    }
    public Datetime stDt {
        get;
        set;
    }
    public PageReference getAcc2() {
        getAcc();
        return null;
    } /* Non-RTA FREE parking starts public PageReference loadCards() { try{ if(rq != null && !rq.xdapp__c && ((rq.STA__c.equalsIgnoreCase('draft') || rq.STA__c.equalsIgnoreCase('open')) && ((md.isEdit || md.isNew) && !rq.STA__c.equalsIgnoreCase('under review'))) ) { ParkingM pm = new ParkingM();hdCnt = false; if(srv.uid__c == gu.csStr('AdditionalParking')){lstAddparks = pm.getAddParks(rq,acc.ORACLE_PARTY_ID__c);if(lstAddparks.size()==0){hdCnt=true;} if(!rq.STA__c.equalsIgnoreCase('open') && lstAddparks.size()==0){st=false;} }else{ if(String.isNotBlank(cn)) {rq.xtcid__c = cn; ParkingM.shwOne = true;}else{ParkingM.shwOne = false;} String opi = '';  if(ispu){ opi=acc.ORACLE_PARTY_ID__c; }else if(srv.uid__c=='197'){ List<Account> acc1 = [SELECT id, name, ORACLE_PARTY_ID__c FROM account WHERE id=:rq.Acc__c]; if(acc1.size()>0)opi=acc1[0].ORACLE_PARTY_ID__c; }  System.debug('@@@@ opi : ' + rq.Acc__r.ORACLE_PARTY_ID__c); lst_pd = pm.loadCards(rq,srv.uid__c,opi);if(!rq.STA__c.equalsIgnoreCase('open') && lst_pd.size()==0){st=false;} System.debug('!!! ST : ' + st + ' *** pgHide: ' + pgHide); } } if(String.isNotBlank(pdMsg) && !md.isNew){gU.AddWarningMsg(pdMsg);} }catch(Exception ex){st=false;System.debug('Exception : '+ex.getStackTraceString());} return null; } */
    public Map < String, String > validateVehicle() {
        ParkingM pm = new ParkingM();
        Map < String, String > response = new Map < String, String > ();
        response.put('ResponseCode', '0');
        response.put('errMessage', '');
        System.debug('<validateVehicle>: srv.uid__c' + srv.uid__c);
        if (srv.uid__c == gu.csStr('ParkingActivation') || srv.uid__c == gu.csStr('ParkingModification')) {
            response = pm.validateVehicle2(rq, new List < gctlReqI.itm > ());
        }
        return response;
    }
    public void getParkings() {
        el = new Map < String, Integer > ();
        el.put('eligibilty', 0);
        el.put('utilized', 0);
        try {
            ParkingM p = new ParkingM();
            el = p.getEligibility(acc);
        } catch (Exception ex) {
            System.debug('@@Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    } /* Non-RTA FREE parking ends */ /* Non RTA PAID/Additional parking starts */
    public PageReference getAmntAP() {
        ParkingM p = new ParkingM();
        pdMsg = '';
        Map < String, String > response = p.getAmntAP(Date.newInstance(rq.xaed__c.year(), rq.xaed__c.month(), rq.xaed__c.day()), rq.xanum__c);
        if (response.get('errorCode') == '0') {
            amnt = Decimal.valueOf(response.get('amount'));
        } else {
            amnt = 0.0;
            gu.AddErrorMsg(response.get('errorMsg'));
        }
        return null;
    } /*ToDo : Handle in JS */
    public void getStDate() {
        if (rq.xfpc__c == null) {
            stdt = System.now().addDays(2);
        } else {
            stdt = rq.xfpc__c;
        }
        stDt = date.newInstance(stDt.year(), stDt.month(), stDt.day());
    }
    public List < ParkingM.PkgCard > lstCards {
        get;
        set;
    }
    public PageReference getpkgCards() {
        try {
            lstCards = new ParkingM().getpkgCards(rq.xuvdet__c);
        } catch (Exception ex) {
            gu.AddInfoMsg('Couldn\'t fetch existing card details, please contact your administrator!');
        }
        return null;
    }
    public void conInfo() {
        Contact con = [select id, Salutation, ms__c from Contact where id =: rq.Con__c];
        rq.xcslt__c = con.Salutation;
        rq.xcms__c = con.ms__c;
    } /* parking cancellation and deactivation */
    public boolean processParking() {
        Boolean returnPg = false;
        if (srv.uid__c == gu.csStr('ParkingCancellation') || srv.uid__c == gu.csStr('ParkingDeact')) {
            /*String status = (srv.uid__c==gu.csStr('ParkingCancellation')) ? 'Under Review' : 'Completed';*/
            if (!rq.xoca__c) {
                upsertR('Under Review');
                new ParkingM().pushReqItems(rq.Id, new List < g_reqitem__c > ());
                returnPg = true;
            }
        }
        return returnPg;
    } /* Non RTA PAID/Additional parking ends */ /*Insurance for Renewal services */
    public PageReference getInsTp() {
        /*/ToDo : use custom settings for UID */
        System.debug('srv.uid__c : ' + srv.uid__c);
        isSpActive = true;
        Set < String > stdIns = new Set < String > (gu.csStr('INS_STD').split(';'));
        Set < String > spoIns = new Set < String > (gu.csStr('INS_SPO').split(';'));
        Set < String > chldIns = new Set < String > (gu.csStr('INS_CHLD').split(';'));
        if (rq.Con__r.Spon__r.size() > 0) {
            spInsTp = rq.Con__r.Spon__r[0].intp__c;
        }
        if (srv != null && spoIns != null && spoIns.contains(srv.uid__c)) {
            if (rq.xard__c) {
                insRqTp = 'spoNew';
            } else {
                insRqTp = 'spoRnwl';
            }
        } else if (srv != null && chldIns != null && chldIns.contains(srv.uid__c)) {
            if (rq.xard__c) {
                insRqTp = 'chldNew';
            } else {
                insRqTp = 'chldRnwl';
            }
        } else if (srv != null && stdIns != null && stdIns.contains(srv.uid__c)) {
            if (rq.Con__r.Spon__r.size() > 0) {
                isSpActive = (rq.Con__r.Spon__r[0].STA__c.equalsIgnoreCase('Active')) ? true : false;
                spInsTp = rq.Con__r.Spon__r[0].intp__c;
            }
        }
        System.debug('insRqTp : ' + insRqTp);
        return null;
    } /* courier delivery */
    public PageReference assignMngr() {
        Id userId = UserInfo.getUserId();
        User u = [select id, contactId from User where id =: userId];
        Id getContactId = u.contactId;
        List < Contact > lstMngr = [Select Id, name, MobilePhone, Account.xcuzn__c, Account.Location__c, Account.xcublg__c From Contact where accountId =: rq.Acc__c AND id =: u.contactId LIMIT 1];
        if (lstMngr.size() > 0) {
            mngr = lstMngr[0];
        }
        return null;
    }
    public List < SelectOption > getSalutations() {
        List < selectOption > options = new List < selectOption > ();
        options = getOptions('xcslt__c');
        return options;
    }
    public List < SelectOption > getOptions(String PickListFieldName) {
        Schema.sObjectType sobject_type = g_Req__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap();
        List < Schema.PicklistEntry > pick_list_values = field_map.get(PickListFieldName).getDescribe().getPickListValues();
        List < selectOption > options = new List < selectOption > ();
        for (Schema.PicklistEntry a: pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    public List < String > getAvailableDocs() {
        List < selectOption > options = new List < selectOption > ();
        options = getOptions('xnld__c');
        List < string > docs = new List < string > ();
        for (selectOption op: options) {
            docs.add(op.getValue());
        }
        return docs;
    } /*public List<String> lstPrmtReq {get;set;}public void getPrmtReqs(){lstPrmtReq = new List<String>();if(String.isNotBlank(rq.hpr__c)){lstPrmtReq = rq.hpr__c.split(';');}}  */
    public List < String > lstPrmtReq {
        get;
        set;
    }
    public List < g_req__c > lstActiveReq {
        get;
        set;
    }
    public void getPrmtReqs() {
        lstActiveReq = new List < g_req__c > ();
        lstPrmtReq = new List < String > ();
        if (String.isNotBlank(rq.hpr__c)) {
            lstPrmtReq = rq.hpr__c.split(';');
        } /*/ axs-2.0 get all active apt requests and display on the page */
        lstActiveReq = [SELECT Id, Name, xcpid__c, xcped__c, xrap__c, prf__c, xbn__c, csp__c, xchn__c, xceml__c, xcmob__c from g_req__c where srvc__r.uid__c = 'apt'
            and id !=: rq.id and acc__c =: rq.acc__c and sta__c in ('Under Review', 'In Progress') and xcped__c > today
        ];
    }
    public List < String > getlstActivities() {
        /*/system.debug('lstActivities:::::'); */
        List < selectOption > options = new List < selectOption > ();
        options = getOptions('hpr__c');
        List < string > lstActivities = new List < string > ();
        for (selectOption op: options) {
            lstActivities.add(op.getValue());
        }
        System.debug('lstActivities:  ' + lstActivities);
        return lstActivities;
    }
    public String selectedEmb {
        get;
        set;
    }
    public List < SelectOption > getCountriesOptions() {
        List < SelectOption > countryOptions = new List < SelectOption > ();
        Map < String, String > mapCC = new Map < String, String > {
            'Afganisthan ' => 'xaf',
            'Algeria' => 'xdz',
            'Albania' => 'xal',
            'Angola' => 'xao',
            'Argentina' => 'xar',
            'Armenia' => 'xam',
            'Australia' => 'xau',
            'Austria' => 'xat',
            'Azerbaijan' => 'xaz',
            'Bahrain' => 'xbx',
            'Bangladesh' => 'xbd',
            'Belarus' => 'xbl',
            'Belgium' => 'xbe',
            'Bosnia and Herzegovina ' => 'xba',
            'Brazil' => 'xbr',
            'Bulgaria' => 'xbg',
            'Canada' => 'xca',
            'Chile' => 'xcl',
            'China' => 'xcn',
            'Colombia' => 'xco',
            'Costa Rica' => 'xcr',
            'Cyprus' => 'xcy',
            'Denmark' => 'xdk',
            'Dominican Republic' => 'xdu',
            'Eritrea' => 'xer',
            'Ethiopia' => 'xet',
            'France' => 'xfr',
            'Ghana' => 'xgh',
            'Greece' => 'xgr',
            'Grenada' => 'xgd',
            'Guinea' => 'xgn',
            'Hungary' => 'xhu',
            'India' => 'xin',
            'Indonasia' => 'xid',
            'Ireland' => 'xie',
            'Italy' => 'xit',
            'Kazakhstan' => 'xkz',
            'Kuwait' => 'xkw',
            'kyrgystan' => 'xkg',
            'Lebanon' => 'xlb',
            'Libya' => 'xly',
            'Luxemborg' => 'xlu',
            'Malaysia' => 'xmy',
            'Malta' => 'xmt',
            'Mexico' => 'xmx',
            'Montenegro' => 'xcs',
            'Mozambique' => 'xmz',
            'Nepal' => 'xnp',
            'Netherlands' => 'xnl',
            'New Zealand' => 'xnz',
            'Norway' => 'xnw',
            'Oman' => 'xom',
            'Pakistan' => 'xpk',
            'Palestine' => 'xps',
            'Panama' => 'xpa',
            'Peru' => 'xpe',
            'Philippine' => 'xph',
            'Poland' => 'xpl',
            'Portugal' => 'xpt',
            'Republic of Korea' => 'xkr',
            'Republic of Liberia' => 'xlr',
            'Rwanda' => 'xrw',
            'Saint Kitts' => 'xkn',
            'Saudi Arabia' => 'xsa',
            'Senegal' => 'xsn',
            'Serbia' => 'xsr',
            'Seychelles' => 'xsc',
            'Slova Republic' => 'xsk',
            'Somalia' => 'xso',
            'Spain' => 'xes',
            'Sri Lanka' => 'xsl',
            'Sudan' => 'xsd',
            'Sweden' => 'xse',
            'Switzerland' => 'xch',
            'Tajikistan' => 'xtj',
            'Tanzania' => 'xtz',
            'Tunisia' => 'xtn',
            'Turkey' => 'xtr',
            'Turkmenistan' => 'xtm',
            'Uganda' => 'xug',
            'Usbekistan' => 'xuz',
            'Venezuela' => 'xve',
            'Vietnam' => 'xvn'
        };
        countryOptions.add(new SelectOption('', '--None--'));
        for (String s: mapCC.keySet()) {
            countryOptions.add(new SelectOption(mapCC.get(s), s));
        }
        return countryOptions;
    }

    /************************************************************************************************* 
     * Description    : Method to update Encripted QRCode Link on request.
     * Created Date    : 28-July-2024                                        
     * Created By    : Prateek Jangir
     **************************************************************************************************/
    public void updateEncriptedQRCodeLink(g_req__c requestRecord) { //1.1
        if (requestRecord.Id != null) {
            Integer randomNumber = 5; //Integer.valueOf(Math.floor(Math.random() * (6) + 1));
            String encryptedId = gctlInsHelper.encryptStr(requestRecord.Id, randomNumber);
            String finalEnd = encryptedId; //.replace('+','%20');
            String validateQRCodeURL = 'https://axs.force.com/validate?ri=' + finalEnd;
            requestRecord.Encrypted_QR_Code_URL__c = validateQRCodeURL; // EncodingUtil.urlEncode(validateQRCodeURL, 'UTF-8');
            update requestRecord;
        }
    }

}
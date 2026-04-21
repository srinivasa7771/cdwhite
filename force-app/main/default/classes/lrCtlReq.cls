public without sharing class lrCtlReq {

    public Boolean showCPUWarning {
        get;
        set;
    }

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
    public boolean uboFlg {
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
    public String licpriceMap {
        set;
        get;
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
    public g_Req__c req {
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
    public Decimal psfFee {
        get;
        set;
    }
    public List < loc__c > regOffnew {
        get;
        set;
    }
    public List < loc__c > regOffnew1 {
        get;
        set;
    }
    public Boolean spFlaf {
        get;
        set;
    }
    public String pMap {
        get;
        set;
    } /*// Temp Flag For Provisional Issuance*/
    public Boolean provisionalIssuance {
        get;
        set;
    } /*// Temp Flag For Provisional Issuance*/
    public String strpriceMap {
        get;
        set;
    } /*//Insurance */
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
    public Transient List < grqWsDccaGetService.Records > tecomd3LsList {
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
    public List < grqWsOnboard.QuoteInfo > leaseList {
        get;
        set;
    }
    public Transient Map < string, List < grqWsOnboard.PaymentSchedules >> paymentMp {
        get;
        set;
    }
    public Transient List < grqWsOnboard.Invoices > invoiceLst {
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
    } /*//public map<String,List<String>> newmapLoc {get;set;}*/
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
    } /*// addedBy SH*/
    public string lcl {
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
    public static String searchNum {
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
    public transient String imageBase64 {
        get;
        set;
    }
    public String reqDocId {
        get;
        set;
    }
    public String docName {
        get;
        set;
    }
    public map < String, String > agreeLocMap {
        get;
        set;
    } /*//###*/
    public Map < String, String > sItmByCode {
        set;
        get;
    }
    public boolean ejariLeaseFlg {
        set;
        get;
    }
    public boolean lsdiffFlg {
        set;
        get;
    }
    public Decimal crmLeaseArea {
        get;
        set;
    }
    public Decimal ejariLeaseArea {
        get;
        set;
    }
    public Decimal leaseDifference {
        get;
        set;
    }
    public List < grqWsDccaGetService.ContractInfo > contractLst {
        get;
        set;
    }
    public PMSLeaseAmdInfo lsAmdInfo {
        set;
        get;
    }
    public boolean isInsurance {
        get;
        set;
    }
    public boolean isDigitalSign {
        get;
        set;
    }
    public boolean isHSELease {
        get;
        set;
    }
    public List < UnitWrapper > unitDetails {
        get;
        set;
    }
    public List < PaymentScheduleWrapper > paymentSchDetails {
        get;
        set;
    }
    public List < PaymentScheduleWrapper > paymentSchDetailsPost {
        get;
        set;
    }
    public String redirectURL {
        get;
        set;
    }
    public Boolean bCallAdnic {
        get;
        set;
    }
    public String rqTp {
        get;
        set;
    }
    public String errorMsg {
        get;
        set;
    }

    String dtstr = String.ValueOf(system.NOW());

    public string discount {
        get;
        set;
    }

    public Map < String, Policy > insPolicies = new Map < String, Policy > ();
    public Account acnt {
        get;
        set;
    }

    public Boolean isDependentApp {
        get;
        set;
    }
    public String selectedInsuranceType {
        get;
        set;
    }
    public String isInsTypeChange {
        get;
        set;
    }
    public String isPolicyNumChange {
        get;
        set;
    }
    public String isPolicyComChange {
        get;
        set;
    }
    public String isExpireDateChange {
        get;
        set;
    }
    public String isDigitalSignChange {
        get;
        set;
    }
    public String amtinWords {
        get;
        set;
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
    } /*in5 Variables Start*/
    public List < g_Req__c > rqRenLst {
        get;
        set;
    } /*/ Renewal Request */
    public List < String > renewLinkLst {
        get;
        set;
    } /*/ Renewal RequestURL */
    public boolean isIn5 {
        get;
        set;
    }
    public String in5idrq {
        get;
        set;
    }
    public String rqsrvc {
        get;
        set;
    }
    public String pgno {
        get;
        set;
    }
    public String newMemType {
        get;
        set;
    }
    public blob file1 {
        get;
        set;
    }
    public List < Selectoption > SegmentList {
        get;
        set;
    }
    public List < Selectoption > IndustryTypeList {
        get;
        set;
    }
    public List < Selectoption > businessGrowthStageList {
        get;
        set;
    }
    public List < Selectoption > leadSourceList {
        get;
        set;
    }
    public List < Selectoption > specificTechList {
        get;
        set;
    }
    public List < Selectoption > fundingStageList {
        get;
        set;
    }
    public List < Selectoption > customMemTypeList {
        get;
        set;
    }
    public List < Selectoption > GraduationYearList {
        get;
        set;
    }
    public List < Selectoption > specializationList {
        get;
        set;
    }
    public boolean showSg {
        get;
        set;
    }
    public boolean showPg1 {
        get;
        set;
    }
    public boolean showPg2 {
        get;
        set;
    }
    public boolean thanksFlg {
        get;
        set;
    }
    public boolean SubmitedFlg {
        get;
        set;
    }
    public boolean captchaVerified {
        get;
        set;
    }
    public boolean emailValid {
        get;
        set;
    }
    public boolean showRenewal {
        get;
        set;
    }
    public boolean showPD {
        get;
        set;
    }
    public Map < Id, g_reqitem__c > reqItems;
    public List < g_reqitemDoc__c > rqItemDocLst;
    public lrCtlReq() {}

    public lrCtlReq(ApexPages.StandardController c) {
        sItmByCode = new Map < String, String > ();
        requestItemWrappers = new List < RequestItemWrapper > (); /*/c.addFields(new List<String>{'Provisional_Issuance__c'});*/
        rq = (g_Req__c) c.getRecord();
        system.debug('#####################3');
        system.debug('couct rq>>' + rq);
        system.debug('#####################3');
        st = true;
        mngr = new Contact();
        amedFlag = false;
        ejariLeaseFlg = false;
        lsdiffFlg = false;
        md = new gu.pgMode();
        segflag = false;
        locflag = false;
        incubflag = false;
        brnchincubflag = false;
        fzllcflag = false;
        freelancerFlag = false;
        tcopylist = new list < lostDocWrap > (); /*/  provisionalIssuance = rq.Provisional_Issuance__c;*/
        provisionalIssuance = false;
        ispu = gu.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
        mbrs = new list < mbr > ();
        mbrCnt = 0;
        crmLeaseArea = 0.0;
        ejariLeaseArea = 0.0;
        leaseDifference = 0.0;
        pgHide = false;
        allSeg = new List < seg__c > ();
        allAct = new grqWsDccaGetService.ActivityLocations();
        dccalocList = new List < grqWsDccaGetService.Locations > ();
        dccaActList = new List < grqWsDccaGetService.Activities > ();
        tecomLeaseList = new List < grqWsDccaGetService.Records > ();
        tecomd3LsList = new List < grqWsDccaGetService.Records > ();
        d3LeaseList = new List < grqWsDccaGetService.Records > ();
        actLoc = new grqWsDccaGetService.ActivityLocations();
        contractLst = new List < grqWsDccaGetService.ContractInfo > ();
        crmAgrList = new List < grqWsDccaGetService.Records > ();
        leaseList = new List < grqWsOnboard.QuoteInfo > ();
        paymentMp = new Map < string, List < grqWsOnboard.PaymentSchedules >> ();
        invoiceLst = new List < grqWsOnboard.Invoices > ();
        lsAmdInfo = new PMSLeaseAmdInfo();
        dccaStatusMap = new map < String, String > ();
        sancflag = false;
        uboFlg = false;
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
        if (srv != null) {
            system.debug('srv.uid__c >>' + srv.uid__c);
            locList = new List < SelectOption > ();
            locList2 = new List < SelectOption > ();
            seg = new List < seg__c > ();
            if (srv != null && srv.uid__c == 'ltc') {
                loadLocations();
                loadSegAct();
            }
            if (srv != null && (srv.uid__c == '208') && (rq.id == null || (rq != null && rq.STA__c == 'Open' && rq.AP__c == 0))) {
                LoadAllLocSeg(true);
            }
            if (srv != null && srv.uid__c == 'ltc') {
                loadLocations();
                loadSegAct();
            }
            if (srv != null && (srv.uid__c == '200' || srv.uid__c == '201')) {
                makeTrueCopyList();
            } /*/system.debug('xadtx1::'+rq.xadtx1__c);*/
            if (srv != null && rq.id != null && (srv.uid__c == '216' || srv.uid__c == '217' || srv.uid__c == '218') && !string.isEmpty(rq.xadtx3__c)) {
                /*/grqWsOnboard res = (grqWsOnboard) JSon.deserialize(rq.xadtx3__c, grqWsOnboard.class);*/
                grqWsOnboard.Records rec = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class);
                if (rec != null && rec.Invoices != null && !rec.Invoices.isEmpty()) invoiceLst = rec.Invoices;
                system.debug('rec.quotes::' + rec.quotes);
                if (rec != null && rec.quotes != null && !rec.quotes.isEmpty()) {
                    grqWsOnboard.QuoteInfo qinfo = grqWsOnboard.fetchLeaseDetails(rec.quotes, rq.id);
                    system.debug('qinfo::' + qinfo);
                    leaseList.add(qinfo);
                } /*/invoiceLstJson = JSON.serialize(invoiceLst);*/ /* if(leaseList != null && !leaseList.isEmpty()){ for(grqWsOnboard.Records rec : leaseList){ rec.productName = rec.Products[0].ProductName; }   }*/
            }
            if (srv.uid__c == '219') {
                getLeaseDetails();
            }
            system.debug('Calling Adnic mail'); /* if(rq.xcbd__c!=null){system.debug('Inside Adnic mail'); if(Integer.valueOf(system.TODAY().YEAR()) - Integer.valueOf(rq.xcbd__c.YEAR()) >= 64){system.debug('Called Adnic mail');sendAdnicEmail();   } }*/
            system.debug('srv >> ' + srv.uid__c);
        }
        lstSegments3 = new List < DED_Activity__c > ();
        lstSegments3 = [SELECT id, name, Activity__c, Alwd__c, Fees__c, Park__c, Segment__c, Segments_Description__c, Activity_Description__c FROM DED_Activity__c WHERE C_Act_Id__c != 'NA'
            AND C_Seg_Id__c != 'NA'
            AND DDA_Enabled__c = true
        ];
        if (srv.uid__c == '196') {
            bCallAdnic = true;
            rqTp = 'new';
            List < Integer > remainingKeys = new List < Integer > ();
            Date currentDate = System.today();
            System.debug('rq.xadtx1__c :' + rq.xadtx1__c);
            RqWrapper rqData = (RqWrapper) JSON.deserialize(rq.xadtx1__c, RqWrapper.class);
            unitDetails = rqData.units;
            Map < String, List < PaymentScheduleWrapper >> allPaymentSchedules = rqData.paymentSchedule;
            paymentSchDetailsPost = new List < PaymentScheduleWrapper > ();
            paymentSchDetails = new List < PaymentScheduleWrapper > ();
            Map < String, PaymentScheduleWrapper > mapPHY = new Map < String, PaymentScheduleWrapper > ();
            if (allPaymentSchedules != null && allPaymentSchedules.size() > 0) {
                List < Integer > sortedTerms = new List < Integer > ();
                for (String key: allPaymentSchedules.keySet()) {
                    sortedTerms.add(Integer.valueOf(key));
                }
                sortedTerms.sort();
                for (Integer term: sortedTerms) {
                    List < PaymentScheduleWrapper > schList = allPaymentSchedules.get(String.valueOf(term));
                    if (schList == null) continue;
                    for (PaymentScheduleWrapper sch: schList) {
                        Boolean isTermOne = (sch.term == '1');
                        Boolean isBeforeRenewal = (sch.chargeFrom != null && sch.chargeFrom < currentDate);
                        if (isTermOne || isBeforeRenewal) {
                            sch.isSelected = true;
                            paymentSchDetails.add(sch);
                        } else {
                            paymentSchDetailsPost.add(sch);
                        }
                    }
                }
            }
            String amt = String.valueOf(rq.xtpa__c);
            String[] aramt = amt.split('\\.');
            Integer baseAmt = Integer.ValueOf(aramt[0]);
            Integer baseAmt2 = 0;
            if (aramt.size() > 1) {
                baseAmt2 = Integer.ValueOf(aramt[1]);
            }
            amtinWords = gU.AmountInWords(baseAmt) + ' Dirhams';
            if (baseAmt2 != 0 && aramt.size() > 1 && aramt[1] != null) {
                amtinWords = amtinWords + ' ' + gU.AmountInWords(baseAmt2) + ' Fils';
            }
        }
    }

    public String delRecId {
        get;
        set;
    }
    public void deleteRecord() {
        String recid = Apexpages.currentPage().getParameters().get('delRecID');
        system.debug('delID---> ' + recid);
        delete[select Id from g_reqitem__c where Id =: recid];
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
        isIn5 = false;
        try {
            if (rq.id == null) {
                md.setNew();
                loadData(true);
                validate(true);
            } else {
                md.getPgParam();
                loadData(false);
                validate(true);
                fetchRequestItems();
                System.debug('req item wrapper size:>>>>> ' + requestItemWrappers);
            }
        } catch (exception ex) {
            gu.AddErrorMsg('** Exception:' + ex.getStackTraceString());
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
                srv = [select id, xoi__c, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id =: rq.srvc__c limit 1];
                if (isgu) {
                    /*/ only if guest users*/
                    List < Account > accs = [select id, ecedt__c, lcsta__c, Name, Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, sncNt__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, vvsfp__c, session__c from Account where id =: System.Label.TecomAccnt]; /*/ 0012000001DbKS9*/
                    if (accs != null && accs.size() > 0) {
                        rq.Acc__c = accs[0].id; /*/ rq.Spr__c='00328000018PBLv'; */
                        acc = accs[0];
                    }
                    empid = ApexPages.currentPage().getParameters().get('empid');
                    pid = ApexPages.currentPage().getParameters().get('pid');
                    encid = ApexPages.currentPage().getParameters().get('enc');
                    sid = ApexPages.currentPage().getParameters().get('sid'); /*/s isgu = gu.isGuestUser(userInfo.getProfileId()) ;*/
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
                rq = [select Id, srvc__c, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.reqq__c, srvc__r.stg__r.bopg__c from g_Req__c where id =: rq.id]; /*/ Teporarily Added by JP*/
                system.debug('460 rq>>' + rq.srvc__c);
                rq = (g_Req__c) Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false'); /* // exstDpd = false; // if(rq != null && rq.id!=null){ string dpdServiceName = Label.dpdSrvcNames;   if(dpdServiceName.contains(',')){   for(string s : dpdServiceName.split(',')){  exstDpd = rq.srvc__r.Name.contains(s.Trim())  ? rq.xard__c : false;  }   }else {exstDpd = rq.srvc__r.Name.contains(dpdServiceName)  ? rq.xard__c : false;} }*/
                if (rq.reqMbrs__r != null) {
                    for (g_reqMbr__c m: rq.reqMbrs__r) {
                        mbrs.add(new mbr(m));
                    }
                    mbrCnt = mbrs.size();
                } /*if(rq.Items__r != null){for(g_reqitem__c itm: rq.Items__r){ if(rq.srvc__r.name == 'Employee Visa (3 Years)' && itm.sta__r.staown__c == 'Customer' && itm.sta__r.statype__c == 'Correction')isRC=true; }}*/
                Acc = rq.acc__r;
                srv = rq.srvc__r;
                getAcc(); /* for licence renewal requests start*/ /* if((srv.uid__c=='208') && Acc.lcsta__c=='License Under Renewal'){ if(rq.xcawp__c){LoadAllLocSeg(false);}else{LoadAllLocSeg(true);} setDCCAReqValues(rq); }*/
                if ((srv.uid__c == '208') && Acc.lcsta__c == 'License Under Renewal' && rq.STA__c != 'Completed' && rq.STA__c != 'Rejected' && rq.STA__c != 'Cancelled') {
                    if (rq.xcawp__c) {
                        LoadAllLocSeg(false);
                    } else {
                        LoadAllLocSeg(true);
                    }
                    setDCCAReqValues(rq);
                } /* for licence renewal requests end*/ /* for new to add onboarding new status */ /*if(srv.uid__c=='216'){ setNewDCCAReqValues(rq); }*/
            } else {
                rq.conrol__c = srv.conrol__c;
                rq.consta__c = srv.consta__c;
                rq.sprrole__c = srv.sprrole__c;
                rq.sprsta__c = srv.sprsta__c;
                rq.STA__c = 'Draft';
            }
            system.debug('rq >>:' + rq);
            system.debug('########isnw#############-' + isnw);
            system.debug('########ispu#############4' + ispu);
            system.debug('########isgu#############4' + isgu);
            if ((isnw && ispu) && !isgu) {
                system.debug('########UserInfo.getUserId()#############--' + UserInfo.getUserId());
                User usr = [select id, contact.account.mtc__c, contact.account.Name, contact.account.Email__c, contact.account.Phone, MobilePhone, accountid, contact.account.id, contact.account.adb__c, contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c, contact.account.lcsta__c, contact.account.lctp__c, contact.account.session__c, contact.account.vctemp__c, contact.account.vvsfp__c from User where id =: UserInfo.getUserId() limit 1];
                Acc = usr.contact.account;
                rq.acc__c = Acc.Id;
                rq.xaloc__c = acc.loc__c;
                rq.rmob__c = usr.MobilePhone;
                system.debug('########rq.acc__c#############4');
                system.debug(rq.acc__c);
                system.debug(Acc.Id);
                system.debug('#####################4');
                rq.xbrnd__c = acc.xcuzn__c;
                rq.xbn__c = acc.xcublg__c;
                rq.xceml__c = usr.contact.account.Email__c;
                rq.xoln__c = usr.contact.account.Phone;
                if (srv.uid__c == '010' || srv.uid__c == '080' || srv.uid__c == '188' || srv.uid__c == '192' || srv.uid__c == '019') {
                    rq.mtc__c = 'DHA';
                } else rq.mtc__c = acc.mtc__c;
                getAcc(); /*/loadLocations();*/
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
                '057',
                '056',
                '147'
            };
            if (uids.contains(srv.uid__c)) {
                getInsTp();
            }
            if (srv.uid__c == '208' && Acc.lc__c != null) {
                getCPUDetails(Acc.lc__c);
            }
        } catch (exception ex) {
 gu.AddErrorMsg(Label.msgException); 
			System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()+'' + ex.getLineNumber());            System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }
    public Pagereference nvgStatusPage() {
        Pagereference ref = null;
        if ((srv.uid__c == '208') && (rq.AP__c == null || (rq.AP__c != null && rq.AP__c == 0)) && rq.xcawp__c) {
            ref = new Pagereference('/apex/grqStatus?id=' + rq.id);
            ref.setRedirect(true);
        }
        return null;
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS' + msg))).toUpperCase();
        System.debug('** eCd:' + eCd);
        System.debug('** encText:' + encText);
        return eCd == encText;
    }
    //private void getAcc(){Acc = [select id,ecedt__c,Name,Legal_Framework__c,Phone,adb__c,bgb__c,bgnr__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c,vvsfp__c,(Select Id ,acct__c,act__c,act_type__c,bus_unit__c,dcca_id__c,lic__c,or_prty__c,seg__c,sDate__c from aseg__r),(Select Id,Loc__c,agrno__c,acc__c,bu__c,IsMain__c,IsSub__c,ls_end__c,ls_std__c,active__c,rpi__c,Is_frzn__c from aloc__r where Is_frzn__c=true  ),session__c from Account where id=: rq.Acc__c limit 1];}
    private void getAcc() {
        if (rq.Acc__c != null) {
            Acc = [select id, vespe__c, Freehold__c, SF_CRM_ID__c, dccaexId__c, ccrm_sfid__c, ecedt__c, dedlic__c, lcsta__c, Name, Legal_Framework__c, lrd__c, onar__c, Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, vvsfp__c, (Select Id, acct__c, act__c, act_type__c, bus_unit__c, dcca_id__c, lic__c, or_prty__c, seg__c, sDate__c from aseg__r), (Select Id, Loc__c, agrno__c, acc__c, bu__c, IsMain__c, IsSub__c, ls_end__c, ls_std__c, active__c, rpi__c, Is_frzn__c from aloc__r where Is_frzn__c = true), session__c from Account where id =: rq.Acc__c limit 1];
        }
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




    //private void validate(Boolean isNew){if(pg!=gu.pageURL){pgHide = true;gu.addWarningMsg(Label.msgInvReqPg);}
    // if(isNew&&ispu&&hasSanctions){pgHide=true;}if(!accesssOk){pgHide=true;}gU.checkNav();}
    //if(isNew&&ispu && hasSanctions){pgHide=true;}if(!accesssOk){pgHide=true;}gU.checkNav();}

    private void validate(Boolean isNew) {
        if (pg != gu.pageURL) {
            pgHide = true;
            gu.addWarningMsg(Label.msgInvReqPg);
        }
        if (isNew && ispu) {
            pgHide = true;
        }
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
        Decimal psffeeIcVat = 0.0;
        ejariLeaseArea = 0.0;
        crmLeaseArea = 0.0;
        leaseDifference = 0.0;
        lsAmdInfo = new PMSLeaseAmdInfo();
        lsdiffFlg = false;
        Date lsStrDt = null, lsEndDt = null;
        List < PMSDataWrapper.ContractInformation > ejariContractList = null;
        if (isShwloc && Acc.Legal_Framework__c != 'Freelancer') {
            leaseDt = String.ValueOf(Acc.lcedt__c);
            String dccaRes = grqWsDccaGetService.getReqDetails(Acc.lc__c, leaseDt, rq.xdei__c, false);
            system.debug('dccaRes::' + dccaRes);
            if (String.isNotBlank(dccaRes)) {
                grqWsDccaGetService jj = (grqWsDccaGetService) System.JSON.deserialize(dccaRes, grqWsDccaGetService.class);
                if (jj.Data != null && !jj.Data.isEmpty() && String.isNotBlank(jj.Data.get(0).idRec)) rq.xdei__c = jj.Data.get(0).idRec;
                if (jj.Data != null && !jj.Data.isEmpty() && String.isNotBlank(jj.Data.get(0).leaseType) && (jj.Data.get(0).leaseType == 'PMS Lease' || jj.Data.get(0).leaseType.contains('PMS'))) {
                    rq.xpmsle__c = true;
                    system.debug('pms lease::::');
                }
            }
            if (rq.xpmsle__c) {
                ejariContractList = gwsPMSIntegration.getEjariContractInfoByLicenseNo(Acc.lc__c);
                if (ejariContractList != null && !ejariContractList.isEmpty()) {
                    List < PMSDataWrapper.PropertyInformationList > propertyList = new List < PMSDataWrapper.PropertyInformationList > ();
                    for (PMSDataWrapper.ContractInformation c: ejariContractList) {
                        if (String.isNotBlank(c.ContractNumber) && c.propertyInformationList != null && !c.propertyInformationList.isEmpty()) {
                            propertyList.addAll(c.propertyInformationList);
                            List < String > stdList = c.startDate.split('/');
                            lsStrDt = Date.newInstance(integer.valueOf(stdList[2]), integer.valueOf(stdList[0]), integer.valueOf(stdList[1]));
                            List < String > edList = c.endDate.split('/');
                            lsEndDt = Date.newInstance(integer.valueOf(edList[2]), integer.valueOf(edList[0]), integer.valueOf(edList[1]));
                        }
                    }
                    for (PMSDataWrapper.PropertyInformationList p: propertyList) {
                        if (String.isNotBlank(p.Area)) {
                            ejariLeaseArea += decimal.valueOf(p.Area);
                        }
                    }
                    ejariLeaseArea = (ejariLeaseArea * 10.7639).setScale(2, RoundingMode.HALF_UP);
                    psffeeIcVat = (ejariLeaseArea * decimal.valueOf(Label.PSFFeeSF));
                    Decimal freeholdFee = Decimal.valueOf(Label.FreeHold_PsfFee);
                    if (Acc.Freehold__c != null && Acc.Freehold__c && psffeeIcVat != null && psffeeIcVat > freeholdFee) {
                        psffeeIcVat = psffeeIcVat - freeholdFee;
                    } else if (Acc.Freehold__c != null && Acc.Freehold__c && psffeeIcVat != null && psffeeIcVat < freeholdFee) {
                        psffeeIcVat = 0;
                    }
                    psffeeIcVat = (psffeeIcVat + ((psffeeIcVat * 5) / 100)).setScale(2, RoundingMode.HALF_UP);
                    rq.xsvn__c = String.valueOf(ejariLeaseArea);
                    rq.xadtx2__c = Json.serialize(ejariContractList);
                } /*for (grqWsDccaGetService.ContractInfo cinfo: contractLst) { if (String.isNotBlank(cinfo.contractType) && (cinfo.contractType == 'New' || cinfo.contractType == 'Terminated')) rq.xmamd__c = true; }*/
            }
        }
        grDDAReq ddaRq = new grDDAReq();
        ddaRq.Acc = Acc;
        ddaRq.rq = rq;
        ddaRq.LoadAllLocSeg(isShwloc);
        allAct = ddaRq.allAct;
        dccalocList = ddaRq.dccalocList;
        dccaActList = ddaRq.dccaActList;
        tecomLeaseList = ddaRq.tecomLeaseList;
        tecomd3LsList = ddaRq.tecomd3LsList;
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
        licpriceMap = JSON.serialize(mapAct);
        rq = ddaRq.rq;
        Decimal psfAmount = 0;
        ejariLeaseFlg = false;
        if (rq.xpmsle__c && tecomd3LsList != null && !tecomd3LsList.isEmpty()) {
            for (grqWsDccaGetService.Records rc: tecomd3LsList) {
                String status = (String.isNotblank(rc.Status) ? rc.Status : rc.ContractStatusReason);
                boolean stsFlg = false;
                if (String.isNotBlank(rc.ContractNumber) && String.isNotBlank(rc.Status) && rc.Status == 'Active' && rc.Products != null && !rc.Products.isEmpty()) {
                    crmLeaseArea += rc.TotalSize;
                }
            }
            system.debug('crmLeaseArea::' + crmLeaseArea);
            system.debug('ejariLeaseArea::' + ejariLeaseArea);
            String docs = rq.xcddocs__c;
            List < String > docsdupList = new List < String > ();
            Set < String > docsList = new Set < String > ();
            if (docs != null && docs.length() > 0) {
                docs = docs.replaceAll(':[0-9]', '');
                docsdupList = docs.split(';');
                docsList.addAll(docsdupList);
            }
            leaseDifference = ((crmLeaseArea > ejariLeaseArea) ? (crmLeaseArea - ejariLeaseArea) : (ejariLeaseArea - crmLeaseArea));
            if (ejariContractList != null && !ejariContractList.isEmpty() && ejariLeaseArea != null && ejariLeaseArea != 0 && leaseDifference < 60) {
                /*if(ejariContractList != null && !ejariContractList.isEmpty() && String.isNotBlank(rq.xsvn__c)){*/
                ejariLeaseFlg = true;
                rq.xppsfv__c = docsList != null && docsList.size() > 1 ? false : true; /*in case of direct payment  if more than one doc will go for verifictions*/
                rq.xcawp__c = true;
                rq.xvnum__c = String.valueOf(psffeeIcVat);
                if (lsStrDt != null && lsEndDt != null) {
                    rq.xcpid__c = lsStrDt;
                    rq.xcped__c = lsEndDt;
                } /*if(amedFlag){ rq.xmamd__c = true; }*/
            } else {
                lsAmdInfo.leaseAreaDiff = leaseDifference;
                lsAmdInfo.leaseAreaCRM = crmLeaseArea;
                lsAmdInfo.leaseAreaEjari = ejariLeaseArea;
                lsAmdInfo.visaQuota = (acc.vespe__c != null) ? integer.valueOf(acc.vespe__c) : 0;
                List < Pending_Inv__c > invLst = grqWsDccaGetService.getPMSInvList(acc.id);
                if (invLst != null && !invLst.isEmpty()) {
                    decimal invamount = 0.0;
                    String years = '';
                    integer i = 1;
                    for (Pending_Inv__c inv: invLst) {
                        integer yr = (inv.inv_duedt__c).year();
                        invamount = invamount + inv.amt__c;
                        if (invLst.size() > 1 && i == invLst.size()) {
                            years = years.removeEnd(', ');
                            years += ' and ' + string.valueof(yr);
                        } else years += string.valueof(yr) + ', ';
                        i = i + 1;
                    }
                    years = years.removeEnd(', ');
                    lsAmdInfo.invMsg = years + ', totaling AED ' + invamount;
                }
                lsdiffFlg = true;
                rq.xppsfv__c = false;
                rq.xcawp__c = false;
                rq.xtpa__c = 0;
                newmapLoc = new map < String, List < String >> (); /*rq.xdedln__c =  String.ValueOf(Acc.lcedt__c);*/ /*rq.xcbd__c = Acc.lcedt__c; */
            }
            if (ejariContractList != null && !ejariContractList.isEmpty()) rq.xadtx2__c = Json.serialize(ejariContractList);
        }
        if (Acc.Legal_Framework__c == 'Freelancer') {
            rq.tsrv__c = true;
            psfAmount = 4500.00;
            psfFee = psfAmount + (psfAmount * 0.05);
            if (rq.tsrv__c) {
                pMap = '';
                pMap = pMap + '<tr><td style="width:500px;">Tecom Services</td><td>4725 AED</td></tr>';
                pMap = pMap + '<tr><td style="width:500px;">Freelancer Permit Fee</td><td>2775 AED</td></tr>';
                pMap = pMap + '<tr><td style="width:500px;">Knowledge Dirham</td><td>10 AED</td></tr>';
                pMap = pMap + '<tr><td style="width:500px;">Innovation Dirham</td><td>10 AED</td></tr>';
            }
        } else if (rq.xadtx3__c != null) {
            system.debug('r.xadtx3__c Inside loop' + rq.xadtx3__c);
            grqWsDccaGetService.ResponseData newResp = (grqWsDccaGetService.ResponseData) JSON.deserialize(String.ValueOf(rq.xadtx3__c), grqWsDccaGetService.ResponseData.class);
            List < grqWsDccaGetService.Records > getRecList = new List < grqWsDccaGetService.Records > ();
            if (newResp != null && newResp.Records != null) getRecList = newResp.Records;
            String invName = '';
            boolean tecomservice = false;
            for (grqWsDccaGetService.Records getRec: getRecList) {
                if (getRec.Invoices != null) {
                    List < grqWsDccaGetService.Invoices > pyList = new List < grqWsDccaGetService.Invoices > ();
                    pyList = getRec.Invoices;
                    if (Acc.Legal_Framework__c == 'Freelancer') getRec.FreelancerLease = true;
                    for (grqWsDccaGetService.Invoices py: pyList) {
                        if (py.InvoiceAmount != null && getRec.FreelancerLease != null && getRec.FreelancerLease == true) {
                            psfAmount = (psfAmount + Decimal.ValueOf(py.InvoiceAmount).setScale(2)) - 2775;
                            tecomservice = true;
                            invName += py.InvoiceName + '|';
                        } else if (py.InvoiceAmount != null && py.InvoiceType == 'CHARGES') {
                            psfAmount = (psfAmount + Decimal.ValueOf(py.InvoiceAmount).setScale(2));
                            invName += py.InvoiceName + '|';
                        }
                    }
                }
            }
            rq.xlinv__c = invName;
            psfFee = psfAmount + (psfAmount * 0.05);
        }
        system.debug('psfFee0::' + psfFee);
    }
    public void setDCCAReqValues(g_Req__c rq) {
        grqDDAReqdta ddaRq = new grqDDAReqdta();
        ddaRq.Acc = Acc;
        ddaRq.rq = rq;
        ddaRq.tecomLeaseList = tecomLeaseList; /*/leaseDt='01-05-2019';*/
        ddaRq.tecomd3LsList = tecomd3LsList;
        ddaRq.leaseDt = leaseDt;
        ddaRq.setDCCAReqValues();
        regOffnew = ddaRq.regOffnew;
        priceMap = ddaRq.priceMap;
        pMap = '';
        if (priceMap != null && !priceMap.isEmpty() && (!rq.xpmsle__c || (rq.xpmsle__c && rq.xppsfv__c))) {
            strpriceMap = String.valueOf((priceMap.keySet()));
            for (String key: priceMap.keySet()) {
                pMap = pMap + '<tr><td style="width:500px;">' + key + '</td><td>' + priceMap.get(key) + ' AED</td></tr>';
            }
            pMap = pMap + '<tr><td style="width:500px;">Knowledge Dirham</td><td>10 AED</td></tr>';
            pMap = pMap + '<tr><td style="width:500px;">Innovation Dirham</td><td>10 AED</td></tr>';
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
        if (Acc.Legal_Framework__c != 'Freelancer') {
            uboFlg = true;
        } /*uboFlg = ddaRq.uboFlg;*/
        spFlaf = ddaRq.spFlaf;
        rq = ddaRq.rq;
        rq.xcfn__c = ddaRq.mangerName;
        rq.xcfnar__c = ddaRq.mangerNameA;
        rq.xcln__c = ddaRq.managerNation;
        rq.xclnar__c = ddaRq.managerNationA;
        rq.xdei__c = ddaRq.idRec;
        rq.xeng__c = ddaRq.shareHldType;
        system.debug('psfFee::' + psfFee);
        if (rq.xtpa__c != null && rq.xtpa__c != 0 && psfFee != null && psfFee != 0 && ((rq.xpmsle__c == true && rq.xppsfv__c == true) || (rq.tsrv__c))) {
            system.debug('psfFee1::' + psfFee);
            rq.xtpa__c = rq.xtpa__c + psfFee;
            rq.xdedc__c = gU.AmountInWords(rq.xtpa__c.intValue());
        }
    }



    // new licence

    /*public void setNewDCCAReqValues(g_Req__c rq){
        grqDDAReqdta ddaRq=new grqDDAReqdta();
        ddaRq.Acc=Acc;
        ddaRq.rq=rq;
        ddaRq.setNewDDAReqValues();
        
        priceMap=ddaRq.priceMap;
        
        system.debug('########################priceMap###########################'+priceMap); 
        
        
        if(priceMap!=null && !priceMap.isEmpty()){
            strpriceMap=String.valueOf((priceMap.keySet()));
        }else{strpriceMap='';}
        chanTMap=ddaRq.chanTMap;
        addMainOffMap=ddaRq.addMainOffMap;
        brodcastFlag=ddaRq.brodcastFlag;
        ddaReqStatus=ddaRq.ddaReqStatus;
        sancflag=ddaRq.sancflag;
        spFlaf=ddaRq.spFlaf;
        rq=ddaRq.rq;
        rq.xdei__c = ddaRq.idRec;
        if(rq.xtpa__c!=null && rq.xtpa__c!=0  && rq.xppsfv__c==true){
            rq.xtpa__c=rq.xtpa__c+psfFee;
            rq.xdedc__c=gU.AmountInWords(rq.xtpa__c.intValue());
        }
    } */

    //Account Act and Seg

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
                /*/ 'Service Provider' (s.act__c == 'Bread & bakery' || s.act__c == 'Cafeteria' || s.act__c == 'Coffee Shop' || s.act__c == 'Catering Services' || s.act__c == 'Restaurant' || s.act__c == 'Kiosk' || s.act__c == 'Convenience Store' )*/
                String seg = s.seg__c;
                String act = s.act__c;
                if (s.seg__c != null && s.act__c != null) {
                    seg = s.seg__c;
                    act = s.act__c;
                    seg = seg.toLowerCase();
                    if (act != null) act = act.toLowerCase();
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
    }

    //Account loaction

    public void loadLocations() {
        List < loc__c > loc = new List < loc__c > ();
        if (Acc != null && Acc.aloc__r.size() > 0) {
            loc = Acc.aloc__r;
            system.debug('Account loc' + loc);
            if (loc.size() > 0) {
                locList.add(new SelectOption('', '--NONE--'));
                locList2.add(new SelectOption('', '--NONE--'));
                for (loc__c l: loc) {
                    /*/&& l.rpi__c==False*/
                    if (l.rpi__c == false) {
                        locList.add(new SelectOption(l.Loc__c, l.Loc__c));
                    }
                    locList2.add(new SelectOption(l.Loc__c, l.Loc__c));
                }
            }
        } else locflag = true;
    }

    private Boolean hasSanctions {
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
    private Boolean accesssOk {
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
        rq.STA__c = sta; /*/ system.debug('spouse name::' + rq.xspn__c);*/
        upsert rq; /*/update rq;*/
        if (reqItems != null) {
            System.debug('1req item size:>>>>> ' + reqItems.size()); /*/if(srv.uid__c=='223'&& reqItems.size()==1){// update doc required for Renewal Applications*/
            if (reqItems.size() == 1) {
                /*/ update doc required for Renewal Applications*/
                System.debug('req item size:>>>>> ' + reqItems.size() + ' ' + (reqItems.values())[0].id);
                rqItemDocLst = [Select id, rqc__c, Item_Status__c, lbl__c, mxAts__c, mnAts__c, reqDoc__c, reqItm__c, Req__c, reqAts__c, reqOr__c, ord__c, Tp__c, upOk__c from g_reqitemDoc__c where reqItm__c =: (reqItems.values())[0].id];
                for (g_reqitemDoc__c d: rqItemDocLst) {
                    if (d.ord__c == null || d.ord__c == 0) d.ord__c = 1;
                    else {
                        d.ord__c += 1;
                    }
                }
                update rqItemDocLst;
                System.debug('rqItemDocLst size :>>>>> ' + rqItemDocLst.size());
            }
        }
    }
    private Boolean cancelItms() {
        try {
            map < String, Id > mapSTA = new map < String, Id > ();
            for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: rq.srvc__c and cd__c = 'c']) {
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
        } catch (Exception e) {
            gu.AddErrorMsg(e.getStackTraceString());
            return false;
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
        system.debug('##########saveDraft#########################');
        system.debug(rq.STA__c);
        system.debug(rq.Acc__c);
        system.debug('#############saveDraft######################');
        String oldSTA = rq.STA__c;
        try {
            upsertR('Draft');
            if (isgu) return (new pagereference('/apex/grqich?id=' + rq.Id + '&empid=' + empid + '&enc=' + encid + '&sid=' + sid + '&pid=' + pid));
            else if (isIn5) {
                return null;
            } else return (new ApexPages.StandardController(rq)).edit(); /*// String nxtPage = ApexPages.currentPage().getParameters().get('nextPage'); //if(nxtPage!=null && nxtPage == 'grqins'){ rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false');return null;}else return (new ApexPages.StandardController(rq)).edit();*/
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
        system.debug('##########saveOpen#########################');
        system.debug('JJ check fields' + rq.xadh__c + 'second Value InsChk__c' + rq.InsChk__c + ' ### con__c: ' + rq.con__c);
        system.debug('xvn ::' + rq.xvn__c);
        system.debug('srv.uid__c ::' + srv.uid__c);
        String oldSTA = rq.STA__c;
        system.debug('to DOC >>/apex/grqup'); /*//tcopylist */
        try {
            if (md.isNew && !ispu) {
                getAcc();
            }
            if (srv.uid__c == '204' && srv.uid__c == '205' && hasSanctions) {
                return null;
            }
            if (srv.uid__c == '216') upsertR('Under Review');
            else upsertR('Open');
            rq = [select id, xcawp__c, xmloc__c, xtpa__c, AP__c, STA__c from g_req__c where id =: rq.id];
            String nxtPage = ApexPages.currentPage().getParameters().get('nextPage');
            if (srv.uid__c == '208' && !nD && !rq.xcawp__c && Acc.Legal_Framework__c != 'Freelancer' && (rq.xmloc__c || rq.xtpa__c == 0)) {
                
                rq.STA__c = 'Under Review';
                update rq;
                gu.AddSuccessMsg('Your request has been submitted successfully,');
                return new PageReference('/apex/grqSInfo?id=' + rq.Id);
            }
            system.debug('rq.AP__c::' + rq.AP__c + ' ;rq.xcawp__c::' + rq.xcawp__c + ';srv.uid__c::' + srv.uid__c);
            if ((srv.uid__c == '208') && !nD && (rq.AP__c == null || (rq.AP__c != null && rq.AP__c == 0))) {
                rq.STA__c = 'Open';
                update rq;
                nxtPage = 'grqpy';
            } /*// && rq.xcawp__c*/
            if (srv.uid__c == 'apt' && ispu) {
                nxtPage = 'grqup';
            } /* sh AccessPermit, skip items page for pu*/
            if (srv.uid__c == '065' && ispu) {
                nxtPage = 'grqpy';
            }
            if (srv.uid__c == gu.csStr('ParkingCancellation') || srv.uid__c == gu.csStr('ParkingDeact')) {
                if (processParking()) {
                    return new PageReference('/apex/spg?id=' + rq.Id + '&cn=' + srv.uid__c);
                } else {
                    nxtPage = 'grqpy';
                }
            }
            system.debug('nxtPage::' + nxtPage);
            if (nxtPage != null) {
                system.debug('nxtPage1::' + nxtPage);
                return (new pagereference('/apex/' + nxtPage + '?id=' + rq.Id + '&cn=' + srv.uid__c));
            }
            if (isgu) return (new pagereference('/apex/grqupmi?empid=' + empid + '&enc=' + encid + '&pid=' + pid + '&sid=' + sid + '&id=' + rq.Id));
            else return (new pagereference('/apex/grqup?id=' + rq.Id));
        } catch (DMLException exDML) {
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('**DML Exception:' + exDML.getDmlMessage(i));
                    if (ispu) {
                        gu.AddErrorMsg(Label.msgException);
                    } else {
                        gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'DML Exception: ' + exDML.getStackTraceString());
                    } /*/gu.AddErrorMsg(Label.msgException+'4');*/
                }
            }
            return null;
        } catch (exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            rq.STA__c = oldSTA;
            return null;
        }
    }
    public PageReference save() {
        try {
            system.debug('##########save#########################');
            if (srv.uid__c == '216' && rq.os__c == 'CCL Accepted') {
                upsertR(rq.STA__c);
                return (new pagereference('/apex/grqlspy?id=' + rq.Id));
            } else {
                upsertR(rq.STA__c);
                return (new ApexPages.StandardController(rq)).view();
            }
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
                }
                return (new ApexPages.StandardController(rq)).view();
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
        } /*add second id for M*/
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
                }
                return (new ApexPages.StandardController(rq)).view();
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
        } /* return null;*/
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
        /* if(rq.AOP__c>0){ gu.AddErrorMsg('Request has open payments. Please close the payments before proceeding.'); return null; } Savepoint sp = null;String oldSTA = rq.STA__c; try{ sp=Database.setSavePoint(); upsertR('Cancelled'); if(rq.AP__c>0){ if(!cancelItms()){ Database.rollback(sp); rq.STA__c = oldSTA; return null; } } else{ if(!cancelItms()){ Database.rollback(sp); rq.STA__c = oldSTA; return null; } } return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML){if(sp!=null){Database.rollback(sp);}for (Integer i = 0; i < exDML.getNumDml(); i++) {if( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException);}}rq.STA__c= oldSTA;return null;}catch(exception ex){if(sp!=null){Database.rollback(sp);}gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());rq.STA__c = oldSTA;return null;} */
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
    }
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
    }

    //ToDo : Handle in JS
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
    } /* parking cancellation and deactivation*/
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
    } /* Non RTA PAID/Additional parking ends */
    public PageReference addMembers() {
        if (rq.xadtx4__c != null && string.isNotBlank(rq.xadtx4__c)) {
            Map < string, g_srvcitm__c > srvItmMp = new Map < string, g_srvcitm__c > ();
            Member m = (Member) Json.deserialize(rq.xadtx4__c, Member.class);
            List < g_reqitem__c > tI = new List < g_reqitem__c > ();
            for (g_srvcitm__c i: [Select id, Name, cd__c, srvc__c, Tp__c, rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c, spChN__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id From Statuses__r where isDeleted = false and cd__c = 'rv'
                    limit 1) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__r.uid__c = '216']) {
                if (m.ctg == i.cd__c) {
                    tI.add(new g_reqitem__c(Name = i.Name, xcslt__c = m.salutation, xcfn__c = m.fname, xcmn__c = m.mname, xcln__c = m.lname, xcp__c = m.passportNo, xceml__c = m.email, xcnc__c = m.nationality, xrol__c = m.role, RQ__c = rq.Id, itm__c = i.Id, sta__c = i.Statuses__r[0].Id, itmtp__c = i.Tp__c, DscApp__c = i.DscApp__c, exp__c = false, KF__c = i.KF__c, scN__c = i.scN__c, xdcr__c = i.dcr__c, cN__c = i.cN__c, smN__c = i.smN__c, slaN__c = i.slaN__c, scXP__c = i.scXP__c, cXP__c = i.cXP__c, smXP__c = i.smXP__c, slaXP__c = i.slaXP__c, dc__c = i.dc__c, vsc__c = 0, TAX_CODE__c = i.TAX_CODE__c, TAX_TYPE__c = i.TAX_TYPE__c, extc__c = i.extc__c, TAXCODE_SC__c = i.TAXCODE_SC__c, extcsc__c = i.extcsc__c));
                }
            }
            if (tI != null && !tI.isEmpty()) insert tI;
        }
        return null;
    } /*Insurance for Renewal services */
    public PageReference getInsTp() {
        /*ToDo : use custom settings for UID*/
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
        } /* axs-2.0 get all active apt requests and display on the page*/
        lstActiveReq = [SELECT Id, Name, xcpid__c, xcped__c, xrap__c, prf__c from g_req__c where srvc__r.uid__c = 'apt'
            and id !=: rq.id and acc__c =: rq.acc__c and xcped__c > today
        ];
    }
    public PageReference paymentPage() {
        return (new pagereference('/apex/grqpymi??empid=TG1647&enc=1245652097735B7F37FE7D402B2C9B3CCC67292A&pid=00328000018PBLv&sid=a0L2000000YQVLDEA5'));
    }
    public Pagereference creditcatdPay() {
        gU.DEG_PrepareCall(200.00, 'AET20195fd');
        system.debug('After prepare call#####################################');
        return null;
    }
    public String jsonData {
        get;
        set;
    }
    public PageReference getSegments() {
        /*List<Segment__mdt> lstSegs= new List<Segment__mdt>(); lstSegs =[SELECT id, MasterLabel, Segment__c,Fees__c, SCap__c,qnty__c FROM Segment__mdt ];where park__c in ('D3','DIAC')  if(lstSegs.size()>0){  List<Segment> lstSegments = new List<Segment>(); for(Segment__mdt s :lstSegs){ Segment seg     = new Segment(); seg.Name        = s.Segment__c; seg.Quantity    = String.valueOf(s.qnty__c); seg.Fees        = String.valueOf(s.Fees__c); seg.shareCap    = String.valueOf(s.SCap__c); lstSegments.add(seg); } jsonData = JSON.serialize(lstSegments); System.debug('jsonData : ' + jsonData); jsonData = '[';Boolean isfirst = true; for(Segment__mdt seg :lstSegs){if(isfirst){jsonData +='{"Name":"'+ seg.Segment__c+'",'+'"Quantity":"'+seg.qnty__c+'",'+'"Fees":"'+seg.Fees__c+','+seg.SCap__c+'"}';isfirst = false;}else{jsonData +=',{"Name":"'+ seg.Segment__c+'",'+'"Quantity":"'+seg.qnty__c+'",'+'"Fees":"'+seg.Fees__c+','+seg.SCap__c+'"}';}}jsonData +=']'; }*/
        return null;
    }
    public String strDetails {
        set;
        get;
    }
    public PageReference getLeaseDetails() {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json'); /*request.setEndpoint('callout:CCRM_UAT/apexrest/accinfo'); request.setEndpoint('callout:CCRM/apexrest/accinfo');*/
        request.setEndpoint('callout:TECOM_QA/apexrest/accinfo');
        request.setHeader('accId', Acc.ccrm_sfid__c);
        request.setTimeout(90000);
        request.setMethod('GET');
        response = h.send(request);
        if (response.getStatusCode() == 200 && response.getBody() != null) {
            grqWsOnboard.Records rec = (grqWsOnboard.Records) json.deserialize(response.getBody(), grqWsOnboard.Records.class);
            if (rec != null && rec.Invoices != null && !rec.Invoices.isEmpty()) invoiceLst = rec.Invoices;
            system.debug('rec.quotes::' + rec.quotes);
            if (rec != null && rec.quotes != null && !rec.quotes.isEmpty()) {
                grqWsOnboard.QuoteInfo qinfo = grqWsOnboard.fetchLeaseDetails(rec.quotes, rq.id);
                system.debug('qinfo::' + qinfo);
                leaseList.add(qinfo);
            }
        }
        return null; /* List<UnitDetails> recs = (List<UnitDetails>)JSON.deserialize(strUnits,List<UnitDetails>.class);*/
    }
    public class Segment {
        public string Name {
            set;
            get;
        }
        public string Quantity {
            set;
            get;
        }
        public string Fees {
            set;
            get;
        }
        public string shareCap {
            set;
            get;
        }
    }
    public class Member {
        public string salutation;
        public string fname;
        public string lname;
        public string mname;
        public string email;
        public string mobile;
        public string role;
        public string nationality;
        public string passportNo;
        public string ctg;
    }
    public List < RequestItemWrapper > requestItemWrappers {
        get;
        set;
    }
    public String jsonrequestItemWrappers {
        get;
        set;
    } /*public String invoiceLstJson{get;set;}*/
    public void fetchRequestItems() {
        String AOAattName = 'AOA ' + rq.Name + '.pdf';
        String aoaAttId = '';
        List < Attachment > aoaAtt = [SELECT Id FROM Attachment WHERE Name LIKE: AOAattName AND ParentId =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        if (aoaAtt.size() > 0) {
            aoaAttId = aoaAtt[0].Id;
        }
        rqItemDocLst = new List < g_reqitemDoc__c > ();
        reqItems = new Map < Id, g_reqitem__c > ([SELECT Id, Name, xcslt__c, xcfn__c, xcmn__c, xcln__c, xcha__c, Passport_Record_Id__c, xrol__c, xcbd__c, xcp__c, xcpid__c, xcped__c, Service_Name__c, itmtp__c, System_Generated_Doc_Id__c, Customer_Uploaded_Doc_Id__c, xcnc__c, xceml__c, xcmob__c, xpsh__c, itmCd__c, RQ__r.Provisional_Issuance__c, (SELECT Id, Tp__c FROM itmsDocs__r WHERE Tp__c IN('RIC', 'AOA', 'MOA')), (SELECT Id, ParentId, Name FROM Attachments ORDER BY CreatedDate ASC) FROM g_reqitem__c WHERE RQ__c =: ApexPages.currentPage().getParameters().get('id')]);
        System.debug('req item size:>>>>> ' + reqItems.size());
        Map < Id, g_reqitemDoc__c > riDocs = new Map < Id, g_reqitemDoc__c > ([SELECT Id, ord__c, Tp__c, (SELECT Id FROM Attachments ORDER BY CreatedDate DESC) FROM g_reqitemDoc__c WHERE reqItm__c IN: reqItems.keyset() AND Tp__c IN('RIC', 'AOA', 'MOA') ORDER BY Tp__c ASC]);
        for (g_reqitem__c ri: reqItems.values()) {
            RequestItemWrapper riw = new RequestItemWrapper();
            riw.reqItem = ri;
            riw.systemGeneratedAOADocId = aoaAttId;
            Integer reqItemAttSize = ri.Attachments.size();
            if (ri.Attachments.size() > 0) {
                for (Attachment at: ri.Attachments) {
                    if (at.Name.contains('RIC')) riw.systemGeneratedRICDocId = at.Id; /*else if(at.Name.contains('AOA')) riw.systemGeneratedAOADocId = at.Id;*/
                }
            }
            if (ri.itmsDocs__r.size() > 0) {
                for (g_reqitemDoc__c rid: ri.itmsDocs__r) {
                    if (riDocs.get(rid.Id) != null && riDocs.get(rid.Id).Attachments.size() > 0) {
                        if (riDocs.get(rid.Id).Tp__c == 'RIC') riw.customerUploadedRICId = riDocs.get(rid.Id).Attachments[0].Id;
                        if (riDocs.get(rid.Id).Tp__c == 'AOA') riw.customerUploadedAOAId = riDocs.get(rid.Id).Attachments[0].Id;
                        if (riDocs.get(rid.Id).Tp__c == 'MOA') riw.customerUploadedMOAId = riDocs.get(rid.Id).Attachments[0].Id;
                    }
                }
            }
            requestItemWrappers.add(riw);
        }
        System.debug('wrapper:>>>>> ' + requestItemWrappers);
        jsonrequestItemWrappers = JSON.serialize(requestItemWrappers);
        System.debug('jsondata:>>>>> ' + jsonrequestItemWrappers); /*return requestItemWrappers;*/
    }
    public class RequestItemWrapper {
        public g_reqitem__c reqItem {
            get;
            set;
        }
        public String systemGeneratedDocId {
            get;
            set;
        }
        public String customerUploadedDocId {
            get;
            set;
        }
        public String customerUploadedRICId {
            get;
            set;
        }
        public String customerUploadedAOAId {
            get;
            set;
        }
        public String customerUploadedMOAId {
            get;
            set;
        }
        public String systemGeneratedRICDocId {
            get;
            set;
        }
        public String systemGeneratedAOADocId {
            get;
            set;
        }
        public String systemGeneratedMOADocId {
            get;
            set;
        } /*public Attachment attachment{get;set;} public RequestItemWrapper(g_reqitem__c req,String sysDocId,String custDocId) { this.reqItem = req; this.systemGeneratedDocId = sysDocId; this.customerUploadedDocId = custDocId; }*/
    } /* public List<SegAct__c>  lstSegments{get;set;}*/
    public List < Segments > lstSegments2 {
        get;
        set;
    }
    public List < DED_Activity__c > lstSegments3 {
        get;
        set;
    }
    public List < Segments > lstselectedSegs {
        get;
        set;
    }
    public String lstselectedSegsStr {
        get;
        set;
    }
    Set < String > setSegments = new set < String > ();
    public PageReference saveSegments() {
        lstselectedSegs = new List < Segments > ();
        setSegments = new set < String > (rq.xuvdet__c.split(';'));
        for (Segments s: lstSegments2) {
            if (setSegments.contains(s.rID) || s.segSelected == true) {
                /*( s.segSelected==true){ Segments ss = new Segments(s.rId,s.name,s.segment,s.activity,s.park,s.segSelected);*/
                lstselectedSegs.add(s);
            }
        }
        lstselectedSegsStr = JSON.serialize(lstselectedSegs);
        return null;
    }
    public PageReference getLstSegments() {
        /*   lstSegments = new List<SegAct__c>(); for(Integer i=0; i<5; i++){ SegAct__c s = new SegAct__c(name='test'+i,sSegment__c='test seg'+i,sActivity__c='Test Act'+i, sPark__c='DIC'); lstSegments.add(s); } lstSegments2 = new List<Segments>(); lstSegments3 = new List<DED_Activity__c>(); lstSegments3 = [SELECT id,Name,Activity__c,Activity_Description__c,Park__c,Segment__c,Segments_Description__c from DED_Activity__c where DDA_Enabled__c=true]; for(DED_Activity__c s : lstSegments3){  Segments ss = new Segments(s.id,s.Activity__c,s.Segment__c,s.Park__c,s.Segments_Description__c,s.Activity_Description__c,s.Alwd__c,s.fees__c,false); if(setSegments.contains(s.id)){ ss.segSelected = true; } lstSegments2.add(ss); } System.debug('#### lstSegments: '+ lstSegments2);*/
        return null;
    }
    public class Segments {
        public String name {
            get;
            set;
        }
        public String rID {
            get;
            set;
        }
        public String segment {
            get;
            set;
        }
        public String activity {
            get;
            set;
        }
        public String fee {
            get;
            set;
        }
        public String quanity {
            get;
            set;
        }
        public String park {
            get;
            set;
        }
        public String SegDesc {
            get;
            set;
        }
        public String ActivityDesc {
            get;
            set;
        }
        public Decimal allowedUnits {
            get;
            set;
        }
        public Decimal fees {
            get;
            set;
        }
        public Boolean segSelected {
            get;
            set;
        }
        public Segments(String tID, String tActivity, String tSegment, String tPark, String tSegDesc, String tActivityDesc, Decimal tAllowedUnits, Decimal tFees, Boolean tsegSelected) {
            rID = tID;
            activity = tActivity;
            segment = tSegment;
            ActivityDesc = tActivityDesc;
            SegDesc = tSegDesc;
            park = tPark;
            allowedUnits = tAllowedUnits;
            fees = tFees;
            segSelected = tsegSelected;
        }
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
    public List < SelectOption > getMartialStatus() {
        List < selectOption > options = new List < selectOption > ();
        options = getOptions('xcms__c');
        return options;
    }
    public List < String > getSpokenLanguages() {
        List < selectOption > options = new List < selectOption > ();
        options = getOptions('xclng__c');
        List < string > spokenLngList = new List < string > ();
        for (selectOption op: options) {
            spokenLngList.add(op.getValue());
        }
        return spokenLngList;
    }
    public List < String > getAvailableDocs() {
        List < selectOption > options = new List < selectOption > ();
        options = getOptions('xnld__c');
        List < string > docs = new List < string > ();
        for (selectOption op: options) {
            docs.add(op.getValue());
        }
        return docs;
    }
    public PageReference renderJs() {
        return null;
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
            'Iran' => 'xir',
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
            'Russian Federation' => 'xru',
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
            'Thailand' => 'xth',
            'Tunisia' => 'xtn',
            'Turkey' => 'xtr',
            'Turkmenistan' => 'xtm',
            'Uganda' => 'xug',
            'Ukraine' => 'xua',
            'Usbekistan' => 'xuz',
            'Venezuela' => 'xve',
            'Vietnam' => 'xvn'
        };
        countryOptions.add(new SelectOption('', '--None--'));
        for (String s: mapCC.keySet()) {
            countryOptions.add(new SelectOption(mapCC.get(s), s));
        }
        return countryOptions;
    } /* captcha image */
    public Boolean codeCheck {
        get;
        set;
    }
    public boolean noSRfg {
        get;
        set;
    }
    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';
    private static String secret = Label.CaptchaSecret;
    public static String TestResponse = 'System.HttpResponse[Status=OK, StatusCode=200]';
    public String sitekey {
        get {
            return Label.CaptchaSitekey;
        }
    }
    public String response {
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }

    public String getCPUDetails(String licenseNumber) {
        String alertDescription;
        System.debug('licenseNumber :' + licenseNumber);
        if (String.isNotBlank(licenseNumber)) {
            List < mdWrapper > mdList = new List < mdWrapper > ();
            lrCtlReq lrCtlReqAtt = new lrCtlReq();
            if (String.isNotBlank(licenseNumber)) {
                showCPUWarning = false;
                string jsonStr = '{"methodname":"getcompanyalerts", "data":{"licenseNum":"' + licenseNumber + '"}}';
                String responseBody = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStr);
                System.debug('responseBody getcompanyalerts ' + responseBody);
                if (String.isNotBlank(responseBody)) {
                    Map < String, Object > alertMap = (Map < String, Object > ) JSON.deserializeUntyped(responseBody);
                    List < Object > alertList = (List < Object > ) alertMap.get('ListAlerts');
                    system.debug('--alertList getcompanyalerts--' + alertList);
                    if (alertList != null && !alertList.isEmpty()) {
                        for (Object alertObj: alertList) {
                            Map < String, Object > alertDetails = (Map < String, Object > ) alertObj;
                            String alertType = (String) alertDetails.get('Type');
                            if (String.isNotBlank(alertType) && alertType == 'Customer Profile Update') {
                                alertDescription = (String) alertDetails.get('Description');
                                showCPUWarning = true;
                                system.debug('--showCPUWarning--' + showCPUWarning);
                            }
                        }
                    }
                }
            }
        }
        return alertDescription;
    }

    public PageReference updateRequestDetails() {
        List < g_reqitem__c > requestItems = new List < g_reqitem__c > ();
        List < ws_call__c > wsListToInsert = new List < ws_call__c > ();
        Map < String, Decimal > termTotals = new Map < String, Decimal > ();
        Map < String, grqWsOnboard.PaymentSchedules > pyterms = new Map < String, grqWsOnboard.PaymentSchedules > ();
        id hseItemId;
        PageReference pg = null;
        if (rq != null) {
            rq.xintp__c = selectedInsuranceType != null ? selectedInsuranceType : rq.xintp__c;
            if (String.isNotBlank(rq.xcddocs__c)) {
                redirectURL = '/lrqup?id=' + rq.id;
            }
            pg = new pagereference(redirectURL);
            if (!reqItems.isEmpty()) {
                for (g_reqitem__c ri: reqItems.values()) {
                    if (ri.itmCd__c == 'dr') {
                        hseItemId = ri.Id;
                    }
                }
                if (isDigitalSignChange == 'true' && rq.xaccbrand__c != null) {
                    String accMob = rq.Acc__r.Manager_Mobile__c;
                    accMob = accMob.replace('+971-', '').replace('0971', '').replace('971', '');
                    Map < String, String > digitalSignMap = new Map < String, String > {
                        'CLSPL' => rq.xaccbrand__c,
                        'CLSCC' => 'AE +971',
                        'CLSPH' => accMob
                    };
                    ws_call__c wsSign = new ws_call__c();
                    wsSign.rq_jsn__c = getRequestJSON('DigitalSignature', digitalSignMap, rq.rtacn__c);
                    wsSign.ws_typ__c = 'axsLeaseRenewal';
                    wsSign.mtd_nm__c = 'yardiWetSignatureUpdate';
                    wsSign.uid__c = rq.id + '-' + wsSign.mtd_nm__c + system.now();
                    wsSign.rq_itm__c = hseItemId;
                    wsSign.intsts__c = 'Ready for Integration';
                    wsListToInsert.add(wsSign);
                }
                if (isInsTypeChange == 'true' || isPolicyNumChange == 'true' || isPolicyComChange == 'true' || isExpireDateChange == 'true') {
                    ws_call__c wsUpdateDigital = new ws_call__c();
                    wsUpdateDigital.rq_jsn__c = rq.xadtx4__c;
                    wsUpdateDigital.ws_typ__c = 'axsLeaseRenewal';
                    wsUpdateDigital.mtd_nm__c = 'yardiInsuarceDetailsUpdate';
                    wsUpdateDigital.uid__c = rq.id + '-ec-' + wsUpdateDigital.mtd_nm__c + system.now();
                    wsUpdateDigital.rq_itm__c = hseItemId;
                    wsUpdateDigital.intsts__c = 'Ready for Integration';
                    wsListToInsert.add(wsUpdateDigital);
                }
            }
            Map < String, Object > selSchedule = new Map < String, Object > ();
            if (rq.xadtx1__c != null) {
                Map < String, Object > jsonMap = (Map < String, Object > ) JSON.deserializeUntyped(rq.xadtx1__c);
                Set < String > selectedTerms = new Set < String > ();
                if (jsonMap.containsKey('paymentSchedule')) {
                    Map < String, Object > paymentSchedule = (Map < String, Object > ) jsonMap.get('paymentSchedule');
                    for (String termKey: paymentSchedule.keySet()) {
                        List < Object > schedules = (List < Object > ) paymentSchedule.get(termKey);
                        Decimal termTotal = 0;
                        for (Object schObj: schedules) {
                            Map < String, Object > sch = (Map < String, Object > ) schObj;
                            if (sch.containsKey('isSelected') && (Boolean) sch.get('isSelected')) {
                                termTotal += sch.containsKey('totalAmountIncludingVat') ? Decimal.valueOf(sch.get('totalAmountIncludingVat').toString()) : 0;
                                selectedTerms.add(termKey);
                                if (termKey == '10' || termKey == '11' || termKey == '12') {
                                    selSchedule.put('p' + termKey, sch);
                                } else {
                                    selSchedule.put('pt' + termKey, sch);
                                }
                            }
                        }
                        if (termTotal > 0) {
                            termTotals.put('pt' + termKey, termTotal);
                        }
                    }
                }
                List < String > ptList = new List < String > ();
                for (String term: selectedTerms) {
                    if (term == '10' || term == '11' || term == '12') {
                        ptList.add('p' + term);
                    } else {
                        ptList.add('pt' + term);
                    }
                }
                rq.xadh__c = String.join(ptList, ';');
            }
            update rq;
            List < g_reqitem__c > reqItems = [select id, itmCd__c, cN__c from g_reqitem__c where RQ__c =: rq.Id AND itmCd__c LIKE 'p%'];
            if (!reqItems.isEmpty()) {
                for (g_reqitem__c item: reqItems) {
                    if (selSchedule.containsKey(item.itmCd__c)) {
                        Map < String, Object > sch = (Map < String, Object > ) selSchedule.get(item.itmCd__c);
                        item.scN__c = sch.containsKey('billedAmount') ? Decimal.valueOf(sch.get('billedAmount').toString()) : 0;
                        item.vsc__c = sch.containsKey('vatAmount') ? Decimal.valueOf(sch.get('vatAmount').toString()) : 0;
                        item.pcd__c = sch.get('propertyCode').toString();
                        item.tcd__c = sch.get('tenantCode').toString();
                        item.ccd__c = sch.get('chargeCode').toString();
                        item.nt__c = ' (Charge Period:' + Date.valueOf(sch.get('chargeFrom').toString()).format() + ' to ' + Date.valueOf(sch.get('chargeTo').toString()).format() + ' )';
                    }
                }
                update reqItems;
            }
            updateItemSTA();
            if (!wsListToInsert.isEmpty()) {
                insert wsListToInsert;
            }
        }
        return pg;
    }

    public String getRequestJSON(String jsonType, Map < String, String > jsonValue, String tCode) {
        if (jsonType == 'DigitalSignature') {
            List < gTYardiInvCreation.YardiLRRequest > oneToManyData = new List < gTYardiInvCreation.YardiLRRequest > ();
            gTYardiInvCreation.YardiLRRequest entry = new gTYardiInvCreation.YardiLRRequest();
            entry.Table_Name = 'COMMLEASEBUT29';
            entry.Entity_Record_Code = tCode;
            for (String key: jsonValue.keySet()) {
                gTYardiInvCreation.FieldWrapper fw = new gTYardiInvCreation.FieldWrapper();
                fw.Field_Name = key;
                fw.Field_Value = jsonValue.get(key);
                entry.Fields.add(fw);
            }
            oneToManyData.add(entry);
            Map < String, Object > finalPayload = new Map < String, Object > ();
            finalPayload.put('OneToManyData', oneToManyData);
            return JSON.serialize(finalPayload);
        } else if (jsonType == 'InsuranceDetailsUpdate') {
            List < gTYardiInvCreation.YardiLRRequest > oneToManyData = new List < gTYardiInvCreation.YardiLRRequest > ();
            gTYardiInvCreation.YardiLRRequest entry = new gTYardiInvCreation.YardiLRRequest();
            entry.Table_Name = 'COMMLEASEBUT_InsInfo';
            entry.Entity_Record_Code = tCode;
            for (String key: jsonValue.keySet()) {
                gTYardiInvCreation.FieldWrapper fw = new gTYardiInvCreation.FieldWrapper();
                fw.Field_Name = key;
                fw.Field_Value = jsonValue.get(key);
                entry.Fields.add(fw);
            }
            oneToManyData.add(entry);
            return JSON.serialize(new Map < String, Object > {
                'OneToManyData' => oneToManyData
            });
        }
        return null;
    }

    public void updateItemSTA() {
        list < g_reqitem__c > Itms = new list < g_reqitem__c > ();
        boolean isReqCompleted = false;
        List < g_reqitem__c > itmIds = [SELECT Id, RQ__c, sta__c, sta__r.Next_Status__c, sta__r.Next_Status__r.rqSTA__c, itm__c, itm__r.cd__c from g_reqitem__c where RQ__c =: rq.id and sta__r.isfn__c = true and isdeleted = false order by createdDate desc];
        if (!itmIds.isEmpty() && itmIds.size() > 0) {
            for (g_reqitem__c i: itmIds) {
                i.sta__c = i.sta__r.Next_Status__c;
                if ((i.sta__r.Next_Status__c != null && i.sta__r.Next_Status__r.rqSTA__c == 'Completed') || (i.itm__r.cd__c == 'ai' && i.sta__r.Next_Status__c != null)) {
                    rq.STA__c = i.sta__r.Next_Status__r.rqSTA__c;
                    isReqCompleted = true;
                }
                Itms.add(i);
            }
        }
        if (!Itms.isEmpty() && Itms.size() > 0) {
            update Itms;
        }
    }

    public PageReference invokeCourier() {
        string itmCd = 'rd';
        update rq;
        List < g_reqitem__c > courBk = [SELECT Id, RQ__c, sta__c, sta__r.Next_Status__c, sta__r.Courier_Stage__c, sta__r.cd__c, Name, xcasc__c, exp__c from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c =: itmCd order by createdDate desc limit 1];
        if (courBk != null && !courBk.isEmpty() && courBk[0].sta__r.Courier_Stage__c == 'Collection') {
            XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
            cour.courierBooking(courBk[0], rq, false, '');
            g_reqitem__c udcourBkItm = new g_reqitem__c(id = courBk[0].id);
            udcourBkItm.sta__c = courBk[0].sta__r.Next_Status__c;
            update udcourBkItm;
        }
        return null;
    }

    public PageReference calprem() {
        Policy policy;
        dtstr = dtstr.replaceALL('-', '');
        dtstr = dtstr.replaceAll(':', '');
        if (bCallAdnic) {
            try {
                Map < String, String > reqCreatMap = new Map < String, String > ();
                Integer z = Integer.valueOf(Math.floor(Math.random() * (6) + 1));
                Map < String, String > SnV = gctlInsHelper.getSnV(z);
                String strSALT = SnV.get('reqSALT');
                String strIV = SnV.get('reqIV');
                Boolean isPolicyExp = true;
                if (rq.Con__c != null && rq.Con__r.xped__c != null) {
                    isPolicyExp = isPolicyExpired(rq.Con__r.xped__c);
                }
                if (isPolicyExp && rq.srvc__r.uid__c == '212') {
                    gu.AddErrorMsg('Policy Expired, please cancel this applicaion and apply for new policy');
                    return null;
                }
                String methodToCall = 'CalPrem';
                if (Label.ADNIC_CheckForRenewal == 'Y') {
                    methodToCall = (!isPolicyExp && (rq.srvc__r.uid__c == '212' || String.isNotBlank(rq.Con__r.xpno__c))) ? 'CalPrmRen' : 'CalPrem';
                }
                reqCreatMap = gctlInsHelper.crtReq(methodToCall, strSALT, strIV, gctlInsHelper.encryptStr(getJson(), z), 'POST');
                Map < String, String > mapCAlPrm = gctlInsHelper.calPremium(reqCreatMap);
                String decryptResponse = gctlInsHelper.decryptStr(mapCAlPrm.get('respBody'), z);
                gctlInsHelper.Insurance dptData = (gctlInsHelper.Insurance) JSON.deserialize(decryptResponse, gctlInsHelper.Insurance.class);
                List < gctlInsHelper.ErrorInfo > errMsg = dptData.ErrorInfo;
                errorMsg = '';
                Set < String > errorCodes = new Set < String > {
                    'VDB001',
                    'VDB013',
                    'VDB027',
                    'VDB028',
                    'VDB029',
                    'VDB030',
                    'VDB031'
                };
                if (errMsg.size() > 0) {
                    for (gctlInsHelper.ErrorInfo err: errMsg) {
                        if (err != null && (errorCodes.Contains(err.errorCode) || err.errorMsg.contains('CONTACT ADNIC TEAM'))) {
                            errorMsg = errorMsg + err.ErrorMsg + ';';
                        }
                    }
                    gu.AddErrorMsg(errorMsg);
                    return null;
                } else {
                    discount = dptData.PremiumInfo.DiscountAmt;
                    if (String.isNotBlank(discount)) {
                        discount = discount.replace('- ', '');
                    } else {
                        discount = '0';
                    }
                    Decimal grs = Decimal.ValueOf(dptData.PremiumInfo.GrossPremiumAmt) + Decimal.ValueOf(dptData.PremiumInfo.BasmahFund) + Decimal.ValueOf(discount);
                    grsPrem = String.valueOf(grs);
                    vatAmt = dptData.PremiumInfo.VATAmt;
                    fnlPrem = dptData.PremiumInfo.FinalPremiumAmt;
                    policy = new policy();
                    policy.pType = rq.xintp__c;
                    policy.pRefNo = dtstr.deleteWhitespace();
                    policy.pQuotationNo = dptData.QuoteInfo.QuotationNo;
                    policy.pGrossPremiumAmt = Decimal.ValueOf(dptData.PremiumInfo.GrossPremiumAmt);
                    policy.pBasmahFund = Decimal.ValueOf(dptData.PremiumInfo.BasmahFund);
                    policy.pVATAmt = Decimal.ValueOf(dptData.PremiumInfo.VATAmt);
                    policy.pFinalPremiumAmt = Decimal.ValueOf(dptData.PremiumInfo.FinalPremiumAmt);
                    policy.pDiscountAmt = String.isNotBlank(dptData.PremiumInfo.DiscountAmt) ? Decimal.ValueOf(dptData.PremiumInfo.DiscountAmt) : 0;
                    insPolicies.put(policy.pType, policy);
                    rq.xuvdet__c = JSON.serialize(insPolicies);
                    IF(rq.InsChk__c == true) {
                        rq.xtpa__c = Decimal.ValueOf(fnlPrem);
                        rq.xinsv__c = Decimal.ValueOf(vatAmt);
                        rq.xqno__c = dptData.QuoteInfo.QuotationNo;
                        rq.xirfn__c = dtstr.deleteWhitespace();
                    }
                    System.debug('grsPrem : ' + grsPrem + ' vatAmt : ' + vatAmt + ' fnlPrem : ' + fnlPrem);
                }
            } catch (Exception ex) {
                gu.AddErrorMsg('Technical Error, please try after some time or contact axs backoffice');
                System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
                return null;
            }
        }
        return null;
    }

    public String getJson() {
        Boolean isDependent = (rqTp.equalsIgnoreCase('nwb') || rqTp.equalsIgnoreCase('chldNew') || rqTp.equalsIgnoreCase('chldRnwl') || (rqTp.equalsIgnoreCase('spoNew') || rqTp.equalsIgnoreCase('spoRnwl')) || (rqTp.equalsIgnoreCase('stln') && (rq.Con__r.rol__c == 'Spouse' || rq.Con__r.rol__c == 'Child')));
        System.debug('#### isDependent : ' + isDependent);
        dtstr = dtstr.replaceALL('-', '');
        dtstr = dtstr.replaceAll(':', '');
        gctlInsHelper.Insurance ins = new gctlInsHelper.Insurance();
        gctlInsHelper.SponsorInfo spInfo = new gctlInsHelper.SponsorInfo();
        gctlInsHelper.QuoteInfo qInfo = new gctlInsHelper.QuoteInfo();
        gctlInsHelper.InsuredInfo insInfo = new gctlInsHelper.InsuredInfo();
        List < gctlInsHelper.InsuredInfo > lstInsInfo = new List < gctlInsHelper.InsuredInfo > ();
        acnt = [SELECT id, name, Phone, vetemp__c, Email__c, lc__c From Account where Id =: acnt.Id];
        String mob = '';
        spInfo.MobileNo = (String.isNotBlank(rq.xcmob__c) && rq.xcmob__c.length() >= 10) ? rq.xcmob__c.right(9) : rq.xcmob__c;
        if (String.isBlank(spInfo.MobileNo) && String.isNotBlank(rq.rmob__c)) {
            mob = rq.rmob__c.trim();
        }
        if (String.isBlank(spInfo.MobileNo) && String.isNotBlank(acnt.Phone)) {
            mob = acnt.Phone.trim();
        }
        if (String.isNotBlank(mob)) {
            mob = mob.replaceAll(' ', '');
            mob = mob.replaceAll('-', '');
            if (mob.contains('+971')) {
                mob = mob.replace('+971', '0');
            }
            spInfo.MobileNo = (mob.length() >= 10) ? mob.right(9) : mob;
        }
        spInfo.EmailId = String.isNotBlank(rq.xceml__c) ? rq.xceml__c : UserInfo.getUserEmail();
        spInfo.TradeLicenseNo = acnt.lc__c;
        if (isDependent) {
            system.debug('<isDependent> rq.Spon__r.xpmi__c' + rq.Spr__r.xpmi__c + ' :: idtxt__c :: ' + rq.Spr__r.idtxt__c + ' %%% rq.xard__c : ' + rq.xard__c);
            if (rq.xard__c || rq.Spr__c != null) {
                spInfo.Name = rq.Spr__r.Name;
                if (string.isNotBlank(rq.Spr__r.xpmi__c)) {
                    spInfo.IsADNICMember = 'YES';
                    spInfo.SponsorMedPolicyNo = rq.Spr__r.xpmi__c;
                } else {
                    spInfo.IsADNICMember = 'NO';
                    spInfo.SponsorPFNo = rq.Spr__r.idtxt__c;
                }
                spInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.Spr__r.Birthdate), '-');
            } else {
                spInfo.Name = rq.Con__r.Spon__r.Name;
                if (string.isNotBlank(rq.Con__r.Spon__r.xpmi__c)) {
                    spInfo.IsADNICMember = 'YES';
                    spInfo.SponsorMedPolicyNo = rq.Con__r.Spon__r.xpmi__c;
                } else {
                    spInfo.IsADNICMember = 'NO';
                    spInfo.SponsorPFNo = rq.Con__r.Spon__r.idtxt__c;
                }
                spInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.Con__r.Spon__r.Birthdate), '-');
            }
        } else {
            spInfo.Name = acnt.Name;
        }
        insInfo.Name = rq.xcslt__c + ' ' + rq.xcfn__c + ' ' + rq.xcln__c;
        insInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.xcbd__c), '-');
        insInfo.PregnantStatus = String.isBlank(rq.xpgs__c) ? 'NO' : gctlInsHelper.upperCase(rq.xpgs__c);
        insInfo.MaritalStatus = (String.isBlank(rq.xcms__c)) ? 'SINGLE' : gctlInsHelper.upperCase(rq.xcms__c);
        insInfo.Gender = (rq.xcslt__c == 'Mr.') ? 'MALE' : 'FEMALE';
        qInfo.VisaEmirate = 'Dubai';
        if (rqTp == 'new') {
            System.debug('rq : ' + rq);
            qInfo.SalaryBand = (rq.xcmbs__c + rq.xcma__c + rq.xcmta__c + rq.xcmoa__c) > 4000 ? 'ABOVE 4000' : 'BELOW 4000';
        } else if (rqTp == 'stln') {
            qInfo.SalaryBand = 'BELOW 4000';
        } else {
            qInfo.SalaryBand = 'BELOW 4000';
        }
        insInfo.PreviouslyCovered = 'NO';
        insInfo.Relationship = (rqTp.equalsIgnoreCase('stunew') || (rq.Con__c != null && rq.Con__r.rol__c == 'Student')) ? 'ST' : (rqTp.equalsIgnoreCase('chldNew') || rqTp.equalsIgnoreCase('nwb') || rqTp.equalsIgnoreCase('chldRnwl') || (rq.Con__c != null && rq.Con__r.rol__c == 'Child')) ? 'C' : (rqTp.equalsIgnoreCase('spoNew') || rqTp.equalsIgnoreCase('spoRnwl') || (rq.Con__c != null && rq.Con__r.rol__c == 'Spouse')) ? 'S' : 'E';
        lstInsInfo.add(insInfo);
        qInfo.PlanType = (rq.xintp__c == 'B1asic' && qInfo.SalaryBand == 'BELOW 4000') ? 'EBP' : rq.xintp__c.ToUpperCase();
        if (rqTp == 'stunew' || (rq.Con__c != null && rq.Con__r.rol__c == 'Student')) {
            qInfo.PlanType = 'STUDENTS';
        }
        qInfo.PolicyType = (isDependent) ? 'F' : 'E';
        qInfo.NoOfPersonsToInsure = '1';
        qInfo.disclaimer = 'YES';
        qInfo.IncludingSponsor = 'NO';
        qInfo.RefNo = dtstr.deleteWhitespace();
        System.debug('rq.srvc__r.uid__c : ' + rq.srvc__r.uid__c);
        if (!test.isRunningTest()) {
            if (rq.srvc__r.uid__c == '212' || String.isNotBlank(rq.Con__r.xpno__c)) {
                String fName = (String.isNotBlank(rq.xcfn__c)) ? rq.xcfn__c.replaceAll(' ', '') : '';
                fName = fName.replaceAll('[^a-zA-Z0-9\\s+]', '');
                qInfo.RefNo = 'AXS' + rq.Con__r.xpno__c + fName + Date.Today().Year();
                System.debug(' qInfo.RefNo : ' + qInfo.RefNo);
                qInfo.MemberId = rq.Con__r.xpno__c;
            }
        }
        dtstr = qInfo.RefNo;
        System.debug('qInfo.MemberId ::: ' + qInfo.MemberId);
        gctlInsHelper.PartnerInfo pi = new gctlInsHelper.PartnerInfo();
        Map < String, adnicWS__c > adnicValues = adnicWS__c.getAll();
        pi.PartnerId = adnicValues.get('Json Creation').PartnerID__c;
        ins.SponsorInfo = spInfo;
        ins.InsuredInfo = lstInsInfo;
        ins.QuoteInfo = qInfo;
        ins.PartnerInfo = pi;
        String jReq = JSON.serialize(ins);
        System.debug('<jReq> : ' + jReq);
        return jReq;
    }

    public static Boolean isPolicyExpired(Date ExpDate) {
        if (ExpDate == null) {
            return true;
        }
        Date dToday = Date.today();
        return ExpDate < dToday;
    }

    public class RqWrapper {
        public List < UnitWrapper > units {
            get;
            set;
        }
        public Map < String, List < PaymentScheduleWrapper >> paymentSchedule {
            get;
            set;
        }
    }

    public class UnitWrapper {
        public String status {
            get;
            set;
        }
        public String productName {
            get;
            set;
        }
        public String name {
            get;
            set;
        }
        public Boolean isActive {
            get;
            set;
        }
        public String floor {
            get;
            set;
        }
        public String buildingName {
            get;
            set;
        }
        public Decimal area {
            get;
            set;
        }
    }

    public class PaymentScheduleWrapper {
        public String yearNo {
            get;
            set;
        }
        public Decimal vatAmount {
            get;
            set;
        }
        public Integer totalDays {
            get;
            set;
        }
        public Decimal totalAmountIncludingVat {
            get;
            set;
        }
        public String term {
            get;
            set;
        }
        public String tenantCode {
            get;
            set;
        }
        public String schName {
            get;
            set;
        }
        public String quote {
            get;
            set;
        }
        public String propertyCode {
            get;
            set;
        }
        public String paySc {
            get;
            set;
        }
        public String Id {
            get;
            set;
        }
        public Date dueDate {
            get;
            set;
        }
        public String description {
            get;
            set;
        }
        public Date chargeTo {
            get;
            set;
        }
        public Date chargeFrom {
            get;
            set;
        }
        public String chargeCode {
            get;
            set;
        }
        public Decimal billedAmt {
            get;
            set;
        }
        public Decimal billedAmount {
            get;
            set;
        }
        public Boolean isSelected {
            get;
            set;
        }
    }

    public class Policy {
        public String pType, pRefNo, pQuotationNo;
        public Decimal pGrossPremiumAmt, pBasmahFund, pVATAmt, pDiscountAmt;
        public Decimal pFinalPremiumAmt {
            get;
            set;
        }
    }
}
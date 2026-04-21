public with sharing class gctlAxs2 {

    public User U {get;set;}
    public Account A {get;set;}
    public Boolean pgHide {get;set;}
    public Boolean ispu {get;set;}
    public String rejectionReason {get;set;}

    public string docForName{get;set;}
    public string sid {get;set;}
    public string pid {get;set;}
    public string formation{get;set;}
    public string indTyp{get;set;}

    public List<grqWsDccaGetService.Records>  tecomLeaseList {get;set;}
    public List<grqWsDccaGetService.Records>  d3Rec {get;set;}
    public String orclId {get;set;}

    public  map<String, String > finalAgreeLoc{get;set;}
    public  map<String, String > LeaseNameMap{get;set;}
    public  map<String, Decimal > LeaseAmtMap{get;set;}
    public  List<segmentWraper> segments{get;set;}
    public  List<segmentWraper> pyTerms{get;set;}
    public List<loc__c> locLst  {get;set;}
    public decimal DueAmt{get;set;}
    public decimal DueAmt2{get;set;}
    public String pydueDesc {get; set;}

    public string rqid{get;set;}
    public string getRqid() {return rqid;}

    public g_Req__c rq1{get;set;}
    public g_Req__c rq ;
    public g_Req__c getRq() {return rq;}
    public g_reqitem__c ritm {set;get;}

    public void setRq(g_Req__c input) {
        system.debug('2 input >>>'+input);
        if (this.rq == null || this.rq.id != input.id || this.rq.STA__c != input.STA__c ) {
            this.rq = input;this.rqid = rq.id;
            //  this.rqid = 'a0Ep0000005d1wCEAQ';//draft
            // this.rqid = 'a0Ep00000057KNDEA2';//open
            ldLeaseCmp(); addSegment4mRQ();
        }
    }

    public string segJson;

    public String getSegJson() {
        return segJson;
    }

    public void setSegJson(String input) {
        system.debug('1 input >>>'+input);

        if (this.segJson != input) {
            this.segJson = input;
            addSegment();
        }
    }

    public list<selectoption> Pick1;
    public list<selectoption> getPick1() {
        list<selectoption> pk1 = new list<selectoption>();
        schema.DescribeFieldResult fd = g_Req__c.xcnm__c.getdescribe();
        list<schema.picklistentry> pc = fd.getpicklistvalues();
        for (schema.picklistentry f: pc) {
            pk1.add(new selectoption(f.getlabel(), f.getvalue()));
        }
        return pk1;
    }

    public list<selectoption> Pick2;

    public list<selectoption> getPick2() {
        list<selectoption> pk2 = new list<selectoption>();
        schema.DescribeFieldResult fd = g_Req__c.xfb__c.getdescribe();
        list<schema.picklistentry> pc = fd.getpicklistvalues();
        for (schema.picklistentry f: pc) {
            pk2.add(new selectoption(f.getlabel(), f.getvalue()));
        }
        return pk2;
    }

    public gctlAxs2(String x) {}

    public gctlAxs2() {
        ritm = new g_reqitem__c();
        init();
        ldAlmostDone();
       // docForName ='Passport copy';
        docForName ='Certificate of Incorporation of Corporate Members (Original or Notarized Copy)';
    }

    private void init() {
        try {
            DueAmt =0;DueAmt2=0; pydueDesc = 'Approximate payment';
            segments = new List<segmentWraper>();

            loadData(false);

        }catch (exception ex) {
            gu.AddErrorMsg(ex);
            System.debug('@@ Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            pgHide = true;
        }
    }

    private void loadData(Boolean isnw) {
        String url = Apexpages.currentPage().getURL();

        U = [select Id, FirstName, LastName, accountid, LastPasswordChangeDate, LastLoginDate,
            contact.account.clt__c, contact.Photo_ID__c, contact.account.id, contact.account.on__c ,
            contact.account.ccrm_sfid__c, contact.account.onar__c , contact.account.Website,
            contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c ,
            contact.account.vetst__c, contact.account.vespstx__c , contact.account.vbtst__c,
            contact.account.vev__c, contact.account.mxPortalUsers__c, contact.account.Name, contact.account.Email__c,
            contact.account.lPrk__c, contact.account.Building_Name__c, contact.account.xcublg__c,
            contact.account.Location__c, contact.account.Location_Cluster__c, contact.account.xcuzn__c ,
            contact.account.Phone, contact.account.Type, contact.account.Prk__c, contact.account.adb__c,
            contact.account.info__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.bgc__c,
            contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c, contact.account.speabsc__c,
            contact.account.vctst__c, contact.account.sncNt__c, contact.account.vbvv__c, contact.account.lcidt1__c,
            contact.account.ec__c, contact.account.ecidt__c, contact.account.lctp__c,    contact.account.ecedt__c,
            contact.account.lcedt__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.Legal_Framework__c,
            contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.lcsta__c,
            contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.lcrndt__c,
            contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.licexdt__c,
            contact.account.licIdt__c,   contact.account.bgsnc__c, contact.account.bgsncnt__c,
            contact.account.snc__c, contact.account.voep__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c,
            contact.account.rpa__c, contact.account.os__c, contact.account.adob__c , contact.account.adx__c,
            contact.account.adc__c  from User where id =: UserInfo.getUserId() limit 1];

        A = U.contact.account;
        system.debug('A>>>'+ A);

        /*if (U.contact.account.ORACLE_PARTY_ID__c != null) {
            orclId = U.contact.account.ORACLE_PARTY_ID__c;
            system.debug('orclId>>> '+orclId);
            loadD3Loc(orclId);
        }*/

        orclId = String.isNotBlank(U.contact.account.ORACLE_PARTY_ID__c) ? U.contact.account.ORACLE_PARTY_ID__c : u.contact.account.ccrm_sfid__c;
        loadD3Loc(orclId);
        if (String.isNotBlank(U.contact.account.clt__c) && U.contact.account.clt__c == 'PMS Lease') {
            loadPMSLoc();
        }

    }

    public void ldAlmostDone() {
        system.debug('######################ldAlmostDone#############################');
        //id=a0Ep0000005711KEAQ
        pid ='nnnnn';
        rqid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
       // ldLeaseCmp();
    }
        public void loadPMSLoc() {
            rqid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
            system.debug('rqid:' + rqid);
            if (String.isNotBlank(rqid)) {
                List < g_req__c > rqLst = [select id, xpmsle__c, activitiesFL__c from g_req__c where id =: rqid];
                if (rqLst != null && !rqLst.isEmpty() && rqLst[0].xpmsle__c && String.isNotBlank(rqLst[0].activitiesFL__c)) {
                    List < PMSDataWrapper.ContractInformation > contractlist = (List < PMSDataWrapper.ContractInformation > ) JSON.deserialize(rqLst[0].activitiesFL__c,
                        List < PMSDataWrapper.ContractInformation > .class);
                    dispUnits = new List < Unit > ();
                    PMSDataWrapper.ContractInformation contract = contractlist[0];
                    List < PMSDataWrapper.PropertyInformationList > propertyList = contract.propertyInformationList;
                    if (propertyList != null && !propertyList.isEmpty()) {
                        decimal propertyArea = 0;
                        for (PMSDataWrapper.PropertyInformationList property: propertyList) {
                            Unit u = new Unit();
                            u.ProductName = property.propertyType;
                            u.UnitNumber = property.unitNumber;
                            /*u.floor = pr.floor;
                            */ u.Category = property.propertyType;
                            propertyArea = (String.isNotBlank(property.Area)) ? decimal.valueOf(property.Area) : 0.0;
                            u.OppArea = String.valueOf((propertyArea * 10.7639).setScale(2, RoundingMode.HALF_UP));
                            u.buildingName = contract.buildingName.englishName;
                            /*u.park=rec.BusinessPark;
                            */ dispUnits.add(u);
                        }
                    }
                }
            }
        }

    // Pass Account Party Id as parameter
    public  List<grqWsDccaGetService.Records> loadD3Loc( String accParyId) {
        d3Rec =new   List<grqWsDccaGetService.Records> ();
        String jsonBody;
        //ResponseData res = new ResponseData();
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        //request.setEndpoint('callout:CCRM/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId='+accParyId);
        request.setEndpoint('callout:'+Label.CRM_Instance+'/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId='+accParyId);
        request.setMethod('GET');
        request.setTimeout(120000);
        response = h.send(request);
        System.debug('####response.getBody()::: ' + response.getBody());
        if (response.getStatusCode() == 200) {
            grqWsDccaGetService resLease = (grqWsDccaGetService) JSON.deserialize( response.getBody(), grqWsDccaGetService.class);
            System.debug('####resLease::: ' + resLease);
            if (resLease != null && resLease.ResponseData != null && resLease.ResponseData.Records != null) {
                //d3Rec= resLease.ResponseData.Records;
                for (grqWsDccaGetService.Records rc : resLease.ResponseData.Records) {
                    if (rc.StageName != 'Cancelled' && rc.StageName != 'Renewed' && rc.StageName != 'Terminated' && rc.StageName != 'Modified')
                        d3Rec.add(rc);
                }
            }
        }
        system.debug('JJJ response.getBody()  '+response.getBody());
        system.debug('JJJ response  '+d3Rec);

        finalAgreeLoc= new   map<String, String>();
        LeaseNameMap= new   map<String, String>();
        LeaseAmtMap= new   map<String, Decimal>();
        dispUnits = new List<Unit>();
        Map<String, Unit>  prod=new Map<String, Unit>();
        //for (grqWsDccaGetService.Records rec: d3Rec) {if (rec.Products != null && rec.Products.size()>0) {for (grqWsDccaGetService.Products pr :  rec.Products) {finalAgreeLoc.put(rec.AgNo, pr.UnitNumber+', '+pr.ProductName); }}else{finalAgreeLoc.put(rec.AgNo, 'NA');}}

        for (grqWsDccaGetService.Records rec: d3Rec) {
            if (rec.Products != null && rec.Products.size()>0) {
                for (grqWsDccaGetService.Products pr :  rec.Products) {
                    LeaseNameMap.put(rec.AgNo, pr.ProductName); //rec.Products[0].ProductName
                    Unit u = new Unit();
                    u.ProductName= pr.ProductName;
                    u.UnitNumber = pr.UnitNumber;
                    u.floor = pr.floor;
                    u.Category = rec.Category;
                    u.OppArea = String.valueOf(rec.Area);
                    u.buildingName=rec.Building;
                    u.park=rec.BusinessPark;
                    if (prod.isEmpty()) {
                        prod.put(pr.ProductName, u);
                    }else if (!prod.containsKey(pr.ProductName)) {prod.put(pr.ProductName, u);}

                    dispUnits.add(u);
                }
                dispUnits=prod.values();
            }else{LeaseNameMap.put(rec.AgNo, 'NA');}
        }

        system.debug('d3Rec>>> '+d3Rec);
        system.debug('finalAgreeLoc>>> '+finalAgreeLoc);
        system.debug('LeaseNameMap>>> '+LeaseNameMap);

        /*
        for (grqWsDccaGetService.Records rec: d3Rec) {
            if (rec.PaymentSchedules[0].Amount != null)
                LeaseAmtMap.put(rec.AgNo, Decimal.valueOf(rec.PaymentSchedules[0].Amount));
        }
        */

        return d3Rec;
    }

    public List<Unit> dispUnits {get;set;}
    public class Unit {
        public String LineItemName{get;set;}
        public String ProductName{get;set;}
        public String UnitNumber{get;set;}
        public String buildingName{get;set;}
        public String floor{get;set;}
        public String Category{get;set;}
        public String SubCategory{get;set;}
        public String OppArea{get;set;}
        public String park{get;set;}
    }

    @testVisible
    private void loadAccountLocation() {
        try{

            tecomLeaseList = new  List<grqWsDccaGetService.Records>();
            List<grqWsDccaGetService.Records>  d3LeaseList = new  List<grqWsDccaGetService.Records>();

            if (A != null && A.ORACLE_PARTY_ID__c != null ) {
               // tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);
                system.debug('##############tecomLeaseList###################');
                system.debug(tecomLeaseList);
                d3LeaseList = grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c);
            }
            system.debug('######################d3LeaseList#############################');

            if (d3LeaseList != null && !d3LeaseList.isEmpty() && d3LeaseList.size()>0) {tecomLeaseList.addAll(d3LeaseList);}

            tecomLeaseList.addAll(tecomLeaseList);
            tecomLeaseList.addAll(tecomLeaseList);
            system.debug('JJJJJ tecomLeaseList11'+tecomLeaseList);

            finalAgreeLoc= new   map<String, String>();
            LeaseNameMap= new   map<String, String>();
            LeaseAmtMap= new   map<String, Decimal>();

            for (grqWsDccaGetService.Records rec: tecomLeaseList) { finalAgreeLoc.put(rec.AgNo, rec.Products[0].UnitNumber+', '+rec.Products[0].ProductName); }

            for (grqWsDccaGetService.Records rec: tecomLeaseList) { LeaseNameMap.put(rec.AgNo, rec.Products[0].ProductName); }

            for (grqWsDccaGetService.Records rec: tecomLeaseList) { LeaseAmtMap.put(rec.AgNo, Decimal.valueOf(rec.PaymentSchedules[0].Amount)); }

            system.debug('JJJJJ LeaseNameMap'+LeaseNameMap);

            locLst = new List<loc__c>();
            system.debug('ll A>>>'+ A);
            if (a != null && A.Id != null)
                for (loc__c lc: [select Id, Name, acc__c, active__c, act__c, agrno__c, arBldg__c,
                    arbu__c, arflr__c, aroffno__c, asf__c, Bldg__c, bu__c, cat__c, flr__c, IsActive__c,
                    Is_frzn__c, IsMain__c, isregof__c, IsSub__c, ls_end__c, ls_std__c, lstyp__c, Loc__c,
                    mu__c, offno__c, pyear__c, plt__c, pltarb__c, rpi__c, rqno__c, subcat__c, su__c from loc__c where acc__c =: A.Id]) {
                    locLst.add(lc);
                }
        }catch (Exception ex) {
            system.debug('loadAccountLocation Ex >>>'+ ex);
        }
        system.debug('locLst >>> '+ locLst);
    }

    /* need to revist this method srini*/
    private void ldLeaseCmp() {
        system.debug('######################ldLeaseCmp START#############################');
        //rqid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        if (rqid != null && rqid!='') {
           // rq = [select Acc__r.Prk__c, Id, Service__c, STA__c, ap__C, acc__r.lctp__c, xvtyp__c, aop__C, srvc__c, xfb__c, srvc__r.stg__c, srvc__r.stg__r.reqq__c, os__c, xadtx2__c, xadtx1__c, xvbr__c, xcnm__c from g_Req__c where id =:rqid ]; // Teporarily Added by JP
            //rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + String.escapeSingleQuotes(rqid) + '\' and isDeleted = false');
            system.debug('rq.os__c>>>'+ rq.os__c);
           //system.debug('itm::'+rq.Items__r);

            for (g_reqitem__c i:[select id, ccrmid__c, itm__c, itm__r.cd__c, sta__c from g_reqitem__c where rq__c=:rqid]) {if (i.itm__r.cd__c == 'ob') {ritm = i; } }

           // rq1  = rq.clone(false, false, false, false);
            //Account acCloneCopy = ac.clone(true, true, false, false);

            //formation = rq.xfb__c;
            //indTyp = rq.xcnm__c;
        }
        system.debug('rq>>>'+ rq);
        system.debug('######################ldLeaseCmp END#############################');

    }

    public void updateOffer() {
        string stsCd = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('itmCd'));
        System.debug('stsCd:: ' + String.escapeSingleQuotes(stsCd) + '  --ritm.itm__c:: '+ ritm.itm__c);
        String rjreason = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('rejectionReason'));

           if (stsCd=='cr') {
            rq.os__c = 'LCL Rereview';
            rq.rj_reason__c = rjreason;
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update rq;
            }
            //delete [select id, ccrmid__c, itm__c, itm__r.cd__c, sta__c from g_reqitem__c where rq__c=:rqid and  ccrmid__c=:ritm.ccrmid__c and itm__r.cd__c != 'ob'];
        }
        else{
            system.debug('adhoc::'+rq.xadh__c);
            if (String.isNotBlank(rq.xadh__c) && !((rq.xadh__c).contains('ec;'))) {
               system.debug('adhoc1::'+rq.xadh__c);
               rq.xadh__c = (String.isNotBlank(rq.xadh__c) && rq.xvtyp__c != 'DED') ? (rq.xadh__c + 'ec;') : (rq.xvtyp__c != 'DED') ? 'ec;' : rq.xadh__c;
               rq.os__c = 'CCL Accepted';
               if (Schema.sObjectType.g_req__c.isUpdateable()) {
                   update rq;
               }
            }
        }
        String stsid = GDRFAUtil.statusId(stsCd, ritm.itm__c);
        ritm.sta__c = stsid;
        update ritm;

    }

    public PageReference formationUpdate() {
        //rq.xfb__c= formation;
        system.debug('In lease rq.xfb__c>>'+ formation);
        return null;
    }

    public PageReference indTypUpdate() {
        //rq.xcnm__c = indTyp;
        system.debug('In lease rq.xcnm__c>>'+ indTyp);
        return null;
    }

    public PageReference editFromLeaseCmp() {
        if (rq != null) {
            g_Req__c rq2  = rq;
            rq2.xfb__c= formation;
            rq2.xcnm__c = indTyp;
            system.debug('In lease rq2.xfb__c>>'+ rq2.xfb__c);
            system.debug('In lease rq2.xcnm__c>>'+ rq2.xcnm__c);

            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update rq2;
            }
            system.debug('lease rq>>'+ rq2);
        }

        return null;
    }

    public PageReference addSegment() {
        system.debug('2 segJson >>>'+segJson);
        try{
            if (segJson != null &&  segJson!='' && segJson!='[]') {
                if (rq.os__c=='segments') {
                    segments =(List<segmentWraper>)JSON.deserialize(segJson, List<segmentWraper>.class);
                    system.debug('2 segments >>>'+segments);
                }else{

                    filterPys();
                    if (String.isBlank(rq.xadtx1__c) || !rq.xadtx1__c.contains('chargeFrom')) {   //if (pyTerms == null || pyTerms.size()==0) {
                        rq.xadtx2__c = rq.xadtx2__c.replaceAll('&amp;amp;', '&');  rq.xadtx2__c = rq.xadtx2__c.replaceAll('&amp;', '&');
                        segments =(List<segmentWraper>)JSON.deserialize(rq.xadtx2__c, List<segmentWraper>.class);
                    }
                }
            }else{

                segments = null;
                system.debug('3 segments >>>'+segments);
            }

            calculateDueAmt();
        }catch (Exception ex) {
            system.debug('Exp >>> '+ex);
        }
        /*if (segments == null || segments.size()<=0) {
//ldLeaseCmp();
addSegment4mRQ();
}*/
        return null;
    }

    void filterPys() {

        map<String, String> mapTandP = new Map<String, String>();
        pyTerms = new List<segmentWraper>();
        segments = new List<segmentWraper>();

        if (String.isNotBlank(rq.xadtx1__c) && rq.xadtx1__c.contains('chargeFrom')) {
            pydueDesc = 'Payment due';
            List<segmentWraper> pySch = (List<segmentWraper>)JSON.deserialize(rq.xadtx1__c, List<segmentWraper>.class);

            System.debug('pySch :: ' + pySch);
            if (pySch != null && pySch.size()>0) {
                for (segmentWraper s : pySch) {
                    if (s.name != null) /*MS 1.1*/
                    {
                        if (!mapTandP.containsKey(s.name)) {
                            mapTandP.put(s.name, '0');
                        }
                        Decimal pr = Decimal.valueOf(mapTandP.get(s.name)) + Decimal.valueOf(s.totalPrice);
                        mapTandP.put(s.name, ''+pr);
                    }
                }
            }

            System.debug('mapTandP :: ' + mapTandP.keyset());
            DueAmt2=0;
            for (String s :  mapTandP.keyset()) {
                segmentWraper sw = new segmentWraper(); sw.name = s; sw.totalPrice = mapTandP.get(s);
                if (!s.contains('Lease Fees') || (s.contains('Lease Fees') && s =='Lease Fees - Term 1')) {
                    segments.add(sw);
                }else{
                    pyTerms.add(sw);
                    DueAmt2 += Decimal.valueOf(sw.totalPrice);
                }
            }

        }
        system.debug('DueAmt2::'+DueAmt2);
    }

    //get segment Json from Request
    public void addSegment4mRQ() {
        if (rq != null && rq.xadtx2__c != null && rq.xadtx2__c!='') {
            rq.xadtx2__c = rq.xadtx2__c.replaceAll('&amp;amp;', '&');  rq.xadtx2__c = rq.xadtx2__c.replaceAll('&amp;', '&');
            filterPys();

            if (String.isBlank(rq.xadtx1__c) || !rq.xadtx1__c.contains('chargeFrom')) {     //if (pyTerms == null || pyTerms.size()==0) {
                segments =(List<segmentWraper>)JSON.deserialize(rq.xadtx2__c, List<segmentWraper>.class);
            }

        }else{
            segments = null;
        }
        calculateDueAmt();
    }

    public void calculateDueAmt() {
        DueAmt =0;
        system.debug('segments >>>'+ segments);

        if (segments != null && segments.size()>0) {
           if (rq.xvtyp__c != 'DED' && rq.parCat__c != 'Land' && (String.isBlank(rq.xadtx1__c) || !rq.xadtx1__c.contains('Registration Fees')) ) {
                 List<String> rgDetails = Label.Onboarding_RgFee.split(':');
                    segmentWraper rf  = new segmentWraper();
                    rf.name = rgDetails[0];
                    rf.price = rgDetails[1];
                    rf.totalPrice = rgDetails[1];
                    rf.SegActivities = new List<SegActivity>();
                    segments.add(rf);
             }
 if (rq.xvtyp__c != 'DED' && rq.parCat__c != 'Land' && (rq.srvc__r.uid__c != '322' || (rq.srvc__r.uid__c == '322' && String.isNotBlank(rq.xadh__c) && rq.xadh__c.contains('ec;')))) {
     segmentWraper ec = new segmentWraper();
                List<String> ecDetails = Label.Onboarding_EC.split(':');
                ec.name = ecDetails[0];

                if (String.isBlank(rq.xadtx1__c) || !rq.xadtx1__c.contains('chargeFrom')) {
                    ec.price = ecDetails[1];
                }else{
                    ec.totalPrice = ecDetails[1];
                }
                ec.SegActivities = new List<SegActivity>();
                segments.add(ec);
            }

            for (segmentWraper sw : segments) {
                system.debug('sw.totalPrice >>>'+ sw.price);
                if (String.isBlank(rq.xadtx1__c) || !rq.xadtx1__c.contains('chargeFrom')) {     //if (pyTerms == null || pyTerms.size()==0) {
                    DueAmt = DueAmt+ Decimal.valueOf(sw.price);
                }else{
                     DueAmt = DueAmt+ Decimal.valueOf(sw.totalPrice);
                }
            }
            system.debug('DueAmt >>>'+ DueAmt);
        }

    }

    class SegActivity{
        public String id{get;set;}
        public String name{get;set;}
        public String price{get;set;}
        public String channel{get;set;}
        public String title{get;set;}
    }

    class segmentWraper{
        public string name{get;set;}
        public string id{get;set;}
        public String price{get;set;}
        public String totalPrice{get;set;}
        public List<SegActivity> SegActivities{get;set;}
    }

}
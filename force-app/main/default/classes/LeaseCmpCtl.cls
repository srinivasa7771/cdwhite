public class LeaseCmpCtl {
    public User U {
        get;
        set;
    }
    public Account A {
        get;
        set;
    }
    public Boolean pgHide {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }
    public String licpriceMap {
        set;
        get;
    }
    public string docForName {
        get;
        set;
    }
    public string sid {
        get;
        set;
    }
    public string pid {
        get;
        set;
    }
    public string formation {
        get;
        set;
    }
    public string indTyp {
        get;
        set;
    }
    public String pMap {
        get;
        set;
    }
    public List < grqWsDccaGetService.Records > tecomLeaseList {
        get;
        set;
    }
    public List < grqWsDccaGetService.Records > d3Rec {
        get;
        set;
    }
    public String orclId {
        get;
        set;
    }
    public map < String, Integer > priceMap {
        get;
        set;
    }
    public map < String, String > finalAgreeLoc {
        get;
        set;
    }
    public List < UnitInfo > unitList {
        get;
        set;
    }
    public map < String, String > LeaseNameMap {
        get;
        set;
    }
    public map < String, Decimal > LeaseAmtMap {
        get;
        set;
    }
    public List < segmentWraper > segments {
        get;
        set;
    }
    public List < loc__c > locLst {
        get;
        set;
    }
    public decimal DueAmt {
        get;
        set;
    }
    public string rqid {
        get;
        set;
    }
    public string getRqid() {
        return rqid;
    }
    public g_Req__c rq1 {
        get;
        set;
    }
    public g_Req__c rq;
    public g_Req__c getRq() {
        return rq;
    }
    public g_reqitem__c ritm {
        set;
        get;
    }
    public void setRq(g_Req__c input) {

        system.debug('2 input >>>' + input);
        this.rq = input;
        loadAccountLocation();

        if (this.rq == null || this.rq.id != input.id || this.rq.STA__c != input.STA__c) {
            this.rq = input;
            this.rqid = rq.id;
            /*//  this.rqid = 'a0Ep0000005d1wCEAQ';//draft
            // this.rqid = 'a0Ep00000057KNDEA2';//open*/
            //ldLeaseCmp();
            /*//  addSegment4mRQ(); */
            // loadAccountLocation();
        }
    }


    public string segJson;
    public Map < String, String > mapAct {
        get;
        set;
    }
    public String getSegJson() {
        return segJson;
    }
    public void setSegJson(String input) {
        system.debug('1 input >>>' + input);

        if (this.segJson != input) {
            this.segJson = input;
            addSegment();
        }
    }

    public list < selectoption > Pick1;
    public list < selectoption > getPick1() {
        list < selectoption > pk1 = new list < selectoption > ();
        schema.DescribeFieldResult fd = g_Req__c.xcnm__c.getdescribe();
        list < schema.picklistentry > pc = fd.getpicklistvalues();
        for (schema.picklistentry f: pc) {
            pk1.add(new selectoption(f.getlabel(), f.getvalue()));
        }
        return pk1;
    }

    public list < selectoption > Pick2;
    public list < selectoption > getPick2() {
        list < selectoption > pk2 = new list < selectoption > ();
        schema.DescribeFieldResult fd = g_Req__c.xfb__c.getdescribe();
        list < schema.picklistentry > pc = fd.getpicklistvalues();
        for (schema.picklistentry f: pc) {
            pk2.add(new selectoption(f.getlabel(), f.getvalue()));
        }
        return pk2;
    }

    public LeaseCmpCtl(String x) {}
    public LeaseCmpCtl() {
        ritm = new g_reqitem__c();
        init();
        ldAlmostDone();

        /*// docForName ='Passport copy'; */
        docForName = 'Certificate of Incorporation of Corporate Members (Original or Notarized Copy)';
    }

    private void init() {
        try {
            DueAmt = 0;
            loadData(false);
        } catch (exception ex) {
            gu.AddErrorMsg(ex);
            System.debug('@@ Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            pgHide = true;
        }
    }

    private void loadData(Boolean isnw) {
        String url = Apexpages.currentPage().getURL();
        U = [select Id, FirstName, LastName, accountid, LastPasswordChangeDate, LastLoginDate, contact.Photo_ID__c, contact.account.id, contact.account.on__c, contact.account.onar__c, contact.account.Website, contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c, contact.account.vetst__c, contact.account.vespstx__c, contact.account.vbtst__c, contact.account.vev__c, contact.account.mxPortalUsers__c, contact.account.Name, contact.account.Email__c, contact.account.lPrk__c, contact.account.Building_Name__c, contact.account.xcublg__c, contact.account.Location__c, contact.account.Location_Cluster__c, contact.account.xcuzn__c, contact.account.Phone, contact.account.Type, contact.account.Prk__c, contact.account.adb__c, contact.account.info__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.bgc__c, contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c, contact.account.speabsc__c, contact.account.vctst__c, contact.account.sncNt__c, contact.account.vbvv__c, contact.account.lcidt1__c, contact.account.ec__c, contact.account.ecidt__c, contact.account.lctp__c, contact.account.ecedt__c, contact.account.lcedt__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.Legal_Framework__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.lcsta__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.lcrndt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.licexdt__c, contact.account.licIdt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.voep__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c, contact.account.rpa__c, contact.account.os__c, contact.account.adob__c, contact.account.adx__c, contact.account.adc__c from User where id =: UserInfo.getUserId() limit 1];
        A = U.contact.account;
        system.debug('A>>>' + A);
        if (U.contact.account.ORACLE_PARTY_ID__c != null) {
            orclId = U.contact.account.ORACLE_PARTY_ID__c;
            system.debug('orclId>>> ' + orclId); /*//loadD3Loc(orclId); //loadD3Loc('83790');  */ /*loadAccountLocation();*/
        }
    }


    public void ldAlmostDone() {
        system.debug('######################ldAlmostDone#############################'); /*//id=a0Ep0000005711KEAQ */
        pid = 'nnnnn';
        rqid = ApexPages.currentPage().getParameters().get('id');
        ldLeaseCmp();
    }

    /*// Pass Account Party Id as parameter */
    public List < grqWsDccaGetService.Records > loadD3Loc(String accParyId) {
        d3Rec = new List < grqWsDccaGetService.Records > ();
        String jsonBody; /*//ResponseData res = new ResponseData(); */
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse(); /*//request.setEndpoint('callout:CCRM/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId='+accParyId); */
        request.setEndpoint('callout:D3_NC/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId=' + accParyId);
        request.setMethod('GET');
        request.setTimeout(120000);
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            grqWsDccaGetService resLease = (grqWsDccaGetService) JSON.deserialize(response.getBody(), grqWsDccaGetService.class);
            System.debug('####resLease::: ' + resLease);
            System.debug('####resLease.ResponseData::: ' + resLease.ResponseData);
            if (resLease != null && resLease.ResponseData != null && resLease.ResponseData.Records != null) {
                /*//d3Rec= resLease.ResponseData.Records; */
                for (grqWsDccaGetService.Records rc: resLease.ResponseData.Records) {
                    if (rc.StageName != 'Cancelled' && rc.StageName != 'Renewed' && rc.StageName != 'Terminated' && rc.StageName != 'Modified') d3Rec.add(rc);
                }
            }
        }
        system.debug('JJJ response.getBody()  ' + response.getBody());
        system.debug('JJJ response  ' + d3Rec);
        finalAgreeLoc = new map < String, String > ();
        LeaseNameMap = new map < String, String > ();
        LeaseAmtMap = new map < String, Decimal > ();
        for (grqWsDccaGetService.Records rec: d3Rec) {
            if (rec.Products != null && rec.Products.size() > 0) {
                finalAgreeLoc.put(rec.AgNo, rec.Products[0].UnitNumber + ',' + rec.Products[0].ProductName);
            } else {
                finalAgreeLoc.put(rec.AgNo, 'NA');
            }
        }
        for (grqWsDccaGetService.Records rec: d3Rec) {
            if (rec.Products != null && rec.Products.size() > 0) {
                LeaseNameMap.put(rec.AgNo, rec.Products[0].ProductName);
            } else {
                LeaseNameMap.put(rec.AgNo, 'NA');
            }
        }
        system.debug('d3Rec>>> ' + d3Rec);
        system.debug('finalAgreeLoc>>> ' + finalAgreeLoc);
        system.debug('LeaseNameMap>>> ' + LeaseNameMap); /* for (grqWsDccaGetService.Records rec: d3Rec) { if(rec.PaymentSchedules[0].Amount !=null) LeaseAmtMap.put(rec.AgNo,Decimal.valueOf(rec.PaymentSchedules[0].Amount)); } */
        return d3Rec;
    }


    private void loadAccountLocation() {
        try {
            system.debug('ORACLE_PARTY_ID__c:' + A.ORACLE_PARTY_ID__c);
            system.debug('rq.xvnum__c:' + rq.xvnum__c);
            system.debug('rq.xpmsle__c:' + rq.xpmsle__c);
            system.debug('rq.xadtx2__c::' + rq.xadtx2__c);
            tecomLeaseList = new List < grqWsDccaGetService.Records > ();
            unitList = new List < UnitInfo > ();
            LeaseNameMap = new map < String, String > ();
            List < grqWsDccaGetService.Records > d3LeaseList = new List < grqWsDccaGetService.Records > ();
            if (String.isNotBlank(rq.xvnum__c) && rq.xpmsle__c && String.isNotBlank(rq.xadtx2__c)) {
                List < PMSDataWrapper.ContractInformation > ejariContractList = (List < PMSDataWrapper.ContractInformation > ) JSON.deserialize(rq.xadtx2__c, List < PMSDataWrapper.ContractInformation > .class);
                for (PMSDataWrapper.ContractInformation c: ejariContractList) {
                    List < grqWsDccaGetService.Units > ejariUnitList = new List < grqWsDccaGetService.Units > ();
                    Decimal ejariLeaseArea = 0.0;
                    grqWsDccaGetService.Records rec = new grqWsDccaGetService.Records();
                    rec.AgNo = c.contractNumber;
                    rec.ContractStartDate = (String.isNotBlank(c.startDate)) ? grqWsDccaGetService.formatEjariDt(c.startDate) : c.startDate;
                    rec.ContractEnddate = (String.isNotBlank(c.endDate)) ? grqWsDccaGetService.formatEjariDt(c.endDate) : c.endDate;
                    if (String.isNotBlank(c.ContractNumber) && c.propertyInformationList != null && !c.propertyInformationList.isEmpty()) {
                        for (PMSDataWrapper.PropertyInformationList p: c.propertyInformationList) {
                            grqWsDccaGetService.Units u = new grqWsDccaGetService.Units();
                            UnitInfo uinfo = new UnitInfo();
                            u.UnitNoEnglish = p.unitNumber;
                            u.BuildingName = c.buildingName.englishName;
                            rec.Category = p.propertyType;
                            ejariUnitList.add(u);
                            uinfo.UnitNumber = u.UnitNoEnglish;
                            uinfo.ProductName = u.BuildingName;
                            uinfo.ContractStartDate = (String.isNotBlank(c.startDate)) ? grqWsDccaGetService.formatEjariDt(c.startDate) : c.startDate;
                            uinfo.ContractEndDate = (String.isNotBlank(c.endDate)) ? grqWsDccaGetService.formatEjariDt(c.endDate) : c.endDate;
                            uinfo.AgNo = c.contractNumber;
                            Decimal unitAreaSqm = String.isnotBlank(p.Area) ? decimal.valueOf(p.Area) : 0.0;
                            uinfo.UnitArea = (unitAreaSqm * 10.7639).setScale(2, RoundingMode.HALF_UP);
                            if (String.isNotBlank(p.Area)) {
                                ejariLeaseArea += decimal.valueOf(p.Area);
                            }
                            unitList.add(uinfo); /*u.BusinessPark = */
                        }
                        ejariLeaseArea = (ejariLeaseArea * 10.7639).setScale(2, RoundingMode.HALF_UP);
                        rec.OppArea = String.valueOf(ejariLeaseArea); /*rq.xsvn__c;*/
                        rec.Units = ejariUnitList;
                    }
                    tecomLeaseList.add(rec);
                    system.debug('rec Agno:' + rec.AgNo + ' :unitno:' + rec.Units[0].UnitNoEnglish);
                    LeaseNameMap.put(rec.AgNo, rec.Units[0].UnitNoEnglish);
                }
            }
            if (A != null && A.ORACLE_PARTY_ID__c != null) {
                /*tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);*/
                system.debug('##############tecomLeaseList###################'); /*system.debug(tecomLeaseList);*/
                d3LeaseList = grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c);
            }
            system.debug('######################d3LeaseList#############################');
            if (d3LeaseList != null && !d3LeaseList.isEmpty() && d3LeaseList.size() > 0) {
                /*tecomLeaseList.addAll(d3LeaseList);*/
                for (grqWsDccaGetService.Records c: d3LeaseList) {
                    List < grqWsDccaGetService.Units > crmUnitList = new List < grqWsDccaGetService.Units > ();
                    List < String > crmUnitUidLst = new List < String > ();
                    String status = (String.isNotblank(c.Status) ? c.Status : c.ContractStatusReason);
                    boolean stsFlg = false;
                    if (status != null && (status == 'Active' || status == 'Lease Signed' || status == 'Modification Activation' || status == 'Contraction Activation' || status == 'Contraction Activation' || status == 'LA sent for Signoff' || status == 'Expansion Activation' || status == 'Original Lease Activation' || status == 'Renewal Activation' || status == 'Customer sign' || status == 'Customer signed' || status == 'Tecom Sign' || status == 'Tecom Signed' || status == 'Ready for Activation' || status == 'Tecom Sign' || status == 'Tecom Signed' || status == 'Ready for Activation' || status.contains('Collected by BP') || status.contains('Signed by BP') || status == 'LA is signed off' || status == 'LA is ready to activated' || status == 'LA activated' || status == 'Signed LA received' || status.contains('Counter Signed') || status.contains('Ready for Activation') || status.contains('Modification In Progress') || status.contains('Renewal In Progress') || status.contains('Expansion In Progress') || status.contains('Termination in progress'))) {
                        stsFlg = true;
                    }
                    if (stsFlg && (String.isNotblank(c.AgNo) || (String.isNotblank(c.ContractNumber) && String.isBlank(rq.xvnum__c)))) {
                        Decimal crmLeaseArea = 0.0;
                        grqWsDccaGetService.Records rec = new grqWsDccaGetService.Records();
                        rec.AgNo = (String.isNotBlank(c.ContractNumber) ? c.ContractNumber : c.AgNo);
                        rec.ContractStartDate = (String.isNotBlank(c.ContractStartDate)) ? grqWsDccaGetService.formatDt(c.ContractStartDate) : c.ContractStartDate;
                        rec.ContractEnddate = (String.isNotBlank(c.ContractEndDate)) ? grqWsDccaGetService.formatDt(c.ContractEndDate) : c.ContractEndDate;
                        if (c.Products != null && !c.Products.isEmpty()) {
                            for (grqWsDccaGetService.Products p: c.Products) {
                                grqWsDccaGetService.Units u = new grqWsDccaGetService.Units();
                                UnitInfo uinfo = new UnitInfo();
                                u.UnitNoEnglish = (String.isNotBlank(c.ContractNumber) ? p.ProductName : p.unitNumber);
                                if (String.isNotBlank(c.BuildingName)) u.BuildingName = c.BuildingName;
                                else if (String.isNotBlank(p.ProductName) && p.ProductName.contains('-')) {
                                    u.BuildingName = p.ProductName.split('-')[1];
                                }
                                rec.Category = c.Category;
                                uinfo.UnitNumber = u.UnitNoEnglish;
                                uinfo.ProductName = u.BuildingName;
                                uinfo.ContractStartDate = (String.isNotBlank(c.ContractStartDate)) ? grqWsDccaGetService.formatDt(c.ContractStartDate) : c.ContractStartDate;
                                uinfo.ContractEndDate = (String.isNotBlank(c.ContractEndDate)) ? grqWsDccaGetService.formatDt(c.ContractEndDate) : c.ContractEndDate;
                                uinfo.AgNo = (String.isNotBlank(c.ContractNumber) ? c.ContractNumber : c.AgNo);
                                uinfo.UnitArea = (p.UnitArea != null) ? p.UnitArea : 0;
                                if (!crmUnitUidLst.contains(u.UnitNoEnglish + '' + uinfo.AgNo)) {
                                    unitList.add(uinfo);
                                    crmUnitList.add(u);
                                    crmUnitUidLst.add(u.UnitNoEnglish + '' + uinfo.AgNo);
                                } /*u.BusinessPark =*/
                            } /*crmLeaseArea = String.isNotBlank(c.OppArea) ? decimal.valueOf(c.OppArea) : c.TotalSize;*/
                            crmLeaseArea = (c.Area != null) ? c.Area : c.TotalSize;
                            rec.OppArea = String.valueOf(crmLeaseArea); /*rq.xsvn__c;*/
                            rec.Units = crmUnitList;
                        }
                        tecomLeaseList.add(rec);
                        LeaseNameMap.put(rec.AgNo, rec.Units[0].UnitNoEnglish);
                    }
                }
            } /*//tecomLeaseList.addAll(tecomLeaseList); // tecomLeaseList.addAll(tecomLeaseList); */
            system.debug('JJJJJ tecomLeaseList11' + tecomLeaseList);
            system.debug('JJJJJ unitList11' + unitList);
            finalAgreeLoc = new map < String, String > ();
            LeaseAmtMap = new map < String, Decimal > (); /* for (grqWsDccaGetService.Records rec: tecomLeaseList) { List < grqWsDccaGetService.Products > prdList = rec.Products; if (String.isNotBlank(rec.ContractStartDate) && rec.ContractStartDate.contains('-')) rec.ContractStartDate = grqWsDccaGetService.formatDt(rec.ContractStartDate); if (String.isNotBlank(rec.ContractEndDate) && rec.ContractEndDate.contains('-'))  rec.ContractEndDate = grqWsDccaGetService.formatDt(rec.ContractEndDate); for (grqWsDccaGetService.Products prd: prdList) { UnitInfo u = new UnitInfo(); u.UnitNumber = prd.UnitNumber; if(String.isNotBlank(rec.ContractNumber)) u.AgNo = rec.ContractNumber; else u.AgNo = prd.UnitNumber; u.ProductName = prd.ProductName; u.ContractStartDate = rec.ContractStartDate; u.ContractEndDate = rec.ContractEndDate; unitList.add(u); if (finalAgreeLoc.containsKey(rec.AgNo)) { String uno = finalAgreeLoc.get(rec.AgNo); finalAgreeLoc.put(rec.AgNo, uno + '-' + prd.UnitNumber); } else { finalAgreeLoc.put(rec.AgNo, prd.UnitNumber); }  } } */ /*//finalAgreeLoc.put(rec.AgNo, rec.Products[0].UnitNumber+'-'+rec.Products[(rec.Products).size()-1].UnitNumber); */ /*for (grqWsDccaGetService.Records rec: tecomLeaseList) { */ /* if(String.isNotBlank(rec.ContractNumber)) LeaseNameMap.put(rec.ContractNumber, rec.Products[0].ProductName); else*/ /* LeaseNameMap.put(rec.AgNo, rec.Products[0].ProductName); */ /* } */ /* for (grqWsDccaGetService.Records rec: tecomLeaseList) { LeaseAmtMap.put(rec.AgNo, Decimal.valueOf(rec.PaymentSchedules[0].Amount)); } system.debug('JJJJJ LeaseNameMap' + LeaseNameMap); locLst = new List < loc__c > (); system.debug('ll A>>>' + A); if (a != null && A.Id != null) for (loc__c lc: [select Id, Name, acc__c, active__c, act__c, agrno__c, arBldg__c, arbu__c, arflr__c, aroffno__c, asf__c, Bldg__c, bu__c, cat__c, flr__c, IsActive__c, Is_frzn__c, IsMain__c, isregof__c, IsSub__c, ls_end__c, ls_std__c, lstyp__c, Loc__c, mu__c, offno__c, pyear__c, plt__c, pltarb__c, rpi__c, rqno__c, subcat__c, su__c from loc__c where acc__c =: A.Id]) { locLst.add(lc); }*/
        } catch (Exception ex) {
            system.debug('loadAccountLocation Ex >>>' + ex.getStackTraceString());
        }
        system.debug('locLst >>> ' + locLst);
    }

    private void ldLeaseCmp() {
        system.debug('######################ldLeaseCmp START#############################'); /*//rqid=ApexPages.currentPage().getParameters().get('id'); */
        if (rqid != null && rqid != '') {
            rq = [select Id, Service__c, STA__c, srvc__c, xfb__c, srvc__r.stg__c, srvc__r.stg__r.reqq__c, os__c, xadtx2__c, xvbr__c, xcnm__c, xtpa__c from g_Req__c where id =: rqid]; /*/ Teporarily Added by JP */ /*//rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rqid + '\' and isDeleted = false'); */
            system.debug('rq.os__c>>>' + rq.os__c); /*//system.debug('itm::'+rq.Items__r); */
            for (g_reqitem__c i: [select id, ccrmid__c, itm__c, itm__r.cd__c, sta__c from g_reqitem__c where rq__c =: rqid]) {
                if (i.itm__r.cd__c == 'ob') ritm = i;
            }
            rq1 = rq.clone(false, false, false, false); /*//Account acCloneCopy = ac.clone(true, true, false, false);  //formation = rq.xfb__c; //indTyp = rq.xcnm__c; */
        }
        system.debug('rq>>>' + rq);
        system.debug('######################ldLeaseCmp END#############################');
    }
    public void updateOffer() {
        string stsCd = Apexpages.currentPage().getParameters().get('itmCd');
        String stsid = GDRFAUtil.statusId(stsCd, ritm.itm__c);
        ritm.sta__c = stsid;
        update ritm;
    }
    public PageReference formationUpdate() {
        /*//rq.xfb__c= formation; */
        system.debug('In lease rq.xfb__c>>' + formation);
        return null;
    }
    public PageReference indTypUpdate() {
        /*//rq.xcnm__c = indTyp; */
        system.debug('In lease rq.xcnm__c>>' + indTyp);
        return null;
    }


    public PageReference editFromLeaseCmp() {
        if (rq != null) {
            g_Req__c rq2 = rq;
            rq2.xfb__c = formation;
            rq2.xcnm__c = indTyp;
            system.debug('In lease rq2.xfb__c>>' + rq2.xfb__c);
            system.debug('In lease rq2.xcnm__c>>' + rq2.xcnm__c);
            update rq2;
            system.debug('lease rq>>' + rq2);
        }
        return null;
    }
    public PageReference addSegment() {
        system.debug('2 segJson >>>' + segJson);
        try {
            if (segJson != null && segJson != '') {
                segments = (List < segmentWraper > ) JSON.deserialize(segJson, List < segmentWraper > .class);
                calculateDueAmt();
            }
        } catch (Exception ex) {
            system.debug('Exp >>> ' + ex);
        }
        if (segments == null || segments.size() <= 0) {
            /*//ldLeaseCmp(); */
            addSegment4mRQ();
        }
        return null;
    }

    /*//get segment Json from Request */
    public void addSegment4mRQ() {
        if (rq != null && rq.xadtx2__c != null && rq.xadtx2__c != '') {
            segments = (List < segmentWraper > ) JSON.deserialize(rq.xadtx2__c, List < segmentWraper > .class);
            calculateDueAmt();
        }
    }

    public void calculateDueAmt() {
        DueAmt = 0;
        system.debug('segments >>>' + segments);
        if (segments != null && segments.size() > 0) {
            for (segmentWraper sw: segments) {
                system.debug('sw.price >>>' + sw.price);
                if (sw.price != null && sw.price != '') DueAmt = DueAmt + Decimal.valueOf(sw.price);
            }
            system.debug('DueAmt >>>' + DueAmt);
        }
    }

    public class SegActivity {
        public String id {
            get;
            set;
        }
        public String name {
            get;
            set;
        }
        public String price {
            get;
            set;
        }
        public String channel {
            get;
            set;
        }
        public String title {
            get;
            set;
        }
    }
    public class segmentWraper {
        public string name {
            get;
            set;
        }
        public string id {
            get;
            set;
        }
        public String price {
            get;
            set;
        }
        public List < SegActivity > SegActivities {
            get;
            set;
        }
    }
    public class UnitInfo {
        public String LineItemName {
            set;
            get;
        }
        public String ProductName {
            set;
            get;
        }
        public String UnitNumber {
            set;
            get;
        }
        public String buildingName {
            set;
            get;
        }
        public String floor {
            set;
            get;
        }
        public boolean regOff {
            set;
            get;
        }
        public string agNo {
            set;
            get;
        }
        public String ContractStartDate {
            get;
            set;
        }
        public String ContractEndDate {
            get;
            set;
        }
        public Decimal UnitArea {
            get;
            set;
        }
    }
}
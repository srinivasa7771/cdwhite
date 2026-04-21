public class grqWsOnboard {


    public static void updateFrlAccInfo(g_Req__c rq, String ccrmId) {
        List < ws_call__c > wsCallLst = new List < ws_call__c > ();
        List < Country__c > cntLst = [select id, name, cntcrm__c, ntcrm__c, cntdda__c from Country__c where(cntcrm__c != ''
            OR ntcrm__c != '')];
        String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        Map < String, String > ntmp = new Map < String, String > ();
        Map < String, String > cntmp = new Map < String, String > ();
        Boolean cntflg = false;
        for (Country__c cnt: cntLst) {
            if (String.isNotBlank(cnt.cntcrm__c)) cntmp.put(cnt.name, cnt.cntcrm__c);
            if (String.isNotBlank(cnt.ntcrm__c)) ntmp.put(cnt.name, cnt.ntcrm__c);
        }
        String reqJson = '';
        g_reqitem__c ritm = [select id from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c = 'frl'];

        List < ActivityInfo > tActv = new List < ActivityInfo > ();
        grqWsOnboard.Records rqRec = new grqWsOnboard.Records();
        rqRec.crmAccId = ccrmId;
        rqRec.businessName1 = rq.Full_Name__c;
        rqRec.fullName = (string.isNotBlank(rq.xcfn__c) ? (rq.xcfn__c).toLowerCase().capitalize() : '') + ' ' + (string.isNotBlank(rq.xcln__c) ? (rq.xcln__c).toLowerCase().capitalize() : '');

        rqRec.requestid = rq.id;
        rqRec.proposedLegalForm = 'Freelancer';
        rqRec.licenseType = rq.xaccbrand__c;
        rqRec.BusinessPark = rq.xaccbrand__c;
        List < grqWsOnboard.Member > mlst = new List < grqWsOnboard.Member > ();
        grqWsOnboard.Member m = new grqWsOnboard.Member();
        m.role = 'General Manager';
        m.fname = string.isNotBlank(rq.xcfn__c) ? (rq.xcfn__c).toLowerCase().capitalize() : '';
        m.fnameAr = rq.xcfnar__c;
        if (String.isNotBlank(m.fname) && (m.fname == m.fnameAr || String.isBlank(m.fnameAr) || (m.fnameAr).length() == 1))
            m.fnameAr = GDRFAUtil.engToArabicStr(m.fname, gApiToken);
        m.lname = string.isNotBlank(rq.xcln__c) ? (rq.xcln__c).toLowerCase().capitalize() : '';
        m.lnameAr = rq.xclnar__c;
        if (String.isNotBlank(m.lname) && (m.lname == m.lnameAr || String.isBlank(m.lnameAr) || (m.lnameAr).length() == 1))
            m.lnameAr = GDRFAUtil.engToArabicStr(m.lname, gApiToken);
        rqRec.fullNameAr = m.fnameAr + ' ' + m.lnameAr;
        m.passportNo = rq.xcp__c;
        m.email = rq.xceml__c;
        if (ntmp != null && String.isNotBlank(rq.xcnc__c) && ntmp.containsKey(rq.xcnc__c))
            m.nationality = ntmp.get(rq.xcnc__c);
        else {
            m.nationality = rq.xcnc__c;
            cntflg = true;
        }
        m.gender = rq.Gender__c;
        m.salutation = rq.xcslt__c;
        if (String.isNotBlank(rq.xcmob__c)) {
            m.mobile = rq.xui__c + '-' + rq.xcmob__c;
            m.phoneno = rq.xui__c + '-' + rq.xcmob__c;
        } /*MS 1.1*/
        if (String.isNotBlank(rq.xvn__c))
            m.website = rq.xvn__c;
        //m.fullName = rq.Full_Name__c;
        m.pIssuedDate = String.valueOf(rq.xcpid__c);
        m.pExpDate = String.valueOf(rq.xcped__c);
        m.eExpDate = String.valueOf(rq.xceidedt__c);
        m.rpNo = rq.xrp__c;
        m.eid = rq.xceidid__c;
        m.dob = String.valueOf(rq.xcbd__c);
        m.ctgCode = 'fl';
        if (ntmp != null && String.isNotBlank(rq.xcpic__c) && ntmp.containsKey(rq.xcpic__c))
            m.placeissued = ntmp.get(rq.xcpic__c);
        else {
            cntflg = true;
            m.placeissued = rq.xcpic__c;
        }

        m.birthplace = rq.xcbp__c;
        String street = rq.xcstrt__c + ',' + rq.xcarea__c + ',' + rq.xccty__c;

        m.mailingStreet = (rq.xcnc__c == 'United Arab Emirates') ? street : rq.xeng__c;
        m.mailingCity = (rq.xcnc__c == 'United Arab Emirates') ? rq.xcemrt__c : rq.xengp__c;
        m.mailingPostalCode = '11111'; /* Need to remove once CRM update validation*/
        String country = (rq.xcnc__c == 'United Arab Emirates') ? rq.xcnc__c : rq.xcnp__c;
        if (String.isNotBlank(country) && cntmp.containsKey(country))
            m.mailingCountry = cntmp.get(country);
        else {
            m.mailingCountry = country;
            cntflg = true;
        }

        if (String.isNotBlank(rq.xcstrt__c)) {
            m.street = street;
            m.city = rq.xcemrt__c;
            m.postalCode = '11111'; /* Need to remove once CRM update validation*/
        }
        m.address = rq.xcha__c;
        mlst.add(m);

        rqRec.members = mlst;

        if (String.isNotBlank(rq.xadtx2__c)) {
            List < grqWsOnboard.SegmentInfo > lst = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(rq.xadtx2__c, List < grqWsOnboard.SegmentInfo > .class);
            for (grqWsOnboard.SegmentInfo rec: lst) {
                tActv.addAll(rec.SegActivities);
            }
            rqRec.actvities = tActv;
        }
        if (String.isNotBlank(rq.activitiesFL__c)) {
            List < String > actlst = rq.activitiesFL__c.split(';');
            //String seg = (rq.xaccbrand__c == 'Dubai Internet City') ? 'ICT Freelancer' : (rq.xaccbrand__c+' Freelancer');
            String seg = rq.segmentFL__c;
            for (DED_Activity__c act: [select id, name, DDAActID__c, Activity_Label__c from DED_Activity__c where Activity_Label__c =: actlst and Segment_Label__c =: seg]) { //and  Segment_Label__c=:
                tActv.add(new ActivityInfo(act.Activity_Label__c, act.DDAActID__c));
            }
            rqRec.actvities = tActv;
        }
        reqJson = Json.serialize(rqRec);



        ws_call__c wc = new ws_call__c();
        wc.rq_itm__c = ritm.id;
        wc.ws_typ__c = 'Onboarding';
        wc.mtd_nm__c = 'updateAccInfo';
        wc.rq_jsn__c = reqJson;
        if (!cntflg)
            wc.intsts__c = 'Ready for Integration';
        else
            wc.intsts__c = 'Failed';
        wsCallLst.add(wc);


        if (wsCallLst != null && !wsCallLst.isEmpty()) {
            insert wsCallLst;
            if (!cntflg)
                callUpdateAccInfo(wsCallLst[0].id);
        }

    }


    @Future(callout = true)
    public static void autoQualifyLead(String ldid) {
        String reqJson = '{"methodName":"autoqualifylead","data":[{"leadId":"' + ldid + '"}]}';
        ccrmStatusUpdate(reqJson);
    }

    public static HttpResponse ccrmStatusUpdate(String reqJson) {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/onboarding/');
        request.setTimeout(90000);
        request.setMethod('POST');
        request.setBody(reqJson);
        response = h.send(request);

        return response;
    }


    public static void updateAccInfo(List < g_reqitem__c > rqItSet, map < Id, g_Req__c > reqMap, String wsTyp, String wsMd) {
        List < ws_call__c > wsCallLst = new List < ws_call__c > ();
        List < Country__c > cntLst = [select id, name, cntcrm__c, ntcrm__c, cntdda__c from Country__c where(cntcrm__c != ''
            OR ntcrm__c != '')];
        String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        Map < String, String > ntmp = new Map < String, String > ();
        Map < String, String > cntmp = new Map < String, String > ();
        Map < String, String > cntDDamp = new Map < String, String > (); /*MS 1.1*/
        for (Country__c cnt: cntLst) {
            if (String.isNotBlank(cnt.cntcrm__c)) cntmp.put(cnt.name, cnt.cntcrm__c);
            if (String.isNotBlank(cnt.ntcrm__c)) ntmp.put(cnt.name, cnt.ntcrm__c);
            if (String.isNotBlank(cnt.cntdda__c)) cntDDamp.put(cnt.name, cnt.cntdda__c);
        }

        /*MS 1.1 Starts*/
        map < String, Contact > mapContact = new map < String, Contact > ();
        list < Id > lstAcc = new list < Id > ();
        for (g_reqitem__c n: rqItSet) {
            g_Req__c rq = reqMap.get(n.id);
            if (String.isNotBlank(rq.acc__c)) {
                lstAcc.add(rq.acc__c);
            }
        }
        if (!lstAcc.isEmpty()) {
            for (Contact objCon: [Select id, name, email, account.name, accountId from Contact where accountId IN: lstAcc]) {
                mapContact.put(objCon.accountId, objCon);
            }
        }
        /*MS 1.1 Ends*/

        Boolean cntflg = false;
        for (g_reqitem__c n: rqItSet) {
            System.debug('<updateAccInfo> n.id::' + n.id);
            g_Req__c rq = reqMap.get(n.id);
            String reqJson = '';
            grqWsOnboard.Records adhoc4Wrapper = (grqWsOnboard.Records) json.deserialize(rq.xadtx4__c, grqWsOnboard.Records.class);
            Map < String, grqWsOnboard.Member > passportMemberMap = new Map < String, grqWsOnboard.Member > ();
            for (grqWsOnboard.Member member: adhoc4Wrapper.members) {
                passportMemberMap.put(member.passportNo, member);
            }
            system.debug('<updateAccInfo> rq.xadtx3__c : ' + rq.xadtx3__c);
            system.debug('<updateAccInfo> rq.xadtx4__c : ' + rq.xadtx4__c);
            List < ActivityInfo > tActv = new List < ActivityInfo > ();
            grqWsOnboard.Records rec1 = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class);
            grqWsOnboard.Records rqRec = new grqWsOnboard.Records();



            if (rec1 != null && string.isNotBlank(rec1.crmAccId)) { // &&  string.isNotBlank(rec1.nameResWorkid)
                rqRec.crmAccId = rec1.crmAccId;
                rqRec.nameResWorkid = rec1.nameResWorkid;
                rqRec.scWorkid = rec1.scWorkid;
                rqRec.onbReqid = rec1.onbReqid;

                if (String.isNotBlank(rq.xfb__c)) {
                    if (rq.xfb__c == 'FZ-LLC')
                        rqRec.proposedLegalForm = 'Free Zone Limited Liability company';
                    else if (rq.xfb__c == 'Branch of Foreign Company')
                        rqRec.proposedLegalForm = 'Branch of a Foreign Company';
                    else if (rq.xfb__c == 'Branch of UAE Company') {
                        if (String.isNotBlank(rq.xvch__c) && rq.xvch__c == 'single')
                            rqRec.proposedLegalForm = 'Branch of a UAE Establishment';
                        else
                            rqRec.proposedLegalForm = 'Branch of a UAE Company';
                    } else
                        rqRec.proposedLegalForm = rq.xfb__c;
                }

                // name reservation
                rqRec.businessName1 = rq.xcfn__c;
                rqRec.businessName2 = rq.xcmn__c;
                rqRec.businessName3 = rq.xcln__c;
                rqRec.parentCompany = rq.xccn__c;
                rqRec.fullNameAR = String.isNotBlank(rq.xcna__c) ? rq.xcna__c : ''; /*MS 1.1*/
                if (rq.xvtyp__c == 'DED') {

                    /*MS 1.1 Starts*/
                    Contact objCon = mapContact.get(rq.acc__c);
                    if (objCon != null) {
                        rqRec.parentCompany = objCon.Account.Name;
                        rqRec.conEmail = objCon.email;
                    }
                    rqRec.compName = rq.xccn__c;
                    rqRec.accDesc = rq.Acc__r.Description;
                    rqRec.addState = rq.xcemrt__c;
                    /*MS 1.1 ends*/

                    rqRec.dedCompanyName = rq.xcfn__c;
                    rqRec.dedLicense = rq.xdedln__c;
                    rqRec.dedLeaseType = rq.xltp__c;


                }
                rqRec.productCategory = rq.parcat__c; /*MS 1.1*/
                rqRec.licenseType = rq.xvtyp__c;
                rqRec.pcRegNo = rq.rtacn__c;
                if (String.isNotBlank(rq.xcpic__c) && ntmp != null && ntmp.containsKey(rq.xcpic__c))
                    rqRec.nationality = ntmp.get(rq.xcpic__c);
                else {
                    rqRec.nationality = rq.xcpic__c;
                    if (String.isNotBlank(rq.xcpic__c))
                        cntflg = true;
                }


                if (String.isNotBlank(rq.xuvdet__c)) {

                    grqWsOnboard.parCmpDetails jPcDetails = (grqWsOnboard.parCmpDetails) json.deserialize(rq.xuvdet__c, grqWsOnboard.parCmpDetails.class);
                    System.debug(jPcDetails.issuingauth);
                    if (cntmp != null && cntmp.containskey(jPcDetails.cntry1))
                        rqRec.countryOfIncorp = cntmp.get(jPcDetails.cntry1);
                    else {
                        rqRec.countryOfIncorp = jPcDetails.cntry1;
                        cntflg = true;
                    }

                    rqRec.issuingAuthority = jPcDetails.issuingauth;
                    if (rq.acc__r.lctp__c == 'DED') {
                        rqRec.issuingAuthority = rq.License_Authority__c;
                    } /*MS 1.1*/
                    rqRec.ofcEmail = jPcDetails.ofceml;
                    rqRec.ofcPhone = String.isNotBlank(jPcDetails.ofPhCode) ? jPcDetails.ofPhCode + '-' + jPcDetails.ofcphone : '+971-' + jPcDetails.ofcphone; /*MS 1.1*/
                    rqRec.ofcAddress = jPcDetails.addcity;
                    String addCt = '';
                    if (String.isNotBlank(jPcDetails.addcity)) {
                        addCt = jPcDetails.addcity;
                        addCt = addCt.right(10).replace(',', '');
                        list < String > lstString = addCt.split(' ');
                        addCt = lstString[lstString.size() - 1];

                        system.debug('addCt==' + lstString[lstString.size() - 1]);
                    }
                    /*MS 1.1 start*/
                    rqRec.adcity = (string.isNotBlank(jPcDetails.adcity)) ? jPcDetails.adcity : (string.isNotBlank(jPcDetails.addcity)) ? addCt : 'Dubai';
                    rqRec.addstreet = string.isNotBlank(jPcDetails.addstreet) ? jPcDetails.addstreet : string.isNotBlank(jPcDetails.addcity) ? jPcDetails.addcity : '';
                    rqRec.addPO = jPcDetails.addPO;
                    rqRec.profceml = jPcDetails.profceml;
                    rqRec.secofceml = jPcDetails.secofceml;
                    rqRec.prMobile = string.isNotBlank(jPcDetails.prmMobile) ? jPcDetails.prmMobile : '';
                    rqRec.secMobile = String.isNotBlank(jPcDetails.secMobile) ? jPcDetails.secMobile : '';
                    rqRec.prmccode = jPcDetails.prmccode;
                    rqRec.seccode = jPcDetails.seccode;
                    /*MS 1.1 end*/
                }
                g_req__c objreq = [select id, xadtx5__c from g_req__c where id =: rq.id];
                if (String.isNotBlank(objreq.xadtx5__c)) {
                    list < Object > lstLandInfo = (list < Object > ) JSON.deserializeUntyped(objreq.xadtx5__c);
                    for (object landinfo: lstLandInfo) {
                        map < String, object > maplandInfo = (map < String, object > ) landinfo;
                        system.debug('strInfo===' + maplandInfo.get('type'));
                        rqRec.landtype = (String) maplandInfo.get('type');
                        map < String, object > mapinfo = (map < String, object > ) maplandInfo.get('info');
                        for (String strInfo: mapinfo.keySet()) {
                            system.debug('strInfo===' + strInfo + '=====val===' + mapinfo.get(strInfo));
                            if (strInfo == 'Size required') {
                                rqRec.landsize = Decimal.valueOf(Integer.valueof(mapinfo.get(strInfo)));
                            } else if (strInfo == 'Connected Power Load Required') {
                                rqRec.PowerLoad = Decimal.valueOf(Integer.valueof(mapinfo.get(strInfo)));
                            } else if (strInfo == 'Anticipated amount of water for your industry') {
                                rqRec.wateramount = (mapinfo.ContainsKey(strInfo) && mapinfo.get(strInfo) != null && mapinfo.get(strInfo) != '') ? Decimal.valueOf((String) mapinfo.get(strInfo)) : null;
                            } else if (strInfo == 'Estimated BUA DM range (35-50%)') {
                                rqRec.BUARange = Integer.valueOf(mapinfo.get(strInfo));
                            }
                            /* |strInfo===Size required=====val===1111111111
15:23:59.40 (52993151)|USER_DEBUG|[10]|DEBUG|strInfo===Connected Power Load Required=====val===222222222

15:23:59.40 (53026260)|USER_DEBUG|[10]|DEBUG|strInfo===Anticipated amount of water for your industry=====val===2222222222

15:23:59.40 (53067402)|USER_DEBUG|[10]|DEBUG|strInfo===Estimated BUA DM range (35-50%)=====val===44*/
                        }
                    }
                }

                if (String.isNotBlank(rq.xbtnm__c))
                    rqRec.pcDOI = strDate(rq.xbtnm__c);

                rqRec.tdLcStdt = rq.xceididt__c != null ? rq.xceididt__c : null; /*MS 1.1*/
                rqRec.tdLcEddt = rq.xceidedt__c != null ? rq.xceidedt__c : null; /*MS 1.1*/
                rqRec.taxRgNo = String.isNotBlank(rq.Acc__r.van__c) != null ? rq.Acc__r.van__c : null; /*MS 1.1*/
                rqRec.MethodName = rq.mtnm__c;
                rqRec.axsSrNo = rq.Name;

                rqRec.requestid = rq.id;
                List < grqWsOnboard.Member > mlst = new List < grqWsOnboard.Member > ();
                integer i = 0;
                for (acc_sharehd__c sh: [select id, nsh__c, nd__c, xcfnar__c, xclnar__c, strt__c, cty__c, mstrt__c, mcty__c, mcnt__c, pob__c, eid__c, eidedt__c, uboexptype__c, iAuthority__c, cmpwebsite__c, cshType__c, UBO_Type__c, UBO_RelatedTo__c, ubolglrp__c, accsh__r.sharecap__c, accsh__r.noshrs__c, crole__c, ctgCode__c, Postion__c, regno__c, Shareholder_Type__c, fname__c, mname__c, lname__c, passno__c, Email__c, nat__c, Gender__c, Mobile__c, noshrs__c, shName__c, pIsDt__c, pExDt__c, dob__c,
                        ppi__c, phn__c from acc_sharehd__c where accsh__c =: rq.Acc__c
                    ]) {
                    grqWsOnboard.Member m = new grqWsOnboard.Member();
                    system.debug('Acting SH' + m.actingAsNomineeShareholder);
                    system.debug('Acting Dir' + m.actingAsNomineeDirector);
                    m.corpORind = sh.Shareholder_Type__c;
                    if (i == 0) {
                        rqRec.noofShares = integer.valueOf(sh.accsh__r.noshrs__c);
                        rqRec.shareCapital = sh.accsh__r.sharecap__c;
                    }
                    if (String.isNotBlank(sh.crole__c)) {
                        m.role = (sh.crole__c).replace('Shareholder', 'Member').replace('Board of Director', 'Board of Directors');
                    }

                    /*if(String.isNotBlank(sh.crole__c) && !((sh.crole__c).contains('Member'))) m.role += ',Member';   */
                    m.fname = string.isNotBlank(sh.fname__c) ? (sh.fname__c).toLowerCase().capitalize() : '';
                    m.mname = string.isNotBlank(sh.mname__c) ? (sh.mname__c).toLowerCase().capitalize() : '';
                    m.lname = string.isNotBlank(sh.lname__c) ? (sh.lname__c).toLowerCase().capitalize() : '';
                    m.fnameAr = sh.xcfnar__c;
                    m.lnameAr = sh.xclnar__c;

                    if (String.isNotBlank(m.fname) && (m.fname == m.fnameAr || String.isBlank(m.fnameAr) || (m.fnameAr).length() == 1))
                        m.fnameAr = GDRFAUtil.engToArabicStr(m.fname, gApiToken);
                    if (String.isNotBlank(m.lname) && (m.lname == m.lnameAr || String.isBlank(m.lnameAr) || (m.lnameAr).length() == 1))
                        m.lnameAr = GDRFAUtil.engToArabicStr(m.lname, gApiToken);
                    system.debug('firstname AR:' + m.fnameAr);
                    system.debug('lastname AR:' + m.lnameAr);
                    m.passportNo = sh.passno__c;
                    if (m.passportNo != null && passportMemberMap.containsKey(m.passportNo)) {
                        System.debug('passportMemberMap.get(m.passportNo) prateek :' + passportMemberMap.get(m.passportNo));
                        m.pepRelated = passportMemberMap.get(m.passportNo).pepRelated;
                        m.pepCountry = passportMemberMap.get(m.passportNo).pepCountry;
                        m.pepCloselyRelatedOthers = passportMemberMap.get(m.passportNo).pepCloselyRelatedOthers;
                        m.pepCloselyAssociatedOthers = passportMemberMap.get(m.passportNo).pepCloselyAssociatedOthers;
                        m.pepAssociation = passportMemberMap.get(m.passportNo).pepAssociation;
                        m.sourceOfwealth = passportMemberMap.get(m.passportNo).sourceOfwealth;

                        /*MS 1.1 starts*/
                        m.inUAE = passportMemberMap.get(m.passportNo).inUAE;
                        m.visitedUAE = passportMemberMap.get(m.passportNo).visitedUAE;
                        if (m.inUAE != null) {
                            m.citizenOrResident = m.inUAE.equalsignorecase('Yes') ? 'Citizen or Resident' : 'Non-Citizen/Non-Resident';
                        }
                        m.placeissued = passportMemberMap.get(m.passportNo).placeissued;

                        if (cntDDamp != null && cntDDamp.containsKey(passportMemberMap.get(m.passportNo).birthCountry))
                            m.birthCountry = cntDDamp.get(passportMemberMap.get(m.passportNo).birthCountry);
                        else {
                            m.birthCountry = passportMemberMap.get(m.passportNo).birthCountry;
                            if (String.isNotBlank(passportMemberMap.get(m.passportNo).birthCountry))
                                cntflg = true;
                        }
                        system.debug('cntflg===2' + cntflg);
                        m.emiratesIdIssueDate = passportMemberMap.get(m.passportNo).emiratesIdIssueDate;
                        if (String.isNotBlank(m.emiratesIdIssueDate) && m.emiratesIdIssueDate.contains('/')) {
                            date newdate = date.parse(m.emiratesIdIssueDate);
                            system.debug('newDate==' + newdate);
                            string s = newdate.year() + '-' + newdate.month() + '-' + newdate.day();
                            system.debug('s==' + s);
                            m.emiratesIdIssueDate = s;
                        }
                        /*MS 1.1 Ends*/

                    }
                    m.email = sh.Email__c;
                    if (ntmp != null && ntmp.containsKey(sh.nat__c)) {
                        /*  m.placeissued = ntmp.get(sh.nat__c); */
                        m.nationality = ntmp.get(sh.nat__c);
                    } else {
                        /*  m.placeissued = sh.nat__c;*/
                        m.nationality = sh.nat__c;
                        cntflg = true;
                    }

                    /*--Add default value to birthcountry incase old application where customer did not has option for birth Country*/
                    if (String.isBlank(m.birthCountry) && String.isNotBlank(m.nationality)) {
                        m.birthCountry = m.nationality;
                    }

                    m.gender = sh.Gender__c;
                    if (String.isNotBlank(sh.Gender__c) && sh.Gender__c.equalsIgnoreCase('male')) {
                        m.salutation = 'Mr.';
                    } else if (String.isNotBlank(sh.Gender__c) && sh.Gender__c.equalsIgnoreCase('female')) {
                        m.salutation = 'Ms.';
                    }
                    m.mobile = sh.Mobile__c;
                    m.sh = String.valueOf(sh.noshrs__c);
                    //m.fullName = sh.shName__c;
                    m.pIssuedDate = String.valueOf(sh.pIsDt__c);
                    m.pExpDate = String.valueOf(sh.pExDt__c);
                    m.dob = String.valueOf(sh.dob__c);
                    m.ctgCode = sh.ctgCode__c;
                    //m.placeissued = sh.ppi__c; 

                    if (String.isBlank(sh.pob__c) && String.isNotBlank(m.nationality)) {
                        m.birthplace = m.nationality;
                    } else m.birthplace = sh.pob__c;

                    // m.birthplace = sh.pob__c;
                    m.mailingStreet = sh.mstrt__c;
                    m.mailingCity = sh.mcty__c;
                    if (string.isblank(m.mailingStreet)) m.mailingStreet = 'Dubai';
                    if (string.isblank(m.mailingPostalCode)) m.mailingPostalCode = '11111';
                    if (string.isblank(m.mailingCity)) m.mailingCity = 'Dubai';
                    if (string.isblank(m.mailingCountry)) m.mailingCountry = 'United Arab Emirates';
                    if (cntmp != null && cntmp.containsKey(sh.mcnt__c))
                        m.mailingCountry = cntmp.get(sh.mcnt__c);
                    else {
                        m.mailingCountry = sh.mcnt__c;
                        if (String.isNotBlank(sh.mcnt__c))
                            cntflg = true;
                    }

                    m.mailingPostalCode = '11111';
                    if (String.isNotBlank(sh.strt__c)) {
                        m.street = sh.strt__c;
                        m.city = sh.cty__c;
                    }
                    if (string.isNotBlank(sh.eid__c)) {
                        m.eid = sh.eid__c;
                        m.eExpDate = String.valueOf(sh.eidedt__c);
                    }
                    m.phoneno = sh.phn__c;
                    m.cshType = sh.cshType__c;
                    //if(m.role.contains('Ultimate Beneficiary')){
                    if (String.isNotBlank(sh.UBO_Type__c)) {
                        m.uboType = sh.UBO_Type__c;
                        m.actingAsNomineeShareholder = sh.nsh__c;
                        m.actingAsNomineeDirector = sh.nd__c;
                    }
                    if (String.isNotBlank(sh.ubolglrp__c))
                        m.legals = sh.ubolglrp__c;
                    /*if(sh.ubostk__c != null)
m.stockExchangeListed = sh.ubostk__c; */
                    m.uboRelatedTo = sh.UBO_RelatedTo__c;
                    m.website = sh.cmpwebsite__c;
                    m.iAuthority = sh.iAuthority__c;
                    /*if(sh.fda__c != null)
m.uboDeclaration = sh.fda__c;*/
                    if (String.isNotBlank(sh.uboexptype__c)) {
                        m.stockExchangeListed = (sh.uboexptype__c == 'stockExchangeListed') ? true : false;
                        m.uboOwnedbyUAE = (sh.uboexptype__c == 'ownedByUAE') ? true : false;
                        m.uboDeclaration = (sh.uboexptype__c == 'submittedToFdrl') ? true : false;

                    }
                    //}

                    mlst.add(m);
                }
                rqRec.members = mlst;

                List < grqWsOnboard.SegmentInfo > lst = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(rq.xadtx2__c, List < grqWsOnboard.SegmentInfo > .class);
                for (grqWsOnboard.SegmentInfo rec: lst) {
                    if (rq.acc__r.lctp__c == 'DED') {
                        String actvt = '';
                        for (grqWsOnboard.ActivityInfo act: rec.SegActivities) {
                            actvt = actvt + act.name + ';';
                        }
                        rqRec.dedActivities = actvt;
                    }
                    tActv.addAll(rec.SegActivities);
                }
                rqRec.actvities = tActv;
                reqJson = Json.serialize(rqRec);
            }


            ws_call__c wc = new ws_call__c();
            wc.rq_itm__c = n.id;
            wc.ws_typ__c = wsTyp;
            wc.mtd_nm__c = wsMd;
            wc.rq_jsn__c = reqJson;
            if (!cntflg)
                wc.intsts__c = 'Ready for Integration';
            else
                wc.intsts__c = 'Failed';
            wsCallLst.add(wc);

        }
        if (wsCallLst != null && !wsCallLst.isEmpty()) {
            insert wsCallLst;
            system.debug('ws call id:' + wsCallLst[0].id);
            if (!cntflg && Label.Onboarding_MemberUpdate == 'Yes')
                callUpdateAccInfo(wsCallLst[0].id);
        }



    }


    //SH_V2 added
    @Future(callout = true)
    public static void callUpdateAccInfo() {

        String query = 'Select Id,rq_jsn__c,res_jsn__c,err_msg__c,intsts__c,pmid__c,xrno__c,rq_itm__c,rq_itm__r.RQ__c,mtd_nm__c,rq_itm__r.ccrmid__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where ws_typ__c = \'Onboarding\' AND mtd_nm__c=\'updateAccInfo\' AND intsts__c =\'Ready for Integration\'';
        List < ws_call__c > wsC = Database.query(query);
        new BatchOnboardInfoUpdate().updateAccInfo(wsC[0]);

        //BatchOnboardInfoUpdate b = new BatchOnboardInfoUpdate();
        //database.executebatch(b, 1);
    }


    // @Future(callout=true)
    public static void callUpdateAccInfo(String wsCallId) {
        System.debug('wsCallId : ' + wsCallId);
        //String query = 'Select Id,rq_jsn__c,res_jsn__c,err_msg__c,intsts__c,pmid__c,xrno__c,rq_itm__c,rq_itm__r.RQ__c,mtd_nm__c,rq_itm__r.ccrmid__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id=:wsCallId';
        //List<ws_call__c> wsC =  Database.query(query);
        //new BatchOnboardInfoUpdate().updateAccInfo(wsC[0]); 
        System.enqueueJob(new OnboardQueueable('updateAccInfo', wsCallId));
    }


    @Future(callout = true)
    public static void callUploadDocs(String wsCallId) {
        System.debug('wsCallId : ' + wsCallId);
        String query = 'Select Id,rq_jsn__c,res_jsn__c,err_msg__c,intsts__c,pmid__c,xrno__c,rq_itm__r.itm__r.cd__c,rq_itm__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.xcfn__c,rq_itm__r.RQ__r.xcln__c,mtd_nm__c,rq_itm__r.ccrmid__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c,rq_itm__r.RQ__r.Acc__r.name,rq_itm__r.RQ__r.xadtx1__c,rq_itm__r.RQ__r.Service_Code__c from ws_call__c where id=:wsCallId and ws_typ__c = \'Onboarding\' AND mtd_nm__c=\'uploadDoc\' AND intsts__c =\'Ready for Integration\''; /*MS 1.1*/
        List < ws_call__c > wsC = Database.query(query);
        new BatchOnboardFetchAccInfo().uploadDocument(wsC[0]);
    }


    //SH_V2 added
    public static void callUploadDocs() {

        String query = 'Select Id,rq_jsn__c,res_jsn__c,err_msg__c,intsts__c,pmid__c,xrno__c,rq_itm__c,rq_itm__r.RQ__c,mtd_nm__c,rq_itm__r.ccrmid__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where ws_typ__c = \'Onboarding\' AND mtd_nm__c=\'uploadDoc\' AND intsts__c =\'Ready for Integration\'';
        List < ws_call__c > wsC = Database.query(query);

        grqWsOnboard.Records recs = (grqWsOnboard.Records) JSON.deserialize(wsC[0].rq_jsn__c, grqWsOnboard.Records.class);
        //uploadDocs(recs,rqId,wsCall);   
        new BatchOnboardInfoUpdate().uploadDocs(recs, wsC[0].pmid__c, wsC[0]);
    }


    public static void fetchAccInfo(List < g_reqitem__c > rqItSet, map < Id, g_Req__c > reqMap, String wsTyp, String wsMd) {
        system.debug('rqItSet:' + rqItSet);
        List < ws_call__c > wsCallLst = new List < ws_call__c > ();
        for (g_reqitem__c n: rqItSet) {
            g_Req__c rq = reqMap.get(n.id);
            ws_call__c wc = new ws_call__c();
            wc.rq_itm__c = n.id;
            wc.ws_typ__c = wsTyp;
            wc.mtd_nm__c = wsMd;
            wc.intsts__c = 'Ready for Integration';
            wc.pmid__c = rq.Acc__r.ccrm_sfid__c;
            wsCallLst.add(wc);
        }
        system.debug('wsCallLst::' + wsCallLst);
        if (wsCallLst != null && !wsCallLst.isEmpty()) insert wsCallLst;
    }

    public static void callUpdatePMSInfo(List < id > wsCallLst) {

        System.debug('recList : ' + wsCallLst);
        System.enqueueJob(new OnboardQueueable('UpdatePMSInfo', wsCallLst));
    }



    public static QuoteInfo fetchLeaseDetails(List < QuoteInfo > qlst, String rqid) {
        QuoteInfo qinfo = new QuoteInfo();
        for (QuoteInfo qi: qlst) {
            if (rqid == qi.requestId) {
                qinfo = qi;
                break;
            }
        }
        return qinfo;
    }
    @future(callout = true)
    public static void updateUsrAccess(List < Id > accIdLst) {
        system.debug('updateUsrAccess::');

        List < User > usrLst = [select id, isactive from User where(contact.accountid =: accIdLst or id In: accIdLst) and isactive = true];
        if (usrLst != null && !usrLst.isEmpty()) {
            for (User usr: usrLst) {
                usr.isactive = false;
            }
            update usrLst;
        }
    }

    public static String frmtAddrs(String adr) {
        String val = '';
        if (String.isNotBlank(adr) && adr.contains(' ')) {
            List < String > lst = adr.split(' ');
            for (String str: lst) {
                if (String.isNotBlank(str) && str.length() > 40) {
                    val = val + frmStr(str);
                } else {
                    val = val + ' ' + str;
                }
            }
        } else if (String.isNotBlank(adr) && adr.length() > 40) {
            val = val + frmStr(adr);
        } else {
            val = adr;
        }
        return val;
    }


    public static string frmStr(String strInput) {
        String frmStr = '';
        do {
            frmStr = frmStr + strInput.subString(0, 40) + ' ';
            strInput = strInput.subString(40, strInput.length());
        } while (strInput.length() > 40);
        frmStr = frmStr + strInput;
        return frmStr;
    }


    public static String strDate(String dt) {
        List < string > lst = dt.split('/');
        return lst[2] + '-' + lst[1] + '-' + lst[0]; //Date.newInstance(integer.valueOf(lst[2]) ,integer.valueOf(lst[1]), integer.valueOf(lst[0]));  
    }

    public static string ddaOnbordingInfo(String rqBody) {
        String respBody = '';
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/onbordingapi');
        request.setTimeout(90000);
        request.setMethod('POST');
        request.setBody(rqBody);
        response = h.send(request);
        if (response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) {
            respBody = response.getBody();
            system.debug('respBody:' + respBody);
        }
        return respBody;
    }
    public static Boolean validateFreelancer(g_Req__c rq) {
        Boolean lcflg = false;
        FLInfo fl = new FLInfo();
        fl.firstName = rq.xcfn__c;
        fl.lastName = rq.xcln__c;
        fl.birthdate = String.valueOf(rq.xcbd__c);
        fl.passportNumber = rq.xcp__c;
        fl.country = rq.xcnc__c;
        FLValidate flRq = new FLValidate();
        flRq.methodname = 'validateFreelancer';
        flRq.data = fl;
        String rqBody = Json.serialize(flRq);
        String respBody = ddaOnbordingInfo(rqBody);
        if (String.isNotBlank(respBody)) {
            grqWsOnboard.FLInfo flres = (grqWsOnboard.FLInfo) JSON.deserialize(respBody, grqWsOnboard.FLInfo.class);
            lcflg = flres.isLicenseIssued;
        }
        return lcflg;
    }
    //    public static void updatePMSInfo(ws_call__c ws){ List<PMSDataWrapper.ContractInformation> contractlist = gwsPMSIntegration.getContractInfoByLicNo(ws.pmid__c); Decimal psffee = 0; if(contractlist !=null && !contractlist.isEmpty()){ PMSDataWrapper.ContractInformation contract = contractlist[0]; Decimal ttlAreaSM = 0,ttlAreaSF=0; if(contract.propertyInformationList != null && !contract.propertyInformationList.isEmpty()){ for(PMSDataWrapper.PropertyInformationList property: contract.propertyInformationList){ ttlAreaSM = (ttlAreaSM + ((String.isNotBlank(property.Area)) ? decimal.valueOf(property.Area) : 0.0)); } ttlAreaSF = (ttlAreaSM*10.7639).setScale(2, RoundingMode.HALF_UP); psffee = (ttlAreaSF * decimal.valueOf(Label.PSFFeeSF)); } } List < g_Req__c > rqLst = [select id, os__c, DDA_INV__c,activitiesFL__c,name, xadtx3__c, xdccaRq__c, xadtx2__c, xdei__c, xadh__c, acc__c, acc__r.id, acc__r.lcedt__c, skpu__c from g_Req__c where name=:ws.xrno__c limit 1]; if(rqLst != null && !rqLst.isEmpty()) { grqWsOnboard.Records rec = (grqWsOnboard.Records) JSON.deserialize(rqLst[0].xadtx3__c, grqWsOnboard.Records.class); rqLst[0].os__c = 'CCL Accepted'; if (String.isBlank(rqLst[0].xadh__c)) { rqLst[0].xadh__c = ''; } else { rqLst[0].xadh__c += ';'; } String paySch = '{"workorders":[{"status":"Approved","recType":"Brand_Approval","recid":"0WO2R0000059dE0WAI","parentid":null,"members":null,"ddaRQNo":null,"ddaRQId":null},{"status":"Waiting for Original Documents","recType":"License_Registration_Request","recid":"0WO2R0000059dE2WAI","parentid":null,"members":null,"ddaRQNo":null,"ddaRQId":null},{"status":"Approved","recType":"Security_Clearance","recid":"0WO2R0000059dE1WAI","parentid":null,"members":null,"ddaRQNo":null,"ddaRQId":null}],"usrName":"Ramzieh Kahil","scWorkid":"0WO2R0000059dE1WAI","respMsg":"Success","requestid":"a0E2y000006RTdzEAG","quotes":[{"units":[{"status":"Soft Booked","productName":"DSC-DSC Tower-1209","name":"1209","isActive":true,"floor":"Twelfth Floor","buildingName":"DSC Tower","area":759.47}],"totalOfrPrice":129109.9,"totalDiscount":15.00,"totalBstRate":170880.75,"status":"Accepted","rqtype":"New","requestId":"a0E2y000006RTdzEAG","quoteNo":"00078446","quoteName":"Quote - New - Office - 20220126","quoteId":"0Q02R000002GeGiSAK","opportunityId":"0062R00000xKv6cQAC","lsStDt":"2022-02-02","lsStatus":null,"lsEndDt":"2025-02-01","locDet":null,"agNo":"AG-083771"}],"proposedLegalForm":"DDA","prmPhone":"00971 4 3914605","prmMobile":"+971 504767977","prmLastName":"Kahil","prmFirstName":"Ramzieh","prmEmail":"ramzieh.kahil@dmc.ae","paymentSchedules":[{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJMQA3","description":"Ejari Service Charge","chargeTo":"2022-02-02","chargeFrom":"2022-02-02","chargeCode":"ejarisc","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJNQA3","description":"Ejari Services","chargeTo":"2022-02-02","chargeFrom":"2022-02-02","chargeCode":"ejrsvc","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJOQA3","description":"Rental Income - Office","chargeTo":"2022-05-01","chargeFrom":"2022-02-02","chargeCode":"rntoff","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJPQA3","description":"PSF Fee","chargeTo":"2022-05-01","chargeFrom":"2022-02-02","chargeCode":"psf","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJPQA4","description":"Service Charge","chargeTo":"2022-05-01","chargeFrom":"2022-02-02","chargeCode":"srvchrg","billedAmount":0}],"oppId":"0062R00000xKv6cQAC","onbReqid":"a2l2R000004O0VoQAK","nameResWorkid":"0WO2R0000059dE2WAI","members":[{"website":null,"uboType":null,"uboRelatedTo":null,"uboOwnedbyUAE":null,"uboDeclaration":null,"street":null,"stockExchangeListed":null,"sh":"50","security":null,"salutation":"Mr.","rpNo":null,"rpExpDate":null,"role":"Member;Board of Directors;General Manager;Ultimate Beneficiary","postalCode":null,"placeissued":"United Arab Emirates","pIssuedDate":null,"phoneno":"0553822838","pExpDate":"2024-05-26","passportNo":"FF4262724","nationality":"United Arab Emirates","mobile":"+971553822838","mname":null,"mailingStreet":null,"mailingPostalCode":null,"mailingCountry":null,"mailingCity":null,"lnameAr":null,"lname":"Alfarsi","legals":null,"iAuthority":null,"gender":"Male","fnameAr":null,"fname":"Majid","email":"majidmohammed@skyi.ae","eid":null,"eExpDate":null,"dob":"1996-06-23","ctgCode":null,"cshType":null,"corpORind":"Individual Shareholder","conid":"0032R00002KXrWAQA1","city":null,"birthplace":null}],"lrWorkid":null,"licenseType":"DDA","legalFramework":"DDA","lcExpdate":"2023-02-03","isSuccess":true,"hseWorkid":null,"documents":[{"name":"Signed Article of Association","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"Signed Article of Association","ddaDocId":"a3e6F0000018SW0QAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlRVUAZ"},{"name":"Valid Passport Copy - Majid Alfarsi","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"Valid Passport Copy - Majid Alfarsi","ddaDocId":"a3e6F0000018SYkQAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlbbUAB"},{"name":"Resolution for the Incorporation of an FZ-LLC","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"Resolution for the Incorporation of an FZ-LLC","ddaDocId":"a3e6F0000018SW2QAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlRXUAZ"},{"name":"General Declaration and Undertaking Form","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"General Declaration and Undertaking Form","ddaDocId":"a3e6F0000018SW1QAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlRWUAZ"}],"DDAReqNo":null,"crmAccName":"Sky I Aerial Photography FZ-LLC","crmAccId":"0012R00002H1j4wQAB","caseid":null,"businessPark":"DDA","brandWorkid":"0WO2R0000059dE0WAI","actvities":[{"title":null,"segment":"Production (Film/TV and Radio)","name":"Post Production","channel":null,"actId":"a0L2R00000KCy1DUAT"},{"title":null,"segment":"Production (Film/TV and Radio)","name":"Production - Film, TV, and Radio","channel":null,"actId":"a0L2R00000KCxp7UAD"},{"title":null,"segment":"Production (Film/TV and Radio)","name":"Production ? Corporate/Social Videos","channel":null,"actId":"a0L2R00000KCxlMUAT"}]}'; grqWsOnboard.Records DmmypaySch = (grqWsOnboard.Records) JSON.deserialize(paySch, grqWsOnboard.Records.class); rec.paymentSchedules = DmmypaySch.paymentSchedules; List < grqWsOnboard.ActivityInfo > DDALts = new List < grqWsOnboard.ActivityInfo > (); List < grqWsOnboard.ActivityInfo > lstActs = new List < grqWsOnboard.ActivityInfo > (); List < grqWsOnboard.SegmentInfo > lstSegments2 = new List < grqWsOnboard.SegmentInfo > (); String DDA_INV = ''; if (rec.paymentSchedules != null && rec.paymentSchedules.size() > 0) { List < grqWsOnboard.SegmentInfo > lstSegments = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(rqLst[0].xadtx2__c, List < grqWsOnboard.SegmentInfo > .class); if (lstSegments == null) { lstSegments = new List < grqWsOnboard.SegmentInfo > (); } /*create a map  for Terms*/ /*rec.paymentSchedules.sort();*/ System.debug('SORT>>> : ' + JSON.serialize(rec.paymentSchedules)); Map < Integer, List < grqWsOnboard.PaymentSchedules >> termsMap = new Map < Integer, List < grqWsOnboard.PaymentSchedules >> (); List < String > chrgCdLst = Label.Charge_Code_Yardi.split(';'); List < grqWsOnboard.PaymentSchedules > paySchule; paySchule = new List < grqWsOnboard.PaymentSchedules > (); Integer Terms = 1; String fromDate = ''; system.debug('Terms---' + Terms); for (grqWsOnboard.PaymentSchedules py: rec.paymentSchedules) { if (!chrgCdLst.contains(py.chargeCode)) { /* py.chargeCode!='rntoff' && py.chargeCode!='srvchrg' && py.chargeCode!='in5deinc' */ py.term = '1'; paySchule.add(py); } else if (py.chargeFrom == fromDate || fromDate == '') { py.term = '' + Terms; paySchule.add(py); fromDate = py.chargeFrom; system.debug('fromDate---' + fromDate); system.debug('Terms---' + Terms); } else { fromDate = py.chargeFrom; termsMap.put(Terms, paySchule); paySchule = new List < grqWsOnboard.PaymentSchedules > (); Terms++; py.term = '' + Terms; paySchule.add(py); system.debug('fromDate---' + fromDate); system.debug('Terms---' + Terms); } } termsMap.put(Terms, paySchule); List < grqWsOnboard.PaymentSchedules > paySchTrms = new List < grqWsOnboard.PaymentSchedules > (); System.debug('termsMap>>> : ' + JSON.serialize(termsMap)); for (Integer key: termsMap.keySet()) { List < grqWsOnboard.PaymentSchedules > payS = termsMap.get(key); System.debug('payS>>> : ' + JSON.serialize(payS)); for (grqWsOnboard.PaymentSchedules py: payS) { grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(py.description, 'CCRM-' + py.quote); List < String > lstActDocs = new List < String > (); act.docs = lstActDocs; act.price = '' + py.billedAmount; act.vatAmount = '' + py.vatAmount; act.totalPrice = '' + py.totalAmountIncludingVat; act.chargeCode = py.chargeCode; act.propertyCode = py.propertyCode; act.tenantCode = py.tenantCode; act.chargeFrom = py.chargeFrom; act.chargeTo = py.chargeTo; act.description = py.description; act.term = py.term; lstActs.add(act); } } String res = grqWsDccaGetService.getNewReqDetails(rqLst[0].xdccaRq__c); grqWsDccaGetService dccaResp = (grqWsDccaGetService) System.JSON.deserialize(res, grqWsDccaGetService.class); DDA_INV = dccaResp.invno; Map < String, grqWsOnboard.ActivityInfo > mapLstActs = new Map < String, grqWsOnboard.ActivityInfo > (); List < grqWsDccaGetService.LineItems > ddaItms = dccaResp.Data[0].lines; Decimal in5Price = 0; if (ddaItms != null) { for (grqWsDccaGetService.LineItems dda: ddaItms) { String Name = ''; if (dda.lineName != 'Registration Fees' && dda.lineName != 'Knowledge Dirham' && dda.lineName != 'Innovation Dirham') { Name = 'New Licence Fee'; } else { Name = dda.lineName; } if (String.isNotBlank(Name)) { grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(Name, 'dda'); List < String > lstActDocs = new List < String > (); act.docs = lstActDocs; if (Name == 'New Licence Fee' && dda.amount != null) { in5Price = in5Price + Decimal.valueOf(dda.amount); act.price = '' + in5Price; act.vatAmount = '0'; act.totalPrice = '' + in5Price; } else { if (!mapLstActs.isEmpty() && mapLstActs.containsKey(Name)) { grqWsOnboard.ActivityInfo exAct = (grqWsOnboard.ActivityInfo) mapLstActs.get(Name); act.price = '' + (Decimal.valueOf(exAct.price) + Decimal.valueOf(dda.amount)); } else { act.price = '' + dda.amount; } act.vatAmount = '0'; act.totalPrice = act.price; } act.description = Name; act.term = '1'; act.actId = 'dda'; /* lstActs.add(act); */ mapLstActs.put(Name, act); } } DDALts = mapLstActs.values(); lstActs.addAll(DDALts); } Integer itemNo = 1; for (grqWsOnboard.ActivityInfo curAct: lstActs) { grqWsOnboard.SegmentInfo sInfo = new grqWsOnboard.SegmentInfo(); if (curAct.actId == 'dda') { if (curAct.Name == 'New Licence Fee') { sInfo.segId = 'dr'; } if (curAct.Name == 'Registration Fees') { sInfo.segId = 'rgf'; } if (curAct.Name == 'Knowledge Dirham') { sInfo.segId = 'kf'; } if (curAct.Name == 'Innovation Dirham') { sInfo.segId = 'inf'; } sInfo.name = curAct.Name; } else if (!curAct.Name.contains('Ejari Service') && curAct.Name != 'Refundable Security Deposit' && curAct.Name != 'PSF Fee' && curAct.actId != 'dda') { sInfo.segId = curAct.term + 'py'; if (Integer.valueOf(curAct.term) <= 12 && !rqLst[0].xadh__c.contains(curAct.term + 'py;')) { rqLst[0].xadh__c += curAct.term + 'py;'; } sInfo.name = 'Lease Fees - Term ' + curAct.term; } else if (curAct.Name == 'Refundable Security Deposit' && curAct.actId != 'dda') { sInfo.segId = 'sc'; if (Integer.valueOf(curAct.term) <= 12 && !rqLst[0].xadh__c.contains('sc;')) { rqLst[0].xadh__c += 'sc;'; } sInfo.name = 'Refundable Security Deposit'; } else if (curAct.Name == 'PSF Fee' && curAct.actId != 'dda') { sInfo.segId = 'psf'; if ( !rqLst[0].xadh__c.contains('psf;')) { rqLst[0].xadh__c += 'psf;'; } sInfo.name = 'PSF Fee'; } else { String itmCd = (curAct.Name.equalsIgnoreCase('Ejari Services')) ? 'ej' : 'ejc'; sInfo.segId = itmCd; sInfo.name = curAct.Name; if (Integer.valueOf(curAct.term) <= 12 && !rqLst[0].xadh__c.contains(itmCd + ';')) { rqLst[0].xadh__c += itmCd + ';'; } } curAct.name = ''; curAct.actId = sInfo.name; /*sInfo.SegActivities =  new List<grqWsOnboard.ActivityInfo>{curAct};*/ sInfo.vatAmount = curAct.vatAmount; sInfo.term = curAct.term; if(sInfo.segId == 'psf'){ sInfo.price = ''+psffee; sInfo.totalPrice = ''+psffee; } else{ sInfo.price = curAct.price; sInfo.totalPrice = curAct.totalPrice; } sInfo.chargeCode = curAct.chargeCode; sInfo.propertyCode = curAct.propertyCode; sInfo.tenantCode = curAct.tenantCode; sInfo.chargeFrom = curAct.chargeFrom; sInfo.chargeTo = curAct.chargeTo; lstSegments2.add(sInfo); } } System.debug('lstSegments2>>> : ' + JSON.serialize(lstSegments2)); rqLst[0].xadtx1__c = JSON.serialize(lstSegments2); rqLst[0].DDA_INV__c = DDA_INV; if(contractlist!=null && !contractlist.isEmpty()) rqLst[0].activitiesFL__c = JSON.serialize(contractlist); System.debug('after payment sc xadh__c : ' + rqLst[0].xadh__c); if (String.isNotBlank(rqLst[0].xadh__c)) { rqLst[0].xadh__c = rqLst[0].xadh__c.replaceAll(';;', ';'); rqLst[0].xadh__c += ';'; } update rqLst; ws.intsts__c = 'Success'; } else{ ws.intsts__c = 'Failed'; } update ws; }
    public static void updateAccLicInfo(String licno) {
        grqWsOnboard.AccInfo accInfo = getLicInfo(licno, '');
        accInfoNew(accInfo);
    }
    public static Account updateAccName(Account acc) {

        if (acc.lc__c != '93408') {
            grqWsOnboard.AccInfo accInfo = getLicInfo(acc.lc__c, 'AccNameInfo');
            acc.name = String.isNotBlank(accInfo.accOpName) ? accInfo.accOpName : acc.on__c;
            acc.licn__c = String.isNotBlank(accInfo.accName) ? accInfo.accName : acc.licn__c;
            acc.licnarb__c = String.isNotBlank(accInfo.accNameAr) ? accInfo.accNameAr : acc.licnarb__c;
            acc.on__c = String.isNotBlank(accInfo.accOpName) ? accInfo.accOpName : acc.on__c;
            acc.onar__c = String.isNotBlank(accInfo.accOpNameAr) ? accInfo.accOpNameAr : acc.onar__c;
            if (acc.lcidt1__c == null && String.isBlank(accinfo.licFrstIssDt))
                acc.lcidt1__c = Date.valueOf(accinfo.licFrstIssDt);
        }
        return acc;
    }
    /*Written as resuable method*/
    public static void accInfoNew(grqWsOnboard.AccInfo accInfo) {
        List < Account > accLst = [select id, name, licn__c, onar__c, licnarb__c, lcidt1__c, lcedt__c, Legal_Framework__c, noshrs__c, shareVal__c, sharecap__c, shcrtp__c from Account where lc__c =: accInfo.licNo];
        if (accLst != null && !accLst.isEmpty()) {
            Account acc = accLst[0];
            List < acc_sharehd__c > delAccShLst = [select id from acc_sharehd__c where accsh__c =: acc.id];
            List < seg__c > delAccSegLst = [select id from seg__c where acct__c =: acc.id];
            system.debug('---delAccSegLst---' + delAccSegLst);
            if (delAccShLst != null && !delAccShLst.isEmpty()) delete delAccShLst;
            if (delAccSegLst != null && !delAccSegLst.isEmpty()) delete delAccSegLst;
            if (acc.lcidt1__c == null) acc.lcidt1__c = Date.valueOf(accinfo.licFrstIssDt);
            acc.name = String.isNotBlank(accInfo.accName) ? accInfo.accName : acc.name;
            acc.licn__c = String.isNotBlank(accInfo.accName) ? accInfo.accName : acc.licn__c;
            acc.licnarb__c = String.isNotBlank(accInfo.accNameAr) ? accInfo.accNameAr : acc.licnarb__c;
            acc.on__c = String.isNotBlank(accInfo.accOpName) ? accInfo.accOpName : acc.on__c;
            acc.onar__c = String.isNotBlank(accInfo.accOpNameAr) ? accInfo.accOpNameAr : acc.onar__c;
            if (accinfo.ttlShval != null && accinfo.ttlShval != 0) {
                acc.noshrs__c = accinfo.noOfSh;
                acc.shareVal__c = accinfo.shVal;
                acc.sharecap__c = accinfo.ttlShval;
                acc.shcrtp__c = accinfo.curTyp;
            }
            List < seg__c > segLst = new List < seg__c > ();
            if (accinfo.actLst != null && !accinfo.actLst.isEmpty()) {
                for (ActInfo act: accinfo.actLst) {
                    seg__c segAct = new seg__c();
                    segAct.acct__c = acc.id;
                    segAct.act__c = act.actName;
                    segAct.seg__c = act.segName;
                    segAct.Isact__c = true;
                    segLst.add(segAct);
                }
                insert segLst;
            }
            List < acc_sharehd__c > accShLst = new List < acc_sharehd__c > ();
            if (accinfo.mbLst != null && !accinfo.mbLst.isEmpty()) {
                for (MemberInfo m: accinfo.mbLst) {
                    acc_sharehd__c ash = new acc_sharehd__c();
                    ash.shName__c = m.name;
                    if (String.isNotBlank(m.nameAr)) ash.shNameArb__c = m.nameAr;
                    ash.Postion__c = m.role;
                    ash.nat__c = m.nt;
                    if (String.isNotBlank(m.ntAr)) ash.natarb__c = m.ntAr;
                    if (String.isNotBlank(m.regNo)) ash.regno__c = m.regNo;
                    ash.accsh__c = acc.id;
                    accShLst.add(ash);
                }
            }
            if (accinfo.shLst != null && !accinfo.shLst.isEmpty()) {
                for (ShareInfo sh: accinfo.shLst) {
                    acc_sharehd__c ash = new acc_sharehd__c();
                    ash.shName__c = sh.name;
                    if (String.isNotBlank(sh.nameAr)) ash.shNameArb__c = sh.nameAr;
                    ash.Postion__c = sh.role;
                    ash.nat__c = sh.nt;
                    if (String.isNotBlank(sh.ntAr)) ash.natarb__c = sh.ntAr;
                    ash.noshrs__c = sh.noSh;
                    ash.totalValShrs__c = sh.ttlValSh;
                    ash.shrperc__c = sh.shper;
                    ash.accsh__c = acc.id;
                    accShLst.add(ash);
                }
            }
            insert accShLst;
            update acc;
        }
    }
    public static grqWsOnboard.AccInfo getLicInfo(String licno, String srvType) {
        grqWsOnboard.AccInfo accinfo = new grqWsOnboard.AccInfo();
        String respBody = '';
        Boolean lcflg = false;
        FLInfo fl = new FLInfo();
        FLValidate flRq = new FLValidate();
        flRq.methodname = 'licenseinfo';
        fl.licenseNum = licno;
        flRq.data = fl;
        String rqBody = Json.serialize(flRq);
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/onbordingapi');
        request.setTimeout(90000);
        request.setMethod('POST');
        request.setBody(rqBody);
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            if (String.isNotBlank(response.getBody())) {
                respBody = response.getBody();
                system.debug('res::' + respBody);
            }
        }
        if (String.isNotBlank(respBody)) {
            Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(respBody);
            Integer respCode = (Integer) results.get('responseCode');
            String errorMsg = (String) results.get('errorMessage');
            if (errorMsg == 'Success' && respCode == 200) {
                List < Object > actObjLst = (List < Object > ) results.get('activities');
                List < Object > shObjLst = (List < Object > ) results.get('shareholders');
                List < Object > memObjLst = (List < Object > ) results.get('members');
                Object licObjInfo = (Object) results.get('licenseinfo');
                List < ActInfo > actInfLst = new List < ActInfo > ();
                List < MemberInfo > mbLst = new List < MemberInfo > ();
                List < ShareInfo > shLst = new List < ShareInfo > ();
                if (srvType != 'AccNameInfo') {
                    for (integer i = 0; i < actObjLst.size(); i++) {
                        /*system.debug('---actObjLst--'+actObjLst);*/
                        Map < string, Object > actObjMp = (Map < string, Object > ) actObjLst[i];
                        String actName = (String) actObjMp.get('Activity_Name__c');
                        String segName = (String) actObjMp.get('Segment__c');
                        ActInfo act = new ActInfo();
                        act.actName = actName;
                        act.segName = segName;
                        actInfLst.add(act);
                    }
                    for (integer i = 0; i < memObjLst.size(); i++) {
                        Map < string, Object > memObjMp = (Map < string, Object > ) memObjLst[i];
                        MemberInfo mb = new MemberInfo(); /*system.debug('--memObjMp--'+memObjMp);*/
                        mb.role = (String) memObjMp.get('Position__c');
                        mb.name = (String)((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Name');
                        mb.nameAr = (String)((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Full_Name_Arabic__c');
                        mb.regNo = (String)((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Registration_No__c');
                        mb.email = (String)((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Per_Email__c');
                        mb.mobile = (String)((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Per_Mobile__c');
                        system.debug('--mb.role--' + mb.role);
                        if (String.isNotBlank(mb.role) && mb.role == 'Parent') {
                            mb.nt = (String)((Map < string, Object > )((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Country_of_Incorporation__r')).get('Name');
                            mb.ntAr = (String)((Map < string, Object > )((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Country_of_Incorporation__r')).get('Arabic_Country_Name__c');
                        } else {
                            mb.nt = (String)((Map < string, Object > )((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Nationality__r')).get('Name');
                            mb.ntAr = (String)((Map < string, Object > )((Map < string, Object > ) memObjMp.get('Relation_Source__r')).get('Nationality__r')).get('Arabic_Country_Name__c');
                        }
                        mbLst.add(mb);
                    }
                    for (integer i = 0; i < shObjLst.size(); i++) {
                        Map < string, Object > shObjMp = (Map < string, Object > ) shObjLst[i];
                        ShareInfo sh = new ShareInfo();
                        sh.role = 'Shareholder';
                        sh.name = (String)((Map < string, Object > ) shObjMp.get('Identity__r')).get('Name');
                        sh.nameAr = (String)((Map < string, Object > ) shObjMp.get('Identity__r')).get('Full_Name_Arabic__c');
                        Map < string, Object > idnMp = (Map < string, Object > ) shObjMp.get('Identity__r');
                        if (idnMp.containsKey('Nationality__r')) {
                            sh.nt = (String)((Map < string, Object > )((Map < string, Object > ) shObjMp.get('Identity__r')).get('Nationality__r')).get('Name');
                            sh.ntAr = (String)((Map < string, Object > )((Map < string, Object > ) shObjMp.get('Identity__r')).get('Nationality__r')).get('Arabic_Country_Name__c');
                        } else {
                            sh.nt = (String)((Map < string, Object > )((Map < string, Object > ) shObjMp.get('Identity__r')).get('Country_of_Incorporation__r')).get('Name');
                            sh.ntAr = (String)((Map < string, Object > )((Map < string, Object > ) shObjMp.get('Identity__r')).get('Country_of_Incorporation__r')).get('Arabic_Country_Name__c');
                        }
                        sh.noSh = (decimal) shObjMp.get('Number_of_Shares__c');
                        sh.email = (String)((Map < string, Object > ) shObjMp.get('Identity__r')).get('Per_Email__c');
                        sh.mobile = (String)((Map < string, Object > ) shObjMp.get('Identity__r')).get('Per_Mobile__c');
                        sh.ttlValSh = (sh.noSh * ((decimal) shObjMp.get('Value_of_Share__c')));
                        sh.shper = (decimal) shObjMp.get('Share_Percentage_New__c');
                        accinfo.shVal = (decimal)((Map < string, Object > ) shObjMp.get('Revision__r')).get('Share_Value__c');
                        accinfo.noOfSh = (decimal)((Map < string, Object > ) shObjMp.get('Revision__r')).get('Number_of_Shares__c');
                        accinfo.ttlShval = (decimal)((Map < string, Object > ) shObjMp.get('Revision__r')).get('Share_Capital__c');
                        accinfo.curTyp = (String)((Map < string, Object > ) shObjMp.get('Revision__r')).get('Currency__c');
                        shLst.add(sh);
                    }
                }
                Map < string, Object > licObjMp = (Map < string, Object > ) results.get('licenseinfo');
                accinfo.licNo = (String) licObjMp.get('License__c');
                accinfo.accName = (String) licObjMp.get('Licensee_Name__c');
                accinfo.accNameAr = (String) licObjMp.get('Licensee_Name_Arabic__c');
                accinfo.accOpName = (String) licObjMp.get('Legal_Name__c');
                accinfo.accOpNameAr = (String) licObjMp.get('Legal_name_Arabic__c');
                accinfo.licFrstIssDt = (String) licObjMp.get('License_First_Issue_Date__c');
                accinfo.licIssDt = (String) licObjMp.get('License_Issue_Date__c');
                accinfo.licExpDt = (String) licObjMp.get('License_Expiry_Date__c');
                accinfo.lgFrm = (String)((Map < string, Object > ) licObjMp.get('Legal_Framework__r')).get('Name');
                accinfo.actLst = actInfLst;
                accinfo.mbLst = mbLst;
                accinfo.shLst = shLst;
            }
        }
        return accinfo;
    }

    public ResponseData ResponseData {
        set;
        get;
    }
    public class ResponseData {
        public List < Records > Records {
            set;
            get;
        }
    }

    public static string updateRqDocs(String rqdocid) {
        String docname = '', doclbl = '', nm = '';
        try {
            List < g_reqitemDoc__c > ridocLst = [select id, Req__c, reqAts__c, reqItm__r.itm__r.cd__c, reqItm__r.xcfn__c, reqItm__r.xcln__c, reqItm__r.RQ__r.xccn__c, name, lbl__c, reqDoc__c from g_reqitemDoc__c where reqDoc__c =: rqdocid];
            if (ridocLst != null && !ridocLst.isEmpty() && ridocLst[0].lbl__c.contains(ridocLst[0].reqItm__r.itm__r.cd__c)) {
                g_reqitemDoc__c ridoc = ridocLst[0];
                if ((String.isNotBlank(ridoc.reqItm__r.xcln__c) && !ridoc.lbl__c.contains(ridoc.reqItm__r.xcln__c))) {
                    nm = (String.isBlank(ridoc.reqItm__r.xcfn__c)) ? ridoc.reqItm__r.xcln__c : ridoc.reqItm__r.xcfn__c + ' ' + ridoc.reqItm__r.xcln__c;
                } else if (String.isNotBlank(ridoc.reqItm__r.RQ__r.xccn__c) && !ridoc.lbl__c.contains(ridoc.reqItm__r.RQ__r.xccn__c)) {
                    nm = ridoc.reqItm__r.RQ__r.xccn__c;
                } /*doclbl = (ridoc.lbl__c).replace(ridoc.reqItm__r.itm__r.cd__c, nm);*/
                doclbl = (ridoc.lbl__c).replace('- ' + ridoc.reqItm__r.itm__r.cd__c, '- ' + nm); /*MS 1.1*/
                docname = (doclbl.length() > 80) ? doclbl.substring(0, 79) : doclbl;
                ridoc.Name = docname;
                ridoc.lbl__c = doclbl;
                ridoc.Req__c = true;
                ridoc.reqAts__c = true;
                update ridoc;
                g_reqDoc__c rdoc = new g_reqDoc__c(id = rqdocid, name = docname, lbl__c = doclbl);
                update rdoc;
            } else if (ridocLst != null && !ridocLst.isEmpty()) doclbl = ridocLst[0].lbl__c;
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
        return doclbl;
    }
    public static string fetchAccInfo(String crmAccid) {
        String respBody = '';
        try {
            system.debug('crmAccid::' + crmAccid);
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            //request.setEndpoint('callout:CCRM_UAT/apexrest/accinfo');
            request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/accinfo');
            //request.setEndpoint('callout:CCRM/apexrest/accinfo');
            request.setHeader('accId', crmAccid);
            request.setTimeout(90000);
            request.setMethod('GET');

            response = h.send(request);
            if (response.getStatusCode() == 200) {

                if (response.getBody() != null)
                    respBody = response.getBody();

            }
        } catch (Exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
        }
        return respBody;
    }


    public static void docsWSCallToDDA(id rq, String type) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < g_Req__c > lstreq = new List < g_Req__c > ();
        if (type == 'Correction') {
            lstreq = [Select id, Name, Acc__c, Acc__r.lc__c, srvc__c, (select id from Items__r where itm__r.cd__c IN('ddd')), (select id, name, nc__c, lbl__c, dda_att__c, RQ__r.name from rDocs__r where Req__c = true and upOk__c = true and nc__c = true) from g_Req__c where id =: rq];
        } else {
            lstreq = [Select id, Name, Acc__c, Acc__r.lc__c, srvc__c, (select id from Items__r where itm__r.cd__c IN('ddd')), (select id, name, lbl__c, dda_att__c, RQ__r.name from rDocs__r where Req__c = true and upOk__c = true) from g_Req__c where id =: rq];
        }
        List < g_reqDoc__c > rdList = new List < g_reqDoc__c > ();
        system.debug('====lstreq===' + lstreq);
        if (lstreq != null && !lstreq.isEmpty() && lstreq != null && lstreq[0].rDocs__r != null) {
            for (g_reqDoc__c rqDoc: lstreq[0].rDocs__r) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = lstreq[0].Items__r[0].id;
                wc.ws_typ__c = 'License Amendments';
                wc.mtd_nm__c = 'LADocs';
                wc.intsts__c = 'Ready for Integration';
                wc.adhoc_text1__c = !string.isblank(rqDoc.lbl__c) ? rqDoc.lbl__c : rqDoc.name;
                wc.pmid__c = rqDoc.dda_att__c;
                wsList.add(wc);
            }
        }
        insert wsList;
    }

    //@Future(callout = true)
    //public static void callUpsertContacts(String wsCallId) { System.debug('wsCallId : ' + wsCallId); String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c; String query = 'Select Id,rq_itm__c,intsts__c,rq_itm__r.RQ__r.Acc__r.Email__c,rq_itm__r.RQ__r.rmob__c,rq_itm__r.RQ__r.xcamc__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.xcitn__c,rq_itm__r.RQ__r.xadtx4__c,rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c from ws_call__c where id=:wsCallId'; List < ws_call__c > wsLst = Database.query(query); List < id > attIdLst = new List < id > (); String woId = ''; List < ws_call__c > docwsLst = new List < ws_call__c > (); if (wsLst != null && !wsLst.isEmpty() && String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xadtx4__c)) { String reqJson = ''; List < Object > jsonBody = (List < Object > ) JSON.deserializeUntyped(wsLst[0].rq_itm__r.RQ__r.xadtx4__c); List < RecInfo > recLst = new List < RecInfo > (); StatusUpdate obj = new StatusUpdate(); obj.methodName = 'upsertcontacts'; for (Object objrec: jsonBody) { Map < String, object > memMap = (Map < String, object > ) objrec; system.debug('val:' + memMap.get('Given_Name')); RecInfo rec = new RecInfo(); rec.oraclePartyId = wsLst[0].rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c; if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && wsLst[0].rq_itm__r.RQ__r.xcamc__c == 'Change of General Manager') rec.role = 'General Manager;'; else if(String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c).startsWith('Change of Director')) rec.role = 'Board of Directors;'; else if(String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c).startsWith('Share Affairs')){ rec.role = 'Member;'; rec.typeOfShareHolder = 'Individual Shareholder'; } /* if(string.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)){ List<String> conrolLst = (wsLst[0].rq_itm__r.RQ__r.xcitn__c).split('_'); rec.ccrmContactId =  conrolLst[0]; rec.role =  rec.role +conrolLst[1]; }*/  if (memMap.get('MR_Gender') == 'M') { rec.salutation = 'Mr.'; rec.gender = 'Male'; } else { rec.salutation = 'Ms.'; rec.gender = 'Female'; } rec.passportNo = (String) memMap.get('Passport_No'); if (String.isNotBlank((String) memMap.get('Date_of_Issue2'))) rec.passportIssueDate = String.valueOf(GDRFAUtil.strtoDate((String) memMap.get('Date_of_Issue2'))); if (String.isNotBlank((String) memMap.get('Date_of_Expiry2'))) rec.passportExpiryDate = String.valueOf(GDRFAUtil.strtoDate((String) memMap.get('Date_of_Expiry2'))); if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c)) rec.email = wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c; else rec.email = 'test@test.com'; rec.nationality = (String) memMap.get('country'); rec.firstName = (String) memMap.get('Given_Name'); rec.lastName = (String) memMap.get('Surname'); rec.firstNameArabic = GDRFAUtil.engToArabicStr((String) memMap.get('Given_Name'), gApiToken); rec.lastNameArabic = GDRFAUtil.engToArabicStr((String) memMap.get('Surname'), gApiToken); if (String.isNotBlank((String) memMap.get('Date_of_Birth'))) rec.birthDate = String.valueOf(GDRFAUtil.strtoDate((String) memMap.get('Date_of_Birth'))); if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)) rec.isSecurityClearanceRequired = false; else rec.isSecurityClearanceRequired = true; if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.rmob__c)) rec.mobilePhone = '+971' + wsLst[0].rq_itm__r.RQ__r.rmob__c; else rec.mobilePhone = '011111111111'; rec.passportPlaceOfIssue = (String) memMap.get('country'); rec.placeOfBirth = (String) memMap.get('Place_of_Birth'); rec.emiratesId = (String) memMap.get('eid'); String inOrOut = (String) memMap.get('InOrOut'); if (String.isNotBlank(inOrOut) && inOrOut == 'yes') rec.inorOut = 'In'; else rec.inorOut = 'Out'; rec.mailingStreet = 'Bur Dubai'; rec.mailingCity = 'Dubai'; rec.mailingPostalCode = '111111'; attIdLst.add((String) memMap.get('AttachmentId')); recLst.add(rec); } obj.data = recLst; reqJson = JSON.serialize(obj); system.debug('reqJson::' + reqJson); HttpResponse response = new HttpResponse(); response = ccrmStatusUpdate(reqJson); if (response.getStatusCode() == 200) { if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)) { obj.data[0].isSecurityClearanceRequired = true; reqJson = JSON.serialize(obj); system.debug('reqJson1::' + reqJson); response = ccrmStatusUpdate(reqJson); } String respBody = ''; if (response.getBody() != null) { respBody = response.getBody(); system.debug('res::' + respBody); List < Object > resLst = (List < Object > ) JSON.deserializeUntyped(respBody); integer i = 0; for (Object resrec: resLst) { Map < String, Object > resMap = (Map < String, Object > ) resrec; woId = (String) resMap.get('workOrderId'); ws_call__c wc = new ws_call__c(); wc.rq_itm__c = wsLst[0].rq_itm__c; wc.rq_jsn__c = attIdLst[i]; wc.pmid__c = (String) resMap.get('contactId'); wc.ws_typ__c = 'DDA Amendments'; wc.mtd_nm__c = 'uploadDoc'; wc.intsts__c = 'Ready for Integration'; docwsLst.add(wc); i = i + 1; } reqJson = '{"methodName":"updateWorkOrder","data":[{"workOrderId":"' + woId + '","oraclePartyId":"' + wsLst[0].rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c + '","status":"Submitted","description":"Any detail about work order"}]}'; system.debug('reqJson Sts update::' + reqJson); ccrmStatusUpdate(reqJson); system.debug('doc ws lst::' + docwsLst.size()); wsLst[0].intsts__c = 'Success'; docwsLst.add(wsLst[0]); upsert docwsLst; g_reqitem__c ri = new g_reqitem__c(id = wsLst[0].rq_itm__c, ccrmid__c = woId); update ri; /* Map<String, String> resMap = (Map<String, String>) resLst[1];  */ /** sample response [{ "contactId" : "003O2R000002oeYG", "workOrderId": "0WO2R000002oeYG", "oraclePartyId" : "23497", "isSuccess" : true , "errorMessage" : "" }] */ } } } }
    //Expanded meth
    // public static void callUpsertContacts(String wsCallId) { System.debug('wsCallId : ' + wsCallId); String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c; String query = 'Select Id,rq_itm__r.RQ__r.xadtx3__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c,pmid__c,rq_itm__r.RQ__r.Service_Code__c,rq_itm__c,intsts__c,rq_itm__r.RQ__r.Acc__r.Email__c,rq_itm__r.RQ__r.rmob__c,rq_itm__r.RQ__r.xcamc__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.xcitn__c,rq_itm__r.RQ__r.xadtx4__c,rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c,rq_itm__r.RQ__r.xdccaRq__c,rq_itm__r.RQ__r.xdei__c from ws_call__c where id=:wsCallId'; List < Country__c > conLst = [select id, cntcrm__c, Name from Country__c]; Map < String, String > comMap = new Map < String, String > (); for (Country__c c: conLst) { comMap.put(c.Name, c.cntcrm__c); } List < ws_call__c > wsLst = Database.query(query); List < id > attIdLst = new List < id > (); List < id > attIdLstEidB = new List < id > (); List < id > attIdLstVisa = new List < id > (); List < id > attIdLstEidF = new List < id > (); String woId = ''; String conId; List < ws_call__c > docwsLst = new List < ws_call__c > (); if (wsLst != null && !wsLst.isEmpty()) { String reqJson = ''; List < RecInfo > recLst = new List < RecInfo > (); StatusUpdate obj = new StatusUpdate(); obj.methodName = 'upsertcontacts'; if (wsLst[0].rq_itm__r.RQ__r.Service_Code__c == '220' && String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xadtx3__c)) { LARequestWrapper adhoc3Data = (LARequestWrapper) System.JSON.deserialize(wsLst[0].rq_itm__r.RQ__r.xadtx3__c, LARequestWrapper.class); for (LARequestWrapper.Members mem: adhoc3Data.serviceRequests[0].members) { if (mem.actionType != 'REMOVE') { RecInfo rec = new RecInfo(); system.debug('==mem==' + mem); rec.oraclePartyId = wsLst[0].rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c; if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && wsLst[0].rq_itm__r.RQ__r.xcamc__c == 'Change of General Manager') rec.role = 'General Manager;'; else if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c).startsWith('Change of Director')) rec.role = 'Board of Directors;'; else if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c).startsWith('Share Affairs')) { rec.role = 'Member;'; rec.typeOfShareHolder = 'Individual Shareholder'; } if (mem.gender == 'M') { rec.salutation = 'Mr.'; rec.gender = 'Male'; } else { rec.salutation = 'Ms.'; rec.gender = 'Female'; } rec.passportNo = mem.passports[0].docNo; if (mem.passports[0].issueDate != null) rec.passportIssueDate = String.valueOf(mem.passports[0].issueDate); if (mem.passports[0].expiryDate != null) rec.passportExpiryDate = String.valueOf(mem.passports[0].expiryDate); /*if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c)) rec.email = wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c; else rec.email = 'test@test.com';*/ if (String.isNotBlank(mem.perEmail)) rec.email = mem.perEmail; if (comMap.containsKey(mem.nationality)) { rec.nationality = (String) comMap.get(mem.nationality); } rec.firstName = (String) mem.firstName; rec.lastName = (String) mem.lastName; rec.firstNameArabic = GDRFAUtil.engToArabicStr((String) mem.firstName, gApiToken); rec.lastNameArabic = GDRFAUtil.engToArabicStr((String) mem.lastName, gApiToken); if (mem.birthDate != null) rec.birthDate = String.valueOf(mem.birthDate); if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)) rec.isSecurityClearanceRequired = false; else rec.isSecurityClearanceRequired = true; if (String.isNotBlank(mem.perMobile)) rec.mobilePhone = mem.perMobile; rec.isMobilePhoneVerified = mem.isMobilePhoneVerified; rec.mobilePhoneVerificationDatetime = mem.mobilePhoneVerificationDatetime; rec.isEmailVerified = mem.isEmailVerified; rec.emailVerificationDatetime = mem.emailVerificationDatetime; if (String.isNotBlank(mem.phoneNo)) rec.phone = mem.phoneNo; rec.isPhoneVerified = mem.isPhoneVerified != null ? mem.isPhoneVerified : true;rec.VisitedUAE = mem.VisitedUAE;rec.birthCountry = mem.birthCountry; rec.phoneVerificationDateTime = mem.phoneVerificationDateTime != null ? mem.phoneVerificationDateTime : System.now(); rec.passportPlaceOfIssue = mem.passports[0].placeOfIssuance; rec.placeOfBirth = mem.placeborn; rec.emiratesId = mem.emiratesId.docNo; /* String inOrOut = mem.get('InOrOut'); if (String.isNotBlank(inOrOut) && inOrOut == 'yes') rec.inorOut = 'In'; else*/ rec.inorOut = 'Out'; /* rec.mailingStreet = 'Bur Dubai'; rec.mailingCity = 'Dubai'; rec.mailingPostalCode = '111111';*/ if (String.isNotBlank(mem.addresses[0].street)) rec.mailingStreet = mem.addresses[0].street; if (String.isNotBlank(mem.addresses[1].city)) rec.mailingCity = mem.addresses[0].city; rec.mailingPostalCode = '0'; attIdLst.add(mem.attachmentId); attIdLstEidF.add(mem.EIDfId); attIdLstEidB.add(mem.EIDbId); attIdLstVisa.add(mem.visaId); recLst.add(rec); } } } else if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xadtx4__c)) { List < Object > jsonBody = (List < Object > ) JSON.deserializeUntyped(wsLst[0].rq_itm__r.RQ__r.xadtx4__c); for (Object objrec: jsonBody) { Map < String, object > memMap = (Map < String, object > ) objrec; system.debug('val:' + memMap.get('Given_Name')); RecInfo rec = new RecInfo(); rec.oraclePartyId = wsLst[0].rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c; if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && wsLst[0].rq_itm__r.RQ__r.xcamc__c == 'Change of General Manager') rec.role = 'General Manager;'; else if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c).startsWith('Change of Director')) rec.role = 'Board of Directors;'; else if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c).startsWith('Share Affairs')) { rec.role = 'Member;'; rec.typeOfShareHolder = 'Individual Shareholder'; } /* if(string.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)){ List<String> conrolLst = (wsLst[0].rq_itm__r.RQ__r.xcitn__c).split('_'); rec.ccrmContactId =  conrolLst[0]; rec.role =  rec.role +conrolLst[1]; }*/ if (memMap.get('MR_Gender') == 'M') { rec.salutation = 'Mr.'; rec.gender = 'Male'; } else { rec.salutation = 'Ms.'; rec.gender = 'Female'; } rec.passportNo = (String) memMap.get('Passport_No'); if (String.isNotBlank((String) memMap.get('Date_of_Issue2'))) rec.passportIssueDate = String.valueOf(GDRFAUtil.strtoDate((String) memMap.get('Date_of_Issue2'))); if (String.isNotBlank((String) memMap.get('Date_of_Expiry2'))) rec.passportExpiryDate = String.valueOf(GDRFAUtil.strtoDate((String) memMap.get('Date_of_Expiry2'))); if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c)) if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c)) rec.email = wsLst[0].rq_itm__r.RQ__r.Acc__r.Email__c; /* else rec.email = 'test@test.com';*/ if (comMap.containsKey(rec.nationality)) { rec.nationality = (String) comMap.get(rec.nationality); } /*rec.nationality = (String) memMap.get('country');*/ rec.firstName = (String) memMap.get('Given_Name'); rec.lastName = (String) memMap.get('Surname'); rec.firstNameArabic = GDRFAUtil.engToArabicStr((String) memMap.get('Given_Name'), gApiToken); rec.lastNameArabic = GDRFAUtil.engToArabicStr((String) memMap.get('Surname'), gApiToken); if (String.isNotBlank((String) memMap.get('Date_of_Birth'))) rec.birthDate = String.valueOf(GDRFAUtil.strtoDate((String) memMap.get('Date_of_Birth'))); if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)) rec.isSecurityClearanceRequired = false; else rec.isSecurityClearanceRequired = true; /*if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.rmob__c)) rec.mobilePhone = '+971' + wsLst[0].rq_itm__r.RQ__r.rmob__c; else rec.mobilePhone = '011111111111';*/ rec.passportPlaceOfIssue = (String) memMap.get('country'); rec.placeOfBirth = (String) memMap.get('Place_of_Birth'); rec.emiratesId = (String) memMap.get('eid'); String inOrOut = (String) memMap.get('InOrOut'); if (String.isNotBlank(inOrOut) && inOrOut == 'yes') rec.inorOut = 'In'; else rec.inorOut = 'Out'; /*rec.mailingStreet = 'Bur Dubai'; rec.mailingCity = 'Dubai'; rec.mailingPostalCode = '111111';*/ attIdLst.add((String) memMap.get('AttachmentId')); recLst.add(rec); } } system.debug('==recLst==' + recLst); obj.data = recLst; reqJson = JSON.serialize(obj); wsLst[0].rq_jsn__c = reqJson; system.debug('reqJson::' + reqJson); HttpResponse response = new HttpResponse(); response = ccrmStatusUpdate(reqJson); System.debug('======res====' + response.getBody()); wsLst[0].res_jsn__c = response.getBody(); if (response.getStatusCode() == 200) { if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcitn__c)) { obj.data[0].isSecurityClearanceRequired = true; reqJson = JSON.serialize(obj); system.debug('reqJson1::' + reqJson); response = ccrmStatusUpdate(reqJson); } String respBody = ''; if (response.getBody() != null) { respBody = response.getBody(); system.debug('res::' + respBody); List < Object > resLst = (List < Object > ) JSON.deserializeUntyped(respBody); integer i = 0; String conIDs = ''; for (Object resrec: resLst) { Map < String, Object > resMap = (Map < String, Object > ) resrec; woId = (String) resMap.get('workOrderId'); conId = ((String) resMap.get('contactId')); if (!String.IsBlank(conIDs)) { conIDs = conIDs + ',' + '"' + conId + '"'; } else { conIDs = '"' + conId + '"'; } system.debug('attIdLst -- ' + attIdLst); system.debug('attIdLstEidB -- ' + attIdLstEidB); system.debug('attIdLstVisa -- ' + attIdLstVisa); system.debug('attIdLstEidF -- ' + attIdLstEidF); ws_call__c wc = new ws_call__c(); ws_call__c wcEf = new ws_call__c(); ws_call__c wcEb = new ws_call__c(); ws_call__c wcV = new ws_call__c(); wc.rq_itm__c = wcEf.rq_itm__c = wcEb.rq_itm__c = wcV.rq_itm__c = wsLst[0].rq_itm__c; wc.rq_jsn__c = attIdLst[i]; wcEb.rq_jsn__c = attIdLstEidB[i]; wcV.rq_jsn__c = attIdLstVisa[i]; wcEf.rq_jsn__c = attIdLstEidF[i]; wc.pmid__c = wcEf.pmid__c = wcEb.pmid__c = wcV.pmid__c = conId; wc.ws_typ__c = wcEf.ws_typ__c = wcEb.ws_typ__c = wcV.ws_typ__c = 'DDA Amendments'; wc.mtd_nm__c = wcEf.mtd_nm__c = wcEb.mtd_nm__c = wcV.mtd_nm__c = 'uploadDoc'; wc.intsts__c = wcEf.intsts__c = wcEb.intsts__c = wcV.intsts__c = 'Ready for Integration'; docwsLst.add(wc); docwsLst.add(wcEb); docwsLst.add(wcEf); docwsLst.add(wcV); i = i + 1; } if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Secretary') || wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Director') || wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Manager'))) { String worId = ''; String rJson = '{"methodName":"dfzcsecurity","data":[{"workOrderId":"' + worId + '","ServiceName":"' + wsLst[0].rq_itm__r.RQ__r.xcamc__c + '","axsId":"' + wsLst[0].rq_itm__r.RQ__c + '","ddaRequestId":"' + wsLst[0].rq_itm__r.RQ__r.xdei__c + '","ddaReqNumber":"' + wsLst[0].rq_itm__r.RQ__r.xdccaRq__c + '","contactIds":[' + conIDs + '],"oraclePartyId":"' + wsLst[0].rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c + '","status":"Submitted","description":"Any detail about work order"}]}'; ws_call__c wcCloned = new ws_call__c(); wcCloned.rq_itm__c = wsLst[0].rq_itm__c; wcCloned.ws_typ__c = 'DDA Amendments'; wcCloned.mtd_nm__c = 'dfzcsecurity'; wcCloned.intsts__c = 'Ready for Integration'; wcCloned.rq_jsn__c = rJson; HttpResponse response1 = grqWsOnboard.ccrmStatusUpdate(rJson); wcCloned.res_jsn__c = response1.getBody(); if (response1.getBody() != null) { String respBody1 = response1.getBody(); List < Object > resLst1 = (List < Object > ) JSON.deserializeUntyped(respBody1); for (Object resrec: resLst1) { Map < String, Object > resMap = (Map < String, Object > ) resrec; woId = (String) resMap.get('workOrderId'); } } wcCloned.intsts__c = 'Success'; insert wcCloned; g_reqitem__c ri = new g_reqitem__c(id = wcCloned.rq_itm__c, ccrmid__c = woId); update ri; } if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && !wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Secretary') && !wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Director') && !wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Manager')) { reqJson = '{"methodName":"updateWorkOrder","data":[{"workOrderId":"' + woId + '","oraclePartyId":"' + wsLst[0].rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c + '","status":"Submitted","description":"Any detail about work order"}]}'; system.debug('reqJson Sts update::' + reqJson); ccrmStatusUpdate(reqJson); System.debug(woId + '=====item id===' + wsLst[0].rq_itm__c); g_reqitem__c ri = new g_reqitem__c(id = wsLst[0].rq_itm__c, ccrmid__c = woId); update ri; /* Map<String, String> resMap = (Map<String, String>) resLst[1];  */ /** sample response [{ "contactId" : "003O2R000002oeYG", "workOrderId": "0WO2R000002oeYG", "oraclePartyId" : "23497", "isSuccess" : true , "errorMessage" : "" }] */ } wsLst[0].intsts__c = 'Success'; system.debug('doc ws lst::' + docwsLst.size()); docwsLst.add(wsLst[0]); upsert docwsLst; } } else { wsLst[0].intsts__c = 'Failed'; docwsLst.add(wsLst[0]); upsert docwsLst; } } }



    //End of expansion
    public static void getPySchedules() {
        String jsonPySchd = '[{"yearNo":"1","vatAmount":4.0,"totalDays":0,"totalAmountIncludingVat":84.0,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r55000004664xAAA","description":"Ejari Service Charge","chargeTo":"2020-12-01","chargeFrom":"2020-12-01","chargeCode":"ejarisc","billedAmount":80.0},{"yearNo":"1","vatAmount":0.0,"totalDays":0,"totalAmountIncludingVat":120.0,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r55000004664yAAA","description":"Ejari Services","chargeTo":"2020-12-01","chargeFrom":"2020-12-01","chargeCode":"ejrsvc","billedAmount":120.0},{"yearNo":"1","vatAmount":1618.29,"totalDays":89,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r55000004664zAAA","description":"Rental Income - Office","chargeTo":"2021-02-28","chargeFrom":"2020-12-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"1","vatAmount":1618.29,"totalDays":91,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046650AAA","description":"Rental Income - Office","chargeTo":"2021-05-31","chargeFrom":"2021-03-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"1","vatAmount":1618.29,"totalDays":91,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046651AAA","description":"Rental Income - Office","chargeTo":"2021-08-31","chargeFrom":"2021-06-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"1","vatAmount":1618.29,"totalDays":90,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046652AAA","description":"Rental Income - Office","chargeTo":"2021-11-30","chargeFrom":"2021-09-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"2","vatAmount":1618.29,"totalDays":89,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046653AAA","description":"Rental Income - Office","chargeTo":"2022-02-28","chargeFrom":"2021-12-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"2","vatAmount":1618.29,"totalDays":91,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046654AAA","description":"Rental Income - Office","chargeTo":"2022-05-31","chargeFrom":"2022-03-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"2","vatAmount":1618.29,"totalDays":91,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046655AAA","description":"Rental Income - Office","chargeTo":"2022-08-31","chargeFrom":"2022-06-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"2","vatAmount":1618.29,"totalDays":90,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046656AAA","description":"Rental Income - Office","chargeTo":"2022-11-30","chargeFrom":"2022-09-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"3","vatAmount":1618.29,"totalDays":89,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046657AAA","description":"Rental Income - Office","chargeTo":"2023-02-28","chargeFrom":"2022-12-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"3","vatAmount":1618.29,"totalDays":91,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046658AAA","description":"Rental Income - Office","chargeTo":"2023-05-31","chargeFrom":"2023-03-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"3","vatAmount":1618.29,"totalDays":91,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r550000046659AAA","description":"Rental Income - Office","chargeTo":"2023-08-31","chargeFrom":"2023-06-01","chargeCode":"rntoff","billedAmount":32365.8},{"yearNo":"3","vatAmount":1618.29,"totalDays":90,"totalAmountIncludingVat":33984.09,"tenantCode":"t0005193","quote":"0Q055000000FS07CAG","propertyCode":"d3_b04","Id":"a0r55000004665AAAQ","description":"Rental Income - Office","chargeTo":"2023-11-30","chargeFrom":"2023-09-01","chargeCode":"rntoff","billedAmount":32365.8}]';
        List < grqWsOnboard.PaymentSchedules > lstPySchedules = (List < grqWsOnboard.PaymentSchedules > ) JSON.deserialize(jsonPySchd, list < grqWsOnboard.PaymentSchedules > .class);
        system.debug('lst: ' + lstPySchedules);
    }

    public static void closeOnbAcc(List < id > rqIdlst, List < id > accIdlst, String srvid) {

        List < g_reqitem__c > riLst = new List < g_reqitem__c > ();
        List < id > usridLst = new List < Id > ();
        Map < String, Id > mapSTA = new Map < String, Id > ();
        try {

            for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: srvid and cd__c = 'c']) {
                mapSTA.put(s.itm__r.cd__c, s.Id);
            }
            list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c, sta__r.Tp__c from g_reqitem__c where RQ__c =: rqIdlst and isDeleted = false and sta__r.Tp__c = 'Open'];
            for (g_reqitem__c i: items) {
                if (mapSTA.get(i.itm__r.cd__c) == null) {
                    System.debug(Label.msgNFSTAC);
                }
                i.sta__c = mapSTA.get(i.itm__r.cd__c);
                riLst.add(i);
            }
            //Map<id,User> usrMp = new Map<id,User>([select id,isactive from User where contact.accountid=:accIdlst and isactive=true]);  
            if (riLst != null && riLst.size() > 0) {
                update riLst;
            }
            List < g_req__c > rqLst = [select id, STA__c, os__c from g_req__c where id =: rqIdlst];
            if (rqLst != null && !rqLst.isEmpty()) {
                for (g_req__c rq: rqLst) {
                    rq.STA__c = 'Cancelled';
                    rq.os__c = 'Cancelled';
                }
                update rqLst;
            }
            /* if (usrMp != null && usrMp.size() > 0) {
List<id> uIdlst = new List<id>();
uIdlst.addAll(usrMp.keySet());  
System.enqueueJob(new OnboardQueueable('revokeUserAccess', uIdlst));
} */
        } catch (Exception ex) {
            system.debug('ex closeAcc::' + ex.getStackTraceString());
        }
    }
    /***License Amendment***/
    //@Future(callout = true)
    /***License Amendment WS call***/


    /**Application fee update on Opportunity in CCRM MS 1.1**/
    public static void updateAppfee(String wsCallId) {
        List < ws_call__c > lstcall = [Select Id, rq_itm__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where Id =: wsCallId];
        if (!lstcall.isEmpty()) {
            /* String reqJson = '{"methodName":"updateapplicationfee", "data":[{"AccountId":"' + lstcall[0].rq_itm__r.RQ__r.Acc__c +'","applicationFee:"true"}]}';*/
            String reqJson = '{"methodName":"updateapplicationfee", "data":[{"AccountId":"' + lstcall[0].rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c + '", "applicationFee":true}]}';

            HttpResponse response = ccrmStatusUpdate(reqJson);
            system.debug('response====434===' + response);
            if (response.getStatusCode() == 200) {
                lstcall[0].intsts__c = 'Success';
                update lstcall[0];
            }
        }
    }

    public static void createLandAssignment(String wsCallId) {
        List < ws_call__c > lstcall = [Select Id, rq_itm__c, rq_itm__r.RQ__c, rq_jsn__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where Id =: wsCallId];
        if (!lstcall.isEmpty()) {
            HttpResponse response = ccrmStatusUpdate(lstcall[0].rq_jsn__c);
            system.debug('response====434===' + response);
            if (response.getStatusCode() == 200) {
                lstcall[0].res_jsn__c = response.getBody();
                lstcall[0].intsts__c = 'Success';
                update lstcall[0];
            }
        }
    }

    public static String toTitleCase(String phrase) {
        String titlePhrase = '';
        Set < String > forceLower = new Set < String > {
            'of',
            'the',
            'for',
            'and',
            'a',
            'to',
            'at',
            'an',
            'but',
            'if',
            'or',
            'nor'
        };
        if (phrase != null && phrase.length() > 0) {
            String[] splitPhrase = phrase.trim().split(' ');
            for (Integer i = 0; i < splitPhrase.size(); i++) {
                String splitStr = splitPhrase[i].trim();
                if (String.isNotBlank(splitStr)) {
                    Boolean shouldCapitalize = !forceLower.contains(splitStr.toLowerCase()) || i == 0 || i == splitPhrase.size() - 1;
                    if (shouldCapitalize) {
                        if (splitStr.length() == 1) {
                            titlePhrase += splitStr.toUpperCase() + ' ';
                        } else {
                            titlePhrase += splitStr.substring(0, 1).toUpperCase() + splitStr.substring(1).toLowerCase() + ' ';
                        }
                    } else {
                        titlePhrase += splitStr.toLowerCase() + ' ';
                    }
                }
            }
        }
        return titlePhrase.trim();
    }
    public static void LAWSCallCreation(id reqID) {
        Map < String, String > ntmp = new Map < String, String > ();
        List < Country__c > cntLst = [select id, name, cntcrm__c, ntcrm__c from Country__c where ntcrm__c != ''];
        for (Country__c cnt: cntLst) {
            if (String.isNotBlank(cnt.ntcrm__c)) ntmp.put(cnt.name, cnt.ntcrm__c);
        }
        List < g_Req__c > lstreq = [Select id, xcamc__c, xadtx3__c, Name, Acc__c, Acc__r.lc__c, srvc__c, (select id, itm__c, itm__r.dcca_refId__c, itm__r.cd__c from Items__r) from g_Req__c where id =: reqID];
        system.debug(' ====Adhoc-3=== ' + lstreq[0].xadtx3__c);
        if (lstreq != null && lstreq[0].Items__r != null && !(lstreq[0].Items__r).isEmpty() && String.isNotBlank(lstreq[0].xadtx3__c)) {
            Id rqItmID;
            String ddaRefID = '';
            for (g_reqitem__c rqItm: lstreq[0].Items__r) {
                if (!String.IsEmpty(rqItm.itm__r.dcca_refId__c)) {
                    ddaRefID = rqItm.itm__r.dcca_refId__c;
                }
                if (rqItm.itm__r.cd__c == 'ddd') {
                    rqItmID = rqItm.id;
                }
            }
            LARequestWrapper adhoc3Data = (LARequestWrapper) System.JSON.deserialize(lstreq[0].xadtx3__c, LARequestWrapper.class);
            adhoc3Data.serviceRequests[0].serviceId = ddaRefID;
            adhoc3Data.serviceRequests[0].axsRefNo = lstreq[0].Name;
            adhoc3Data.serviceRequests[0].licenseNo = lstreq[0].Acc__r.lc__c;
            map < string, string > channelTitleIdMap = new map < string, string > ();
            if (lstreq[0].xcamc__c.contains('Activity') || lstreq[0].xcamc__c.contains('Segment') || lstreq[0].xcamc__c.contains('Title') || lstreq[0].xcamc__c.contains('Channel')) {
                for (LARequestWrapper.Activities act: adhoc3Data.serviceRequests[0].activities) {
                    if (lstreq[0].xcamc__c.contains('Activity') || lstreq[0].xcamc__c.contains('Segment')) {
                        act.actionType = lstreq[0].xcamc__c.startswith('Add') ? 'ADD' : 'REMOVE';
                    }
                    if (lstreq[0].xcamc__c.contains('Title') || lstreq[0].xcamc__c.contains('Channel')) {
                        for (LARequestWrapper.ChannelTitles objChT: act.channelTitles) {
                            objChT.actionType = lstreq[0].xcamc__c.startswith('Add') ? 'ADD' : 'REMOVE';
                            if (!channelTitleIdMap.containsKey(objChT.name)) {
                                channelTitleIdMap.put(objChT.name, objChT.licensedTitleChannelDdaId);
                            }
                            objChT.licensedTitleChannelDdaId = channelTitleIdMap.get(objChT.name);
                        }
                    }
                } /*if(lstreq[0].xcamc__c.contains('Activity') || lstreq[0].xcamc__c.contains('Segment')){ for (LARequestWrapper.Activities act:adhoc3Data.serviceRequests[0].activities) { act.actionType=lstreq[0].xcamc__c.startswith('Add')?'ADD':'REMOVE'; } } if(lstreq[0].xcamc__c.contains('Title') || lstreq[0].xcamc__c.contains('Channel')){ for (LARequestWrapper.Activities act:adhoc3Data.serviceRequests[0].activities) { for(LARequestWrapper.ChannelTitles objChT:act.channelTitles){ objChT.actionType=lstreq[0].xcamc__c.startswith('Add')?'ADD':'REMOVE'; } } }*/
            }
            SYSTEM.DEBUG('--adhoc3Data--' + adhoc3Data);
            for (LARequestWrapper.Members mem: adhoc3Data.serviceRequests[0].Members) {
                mem.firstNameArabic = ApplicantDetailController.getArabicName(mem.firstName);
                mem.lastNameArabic = ApplicantDetailController.getArabicName(mem.lastName);
                mem.firstName = toTitleCase(mem.firstName);
                mem.lastName = toTitleCase(mem.lastName);
                mem.operatingNameArabic = ApplicantDetailController.getArabicName(mem.operatingName);
                if (ntmp != null && String.isNotBlank(mem.nationality) && ntmp.containsKey(mem.nationality)) {
                    mem.nationality = ntmp.get(mem.nationality);
                }
            }
            String rqJsn = JSON.Serialize(adhoc3Data);
            System.debug('====rqJsn===' + rqJsn);
            ws_call__c wc = new ws_call__c();
            wc.rq_itm__c = rqItmID;
            wc.ws_typ__c = 'License Amendments';
            wc.mtd_nm__c = 'createRequest';
            wc.rq_jsn__c = rqJsn;
            wc.intsts__c = 'Ready for Integration';
            insert wc;
        }
    }
    /***License Amendment WS call End***/

    public class Records {
        public string crmAccId {
            set;
            get;
        }
        public string crmAccName {
            set;
            get;
        }
        public string nameResWorkid {
            set;
            get;
        }
        public string scWorkid {
            set;
            get;
        }
        public string brandWorkid {
            set;
            get;
        }
        public string hseWorkid {
            set;
            get;
        }
        public string requestid {
            set;
            get;
        }
        public string usrName {
            set;
            get;
        }
        public string caseid {
            set;
            get;
        }
        public string oppId {
            set;
            get;
        }
        public string onbReqid {
            set;
            get;
        }
        public string respMsg {
            set;
            get;
        }
        public boolean isSuccess {
            set;
            get;
        }
        public List < Member > members {
            set;
            get;
        }
        public SharesInfo shareDetails {
            set;
            get;
        }
        public List < WorkOrderInfo > workorders {
            set;
            get;
        }

        public string licenseType {
            set;
            get;
        }
        public string dedCompanyName {
            set;
            get;
        }
        public string proposedLegalForm {
            set;
            get;
        }
        public string dedLeaseType {
            set;
            get;
        }
        public string parentCompany {
            set;
            get;
        }
        public string dedActivities {
            set;
            get;
        }
        public string countryOfIncorp {
            set;
            get;
        }
        public string dedLicense {
            set;
            get;
        }
        public string issuingAuthority {
            set;
            get;
        }
        public string ofcAddress {
            set;
            get;
        }
        public string ofcEmail {
            set;
            get;
        }
        public string ofcPhone {
            set;
            get;
        }
        public string ofcCountry {
            set;
            get;
        }
        public string businessName1 {
            set;
            get;
        }
        public string businessName2 {
            set;
            get;
        }
        public string businessName3 {
            set;
            get;
        }
        public string nationality {
            set;
            get;
        }
        public string pcRegNo {
            set;
            get;
        }
        public string pcDOI {
            set;
            get;
        }
        public string fullName;
        public string fullNameAr;
        public string prmFirstName;
        public string prmLastName;
        public string prmEmail;
        public string prmPhone;
        public string prmMobile;
        public string accStatus; /*MS 1.1*/
        public string BusinessPark {
            set;
            get;
        }
        public string StageName {
            set;
            get;
        }
        public string AgNo {
            set;
            get;
        }
        public string crmOppId {
            set;
            get;
        }

        public Date lcExpdate;


        public string ContractStartDate {
            set;
            get;
        }
        public string ContractEndDate {
            set;
            get;
        }
        public string Category {
            set;
            get;
        }
        public string SubCategory {
            set;
            get;
        }
        public string ContractStatus {
            set;
            get;
        }
        public string ContractStatusReason {
            set;
            get;
        }
        public string productName {
            set;
            get;
        }
        public string skipLeaseValidations {
            set;
            get;
        }

        public List < QuoteInfo > quotes {
            set;
            get;
        }
        public List < PaymentSchedules > paymentSchedules {
            set;
            get;
        }
        public List < Invoices > Invoices {
            set;
            get;
        }
        public List < Products > Products {
            set;
            get;
        }
        public List < ActivityInfo > actvities {
            set;
            get;
        }
        public List < Document > documents {
            set;
            get;
        }
        public String shareHoldersType {
            set;
            get;
        }
        public String currentpgid {
            set;
            get;
        }
        public integer noofShares {
            set;
            get;
        }
        public Decimal shareCapital {
            set;
            get;
        }
        public String DDAReqNo {
            set;
            get;
        }
        public String gvtRlsWorkId {
            get;
            set;
        } /* MS 1.1 */
        public Date tdLcStdt {
            get;
            set;
        } /* MS 1.1 added by Meenu to store trade License start date  */
        public Date tdLcEddt {
            get;
            set;
        } /* MS 1.1 added by Meenu  store trade License End date  */
        public String taxRgNo {
            get;
            set;
        } /* MS 1.1added by Meenu  store tax Registration Number  */
        public string productCategory {
            get;
            set;
        } /* MS 1.1 */
        public string addstreet {
            set;
            get;
        } /* MS 1.1 */
        public string adcity {
            set;
            get;
        } /* MS 1.1 */
        public string addState {
            set;
            get;
        } /* MS 1.1 */
        public string addPO {
            set;
            get;
        } /* MS 1.1 */
        public string profceml {
            set;
            get;
        } /* MS 1.1 */
        public string secofceml {
            set;
            get;
        } /* MS 1.1 */
        public string prMobile {
            set;
            get;
        } /* MS 1.1 */
        public string secMobile {
            set;
            get;
        } /* MS 1.1 */
        public string prmccode {
            set;
            get;
        } /* MS 1.1 */
        public string seccode {
            set;
            get;
        } /* MS 1.1 */
        public string accDesc {
            set;
            get;
        } /* MS 1.1 */
        public string compName {
            set;
            get;
        } /* MS 1.1 */
        public string conEmail {
            set;
            get;
        } /* MS 1.1 */
        public string hscResWorkid {
            set;
            get;
        } /* MS 1.1 */
        public String landtype {
            set;
            get;
        } /* MS 1.1 */
        public Decimal landsize {
            set;
            get;
        } /* MS 1.1 */
        public Decimal PowerLoad {
            set;
            get;
        } /* MS 1.1 */
        public Decimal wateramount {
            set;
            get;
        } /* MS 1.1 */
        public Integer BUARange {
            set;
            get;
        } /* MS 1.1 */
        public String MethodName {
            set;
            get;
        } /* MS 1.1 */
        public string axsSrNo {
            set;
            get;
        } /* MS 1.1 */

    }

    public class Document {
        public string name;
        public string description;
        public string ccrmDocId;
        public string ccrmParentId;
        public string ddaDocId;
        public boolean gracePeriod;
        public boolean isCallforReview;
        public boolean isFileAttached;
    }

    public class parCmpDetails {
        public string cntry1 {
            set;
            get;
        }
        public string issuingauth {
            set;
            get;
        }
        public string ofcphone {
            set;
            get;
        }
        public string ofceml {
            set;
            get;
        }
        public string addcity {
            set;
            get;
        }
        /*MS 1.1 */
        public string addstreet {
            set;
            get;
        }
        public string adcity {
            set;
            get;
        }
        public string addState {
            set;
            get;
        }
        public string addPO {
            set;
            get;
        }
        public string profceml {
            set;
            get;
        }
        public string secofceml {
            set;
            get;
        }
        public string prmMobile {
            set;
            get;
        }
        public string secMobile {
            set;
            get;
        }
        public string prmccode {
            set;
            get;
        }
        public string seccode {
            set;
            get;
        }
        public string ofPhCode {
            set;
            get;
        }
    }

    public class Products {
        public string ProductName {
            set;
            get;
        }
        public string LineItemName {
            set;
            get;
        }
        public string UnitNumber {
            set;
            get;
        }

    }

    public class QuoteInfo {
        public String rqtype {
            set;
            get;
        }
        public String quoteName {
            set;
            get;
        }
        public String quoteNo {
            set;
            get;
        }
        public String AgNo {
            set;
            get;
        }
        public String status {
            set;
            get;
        }
        public String quoteId {
            set;
            get;
        }
        public String opportunityId {
            set;
            get;
        }
        public String lsStDt {
            set;
            get;
        }
        public String lsEndDt {
            set;
            get;
        }
        public String requestId {
            set;
            get;
        }
        public String locDet {
            set;
            get;
        }
        public String lsStatus {
            set;
            get;
        }
        public String productName {
            set;
            get;
        }
        public Decimal totalBstRate {
            set;
            get;
        }
        public Decimal totalOfrPrice {
            set;
            get;
        }
        public Decimal totalLandQtAmt {
            set;
            get;
        }
        public List < PaymentSchedules > paymentSchedules {
            set;
            get;
        }
        public Decimal totalDiscount {
            set;
            get;
        }
        public List < Unit > units {
            set;
            get;
        }

    }
    public class Unit {
        public String name {
            set;
            get;
        }
        public String floor {
            set;
            get;
        }
        public String buildingName {
            set;
            get;
        }
        public String productName {
            set;
            get;
        }
        public Decimal area {
            set;
            get;
        }
        public String status {
            set;
            get;
        }
        public Boolean isActive {
            set;
            get;
        }
        public String unitCategory {
            set;
            get;
        }
        public String unitsubCategory {
            set;
            get;
        }
    }

    /*public class PaymentSchedules {
public String schName{set;get;}
public String description{set;get;}
public String chargeFrom{set;get;}
public String chargeTo{set;get;}
public Decimal totalDays{set;get;}
public Decimal billedAmt{set;get;}
}*/
    public List < grqWsOnboard.PaymentSchedules > pymSch {
        get;
        private set;
    }

    public class PaymentSchedules implements Comparable {
        public String Id;
        public String quote {
            get;
            set;
        }
        public Double billedAmount {
            get;
            set;
        }
        public String chargeFrom {
            get;
            set;
        }
        public String chargeTo {
            get;
            set;
        }
        public String description {
            get;
            set;
        }
        public Integer totalDays {
            get;
            set;
        }
        public Double vatAmount {
            get;
            set;
        }
        public Double totalAmountIncludingVat {
            get;
            set;
        }
        public String yearNo {
            get;
            set;
        }
        public String chargeCode {
            get;
            set;
        }
        public String propertyCode {
            get;
            set;
        }
        public String tenantCode {
            get;
            set;
        }
        public String schName {
            set;
            get;
        }
        public Decimal billedAmt {
            set;
            get;
        }
        public string term {
            get;
            set;
        }
        public string dueDate {
            get;
            set;
        } /*MS 1.1*/
        public PaymentSchedules paySc;
        public PaymentSchedules(PaymentSchedules py) {
            paySc = py;
        }
        public Integer compareTo(Object compareTo) {
            PaymentSchedules compareTopaySc = (PaymentSchedules) compareTo;
            Integer returnValue = 0;
            Date d1 = this.dueDate != null ? Date.valueOf(this.dueDate) : system.today(); /*MS 1.1*/
            Date d2 = compareTopaySc.dueDate != null ? Date.valueOf(compareTopaySc.dueDate) : system.today(); /*MS 1.1*/
            if (d1 > d2) {
                returnValue = 1;
            } else if (d1 < d2) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    public class paymentScheduleWrapper {
        public String Id; // 
        public String quote {
            get;
            set;
        } // 
        public Double billedAmount {
            get;
            set;
        } //960602.88
        public String chargeCode {
            get;
            set;
        } //rntoff
        public String chargeFrom {
            get;
            set;
        } //2023-07-01T00:00:00.000Z
        public String chargeTo {
            get;
            set;
        } //2023-09-30T00:00:00.000Z
        public String description {
            get;
            set;
        } //Rental Income - Offi (2 more) ...
        public String propertyCode {
            get;
            set;
        } //d3_b02
        public String tenantCode {
            get;
            set;
        } //t0000549
        public Integer totalDays {
            get;
            set;
        } //91
        public Double vatAmount {
            get;
            set;
        } //48030.14
        public Double totalAmountIncludingVat {
            get;
            set;
        } //1008633.02
        public String yearNo {
            get;
            set;
        } //3
        public String dueDate {
            get;
            set;
        } /*MS 1.1*/
    }


    public class Invoices {
        public string InvoiceId {
            set;
            get;
        }
        public string InvoiceName {
            set;
            get;
        }
        public string InvoiceDueDate {
            set;
            get;
        }
        public string InvoiceType {
            set;
            get;
        }
        public Decimal Amount {
            set;
            get;
        }
        public Decimal Vat {
            set;
            get;
        }
        public Decimal InvoiceAmount {
            set;
            get;
        }
    }

    public class Member {
        public string ctg {
            set;
            get;
        }
        public string salutation {
            set;
            get;
        }
        public string fname {
            set;
            get;
        }
        public string fnameAr {
            set;
            get;
        }
        public string lname {
            set;
            get;
        }
        public string lnameAr {
            set;
            get;
        }
        public string mname {
            set;
            get;
        }
        public string dob {
            set;
            get;
        }
        public string isParentComp {
            set;
            get;
        } /* for parent company ubo Branch case -vmkr */
        public string corpORind {
            set;
            get;
        }
        public string address {
            set;
            get;
        }
        public string passportNo {
            set;
            get;
        }
        public string email {
            set;
            get;
        }
        public string nationality {
            set;
            get;
        }
        public string mobile {
            set;
            get;
        }
        public string sh {
            set;
            get;
        }
        public string role {
            set;
            get;
        }
        public string conid {
            set;
            get;
        }
        public boolean security {
            set;
            get;
        }
        public string ctgCode {
            set;
            get;
        }
        public string ctgCode1 {
            set;
            get;
        }
        public string cshType {
            set;
            get;
        }
        public string pIssuedDate;
        public string pExpDate;
        public string eid;
        public string eidExp;
        public string eExpDate;
        public string rpNo;
        public string rpExpDate;
        public string passportId;
        public string gender;
        public string contryCode;
        public string uboType;
        public string legals;
        public boolean stockExchangeListed;
        public string uboException;
        public string iAuthority;
        public string website;
        public string fda;
        public boolean uboDeclaration;
        public boolean uboOwnedbyUAE;
        public string uboRelatedTo;
        public string rRegNum;
        public string actingAsNomineeShareholder {
            set;
            get;
        }
        public string actingAsNomineeDirector {
            set;
            get;
        }


        public string placeissued;
        public string birthplace;
        public string placeborn;
        public String mailingStreet;
        public String mailingCity;
        public String mailingCountry;
        public String mailingPostalCode;
        public String street;
        public String city;
        public String country;
        public string Area;
        public string cityIn;
        public string emirate;
        public string inUAE;
        /*MS 1.1 starts*/
        public string emiratesIdIssueDate {
            set;
            get;
        }
        public string visitedUAE;
        public string citizenOrResident {
            set;
            get;
        }
        public string birthCountry {
            set;
            get;
        }
        /*MS 1.1 Ends*/


        public String postalCode;
        public string phoneno;
        public string fullName {
            set;
            get;
        }
        public string pepAssociation {
            set;
            get;
        }
        public List < String > pepRelated {
            set;
            get;
        }
        public String pepCloselyRelatedOthers {
            set;
            get;
        }
        public String pepCloselyAssociatedOthers {
            set;
            get;
        }
        public string pepCountry {
            set;
            get;
        }
        public List < sourceOfFundWealth > sourceOfwealth {
            set;
            get;
        }
    }
    public class FLValidate {
        public String methodname;
        public FLInfo data;
    }
    public class FLInfo {
        public String firstName;
        public String lastName;
        public String birthdate;
        public String passportNumber;
        public String country;
        public String licenseNum;
        public String responseDetails;
        public Boolean isLicenseIssued;

    }
    public class StatusUpdate {
        public String methodName;
        public List < RecInfo > data;
    }
    public class RecInfo {
        public String workOrderId;
        public string ccrmContactId;
        public String oraclePartyId;
        public String status;
        public String description;
        public String typeOfShareHolder;
        public String salutation;
        public String registrationNo;
        public String role;
        public String passportNo;
        public String passportIssueDate;
        public String passportExpiryDate;
        public String nationality;
        public String firstName;
        public String middleName;
        public String lastName;
        public String firstNameArabic;
        public String middleNameArabic;
        public String lastNameArabic;
        public String gender;
        public String email;
        public Boolean isEmailVerified {
            get;
            set;
        }
        public DateTime emailVerificationDatetime {
            get;
            set;
        }
        public Boolean VisitedUAE {
            get;
            set;
        }
        public String birthCountry {
            get;
            set;
        }
        public String birthDate;
        public String dateOfIncorporation;
        public integer noofshares;
        public boolean isSecurityClearanceRequired = false;
        public String mobilePhone;
        public Boolean isMobilePhoneVerified {
            get;
            set;
        }
        public DateTime mobilePhoneVerificationDatetime {
            get;
            set;
        }
        public String phone;
        public Boolean isPhoneVerified {
            get;
            set;
        }
        public DateTime phoneVerificationDateTime {
            get;
            set;
        }
        public String passportPlaceOfIssue;
        public String placeOfBirth;
        public String mailingStreet;
        public String mailingCity;
        public String mailingPostalCode;
        public string documentId;
        public boolean isSuccess;
        public String inorOut;
        public String emiratesId;
        public String leadId;

    }
    public class DocumentInfo {
        public string recid;
        public string accid;
        public string docName;
        public string fileName;
        public string fileType;
        public string fileBody;
        public string woid; /*MS 1.1*/
    }
    public class WorkOrderInfo {
        public string recid;
        public string status;
        public string recType;
        public string parentid;
        public string ddaRequestId;
        public list < Member > members;
    }
    public class ActivityInfo {
        public string name;
        public string actId;
        public string price {
            get;
            set;
        }
        public string vatAmount {
            get;
            set;
        }
        public string totalPrice {
            get;
            set;
        }
        public string title;
        public string channel;
        public list < String > docs;
        public string segment;
        Public ActivityInfo(string nm, string activityId) {
            name = nm;
            actId = activityId;
        }

        public string term {
            get;
            set;
        }
        public String chargeCode {
            get;
            set;
        }
        public String propertyCode {
            get;
            set;
        }
        public String tenantCode {
            get;
            set;
        }
        public String chargeFrom {
            get;
            set;
        }
        public String chargeTo {
            get;
            set;
        }
        public String description {
            get;
            set;
        }
    }
    public class SegmentInfo {
        public string name;
        public string segId;
        public string price;
        public string allowed;
        public List < ActivityInfo > SegActivities;

        public string vatAmount {
            get;
            set;
        }
        public string totalPrice {
            get;
            set;
        }
        public string term {
            get;
            set;
        }
        public String chargeCode {
            get;
            set;
        }
        public String propertyCode {
            get;
            set;
        }
        public String tenantCode {
            get;
            set;
        }
        public String chargeFrom {
            get;
            set;
        }
        public String chargeTo {
            get;
            set;
        }

    }
    public class StatusRequest {
        public string recordId;
        public string requestId;
        public string accid;
        public string status;
        public string description;
        public string objectType;
        public string businessName1 {
            set;
            get;
        }
        public string businessName2 {
            set;
            get;
        }
        public string businessName3 {
            set;
            get;
        }
        public string parentCompany {
            set;
            get;
        }
        public string pcRegNo {
            set;
            get;
        }
        public String nationality {
            set;
            get;
        }
        public string pcDOI {
            set;
            get;
        }
        public List < ActivityInfo > actvities {
            set;
            get;
        }
    }
    public class SharesInfo {
        public integer totalShares;
        public integer shareValue;
    }

    public class ActInfo {
        public String actName;
        public String segName;
    }
    Public class ShareInfo {
        public string role;
        public string name;
        public string nameAr;
        public string nt;
        public string ntAr;
        public decimal noSh;
        public decimal ttlValSh;
        public decimal shper;

        public string email;
        public string mobile;


    }
    public class MemberInfo {
        public string role;
        public string name;
        public string nameAr;
        public string nt;
        public string ntAr;
        public string regNo;
        public string email;
        public string mobile;



    }

    Public class AccInfo {
        public String accName;
        public String accNameAr;
        public String accOpName;
        public String accOpNameAr;
        public String lgFrm;
        public String licNo;
        public String licFrstIssDt;
        public String licIssDt;
        public String licExpDt;
        public string curTyp;
        public decimal shVal;
        public decimal noOfSh;
        public decimal ttlShval;
        public List < MemberInfo > mbLst;
        public List < ShareInfo > shLst;
        public List < ActInfo > actLst;

    }
    public class sourceofFundWealth {
        public string incomeSource {
            set;
            get;
        }
        public string detail {
            set;
            get;
        }
        public string incomeCountry {
            set;
            get;
        }
    }


}
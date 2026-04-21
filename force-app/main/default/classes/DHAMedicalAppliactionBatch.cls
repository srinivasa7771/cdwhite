global class DHAMedicalAppliactionBatch implements Database.Batchable < sObject > , Database.AllowsCallouts, Schedulable {
    String query = '';
    global DHAMedicalAppliactionBatch() {
        DateTime dt = Datetime.now();
        query = 'SELECT Id,Prioirty__c,rq_itm__r.RQ__r.xcp__c,rq_itm__r.RQ__r.e__c,rq_itm__r.itm__c,rq_itm__r.RQ__r.xui__c,rq_itm__r.RQ__r.xcslt__c,res_jsn__c,intsts__c,mtd_nm__c,rq_itm__r.sta__r.cd__c,rq_itm__r.RQ__r.Con__r.rol__c,rq_itm__r.RQ__r.Con__r.e__c,rq_itm__r.xf__c,rq_itm__r.RQ__r.srvc__c,rq_itm__r.sta__r.Next_Status__c,rq_itm__r.sta__r.Next_Status__r.xcsits__c,rq_itm__c,xrno__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.xceidid__c,rq_itm__r.RQ__r.Con__r.rp__c,rq_itm__r.RQ__r.Con__r.Name,rq_itm__r.RQ__r.Con__r.flnm__c,rq_itm__r.RQ__r.Con__r.FlnAr__c,rq_itm__r.RQ__r.Con__r.Account.Name,rq_itm__r.RQ__r.Con__r.Account.on__c,rq_itm__r.RQ__r.Con__r.Account.onar__c,rq_itm__r.RQ__r.Con__r.Job_Title_Formula__c,rq_itm__r.RQ__r.Con__r.jbar__c,rq_itm__r.RQ__r.Con__r.jb__r.cd__c,rq_itm__r.RQ__r.Con__r.nc__c,rq_itm__r.RQ__r.Con__r.p__c,rq_itm__r.RQ__r.Con__r.ped__c,rq_itm__r.RQ__r.Con__r.Gender__c,rq_itm__r.RQ__r.Con__r.Birthdate,rq_itm__r.RQ__r.Con__r.HomePhone,rq_itm__r.RQ__r.Con__r.strt__c,rq_itm__r.RQ__r.Con__r.Email,rq_itm__r.RQ__r.Con__r.MobilePhone,rq_itm__r.RQ__r.Con__r.eidid__c,rq_itm__r.RQ__r.Con__r.rpui__c,rq_itm__r.RQ__r.srvc__r.uid__c,rq_itm__r.RQ__r.Con__r.Photo_ID__c,rq_itm__r.exp__c  From ws_call__c where ws_typ__c = \'DHA Medical\' AND mtd_nm__c in (\'newDHA\',\'createApplication\',\'upgradeApplication\')  AND intsts__c =\'Ready for Integration\'AND rq_itm__r.AD__c<=0 and (sdt__c <=:dt or isRI__c=true or rq_itm__r.RQ__r.expflg__c=true) ORDER BY createdDate';

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime dt = Datetime.now();
        return Database.getQueryLocator(query);
    }

    global DHAMedicalAppliactionBatch(String wsid) {
        query = 'SELECT Id,Prioirty__c,rq_itm__r.RQ__r.xcp__c,rq_itm__r.RQ__r.e__c,rq_itm__r.itm__c,rq_itm__r.RQ__r.xui__c,rq_itm__r.RQ__r.xcslt__c,res_jsn__c,intsts__c,mtd_nm__c,rq_itm__r.sta__r.cd__c,rq_itm__r.RQ__r.Con__r.rol__c,rq_itm__r.RQ__r.Con__r.e__c,rq_itm__r.xf__c,rq_itm__r.RQ__r.srvc__c,rq_itm__r.sta__r.Next_Status__c,rq_itm__r.sta__r.Next_Status__r.xcsits__c,rq_itm__c,xrno__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.xceidid__c,rq_itm__r.RQ__r.Con__r.rp__c,rq_itm__r.RQ__r.Con__r.Name,rq_itm__r.RQ__r.Con__r.flnm__c,rq_itm__r.RQ__r.Con__r.FlnAr__c,rq_itm__r.RQ__r.Con__r.Account.Name,rq_itm__r.RQ__r.Con__r.Account.on__c,rq_itm__r.RQ__r.Con__r.Account.onar__c,rq_itm__r.RQ__r.Con__r.Job_Title_Formula__c,rq_itm__r.RQ__r.Con__r.jbar__c,rq_itm__r.RQ__r.Con__r.jb__r.cd__c,rq_itm__r.RQ__r.Con__r.nc__c,rq_itm__r.RQ__r.Con__r.p__c,rq_itm__r.RQ__r.Con__r.ped__c,rq_itm__r.RQ__r.Con__r.Gender__c,rq_itm__r.RQ__r.Con__r.Birthdate,rq_itm__r.RQ__r.Con__r.HomePhone,rq_itm__r.RQ__r.Con__r.strt__c,rq_itm__r.RQ__r.Con__r.Email,rq_itm__r.RQ__r.Con__r.MobilePhone,rq_itm__r.RQ__r.Con__r.eidid__c,rq_itm__r.RQ__r.Con__r.rpui__c,rq_itm__r.RQ__r.srvc__r.uid__c,rq_itm__r.RQ__r.Con__r.Photo_ID__c,rq_itm__r.exp__c  From ws_call__c where id= \'' + wsid + '\'';

    }

    global void execute(Database.BatchableContext BC, List < ws_call__c > scope) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < g_reqitem__c > rqItmList = new List < g_reqitem__c > ();
        List < g_req__c > reqList = new List < g_req__c > ();
        List < Attachment > attLst = new List < Attachment > ();
        List < String > rnSrvCdLst = (Label.DHA_ReNew_Srvcd).split(';');
        Map < String, String > inputHttpHeaders_x = new Map < String, String > ();
        Boolean dhaNewFlg = gu.csBool('DHA_New_Enabled');
        AXSDHA.DHASalemFreeZoneToConsoleHttpsSoap11Endpoint cls = new AXSDHA.DHASalemFreeZoneToConsoleHttpsSoap11Endpoint();
        AXSNewDHA.DHAFreezonesToConsolServiceHttpSoap11Endpoint newcls = new AXSNewDHA.DHAFreezonesToConsolServiceHttpSoap11Endpoint();
        String base64Str = '';
        String NEW_VISA = '7';
        String RENEW_VISA = '1'; /*String gender = '';*/
        String applicationNo = '';
        String urgency = gU.csStr('gdhreg');
        string countryCode = '';
        string countryid = '';
        String countryAr = '', eidaNo = '', residencyNo = '', rpUID = '', nameEn = '', nameAr = '', sponNameAr = '', jobtitle = '', jobAr = '', jobcd = '', gender = '', personType = '', visaType = '', pno = '';
        for (ws_call__c ws: scope) {
            if (ws.intsts__c == 'Ready for Integration' && (ws.rq_itm__r.sta__r.cd__c == 'n' || ws.rq_itm__r.sta__r.cd__c == 'rv' || ws.rq_itm__r.sta__r.cd__c == 'v') && (ws.mtd_nm__c == 'newDHA' || ws.mtd_nm__c == 'createApplication')) {
                try {
                    if (dhaNewFlg) {
                        inputHttpHeaders_x.put('x-gateway-apikey', gu.csStr('DHA_FZ_APIKEY_New'));
                        newcls.inputHttpHeaders_x = inputHttpHeaders_x;
                    } else {
                        AXSDHA.Timestamp t = new AXSDHA.Timestamp();
                        t.Created = system.now();
                        t.Expires = System.now().addMinutes(5);
                        AXSDHA.UsernameToken u = new AXSDHA.UsernameToken();
                        u.username = gU.csStr('DHA_USR');
                        u.password = gU.csStr('DHA_PASS');
                        AXSDHA.Security hd = new AXSDHA.Security();
                        hd.usernameToken = u;
                        hd.TimeStamp = t;
                        cls.Header = hd; /* if(ws.rq_itm__r.RQ__r.Con__r.Gender__c == 'Male') gender = 'Male'; else gender = 'Female';  */
                    }
                    if (ws.rq_itm__r.exp__c || ws.Prioirty__c == 'Express') urgency = gU.csStr('gdhexp');
                    ws.intsts__c = 'Failed';
                    eidaNo = ws.rq_itm__r.RQ__r.Con__r.eidid__c;
                    nameAr = ws.rq_itm__r.RQ__r.Con__r.FlnAr__c;
                    sponNameAr = ws.rq_itm__r.RQ__r.Con__r.Account.onar__c;
                    jobtitle = ws.rq_itm__r.RQ__r.Con__r.Job_Title_Formula__c;
                    jobAr = ws.rq_itm__r.RQ__r.Con__r.jbar__c;
                    jobcd = ws.rq_itm__r.RQ__r.Con__r.jb__r.cd__c;
                    gender = ((ws.rq_itm__r.RQ__r.Con__r.Gender__c != null && ws.rq_itm__r.RQ__r.Con__r.Gender__c != '[N/A]') ? ws.rq_itm__r.RQ__r.Con__r.Gender__c : (ws.rq_itm__r.RQ__r.xcslt__c == 'Mr.' ? 'Male' : 'Female'));
                    if (String.isBlank(jobtitle)) {
                        if (ws.rq_itm__r.RQ__r.Con__r.rol__c == 'Student' || ws.rq_itm__r.RQ__r.Con__r.rol__c == 'Child') {
                            jobtitle = 'Student';
                            jobAr = 'طالب';
                            jobcd = '9900015';
                        } else if (ws.rq_itm__r.RQ__r.Con__r.rol__c == 'Spouse' && gender == 'Male') {
                            jobtitle = 'Muhrem';
                            jobAr = 'محرم';
                            jobcd = '9900025';
                        } else if (ws.rq_itm__r.RQ__r.Con__r.rol__c == 'Spouse' && gender == 'Female') {
                            jobtitle = 'House Wife';
                            jobAr = 'ربه بيت';
                            jobcd = '9900011';
                        }
                    }
                    Date dt = Date.today();
                    if (ws.rq_itm__r.RQ__r.Con__r.ped__c != null && ws.rq_itm__r.RQ__r.Con__r.ped__c < dt && String.isNotBlank(ws.rq_itm__r.RQ__r.xcp__c)) pno = ws.rq_itm__r.RQ__r.xcp__c.replaceAll('[^a-zA-Z0-9\\s]', '').replaceAll('\\s+', '').toUpperCase();
                    else pno = ws.rq_itm__r.RQ__r.Con__r.p__c.replaceAll('[^a-zA-Z0-9\\s]', '').replaceAll('\\s+', '').toUpperCase();
                    if (ws.mtd_nm__c == 'newDHA') {
                        residencyNo = ws.rq_itm__r.RQ__r.Con__r.e__c;
                        personType = NEW_VISA; /*7*/
                        visaType = 'New Visa';
                    } else {
                        if (rnSrvCdLst.contains(ws.rq_itm__r.RQ__r.srvc__r.uid__c)) residencyNo = ws.rq_itm__r.RQ__r.e__c;
                        else residencyNo = ws.rq_itm__r.RQ__r.Con__r.rp__c;
                        personType = RENEW_VISA; /*1*/
                        visaType = 'Renew Visa';
                    }
                    if (rnSrvCdLst.contains(ws.rq_itm__r.RQ__r.srvc__r.uid__c)) {
                        rpUID = ws.rq_itm__r.RQ__r.xui__c;
                    } else {
                        rpUID = ws.rq_itm__r.RQ__r.Con__r.rpui__c;
                    }
                    list < Country__c > cnList = [select id, CnCd__c, CnId__c, CnAr__c, Name, Country_DHA__c from Country__c where name =: ws.rq_itm__r.RQ__r.Con__r.nc__c];
                    if (cnList != null && !cnList.isEmpty()) {
                        countryCode = cnList[0].Country_DHA__c;
                        countryid = cnList[0].CnId__c;
                        countryAr = cnList[0].CnAr__c;
                    }
                    if (ws.rq_itm__r.RQ__r.Con__r.eidid__c == null || String.isBlank(ws.rq_itm__r.RQ__r.Con__r.eidid__c)) {
                        for (g_reqitem__c ri: [select id, sta__c, xceidid__c from g_reqitem__c where rq__c =: ws.rq_itm__r.RQ__c and itm__r.cd__c = 'ia']) {
                            eidaNo = ri.xceidid__c;
                        }
                    }
                    if (eidaNo == null || String.isBlank(eidaNo)) {
                        eidaNo = ws.rq_itm__r.RQ__r.xceidid__c;
                    } /*if (ws.rq_itm__r.RQ__r.Con__r.Photo_ID__c != null && String.isNotBlank(ws.rq_itm__r.RQ__r.Con__r.Photo_ID__c)) { */
                    List < String > photoDocLst = Label.DHA_Photo_Docs.split(';');
                    attLst = [select id, body from Attachment where parentid in (select id from g_reqDoc__c where RQ__c =: ws.rq_itm__r.RQ__c and name in: photoDocLst) order by createddate desc limit 1]; /*base64Str = EncodingUtil.base64Encode(attLst[0].Body); */
                    if (attLst != null && !attLst.isEmpty()) {
                        base64Str = EncodingUtil.base64Encode(attLst[0].Body); /*base64Str = convertDoc(EncodingUtil.base64Encode(attLst[0].Body));*/
                    } /*}*/
                    String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
                    nameEn = ws.rq_itm__r.RQ__r.Con__r.flnm__c;
                    if (String.isNotBlank(nameEn)) {
                        nameEn = nameEn.replaceAll('[^a-zA-Z\\s+]', '');
                    }
                    if (String.isNotBlank(nameEn) && (String.isBlank(nameAr) || (nameAr != null && nameAr.trim().length() <= 1))) {
                        nameAr = GDRFAUtil.engToArabicStr(nameEn, gApiToken);
                    }
                    if (String.isNotBlank(ws.rq_itm__r.RQ__r.Con__r.Account.Name) && (String.isBlank(sponNameAr) || (sponNameAr != null && sponNameAr.trim().length() <= 1))) {
                        sponNameAr = GDRFAUtil.engToArabicStr(ws.rq_itm__r.RQ__r.Con__r.Account.Name, gApiToken);
                    }
                    if (dhaNewFlg) applicationNo = newcls.createApplication(residencyNo, nameEn, nameAr, ws.rq_itm__r.RQ__r.Con__r.Account.Name, sponNameAr, jobtitle, jobAr, jobcd, countryCode, countryAr, countryid, pno, base64Str, gender, String.valueOf(ws.rq_itm__r.RQ__r.Con__r.Birthdate), '0525454568', '043911111', ((ws.rq_itm__r.RQ__r.Con__r.strt__c != null && ws.rq_itm__r.RQ__r.Con__r.strt__c != '') ? ws.rq_itm__r.RQ__r.Con__r.strt__c : 'Dubai'), 'دبي', gU.csStr('gdhem'), '0525454568', eidaNo, rpUID, gU.csStr('gdhsptp'), visaType, personType, urgency, gU.csStr('gdhcntr'), gU.csStr('gdhpkg'), '', gU.csStr('gdhfzorg'));
                    else applicationNo = cls.createApplication(residencyNo, nameEn, nameAr, ws.rq_itm__r.RQ__r.Con__r.Account.Name, sponNameAr, jobtitle, jobAr, jobcd, countryCode, countryAr, countryid, pno, base64Str, gender, String.valueOf(ws.rq_itm__r.RQ__r.Con__r.Birthdate), '0525454568', '043911111', ((ws.rq_itm__r.RQ__r.Con__r.strt__c != null && ws.rq_itm__r.RQ__r.Con__r.strt__c != '') ? ws.rq_itm__r.RQ__r.Con__r.strt__c : 'Dubai'), 'دبي', gU.csStr('gdhem'), '0525454568', eidaNo, rpUID, gU.csStr('gdhsptp'), visaType, personType, urgency, gU.csStr('gdhcntr'), gU.csStr('gdhpkg'), '', gU.csStr('gdhfzorg'));
                    system.debug('#######################3');
                    system.debug(applicationNo);
                    system.debug('#######################3');
                    ws.res_jsn__c = applicationNo;
                } catch (Exception e) {
                    String expMsg = e.getMessage();
                    if (String.isNotBlank(expMsg) && expMsg.contains('DUPLICATE_ENTRY_FOUND faultcode=')) {
                        applicationNo = expMsg.substringBetween('Web service callout failed: WebService returned a SOAP Fault: DUPLICATE_ENTRY_FOUND faultcode=', 'faultactor=');
                        if (String.isNotBlank(applicationNo)) {
                            applicationNo = applicationNo.trim();
                            ws.intsts__c = 'Success';
                            ws.res_jsn__c = applicationNo;
                        } else {
                            ws.intsts__c = 'Failed';
                            ws.res_jsn__c = e.getMessage();
                        }
                    } else if (String.isNotBlank(expMsg) && expMsg.contains('Applicant has already an application in progress')) {
                        applicationNo = expMsg.substringBetween('Web service callout failed: WebService returned a SOAP Fault: Applicant has already an application in progress :', ' with status : In Process faultcode=S:Server faultactor=');
                        if (String.isNotBlank(applicationNo)) {
                            applicationNo = applicationNo.trim();
                            ws.intsts__c = 'Success';
                            ws.res_jsn__c = applicationNo;
                        } else {
                            ws.intsts__c = 'Failed';
                            ws.res_jsn__c = e.getMessage();
                        }
                    } else if (String.isNotBlank(expMsg) && expMsg.contains('PHOTO_SIZE_IS_TOO_BIG faultcode=')) {
                        try {
                            base64Str = convertDoc(EncodingUtil.base64Encode(attLst[0].Body));
                            if (dhaNewFlg) applicationNo = newcls.createApplication(residencyNo, nameEn, nameAr, ws.rq_itm__r.RQ__r.Con__r.Account.Name, sponNameAr, jobtitle, jobAr, jobcd, countryCode, countryAr, countryid, pno, base64Str, gender, String.valueOf(ws.rq_itm__r.RQ__r.Con__r.Birthdate), '0525454568', '043911111', ((ws.rq_itm__r.RQ__r.Con__r.strt__c != null && ws.rq_itm__r.RQ__r.Con__r.strt__c != '') ? ws.rq_itm__r.RQ__r.Con__r.strt__c : 'Dubai'), 'دبي', gU.csStr('gdhem'), '0525454568', eidaNo, rpUID, gU.csStr('gdhsptp'), visaType, personType, urgency, gU.csStr('gdhcntr'), gU.csStr('gdhpkg'), '', gU.csStr('gdhfzorg'));
                            else applicationNo = cls.createApplication(residencyNo, nameEn, nameAr, ws.rq_itm__r.RQ__r.Con__r.Account.Name, sponNameAr, jobtitle, jobAr, jobcd, countryCode, countryAr, countryid, pno, base64Str, gender, String.valueOf(ws.rq_itm__r.RQ__r.Con__r.Birthdate), '0525454568', '043911111', ((ws.rq_itm__r.RQ__r.Con__r.strt__c != null && ws.rq_itm__r.RQ__r.Con__r.strt__c != '') ? ws.rq_itm__r.RQ__r.Con__r.strt__c : 'Dubai'), 'دبي', gU.csStr('gdhem'), '0525454568', eidaNo, rpUID, gU.csStr('gdhsptp'), visaType, personType, urgency, gU.csStr('gdhcntr'), gU.csStr('gdhpkg'), '', gU.csStr('gdhfzorg'));
                            ws.res_jsn__c = applicationNo;
                            ws.intsts__c = 'Success';
                        } catch (Exception ex) {
                            ws.intsts__c = 'Failed';
                            ws.res_jsn__c = ex.getMessage();
                        }
                    } else {
                        ws.intsts__c = 'Failed';
                        ws.res_jsn__c = e.getMessage();
                    }
                    system.debug('ex::' + e.getStackTraceString());
                }
                if (applicationNo != '') {
                    /*system.debug('xcsits::' + ws.rq_itm__r.sta__r.Next_Status__r.xcsits__c);*/
                    String nxtstsId = '';
                    if (String.isBlank(ws.rq_itm__r.sta__r.Next_Status__c)) {
                        nxtstsId = GDRFAUtil.statusId('fi', ws.rq_itm__r.itm__c);
                    } else nxtstsId = ws.rq_itm__r.sta__r.Next_Status__c;
                    rqItmList.add(new g_reqitem__c(id = ws.rq_itm__c, sta__c = nxtstsId, xf__c = applicationNo, xfid__c = date.today(), xfed__c = date.today().addMonths(2)));
                    ws.intsts__c = 'Success'; /*system.debug('xcsits1::' + ws.rq_itm__r.sta__r.Next_Status__r.xcsits__c);*/
                    if (String.isNotBlank(nxtstsId)) {
                        List < g_srvcitm_Status__c > stsLst = [SELECT Id, xcsits__c FROM g_srvcitm_Status__c WHERE id =: nxtstsId];
                        if (stsLst != null && !stsLst.isEmpty() && String.isNotBlank(stsLst[0].xcsits__c)) {
                            List < String > lst = stsLst[0].xcsits__c.split(';');
                            Map < String, String > itmMp = new Map < String, String > ();
                            Map < String, String > stsMp = new Map < String, String > ();
                            for (String str: lst) itmMp.put(str.split(':')[0], str.split(':')[1]);
                            system.debug('itmMp::' + itmMp);
                            for (g_srvcitm_Status__c sts: [select id, cd__c, uid__c from g_srvcitm_Status__c where itm__r.srvc__c =: ws.rq_itm__r.RQ__r.srvc__c and itm__r.cd__c =: itmMp.keySet() and cd__c =: itmMp.values()]) stsMp.put(sts.uid__c, sts.id);
                            system.debug('stsMp::' + stsMp);
                            system.debug('ws.xrno__c::' + ws.xrno__c);
                            for (g_reqitem__c ri: [select id, sta__c, itm__r.cd__c, itm__r.uid__c from g_reqitem__c where rq__c =: ws.rq_itm__r.RQ__c and itm__r.cd__c =: itmMp.keySet()]) {
                                String stsCode = itmMp.get(ri.itm__r.cd__c);
                                system.debug('stsCode::' + stsCode + ':' + ri.itm__r.cd__c + stsCode);
                                rqItmList.add(new g_reqitem__c(id = ri.id, sta__c = stsMp.get(ri.itm__r.uid__c + stsCode)));
                            }
                            system.debug('rqItmList::' + rqItmList);
                        }
                    }
                    reqList.add(new g_req__c(id = ws.rq_itm__r.RQ__c, STA__c = 'In Process'));
                }
                wsList.add(ws);
            }
            if (ws.intsts__c == 'Ready for Integration' && ws.mtd_nm__c == 'upgradeApplication') {
                AXSDHA.UpgradePackageResponse_element res = upgradePackage(ws.rq_itm__r.xf__c);
                if (res != null && res.ResponseCode == '00') {
                    ws.intsts__c = 'Success';
                } else {
                    ws.intsts__c = 'Failed';
                    ws.err_cd__c = res.ResponseCode;
                    ws.err_msg__c = res.ResponseDescription;
                }
                wsList.add(ws);
            }
        }
        if (wsList.size() > 0) {
            update wsList;
        }
        if (rqItmList.size() > 0) {
            update rqItmList;
        }
        if (reqList.size() > 0) {
            update reqList;
        }
    }
    global void finish(Database.BatchableContext BC) {}
    @TestVisible private AXSDHA.UpgradePackageResponse_element upgradePackage(String appNo) {
        AXSDHA.UpgradePackageResponse_element res = null;
        try {
            AXSDHA.Timestamp t = new AXSDHA.Timestamp();
            t.Created = system.now();
            t.Expires = System.now().addMinutes(5);
            AXSDHA.UsernameToken u = new AXSDHA.UsernameToken();
            u.username = gU.csStr('DHA_USR');
            u.password = gU.csStr('DHA_PASS');
            AXSDHA.Security hd = new AXSDHA.Security();
            hd.usernameToken = u;
            hd.TimeStamp = t;
            AXSDHA.DHASalemFreeZoneToConsoleHttpsSoap11Endpoint cls = new AXSDHA.DHASalemFreeZoneToConsoleHttpsSoap11Endpoint();
            cls.Header = hd;
            res = cls.upgradePackage(appNo, gU.csStr('gdhexp'), gU.csStr('gdhfzorg'));

        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
        }
        return res;
    }
    public String convertDoc(String base64Str) {
        String convStr = '';
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"');
        req.setHeader('Apikey', Label.GDRFAConvertAPIKey);
        String endpointUrl = 'https://v2.convertapi.com/convert/jpeg/to/jpg?Secret=' + Label.GDRFAConvertAPISecret;
        req.setTimeout(90000);
        req.setMethod('POST');
        req.setEndpoint(endpointUrl);
        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"my_file.jpeg","Data":"' + base64Str + '"}},{ "Name": "ImageResolution", "Value": "200" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "355" }, { "Name": "ImageWidth", "Value": "300" }, { "Name": "ImageQuality", "Value": "50" },{"Name":"StoreFile","Value":false}]}');
        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug('res : ' + res.getBody());
        if (res.getStatusCode() == 200) {
            DocumentConversionWrapper dcw = DocumentConversionWrapper.parse(res.getBody());
            if (dcw.Files != null && !dcw.Files.isEmpty()) {
                convStr = dcw.Files[0].FileData;
            }
        }

        return convStr;

    }
    public void execute(SchedulableContext sc) {
        DHAMedicalAppliactionBatch b = new DHAMedicalAppliactionBatch();
        database.executebatch(b, 1);
    }

}
public class CTRLCustProfileUpdate1 extends pgBsCtrl {
    public List < mdWrapper.IdentityInfo > infoList {
        get;
        set;
    }
    public List < mdWrapper > mdList {
        get;
        set;
    }
    public Boolean isgu {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }
    public g_req__c req {
        get;
        set;
    }
    public String memPP {
        get;
        set;
    }
    public string selectedValue {
        get;
        set;
    }
    public string pageUrl {
        get;
        set;
    }
    public gctlRequ componentOne {
        get;
        set;
    }
    public String responseBody {
        get;
        set;
    }
    public String memId {
        get;
        set;
    }
    public user usr {
        get;
        set;
    }
    public String reqId {
        get;
        set;
    }
    public string sid {
        get;
        set;
    }
    public mdWrapper.IdentityInfo info {
        get;
        set;
    }
    public mdWrapper.IdentityInfo infoUpdated {
        get;
        set;
    }
    public g_Srvc__c srv {
        get;
        set;
    }
    public String docName {
        get;
        set;
    }
    public transient String imageBase64 {
        get;
        set;
    }
    public List < g_reqDoc__c > rdocList {
        set;
        get;
    }
    public String ppAttId {
        get;
        set;
    }
    public String EIDAttId {
        get;
        set;
    }
    public String RICAttId {
        get;
        set;
    }
    public String draftIns {
        get;
        set;
    }
    public String draftMsg {
        get;
        set;
    }
    public String bckOfcCmts {
        get;
        set;
    }
    public boolean showData {
        get;
        set;
    }
    public Map < String, mdWrapper.IdentityInfo > infoListMap {
        get;
        set;
    }
    public List < g_srvcitm_Status__c > stsList {
        get;
        set;
    }
    public boolean showedit {
        get;
        set;
    }
    public map < string, mdWrapper.IdentityInfo > mapInfo {
        get;
        set;
    }
    public CTRLCustProfileUpdate1() {
        stsList = [select id from g_srvcitm_Status__c where itm__r.cd__c = 'ma'
            and cd__c in ('v', 'c') order by cd__c desc
        ];
        reqId = apexpages.currentpage().getparameters().get('id');
        sid = apexpages.currentpage().getparameters().get('sid');
        ispu = gU.isPortalUser(UserInfo.getProfileId());
        isgu = gU.isGuestUser(UserInfo.getProfileId());
        draftMsg = '';
        bckOfcCmts = '';
        if (reqId != null) {
            system.debug('reqId:::' + reqId);
            req = [select Id, xceml__c, rmob__c, xcs__c, acc__r.id, Acc__r.Legal_Framework__c, Srvc__r.sdg__c, Srvc__r.sdg__r.sd__c, Srvc__r.sdg__r.ptype__c, acc__r.name, srvc__c, sta__c, xdmpn__c, srvc__r.uid__c, srvc__r.Name, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.AddOnSrv__c, srvc__r.stg__r.reqq__c, srvc__r.stg__r.bopg__c, xcamc__c, xcamdt__c, xnry__c, tob__c, (select id, sta__c from Items__r limit 1) from g_Req__c where id =: reqId];
            req = (g_Req__c) Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + reqId + '\' and isDeleted = false');
            if (req.Items__r != null && (req.Items__r).size() > 0 && String.isNotBlank(req.Items__r[0].xr__c)) {
                bckOfcCmts = req.Items__r[0].xr__c;
            }
            srv = [select id, uid__c, name, sdg__c, sdg__r.sd__c, sdg__r.slbl__c, sdg__r.docslbl__c, sdg__r.srvdocs__c, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id =: req.srvc__c limit 1];
        }
    }
    public void getMember() {
        info = new mdWrapper.IdentityInfo();
        system.debug('req.xadtx4__c -- ' + req.xadtx4__c);
        if (!test.isRunningTest()) {
            if (String.isBlank(req.xadtx3__c)) {
                info = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx4__c, mdWrapper.IdentityInfo.class);
            } else {
                info = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx3__c, mdWrapper.IdentityInfo.class);
            }
            if (info.PassportInfo.isExpired) {
                info.PassportInfo.passportExpiryDate = '';
            }
        }
        system.debug('info -- ' + info);
        getAtts();
    }
    public void getAtts() {
        ppAttId = '';
        EIDAttId = '';
        RICAttId = '';
        rdocList = [select id from g_reqDoc__c where RQ__c =: req.id and upOk__c = true];
        for (Attachment a: [select id, name from Attachment where parentId =: rdocList order by createddate desc]) {
            if (a.name.startswith('Passport')) {
                ppAttId = a.Id;
            } else if (a.name.startswith('Emirates')) {
                EIDAttId = a.Id;
            } else if (a.name.startswith('RIC')) {
                RICAttId = a.Id;
            }
        }
    }
    public PageReference updateDetails() {
        showData = false;
        req = new g_req__c();
        selectedValue = '';
        pageUrl = '';
        memPP = ApexPages.CurrentPage().getParameters().get('pp');
        usr = [select id, contact.account.lc__c, contact.account.lcsta__c, contact.accountId from User where id =: UserInfo.getUserId() limit 1];
        if (usr.contact.account.lcsta__c == 'License Cancelled' || usr.contact.account.lcsta__c == 'License Under Cancellation') {
            showData = true;
        }
        List < String > identityIds = new List < String > ();
        Map < String, mdWrapper.IdentityInfo > oldidentityMap = new Map < String, mdWrapper.IdentityInfo > ();
        Map < String, List < mdWrapper.IdentityInfo >> newidentityMap = new Map < String, List < mdWrapper.IdentityInfo >> ();
        infoListMap = new Map < String, mdWrapper.IdentityInfo > ();
        Map < string, string > srMap = new Map < string, string > ();
        IF(!showData) {
            string jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"' + usr.contact.account.lc__c + '"}}'; /*string jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"20979"}}'; system.debug('---jsonStr---'+jsonStr);*/
            String responseBody = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStr);
            system.debug('---responseBody---' + responseBody); /*responseBody = '[ { "responseCode": { "responseCode": 200, "errorMessage": "Error message here if any" }, "IdentityInfo": [ { "role": "manager", "passportInfo": { "passportNumber": "1123A1", "passportIssueDate": "2021-11-10", "passportExpiryDate": "2023-08-13" }, "nationalIdNo": "1D23F", "identityName": "Samiha", "identityId": "a060l000008cQRSAA2", "emiratesIdInfo": { "emiratesIdNumber": "51A4D113", "emiratesIdIssueDate": "2022-08-05", "emiratesIdExpiryDate": "2024-11-14" }, "contactDetail": { "nationality": "Lebanese", "mobileNumber": "+971307701231", "middleName": "Walid", "lastName": "Baker", "gender": "male", "firstName": "Sami", "emailAddress": "john@tecom.com", "dateOfBirth": "2002-12-15" }, "addressDetailsInUAE": { "residencePhone": "0131211111", "POBoxNo": "000", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j@uae.com", "city": "Al Shariqa", "address": "5Rue" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "0131211111", "POBoxNo": "000", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j@home.com", "country": "Lebanon", "city": "Jbeil", "address": "5Rue" } }, { "role": "shareholder", "passportInfo": { "passportNumber": "11441", "passportIssueDate": "2022-02-18", "passportExpiryDate": "2023-05-05" }, "nationalIdNo": "3X23F", "identityName": "Fahad", "identityId": "a060l000008bI3CAAU", "emiratesIdInfo": { "emiratesIdNumber": "1233fA2", "emiratesIdIssueDate": "2020-05-17", "emiratesIdExpiryDate": "2023-03-25" }, "contactDetail": { "nationality": "British", "mobileNumber": "+971307701231", "middleName": "Yaris", "lastName": "Saleh", "gender": "female", "firstName": "Tina", "emailAddress": "john@tecom.com", "dateOfBirth": "2002-12-15" }, "addressDetailsInUAE": { "residencePhone": "0131214411", "POBoxNo": "0400", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j2@uae.com", "city": "Al Shariqa", "address": "6Rue" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "0132141111", "POBoxNo": "0400", "officePhoneNo": "+96151277213", "mobileNo": "708440211", "emailAddress": "j2@home.com", "country": "Lebanon", "city": "Saida", "address": "6Rue" } } ] } ]'; responseBody = '[ { "responseCode": { "responseCode": 200, "errorMessage": "Error message here if any" }, "IdentityInfo": [ { "role": "manager", "passportInfo": { "passportNumber": "1123A1", "passportIssueDate": "2021-11-10", "passportExpiryDate": "2022-08-13" }, "nationalIdNo": "1D23F", "identityName": "Samiha", "identityId": "a060l000008cQRSAA2", "emiratesIdInfo": { "emiratesIdNumber": "51A4D113", "emiratesIdIssueDate": "2022-08-05", "emiratesIdExpiryDate": "2022-11-14" }, "contactDetail": { "nationality": "Lebanese", "mobileNumber": "+971307701231", "middleName": "Walid", "lastName": "Baker", "gender": "female", "firstName": "Sami", "emailAddress": "john@tecom.com", "dateOfBirth": "2002-12-15" }, "addressDetailsInUAE": { "residencePhone": "0131211111", "POBoxNo": "000", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j@uae.com", "city": "Al Shariqa", "address": "5Rue" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "0131211111", "POBoxNo": "000", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j@home.com", "country": "Lebanon", "city": "Jbeil", "address": "5Rue" } }, { "role": "shareholder", "passportInfo": { "passportNumber": "11441", "passportIssueDate": "2022-02-18", "passportExpiryDate": "2023-05-05" }, "nationalIdNo": "3X23F", "identityName": "Fahad", "identityId": "a060l000008bI3CAAU", "emiratesIdInfo": { "emiratesIdNumber": "1233fA2", "emiratesIdIssueDate": "2020-05-17", "emiratesIdExpiryDate": "2023-03-25" }, "contactDetail": { "nationality": "British", "mobileNumber": "+971307701231", "middleName": "Yaris", "lastName": "Saleh", "gender": "female", "firstName": "Tina", "emailAddress": "john@tecom.com", "dateOfBirth": "2002-12-15" }, "addressDetailsInUAE": { "residencePhone": "0131214411", "POBoxNo": "0400", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j2@uae.com", "city": "Al Shariqa", "address": "6Rue" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "0132141111", "POBoxNo": "0400", "officePhoneNo": "+96151277213", "mobileNo": "708440211", "emailAddress": "j2@home.com", "country": "Lebanon", "city": "Saida", "address": "6Rue" } } ] } ]';*/
            mdList = new List < mdWrapper > ();
            infoList = new List < mdWrapper.IdentityInfo > ();
            if (string.isNotBlank(responseBody)) {
                mdList = (List < mdWrapper > ) System.JSON.deserialize(responseBody, List < mdWrapper > .class);
                if (mdList != null && !mdList.isEmpty() && !test.isRunningTest()) {
                    for (mdWrapper obj: mdList) {
                        for (mdWrapper.IdentityInfo info: obj.IdentityInfo) {
                            identityIds.add(info.identityId);
                        }
                    }
                    List < g_req__c > existReqs = [select id, name, xadtx3__c, xadtx4__c, UBO_File_Name__c, xoca__c from g_req__c where sta__c not in ('Completed', 'Cancelled', 'Rejected') and UBO_File_Name__c in: identityIds and Acc__c =: usr.contact.accountId order by createddate];
                    system.debug(existReqs);
                    for (g_req__c r: existReqs) {
                        if (!srMap.containsKey(r.UBO_File_Name__c)) {
                            srMap.put(r.UBO_File_Name__c, r.name);
                        }
                        if (!infoListMap.containsKey(r.UBO_File_Name__c)) {
                            if (String.isNotBlank(r.xadtx3__c)) {
                                infoListMap.put(r.UBO_File_Name__c, (mdWrapper.IdentityInfo) System.JSON.deserialize(r.xadtx3__c, mdWrapper.IdentityInfo.class));
                            }
                        }
                    }
                    for (mdWrapper obj: mdList) {
                        for (mdWrapper.IdentityInfo info: obj.IdentityInfo) {
                            String identityId = info.identityId;
                            if (!infoListMap.containsKey(identityId)) {
                                infoListMap.put(identityId, info);
                            }
                            system.debug('---infoListMap---' + infoListMap);
                        }
                    }
                    infoList.addAll(infoListMap.values());
                    system.debug('---infoList---' + infoList);
                }
            }
        }
        return null;
    } /* public pagereference navigate() { Integer val = Integer.valueOf(Apexpages.currentPage().getParameters().get('rowIndex')); Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.memberUpdate'); system.debug(sessionPart); mdWrapper.IdentityInfo info = infoList[val]; sessionPart.put('selectedData', JSON.serialize(info));  pageUrl = '/apex/memberDeatilsUpdate?sid=a0L0p000001MDF7EAO'; return null; }*/
    public void saveDraftR() {
        req.sta__c = string.isblank(req.sta__c) ? 'Draft' : 'In Process';
        draftMsg = draftIns == 'showMsg1' ? 'msg1' : draftIns == 'showMsg2' ? 'msg2' : '';
        update req;
        if (req.sta__c == 'Draft') {
            submitRequest();
        }
    }
    public String conEmail {
        get;
        set;
    }
    public void saveEmail() {
        req.xceml__c = conEmail;
        update req;
    }
    public PageReference cancelR() {
        req.sta__c = 'Cancelled';
        update req;
        req.items__r[0].sta__c = stsList[1].id;
        update req.items__r[0];
        return new PageReference('/apex/grqstatus?id=' + req.id);
    }
    public void saveReqLR() {
        req = new g_req__c();
        req.srvc__c = sid;
        req.Acc__c = usr.contact.accountId;
        insert req;
    }
    public Pagereference saveReq() {
        req = new g_req__c();
        String identityId = '';
        String s = '';
        req.srvc__c = sid;
        req.Acc__c = usr.contact.accountId;
        mdWrapper.IdentityInfo mem = new mdWrapper.IdentityInfo();
        for (mdWrapper.IdentityInfo m: infoList) {
            if (m.identityId == memId) {
                mem = m;
                identityId = m.identityId;
                req.xceml__c = !string.isblank(m.contactDetail.emailAddress) ? m.contactDetail.emailAddress : '';
                req.rmob__c = !string.isblank(m.contactDetail.mobileNumber) ? m.contactDetail.mobileNumber : null;
            }
            system.debug('--Mobile Number----' + m.contactDetail.mobileNumber);
            system.debug('--Mobile Number----' + req.rmob__c);
        }
        s = JSON.serialize(mem);
        system.debug('s -------- ' + s);
        if (!String.isBlank(s)) req.xadtx4__c = s;
        if (!String.isBlank(identityId)) req.UBO_File_Name__c = identityId;
        insert req;
        pagereference retURL = new pagereference('/apex/memberDeatilsUpdate?id=' + req.id);
        retURL.setRedirect(true);
        return retURL;
    }
    public string attachId {
        get;
        set;
    }
    public void saveAttachment() {
        try {
            system.debug('Rq Id::' + req.id);
            system.debug('docName: ' + docName);
            system.debug('imageBase64: ' + imageBase64);
            String dName = docName.contains('pdf') ? docName + '.jpg' : docName + '.jpg';
            List < g_reqDoc__c > rqDocList = [select id, RQ__r.name from g_reqDoc__c where RQ__c =: req.id and name =: docName];
            if (rqDocList != null && !rqDocList.isEmpty() && String.isNotBlank(imageBase64)) {
                String rqNo = rqDocList[0].RQ__r.name;
                system.debug('rqNo -- ' + rqNo);
                Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = dName, ParentId = rqDocList[0].id);
                system.debug('A -- ' + A);
                insert A;
                attachId = A.id;
                if (!string.isblank(req.xdei__c)) {
                    grqWsDccaGetService.AttachList attList = new grqWsDccaGetService.AttachList();
                    List < grqWsDccaGetService.Attachments > attrecList = new List < grqWsDccaGetService.Attachments > ();
                    grqWsDccaGetService.Attachments attrec = new grqWsDccaGetService.Attachments();
                    attrec.parentId = req.xdei__c;
                    attrec.Name = rqDocList[0].name;
                    attrecList.add(attrec);
                    attList.AttachmentList = attrecList;
                    String reqjs = JSON.serialize(attList);
                    ws_call__c docws = new ws_call__c();
                    docws.ws_typ__c = 'DCCA Letters';
                    docws.mtd_nm__c = 'membersDocs';
                    docws.rq_itm__c = req.items__r[0].id;
                    docws.intsts__c = 'Ready for Integration';
                    docws.rq_jsn__c = reqjs;
                    insert docws;
                }
            }
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        getAtts();
    }
    public void deleteAttach() {
        try {
            string attId = Apexpages.currentPage().getParameters().get('attId');
            system.debug('deleteAttach attId >>' + attId);
            Attachment A = [select id, name from Attachment where id =: attId];
            if (req.STA__c == 'Open') {
                A.name = 'CFR' + A.name;
                update A;
            }
            if (req.STA__c != 'Open') {
                delete A;
            }
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
        getAtts();
    }
    public pagereference submitRequest() {
        system.debug('---first record----' + stsList[0].id);
        req.sta__c = 'Under Review';
        update req;
        req.items__r[0].sta__c = stsList[0].id;
        update req.items__r[0];
        if (req.items__r != null && !req.items__r.isEmpty()) {
            grqWsDcca.serviceRequest reqjsRq = new grqWsDcca.serviceRequest();
            grqWsDcca.serviceReq request = new grqWsDcca.serviceReq();
            request.service = '';
            request.serNm = 'CPU';
            request.dccapermtNo = string.isblank(req.xdei__c) ? '' : req.xdei__c;
            request.memInfo = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx3__c, mdWrapper.IdentityInfo.class);
            List < grqWsDcca.serviceReq > lst = new List < grqWsDcca.serviceReq > ();
            lst.add(request);
            reqjsRq.serviceRequest = lst;
            String rqbody = JSON.serialize(reqjsRq);
            ws_call__c ws = new ws_call__c();
            ws.rq_jsn__c = rqbody;
            ws.ws_typ__c = 'DCCA Letters';
            ws.mtd_nm__c = 'membersUpd';
            ws.uid__c = req.id + '' + '' + ws.mtd_nm__c + system.now();
            ws.rq_itm__c = req.items__r[0].id;
            ws.intsts__c = 'Ready for Integration';
            insert ws;
        }
        PageReference sInfoPage = new PageReference('/grqsinfo?id=' + req.id);
        sInfoPage.setRedirect(true);
        return sInfoPage;
    }
    public String otpResult {
        get;
        set;
    }
    public String otpReqId {
        get;
        set;
    }
    public Integer otpAttempt {
        get;
        set;
    }
    public String otpValMsg {
        get;
        set;
    }
    public String otpfrmPg {
        get;
        set;
    }
    public String mobNum {
        get;
        set;
    }
    public String mobNumber {
        get;
        set;
    }
    public void sendOneTimePassword(string mobileNumber, string requestId) {
        try {
            otpReqId = SMSService.sendOtp(mobileNumber, requestId);
            system.debug('--otpReqId--' + otpReqId);
            otpResult = '';
            otpValMsg = '';
            if (String.isNotBlank(otpReqId) && otpReqId.startsWith('ERROR') && otpReqId.contains('is invalid')) {
                otpValMsg = 'Mobile number is invalid, please contact 800 4 axs (297)';
            }
        } catch (Exception e) {
            otpValMsg = 'Error while sending the OTP, please try after sometime';
            System.debug('EX::: ' + e.getMessage() + ' stack: ' + e.getStackTraceString());
        }
    }
    public void callSMService() {
        System.debug('Inside this method');
        sendOneTimePassword(req.rmob__c, req.id);
        System.debug('after calling the  method');
    }
    public void sendOTP() {
        if (string.isblank(req.rmob__c) || !req.rmob__c.startswith('+9715')) {
            req.rmob__c = '+971' + mobNum;
            update req;
        }
    }
    public String validateOtp() {
        CTRLCustProfileUpdate1 ctrl = new CTRLCustProfileUpdate1();
        try {
            system.debug('otpReqId -- ' + otpReqId + ' && otpfrmPg -- ' + otpfrmPg);
            otpResult = SMSService.otpValidate(otpReqId, otpfrmPg);
        } catch (Exception e) {
            gU.AddErrorMsg('OTP validation failed, regenerate the OTP and verify.');
            System.debug('EX::: ' + e.getMessage() + ' stack: ' + e.getStackTraceString());
            return null;
        }
        System.debug('otpResult ' + otpResult);
        return null;
    }
}
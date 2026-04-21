/**************************************************************************************************
@Version History
* Version		Date            Name						Description
* 1.0         Initial          DHAM                        Initial Draft
* 1.1         07-04-2024       Prateek Jangir              Added logic to adjust referance mobile format.
* 1.2         01-03-2025       Prateek Jangir              Added code to capture first name and last name as arbic to pass DDA.
**************************************************************************************************/
public class grCtrlCustProfUp extends pgBsCtrl {

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
    public String mobileNumberJson {
        get;
        set;
    } //1.1
    public String otpSentMobileOREmail {
        get;
        set;
    } //1.1
    public String missingInfoMembers {
        get;
        set;
    } //1.1
    public String firstNameArabic {
        get;
        set;
    } // 1.2 PJ
    public String lastNameArabic {
        get;
        set;
    } // 1.2 PJ

    public grCtrlCustProfUp() {
        try { //1.1 
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
                req = [select Id, xceml__c, rmob__c, xcs__c, xcemrt__c, xcnc__c, amsgs__c, inUAE__c, acc__r.id, Acc__r.Legal_Framework__c, Srvc__r.sdg__c, Srvc__r.sdg__r.sd__c, Srvc__r.sdg__r.ptype__c, acc__r.name,
                    srvc__c, sta__c, xdmpn__c, srvc__r.uid__c, srvc__r.Name, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.AddOnSrv__c, srvc__r.stg__r.reqq__c,
                    srvc__r.stg__r.bopg__c, xcamc__c, xcamdt__c, xnry__c, tob__c, (select id, sta__c from Items__r limit 1) from g_Req__c where id =: reqId
                ];
                req = (g_Req__c) Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + reqId + '\' and isDeleted = false');
                if (req.Items__r != null && (req.Items__r).size() > 0 && String.isNotBlank(req.Items__r[0].xr__c)) {
                    bckOfcCmts = req.Items__r[0].xr__c;
                }
                srv = [select id, uid__c, name, sdg__c, sdg__r.sd__c, sdg__r.slbl__c, sdg__r.docslbl__c, sdg__r.srvdocs__c, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c,
                    sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id =: req.srvc__c limit 1
                ];
            }
        } catch (exception ex) {
            system.debug('stack====1===' + ex.getStackTraceString() + '====msg====' + ex.getLineNumber());
        }
    }
    public void getMember() {

        info = new mdWrapper.IdentityInfo();
        if (String.isBlank(req.xadtx3__c)) {
            info = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx4__c, mdWrapper.IdentityInfo.class);
        } else {
            info = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx3__c, mdWrapper.IdentityInfo.class);
        }
        system.debug(info.passportInfo);
        if (info.PassportInfo.isExpired) {
            info.PassportInfo.passportExpiryDate = '';
        }

        if (info.contactDetail.firstName != null) { // 1.2 PJ
            firstNameArabic = ApplicantDetailController.getArabicName(info.contactDetail.firstName);
        }
        if (info.contactDetail.lastName != null) { // 1.2 PJ
            lastNameArabic = ApplicantDetailController.getArabicName(info.contactDetail.lastName);
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
        try { //1.1
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
                string jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"' + usr.contact.account.lc__c + '"}}';
                String responseBody = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStr);
                System.debug('responseBody PJ :' + responseBody);
                mdList = new List < mdWrapper > ();
                infoList = new List < mdWrapper.IdentityInfo > ();
                if (string.isNotBlank(responseBody)) {
                    mdList = (List < mdWrapper > ) System.JSON.deserialize(responseBody, List < mdWrapper > .class);
                    if (mdList != null && !mdList.isEmpty()) { //&& !test.isRunningTest()
                        for (mdWrapper obj: mdList) {
                            for (mdWrapper.IdentityInfo info: obj.IdentityInfo) {
                                identityIds.add(info.identityId);
                            }
                        }
                        List < g_req__c > existReqs = [select id, name, xadtx3__c, xadtx4__c, UBO_File_Name__c, xoca__c from g_req__c where sta__c not in ('Completed', 'Cancelled', 'Rejected') and UBO_File_Name__c in: identityIds and Acc__c =: usr.contact.accountId order by createddate];
                        for (g_req__c r: existReqs) {
                            if (!srMap.containsKey(r.UBO_File_Name__c)) {
                                srMap.put(r.UBO_File_Name__c, r.name);
                            }
                            mdWrapper.IdentityInfo inf = new mdWrapper.IdentityInfo();
                            if (!infoListMap.containsKey(r.UBO_File_Name__c)) { //r.xoca__c
                                if (String.isNotBlank(r.xadtx3__c)) {
                                    inf = (mdWrapper.IdentityInfo) System.JSON.deserialize(r.xadtx3__c, mdWrapper.IdentityInfo.class);
                                    inf.reqNum = r.name;
                                    inf.reqId = r.id;
                                    system.debug('inf -- ' + inf);
                                    infoListMap.put(r.UBO_File_Name__c, inf);
                                }
                            }
                        }
                        for (mdWrapper obj: mdList) {
                            for (mdWrapper.IdentityInfo info: obj.IdentityInfo) {
                                String identityId = info.identityId;
                                if (!infoListMap.containsKey(identityId)) {
                                    infoListMap.put(identityId, info);
                                }
                            }
                        }
                        infoList.addAll(infoListMap.values());
                    }
                    lrCtlReq ctlReq = new lrCtlReq();
                    String alertDetails = ctlReq.getCPUDetails(usr.contact.account.lc__c); //1.1
                    if (String.isNotBlank(alertDetails)) {
                        // Split the string by newline characters to separate each line
                        List < String > memberDetails = alertDetails.split('\n');

                        // Loop through each line to find lines that start with a hyphen
                        for (String member: memberDetails) {
                            // Trim whitespace and check if the line starts with a hyphen
                            if (member.trim().startsWith('-')) {

                                if (member.trim().startsWith('-')) {
                                    // Remove the hyphen and any leading spaces by trimming and then removing the first character
                                    if (String.isBlank(missingInfoMembers)) {
                                        missingInfoMembers = member.trim().substring(1).trim();
                                    } else {
                                        missingInfoMembers += ',' + member.trim().substring(1).trim();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return null;
        } catch (exception ex) {
            system.debug('stack====1===' + ex.getStackTraceString() + '====msg====' + ex.getLineNumber());
            return null;
        }
    }
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

    public void saveEmail() { // PJ 1.1
        otpSentMobileOREmail = 'Email Address';
        gU.sendEmailOTP('CPU', conEmail, req);
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
                //req.xceml__c=!string.isblank(m.contactDetail.emailAddress)?m.contactDetail.emailAddress:'';

                system.debug('m.contactDetail.emailAddress@@@@@@@@@ ');
                system.debug(m.contactDetail.emailAddress);
                system.debug('m.contactDetail.emailAddress@@@@@@@@@ ');
                if (m.contactDetail.emailAddress != null && m.contactDetail.emailAddress != '' && m.contactDetail.emailAddress.contains('@')) {
                    system.debug('Inside m.contactDetail.emailAddress@@@@@@@@@ ');
                    req.xceml__c = m.contactDetail.emailAddress;
                }
                system.debug('req.xceml__c##### ' + req.xceml__c);
                req.rmob__c = m.contactDetail.mobileNumber; //1.1
            }
        }
        s = JSON.serialize(mem);
        system.debug('s -------- ' + s);

        if (!String.isBlank(s))
            req.xadtx4__c = s;
        if (!String.isBlank(identityId))
            req.UBO_File_Name__c = identityId;

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
            String dName = docName.contains('pdf') ? docName + '.jpg' : docName + '.jpg';
            List < g_reqDoc__c > rqDocList = [select id, name, RQ__r.name from g_reqDoc__c where RQ__c =: req.id and name =: docName];
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

        Map < String, Object > mobileNumberMap = (Map < String, Object > ) JSON.deserializeUntyped(mobileNumberJson); //1.2
        req.sta__c = 'Under Review';

        //1.1 Start
        String countryCode = String.valueOf(mobileNumberMap.get('countrycode_rmob__c'));
        String temCountryCode = countryCode.subString(1);

        if (req.rmob__c != null && String.valueOf(req.rmob__c).startsWith(countryCode)) {
            req.rmob__c = countryCode + '-' + String.valueOf(req.rmob__c).replace(countryCode, '');
        } else if (req.rmob__c != null && String.valueOf(req.rmob__c).startsWith(temCountryCode)) {
            req.rmob__c = countryCode + '-' + String.valueOf(req.rmob__c).replace(temCountryCode, '');
        } else {
            req.rmob__c = req.rmob__c != null && mobileNumberMap.size() > 0 ? mobileNumberMap.get('countrycode_rmob__c') + '-' + req.rmob__c : req.rmob__c; //1.1
        }
        //1.1 End
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
    public Boolean isMobileOTP {
        get;
        set;
    }


    public void sendOneTimePassword(string mobileNumber, string requestId) { //PJ 1.1
        try {
            otpSentMobileOREmail = 'Mobile Number';
            otpReqId = SMSService.sendOtp(mobileNumber, requestId);
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
    public void callSMService() { //PJ 1.1
        sendOneTimePassword(req.rmob__c, req.id);
    }
    public void sendOTP() {
        req.rmob__c = mobNum;
        update req;
    }
    public String validateOtp() { //PJ 1.1

        otpResult = '';
        otpResult = gU.validateOtp('CPU', req, null, otpfrmPg, isMobileOTP, otpReqId);
        return null;
    }

    /************************************************************************************************* 
     * Description		: Method to get mobile number if country code exist.
     * Created Date		: 25-June-2024                                        
     * Created By		: Prateek Jangir
     **************************************************************************************************/
    public String getUpdateMobileFields(String mobileNumber) { //1.1

        if (mobileNumber != null && mobileNumber.contains('-')) {
            mobileNumber = mobileNumber.split('-', 2)[1];
        }
        return mobileNumber;
    }

}
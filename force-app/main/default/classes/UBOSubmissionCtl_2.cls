public class UBOSubmissionCtl_2 {
    public Boolean onlyApprovedUBO{set;get;}
    public Boolean isExceptionApplied{set;get;}
    public Boolean confirmLicRen{set;get;}
    public Boolean dupUboFlg{set;get;}
    public Boolean NotIndvSHFlag{set;get;}
    public Boolean Isview{set;get;}
    public Date cessDt{set;get;}
    public string gender {set;get;}
    public date inActdob {set;get;}
    public date inActpsIssue {set;get;}
    public date inActpsExpiry {set;get;}
    public date inActuboShDt {set;get;}
    public String relatedTo{set;get;}
    public String strRelatedTo{set;get;}
    public String shareHolderId{set;get;}
    public List<ShareHolderInfo> shInfoList{set;get;}
    public g_Req__c rq{set;get;}
    public string imgData {set;get;}
    public string licenseNumber{set;get;}
    public string companyName {set;get;}
    public string legalFramework {set;get;}
    public string licenseStatus {set;get;}
    public UBO information {set;get;}
    public UBOInfo uboInfo{set;get;}
    public IndvInfo indvInformation {set;get;}
    public boolean oI {set;get;}
    public boolean editingUbo {set;get;}
    public List < IndvInfo > uDI {set;get;}
    public List < IndvInfo > approvedUBOs {set;get;}
    public List < IndvInfo > deletedUBOs {set;get;}
    public string inactiveubos{set;get;}
    public string operationRecordId {set;get;}
    public boolean exceptionReadOnly{set;get;}
    public string contentDocumentId {set;get;}
    public Attachment attachment {set;get;}
    public Attachment corAtt {set;get;}
    public Attachment comSAtt {set;get;}
    public string docname {set;get;}
    public List < string > fileList {set;get;}
    public boolean lockReq {set;get;}
    public boolean evidence {set;get;}
    public string country {set;get;}
    public string homeCountry {set;get;}
    public string city {set;get;}
    public boolean showAddNewUBO {set;get;}
    public boolean showSubmit {set;get;}
    public String strResp {set;get;}
    public String urlVal {set;get;}
    public Boolean ispu {set;get;}
    public Boolean isgu {set;get;}
    public String aPark {set;get;}
    Set<string> allUboSet{set;get;}
    public string actingAsNomineeShareholder{set;get;}
    public string actingAsNomineeDirector{set;get;}
    public string requestFormId{get;set;}
    public string inactUboJson{get;set;}
    public String mobileNumberJson { get; set; }
    public String mobNum {get;set;}
    public String emailAddr {get;set;}
    public String otpVal {get;set;}
    public  String otpResult {get; set;}
    public  String otpReqId {get; set;}
    public  String attachmentName {get; set;}
    public  String attachmentBody {get; set;}
    public Boolean isMobileOTP {get; set;}
    public String conEmail {get;set;}
    public string requestBody;
    public string responseBody;
    Account accountRecord;
    User userRecord;
    public String checkMarkJSON { get; set; }

    public string pepAssociation {set;get;}
    public String sourceOfFundJSON { get; set; }

    public String sourceOfFundTableJSON { get; set; }
    public boolean isOthersCloselyAssociated { get; set; }
    public boolean isOthersCloselyRelated { get; set; }
    public String otpSentMobileOREmail { get; set; }

    public List<String> closelyAssociatedPEP{ get; set; }
    public List<String> closelyRelatedPEP{ get; set; }
    public String pepCountry{ get; set; }

    public UBOSubmissionCtl_2(String dmy) {}

    public UBOSubmissionCtl_2() {

        system.debug('UBOSubmissionCtl_2::::::');
        allUboSet=new Set<string>();
        onlyApprovedUBO= true;
        NotIndvSHFlag = true;
        editingUbo = false;
        actingAsNomineeShareholder=actingAsNomineeDirector=null;
        Isview=false;
        showAddNewUBO = true;
        attachment = new Attachment();
        lockReq = true;
        evidence = false;
        comSAtt = corAtt = new Attachment();
        showSubmit = false;
        uDI = new List < IndvInfo > ();
        isgu = gU.isGuestUser(UserInfo.getProfileId());
        ispu = gU.isPortalUser(UserInfo.getProfileId());
        Id reqId = apexpages.currentpage().getparameters().get('id');
        if (reqId == null) {
            userRecord = [select Id, contact.account.lc__c, contact.account.Ise__c, contact.account.Prk__c, Country from User where id =: UserInfo.getUserId() limit 1];
            accountRecord = userRecord.contact.account;
            licenseNumber = accountRecord.lc__c;
            aPark = accountRecord.Prk__c;
        } else {
            g_Req__c req = [SELECT Id, acc__r.id, acc__r.Prk__c, xadh__c FROM g_Req__c WHERE id =: reqId];
            accountRecord = [SELECT id, lc__c FROM Account where id =: req.Acc__c limit 1];
            licenseNumber = accountRecord.lc__c;
            aPark = accountRecord.Prk__c;
        }
        urlVal = Apexpages.currentPage().getUrl();
        isExceptionApplied = false;
        getDetails();
        indvInformation = new IndvInfo();
        fileList = new List < String > ();
    }
    public void updatePage() {
        oI= false;
    }
    public void addUBOShareHolder() {
        oI = true;
        for (ShareHolderInfo i: uboInfo.shareInfo) {
            if (operationRecordId == i.shareHolderId) {
                indvInformation = i.personInfo;
                indvInformation.shareId = i.infoId;
                relatedTo =i.infoId;
            }else if (operationRecordId == 'Notrelated') {
                indvInformation= new IndvInfo();
            }
        }
    }
    public void onChangeException() {
        if (isExceptionApplied != null) {
            if (isExceptionApplied == true) {
                indvInformation.fName = '';indvInformation.lName = '';
                country = '';indvInformation.psNo='';
                indvInformation.psIssue=null;indvInformation.psExpiry=null;
                indvInformation.psIssuePlace='';indvInformation.placeofBirth='';
                indvInformation.dob=null;gender='';indvInformation.uboShDt=null;
                indvInformation.uArea='';indvInformation.uStreet='';
                city='';indvInformation.uPoBox='';
                indvInformation.uPhone='';indvInformation.uBuilding='';
                indvInformation.uMobile1='';indvInformation.uMobile2='';
                indvInformation.cCity='';homeCountry='';
                indvInformation.cPhone='';indvInformation.cMobile='';
                indvInformation.isExceptionApplied=true;
            }else if (isExceptionApplied == false) {
                for (IndvInfo i: uDi) {
                    if (operationRecordId == i.reqFormId) {
                        indvInformation =new IndvInfo();
                        indvInformation = i;
                        country = indvInformation.nation;
                        homeCountry = indvInformation.cCountry;
                        city = indvInformation.uCity;
                        gender = indvInformation.gender;

                        indvInformation.isUAE= false;
                        indvInformation.isSE= false;
                        indvInformation.isGov= false;
                        indvInformation.isExceptionApplied=false;
                    }
                }
            }
        }
       system.debug('indvInformation:::'+indvInformation);
    }
    public void updateEvd() {
        evidence = !evidence;
    }
    public pageReference viewIndividual() {
        Isview =true;
        dupUboFlg= false;
        oI = true;
        Isview= true;
        for (IndvInfo i: information.info.approvedubos) {
            if (operationRecordId == i.reqFormId) {
                indvInformation =new IndvInfo();
                indvInformation = i;
                country = indvInformation.nation;
                homeCountry = indvInformation.cCountry;
                city = indvInformation.uCity;
                gender = indvInformation.gender;
                if (indvInformation.shareId != null) {
                    relatedTo =indvInformation.shareId;
                }else if (indvInformation.shareId == null) {
                    relatedTo ='notRelated';
                }

            }
        }
        return null;
    }
    public boolean exReadOnly{get;set;}
    public PageReference editIndividual() {
        oI = true;
        Isview= false;
        dupUboFlg= false;
        editingUbo = true;
        exReadOnly=true;
        for (IndvInfo i: uDi) {
            System.debug('indvInformation initial first:'+uDi);
            if (operationRecordId == i.reqFormId) {
                System.debug('indvInformation  initial:'+i);
                indvInformation =new IndvInfo();
                indvInformation = i;
                country = indvInformation.nation;
                homeCountry = indvInformation.cCountry;
                city = indvInformation.uCity;
                gender = indvInformation.gender;
                relatedTo =indvInformation.shareId;
                if (!string.isblank(indvInformation.relatedTo))strRelatedTo=indvInformation.relatedTo;
                if (indvInformation.shareId != null) {
                    relatedTo =indvInformation.shareId;
                }else if (indvInformation.shareId == null) {
                    relatedTo ='notRelated';
                }
                if (indvInformation.uMobile1 != null) {
                    indvInformation.uMobile1 = indvInformation.uMobile1.removeStart('+971-');
                    indvInformation.uMobile1 = indvInformation.uMobile1.removeStart('+971');
                    indvInformation.uMobile1 = indvInformation.uMobile1.removeStart('971');

                }
                if (indvInformation.uMobile2 != null) {
                    indvInformation.uMobile2 = indvInformation.uMobile2.removeStart('+971-');
                    indvInformation.uMobile2 = indvInformation.uMobile2.removeStart('+971');
                    indvInformation.uMobile2 = indvInformation.uMobile2.removeStart('971');
                }
                if (indvInformation.uPhone != null) {
                    indvInformation.uPhone = indvInformation.uPhone.removeStart('+971-');
                    indvInformation.uPhone = indvInformation.uPhone.removeStart('+971');
                    indvInformation.uPhone = indvInformation.uPhone.removeStart('971');
                }

                System.debug('isExceptionApplied :'+isExceptionApplied);
                if (indvInformation.isExceptionApplied == null) {
                    indvInformation.isExceptionApplied = isExceptionApplied;
                }
                sourceOfFundJSON = indvInformation.sourceOfWealth != null && indvInformation.sourceOfWealth.size() > 0 ? JSON.serialize(indvInformation.sourceOfWealth) : '';
                Boolean isOthersRelated= indvInformation.pepRelated != null && indvInformation.pepRelated.size() > 0 ? indvInformation.pepRelated.contains('others: (Please specify details in below text box)') : false;
                isOthersCloselyAssociated = indvInformation.pepAssociation == 'Closely Associated to PEP' ? isOthersRelated : false;
                isOthersCloselyRelated = indvInformation.pepAssociation == 'Closely Related to PEP' ? isOthersRelated : false;
                if (indvInformation.pepAssociation == 'Closely Associated to PEP' && indvInformation.pepRelated.size() > 0 ) {
                    closelyAssociatedPEP = new List<String>();
                    closelyAssociatedPEP.addAll(indvInformation.pepRelated);
                }
                else if (indvInformation.pepAssociation == 'Closely Related to PEP' && indvInformation.pepRelated.size() > 0 ) {
                    closelyRelatedPEP = new List<String>();
                    closelyRelatedPEP.addAll(indvInformation.pepRelated);
                }
                System.debug('indvInformation  :'+indvInformation);
            }
        }

        return null;
    }
    public PageReference deleteIndividual1() {
        return  null;
    }
    public PageReference deleteDoc() {
        Operation o = new Operation();
        o.opType = 'Delete Document';
        if (contentDocumentId != null) {
            o.contentDeletionId = contentDocumentId;
        }
        Map < string, Operation > mapUBO = new Map < string, Operation > ();
        mapUBO.put('data', o);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DCCA_Auth/apexrest/UBOSubmission');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        System.debug('mapUBO:::'+json.serialize(mapUBO));
        req.setBody(json.serialize(mapUBO));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        getDetails();
        PageReference pageRef = new PageReference('/apex/UBOSubmission?lic=' + licenseNumber);
        if (urlVal.contains('ubo_popup')) {
            pageRef = new PageReference('/apex/ubo_popup?lic=' + licenseNumber);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference deleteIndividual() {
        Operation o = new Operation();
        o.opType = 'Delete';
        o.lic = licenseNumber;

        for (IndvInfo info: udi) {
            if (info.reqFormId == operationRecordId) {
                if (cessDt != null) {
                    info.cessation = cessDt;
                }
                o.individual = info;

            }
        }
        OppData d = new OppData();
        d.data = o;
        Map < string, Operation > mapUBO = new Map < string, Operation > ();
        mapUBO.put('data', o);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DCCA_Auth/apexrest/UBOSubmission');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        System.debug('mapUBO:::'+json.serialize(mapUBO));
        req.setBody(json.serialize(mapUBO));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('--Response Body--'+res.getBody());
        getDetails();
        PageReference pageRef = new PageReference('/apex/UBOSubmission?lic=' + licenseNumber);
        if (urlVal.contains('ubo_popup')) {
            pageRef = new PageReference('/apex/ubo_popup?lic=' + licenseNumber);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    public HttpRequest getReq(string m) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DCCA_Auth/apexrest/UBOSubmission');
        req.setMethod(m);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    public PageReference submit() {
        boolean isStockExcchnage=false;
        boolean isGov=false;
        if (uboInfo.framework == 'Free Zone Limited Liability Company') {
            for (ShareHolderInfo info: uboInfo.shareInfo) {
                string per = info.sharePercentage.replace('%', '');
                decimal sharePer = Decimal.valueOf(per);
                if (info.typeOfShareholder == 'Corporate' && sharePer >= 25 && info.action != 'Available') {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please note that UBO should be declared for all corporate shareholders who own 25% or more in the company'));
                    return null;
                }
            }
        }
        integer count = 0;
        
        system.debug(uboInfo.shareInfo);
         system.debug( indvInformation.isExceptionApplied);

        system.debug(uDi);
        
        for (IndvInfo i: uDi) {
            if (i.status != 'Deleted') count++;
        }
        if (count == 0 && !accountRecord.Ise__c) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There should be atleast one active UBO record to proceed--'+accountRecord.lc__c));
            return null;
        }
        HttpRequest req = getReq('POST');
        Operation o = new Operation();
        o.opType = 'Submit';
        o.lic = licenseNumber;
        Map < string, Operation > mapUBO = new Map < string, Operation > ();
        mapUBO.put('data', o);
        req.setBody(json.serialize(mapUBO));
        req.setTimeout(120000);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        OppData dataInfo = (OppData) JSON.deserialize(res.getBody(), OppData.class);
        if (dataInfo.data.lockReq == true) lockReq = true;
        else lockReq = false;
        PageReference pageRef = new PageReference('/apex/UBOSubmission?lic=' + licenseNumber);
        if (urlVal.contains('ubo_popup')) {
            pageRef = new PageReference('/apex/ubo_popup?lic=' + licenseNumber);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference uploadStructure() {
        oI = false;
        Operation o = new Operation();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DCCA_Auth/apexrest/UBOSubmission');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        o = new Operation();
        o.opType = 'Attachment';
        o.lic = licenseNumber;
        FileOperation fi = new FileOperation();
        system.debug('comSAtt-- ' + comSAtt);
        fi.body = EncodingUtil.base64Decode(imgData); /*/fi.fName = 'CS_' + comSAtt.Name;*/
        fi.fName = DateTime.now() + ' ' + Label.UBOFileExtension;
        system.debug(' fi.fName -- ' + fi.fName);
        fi.pId = uboInfo.request.reqId;
        o.f = fi;
        Map < string, Operation > mapUBO = new Map < string, Operation > ();
        mapUBO.put('data', o);
        req.setBody(json.serialize(mapUBO));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        comSAtt = new attachment();
        PageReference pageRef = new PageReference('/apex/UBOSubmission?lic=' + licenseNumber);
        if (urlVal.contains('ubo_popup')) {
            pageRef = new PageReference('/apex/ubo_popup?lic=' + licenseNumber);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference cancelNewUBO() {
        oI = false;
        PageReference pageRef = new PageReference('/apex/UBOSubmission?lic=' + licenseNumber);
        if (urlVal.contains('ubo_popup')) {
            pageRef = new PageReference('/apex/ubo_popup?lic=' + licenseNumber);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pagereference addNewUBO() {
        editingUbo = false;
        Isview= false;
        oI = true;
        indvInformation = new IndvInfo();
        indvInformation.isExceptionApplied = isExceptionApplied;

        return null;
    }

    public pagereference saveInfo() {

        System.debug('sourceOfFundJSON  value : '+sourceOfFundJSON);

        Map<String, Object> mobileNumberMap = new Map<String, Object>();
        Map<String, Object> checkMarkMap = new Map<String, Object>();

        if (!String.isEmpty(attachmentName) &&  !String.isEmpty(attachmentBody)) {
            attachment.Name = attachmentName;
            attachment.body =   EncodingUtil.base64Decode(attachmentBody);
        }
        if (mobileNumberJson != null && String.isNotBlank(mobileNumberJson)) {
            mobileNumberMap = (Map<String, Object>) JSON.deserializeUntyped(mobileNumberJson);
        }

        if (isExceptionApplied && checkMarkJSON != null && String.isNotBlank(checkMarkJSON)) {
            checkMarkMap = (Map<String, Object>) JSON.deserializeUntyped(checkMarkJSON);

            if (checkMarkMap.size() > 0) {
                indvInformation.isSE = Boolean.valueOf(checkMarkMap.get('isSE'));
                indvInformation.isGov = Boolean.valueOf(checkMarkMap.get('isGov'));
            }
        }

        System.debug('indvInformation  value : '+indvInformation);

        if (String.isNotBlank(country)) {
           indvInformation.nation= country;
        }

        if (String.isNotBlank(sourceOfFundJSON)) {
            List<sourceofFundWealth> wealthList = (List<sourceofFundWealth>)JSON.deserialize(sourceOfFundJSON, List<sourceofFundWealth>.class);
            System.debug('wealthList :'+wealthList);
            indvInformation.sourceOfwealth = new List<sourceofFundWealth>();
            indvInformation.sourceOfwealth.addAll(wealthList);
        }

        if (String.isNotBlank(pepCountry)) {
            indvInformation.pepCountry = pepCountry;
        }

        if (indvInformation.isExceptionApplied == null) {
            indvInformation.isExceptionApplied = isExceptionApplied;
        }

        indvInformation.pepRelated = new List<String>();
        if (closelyAssociatedPEP != null && closelyAssociatedPEP.size() > 0)
            indvInformation.pepRelated.addAll(closelyAssociatedPEP);
        else if (closelyRelatedPEP != null && closelyRelatedPEP.size() > 0)
            indvInformation.pepRelated.addAll(closelyRelatedPEP);

        if (indvInformation.uMobile1 != null && !indvInformation.uMobile1.contains('+971-')) {
                indvInformation.uMobile1 ='+971-'+indvInformation.uMobile1;
        }
        if (indvInformation.uMobile2 != null && !indvInformation.uMobile2.contains('+971-')) {
                indvInformation.uMobile2 ='+971-'+indvInformation.uMobile2;
        }
        if (indvInformation.uPhone != null && !indvInformation.uPhone.contains('+971-')) {
                indvInformation.uPhone ='+971-'+indvInformation.uPhone;
         }
        if (mobileNumberMap != null && mobileNumberMap.size() > 0) {
            if (mobileNumberMap.get('indvInformation_cPhone') != null && mobileNumberMap.get('indvInformation_cPhone') != '') {
                String countryCode = String.valueOf(mobileNumberMap.get('indvInformation_cPhone'));
                if (indvInformation.cPhone != null && indvInformation.cPhone.startsWith(countryCode)) {
                    indvInformation.cPhone=indvInformation.cPhone.replace(countryCode, '');
                }
                countryCode = countryCode.subString(1);
                if (indvInformation.cPhone != null && indvInformation.cPhone.startsWith(countryCode)) {
                    indvInformation.cPhone=indvInformation.cPhone.replace(countryCode, '');
                }
                indvInformation.cPhone = mobileNumberMap.get('indvInformation_cPhone') +'-'+indvInformation.cPhone;
            }
            if (mobileNumberMap.get('indvInformation_cMobile') != null && mobileNumberMap.get('indvInformation_cMobile') != '') {
                String countryCode = String.valueOf(mobileNumberMap.get('indvInformation_cMobile'));
                if (indvInformation.cMobile != null && indvInformation.cMobile.startsWith(countryCode)) {
                    indvInformation.cMobile=indvInformation.cMobile.replace(countryCode, '');
                }
                countryCode = countryCode.subString(1);
                if (indvInformation.cMobile != null && indvInformation.cMobile.startsWith(countryCode)) {
                    indvInformation.cMobile=indvInformation.cMobile.replace(countryCode, '');
                }
                indvInformation.cMobile = mobileNumberMap.get('indvInformation_cMobile') +'-'+indvInformation.cMobile;
            }
        }

        if (indvInformation.pepAssociation == 'Closely Related to PEP'  || indvInformation.pepAssociation == 'Closely Associated to PEP' ) {
            if (indvInformation.pepRelated.size() > 0 && indvInformation.pepRelated.contains('others: (Please specify details in below text box)')) {
                indvInformation.pepCloselyRelatedOthers = indvInformation.pepAssociation == 'Closely Related to PEP' ? indvInformation.pepCloselyRelatedOthers : null;
                indvInformation.pepCloselyAssociatedOthers = indvInformation.pepAssociation == 'Closely Associated to PEP' ? indvInformation.pepCloselyAssociatedOthers : null;
            }
            else{
                indvInformation.pepCloselyRelatedOthers = null;
                indvInformation.pepCloselyAssociatedOthers = null;
            }
        }
        else{
            indvInformation.pepCloselyRelatedOthers = null;
            indvInformation.pepCloselyAssociatedOthers = null;
            indvInformation.pepRelated = null;
            indvInformation.pepCountry =  indvInformation.pepAssociation == 'Not Applicable' ? null : indvInformation.pepCountry ;
        }
        //isExceptionApplied = false;

        Operation o = new Operation();
        Operation inAct = new Operation();
        o.opType = 'New Individual';
        o.lic = licenseNumber;
        inAct.opType = 'New Individual';
        inAct.lic = licenseNumber;
        indvInformation.nation = country;

        indvInformation.cCountry = homeCountry;
        indvInformation.uCity = city;
        indvInformation.gender = gender;
        indvInformation.relatedTo=relatedTo;

        indvInformation.actingAsNomineeShareholder=actingAsNomineeShareholder;
        indvInformation.actingAsNomineeDirector=actingAsNomineeDirector;
        if (!string.isblank(requestFormId)) {
            indvInformation.reqFormId=requestFormId;
            inAct.individual = (IndvInfo)System.JSON.deserialize(inactUboJson, IndvInfo.class);
        }
        if (indvInformation.status == 'Approved') {
            indvInformation.changedStatus='Edited';
        }
        if ((indvInformation.isGov != null && indvInformation.isGov) || (indvInformation.isUAE != null && indvInformation.isUAE) || (indvInformation.isSE != null && indvInformation.isSE)) {
            indvInformation.fName = '';
            indvInformation.lName = '';
            indvInformation.cName = '';
            indvInformation.nation = '';
            indvInformation.psNo = '';
            indvInformation.placeofBirth = '';
            indvInformation.psIssuePlace = '';
            indvInformation.psIssue = null;
            indvInformation.psExpiry = null;
            indvInformation.dob = null;
            indvInformation.uboShDt = null;
            indvInformation.uArea = '';
            indvInformation.uStreet = '';
            indvInformation.uCity = '';
            indvInformation.uBuilding = '';
            indvInformation.uPoBox = '';
            indvInformation.uPhone = '';
            indvInformation.uMobile1 = '';
            indvInformation.uMobile2 = '';
            indvInformation.cCity = '';
            indvInformation.cCountry = '';
            indvInformation.cPhone = '';
            indvInformation.cMobile = '';
            indvInformation.noOfUBO = '';
        }
        o.individual = indvInformation;
        OppData d = new OppData();
        d.data = o;
        Map < string, Operation > mapUBO = new Map < string, Operation > ();
        Map < string, Operation > inActmapUBO = new Map < string, Operation > ();
        if (string.isblank(requestFormId))mapUBO.put('data', o);
        if (!string.isblank(requestFormId))inActmapUBO.put('data', inAct);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DCCA_Auth/apexrest/UBOSubmission');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        System.debug('saveInfo mapUBO:::'+json.serialize(mapUBO));
        System.debug('saveInfo inActmapUBO:::'+json.serialize(inActmapUBO));

        if (string.isblank(requestFormId))req.setBody(json.serialize(mapUBO));
        if (!string.isblank(requestFormId))req.setBody(json.serialize(inActmapUBO));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('--Response Body--'+res.getBody());
        requestBody = mapUBO != null?json.serialize(mapUBO):json.serialize(inActmapUBO);
        responseBody = res.getBody();
        OppData dataInfo = (OppData) JSON.deserialize(res.getBody(), OppData.class);
        if (attachment != null && attachment.Name != null) {
            o = new Operation();
            o.opType = 'Attachment';
            o.lic = licenseNumber;
            FileOperation fi = new FileOperation();
            fi.body = attachment.Body;
            fi.fName = 'ID_' + attachment.Name;
            fi.pId = dataInfo.data.individual.reqFormId;
            o.f = fi;
            mapUBO = new Map < string, Operation > ();
            mapUBO.put('data', o);
            req.setBody(json.serialize(mapUBO));
            http = new Http();
            res = http.send(req);
            attachment = new attachment();
        }
        if (corAtt != null) {
            o = new Operation();
            o.opType = 'Attachment';
            o.lic = licenseNumber;
            FileOperation fi = new FileOperation();
            fi.body = corAtt.Body;
            fi.fName = 'SE_' + corAtt.Name;
            fi.pId = dataInfo.data.individual.reqFormId;
            o.f = fi;
            mapUBO = new Map < string, Operation > ();
            mapUBO.put('data', o);
            req.setBody(json.serialize(mapUBO));
            http = new Http();
            res = http.send(req);
            corAtt = new attachment();
        }
        if (!string.isBlank(dataInfo.data.individual.reqFormId)) {
            uDI.add(dataInfo.data.individual);
        }

        system.debug('uDI:' + uDI);
        oI = false;
        getDetails();

        system.debug('--requestBody---'+requestBody);
        system.debug('--responseBody---'+responseBody);
        closeCreateUBORequest(rq, 'Completed');
        PageReference pageRef = new PageReference('/apex/UBOSubmission?lic=' + licenseNumber);
        if (urlVal.contains('ubo_popup')) {
            pageRef = new PageReference('/apex/ubo_popup?lic=' + licenseNumber);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    public Class MissingInfo {
        public string name {
            set;
            get;
        }
        public string details {
            set;
            get;
        }
        public MissingInfo(string name, string details) {
            this.name = name;
            this.details = details;
        }
    }
    public List < MissingInfo > missedInfo {
        set;
        get;
    }
    public void getDetails() {
        oI = false;
        NotIndvSHFlag= true;
        missedInfo = new List < MissingInfo > ();
        if (licenseNumber != null) {
            HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DCCA_Auth/apexrest/UBOSubmission?licenseNumber=' + licenseNumber);
            req.setMethod('GET');
            req.setTimeout(120000);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('getDetails response:::'+res.getBody());
            strResp = res.getBody();
            strResp = strResp.replaceAll('\'', '');
            information = (UBO)JSON.deserialize(strResp, UBO.class);
            UBOInfo info = information.info;

            if (info.typeOfShareHolder == 'Individual') {
                NotIndvSHFlag = false;
            }else{
                 NotIndvSHFlag = true;
            }
            uboInfo = information.info;
            if (information.info.request != null) {
                lockReq = information.info.request.lockReq;
            }else{
                lockReq= false;
            }
            approvedUBOs = new List < IndvInfo > ();
            if (information.info.approvedubos != null) {
                approvedUBOs.addAll(information.info.approvedubos);
            }
            deletedubos = new List < IndvInfo > ();
            if (information.info.deletedubos != null) {
                deletedUBOs.addAll(information.info.deletedubos);
            }
            for (IndvInfo ubo :information.info.approvedubos) {
                if (ubo.status=='Missing Information') {
                    onlyApprovedUBO= false;
                }
            }
            uDI = new List < IndvInfo > ();
            shInfoList = new List <ShareHolderInfo> ();
            if (information.info.request != null) {
                uDI.addAll(information.info.request.requbos);
                string dob;
                for (IndvInfo ubo : information.info.request.requbos) {
                    if (ubo.status == 'Approved') {
                        if (ubo.dob != null) {
                            Date dobdate =ubo.dob;
                            dob =dobdate.year() + '-' + dobdate.month() + '-' + dobdate.day();
                            system.debug('dob:::::'+dob);
                        }
                        allUboSet.add(ubo.fName+'/'+ubo.lName+'/'+dob+'/'+ubo.nation);
                    }
                }
            }else{
                if (information.info.approvedubos != null) {
                uDI.addAll(information.info.approvedubos);
                    }
            }
            shInfoList.addAll(information.info.shareInfo);
            for (IndvInfo u: uDI) {
                if (u.status == 'Missing Information') {
                    string nm = '';
                    if (!string.isBlank(u.fName)) nm += u.fName;
                    if (!string.isBlank(u.lName)) nm += ' ' + u.lName;
                    missedInfo.add(new MissingInfo(nm, u.statusRemarks));
                }
                if (u.status == 'New' || u.status == 'Deleted' || u.status == 'Edited') showSubmit = true;
                if (u.status != 'Deleted' && information.info.pName != null && (u.isUAE || u.isSE || u.isGov)) showAddNewUBO = false;
                if (u.isSE || u.isGov) u.isexception2 = true;
            }
            System.debug('shInfoList  :'+shInfoList);
        }
    }
    public  void  sendOtp() {
        otpSentMobileOREmail = 'Mobile Number';
        otpReqId=SMSService.sendOTP(mobNum, '');
        rq= closeCreateUBORequest(rq, 'Open');
    }

    public  void  sendEmailOTP() {
        otpSentMobileOREmail ='Email Address';
        rq = gU.sendEmailOTP('UBO', conEmail, rq);
    }
    public  String validateOtp() {

        try {
            otpResult='';
            otpResult = gU.validateOtp('UBO', rq, indvInformation, otpVal, isMobileOTP, otpReqId);
        } catch (Exception e) {
            gU.AddErrorMsg('OTP validation failed, regenerate the OTP and verify.');
            return null;
        }
        return null;
    }

    public g_req__c closeCreateUBORequest(g_req__c request, String status) {
        system.debug('--requestBody---'+requestBody);
        system.debug('--responseBody---'+responseBody);
        if (request != null && request.Id != null) {
            request.STA__c = status;request.xadtx3__c=requestBody;request.xadtx4__c=responseBody;
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update request;
            }
        }
        else{
            g_Srvc__c serviceRecord = [select id from g_Srvc__c where uid__c ='ubo'];
            system.debug('userRecord :'+userRecord);
            system.debug('accountRecord :'+accountRecord);

            userRecord = userRecord != null ? userRecord : [select Id, contact.account.Ise__c,
                contact.account.lc__c, contact.account.Prk__c, Country from User where id =: UserInfo.getUserId() limit 1];
            accountRecord = accountRecord != null ? accountRecord : userRecord.contact.account;

            request = new g_Req__c(Acc__c = accountRecord.Id, srvc__c = serviceRecord.Id, Con__c = userRecord.ContactId,
                STA__c = status, xcnc__c = userRecord.Country, xadtx3__c=requestBody, xadtx4__c=responseBody);
            if (Schema.sObjectType.g_req__c.isCreateable()) {
                insert request;
            }
        }
        return request;
    }

    public class OppData {
        public Operation data;
    }
    public class Operation {
        public string opType;
        public IndvInfo individual;
        public string lic;
        public FileOperation f;
        public boolean lockReq {
            set;
            get;
        }
        public string contentDeletionId;
    }
    public class FileOperation {
        public blob body;
        public string fName;
        public string pId;
    }
    public class UBO {
        public UBOInfo info {
            set;
            get;
        }
    }
    public class UBOInfo {
        public string typeOfShareHolder{set;get;}
        public string licNumber{set;get;}
        public string framework{set;get;}
        public string licStatus {set;get;}
        public string companyName {set;get;}
        public List < ShareHolderInfo > shareInfo {set;get;}
        public List < IndvInfo > indList {set;get;}
        public List<IndvInfo> approvedubos;
        public List<IndvInfo> deletedubos{set;get;}
        public string pName {set;get;}
        public string pRegNo {set;get;}
        public string pNation {set;get;}
        public List < FileLocation > cId {set;get;}
        public ServiceRequest request{set;get;}

    }
    public class ServiceRequest{
        public string reqId{set;get;}
        public string reqNo{set;get;}
        public string callReview{set;get;}
        public boolean lockReq{set;get;}
        public string reqStatus{set;get;}
        public List<IndvInfo> requbos{set;get;}
        public List<FileLocation> cId{set;get;}
    }
    public class IndvInfo {
        public IndvInfo() {
            isGov = isSE = false;
            isAuto = false;
            isMore = false;
            isDirector = false;
            isBody = false;
            isManagment = false;
            isCorporate = false;
        }
        public boolean isAuto {set;get;}
        public boolean isMore {set;get;}
        public boolean isDirector {set;get;}
        public boolean isBody {set;get;}
        public boolean isexception2{set;get;}
        public boolean isManagment {set;get;}
        public boolean isCorporate{set;get;}
        public boolean isExceptionApplied{set;get;}
        public boolean isSE {set;get;}
        public boolean isGov {set;get;}
        public boolean isUAE {set;get;}
        public string fName {set;get;}
        public string lName {set;get;}
        public string cName {set;get;}
        public string nation {set;get;}
        public string psNo {set;get;}
        public date psIssue {set;get;}
        public date psExpiry {set;get;}
        public string psIssuePlace{set;get;}
        public date dob {set;get;}
        public date uboShDt{set;get;}
        public string placeofBirth {set;get;}
        public string uArea {set;get;}
        public string uStreet {set;get;}
        public string actingAsNomineeShareholder{set;get;}
        public string actingAsNomineeDirector{set;get;}
        public string uCity {
            set;
            get;
        }
        public string uBuilding {
            set;
            get;
        }
        public string uPoBox {
            set;
            get;
        }
        public string uPhone {
            set;
            get;
        }
        public string uMobile1 {
            set;
            get;
        }
        public Boolean isMobilePhoneVerified {
            set;
            get;
        }
        public DateTime mobilePhoneVerificationDatetime {
            set;
            get;
        }
        public string uMobile2 {
            set;
            get;
        }
        public String email {
            set;
            get;
        }
        public Boolean isEmailVerified {
            set;
            get;
        }
        public DateTime emailVerificationDatetime {
            set;
            get;
        }
        public string cCity {
            set;
            get;
        }
        public string cCountry {
            set;
            get;
        }
        public string cPhone {
            set;
            get;
        }
        public string cMobile {
            set;
            get;
        }
        public string noOfUBO {
            set;
            get;
        }
        public string reqId {
            set;
            get;
        }
        public string reqFormId {
            set;
            get;
        }
        public string status {
            set;
            get;
        }
        public string relatedTo {
            set;
            get;
        }
        public string shareId {
            set;
            get;
        }
        public date addedOn {
            set;
            get;
        }
        public string statusRemarks {
            set;
            get;
        }
        public List < FileLocation > eId {
            set;
            get;
        }
        public List < FileLocation > sId {
            set;
            get;
        }
        public string gender{
            set;
            get;
        }
        public String changedStatus{
            set;
            get;
        }
        public date cessation {
            set;
            get;
        }

        public string pepAssociation { set; get; }
        public List<String> pepRelated { set; get; }
        public String pepCloselyRelatedOthers { set; get; }
        public String pepCloselyAssociatedOthers { set; get; }
        public string pepCountry { set; get; }
        public List<sourceOfFundWealth> sourceOfwealth { set; get; }
    }
    public class FileLocation {
        public string contentDocumentId{
            set;
            get;
        }
        public string url {
            set;
            get;
        }
        public string name {
            set;
            get;
        }
        public FileLocation(string url, string name) {
            this.url = url;
            this.name = name;
        }
    }
    public class ShareHolderInfo {
        public IndvInfo personInfo {
            set;
            get;
        }
        public string shareHolderName {
            set;
            get;
        }
        public string typeOfShareholder {
            set;
            get;
        }
        public string sharePercentage {
            set;
            get;
        }
        public date submittedDate {
            set;
            get;
        }
        public decimal shareValue {
            set;
            get;
        }
        public decimal numberOfShare {
            set;
            get;
        }
        public string uboStatus {
            set;
            get;
        }
        public string action {
            set;
            get;
        }
        public string shareHolderId {
            set;
            get;
        }
        public string infoId {
            set;
            get;
        }
        public string added {
            set;
            get;
        }
        public boolean lockReq {
            set;
            get;
        }

        public Boolean isMobilePhoneVerified {
            set;
            get;
        }

        public Boolean isEmailVerified {
            set;
            get;
        }
    }

    public class sourceofFundWealth {
        public string incomeSource { set;get;}
        public string detail { set;get;}
        public string incomeCountry { set;get;}
    }
}
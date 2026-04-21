public class leAMLCtl {
    public List<g_Req__c> currUserReqs {//afsbo
        get;
        set;
    }Public String currUserReqsJSON{get;set;}
    public g_Req__c rq {
        get;
        set;
    }
    public FnInfo fi {
        get;
        set;
    }
    public g_srvc_definition__c sd {
        get;
        set;
    }
    public String isdoc {
        set;
        get;
    }

    public List<openAFSRequests> openAfsReqs {
        set;
        get;
    }
    public openAFSRequests currentAfsRequest {
        set;
        get;
    }
    //public string ttlAst {set;get;}
    //public string ttlLib {set;get;}
    //public string ttlEqt {set;get;}
    public string ast {
        set;
        get;
    }
    public List < String > srvList {
        set;
        get;
    }
    public String legalFrm {
        set;
        get;
    }
    public String licenseNbre {
        set;
        get;
    }
    public List < String > srvTrnsList {
        set;
        get;
    }
    public List < String > defdocLblList {
        set;
        get;
    }
    public List < String > docLblList {
        set;
        get;
    }
    public List < String > infoDocLst {
        set;
        get;
    }
    public g_Srvc__c srv {
        get;
        set;
    }
    public integer farDiff {
        get;
        set;
    }
    public dateTime liFirstDate {
        get;
        set;
    }
    public String financialYearStartDate {
       get;
       set;
    }
    public String financialYearEndDate {
        get;
        set;
    }
    public String latestSubmissionDate {
        get;
        set;
    }
    public String licenseIssueDate {
        get;
        set;
    }
    public String licenseFirstIssueDate {
        get;
        set;
    }
    public String newSubmissionDate {
        get;
        set;
    }
    //------------to be removed after testing -----------
    public String todayDate {
        get;
        set;
    }
    //------------end to be removed after testing---------
    public Boolean dsgu{
        set;
        get;
    }
    public Boolean ispu{get;set;}
    public Boolean penaltyApplied{get;set;}
// public string sfdcId
// {

//    get
//    {
//     String retVal='';
//     if (apexpages.currentpage().getparameters().get('id')!= null)
//     {
//         retval=apexpages.currentpage().getparameters().get('id');
//     }
//     return retval ;
//    }
// }

    public String formatDateToString(Date dateToFormat) {
        Integer yearValue = dateToFormat.year();
        Integer monthValue = dateToFormat.month();
        Integer dayValue = dateToFormat.day();
        Datetime dateInDateTime = Datetime.newInstance(yearValue, monthValue, dayValue);
        String financialYearStartDate = dateInDateTime.format('dd/MM/yyyy');
        return financialYearStartDate;
    }
    public List<UserAccountsWrapper> wrapperList{get;set;}
    public String DHREAcc{get;set;}
    public List<Account> afsBOAccs{get;set;}
    public String afsBOAccsStr{get;set;}
    public leAMLCtl() {
        //initialization
        String rqid =apexpages.currentpage().getparameters().get('id');
        String sid = '';
        fi = new FnInfo();

        User U = [SELECT id, contact.account.id, contact.account.Financial_Year_Start_Date__c, contact.account.Financial_Year_End_Date__c,
                  contact.account.Latest_Submission_Date__c, contact.account.Legal_Framework__c, contact.account.lcidt1__c,
                  contact.account.lcidt__c, isportalenabled, contact.account.NewSubmissionDate__c, contact.account.lc__c
                  FROM User
                  WHERE id =: UserInfo.getUserId()
                  LIMIT 1];

        //String DHREAcc = '{"005Ff000006MEqTIAW":["102202", "19299", "93067", "93068567", "9306722"], "005Ik0000010E3dIAE":["102202", "19299", "93067", "93068567", "9306722"]}';//System.Label.DHRE_Accounts;
        String DHREAcc = System.Label.DHRE_Accounts;
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(DHREAcc);
        system.debug('jsonMap  -- '+jsonMap);
        List<UserAccountsWrapper> wrapperList = new List<UserAccountsWrapper>();
        for (String key : jsonMap.keySet()) {
            wrapperList.add(new UserAccountsWrapper(key, jsonMap.get(key)));
        }

        List<String> accIdsAsString = new List<String>();
        //for (String userId : jsonMap.keySet()) {
        system.debug('U.id -- '+U.id);
        List<Object> accountIds = (List<Object>) jsonMap.get(U.id);
        accIdsAsString = new List<String>();
        if (accountIds != null) {
            for (Object accId : accountIds) {
                accIdsAsString.add((String) accId);
            }
        }
        System.debug('Account Ids as String: ' + accIdsAsString);
        //}
        afsBOAccs = [select id, name, lc__c from account where lc__c in:accIdsAsString];
        system.debug('afsBOAccs -- '+JSON.serialize(afsBOAccs));
        afsBOAccsStr = JSON.serialize(afsBOAccs);

        //logic

        ispu=gU.isPortalUser(UserInfo.getProfileId());
        financialYearStartDate = U.contact.account.Financial_Year_Start_Date__c != null ? formatDateToString(U.contact.account.Financial_Year_Start_Date__c):null;
        financialYearEndDate = U.contact.account.Financial_Year_End_Date__c != null? formatDateToString(U.contact.account.Financial_Year_End_Date__c):null;
        latestSubmissionDate=U.contact.account.Latest_Submission_Date__c != null? formatDateToString(U.contact.account.Latest_Submission_Date__c):null;
        licenseIssueDate= U.contact.account.lcidt__c != null? formatDateToString(U.contact.account.lcidt__c):null;
        licenseFirstIssueDate= U.contact.account.lcidt1__c != null? formatDateToString(U.contact.account.lcidt1__c):null;

        //newSubmissionDate =  U.contact.account.NewSubmissionDate__c != null? formatDateToString(U.contact.account.NewSubmissionDate__c):null;

        system.debug('financialYearStartDate ' + financialYearStartDate);
        date lcIssueDt = null;
        legalFrm = U.contact.account.Legal_Framework__c;
        licenseNbre = U.contact.account.lc__c;
        if (U.contact.account.lcidt1__c != null) {
            lcIssueDt = U.contact.account.lcidt1__c;
        }else{
            lcIssueDt = U.contact.account.lcidt__c;
        }
        if (lcIssueDt != null) {
            farDiff = lcIssueDt.daysBetween(system.today());
            liFirstDate = lcIssueDt;
        }
        if (String.isNotBlank(rqid)) {//afsbo
            rq = [select id, name, acc__c, acc__r.lc__c from g_req__c where id=:rqid];
            licenseNbre = rq.acc__r.lc__c;
        }
        currUserReqs = [select id, name, sta__c, Account_Name__c from g_req__c where Service_Code__c='aml' and createdbyId=:u.id and sta__c not in('Cancelled', 'Rejected', 'Completed')];
        currUserReqsJSON = JSON.serialize(currUserReqs);
        openAfsReqs=AuditReportHelper.getPreviousReqDetails(licenseNbre);
        List<openAFSRequests> tempList = new List<openAFSRequests>(); // Temporary list to hold non-matching elements
        //loop over the json and get the record for the current financial year and store it in a variable and remove it from the list
        for (openAFSRequests afsRequest : openAfsReqs) {
            if (afsRequest.financialYear == system.today().year()-1) {
                currentAfsRequest = afsRequest;
                System.debug('currentAfsRequest '+ currentAfsRequest.ddaId);
            }
            else{
                System.debug('templist '+ afsRequest);
            }
            if (afsRequest.financialYearStart != null && afsRequest.financialYearStart.trim().length()>0) {
                afsRequest.finYearStartDt = Date.valueOf(afsRequest.financialYearStart);
            }
            if (afsRequest.financialYearEnd != null && afsRequest.financialYearEnd.trim().length()>0) {
                afsRequest.finYearEndDt = Date.valueOf(afsRequest.financialYearEnd);
            }
            if (afsRequest.subRequests != null && afsRequest.subRequests.size()>0) {
                system.debug('#################################################'+afsRequest.subRequests[0]);
                if (afsRequest.subRequests[0].type=='AFS Request Date of Submission') {
                    if (afsRequest.subRequests[0].inProgress ) {
                        afsRequest.Status='In Progress';
                    }
                    else if (afsRequest.subRequests[0].isRejected) {
                        afsRequest.Status='Rejected Resubmission Required';
                    }
                    else if (afsRequest.subRequests[0].isApproved) {
                        afsRequest.Status='Date Extension approved';
                    }
                }
            }
            currentAfsRequest = openAfsReqs[0];
            tempList.add(afsRequest);
        }
        openAfsReqs = tempList;

        //----------------to be removed - added for testing purpose-----------------
        // openAfsReqs = new List<openAFSRequests>();
        //----------------to be removed - added for testing purpose-----------------

        //--------------new logic to open old request -------

        list<g_Req__c> listOpenRequest = new List<g_Req__c>();
        listOpenRequest = [SELECT id, STA__c, name, acc__r.name, acc__r.lc__c, xadtx1__c, dsgu__c, xadh__c, xcddocs__c, srvc__c, NewSubmissionDate__c, srvc__r.uid__c, xcpid__c, xcped__c
                           FROM g_req__c
                           WHERE  acc__r.id =: U.contact.account.id
                           AND Service_Code__c ='aml' ORDER BY
                           CreatedDate desc];
        //----end new logic to open old request---------------------
        if (String.isNotBlank(rqid)) {//|| (listOpenRequest[0].STA__c != 'Completed' && listOpenRequest[0].STA__c != 'Cancelled' && listOpenRequest[0].STA__c != 'Rejected' && openAfsReqs.isEmpty())
            //String requestId = String.isNotBlank(rqid)? rqid : listOpenRequest[0].Id;
            String requestId =rqid;
            rq = [SELECT id, name, acc__r.name, acc__r.lc__c, xadtx1__c, dsgu__c, xadh__c, xcddocs__c, srvc__c, NewSubmissionDate__c,
                  srvc__r.uid__c, xcpid__c, xcped__c
                  FROM g_req__c
                  WHERE id =: requestId]; //previously =: rqid
            sid = rq.srvc__c;
            system.debug('name +license '+ rq.name + rq.acc__r.lc__c + rq.xadtx1__c);
            if (rq != null && String.isNotBlank(rq.xadtx1__c)) {
                fi = (FnInfo) JSON.deserialize(rq.xadtx1__c, FnInfo.class);
                system.debug('fi output: '+fi);
            }
            if (Apexpages.currentPage().getUrl().contains('AuditReport')) {
                Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename="AuditReport_' + rq.acc__r.name + '.pdf"');
            }
        } else {
            sid = apexpages.currentpage().getparameters().get('sid');
            system.debug('sid -- '+sid);
            sid = String.isNotBlank(sid)?sid:'a0L2y00000fV4xdEAC';
            rq = new g_Req__c();
            rq.acc__c = U.contact.account.id;
            rq.srvc__c = sid;
            rq.STA__c = 'Open';
        }

        srv = [SELECT id, xoi__c, sdg__c, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c,
               consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c,
               stg__r.reqq__c
               FROM g_Srvc__c
               WHERE id =: sid
               LIMIT 1];
        sd = [SELECT id, Name, sd__c, Category__c, Sub_Category__c, pyChk__c, srvlbl__c, docslbl__c,
              srvdocs__c, srvtdocs__c, vtyp__c, srat__c, srv__c, srvt__c, slbl__c, ptype__c, skpsd__c,
              cv__c, insreq__c
              FROM g_srvc_definition__c
              WHERE id =: srv.sdg__c]; //where AccTp__c in ('Customer - External; Customer - LAS', 'Customer - External')
        if (String.isNotBlank(sd.docslbl__c)) {
            docLblList = sd.docslbl__c.split(';');
            defdocLblList = sd.docslbl__c.split('#');
        }
        if (defdocLblList != null && defdocLblList.size() > 0) {
            docLblList = defdocLblList[0].split(';');
        }
        if (defdocLblList != null && defdocLblList.size() > 1) {
            infoDocLst = defdocLblList[1].split(';');
        }
    }
    public PageReference createAFSReq_BO() {//afsbo
        PageReference pageRef = null;
        system.debug(' in createAFSReq');
        g_req__c req = new g_Req__c();
        String sid = apexpages.currentpage().getparameters().get('sid');
        String accId = apexpages.currentpage().getparameters().get('accId');
        sid = String.isNotBlank(sid)?sid:'a0L2y00000fV4xdEAC';
        //Account acc = [select id, name from Account where Id=:accId];
        req.acc__c = accId;
        req.srvc__c = sid;
        req.STA__c = 'Open';
        system.debug('req -- '+JSON.serialize(req));
        if (req != null) {
            if (Schema.sObjectType.g_req__c.isCreateable()) {
                insert req;
            }
            pageRef =  new PageReference('/apex/lerqaml?id='+req.id);
            pageref.setRedirect(true);
        }
        system.debug('pageRef -- '+pageRef);
        return pageRef;
    }
    public Pagereference saveReq() {
        system.debug('MyfinancialYearStartDate '+ financialYearStartDate);
        try {
            PageReference pageRef = null;
            integer strYr = fi.yearstartdate.year();//fi.yearstartdate.year();
            system.debug('strYr '+ strYr);
            integer endYr = fi.yearenddate.year();//fi.yearenddate.year();
            system.debug('strYr:' + strYr + 'endYr:' + endYr);
             rq.xdei__c=  fi.ddaId;
            List < g_req__c > dpRQLst = new  List < g_req__c >();

            /*[SELECT id, name
                                         FROM g_req__c
                                         WHERE srvc__r.uid__c = 'aml'
                                         AND acc__c =: rq.acc__c
                                         AND sta__c != 'Cancelled' AND CALENDAR_YEAR(xcpid__c) =: strYr AND CALENDAR_YEAR(xcped__c) =: endYr];
                                         *///AND CALENDAR_YEAR(xcpid__c) =: strYr AND CALENDAR_YEAR(xcped__c) =: endYr  --> there is no more user input for date it is done automatically
            system.debug('##### withinifcondition ' +dpRQLst );
            if (dpRQLst == null || dpRQLst.isEmpty() || (String.isNotBlank(rq.id) && dpRQLst != null && !dpRQLst.isEmpty() && dpRQLst[0].id == rq.id)) {
                system.debug('##### withinifcondition');
                fi.totalasset = String.valueof((String.isNotBlank(fi.currentassets) ? decimal.valueOf(fi.currentassets) : 0.00) +
                    (String.isNotBlank(fi.fixedassets) ? decimal.valueOf(fi.fixedassets) : 0.00) + (String.isNotBlank(fi.otherassets) ? decimal.valueOf(fi.otherassets) : 0.00) +
                    (String.isNotBlank(fi.investments) ? decimal.valueOf(fi.investments) : 0.00));
                fi.totalLiabilities = String.valueof((String.isNotBlank(fi.currentliabilities) ? decimal.valueOf(fi.currentliabilities) : 0.00) +
                    (String.isNotBlank(fi.longtermliabilities) ? decimal.valueOf(fi.longtermliabilities) : 0.00));
                fi.totalequity = String.valueof((String.isNotBlank(fi.sharecapital) ? decimal.valueOf(fi.sharecapital) : 0.00) +
                    (String.isNotBlank(fi.retainedearnings) ? decimal.valueOf(fi.retainedearnings) : 0.00) +
                        (String.isNotBlank(fi.reservesandsurplus) ? decimal.valueOf(fi.reservesandsurplus) : 0.00));
                fi.assest = String.valueof((String.isNotBlank(fi.currentliabilities) ? decimal.valueOf(fi.currentliabilities) : 0.00) +
                    (String.isNotBlank(fi.longtermliabilities) ? decimal.valueOf(fi.longtermliabilities) : 0.00) + (String.isNotBlank(fi.sharecapital) ? decimal.valueOf(fi.sharecapital) : 0.00) +
                    (String.isNotBlank(fi.retainedearnings) ? decimal.valueOf(fi.retainedearnings) : 0.00) +
                        (String.isNotBlank(fi.reservesandsurplus) ? decimal.valueOf(fi.reservesandsurplus) : 0.00));
                rq.NewSubmissionDate__c = fi.newSubmissionDate;
                //rq.xcpid__c = fi.yearstartdate;
                //rq.xcped__c = fi.yearenddate;
                //fi.yearstartdate = financialYearStartDate;
                String fiJs = JSON.serialize(fi);
                system.debug('js::' + fiJs);
                rq.xadtx1__c = fiJs;
                rq.xdei__c=  fi.ddaId;
                if (Schema.sObjectType.g_req__c.isCreateable()) {
                    upsert rq;
                }
                User user = [SELECT Id, Contact.AccountId
                             FROM User
                             WHERE Id = :UserInfo.getUserId()
                             LIMIT 1];
                Account accountToUpdate = [SELECT Id, Latest_Submission_Date__c, NewSubmissionDate__c
                                           FROM Account
                                           WHERE Id = :rq.acc__c //user.Contact.AccountId
                                           LIMIT 1];
                accountToUpdate.Latest_Submission_Date__c = fi.yearenddate;
                accountToUpdate.NewSubmissionDate__c = fi.newSubmissionDate;
                if (Schema.sObjectType.Account.isUpdateable()) {
                    update accountToUpdate;
                }
                //to check if we should redirect to upload page or SInfo page
                List<g_reqitemDoc__c> reqItemDocs = [
                    SELECT Id, reqItm__r.RQ__r.Name, Req__c
                    FROM g_reqitemDoc__c
                    WHERE reqItm__r.RQ__r.Id = :rq.id];

                Boolean allRequiredFalse = true;
                for (g_reqitemDoc__c reqItemDoc : reqItemDocs) {
                    // If any record has Req__c as true, set the flag to false and break the loop
                    if (reqItemDoc.Req__c == true) {
                        allRequiredFalse = false;
                        break;
                    }
                }
                //-------------------penalty logic -------------------------
                //query all request items (service charge, ...)and check if item where code is sd3

                List <g_reqitem__c> listRequestItems = new List<g_reqitem__c >();
                listRequestItems = [SELECT id, itmCd__c, scN__c FROM g_reqitem__c WHERE AP__c=0 and RQ__c = :rq.id AND itmCd__c in ('sd3', 'afs', 'ar')];

                if (!listRequestItems.isEmpty() ) {
                    //check if today > financialYear + 180 days
                   // if (penaltyapplied) {//penaltyapplied
                        listRequestItems[0].scN__c = Decimal.valueOf(currentAfsRequest.totalAmountToPay);
                        update listRequestItems[0];
                  //  }
                    system.debug('penalty case' + penaltyApplied) ;
                }

                //------------------End of penalty logic ---------------------------

                if (allRequiredFalse) {
                    //to be reovled

                    List < g_reqitem__c > riLst = [select id from g_reqitem__c where RQ__c =: rq.id];
                    if (riLst != null && !riLst.isEmpty()) {
                        grqWsDcca.serviceRequest reqjsRq = new grqWsDcca.serviceRequest();
                        grqWsDcca.serviceReq req = new grqWsDcca.serviceReq();
                        req.service = 'Submission of Annual Financial Statement';
                        req.serNm = 'Submission of Annual Financial Statement';
                        //system.debug('justificationNo::' + rq.xadtx4__c);
                        grqWsDcca.AuditInfo ad = (grqWsDcca.AuditInfo) JSON.deserialize(rq.xadtx1__c, grqWsDcca.AuditInfo.class);
                       /// fi.yearstartdate = null;
                        req.auditedData = ad;
                        //req.auditedData.yearstartdate = null;
                        system.debug('rq.name '+ rq.name);
                        system.debug('rq.licenseNo '+ rq.acc__r.lc__c);
                        system.debug('fi.ddaId '+ fi.ddaId);

                        req.refAXS = rq.name;
                        req.licenseNo = licenseNbre;
                        req.extAXS = fi.ddaId;

                       // req.cFRNotes = rq.xadtx1__c;
                      if (rq.dsgu__c) req.attaFlag = true;
                      else req.attaFlag = false;
                      List < grqWsDcca.serviceReq > lst = new List < grqWsDcca.serviceReq > ();
                      lst.add(req);
                      reqjsRq.serviceRequest = lst;
                      String rqbody = JSON.serialize(reqjsRq);
                      ws_call__c ws = new ws_call__c();
                      ws.rq_jsn__c = rqbody;
                      ws.ws_typ__c = 'DCCA Letters';
                      ws.mtd_nm__c = 'auditform';
                      ws.uid__c = rq.id + '' + '' + ws.mtd_nm__c + system.now();
                      ws.rq_itm__c = riLst[0].id;
                      ws.intsts__c = 'Ready for Integration';
                      if (Schema.sObjectType.ws_call__c.isCreateable()) {
                          insert ws;
                      }
                      }
                      rq.sta__c = 'Open';
                      if (Schema.sObjectType.g_req__c.isUpdateable()) {
                          update rq;
                      }
                      pageRef = new PageReference('/apex/grqSInfo?id=' + rq.id);
                      /*Information page*/
                }else{
                    rq.sta__c = 'Open';
                    if (Schema.sObjectType.g_req__c.isUpdateable()) {
                        update rq;
                    }
                    pageRef = new PageReference('/apex/lrqup?id=' + rq.id);//upload document page
                }
            } else {
              //  gu.AddErrorMsg('Request already submitted for provided financial year:' + dpRQLst[0].name);
            }
            return pageRef;
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            system.debug('ex msg::' + e.getMessage());
            system.debug('ex line number::' + e.getLineNumber());
            gU.AddErrorMsg(e.getMessage()+'---'+e.getStackTraceString());
            return null;
        }
    }
    public PageReference updateSelectedCurrency() {
        return null;
    }
    public class UserAccountsWrapper {
        public String userId;
        public object accountNumbers;

        public UserAccountsWrapper(String userId, object accountNumbers) {
            this.userId = userId;
            this.accountNumbers = accountNumbers;
        }
    }
    public class FnInfo {
        public String revenues {
            set;
            get;
        }
        public String costofsales {
            set;
            get;
        }
        public String grossprofit {
            set;
            get;
        }
        public String operatingcost {
            set;
            get;
        }
        public String operatingprofit {
            set;
            get;
        }
        public String interestexpenses {
            set;
            get;
        }
        public String depreciation {
            set;
            get;
        }
        public String amortization {
            set;
            get;
        }
        public String otherincomeorloss {
            set;
            get;
        }
        public String netprofit {
            set;
            get;
        }
        public String currentassets {
            set;
            get;
        }
        public String fixedassets {
            set;
            get;
        }
        public String investments {
            set;
            get;
        }
        public String otherassets {
            set;
            get;
        }
        public String currentliabilities {
            set;
            get;
        }
        public String longtermliabilities {
            set;
            get;
        }
        public String sharecapital {
            set;
            get;
        }
        public String retainedearnings {
            set;
            get;
        }
        public String reservesandsurplus {
            set;
            get;
        }
        public string totalasset {
            set;
            get;
        }
        public string totalLiabilities {
            set;
            get;
        }
        public string totalequity {
            set;
            get;
        }
        public string assest {
            set;
            get;
        }
        public string auditfirm {
            set;
            get;
        }

        public String financialYear {
            set;
            get;
        }
        public String reasonNonSubmission {
            set;
            get;
        }
        public date yearstartdate {
            set;
            get;
        }

        /*public String yearstartdate {
            set;
            get;
        }*/

        public date yearenddate {
            set;
            get;
        }
        public date newSubmissionDate {
            set;
            get;
        }
        public string reasonNewSubmissionDate {
            set;
            get;
        }
        public String selectedCurrency {
            set;
            get;
        }
        public String ddaId {
            set;
            get;
        }
         public String feesAndTaxes {
            set;
            get;

        }
        public String workerCompensation {
                set;
                get;
        }

    }
}
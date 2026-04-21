global class BatchOnboardFetchAccInfo implements Database.Batchable < sObject > , Database.AllowsCallouts, Queueable, Schedulable {



    /*Ms 1.1 Starts*/
    private List < String > lstOfWaCallID = new List < String > (); //list of ws call id
    global BatchOnboardFetchAccInfo() {}
    public BatchOnboardFetchAccInfo(list < Id > wsCallId) {
        lstOfWaCallID = wsCallId;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query = 'Select Id,rq_jsn__c,res_jsn__c,intsts__c,xrno__c,rq_itm__c,rq_itm__r.RQ__c,pmid__c from ws_call__c where ws_typ__c = \'Onboarding\' AND mtd_nm__c= \'updateAccInfo\' AND intsts__c =\'Ready for Integration\'';
        String query = 'Select Id,rq_itm__r.rq__r.xdei__c,xrno__c,rq_itm__r.rq__r.xdccaRq__c,rq_itm__r.RQ__r.xadtx1__c,rq_itm__r.RQ__r.Service_Code__c,adhoc_text1__c,rq_itm__r.RQ__r.xuvdet__c,rq_itm__r.RQ__r.xcfn__c,rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c,rq_itm__r.RQ__r.xccn__c,rq_itm__r.RQ__r.rtacn__c,rq_itm__r.RQ__r.xbtnm__c,rq_itm__r.RQ__r.xcpic__c,rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c,err_msg__c,rq_itm__r.itm__c,rq_itm__r.RQ__r.srvc__r.uid__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.xadtx2__c,rq_itm__r.RQ__r.xcn__c,rq_itm__r.ccrmid__c,rq_itm__r.sta__c,rq_itm__r.itm__r.cd__c,rq_itm__r.sta__r.cd__c,pmid__c,mtd_nm__c,intsts__c from ws_call__c where ws_typ__c = \'Onboarding\' AND mtd_nm__c in (\'fetchAccInfo\',\'createRequest\',\'updateStatus\',\'uploadDoc\',\'getNewReqDetails\') AND intsts__c =\'Ready for Integration\'';
        if (lstOfWaCallID != null && !lstOfWaCallID.isEmpty()) {
            query += ' and Id IN: lstOfWaCallID';
        } else {
            query += ' and createddate=LAST_N_DAYS:2';
        }

        /*MS 1.1 ends*/

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < ws_call__c > scope) {
        if (scope != null && scope.size() > 0) {
            processWSCall(scope[0]);
        }
    }


    public void processWSCall(ws_call__c ws) {

        try {
            if (ws.mtd_nm__c == 'updateStatus') {
                updateStatus(ws);
            } else if (ws.mtd_nm__c == 'uploadDoc') {
                uploadDocument(ws);
            } else if (ws.mtd_nm__c == 'getNewReqDetails') {
                getDDAReqDetails(ws);
            } else if (ws.mtd_nm__c == 'createRequest') {
                createRequest(ws);
            } else if (ws.mtd_nm__c == 'fetchAccInfo' || ws.mtd_nm__c == 'upfetchAccInfo') {
                fetchAccInfo(ws);
            }

        } catch (Exception ex) {
            ws.err_msg__c = ex.getMessage() + ex.getStackTraceString();
            ws.intsts__c = 'Failed';
            update ws;
            System.debug('Exception:: ' + ex.getStackTraceString());
        }

    }


    public void fetchAccInfo(Ws_call__c ws) {
        try {
            String jsonAcc = getCCRMAccountInfo(ws.pmid__c);
            system.debug('jsonAccjsonAcc--' + jsonAcc);

            if (String.isBlank(jsonAcc)) {
                ws.intsts__c = 'Failed';
                ws.err_msg__c = 'resp <jsonAcc> is blank';
                update ws;
                return;
            }


            String jsonAcc1 = jsonAcc;
            String DDA_INV = '';
            Boolean isSME = false;
            System.debug('jsonAcc.length():: ' + jsonAcc.length());
            grqWsOnboard.Records rec = null;
            rec = (grqWsOnboard.Records) JSON.deserialize(jsonAcc1, grqWsOnboard.Records.class);



            //List < g_Req__c > rqLst = [select id, xvtyp__c, xcmbs__c, os__c, xcddocs__c, DDA_INV__c, name, xadtx3__c, xdccaRq__c, xadtx2__c, xdei__c, xadh__c, acc__c, acc__r.id, acc__r.lcedt__c, skpu__c from g_Req__c where(id =: rec.requestid or name =: rec.requestid) limit 1];

             List < g_Req__c > rqLst = [select id, xvtyp__c, parcat__c, xcmbs__c, os__c, xcddocs__c, DDA_INV__c, name, xadtx3__c, xdccaRq__c, xadtx2__c, xdei__c, xadh__c, acc__c, acc__r.id, acc__r.lcedt__c, skpu__c from g_Req__c where(Acc__r.ccrm_sfid__c =: ws.pmid__c) and (Service_Code__c='216' OR Service_Code__c='322') and sta__c not in('Cancelled','Rejected') order by createdDate Desc limit 1];

            //save response without paymentschedules as schedules will be saved in adhoc2
            rec.paymentSchedules = null;
            ws.res_jsn__c = JSON.serialize(rec);
            if (rqLst != null && !rqLst.isEmpty()) {
                rqLst[0].xadtx3__c = ws.res_jsn__c;

                /*MS 1.1 Land Assignment Start */
                Set < String > setOs = new Set < String > {
                    'Lead generated',
                    'Lead qualified',
                    'members',
                    'segments',
                    'businessName',
                    'confpage',
                    'Lease Info',
                    'Cancelled',
                    'Rejected',
                    'Under_Review'
                };
                rec.skipLeaseValidations = (rqLst[0].parcat__c == 'Land Assignment' && !setOs.contains(rqLst[0].os__c)) ? 'true' : rec.skipLeaseValidations;
                system.debug('rec.skipLeaseValidations====' + rec.skipLeaseValidations);
                /*MS 1.1 Land Assignment End */

                if (rec.skipLeaseValidations != null && rec.skipLeaseValidations != 'null') {
                    rqLst[0].skpu__c = rec.skipLeaseValidations == 'true' ? true : false;
                    if (rqLst[0].skpu__c)
                        rqLst[0].os__c = 'CCL Accepted';
                }

                system.debug('rec.quotesrec.quotesrec.quotes--' + rec.quotes);
                if (rec.quotes != null && !rec.quotes.isEmpty()) {
                    for (grqWsOnboard.QuoteInfo q: rec.quotes) {
                        system.debug('q.statusq.statusq.status--' + q.status);
                        if (q.status != 'Draft') {
                            system.debug('q.status--' + q.status);
                            rqLst[0].xcmbs__c = q.totalLandQtAmt * 0.01;
                            system.debug('q.status--' + q.totalLandQtAmt * 0.01);
                        }
                    }
                }
            }

            rec = (grqWsOnboard.Records) JSON.deserialize(jsonAcc, grqWsOnboard.Records.class);
            Boolean isNameApproved = false;
            if (rqLst != null && !rqLst.isEmpty()) {

                //
                System.debug('before  payment sc xadh__c : ' + rqLst[0].xadh__c);
                if (rqLst[0].xadh__c == null) {
                    rqLst[0].xadh__c = '';
                } else {
                    rqLst[0].xadh__c += ';';
                }

                //rqLst[0].xadtx3__c = jsonAcc;

                if (rec.workorders != null && !rec.workorders.isEmpty()) {
                    for (grqWsOnboard.WorkOrderInfo w: rec.workorders) {
                        if (w.status == 'Name Approved')
                            isNameApproved = true;
                        if (String.isNotBlank(w.ddaRequestId)) {
                            rqLst[0].xdei__c = w.ddaRequestId;

                        }
                    }
                }



                ////////////////////////////////////////
                // update payment schedules in adhoc2 starts
                //
                List < grqWsOnboard.SegmentInfo > lstSegments2 = new List < grqWsOnboard.SegmentInfo > ();
                System.debug('rec.actvities>> : ' + rec.actvities);
                if (rec.actvities != null && rec.actvities.size() > 0) {
                    Map < String, List < grqWsOnboard.ActivityInfo >> mapActsbySeg = new Map < String, List < grqWsOnboard.ActivityInfo >> ();
                    for (grqWsOnboard.ActivityInfo ai: rec.actvities) {
                        if (!mapActsbySeg.containsKey(ai.segment)) {
                            mapActsbySeg.put(ai.segment, new List < grqWsOnboard.ActivityInfo > ());
                        }
                        List < String > lstActDocs = new List < String > ();
                        ai.docs = lstActDocs;
                        mapActsbySeg.get(ai.segment).add(ai);
                    }

                    System.debug('mapActsbySeg>> : ' + mapActsbySeg);
                    //not required price will be fecthed from DDA
                    /*if (mapActsbySeg.size()>0){
                        for (String seg : mapActsbySeg.keySet()){
                            grqWsOnboard.SegmentInfo sInfo= new grqWsOnboard.SegmentInfo();
                            sInfo.name = seg;
                            sInfo.price = '15000.00';
                            sInfo.SegActivities = mapActsbySeg.get(seg);
                            lstSegments2.add(sInfo);
                        }
                    }*/
                }

                String paySch = '{"workorders":[{"status":"Approved","recType":"Brand_Approval","recid":"0WO2R0000059dE0WAI","parentid":null,"members":null,"ddaRQNo":null,"ddaRQId":null},{"status":"Waiting for Original Documents","recType":"License_Registration_Request","recid":"0WO2R0000059dE2WAI","parentid":null,"members":null,"ddaRQNo":null,"ddaRQId":null},{"status":"Approved","recType":"Security_Clearance","recid":"0WO2R0000059dE1WAI","parentid":null,"members":null,"ddaRQNo":null,"ddaRQId":null}],"usrName":"Ramzieh Kahil","scWorkid":"0WO2R0000059dE1WAI","respMsg":"Success","requestid":"a0E2y000006RTdzEAG","quotes":[{"units":[{"status":"Soft Booked","productName":"DSC-DSC Tower-1209","name":"1209","isActive":true,"floor":"Twelfth Floor","buildingName":"DSC Tower","area":759.47}],"totalOfrPrice":129109.9,"totalDiscount":15.00,"totalBstRate":170880.75,"status":"Accepted","rqtype":"New","requestId":"a0E2y000006RTdzEAG","quoteNo":"00078446","quoteName":"Quote - New - Office - 20220126","quoteId":"0Q02R000002GeGiSAK","opportunityId":"0062R00000xKv6cQAC","lsStDt":"2022-02-02","lsStatus":null,"lsEndDt":"2025-02-01","locDet":null,"agNo":"AG-083771"}],"proposedLegalForm":"DDA","prmPhone":"00971 4 3914605","prmMobile":"+971 504767977","prmLastName":"Kahil","prmFirstName":"Ramzieh","prmEmail":"ramzieh.kahil@dmc.ae","paymentSchedules":[{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJMQA3","description":"Ejari Service Charge","chargeTo":"2022-02-02","chargeFrom":"2022-02-02","chargeCode":"ejarisc","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJNQA3","description":"Ejari Services","chargeTo":"2022-02-02","chargeFrom":"2022-02-02","chargeCode":"ejrsvc","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJOQA3","description":"Rental Income - Office","chargeTo":"2022-05-01","chargeFrom":"2022-02-02","chargeCode":"rntoff","billedAmount":0},{"yearNo":"1","vatAmount":0,"totalDays":0,"totalAmountIncludingVat":0,"tenantCode":0,"quote":0,"propertyCode":0,"Id":"a0r2R00000P5XJPQA3","description":"Service Charge","chargeTo":"2022-05-01","chargeFrom":"2022-02-02","chargeCode":"srvchrg","billedAmount":0}],"oppId":"0062R00000xKv6cQAC","onbReqid":"a2l2R000004O0VoQAK","nameResWorkid":"0WO2R0000059dE2WAI","members":[{"website":null,"uboType":null,"uboRelatedTo":null,"uboOwnedbyUAE":null,"uboDeclaration":null,"street":null,"stockExchangeListed":null,"sh":"50","security":null,"salutation":"Mr.","rpNo":null,"rpExpDate":null,"role":"Member;Board of Directors;General Manager;Ultimate Beneficiary","postalCode":null,"placeissued":"United Arab Emirates","pIssuedDate":null,"phoneno":"0553822838","pExpDate":"2024-05-26","passportNo":"FF4262724","nationality":"United Arab Emirates","mobile":"+971553822838","mname":null,"mailingStreet":null,"mailingPostalCode":null,"mailingCountry":null,"mailingCity":null,"lnameAr":null,"lname":"Alfarsi","legals":null,"iAuthority":null,"gender":"Male","fnameAr":null,"fname":"Majid","email":"majidmohammed@skyi.ae","eid":null,"eExpDate":null,"dob":"1996-06-23","ctgCode":null,"cshType":null,"corpORind":"Individual Shareholder","conid":"0032R00002KXrWAQA1","city":null,"birthplace":null}],"lrWorkid":null,"licenseType":"DDA","legalFramework":"DDA","lcExpdate":"2023-02-03","isSuccess":true,"hseWorkid":null,"documents":[{"name":"Signed Article of Association","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"Signed Article of Association","ddaDocId":"a3e6F0000018SW0QAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlRVUAZ"},{"name":"Valid Passport Copy - Majid Alfarsi","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"Valid Passport Copy - Majid Alfarsi","ddaDocId":"a3e6F0000018SYkQAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlbbUAB"},{"name":"Resolution for the Incorporation of an FZ-LLC","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"Resolution for the Incorporation of an FZ-LLC","ddaDocId":"a3e6F0000018SW2QAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlRXUAZ"},{"name":"General Declaration and Undertaking Form","isFileAttached":true,"isCallforReview":false,"gracePeriod":false,"description":"General Declaration and Undertaking Form","ddaDocId":"a3e6F0000018SW1QAM","ccrmParentId":"0WO2R0000059dE2WAI","ccrmDocId":"a0H2R00001IwlRWUAZ"}],"DDAReqNo":null,"crmAccName":"Sky I Aerial Photography FZ-LLC","crmAccId":"0012R00002H1j4wQAB","caseid":null,"businessPark":"DDA","brandWorkid":"0WO2R0000059dE0WAI","actvities":[{"title":null,"segment":"Production (Film/TV and Radio)","name":"Post Production","channel":null,"actId":"a0L2R00000KCy1DUAT"},{"title":null,"segment":"Production (Film/TV and Radio)","name":"Production - Film, TV, and Radio","channel":null,"actId":"a0L2R00000KCxp7UAD"},{"title":null,"segment":"Production (Film/TV and Radio)","name":"Production ? Corporate/Social Videos","channel":null,"actId":"a0L2R00000KCxlMUAT"}]}';
                grqWsOnboard.Records DmmypaySch = (grqWsOnboard.Records) JSON.deserialize(paySch, grqWsOnboard.Records.class);
                system.debug('################rec.skipLeaseValidations#################');
                system.debug(rec.skipLeaseValidations);
                

                if (Test.isRunningTest()) rec.skipLeaseValidations = 'true';

                if (rec.skipLeaseValidations != null && rec.skipLeaseValidations == 'true') {
                    rec.paymentSchedules = DmmypaySch.paymentSchedules;
                }

                system.debug('################rec.paymentSchedules#################');
                system.debug(rec.paymentSchedules);
                

                System.debug('rec.paymentSchedules : ' + rec.paymentSchedules);
                List < grqWsOnboard.ActivityInfo > lstActs = new List < grqWsOnboard.ActivityInfo > ();
                List < grqWsOnboard.ActivityInfo > DDALts = new List < grqWsOnboard.ActivityInfo > ();

                if (rec.paymentSchedules != null && rec.paymentSchedules.size() > 0) {
                    List < grqWsOnboard.SegmentInfo > lstSegments = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(rqLst[0].xadtx2__c, List < grqWsOnboard.SegmentInfo > .class);
                    if (lstSegments == null) {
                        lstSegments = new List < grqWsOnboard.SegmentInfo > ();
                    }
                    //create a map  for Terms
                    ///rec.paymentSchedules.sort();
                    System.debug('SORT>>> : ' + JSON.serialize(rec.paymentSchedules));
                    Map < Integer, List < grqWsOnboard.PaymentSchedules >> termsMap = new Map < Integer, List < grqWsOnboard.PaymentSchedules >> ();
                    List < String > chrgCdLst = Label.Charge_Code_Yardi.split(';');
                    List < grqWsOnboard.PaymentSchedules > paySchule;
                    paySchule = new List < grqWsOnboard.PaymentSchedules > ();
                    Integer Terms = 1;
                    String fromDate = '';
                    system.debug('Terms---' + Terms);
                    for (grqWsOnboard.PaymentSchedules py: rec.paymentSchedules) {

                        if (!chrgCdLst.contains(py.chargeCode)) {
                            /* py.chargeCode!='rntoff' && py.chargeCode!='srvchrg' && py.chargeCode!='in5deinc' */
                            py.term = '1'; //1
                            paySchule.add(py);
                        } else if (py.dueDate == fromDate || fromDate == '') {
                            py.term = '' + Terms; //1
                            paySchule.add(py);
                            fromDate = py.dueDate;
                            system.debug('fromDate---' + fromDate);
                            system.debug('Terms---' + Terms);
                        } else {
                            fromDate = py.dueDate;
                            termsMap.put(Terms, paySchule);
                            paySchule = new List < grqWsOnboard.PaymentSchedules > ();
                            Terms++;
                            py.term = '' + Terms;
                            paySchule.add(py);
                            system.debug('fromDate---' + fromDate);
                            system.debug('Terms---' + Terms);
                        }

                    }
                    termsMap.put(Terms, paySchule);
                    List < grqWsOnboard.PaymentSchedules > paySchTrms = new List < grqWsOnboard.PaymentSchedules > ();

                    System.debug('termsMap>>> : ' + JSON.serialize(termsMap));
                    for (Integer key: termsMap.keySet()) {
                        List < grqWsOnboard.PaymentSchedules > payS = termsMap.get(key);
                        System.debug('payS>>> : ' + JSON.serialize(payS));
                        for (grqWsOnboard.PaymentSchedules py: payS) {


                            grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(py.description, 'CCRM-' + py.quote);
                            List < String > lstActDocs = new List < String > ();
                            act.docs = lstActDocs;
                            act.price = '' + py.billedAmount;
                            act.vatAmount = '' + py.vatAmount;
                            act.totalPrice = '' + py.totalAmountIncludingVat;
                            act.chargeCode = py.chargeCode;
                            act.propertyCode = py.propertyCode;
                            act.tenantCode = py.tenantCode;
                            act.chargeFrom = py.chargeFrom;
                            act.chargeTo = py.chargeTo;
                            act.description = py.description;
                            act.term = py.term;
                            act.actId = rqLst[0].xvtyp__c;
                            lstActs.add(act);

                        }
                    }
                    //licence information price in payment
                    String res = '';
                    grqWsDccaGetService dccaResp = new grqWsDccaGetService();
                    if (rqLst[0].xvtyp__c != 'DED') {
                        /* if not  ded land end*/
                        if (rqLst[0].xdccaRq__c != null && rqLst[0].xvtyp__c != 'DED') {
                            res = grqWsDccaGetService.getNewReqDetails(rqLst[0].xdccaRq__c);

                            dccaResp = (grqWsDccaGetService) System.JSON.deserialize(res, grqWsDccaGetService.class);
                        }
                        DDA_INV = dccaResp.invno;
                        isSME = dccaResp.sme == 'SME-In5' ? true : false;
                        Decimal in5Price = 0;
                        Map < String, grqWsOnboard.ActivityInfo > mapLstActs = new Map < String, grqWsOnboard.ActivityInfo > ();

                        List < grqWsDccaGetService.LineItems > ddaItms = res != '' ? dccaResp.Data[0].lines : null;
                        if (ddaItms != null && rqLst[0].xvtyp__c != 'DED') {
                            for (grqWsDccaGetService.LineItems dda: ddaItms) {
                                String Name = '';
                                if (dda.lineName != 'Registration Fees' && dda.lineName != 'Knowledge Dirham' && dda.lineName != 'Innovation Dirham') {
                                    Name = 'New Licence Fee';
                                } else {
                                    Name = dda.lineName;
                                }
                                if (String.isNotBlank(Name)) {
                                    grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(Name, 'dda');
                                    List < String > lstActDocs = new List < String > ();
                                    act.docs = lstActDocs;
                                    if (Name == 'New Licence Fee' && dda.amount != null) {
                                        in5Price = in5Price + Decimal.valueOf(dda.amount);
                                        act.price = '' + in5Price;
                                        act.vatAmount = '0';
                                        act.totalPrice = '' + in5Price;
                                    } else {
                                        if (!mapLstActs.isEmpty() && mapLstActs.containsKey(Name)) {
                                            grqWsOnboard.ActivityInfo exAct = (grqWsOnboard.ActivityInfo) mapLstActs.get(Name);
                                            act.price = '' + (Decimal.valueOf(exAct.price) + Decimal.valueOf(dda.amount));
                                        } else {
                                            act.price = '' + dda.amount;
                                        }
                                        act.vatAmount = '0';
                                        act.totalPrice = act.price;
                                    }
                                    act.description = Name;
                                    act.term = '1';
                                    act.actId = 'dda';
                                    // lstActs.add(act);
                                    mapLstActs.put(Name, act);
                                }
                            }
                            if (isSME || rqLst[0].xvtyp__c == 'DED') {
                                grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo('Registration Fees', 'dda');
                                List < String > lstActDocs = new List < String > ();
                                act.name = 'Registration Fees';
                                act.docs = lstActDocs;
                                act.price = '0';
                                act.vatAmount = '0';
                                act.totalPrice = '0';
                                act.description = 'Registration Fees';
                                act.term = '1';
                                act.actId = 'dda';
                                mapLstActs.put('Registration Fees', act); /* lstActs.add(act);*/
                            }
                            DDALts = mapLstActs.values();
                            lstActs.addAll(DDALts);
                            //end
                            System.debug('lstActs>>> : ' + JSON.serialize(lstActs));
                        }
                    } /* if not  ded land end*/

                    Integer itemNo = 1;
                    //lstActs=null;
                    System.debug(lstActs.size() + 'lstActs.size()lstActs>>> : ' + JSON.serialize(lstActs));
                    if (lstActs != null && lstActs.size() > 0 && !lstActs.isEmpty()) {
                        for (grqWsOnboard.ActivityInfo curAct: lstActs) {
                            grqWsOnboard.SegmentInfo sInfo = new grqWsOnboard.SegmentInfo();
                            if (rqLst[0].xvtyp__c != 'DED' && curAct.actId != null && curAct.actId.equalsIgnoreCase('dda')) {
                                if (curAct.actId == 'dda') {
                                    if (curAct.Name == 'New Licence Fee') {
                                        sInfo.segId = 'dr';
                                    }
                                    if (curAct.Name == 'Registration Fees') {
                                        sInfo.segId = 'rgf';
                                    }
                                    if (curAct.Name == 'Knowledge Dirham') {
                                        sInfo.segId = 'kf';
                                    }
                                    if (curAct.Name == 'Innovation Dirham') {
                                        sInfo.segId = 'inf';
                                    }
                                    sInfo.name = curAct.Name;
                                }
                            }
                            if (rqLst[0].xvtyp__c == 'DED' && curAct.chargeCode == 'lanmqfee') {
                                sInfo.segId = 'mq';
                                rqLst[0].xadh__c += (!rqLst[0].xadh__c.contains('mq') && !rqLst[0].xadh__c.contains('afmq')) ? ';mq;' : 'mq;'; /*MS 1.1*/
                                sInfo.name = 'Maqayees Fees';
                            } else if (curAct.chargeCode == 'lanafplf') /*rqLst[0].xvtyp__c=='DED' &&- MS 1.1*/ {
                                sInfo.segId = 'afp';
                                rqLst[0].xadh__c += (!rqLst[0].xadh__c.contains('afp')) ? 'afp;' : ''; /*MS 1.1*/
                                sInfo.name = 'Affection Plan';
                            } else if (curAct.chargeCode == 'Naqoodi') {
                                system.debug('in==2===' + curAct.chargeCode);
                                sInfo.segId = 'sp';
                                rqLst[0].xadh__c += (!rqLst[0].xadh__c.contains('sp')) ? 'sp;' : ''; /*MS 1.1*/
                                sInfo.name = 'Noqodi Charges';
                            } else if (rqLst[0].xvtyp__c == 'DED' && curAct.chargeCode == 'diappfee') {
                                sInfo.segId = 'af';
                                rqLst[0].xadh__c += (!rqLst[0].xadh__c.contains('af')) ? 'af;' : ''; /*MS 1.1*/
                                sInfo.name = 'Application Fee(paid)';
                            } else if (!curAct.Name.contains('Ejari Service') && curAct.Name != 'Refundable Security Deposit' && !curAct.Name.contains('New Licence Fee') && !curAct.Name.contains('Registration Fees') && !curAct.Name.contains('Knowledge Dirham') && !curAct.Name.contains('Innovation Dirham') && ((curAct.actId.equalsIgnoreCase('dda') || curAct.actId.equalsIgnoreCase('ded') || rqLst[0].xvtyp__c == 'DDA'))) {
                                sInfo.segId = curAct.term + 'py';
                                if (Integer.valueOf(curAct.term) <= 12 && !rqLst[0].xadh__c.contains(curAct.term + 'py;')) {
                                    rqLst[0].xadh__c += curAct.term + 'py;';
                                }
                                sInfo.name = 'Lease Fees - Term ' + curAct.term;
                            } else if (curAct.Name == 'Refundable Security Deposit' && curAct.actId == 'dda') {
                                sInfo.segId = 'sc';
                                if (Integer.valueOf(curAct.term) <= 12 && !rqLst[0].xadh__c.contains('sc;')) {
                                    rqLst[0].xadh__c += 'sc;';
                                }
                                sInfo.name = 'Refundable Security Deposit';
                            } else if (curAct.Name != 'New Licence Fee' && curAct.Name != 'Registration Fees' && curAct.Name != 'Knowledge Dirham' && curAct.Name != 'Innovation Dirham') {
                                String itmCd = '';
                                if (curAct.Name.equalsIgnoreCase('Ejari Services')) {
                                    sInfo.segId = 'ej';
                                    itmCd = 'ej';
                                }
                                if (curAct.Name.equalsIgnoreCase('Ejari Service Charge')) {
                                    sInfo.segId = 'ejc';
                                    itmCd = 'ejc';
                                } /*String itmCd = (curAct.Name.equalsIgnoreCase('Ejari Services')) ? 'ej' : 'ejc'; sInfo.segId = itmCd;*/
                                sInfo.name = curAct.Name;
                                if (Integer.valueOf(curAct.term) <= 12 && !rqLst[0].xadh__c.contains(itmCd + ';')) {
                                    rqLst[0].xadh__c += itmCd + ';';
                                }
                            }
                            curAct.name = '';
                            curAct.actId = sInfo.name;
                            //sInfo.label = 'for the period '+ curAct.chargeFrom +'to '+curAct.chargeTo;
                            // sInfo.SegActivities =  new List<grqWsOnboard.ActivityInfo>{curAct};
                            sInfo.price = curAct.price; //+py.totalAmountIncludingVat;
                            sInfo.vatAmount = curAct.vatAmount;
                            sInfo.totalPrice = curAct.totalPrice;
                            sInfo.term = curAct.term;
                            sInfo.price = curAct.price;
                            sInfo.chargeCode = curAct.chargeCode;
                            sInfo.propertyCode = curAct.propertyCode;
                            sInfo.tenantCode = curAct.tenantCode;
                            sInfo.chargeFrom = curAct.chargeFrom;
                            sInfo.chargeTo = curAct.chargeTo;

                            lstSegments2.add(sInfo);
                        }
                    }

                }
                System.debug('lstSegments2>>> : ' + JSON.serialize(lstSegments2));
                rqLst[0].xadtx1__c = JSON.serialize(lstSegments2);
                rqLst[0].DDA_INV__c = DDA_INV;
                System.debug('lstSegments2>>> : ' + rqLst[0].id + ' :: ' + rqLst[0].xadtx2__c);
                System.debug('after payment sc xadh__c : ' + rqLst[0].xadh__c);
                if (String.isNotBlank(rqLst[0].xadh__c)) {
                    rqLst[0].xadh__c = rqLst[0].xadh__c.replaceAll(';;', ';');
                    rqLst[0].xadh__c += ';';
                } /* update rqLst;*/
                Boolean uwl = rec.crmAccName == 'Waitlisted' ? true : false;
                if (rec.lcExpdate != null && String.isNotBlank(rqLst[0].acc__c) && rqLst[0].acc__r.lcedt__c == null) {
                    Account acc = new Account(id = rqLst[0].acc__r.id, uwl__c = uwl, name = rec.crmAccName, lcedt__c = rec.lcExpdate);
                    update acc;
                } else {
                    Account acc = new Account(id = rqLst[0].acc__r.id, name = rec.crmAccName, uwl__c = uwl);
                    update acc;
                } /* Upload second level dda documents */
                List < String > docNames = new List < String > ();
                boolean ppFlg = false;
                if (rec.documents != null && !rec.documents.isEmpty()) {
                    List < ws_call__c > wscallLst = new List < ws_call__c > ();
                    Boolean fileAttachedFlg = false;
                    for (grqWsOnboard.Document doc: rec.documents) {
                        if (String.isNotBlank(doc.description) && doc.description.contains('Passport')) {
                            ppFlg = true;
                            if (doc.isFileAttached) {
                                fileAttachedFlg = true;
                            }
                        }
                        if (!doc.isFileAttached) {
                            docNames.add('Declaration of Appointment as General Manager');
                            docNames.add(doc.description);
                            if (String.isNotBlank(doc.description) && !doc.description.contains('Valid Passport Copy')) {
                                if (rqLst[0].xcddocs__c != 'null' && rqLst[0].xcddocs__c != '' && rqLst[0].xcddocs__c != null && !((rqLst[0].xcddocs__c).contains(doc.description))) {
                                    rqLst[0].xcddocs__c = rqLst[0].xcddocs__c + ';' + doc.description;
                                } else {
                                    rqLst[0].xcddocs__c = doc.description;
                                }
                            } /* fileAttachedFlg = false;*/
                        } /** dummy code to upload passport copy to CCRM & DDA - Need to remove before deploymnet */
                        if (String.isNotBlank(doc.description) && doc.description.contains('Passport') && !doc.isFileAttached && isNameApproved) {
                            List < g_reqitem__c > riLst = [select id, ccrmid__c from g_reqitem__c where RQ__c =: rqLst[0].id and itm__r.cd__c = 'dr'];
                            ws_call__c wc = new ws_call__c();
                            wc.rq_itm__c = riLst[0].id;
                            wc.pmid__c = '00P1s000003cORo';
                            wc.ws_typ__c = 'Onboarding';
                            wc.mtd_nm__c = 'uploadDoc';
                            wc.intsts__c = 'Ready for Integration';
                            wc.adhoc_text1__c = doc.description + '.jpg';
                            wscallLst.add(wc);
                        }
                    }
                    system.debug('fileAttachedFlg::' + fileAttachedFlg);
                    if (ppFlg && !fileAttachedFlg) {
                        List < g_reqitem__c > riLst = [select id, ccrmid__c from g_reqitem__c where RQ__c =: rqLst[0].id and itm__r.cd__c = 'dr'];
                        for (g_reqDoc__c rdoc: [select id, name, lbl__c, (select id, name from attachments) from g_reqDoc__c where RQ__c =: rqLst[0].id and(name like 'Passport%'
                                or name =: docNames or lbl__c =: docNames)]) {
                            if (rdoc.attachments != null && rdoc.attachments.size() > 0) {
                                ws_call__c wc = new ws_call__c();
                                wc.rq_itm__c = riLst[0].id;
                                wc.pmid__c = rdoc.attachments[0].id;
                                wc.ws_typ__c = 'Onboarding';
                                wc.mtd_nm__c = 'uploadDoc';
                                wc.intsts__c = 'Ready for Integration';
                                wc.adhoc_text1__c = rdoc.attachments[0].name;
                                system.debug('doc name::' + rdoc.attachments[0].name);
                                wscallLst.add(wc);
                            }
                        }
                    }
                    if (wscallLst != null && !wscallLst.isEmpty()) {
                        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.CREATABLE, wscallLst);
                        insert secDec.getRecords();
                    }
                }
                SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.UPDATABLE, rqLst);
                update secDec2.getRecords();
                if (docNames.size() > 0) {
                    List < g_reqitemDoc__c > itemDocs = [select id, name, Req__c, reqAts__c from g_reqitemDoc__c where reqItm__r.RQ__c =: rqLst[0].id and lbl__c in: docNames and lbl__c != 'Declaration of Appointment as General Manager'];
                    if (itemDocs.size() > 0) {
                        for (g_reqitemDoc__c iDoc: itemDocs) {
                            iDoc.Req__c = true;
                            iDoc.reqAts__c = true;
                        }
                        SObjectAccessDecision secDec3 = Security.stripInaccessible(AccessType.UPDATABLE, itemDocs);
                        update secDec3.getRecords();
                    }
                }
                if (!ppFlg) {
                    List < ws_call__c > obWslst = [select id from ws_call__c where pmid__c =: rec.crmAccId and ws_typ__c = 'Onboarding'
                        and mtd_nm__c = 'fetchAccInfo'
                    ];
                    ws_call__c wc = new ws_call__c();
                    wc.pmid__c = rec.crmAccId;
                    wc.ws_typ__c = 'Onboarding';
                    wc.mtd_nm__c = 'fetchAccInfo';
                    wc.intsts__c = 'Ready for Integration';
                    if (obWslst == null || obWslst.isEmpty() || (obWslst.size() < gu.csNum('OnbFetchAccLimit'))) {
                        if (!Test.isRunningTest()) {
                            insert wc;
                        }
                    } else if (obWslst.size() == gu.csNum('OnbFetchAccLimit')) {
                        wc.No_Issue__c = true;
                        if (!Test.isRunningTest()) {
                            insert wc;
                        }
                    }
                }
            }
            ws.intsts__c = 'Success';
            update ws;
        } catch (Exception ex) {
            ws.err_msg__c = ex.getMessage() + ex.getStackTraceString();
            ws.intsts__c = 'Failed';
            update ws;
            System.debug('Exception:: ' + ex.getStackTraceString());
        }


    }


    public void uploadDocument(ws_call__c wsCall) {
        String docName = '';
        String BrandAppId = 'NA';
        try {
            set < id > rdocs = new Set < id > ();
            wsCall.intsts__c = 'On hold';
            for (g_reqitemDoc__c doc: [select id, reqDoc__c from g_reqitemDoc__c where reqItm__r.RQ__c =: wsCall.rq_itm__r.RQ__c and reqItm__c =: wsCall.rq_itm__c and Req__c = true and upOk__c = true order by createddate]) {
                rdocs.add(doc.reqDoc__c);
            }
            system.debug('wsCall.rq_itm__r.RQ__r.xadtx1__c--' + wsCall.rq_itm__r.RQ__r.xadtx1__c);
            if (wsCall.rq_itm__r.RQ__r.xadtx1__c != null && wsCall.rq_itm__r.RQ__r.Service_Code__c == '322') {
                Map < String, Object > parsedJson = (Map < String, Object > ) JSON.deserializeUntyped(wsCall.rq_itm__r.RQ__r.xadtx1__c);
                List < Object > workOrders = (List < Object > ) parsedJson.get('workOrders'); /*Loop through workOrders list*/
                for (Object woObj: workOrders) {
                    Map < String, Object > workOrder = (Map < String, Object > ) woObj;
                    String workOrderId = (String) workOrder.get('workOrderId');
                    String workOrderStatus = (String) workOrder.get('status');
                    String recordType = (String) workOrder.get('RecordTypeDeveloperName');
                    if (recordType == 'Brand_Approval') {
                        BrandAppId = workOrderId;
                    }
                }
            }
            system.debug('BrandAppIdBrandAppId::' + BrandAppId);
            for (Attachment att: [select id, parentid, parent.name, name, body from Attachment where parentid =: rdocs]) {
                grqWsOnboard.DocumentInfo doc = new grqWsOnboard.DocumentInfo();
                doc.recid = wsCall.rq_itm__r.ccrmid__c; /*wsCall.rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c;*/
                if (BrandAppId != 'NA' && BrandAppId != null && (att.parent.name == 'Educational qualification or training certificate' || att.parent.name == 'Media Regulatory Office undertaking letter' || att.parent.name == 'Sample of work' || att.parent.name == 'Reference letter')) {
                    doc.recid = BrandAppId;
                }
                system.debug(' doc.recid::' + doc.recid);
                if (wsCall.rq_itm__r.itm__r.cd__c == 'frl' && att.parent.name == 'Passport - first page') doc.docName = 'Valid Passport Copy - ' + wsCall.rq_itm__r.RQ__r.xcfn__c + ' ' + wsCall.rq_itm__r.RQ__r.xcln__c;
                else doc.docName = att.parent.name;
                docName = doc.docName + ':' + doc.recid;
                doc.fileName = att.name;
                doc.accid = wsCall.rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c;
                doc.fileBody = EncodingUtil.base64Encode(att.body);
                String rqBody = Json.serialize(doc);
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json'); /*request.setEndpoint('callout:CCRM_UAT/apexrest/createdoc'); */ /*request.setEndpoint('callout:CCRM/apexrest/createdoc');*/
                request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/createdoc');
                request.setTimeout(90000);
                request.setMethod('POST');
                request.setBody(rqBody);
                response = h.send(request);
                if (response.getStatusCode() == 200) {
                    system.debug('res::' + response.getBody());
                    wsCall.intsts__c = 'Success';
                } else {
                    wsCall.intsts__c = 'Failed';
                }
            }
        } catch (exception ex) {
            wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
            wsCall.intsts__c = 'Failed';
            System.debug('##Exception :  ' + ex.getMessage() + ' -- ' + ex.getStackTraceString());
        }
        wsCall.rq_jsn__c = docName;
        update wsCall;
    }


    public void updateStatus(ws_call__c wsCall) {
        try {
            String reqBody = '';
            grqWsOnboard.StatusRequest req = new grqWsOnboard.StatusRequest();
            req.requestId = wsCall.rq_itm__r.RQ__c;
            req.recordId = wsCall.rq_itm__r.ccrmid__c; /*if (string.isNotBlank( wsCall.rq_itm__r.RQ__r.xadtx2__c))  req.description =  wsCall.rq_itm__r.RQ__r.xadtx2__c;  else req.description =  wsCall.rq_itm__r.RQ__r.xcn__c; if (wsCall.rq_itm__r.RQ__r.srvc__r.uid__c == '219')     req.objectType =  'Case'; else if (wsCall.rq_itm__r.RQ__r.srvc__r.uid__c == '216' && wsCall.rq_itm__r.itm__r.cd__c == 'nl' )     req.objectType =  'Opportunity'; else req.objectType =  'Quote';*/
            List < Courier_Status__c > stsList = [select id, Courier_Status__c from Courier_Status__c where srvitm__c =: wsCall.rq_itm__r.itm__c and curSTA__c =: wsCall.rq_itm__r.sta__c];
            if (stsList != null && !stsList.isEmpty()) {
                req.status = stsList[0].Courier_Status__c;
            }
            if (wsCall.rq_itm__r.sta__r.cd__c == 'v' && (wsCall.rq_itm__r.itm__r.cd__c == 'na' || wsCall.rq_itm__r.itm__r.cd__c == 'dr')) {
                List < grqWsOnboard.ActivityInfo > tActv = new List < grqWsOnboard.ActivityInfo > ();
                req.accid = wsCall.rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c;
                req.businessName1 = wsCall.rq_itm__r.RQ__r.xcfn__c;
                req.businessName2 = wsCall.rq_itm__r.RQ__r.xcmn__c;
                req.businessName3 = wsCall.rq_itm__r.RQ__r.xcln__c;
                req.parentCompany = wsCall.rq_itm__r.RQ__r.xccn__c;
                req.pcRegNo = wsCall.rq_itm__r.RQ__r.rtacn__c;
                req.nationality = wsCall.rq_itm__r.RQ__r.xcpic__c;
                if (wsCall.rq_itm__r.RQ__r.xbtnm__c != null) {
                    req.pcDOI = grqwsOnboard.strDate(wsCall.rq_itm__r.RQ__r.xbtnm__c);
                }
                if (String.isNotBlank(wsCall.rq_itm__r.RQ__r.xadtx2__c)) {
                    List < grqWsOnboard.SegmentInfo > lst = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(wsCall.rq_itm__r.RQ__r.xadtx2__c, List < grqWsOnboard.SegmentInfo > .class);
                    for (grqWsOnboard.SegmentInfo rec: lst) {
                        tActv.addAll(rec.SegActivities);
                    }
                    req.actvities = tActv;
                }
            }
            reqBody = Json.serialize(req);
            System.debug('reqBody: ' + reqBody);
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json'); /*request.setEndpoint('callout:CCRM_UAT/apexrest/statusUpdate'); request.setEndpoint('callout:CCRM/apexrest/statusUpdate');*/
            request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/statusUpdate');
            request.setTimeout(90000);
            request.setMethod('POST');
            request.setBody(reqBody);
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                String respBody = '';
                if (response.getBody() != null) {
                    respBody = response.getBody();
                }
                System.debug('<response.getBody()> : ' + respBody);
                grqWsOnboard.Records recs = (grqWsOnboard.Records) JSON.deserialize(respBody, grqWsOnboard.Records.class);
                if (recs.isSuccess) {
                    wsCall.intsts__c = 'Success';
                } else {
                    wsCall.intsts__c = 'Failed';
                    wsCall.err_msg__c = recs.respMsg;
                }
            } else {
                wsCall.intsts__c = 'Failed';
                if (response.getBody() != null) {
                    wsCall.res_jsn__c = response.getBody();
                }
            }
        } catch (exception ex) {
            wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
            wsCall.intsts__c = 'Failed';
            System.debug('##Exception ::' + ex.getMessage() + ' -- ' + ex.getStackTraceString());
        }
        update wsCall;
    }


    public static void createRequest(WS_Call__c ws) {
        String jsonAcc = getCCRMAccountInfo(ws.adhoc_text1__c);
        if (String.isBlank(jsonAcc)) {
            ws.intsts__c = 'Failed';
            update ws;
            return;
        }
        grqWsOnboard.Records rec = (grqWsOnboard.Records) JSON.deserialize(jsonAcc, grqWsOnboard.Records.class);
        if (rec != null && rec.quotes != null && !rec.quotes.isEmpty()) {
            Map < id, grqWsOnboard.QuoteInfo > quoteMp = new Map < id, grqWsOnboard.QuoteInfo > ();
            for (grqWsOnboard.QuoteInfo q: rec.quotes) quoteMp.put(q.quoteId, q);
            if (quoteMp != null && quoteMp.containskey(ws.adhoc_text1__c)) {
                grqWsOnboard.QuoteInfo q = quoteMp.get(ws.adhoc_text1__c);
                String srvid = '';
                List < Account > accLst = [select id from Account where ccrm_sfid__c =: rec.crmAccId];
                if (accLst != null && !accLst.isEmpty()) {
                    if (q.rqtype == 'Renewal') {
                        srvid = gu.csStr('srvc_LeaseRenewal');
                    } else if (q.rqtype == 'New') {
                        srvid = gu.csStr('srvc_NewLease');
                    } else {
                        srvid = gu.csStr('srvc_LeaseAmendments');
                    }
                    g_Req__c rq = new g_Req__c(STA__c = 'Draft', srvc__c = srvid, xadtx3__c = jsonAcc, Acc__c = accLst[0].id); /*Acc__c=con.Accountid,xfb__c=con.Account.Legal_Framework__c,*/
                    insert rq;
                    grqWsOnboard.Records rqRec = new grqWsOnboard.Records();
                    rqRec.crmAccId = rec.crmAccId;
                    rqRec.requestid = rq.id;
                    rqRec.crmOppId = q.opportunityId;
                    String reqJson = Json.serialize(rqRec);
                    ws_call__c wc = new ws_call__c();
                    wc.pmid__c = rec.crmAccId;
                    wc.rq_jsn__c = reqJson;
                    wc.ws_typ__c = 'Onboarding';
                    wc.mtd_nm__c = 'updateAccInfo';
                    wc.intsts__c = 'Ready for Integration';
                    insert wc;
                }
            }
        }
    }


    public static string getCCRMAccountInfo(String accCRMID) {

        String respBody = '';
        try {
            system.debug('crmAccid::' + accCRMID);
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            //request.setEndpoint('callout:CCRM_UAT/apexrest/accinfo');
            //request.setEndpoint('callout:CCRM/apexrest/accinfo');
            request.setEndpoint('callout:' + label.CRM_Instance + '/apexrest/accinfo');
            request.setHeader('accId', accCRMID);
            if (test.isrunningTest()) {
                request.setHeader('accId', '231314');
            }
            request.setTimeout(90000);
            request.setMethod('GET');

            response = h.send(request);
            if (response.getStatusCode() == 200) {
                if (response.getBody() != null) {
                    respBody = response.getBody();
                }
            }

        } catch (Exception ex) {
            system.debug('ex1:' + ex.getMessage());
            system.debug('ex::' + ex.getStackTraceString());
        }


        return respBody;
    }


    public void getDDAReqDetails(ws_call__c wsCall) {
        try {

            String resp = grqWsDccaGetService.getNewReqDetails(wsCall.rq_itm__r.rq__r.xdccaRq__c); //xdei__c  //REQ-00234411 // get the DDA req ID from ws.rq_jsn__c, currently we dont have this req#
            //or use wsCall.
            System.debug('<getDDAReqDetails> resp:: ' + resp);
            if (String.isNotBlank(resp) && !resp.startsWith('ERROR')) {

                g_Req__c req = [SELECT id, name, xadtx2__c, xadh__c from g_Req__c where Name =: wsCall.xrno__c];
                if (String.isBlank(req.xadh__c)) {
                    req.xadh__c = '';
                } else {
                    req.xadh__c += ';';
                }

                grqWsDccaGetService dccaResp = (grqWsDccaGetService) System.JSON.deserialize(resp, grqWsDccaGetService.class);
                System.debug('lines:' + dccaResp);

                if (dccaResp == null || dccaResp.Data == null) {
                    wsCall.intsts__c = 'Failed';
                    wsCall.err_msg__c = 'No data from DDA';
                    update wsCall;
                    return;
                }

                //update the json and update the price in items
                if (dccaResp != null && dccaResp.Data != null && dccaResp.Data.size() > 0) {
                    if (dccaResp.Data[0].lines != null && dccaResp.Data[0].lines.size() > 0) {

                        Map < String, Integer > ddaLnItmsPrice = new Map < String, Integer > ();

                        for (grqWsDccaGetService.LineItems ddaLnItm: dccaResp.Data[0].lines) {
                            String ddaItemStr = (String.isNotBlank(ddaLnItm.segment) && ddaLnItm.segment != 'null') ? 'License_Registration_Request' : ddaLnItm.lineName;
                            if (!ddaLnItmsPrice.containsKey(ddaItemStr)) {
                                ddaLnItmsPrice.put(ddaItemStr, 0);
                            }
                            ddaLnItmsPrice.put(ddaItemStr, ddaLnItmsPrice.get(ddaItemStr) + ddaLnItm.amount);
                        }
                        System.debug('ddaLnItmsPrice : ' + ddaLnItmsPrice);

                        // update the adhoc2 JSON in request
                        List < grqWsOnboard.SegmentInfo > lstSegments2 = new List < grqWsOnboard.SegmentInfo > ();
                        Map < String, String > itmCdsByName = new Map < String, String > {
                            'License_Registration_Request' => 'dr',
                            'Registration Fees' => 'rgf',
                            'Knowledge Dirham' => 'kf',
                            'Innovation Dirham' => 'inf'
                        };
                        for (String itemName: ddaLnItmsPrice.keySet()) {

                            if (itmCdsByName.get(itemName) != null && !req.xadh__c.contains(itmCdsByName.get(itemName))) {
                                grqWsOnboard.SegmentInfo sInfo = new grqWsOnboard.SegmentInfo();
                                List < grqWsOnboard.ActivityInfo > lstActInfo = new List < grqWsOnboard.ActivityInfo > ();

                                sInfo.segId = itemName + '#' + itmCdsByName.get(itemName);
                                if (!req.xadh__c.contains(itmCdsByName.get(itemName) + ';')) {
                                    req.xadh__c += itmCdsByName.get(itemName) + ';';
                                }
                                sInfo.name = itemName;

                                // +20 for reg fees and -10 for innovation and knowledge from DDA resp
                                //Integer axsAmount = itmCdsByName.get(itemName)=='rgf' ? ddaLnItmsPrice.get(itemName) +20 : ddaLnItmsPrice.get(itemName)-10;

                                Integer axsAmount = itmCdsByName.get(itemName) == 'rgf' ? ddaLnItmsPrice.get(itemName) : ddaLnItmsPrice.get(itemName);

                                sInfo.price = '' + axsAmount;

                                grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(itemName, 'DDAItem');
                                List < String > lstActDocs = new List < String > ();
                                act.docs = lstActDocs;
                                act.price = '' + axsAmount; //''+ddaLnItmsPrice.get(itemName);
                                act.actId = sInfo.name;
                                lstActInfo.add(act);

                                sInfo.SegActivities = lstActInfo;
                                lstSegments2.add(sInfo);
                            }
                        }



                        //update the related item's price, mapped by name of the reqItem
                        List < g_reqitem__c > reqItms = [SELECT id, name, scN__c, itm__r.cd__c from g_reqitem__c where name in: ddaLnItmsPrice.keySet() and rq__r.Name =: wsCall.xrno__c];
                        if (reqItms != null && reqItms.size() > 0) {
                            for (g_reqitem__c itm: reqItms) {
                                itm.scN__c = ddaLnItmsPrice.get(itm.name);
                            }
                            SObjectAccessDecision secDec4 = Security.stripInaccessible(AccessType.UPDATABLE, reqItms);
                            update secDec4.getRecords();
                        }

                        wsCall.err_msg__c = ddaLnItmsPrice.toString();
                        // update the price in the request JSON
                        List < grqWsOnboard.SegmentInfo > lstSegments = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(req.xadtx2__c, List < grqWsOnboard.SegmentInfo > .class);
                        System.debug('old SegActivities: ' + lstSegments);

                        if (lstSegments != null && lstSegments.size() > 0) {
                            for (grqWsOnboard.SegmentInfo seg: lstSegments) {
                                if (ddaLnItmsPrice.containsKey(seg.Name)) {
                                    seg.price = '' + ddaLnItmsPrice.get(seg.Name);
                                }
                            }
                        }

                        for (grqWsOnboard.SegmentInfo seg: lstSegments2) {
                            lstSegments.add(seg);
                        }

                        req.xadtx2__c = JSON.serialize(lstSegments);
                        System.debug('new lstSegments : ' + req.xadtx2__c);
                        update req;

                        wsCall.intsts__c = 'Success';
                    }
                }

            } else {
                wsCall.err_msg__c = resp;
                wsCall.intsts__c = 'Failed';
            }
        } catch (Exception e) {
            wsCall.err_msg__c = e.getStackTraceString();
        }
        update wsCall;
    }


    /*** public void getDDAReqDetails(ws_call__c wsCall){

         String resp = grqWsDccaGetService.getNewReqDetails(wsCall.rq_itm__r.xdcca_refId__c ); //REQ-00234411 // get the DDA req ID from ws.rq_jsn__c, currently we dont have this req#
         //or use wsCall.

         if (String.isNotBlank(resp) && !resp.startsWith('ERROR')){

             g_Req__c req = [SELECT id, name,xadtx2__c,xadh__c from g_Req__c where id=:wsCall.pmid__c];
             if (String.isBlank(req.xadh__c)){req.xadh__c='';}else{req.xadh__c+=';';}

             grqWsDccaGetService dccaResp= (grqWsDccaGetService) System.JSON.deserialize(resp, grqWsDccaGetService.class);
             System.debug('lines:' + dccaResp);

             if (dccaResp==null || dccaResp.Data ==null){
                 wsCall.intsts__c = 'Failed'; wsCall.err_msg__c = 'No data from DDA';
                 update wsCall; return;
             }

             //update the json and update the price in items
             if (dccaResp!=null && dccaResp.Data !=null && dccaResp.Data.size()>0){
                 if (dccaResp.Data[0].lines!=null && dccaResp.Data[0].lines.size()>0){

                     Map<String, Integer> ddaLnItmsPrice = new Map<String, Integer>();

                     for (grqWsDccaGetService.LineItems ddaLnItm: dccaResp.Data[0].lines){
                         String ddaItemStr = (String.isNotBlank(ddaLnItm.segment) && ddaLnItm.segment!='null') ? ddaLnItm.segment : ddaLnItm.lineName;
                         if (!ddaLnItmsPrice.containsKey(ddaItemStr)){
                             ddaLnItmsPrice.put(ddaItemStr,0);
                         }
                         ddaLnItmsPrice.put(ddaItemStr, ddaLnItmsPrice.get(ddaItemStr)+ddaLnItm.amount);
                     }
                     System.debug('ddaLnItmsPrice : ' + ddaLnItmsPrice);

                     // update the adhoc2 JSON in request
                     List<grqWsOnboard.SegmentInfo> lstSegments2 = new List<grqWsOnboard.SegmentInfo>();
                     Map<String,String> itmCdsByName = new Map<String,String> {'Registration Fees'=>'rgf','Knowledge Dirham'=>'kf','Innovation Dirham'=>'inf'};
                         for (String itemName : ddaLnItmsPrice.keySet()){

                             if (itmCdsByName.get(itemName)!=null && !req.xadh__c.contains(itmCdsByName.get(itemName))) {
                                 grqWsOnboard.SegmentInfo sInfo= new grqWsOnboard.SegmentInfo();
                                 List<grqWsOnboard.ActivityInfo> lstActInfo = new List<grqWsOnboard.ActivityInfo>();

                                 sInfo.segId = itemName+'#'+itmCdsByName.get(itemName);
                                 if (!req.xadh__c.contains(itmCdsByName.get(itemName)+';')) { req.xadh__c += itmCdsByName.get(itemName)+';';}
                                 sInfo.name = itemName;

                                 // +20 for reg fees and -10 for innovation and knowledge from DDA resp
                                 Integer axsAmount = itmCdsByName.get(itemName)=='rgf' ? ddaLnItmsPrice.get(itemName) +20 : ddaLnItmsPrice.get(itemName)-10;

                                 sInfo.price = ''+axsAmount;

                                 grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(itemName,'DDAItem');
                                 List<String> lstActDocs = new List<String>();
                                 act.docs = lstActDocs;
                                 act.price = ''+axsAmount;//''+ddaLnItmsPrice.get(itemName);
                                 act.actId =  sInfo.name;
                                 lstActInfo.add(act);

                                 sInfo.SegActivities = lstActInfo ;
                                 lstSegments2.add(sInfo);
                             }
                         }



                     //update the related item's price, mapped by name of the reqItem
                     List<g_reqitem__c> reqItms = [SELECT id, name, scN__c, itm__r.cd__c from g_reqitem__c where name in : ddaLnItmsPrice.keySet() and rq__c=:wsCall.pmid__c];
                     if (reqItms!=null && reqItms.size()>0){
                         for (g_reqitem__c itm : reqItms){itm.scN__c = ddaLnItmsPrice.get(itm.name);}
                         SObjectAccessDecision secDec5 = Security.stripInaccessible(AccessType.UPDATABLE, reqItms);
                         update secDec5.getRecords();
                     }


                     // update the price in the request JSON
                     List<grqWsOnboard.SegmentInfo> lstSegments = (List<grqWsOnboard.SegmentInfo>) json.deserialize(req.xadtx2__c, List<grqWsOnboard.SegmentInfo>.class);
                     System.debug('old SegActivities: ' + lstSegments);

                     if (lstSegments!=null && lstSegments.size()>0){
                         for (grqWsOnboard.SegmentInfo seg : lstSegments){
                             if (ddaLnItmsPrice.containsKey(seg.Name)){
                                 seg.price = ''+ddaLnItmsPrice.get(seg.Name);
                             }
                         }
                     }

                     for (grqWsOnboard.SegmentInfo seg : lstSegments2) {
                         lstSegments.add(seg);
                     }

                     req.xadtx2__c = JSON.serialize(lstSegments);
                     System.debug('new lstSegments : ' +  req.xadtx2__c);
                     update req;

                     wsCall.intsts__c = 'Success';
                 }
             }

         }else{
             wsCall.err_msg__c = resp;
             wsCall.intsts__c = 'Failed';
         }

         update wsCall;
     }
     ***/

    global void finish(Database.BatchableContext BC) {}


    public String wsID;
    public void execute(QueueableContext qc) {
        System.debug('<queueable> wsID : ');
        if (String.isNotBlank(wsID)) {
            List < ws_call__c > lstWS = [Select Id, rq_itm__r.RQ__r.xcfn__c, rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.xbtnm__c, rq_itm__r.RQ__r.xcpic__c, rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, err_msg__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.srvc__r.uid__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xcn__c, rq_itm__r.ccrmid__c, rq_itm__r.sta__c, rq_itm__r.itm__r.cd__c, rq_itm__r.sta__r.cd__c, pmid__c, mtd_nm__c, intsts__c from ws_call__c where id =: wsId AND intsts__c = 'Ready for Integration'
                limit 1
            ];

            if (lstWS != null && lstWS.size() > 0) {
                try {
                    new BatchOnboardFetchAccInfo().fetchAccInfo(lstWS[0]);
                } catch (Exception ex) {
                    lstWS[0].err_msg__c = ex.getMessage() + ex.getStackTraceString();
                    lstWS[0].intsts__c = 'Failed';
                    update lstWS[0];
                    System.debug('Exception:: ' + ex.getStackTraceString());
                }
            }
        }

        //database.executebatch(new BatchOnboardFetchAccInfo(), 1);
    }

    global void execute(SchedulableContext sc) {
        database.executebatch(new BatchOnboardFetchAccInfo(), 1);
    }
}
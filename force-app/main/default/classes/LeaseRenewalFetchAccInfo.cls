public with sharing class LeaseRenewalFetchAccInfo {

    public static  void fetchAccInfo(Ws_call__c ws, Id renewalOppId, Id requestId) {
        Map < Integer, List < grqWsOnboard.PaymentSchedules >> termsMap = new Map < Integer, List < grqWsOnboard.PaymentSchedules >> ();
        Map < Integer, List < grqWsOnboard.PaymentSchedules >> pytermsMap = new Map < Integer, List < grqWsOnboard.PaymentSchedules >> ();
        Map < String, grqWsOnboard.PaymentSchedules > desctermsMap = new Map < String, grqWsOnboard.PaymentSchedules > ();
        List<ws_call__c> wsListToInsert = new List<ws_call__c>();
        Set<String> termValuesSet = new Set<String>();
        String requestTermValues;
        Map<String, Map<String, Decimal>> termAmountMap = new Map<String, Map<String, Decimal>>();

        try {
            String jsonAcc = ws.rq_jsn__c;
            Decimal leaseRenewalCharges =0;
            Decimal ejariServiceCharge=0;
            List<g_reqitem__c> requestItems = new List<g_reqitem__c>();
            system.debug('jsonAccjsonAcc--' + jsonAcc);

            if (String.isBlank(jsonAcc)) {
                ws.intsts__c = 'Failed';
                ws.err_msg__c = 'resp <jsonAcc> is blank';
                if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                    update ws;
                }
                return;
            }

            String jsonAcc1 = jsonAcc;
            String DDA_INV, unitSubCategory, unitCategory = '';
            Boolean isSME = false;
            Id renewalQuoteId;
            Map<String, Object> finalJson = new Map<String, Object>();
            Map<String, Object> ffinalJson = new Map<String, Object>();
            System.debug('jsonAcc.length():: ' + jsonAcc.length());
            grqWsOnboard.Records rec = null;
            rec = (grqWsOnboard.Records) JSON.deserialize(jsonAcc1, grqWsOnboard.Records.class);

            List < g_Req__c > rqLst = [select id, xcp__c, InsChk__c, ccrmldid__c, xled__c, nt__c,
                xvtyp__c, xcmbs__c, os__c, xcddocs__c, DDA_INV__c, name, xadtx3__c, xdccaRq__c, xadtx2__c,
                xdei__c, xadh__c, acc__c, acc__r.id, acc__r.lcedt__c, skpu__c, (select id, name,
                scN__c, itmCd__c, ccrmid__c from items__r) from g_Req__c where id =: requestId limit 1];

            //save response without paymentschedules as schedules will be saved in adhoc2
            rec.paymentSchedules = null;
            ws.res_jsn__c = JSON.serialize(rec);
            if (rqLst != null && !rqLst.isEmpty()) {
                rqLst[0].xadtx3__c = ws.res_jsn__c;

                if (rec.skipLeaseValidations != null && rec.skipLeaseValidations != 'null') {
                    rqLst[0].skpu__c = rec.skipLeaseValidations == 'true' ? true : false;
                    if (rqLst[0].skpu__c)
                        rqLst[0].os__c = 'CCL Accepted';
                }

                system.debug('rec.quotesrec.quotesrec.quotes--' + rec.quotes);
                if (rec.quotes != null && !rec.quotes.isEmpty()) {
                    for (grqWsOnboard.QuoteInfo q: rec.quotes) {
                        system.debug('q.statusq.statusq.status--' + q.status);
                        if (q.status != 'Draft' && q.opportunityId == renewalOppId) {
                            system.debug('q.status--' + q.status);
                            rqLst[0].xcmbs__c = q.totalLandQtAmt * 0.01;
                            system.debug('q.status--' + q.totalLandQtAmt * 0.01);
                            renewalQuoteId = q.quoteId;

                            if ( q.units != null && q.units.size() > 0 ) {
                                unitSubCategory = q.units[0].unitsubCategory;
                                unitCategory = q.units[0].unitCategory;
                            }
                        }
                    }
                }
            }

            rec = (grqWsOnboard.Records) JSON.deserialize(jsonAcc, grqWsOnboard.Records.class);
            Boolean isNameApproved = false;
            if (rqLst != null && !rqLst.isEmpty()) {
                if (rec.workorders != null && !rec.workorders.isEmpty()) {
                    for (grqWsOnboard.WorkOrderInfo w: rec.workorders) {
                        if (w.status == 'Name Approved') isNameApproved = true;
                        if (String.isNotBlank(w.ddaRequestId)) {
                            rqLst[0].xdei__c = w.ddaRequestId;
                        }
                    }
                }

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
                }

                System.debug('rec.paymentSchedules : ' + rec.paymentSchedules);
                List < grqWsOnboard.ActivityInfo > lstActs = new List < grqWsOnboard.ActivityInfo > ();
                List < grqWsOnboard.ActivityInfo > DDALts = new List < grqWsOnboard.ActivityInfo > ();

                if (rec.quotes.size() > 0 && rec.quotes[0].units.size() > 0) {
                    finalJson.put('units', rec.quotes[0].units);
                }

                if (rec.paymentSchedules != null && rec.paymentSchedules.size() > 0 && renewalQuoteId != null) {
                    Date currentDate = System.today();
                    System.debug('SORT>>> : ' + JSON.serialize(rec.paymentSchedules));

                    List < String > chrgCdLst = Label.Charge_Code_Yardi.split(';');
                    List < grqWsOnboard.PaymentSchedules > paySchule;
                    paySchule = new List < grqWsOnboard.PaymentSchedules > ();
                    Integer Terms = 1;
                    String fromDate = '';
                    system.debug('Terms---' + Terms);
                    for (grqWsOnboard.PaymentSchedules py: rec.paymentSchedules) {
                        if (rqLst[0].xcp__c != null && rqLst[0].xcp__c!='') {
                        rqLst[0].xcp__c= py.propertyCode;
                        }
                        if (py.quote == renewalQuoteId) {
                                if (!chrgCdLst.contains(py.chargeCode)) {
                                    py.term = '1';
                                    paySchule.add(py);
                                }
                                else if (py.dueDate == fromDate || fromDate == '') {
                                    py.term = '' + Terms;
                                    if (py.chargeCode=='CISfee') {
                                        paySchule.add(py);
                                    }
                                    else{
                                        py.description='Lease Fee Term-'+ Terms;
                                        paySchule.add(py);
                                    }
                                    fromDate = py.dueDate;
                                }
                                else {
                                    fromDate = py.dueDate;
                                    termsMap.put(Terms, paySchule);
                                    paySchule = new List < grqWsOnboard.PaymentSchedules > ();
                                    Terms++;
                                    py.term = '' + Terms;
                                    if (py.chargeCode=='CISfee') {
                                        paySchule.add(py);
                                    }
                                    else{
                                        py.description='Lease Fee Term-'+ Terms;
                                        paySchule.add(py);
                                    }
                                }
                                if ( py.description.contains('Ejari') && py.totalAmountIncludingVat != null) {
                                    ejariServiceCharge += py.totalAmountIncludingVat;
                                }
                                else if (!py.description.contains('Ejari') && py.totalAmountIncludingVat != null && py.term =='1'  ) {
                                    leaseRenewalCharges += py.totalAmountIncludingVat;
                                }
                                else if (!py.description.contains('Ejari') && py.chargeFrom != null && py.totalAmountIncludingVat != null && py.term !='1' ) {
                                    Date chargeformDate = Date.valueOf(py.chargeFrom);
                                    System.debug('chargeformDate :'+chargeformDate);
                                    System.debug('py.totalAmountIncludingVat :'+py.totalAmountIncludingVat);
                                    if (chargeformDate < currentDate) {
                                        leaseRenewalCharges += py.totalAmountIncludingVat;
                                        System.debug('py.leaseRenewalCharges :'+leaseRenewalCharges);
                                        Integer termInt = Integer.valueOf(py.term);
                                        String termValue;
                                        if (termInt < 10) {
                                            termValue = 'pt' + termInt;
                                        }
                                        else {
                                            termValue = 'p' + termInt;
                                        }
                                        termValuesSet.add(termValue);
                                        Decimal billingAmt = py.billedAmount;
                                        Decimal vatAmt = py.vatAmount;
                                        if (!termAmountMap.containsKey(termValue)) {
                                            termAmountMap.put(termValue, new Map<String, Decimal>{
                                            'Billing' => 0, 'VAT' => 0}
                                            );
                                        }
                                        Map<String, Decimal> amounts = termAmountMap.get(termValue);
                                        amounts.put('Billing', amounts.get('Billing') + billingAmt);
                                        amounts.put('VAT', amounts.get('VAT') + vatAmt);
                                    }
                                }
                        }
                    }
                    termsMap.put(Terms, paySchule);
                    System.debug('termsMap :'+termsMap);

                    List < grqWsOnboard.PaymentSchedules > paySchTrms = new List < grqWsOnboard.PaymentSchedules > ();

                    finalJson.put('paymentSchedule', termsMap);
                    System.debug('termsMap>>> : ' + JSON.serialize(termsMap));
                }

                Map < String, grqWsOnboard.PaymentSchedules > xtermsMap = new Map < String, grqWsOnboard.PaymentSchedules > ();

                for (Integer  key : termsMap.keySet()) {
                List < grqWsOnboard.PaymentSchedules >  paySchTrm=(List < grqWsOnboard.PaymentSchedules >)termsMap.get(key);

                    Decimal billedAmount=0.0;
                    Decimal vatAmount=0.0;
                    Decimal totalAmountIncludingVat=0.0;
                    String pyDesc='NA';
                    xtermsMap = new Map < String, grqWsOnboard.PaymentSchedules > ();
                    for (grqWsOnboard.PaymentSchedules  pys : paySchTrm) {
                       system.debug('####################--pys.description'+pys.description);
                        if (xtermsMap != null&& xtermsMap.size()>0 && xtermsMap.containsKey(pys.description)) {
                            grqWsOnboard.PaymentSchedules xpy=(grqWsOnboard.PaymentSchedules)xtermsMap.get(pys.description);
                            xpy.billedAmount+=pys.billedAmount;
                            xpy.vatAmount+=pys.vatAmount;
                            xpy.totalAmountIncludingVat+=pys.totalAmountIncludingVat;
                            xtermsMap.put(pys.description, xpy);
                            desctermsMap.put(pys.description, xpy);
                        }
                        else{ xtermsMap.put(pys.description, pys); desctermsMap.put(pys.description, pys); }
                    }

                    pytermsMap.put(key, xtermsMap.values());

                }
                ffinalJson.put('paymentSchedule', pytermsMap);
                if (!termValuesSet.isEmpty()) {
                    requestTermValues = String.join(
                        new List<String>(termValuesSet),
                        ';'
                    );
                    rqLst[0].xadh__c = requestTermValues;
                }

                rqLst[0].xadtx1__c = JSON.serialize(ffinalJson);
                rqLst[0].parCat__c = unitCategory;
                rqLst[0].xcamc__c = unitSubCategory; //no to confirm
                rqLst[0].xtpa__c = leaseRenewalCharges + ejariServiceCharge;
                if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                    update ws;
                }
                if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                    update rqLst;
                }

                rqLst = [select id, InsChk__c, ccrmldid__c, xled__c, nt__c, xvtyp__c, xcmbs__c, os__c,
                    xcddocs__c, DDA_INV__c, name, xadtx3__c, xdccaRq__c, xadtx2__c, xdei__c, xadh__c,
                    acc__c, acc__r.id, acc__r.lcedt__c, skpu__c, (select id, name, scN__c, itmCd__c,
                    ccrmid__c from items__r) from g_Req__c where id =: requestId limit 1];

                 system.debug('desctermsMap-'+desctermsMap);
                if (rqLst[0].items__r.size() > 0) {
                    for (g_reqitem__c ri: rqLst[0].items__r) {
                        if (desctermsMap != null && desctermsMap.size()>0 && desctermsMap.containsKey(ri.Name)) {
                            grqWsOnboard.PaymentSchedules py=desctermsMap.get(ri.Name);
                            system.debug(ri.Name+'--py.description-'+py.description);

                                if (ri.itmCd__c == 'rd') {
                                    ri.ccrmid__c = rqLst[0].ccrmldid__c;
                                }

                                if (ri.Name == py.description) {
                                    ri.scN__c= termAmountMap.size() > 0 && termAmountMap.containsKey(ri.itmCd__c) ? termAmountMap.get(ri.itmCd__c).get('Billing') : py.billedAmount;
                                    ri.vsc__c= termAmountMap.size() > 0 && termAmountMap.containsKey(ri.itmCd__c) ? termAmountMap.get(ri.itmCd__c).get('VAT') : py.vatAmount;
                                    ri.pcd__c=py.propertyCode;
                                    ri.tcd__c=py.tenantCode;
                                    ri.ccd__c=py.chargeCode;
                                    if ((ri.Name).contains('Lease Fee Term') && py.chargeFrom != null && py.chargeFrom!='' && py.chargeFrom!='' && py.chargeFrom!='null' && py.chargeTo != null && py.chargeTo!='null') {
                                        ri.nt__c=' (Charge Period:'+ Date.valueOf(py.chargeFrom).format() +' to '+ Date.valueOf(py.chargeTo).format()+' )';
                                    }
                                    requestItems.add(ri);
                                }
                        }

                        if (rqLst[0].InsChk__c && ri.itmCd__c == 'dr') {
                            ws_call__c wsHse = new ws_call__c();
                            wsHse.rq_jsn__c = '{ "requestType": "Lease Renewal;HSE Review", "oppId": "' + rqLst[0].ccrmldid__c + '" , "axsreference": "' +
                                rqLst[0].Name + '", "axsId": "' + ri.Id + '"}';
                            wsHse.ws_typ__c = 'axsLeaseRenewal';
                            wsHse.mtd_nm__c = 'createHSESumittalRequest';
                            wsHse.uid__c = rqLst[0].id + '-' + wsHse.mtd_nm__c + system.now();
                            wsHse.rq_itm__c = ri.Id ;
                            wsHse.intsts__c = 'Ready for Integration';
                            wsListToInsert.add(wsHse);
                        }
                    }
                    system.debug('requestItemsrequestItems-'+requestItems);
                    if (!requestItems.isEmpty()) {
                        System.debug('requestItems :'+requestItems);
                        if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                            update requestItems;
                        }
                    }

                    if (!wsListToInsert.isEmpty()) {
                        if (Schema.sObjectType.ws_call__c.isCreateable()) {
                            insert wsListToInsert;
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ws.err_msg__c = ex.getMessage() + ex.getStackTraceString();
            ws.intsts__c = 'Failed';
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update ws;
            }
            System.debug('Exception:: ' + ex.getStackTraceString());
        }

    }

}
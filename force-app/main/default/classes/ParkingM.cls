public class ParkingM {

    /*Optimization, Exception Handling,  */
    private List <ParkingDetail> lst_pd {get;set;}
    public String adh4 {get;set;}
    private Map<String, String> response;
    private String activation, updation, lostCard, addPrk, cancellation, deactivation, renewal;

    public static Boolean shwOne;
    public static final String RESPONSE_CODE    = 'ResponseCode';
    public static final String RESPONSE_MSG     = 'errMessage';
    public static final String FREE_ELG         = 'stdElg';
    public static final String PAID_ELG         = 'AddElg';
    public static final String PAID_INACTIVE    = 'AddElgPaid';
    public static final String TOTAL_UTILIZED   = 'tUtlzd';
    public static final String PAID_UTILIZED    = 'paidUtlzd';
    public static final String FREE_UTILIZED    = 'freeUtlzd';
    public static final String BALANCE          = 'balance';
    public static final String SHOW_SECTION     = 'shwSection';
    public static final String PAID_ACTIVE      = 'paidAc';
    public static final String RESERVED      = 'rsrvd';
    public static final String ENROLLED      = 'enrld';
    public static final String PRKAVL      = 'prkAvl';
    public static final String PAID_STD      = 'paidStd';
    public static final String PAID_EXC     = 'paidEXC';
    public static final String PAID_STD_N_EXC      = 'paidStdnExc';
    public static final String USED_STD      = 'usedStd';
    public static final String USED_EXC      = 'usedExc';
    public static final String USED_PRE_APPROVED ='preApproved';
    //blic integer preApproved {get;set;}
    public ParkingM() {
        response = new Map<String, String>();
        response.put(RESPONSE_CODE, '0'); response.put(RESPONSE_MSG, '');

        activation = gu.csStr('ParkingActivation');

        updation = gu.csStr('ParkingModification');
        lostCard = gu.csStr('ParkingLostCard');
        addPrk = gu.csStr('AdditionalParking');
        cancellation = gu.csStr('ParkingCancellation');
        deactivation = gu.csStr('ParkingDeact');
        renewal = gu.csStr('ParkingRenewal');
    }

    /* toDo: Remove all harcoded values*/
    //public Map < String, Integer > getEligibility(Account acc) { Map < String, Integer > el = new Map < String, Integer > (); el.put(FREE_ELG, 0); el.put(TOTAL_UTILIZED, 0); el.put(PAID_ELG, 0); el.put(PAID_INACTIVE, 0); el.put(PAID_UTILIZED, 0); el.put(FREE_UTILIZED, 0); el.put(BALANCE, 0); el.put(SHOW_SECTION, 0); el.put(RESERVED, 0); el.put(ENROLLED, 0); el.put(PRKAVL, 0); try { String rqBody = WsParking.getRqBody('getaccounteligibility', acc.ORACLE_PARTY_ID__c, null); System.debug('rqBody -- ' + rqBody); String str = WsParking.callParkingWs(rqBody); System.debug('@@str :' + str); WsParking.Response resp = (WsParking.Response) JSON.deserialize(str, WsParking.Response.class); System.debug('@@resp :' + resp); Integer activeCards = 0, reservedCards = 0, enrolledCards = 0, paidElg = 0, freeElg = 0; if (resp != null) { for (WsParking.EligibilityDetail l: resp.AccountEligibility) { system.debug('l.defaultPaidparking -- '+l.defaultPaidparking); freeElg += (string.isNotBlank(l.FreeEligibility)) ? Integer.valueOf(l.FreeEligibility) : 0; paidElg += (string.isNotBlank(l.PaidEligibility)) ? Integer.valueOf(l.PaidEligibility) : 0; activeCards += (string.isNotBlank(l.ActiveCard)) ? Integer.valueOf(l.ActiveCard) : 0; reservedCards += (string.isNotBlank(l.ReservedCard)) ? Integer.valueOf(l.ReservedCard) : 0; enrolledCards += (string.isNotBlank(l.EnrolledCard)) ? Integer.valueOf(l.EnrolledCard) : 0; if (l.defaultPaidparking) { el.put(PRKAVL, 1); } } system.debug('activeCards -- ' + activeCards); el.put(PAID_ELG, paidElg); el.put(FREE_ELG, freeElg); el.put(TOTAL_UTILIZED, activeCards); system.debug('reservedCards -- ' + reservedCards); el.put(RESERVED, reservedCards); el.put(ENROLLED, enrolledCards); for (String s: el.keySet()) { if (el.get(s) == null) { el.put(s, 0); } } } } catch (Exception ex) { System.debug('Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString()); } return el; }
    public Map < String, Integer > getEligibility(Account acc) {
        Map < String, Integer > el = new Map < String, Integer > ();
        el.put(FREE_ELG, 0);
        el.put(TOTAL_UTILIZED, 0);
        el.put(PAID_ELG, 0);
        el.put(PAID_INACTIVE, 0);
        el.put(PAID_UTILIZED, 0);
        el.put(FREE_UTILIZED, 0);
        el.put(BALANCE, 0);
        el.put(SHOW_SECTION, 0);
        el.put(RESERVED, 0);
        el.put(ENROLLED, 0);
        el.put(PRKAVL, 0);
        el.put(PAID_STD, 0);
        el.put(PAID_EXC, 0);
        el.put(PAID_STD_N_EXC, 0);
        el.put(USED_STD, 0);
        el.put(USED_EXC, 0);
        el.put(USED_PRE_APPROVED, 0);
        try {
            String rqBody = WsParking.getRqBody('getaccounteligibility', acc.ORACLE_PARTY_ID__c, null);
            System.debug('rqBody -- ' + rqBody);
            String str = WsParking.callParkingWs(rqBody);
            System.debug('@@str :' + str);
            WsParking.Response resp = (WsParking.Response) JSON.deserialize(str, WsParking.Response.class);
            System.debug('@@resp :' + resp);
            Integer activeCards = 0, reservedCards = 0, enrolledCards = 0, paidElg = 0, freeElg = 0, paidStandard = 0, paidExec = 0, paidStdandExc=0, usedStd=0, usedExc=0, usedsne=0;
            if (resp != null) {
                for (WsParking.EligibilityDetail l: resp.AccountEligibility) {
                    system.debug('l.defaultPaidparking -- ' + l.defaultPaidparking);
                    freeElg += (string.isNotBlank(l.FreeEligibility)) ? Integer.valueOf(l.FreeEligibility) : 0;
                    paidElg += (string.isNotBlank(l.PaidEligibility)) ? Integer.valueOf(l.PaidEligibility) : 0;
                    activeCards += (string.isNotBlank(l.ActiveCard)) ? Integer.valueOf(l.ActiveCard) : 0;
                    reservedCards += (string.isNotBlank(l.ReservedCard)) ? Integer.valueOf(l.ReservedCard) : 0;
                    enrolledCards += (string.isNotBlank(l.EnrolledCard)) ? Integer.valueOf(l.EnrolledCard) : 0;
                    for (WsParking.SectorLocation s: l.SectorLocations) {
                        system.debug('s.LocationName -- '+s.LocationName);
                        if (s.LocationName.toLowerCase().contains('doc')) {
                            paidStdandExc+=(string.isNotBlank(l.PaidEligibility)) ? Integer.valueOf(l.PaidEligibility) : 0;
                            paidStdandExc+=(string.isNotBlank(l.newCardsPaidEligible)) ? Integer.valueOf(l.newCardsPaidEligible) : 0;
                            if (s.LocationName.toLowerCase().contains('executive')) {
                                Integer avlblPermits = 0, orgnlPermits=0, usedPermits =0;
                                paidExec +=(string.isNotBlank(l.PaidStandardEligibility)) ? Integer.valueOf(l.PaidStandardEligibility) : 0;
                                orgnlPermits = paidExec-Integer.valueOf(l.newCardsPaidEligible);
                                usedPermits = Integer.valueOf(l.PaidEligibility);
                                avlblPermits = usedPermits>orgnlPermits?Integer.valueOf(l.newCardsPaidEligible):Integer.valueOf(l.PaidStandardEligibility)-Integer.valueOf(l.PaidEligibility);
                                paidExec = avlblPermits;
                                usedExc=Integer.valueOf(l.PaidStandardEligibility)-Integer.valueOf(l.PaidEligibility);
                            }
                            else{
                                system.debug('l.PaidStandardEligibility -- '+l.PaidStandardEligibility);
                                system.debug('l.newCardsPaidEligible -- '+l.newCardsPaidEligible);
                                paidStandard +=(string.isNotBlank(l.PaidStandardEligibility)) ? Integer.valueOf(l.PaidStandardEligibility) : 0;
                                Integer avlblPermits = 0, orgnlPermits=0, usedPermits =0;
                                orgnlPermits = paidStandard-Integer.valueOf(l.newCardsPaidEligible);
                                usedPermits = Integer.valueOf(l.PaidEligibility);
                                avlblPermits = usedPermits>orgnlPermits?Integer.valueOf(l.newCardsPaidEligible):Integer.valueOf(l.PaidStandardEligibility)-Integer.valueOf(l.PaidEligibility);
                                paidStandard = avlblPermits;
                                if (!string.isNotBlank(l.PaidStandardEligibility)&&!string.isNotBlank(l.PaidEligibility)) usedStd=Integer.valueOf(l.PaidStandardEligibility)-Integer.valueOf(l.PaidEligibility);
                            }
                            system.debug('paidStandard -- '+paidStandard);
                            system.debug('paidExec -- '+paidExec);
                            system.debug('paidElg -- '+paidElg);
                            usedsne = (paidStandard+paidExec)-paidElg<0 ? 0 : (paidStandard+paidExec)-paidElg;
                        }
                    }
                    if (l.defaultPaidparking) {
                        el.put(PRKAVL, 1);
                    }
                }
                system.debug('activeCards -- ' + activeCards);
                el.put(PAID_ELG, paidElg);
                el.put(FREE_ELG, freeElg);
                el.put(TOTAL_UTILIZED, activeCards);
                system.debug('reservedCards -- ' + reservedCards);
                el.put(RESERVED, reservedCards);
                el.put(ENROLLED, enrolledCards);
                el.put(PAID_STD, paidStandard);
                el.put(PAID_EXC, paidExec);
                el.put(PAID_STD_N_EXC, paidStdandExc);
                el.put(USED_STD, usedStd);
                el.put(USED_EXC, usedExc);
                el.put(USED_PRE_APPROVED, usedsne);
                for (String s: el.keySet()) {
                    if (el.get(s) == null) {
                        el.put(s, 0);
                    }
                }
            }
        }
        catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        return el;
    }
    public List < ParkingDetails_m > loadCards(g_Req__c rq, String srvcCode, String oracleID) {
        lst_pd = new List < ParkingM.ParkingDetail > ();
        List < ParkingDetails_m > lst_pd3 = new List < ParkingDetails_m > ();
        try {
            String str = '';
            String cardtype = '';
            /*soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            */ if (srvcCode == activation) {
                cardtype = 'Active';
                /*cardtype = 'Inactive';
                cardtype = 'Both';
            */ }
            else if (srvcCode == updation) {
                cardtype = 'Active';
            }
            else if (srvcCode == cancellation || srvcCode == renewal || srvcCode == deactivation || srvcCode == lostCard || srvcCode == gu.csStr('ParkingDetail')) {
                cardtype = 'Both';
            }
            else if (srvcCode == '197') {
                cardtype = 'courCollection';
            }
            /*String rqBody = WsParking.getRqBody('getavailablecards', oracleID, null);
            */ if (srvcCode == '197') {
                List <grqWsDccaGetService.Records> tecomLeaseList = grqWsDccaGetService.loadD3Loc(oracleID);
                if (tecomLeaseList != null && !tecomLeaseList.isEmpty()) {
                    for (grqWsDccaGetService.Records rec: tecomLeaseList) {
                        if (String.isNotBlank(rec.Category) && !((rec.Category).contains('Parking')) ) {
                            ParkingDetails_m pd = new ParkingDetails_m();
                            pd.BusinessPark = '0';
                            pd.cardNum = rec.AgNo;
                            pd.cardType = rec.Category;
                            lst_pd3.add(pd);
                        }
                    }
                }
            }
            else{
                String rqBody = '{"ActionName":"getavailablecards", "OracleID":"' + oracleID + '", "CardStatus":"' + cardtype + '"}';
                String cardDets = WsParking.callParkingWs(rqBody);
                system.debug('cardDets -- ' + cardDets);
                WsParking.Response resp = (WsParking.Response) JSON.deserialize(cardDets, WsParking.Response.class);
                for (WsParking.Card c: resp.CardsDetail) {
                    ParkingDetails_m pd = new ParkingDetails_m();
                    pd.sector = c.Sector;
                    pd.sectorId = c.SectorLocationId;
                    pd.BusinessPark = c.BusinessPark;
                    pd.cardNum = c.CardNumber;
                    pd.actStat = c.CardStatus;
                    pd.cHolderNm = c.CardHolderName;
                    pd.cardType = c.CardType;
                    pd.refMobile = c.CardHolderPhone;
                    pd.email = c.CardHolderEmail;
                    pd.isReserved = c.IsReserved;
                    pd.EligibilityName = c.EligibilityName;
                    if (c.CardExpDate != null) {
                        String[] d = c.CardExpDate.split('-');
                        pd.expDate = d[2] + '/' + d[1] + '/' + d[0];
                    }
                    String regVehs = JSON.serialize(c.Vehicles);
                    system.debug('regVehs - ' + regVehs);
                    pd.vDetails = c.Vehicles;
                    lst_pd3.add(pd);
                }
            }
            if (lst_pd3 != null && lst_pd3.size() > 0) lst_pd3.sort();
        }
        catch (Exception ex) {
            System.debug('##Exception : ' + ex.getStackTraceString());
        }
        return lst_pd3;
    }
    public List < ParkingDetails_m > loadCards(String oracleID) {
    List < ParkingDetails > lst_pd2 = new List < ParkingDetails > ();
    List < ParkingDetails_m > lst_pd3 = new List < ParkingDetails_m > ();
    try {
        String str = '';
        String rqBody = '{"ActionName":"getavailablecards", "OracleID":"' + oracleID + '", "CardStatus":"BOTH"}';
        String cardDets = WsParking.callParkingWs(rqBody);
        system.debug('cardDets -- ' + cardDets);
        WsParking.Response resp = (WsParking.Response) JSON.deserialize(cardDets, WsParking.Response.class);
            for (WsParking.Card c: resp.CardsDetail) {
                ParkingDetails_m pd = new ParkingDetails_m();
                pd.sector = c.Sector;
                pd.BusinessPark = c.BusinessPark;
                pd.cardNum = c.CardNumber;
                pd.actStat = c.CardStatus;
                pd.EligibilityName = c.EligibilityName;
                pd.isReserved = c.IsReserved;
                pd.cHolderNm = c.CardHolderName;
                pd.cardType = c.CardType;
                pd.refMobile = c.CardHolderPhone;
                pd.email = c.CardHolderEmail;
                pd.sectorId = c.SectorLocationId;
                pd.sectorlocationname = c.SectorLocationName;
                if (c.CardExpDate != null) {
                    String[] d = c.CardExpDate.split('-');
                    pd.expDate = d[2] + '/' + d[1] + '/' + d[0];
                }
                String regVehs = JSON.serialize(c.Vehicles);
                system.debug('regVehs - ' + regVehs);
                pd.vDetails = c.Vehicles;
                lst_pd3.add(pd);
                system.debug('---lst_pd3---' + lst_pd3);
            }
    } catch (Exception ex) {
        System.debug('##Exception : ' + ex.getStackTraceString());
    }
    System.debug('lst_pd:   ++++ ' + lst_pd3);
    if (!lst_pd3.isEmpty()) {
        return lst_pd3;
    } else {
        return null;
    }
}
    //public List < ParkingDetails_m > loadCards(String oracleID) { List < ParkingDetails > lst_pd2 = new List < ParkingDetails > (); List < ParkingDetails_m > lst_pd3 = new List < ParkingDetails_m > (); try { String str = ''; String rqBody = '{"ActionName":"getavailablecards", "OracleID":"' + oracleID + '", "CardStatus":"BOTH"}'; String cardDets = WsParking.callParkingWs(rqBody); system.debug('cardDets -- ' + cardDets); WsParking.Response resp = (WsParking.Response) JSON.deserialize(cardDets, WsParking.Response.class); for (WsParking.Card c: resp.CardsDetail) { ParkingDetails_m pd = new ParkingDetails_m(); pd.sector = c.Sector; pd.BusinessPark = c.BusinessPark; pd.cardNum = c.CardNumber; pd.actStat = c.CardStatus; pd.EligibilityName = c.EligibilityName; pd.isReserved = c.IsReserved; pd.cHolderNm = c.CardHolderName; pd.cardType = c.CardType; pd.refMobile = c.CardHolderPhone; pd.email = c.CardHolderEmail; pd.sectorId = c.SectorLocationId; if (c.CardExpDate != null) { String[] d = c.CardExpDate.split('-'); pd.expDate = d[2] + '/' + d[1] + '/' + d[0]; } String regVehs = JSON.serialize(c.Vehicles); system.debug('regVehs - ' + regVehs); pd.vDetails = c.Vehicles; lst_pd3.add(pd); } lst_pd3.sort(); } catch (Exception ex) { System.debug('##Exception : ' + ex.getStackTraceString()); } System.debug('lst_pd:   ++++ ' + lst_pd3); if (!lst_pd3.isEmpty()) { return lst_pd3; } else { return null; } }
    public Map<String, String> validateVehicle2(g_Req__c rq, List<gctlReqI.itm> lstItem) {
        Boolean isOkay = true;
        String str='';
        try{
            soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            if ( rq.xtcid__c != null ) {
                str = tps.checkVehicleValidity(rq.xtcid__c, rq.xps__c, rq.xpveh__c, rq.xppor__c, rq.xsvn__c, rq.xspor__c);
            }
            System.debug('Validation Response: ' + str);
            PushResponse pushResponse = (PushResponse)JSON.deserialize(str, ParkingM.PushResponse.class);
            response.put(RESPONSE_CODE, pushResponse.ErrorCode);
            response.put(RESPONSE_MSG, pushResponse.ErrorMessage);
            return response;
        }
        catch (Exception ex) {
            response.put(RESPONSE_CODE, '1');
            response.put(RESPONSE_MSG, 'Technical error, please contact your administrator.' + ex.getMessage());
            System.debug('Exception : ' + ex.getMessage() + '  :  ' + ex.getStackTraceString());
            return response;
        }
    }

    /*
     * ## pushes request data to Tecom-CRM
     * 1. for new Free-Parking and UpdateParking requests - on uploading the documents,
     * 2. for Lost Card - on processing the payment,
     * 3. for Additional/Paid parking - on creating the request(Save and Continue).
     */

    public Map < String, String > pushReqItems(String rqID, list < g_reqitem__c > lstItems) {
        /*** ToDo : Optimise the method - eliminte the vehicleDetails as no longer in use***/ system.debug('rqID -- ' + rqID);
        g_reqitem__c primVeh;
        DOM.Document doc = new DOM.Document();
        Map < String, g_reqitem__c > vechMap = new Map < String, g_reqitem__c > ();
        dom.XmlNode request = doc.createRootElement('Request', null, null);
        /* items need to be queried if the call is from docs page*/ if (lstItems == null || lstItems.size() == 0) {
            lstItems = [SELECT Id, name, ccrmid__c, xspor__c, xspnc__c, xcbn__c, sta__c, xcmo__c,
                xcpc__c, xcpnc__c, xcpor__c, xcvc__c, RQ__c, RQ__r.name, RQ__r.xadtx4__c, RQ__r.rtacn__c,
                RQ__r.xps__c, RQ__r.xchn__c, RQ__r.xceml__c, RQ__r.rmob__c, RQ__r.xoln__c, RQ__r.Service_Code__c,
                itm__r.cd__c, RQ__r.xrap__c, RQ__r.xtpa__c, RQ__r.xanum__c, RQ__r.xaed__c, RQ__r.Acc__r.ORACLE_PARTY_ID__c,
                RQ__r.xtcid__c from g_reqitem__c where RQ__c =: rqId order by createdDate];
            system.debug('lstItems -- ' + lstItems);
        }
        /* get request-item details*/ if (lstItems != null && lstItems.size() > 0) {
            for (g_reqitem__c itm: lstItems) {
                vechMap.put(itm.itm__r.cd__c, itm);
                if (itm.itm__r.cd__c == '0np' || itm.itm__r.cd__c == '1np' || itm.itm__r.cd__c == 'xnp') {
                    primVeh = itm;
                }
            }
        }
        try {
            Set < String > pSrvcCds = new Set < String > ();
            pSrvcCds.add(activation);
            pSrvcCds.add(updation);
            pSrvcCds.add(lostCard);
            pSrvcCds.add(addPrk);
            pSrvcCds.add(cancellation);
            pSrvcCds.add(deactivation);
            system.debug('primVeh -- ' + primVeh);
            if (primVeh != null && String.isNotBlank(primVeh.RQ__c) && pSrvcCds.contains(primVeh.RQ__r.Service_Code__c)) {
                String service = '', sVar = '';
                String srvcCd = primVeh.RQ__r.Service_Code__c;
                if (srvcCd == activation) {
                    service = 'Activation';
                }
                else if (srvcCd == updation) {
                    service = 'Modification';
                }
                else if (srvcCd == lostCard) {
                    service = 'Lost';
                }
                else if (srvcCd == cancellation) {
                    service = 'Cancellation';
                    if (primVeh.RQ__r.xadtx4__c.contains('Deact')) /* added for differentiatin b/w cancellation and deactivation as using same service in AXS2.0 - VMKR*/ service = 'Deactivation';
                }
                else if (srvcCd == deactivation) {
                    service = 'Deactivation';
                }
                System.debug('####### primVeh.RQ__r.xchn__c :  ' + primVeh.RQ__r.xchn__c);
                System.debug('####### service :  ' + service);
                request.addChildElement('service', null, null).addTextNode(service);
                request.addChildElement('requestNo', null, null).addTextNode(primVeh.RQ__r.Name);
                request.addChildElement('oracleID', null, null).addTextNode(primVeh.RQ__r.Acc__r.ORACLE_PARTY_ID__c);
                /*-------------------------------------------*/ sVar = String.isNotBlank(primVeh.RQ__r.rtacn__c) ? primVeh.RQ__r.rtacn__c : '';
                request.addChildElement('cardNo', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xchn__c) ? primVeh.RQ__r.xchn__c : '';
                request.addChildElement('cardHolderName', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xoln__c) ? primVeh.RQ__r.xoln__c : '';
                request.addChildElement('landlineNo', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.rmob__c) ? primVeh.RQ__r.rmob__c : '';
                request.addChildElement('refMobile', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xceml__c) ? primVeh.RQ__r.xceml__c : '';
                request.addChildElement('email', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xps__c) ? primVeh.RQ__r.xps__c : '';
                request.addChildElement('sector', null, null).addTextNode(sVar);
                /*-------------------------------------------*/ /* if (String.isNotBlank(primVeh.RQ__r.rtacn__c)) {
                    request.addChildElement('cardNo', null, null).addTextNode(primVeh.RQ__r.rtacn__c);
                }
                else{
                    request.addChildElement('cardNo', null, null).addTextNode('');
                }
                if (String.isNotBlank(primVeh.RQ__r.xchn__c)) {
                    request.addChildElement('cardHolderName', null, null).addTextNode(primVeh.RQ__r.xchn__c);
                }
                else {
                    request.addChildElement('cardHolderName', null, null).addTextNode('');
                }
                if (String.isNotBlank(primVeh.RQ__r.xoln__c)) {
                    request.addChildElement('landlineNo', null, null).addTextNode(primVeh.RQ__r.xoln__c);
                }
                else{
                    request.addChildElement('landlineNo', null, null).addTextNode('');
                }
                if (String.isNotBlank(primVeh.RQ__r.rmob__c)) {
                    request.addChildElement('refMobile', null, null).addTextNode(primVeh.RQ__r.rmob__c);
                }
                else{
                    request.addChildElement('refMobile', null, null).addTextNode('');
                }
                if (String.isNotBlank(primVeh.RQ__r.xceml__c)) {
                    request.addChildElement('email', null, null).addTextNode(primVeh.RQ__r.xceml__c);
                }
                else{
                    request.addChildElement('email', null, null).addTextNode('');
                }
                if (String.isNotBlank(primVeh.RQ__r.xps__c )) {
                    request.addChildElement('sector', null, null).addTextNode(primVeh.RQ__r.xps__c);
                }
                else {
                    request.addChildElement('sector', null, null).addTextNode('');
                }
                */ if (srvcCd == addPrk) {
                    request.addChildElement('amount', null, null).addTextNode('' + primVeh.RQ__r.xtpa__c);
                    request.addChildElement('reqSlots', null, null).addTextNode('' + primVeh.RQ__r.xrap__c);
                    request.addChildElement('agNo', null, null).addTextNode('' + primVeh.RQ__r.xanum__c);
                    request.addChildElement('parkingType', null, null).addTextNode('Paid');
                }
                else {
                    request.addChildElement('amount', null, null).addTextNode('');
                    request.addChildElement('reqSlots', null, null).addTextNode('');
                    request.addChildElement('agNo', null, null).addTextNode('');
                    request.addChildElement('parkingType', null, null).addTextNode('Free');
                }
                dom.XmlNode Items = request.addChildElement('Items', null, null);
                dom.XmlNode attachments = request.addChildElement('attachments', null, null);
                if (srvcCd == activation || srvcCd == updation || srvcCd == cancellation || srvcCd == deactivation) {
                    system.debug('xadtx4__c##adh4--' + adh4);
                    if (String.isNotBlank(adh4)) {
                        system.debug('xadtx4__c2--' + adh4);
                        ActCard carddetails = (ActCard) JSON.deserialize(adh4, ActCard.class);
                        system.debug('carddetails--' + carddetails);
                        if (carddetails != null && carddetails.items != null) {
                            for (Vehicle1 veh: carddetails.items) {
                                system.debug('veh--' + veh);
                                dom.XmlNode Item = Items.addChildElement('Item', null, null);
                                sVar = String.isNotBlank(veh.pltNum_RC) ? veh.pltNum_RC : '';
                                Item.addChildElement('plateNumberCode', null, null).addTextNode(sVar);
                                sVar = String.isNotBlank(veh.RegDate_RC) ? veh.RegDate_RC : '';
                                Item.addChildElement('placeOfReg', null, null).addTextNode(sVar);
                                /* if (String.isNotBlank(veh.xcpnc__c)) {
                                    Item.addChildElement('plateNumberCode', null, null).addTextNode(veh.xcpnc__c);
                                }
                                else{
                                    Item.addChildElement('plateNumberCode', null, null).addTextNode('');
                                }
                                if (String.isNotBlank(veh.xcpor__c)) {
                                    Item.addChildElement('placeOfReg', null, null).addTextNode(veh.xcpor__c);
                                }
                                else{
                                    Item.addChildElement('placeOfReg', null, null).addTextNode('');
                                }
                                */ /* remove this section*/ Item.addChildElement('vehicle', null, null).addTextNode(veh.sequence);
                                Item.addChildElement('status', null, null).addTextNode(veh.status);
                                Item.addChildElement('brandName', null, null).addTextNode(veh.VehType_RC);
                                Item.addChildElement('model', null, null).addTextNode(veh.VehModel_RC);
                                Item.addChildElement('plateColor', null, null).addTextNode('');
                                Item.addChildElement('vehicleColor', null, null).addTextNode('');
                            /**/ }
                        }
                    }
                    /*for (g_reqitem__c veh: lstItems) {
                        dom.XmlNode Item = Items.addChildElement('Item', null, null);
                        sVar = String.isNotBlank(veh.xcpnc__c) ? veh.xcpnc__c : '';
                        Item.addChildElement('plateNumberCode', null, null).addTextNode(sVar);
                        sVar = String.isNotBlank(veh.xcpor__c) ? veh.xcpor__c : '';
                        Item.addChildElement('placeOfReg', null, null).addTextNode(sVar);
                        if (String.isNotBlank(veh.xcpnc__c)) {
                            Item.addChildElement('plateNumberCode', null, null).addTextNode(veh.xcpnc__c);
                        }
                        else{
                            Item.addChildElement('plateNumberCode', null, null).addTextNode('');
                        }
                        if (String.isNotBlank(veh.xcpor__c)) {
                            Item.addChildElement('placeOfReg', null, null).addTextNode(veh.xcpor__c);
                        }
                        else{
                            Item.addChildElement('placeOfReg', null, null).addTextNode('');
                        }
                        Item.addChildElement('vehicle', null, null).addTextNode('Primary vehicle');
                        Item.addChildElement('status', null, null).addTextNode(veh.sta__c);
                        Item.addChildElement('brandName', null, null).addTextNode('');
                        Item.addChildElement('model', null, null).addTextNode('');
                        Item.addChildElement('plateColor', null, null).addTextNode('');
                        Item.addChildElement('vehicleColor', null, null).addTextNode('');
                        if (String.isNotBlank(veh.xspor__c) && String.isNotBlank(veh.xspnc__c)) {
                            dom.XmlNode Item2 = Items.addChildElement('Item', null, null);
                            Item2.addChildElement('plateNumberCode', null, null).addTextNode(veh.xspnc__c);
                            Item2.addChildElement('placeOfReg', null, null).addTextNode(veh.xspor__c);
                            Item2.addChildElement('vehicle', null, null).addTextNode('Secondary vehicle');
                            Item2.addChildElement('status', null, null).addTextNode(veh.sta__c);
                            Item2.addChildElement('brandName', null, null).addTextNode('');
                            Item2.addChildElement('model', null, null).addTextNode('');
                            Item2.addChildElement('plateColor', null, null).addTextNode('');
                            Item2.addChildElement('vehicleColor', null, null).addTextNode('');
                        }
                    }
                    */ list < g_reqDoc__c > rDocs = [Select Id From g_reqDoc__c where RQ__c =: rqId];
                    list < Attachment > att = [Select Id, Body, Name, parent.name, CreatedBy.ProfileId, CreatedById From Attachment where isDeleted = false and parentId in: rDocs];
                    if (att.size() > 0) {
                        for (Attachment at: att) {
                            dom.XmlNode attachment = attachments.addChildElement('attachment', null, null);
                            attachment.addChildElement('name', null, null).addTextNode(at.parent.name);
                            attachment.addChildElement('body', null, null).addTextNode('');
                        }
                    }
                    else {
                        dom.XmlNode attachment = attachments.addChildElement('attachment', null, null);
                        attachment.addChildElement('name', null, null).addTextNode('');
                        attachment.addChildElement('body', null, null).addTextNode('');
                    }
                }
                String xmlRequestData = doc.toXmlString();
                system.debug('xmlRequestData--' + xmlRequestData);
                System.debug('xmlstring: ' + xmlRequestData);
                /*xmlRequestData = '<?xml version="1.0" encoding="UTF-8"?><Request><service>Lost</service><requestNo>84386820200910</requestNo><oracleID>27773</oracleID><cardNo>14505</cardNo><cardHolderName>Rasha ISSA Almasri</cardHolderName><landlineNo>0808080</landlineNo><refMobile>5515515512</refMobile><email>muni@gmail.com</email><sector></sector><amount></amount><reqSlots></reqSlots><agNo></agNo><parkingType>Free</parkingType><Items /><attachments /></Request>';
                */ if (srvcCd == lostCard || srvcCd == addPrk || srvcCd == cancellation || srvcCd == deactivation) {
                    doInsertAsync(xmlRequestData);
                }
                else {
                    soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
                    String res = tps.doInsertRequest(xmlRequestData);
                    CCRMResponse pushResponse = (CCRMResponse) JSON.deserialize(res, ParkingM.CCRMResponse.class);
                    system.debug('pushResponse.Status--' + pushResponse.Status);
                    system.debug('pushResponse--' + pushResponse);
                    if (pushResponse.Status == 'Success') {
                        system.debug('pushResponse.vehicleList--' + pushResponse.vehicleList);
                        list < vehicleWrapper > vehicleList = pushResponse.vehicleList;
                        list < g_reqitem__c > vchlst = new list < g_reqitem__c > ();
                        list < ws_call__c > wsvchlst = new list < ws_call__c > ();
                        for (vehicleWrapper Vchitm: vehicleList) {
                            system.debug('Vchitm.vehicleSequence--' + Vchitm.vehicleSequence);
                            system.debug('Vchitm.vehicleId--' + Vchitm.vehicleId);
                            g_reqitem__c vitm = vechMap.get(Vchitm.vehicleSequence);
                            vitm.ccrmid__c = Vchitm.vehicleId;
                            vchlst.add(vitm);
                            wsvchlst.add(new ws_call__c(rq_itm__c = vitm.id, intsts__c = 'Ready for Integration', mtd_nm__c = 'uploadDocs', ws_typ__c = 'Parking'));
                        }
                        system.debug('vchlst--' + vchlst);
                        system.debug('wsvchlst--' + wsvchlst);
                        if (!vchlst.isEmpty()) {
                            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                                update vchlst;
                            }
                        }
                        if (!wsvchlst.isEmpty()) {
                            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                                insert wsvchlst;
                            }
                            List < String > lstWsIds = new List < String > ();
                            for (ws_call__c ws: wsvchlst) {
                                lstWsIds.add(ws.ID);
                            }
                            /*doInsertAttAsync(lstWsIds);
                        */ }
                    }
                    system.debug('pushResponse--' + res);
                    response.put(RESPONSE_CODE, pushResponse.Status);
                    response.put(RESPONSE_MSG, pushResponse.Message);
                    System.debug('doInsertRequest 2: ' + response);
                }
                return response;
            }
        }
        catch (System.LimitException lEx) {
            response.put(RESPONSE_CODE, '1');
            response.put(RESPONSE_MSG, 'Attachment size [Emirates ID card / Passport Copy] exceeds the allowable limit.');
            return response;
        }
        catch (Exception ex) {
            if (ex.getMessage().contains('Apex heap size too large')) {
                response.put(RESPONSE_CODE, '1');
                response.put(RESPONSE_MSG, 'Attachment size [Emirates ID card / Passport Copy] exceeds the allowable limit.');
                return response;
            }
            System.debug('**** EXC : ' + ex.getMessage() + ' LN: ' + ex.getStackTraceString());
            response.put(RESPONSE_CODE, '1');
            response.put(RESPONSE_MSG, '#Exception: ' + ex.getMessage() + ' LN: ' + ex.getStackTraceString());
            return response;
        }
        return response;
    }

    public Map<String, String> pushReqItemsCrctn(String rqID, list<g_reqitem__c> lstItems) {
        /*** ToDo : Optimise the method - eliminte the vehicleDetails as no longer in use***/ system.debug('rqID -- '+rqID);
        g_reqitem__c primVeh;
        DOM.Document doc = new DOM.Document();
        dom.XmlNode request = doc.createRootElement('Request', null, null);
        /* items need to be queried if the call is from docs page*/ if (lstItems == null || lstItems.size() == 0) {
            lstItems=[SELECT Id, name, xspor__c, xspnc__c, xcbn__c, sta__c, xcmo__c, xcpc__c,
                xcpnc__c, xcpor__c, xcvc__c, RQ__c, RQ__r.name, RQ__r.xadtx4__c, RQ__r.rtacn__c,
                RQ__r.xps__c, RQ__r.xchn__c, RQ__r.xceml__c, RQ__r.rmob__c, RQ__r.xoln__c, RQ__r.Service_Code__c,
                itm__r.cd__c, RQ__r.xrap__c, RQ__r.xtpa__c, RQ__r.xanum__c, RQ__r.xaed__c, RQ__r.Acc__r.ORACLE_PARTY_ID__c,
                RQ__r.xtcid__c from g_reqitem__c where RQ__c = :rqId order by createdDate];
            system.debug('lstItems -- '+lstItems);
        }
        /* get request-item details*/ if (lstItems != null && lstItems.size() > 0) {
            for (g_reqitem__c itm : lstItems) {
                if (itm.itm__r.cd__c=='0np' || itm.itm__r.cd__c=='1np'|| itm.itm__r.cd__c=='xnp') {
                    primVeh=itm;
                }
            }
        }
        try {
            Set<String> pSrvcCds = new Set<String>();
            pSrvcCds.add(activation);
            pSrvcCds.add(updation);
            pSrvcCds.add(lostCard);
            pSrvcCds.add(addPrk);
            pSrvcCds.add(cancellation);
            pSrvcCds.add(deactivation);
            system.debug('primVeh -- '+primVeh);
            if (primVeh != null && String.isNotBlank(primVeh.RQ__c) && pSrvcCds.contains(primVeh.RQ__r.Service_Code__c)) {
                String service='', sVar='';
                String  srvcCd = primVeh.RQ__r.Service_Code__c;
                if (srvcCd == activation) {
                    service='Activation';
                }
                else if (srvcCd == updation) {
                    service='Modification';
                }
                else if (srvcCd == lostCard) {
                    service='Lost';
                }
                else if (srvcCd == cancellation) {
                    service='Cancellation';
                    if (primVeh.RQ__r.xadtx4__c.contains('Deact')) /* added for differentiatin b/w cancellation and deactivation as using same service in AXS2.0 - VMKR*/ service='Deactivation';
                }
                else if (srvcCd == deactivation) {
                    service='Deactivation';
                }
                System.debug('####### primVeh.RQ__r.xchn__c :  ' + primVeh.RQ__r.xchn__c );
                System.debug('####### service :  ' + service );
                request.addChildElement('service', null, null).addTextNode(service);
                request.addChildElement('requestNo', null, null).addTextNode(primVeh.RQ__r.Name);
                request.addChildElement('oracleID', null, null).addTextNode(primVeh.RQ__r.Acc__r.ORACLE_PARTY_ID__c);
                /*-------------------------------------------*/ sVar = String.isNotBlank(primVeh.RQ__r.rtacn__c) ? primVeh.RQ__r.rtacn__c : '';
                request.addChildElement('cardNo', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xchn__c) ? primVeh.RQ__r.xchn__c : '';
                request.addChildElement('cardHolderName', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xoln__c) ? primVeh.RQ__r.xoln__c : '';
                request.addChildElement('landlineNo', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.rmob__c) ? primVeh.RQ__r.rmob__c : '';
                request.addChildElement('refMobile', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xceml__c) ? primVeh.RQ__r.xceml__c : '';
                request.addChildElement('email', null, null).addTextNode(sVar);
                sVar = String.isNotBlank(primVeh.RQ__r.xps__c) ? primVeh.RQ__r.xps__c : '';
                request.addChildElement('sector', null, null).addTextNode(sVar);
                request.addChildElement('amount', null, null).addTextNode('');
                request.addChildElement('reqSlots', null, null).addTextNode('');
                request.addChildElement('agNo', null, null).addTextNode('');
                request.addChildElement('parkingType', null, null).addTextNode('Free');
                dom.XmlNode Items= request.addChildElement('Items', null, null);
                dom.XmlNode attachments= request.addChildElement('attachments', null, null);
                if (srvcCd == activation || srvcCd == updation) {
                    for (g_reqitem__c veh : lstItems) {
                        dom.XmlNode Item= Items.addChildElement('Item', null, null);
                        sVar = String.isNotBlank(veh.xcpnc__c) ? veh.xcpnc__c : '';
                        Item.addChildElement('plateNumberCode', null, null).addTextNode(sVar);
                        sVar = String.isNotBlank(veh.xcpor__c) ? veh.xcpor__c : '';
                        Item.addChildElement('placeOfReg', null, null).addTextNode(sVar);
                        /* remove this section*/ Item.addChildElement('vehicle', null, null).addTextNode('Primary vehicle');
                        Item.addChildElement('status', null, null).addTextNode(veh.sta__c);
                        Item.addChildElement('brandName', null, null).addTextNode('');
                        Item.addChildElement('model', null, null).addTextNode('');
                        Item.addChildElement('plateColor', null, null).addTextNode('');
                        Item.addChildElement('vehicleColor', null, null).addTextNode('');
                        if (String.isNotBlank(veh.xspor__c) && String.isNotBlank(veh.xspnc__c)) {
                            dom.XmlNode Item2= Items.addChildElement('Item', null, null);
                            Item2.addChildElement('plateNumberCode', null, null).addTextNode(veh.xspnc__c);
                            Item2.addChildElement('placeOfReg', null, null).addTextNode(veh.xspor__c);
                            /* remove this section*/ Item2.addChildElement('vehicle', null, null).addTextNode('Secondary vehicle');
                            Item2.addChildElement('status', null, null).addTextNode(veh.sta__c);
                            Item2.addChildElement('brandName', null, null).addTextNode('');
                            Item2.addChildElement('model', null, null).addTextNode('');
                            Item2.addChildElement('plateColor', null, null).addTextNode('');
                            Item2.addChildElement('vehicleColor', null, null).addTextNode('');
                        }
                    }
                    list<g_reqDoc__c> rDocs=[Select Id From g_reqDoc__c where RQ__c = :rqId and name like '%copy%'];
                    list<Attachment> att=[Select Id, Body, Name, parent.name, CreatedBy.ProfileId, CreatedById From Attachment where isDeleted = false and parentId in :rDocs];
                    system.debug('att of size  '+att.size()+' are --> '+att);
                    if (att.size() > 0) {
                        for (Attachment at:att) {
                            dom.XmlNode attachment= attachments.addChildElement('attachment', null, null);
                            attachment.addChildElement('name', null, null).addTextNode(at.parent.name);
                            attachment.addChildElement('body', null, null).addTextNode(EncodingUtil.base64Encode(at.Body));
                            system.debug('attachment-- '+attachment);
                        }
                    }
                    else{
                        dom.XmlNode attachment= attachments.addChildElement('attachment', null, null);
                        attachment.addChildElement('name', null, null).addTextNode('');
                        attachment.addChildElement('body', null, null).addTextNode('');
                    }
                }
                String xmlRequestData = doc.toXmlString();
                System.debug('xmlstring: ' + xmlRequestData);
                doInsertAsync(xmlRequestData);
                return response;
            }
        }
        catch (System.LimitException lEx) {
            response.put(RESPONSE_CODE, '1');
            response.put(RESPONSE_MSG, 'Attachment size [Emirates ID card / Passport Copy] exceeds the allowable limit.');
            return response;
        }
        catch (Exception ex) {
            if (ex.getMessage().contains('Apex heap size too large')) {
                response.put(RESPONSE_CODE, '1');
                response.put(RESPONSE_MSG, 'Attachment size [Emirates ID card / Passport Copy] exceeds the allowable limit.');
                return response;
            }
            System.debug('**** EXC : '+ex.getMessage()+' LN: '+ex.getStackTraceString());
            response.put(RESPONSE_CODE, '1');
            response.put(RESPONSE_MSG, '#Exception: '+ex.getMessage()+' LN: '+ex.getStackTraceString());
            return response;
        }
        return response;
    }

    @future(callout=true)
    public static void doInsertAsync(String xmlStr) {
        try{
            System.debug('<doInsertAsync> xmlStr : ' + xmlStr);
            soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            String res = tps.doInsertRequest(xmlStr);
            System.debug('<doInsertAsync> response : ' + res);
        }
        catch (Exception ex) {
            System.debug('<doInsertAsync> Exception : ' + ex.getMessage() + ex.getStackTraceString());
        }
    }
    //public static void doInsertAttAsync(List<String> wsIds) {try{database.executeBatch(new BatchUploadParkingAtts(wsIds), 1);}catch (Exception ex) {System.debug('<doInsertAttAsync> Exception : ' + ex.getMessage() + ex.getStackTraceString()); }}
   /*#########################################
    ## Additional/Paid Parking Services ##
    ######################################### */
    /*
     * get list of all agreements/sectors for additional parking
     */
   public List < AddtnlPark > getAddParks(g_Req__c rq, String oracleID) {
    List < AddtnlPark > lstAddparks = new List < AddtnlPark > ();
    Boolean isElg = false;
    try {
        System.debug('458 ');
        String str1 = WsParking.getRqBody('getaccounteligibility', oracleID, rq);
        String cardDets = WsParking.callParkingWs(str1);
        System.debug('cardDets -459: ' + cardDets);
        WsParking.Response resp = (WsParking.Response) JSON.deserialize(cardDets, WsParking.Response.class);
        system.debug('resp --- '+resp);
        for (WsParking.EligibilityDetail elg: resp.AccountEligibility) {
            for (WsParking.SectorLocation s: elg.SectorLocations) {
                AddtnlPark p = new AddtnlPark();
                p.Sequence = s.Sequence;
                p.LocationName = s.LocationName;
                p.LocaionId = s.LocaionId;
                p.SectorID = elg.SectorID;
                p.EligibilityID = elg.EligibilityID;
                p.isDefault = s.isDefault;
                p.AgNumber = elg.AgNo;
                p.NewEligibility = elg.newCardsPaidEligible;
                p.PaidStandardEligibility = elg.PaidStandardEligibility;
                /*string.valueOf(Integer.valueOf(elg.PaidStandardEligibility)+((string.isNotBlank(elg.newCardsPaidEligible)) ? Integer.valueOf(elg.newCardsPaidEligible) : 0));
                */ p.PaidStandardPrice = s.PaidStandardPrice;
                p.PaidEligibility = elg.PaidEligibility;
                p.RemainingPaidEligible = elg.RemainingPaidEligible;
                List < String > dt = elg.LeaseEndDate.split('-');
                p.LeaseExp = dt[2] + '/' + dt[1] + '/' + dt[0];
                system.debug('SectorLocation -- ' + p);
                lstAddparks.add(p);
            }
            /*for (WsParking.LeaseDetail o : elg.EligibilityDetail) {
                AddPark p = new AddPark();
                System.debug('o--- : ' + o);
                p.sector = o.Sector;
                p.noOfAO=o.Eligibility;
                p.cntrNo = o.AgNo;
                p.cardID = o.AgNo;
                p.cardType = 'Standard';
                p.elg = o.EligibilityName;
                String[] d=o.LeaseEndDate.split('-');
                p.cntrExp=d[2]+'/'+d[1]+'/'+d[0];
                if (rq != null && String.isNotBlank(rq.xtcid__c) && p.cardId == rq.xtcid__c) {
                    p.sel=true;
                    isElg=true;
                }
                lstAddparks.add(p);
            }
        */ }
        if (!isElg && (rq.STA__c.equalsIgnoreCase('open') || rq.STA__c.equalsIgnoreCase('draft'))) {}
    } catch (Exception ex) {
        System.debug('**** EXC : ' + ex.getMessage() + ' LN : ' + ex.getStackTraceString());
    }
    return lstAddparks;
}  /*get Price per unit*/
   public Map<String, String> getAmntAP(date d, String agNo) {
       try{
           soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
           String resp = tps.perSlotPriceCalculation(d, agNo);
           PushResponse pushResponse = (PushResponse)JSON.deserialize(resp, ParkingM.PushResponse.class);
           System.debug('<getAmntAP> : ' + pushResponse);
           response.put('errorCode', pushResponse.ErrorCode);
           response.put('amount', ''+pushResponse.amountPerSlot);
           response.put('errorMsg', pushResponse.ErrorMessage);
           return response;
       }
       catch (Exception ex) {
           response.put('errorCode', '1');
           response.put('amount', '0.0');
           response.put('errorMsg', ex.getMessage());
           System.debug('**** EXC : ' + ex.getMessage() + ' LN : ' + ex.getStackTraceString() );
           return response;
       }
   }
    @future(callout=true)
    public static void createPaidCards(String rqID, String agNo, Date expDate) {
        try{
            System.debug('rqID : ' + rqID +'  agNo: ' + agNo + '  expDate: ' +expDate);
            soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            String resp = tps.createPaidCards(rqID, agNo, expDate);
            PushResponse pushResponse = (PushResponse)JSON.deserialize(resp, ParkingM.PushResponse.class);
        }
        catch (Exception ex) {
            System.debug('Exception : '+ex.getMessage()+' LN: '+ex.getStackTraceString());
        }
    }

    //ToDo: ask TECOM to merge the method with createPaidCards
    @future(callout=true)
    public static void updatePaymentStatus(String rqID) {
        try{
            System.debug('rqID : ' + rqID);
            g_req__c rq = [SELECT Id, Name, xceml__c, rmob__c, xoln__c From g_req__c WHERE name=:rqID];
            soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            String resp = tps.updatePaymentStatus(rqID);
            tps.UpdateRequestDetails(rqID, '', rq.xceml__c, rq.rmob__c, rq.xoln__c);
            PushResponse pushResponse = (PushResponse)JSON.deserialize(resp, ParkingM.PushResponse.class);
            System.debug('<PM : updatePaymentStatus> ' + pushResponse);
        }
        catch (Exception ex) {
            System.debug('Exception : '+ex.getMessage()+' LN: '+ex.getStackTraceString());
        }
    }
    public List < PkgCard > getpkgCards(String cardDets) {
        System.debug('cardDets: ' + cardDets);
        if (String.isNotBlank(cardDets)) {
            PkgCards PkgCards = (PkgCards) JSON.deserialize(cardDets, ParkingM.PkgCards.class);
            System.debug('PkgCards: ' + PkgCards);
            return PkgCards.cardslist;
        }
        else {
            return new List < PkgCard > ();
        }
    }
    /*#########################################
    ## Contact Management Services ##
    #########################################*/
    @future(callout=true) public static void pushConInfo(List<Id> lstIds, String oId, String vatNo) {
        System.debug('<pushConInfo> oId: ' + oId);
        try{
            if (lstIds.size()==0) {
                System.debug('Ids not found !');
                return;
            }
            if (String.isBlank(oId)) {
                System.debug('Blank oracle ID !');
                return;
            }
            System.debug('lstIds : ' + lstIds);
            List<coninfo__c> lstConInfo = [SELECT Id, rol__c, name__c, ldno__c, Sta__c, email__c, phone__c, seml__c, sphn__c, conid__c, acc__r.van__c, CcrmRole__c FROM coninfo__c WHERE id=:lstIds];
            ConDetails conDetails = new ConDetails();
            conDetails.conDtls = new List<ConInfo>();
            conDetails.orcId = oId;
            conDetails.vatno = String.isNotBlank(vatNo) ? vatNo:lstConInfo[0].acc__r.van__c;
            System.debug('##lstConInfo : ' + lstConInfo);
            for (Coninfo__c ci : lstConInfo) {
                ConInfo conInfo =     new ConInfo();
                conInfo.role     =   ci.CcrmRole__c;
                conInfo.AXS_sfid    =   ci.Id;
                conInfo.name     =   ci.name__c;
                conInfo.TECOM_sfid  = ci.conid__c;
                conInfo.landln   =   ci.ldno__c;
                conInfo.cpstatus    = ci.sta__c;
                conInfo.pEml   =   ci.email__c;
                conInfo.pMob    =   ci.phone__c;
                conInfo.sEml   =   (ci.seml__c != null) ? ci.seml__c : '';
                conInfo.sMob  =   (ci.sphn__c != null) ? ci.sphn__c : '';
                conDetails.conDtls.add(conInfo);
            }
            String strConDetls = JSON.serialize(conDetails);
            System.debug('strConDetls : ' + strConDetls);
            soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            String resp = tps.pushContacts(strConDetls);
            PushResponse pushResponse = (PushResponse)JSON.deserialize(resp, ParkingM.PushResponse.class);
            System.debug('<pushContacts> : ' + pushResponse);
        }catch (Exception ex) {
            System.debug(' ##Exception : ' + ex.getMessage()+' '+ ex.getStackTraceString());
        }
    }
    public List<coninfo__c> getConInfo(String orclID) {
        List<coninfo__c> lstConInfo = new List<coninfo__c>();
        System.debug('<getConInfo> orclID: ' + orclID);
        try{
            soapNrtaActivation.Tecom_Parking_SOAP_WS tps = ParkingSession.setParkingSessionId();
            String resp = tps.fetchContacts(orclID);
            System.debug('getConInfo <resp>' + resp);
            ConDetails conDetails = (ConDetails)JSON.deserialize(resp, ParkingM.ConDetails.class);
            System.debug('getConInfo <conDetails>' + conDetails);
            if (conDetails.conDtls == null) {
                return lstConInfo;
            }
            for (ConInfo ci : conDetails.conDtls) {
                coninfo__c conInfo   =   new coninfo__c();
                conInfo.rol__c        =   ci.role;
                conInfo.name__c     =   ci.name;
                conInfo.ldno__c    =   ci.landln;
                conInfo.email__c    =   ci.pEml;
                conInfo.seml__c    =   ci.sEml;
                conInfo.id          =   ci.AXS_sfid;
                conInfo.phone__c   =   ci.pMob;
                conInfo.conid__c    =   ci.TECOM_sfid;
                conInfo.sphn__c  =   ci.sMob;
                conInfo.sta__c      =   ci.cpstatus;
                lstConInfo.add(conInfo);
            }
        }
        catch (Exception ex) {
            System.debug(' #Exception: ' + ex.getMessage()+' '+ ex.getStackTraceString());
        }
        return lstConInfo;
    }
    /*###########################
    ### WrapperClasses ###
    ###########################*/
    public class ParkingDetail implements Comparable {
        public String  sector       {get;set;}
        public String  cardNum      {get;set;}
        public Boolean  sel             {get;set;}
        public String  cardId       {get;set;}
        public String   sPlaceOfReg     {get;set;}
        public String  BusinessPark {get;set;}
        public String   vType           {get;set;}
        public String  actStat      {get;set;}
        public String   vehicleNumber   {get;set;}
        public String  vDetails     {get;set;}
        public String   secVclNum       {get;set;}
         public String   cHolderNm       {
            public get{
                if (cHolderNm != null) {
                return cHolderNm.replaceAll('\'', '');
                }else {return cHolderNm;}
                }
            public set;

        }

        public String   status          {get;set;}
        public String  cardType     {get;set;}
        public String   pPlaceOfReg     {get;set;}
        public String  refMobile     {get;set;}
        public String   email     {get;set;}
        public String  expDate      {get;set;}
        public String  isReserved      {get;set;}
        public Integer compareTo(Object compareTo) {
            ParkingDetail ParkingDetail = (ParkingDetail) compareTo;
            if (cardNum == ParkingDetail.cardNum) return 0;
            if (cardNum > ParkingDetail.cardNum) return 1;
            return -1;
        }
        }
        public class PkgCard_old {
            public String cardNo    {
                get;
                set;
            }
            public String sector    {
                get;
                set;
            }
            public String expDate   {
                get;
                set;
            }
            public String cnum      {
                get;
                set;
            }
            public String stDate    {
                get;
                set;
            }
            public String chname    {
                get;
                set;
            }
            public String sfcid     {
                get;
                set;
            }
            public String cardexpDate {
                get;
                set;
            }
        }
        public class PkgCard{
            public String ParkingCardId {
                get;
                set;
            }
            public String CardNumber {
                get;
                set;
            }
            public String CardHolderName{
                get;
                set;
            }
            public String SectorName{
                get;
                set;
            }
            public String CardExpireDate{
                get;
                set;
            }
            public boolean isSelected {
                get;
                set;
            }
            public boolean isPaid {
                get;
                set;
            }
        }
        public class AddPark {
            public String noOfAO    {
                get;
                set;
            }
            public String noOfAUtl  {
                get;
                set;
            }
            public String sector    {
                get;
                set;
            }
            public String elg       {
                get;
                set;
            }
            public String cardId    {
                get;
                set;
            }
            public String utl       {
                get;
                set;
            }
            public String cntrNo    {
                get;
                set;
            }
            public String aprvd     {
                get;
                set;
            }
            public String cntrExp   {
                get;
                set;
            }
            public String uprc      {
                get;
                set;
            }
            public String cardType  {
                get;
                set;
            }
            public Boolean sel      {
                get;
                set;
            }
            public String noOfDays  {
                get;
                set;
            }
            public String add       {
                get;
                set;
            }
        }
        public class AddtnlPark {
            public String Sequence {
                get;
                set;
            }
            public String LocationName {
                get;
                set;
            }
            public String LocaionId {
                get;
                set;
            }
            public String isDefault {
                get;
                set;
            }
            public String AgNumber {
                get;
                set;
            }
            public String LeaseExp {
                get;
                set;
            }
            public String RemainingPaidEligible {get;set;}/*VMKR_06032026 - Added to capture RemainingPaidEligible*/
            public String PaidStandardEligibility {get;set;}
            public String NewEligibility {get;set;}
            public String PaidEligibility {get;set;}
            public String PaidStandardPrice {get;set;}
            public String SectorID {get;set;}
            public String EligibilityID{get;set;}

        }
    /*ToDo: merge wrapper classes*/
    public class CCRMResponse{
        public String Status, Message, AXSID;
        public list<vehicleWrapper> vehicleList;
    }
    public class vehicleWrapper{
        public string vehicleSequence, vehicleId;
    }
    public class ParkSettings   { public List<CardDeatils> Settings;}
    public Class PushResponse   { public String ErrorCode, ErrorMessage; Decimal amountPerSlot;}
    public class Vehicle        { public String vtype, vno, brand, model, platecolor, vechcolor, placeofreg, vid;}
    public class CardDeatils    { public String id, cardno, status, cluster, zone, cHolderNm, refMobile, email, cardType, expDate, isReserved; public List<Vehicle> vehicledetails;}
    public class AdditionalEli  { public List<EliDetails> addiEligis;} /* wrapper for additional parking */
    public class EliDetails     { public String secName; public List<OppoElis> oppos;}
    public class OppoElis       { public String agNo, conExpDate, noOfDays, add, cardType; public Decimal addiEli;}
    public class PkgCards       { public List<PkgCard> cardslist; }
    public class ElgDtls        {
        public string ErrorMessage, ErrorCode;
        public Integer TotalEligibility=0, tUtlzd=0, tStdElgb=0, tAddElgb=0, tfreeAc=0, tfreeIn=0, freeUtlzd=0, paidUtlzd=0, tpaidIn=0, tPaidAc=0, tPaidElgb=0, enrld=0, rsrvd=0;
    }
    public class ConDetails     { public String orcId, ErrorCode, vatno; public List<conInfo> conDtls; }
    public class ConInfo        { public String role, name, pMob, sMob, pEml, sEml, landln, TECOM_sfid, AXS_sfid, cpstatus; }
    /*VMKR*/
    public class Vehicle1        { public String status, sequence, pltNum_RC, RegDate_RC, por_RC, VehType_RC, VehModel_RC;}
    Public class ActCard         { public String cardHolderName, refMobile, email, landlineNo, sector, cardNo; public List<Vehicle1> items{get;set;}}
    public class ParkingDetails_m{ /* added for new parking */
        public String  sector       {get;set;}
        public String  sectorlocationname       {get;set;}
        public String EligibilityName{get;set;}
        public String  sectorId       {get;set;}
        public String  cardNum      {get;set;}
        public Boolean  sel             {get;set;}
        public String  cardId       {get;set;}
        public String   sPlaceOfReg     {get;set;}
        public String  BusinessPark {get;set;}
        public String   vType           {get;set;}
        public String  actStat      {get;set;}
        public String   vehicleNumber   {get;set;}
        public List <WsParking.Vehicle>  vDetails     {get;set;}
        public String   secVclNum       {get;set;}
        public String   cHolderNm       {
            public get{
                if (cHolderNm != null) {
                return cHolderNm.replaceAll('\'', '');
                }else {return cHolderNm;}
                }
            public set;

        }
        public String   status          {get;set;}
        public String  cardType     {get;set;}
        public String   pPlaceOfReg     {get;set;}
        public String  refMobile     {get;set;}
        public String   email     {get;set;}
        public String  expDate      {get;set;}
        public String  isReserved      {get;set;}
    }
    /*public class parseResponse  { public String id, access_token;}
    public class ParseResp      { public Boolean success;public String ResponseCode, ObjectID, Error;}
    public class AddPrkgRq      { public string reqNumber, reqSlots, totalAmount, agrNumber, agrExp, sector, refMobile, corpEmail;}*/
}
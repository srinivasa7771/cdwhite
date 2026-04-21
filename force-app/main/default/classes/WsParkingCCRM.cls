@RestResource(urlMapping='/parkingservices/*')
global class WsParkingCCRM {

    @HttpPost
    global static void parkingservices() {

        //{"methodName":"updateAmount", "axsReqId":"114212020211103", "noOfSlots":"2", "reqStatus":"", "totalAmount":null}
        //{"methodName":"updateStatus", "axsReqId":"114212020211103", "reqStatus":"Verification"}
        //{"methodName":"parkingRenewal", "axsReqId":"114035320210530", "reqStatus":"", "agreement":{"axid":132322, "totalslots":5, "totalAmt":"2000.00", "stDate":null, "sector":null, "orclId":"29258", "expDate":null, "agNo":"AG-060612", "cardslist":[{"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder1", "cardexpDate":"2017-12-10"}, {"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder2", "cardexpDate":"2017-12-10"}]}}

        System.debug('reqBody : ' + RestContext.request.requestBody.toString());
        ParkingResp resp = new ParkingResp();
        RestContext.response.addHeader('Content-Type', 'application/json');

        try{

            parkingReq pr = (parkingReq)JSON.deserialize(RestContext.request.requestBody.toString(), parkingReq.class);
            System.debug('parkingReq : ' + pr);

            if (String.isBlank(pr.methodName)) {
                resp.respCode = 'VE_01';
                resp.respMsg = '#ValidationError, methodName cannot be blank.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            if (pr.methodName.equalsIgnoreCase('parkingrenewal')) {
                resp = createparkingrequest(pr.agreement, '');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            if (pr.methodName.equalsIgnoreCase('vipparkingrequest')) {
                resp = createparkingrequest(pr.agreement, 'VIP');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            if (String.isBlank(pr.axsReqId)) {
                resp.respCode = 'VE_01';
                resp.respMsg = '#ValidationError, axs request Id cannot be blank.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            // logic to update the request with amount and numberOfSlots
            // **********update the request
            List<g_reqItem__c> lstReqItms = [SELECT Id, xcpnc__c, scn__c, vsc__c, Rq__c, sta__c,
                itm__r.cd__c, Name, xr__c, xcdocs__c, xcnotes__c, Time_stamp__c, rq__r.srvc__c, rq__r.srvc__r.UID__c,
                rq__r.Name, AP__c From g_reqitem__c WHERE RQ__r.Name=:pr.axsReqId];
            system.debug('lstReqItms -- '+lstReqItms);
            if (lstReqItms == null || lstReqItms.size()==0) {
                resp.respCode = 'DE_01';
                resp.respMsg = '#DataError, request [' + pr.axsReqId + '] not found.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            if (pr.methodName.equalsIgnoreCase('updatestatus')) {

                if (pr.reqStatus=='Approved') {
                    if (String.isBlank(pr.noOfSlots) || pr.noOfSlots=='null' || pr.noOfSlots=='0') {
                        resp.respCode = 'VE_04';
                        resp.respMsg = '#ValidationError, Please provide value for Slots.';
                        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                        return;
                    }
                    //lstReqItms[0].scn__c = pr.totalAmount;
                    if (lstReqItms[0].AP__c == 0 && lstReqItms[0].itm__r.cd__c!='snp' && lstReqItms[0].itm__r.cd__c!='enp') {
                    Decimal price = (Integer.valueOf(pr.noOfSlots)* pr.totalAmount);
                    lstReqItms[0].scn__c = price;
                    lstReqItms[0].vsc__c = price*0.05;
                    lstReqItms[0].xcpnc__c = pr.noOfSlots;
                    }

                }else if (pr.reqStatus=='Refund Generated') {
                    if (pr.totalAmount == null) {
                        resp.respCode = 'VE_02';
                        resp.respMsg = '#ValidationError, amount cannot be zero.';
                        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                        return;
                    }
                    //lstReqItms[0].scn__c = pr.totalAmount;
                    Decimal price = Integer.valueOf(pr.totalAmount);
                    lstReqItms[0].scn__c = price;
                }

                if (String.isNotBlank(pr.reqStatus)) {
                    Map<String, String> mapStatusbyCode = new Map<String, String>();
                    List<g_srvcitm_Status__c> lstStatus = new List<g_srvcitm_Status__c>();

                    if (lstReqItms != null && lstReqItms.size()>0) {
                        lstStatus = [SELECT Id, Name, rqSTA__c, itm__r.cd__c, itm__c, itm__r.name FROM g_srvcitm_Status__c WHERE itm__r.srvc__c= :lstReqItms[0].rq__r.srvc__c];
                        if (lstStatus.size() > 0) {
                            for (g_srvcitm_Status__c st : lstStatus) {
                                mapStatusbyCode.put(st.Name + st.itm__r.name+st.itm__r.cd__c, St.id);
                            }
                        }
                        system.debug('lstReqItms -- '+lstReqItms);
                        for (g_reqitem__c itm : lstReqItms) {
                            system.debug('pr.reqStatuspr.reqStatuspr.reqStatus');
                            system.debug('pr.reqStatus--'+pr.reqStatus);
                            system.debug('itm.Name--'+itm.Name);
                            system.debug('itm.itm__r.cd__c--'+itm.itm__r.cd__c);
                            itm.sta__c = mapStatusbyCode.get(pr.reqStatus+itm.Name+itm.itm__r.cd__c);
                            itm.xcnotes__c =  pr.rejectionReason;
                            system.debug('itm.sta__c--'+itm.sta__c);
                        }

                    }
                }

                system.debug('lstReqItms[0]c--'+lstReqItms[0].sta__c);
                update lstReqItms[0];

                if (pr.reqStatus=='Rejected' || pr.reqStatus=='Cancelled') {
                    g_Req__c r=new g_Req__c(id=lstReqItms[0].RQ__c, Sta__c=pr.reqStatus);
                    if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                        update r;
                    }
                }
                else if (String.isNotBlank(lstReqItms[0].xcpnc__c) && lstReqItms[0].xcpnc__c!='0') {
                    g_Req__c r=new g_Req__c(id=lstReqItms[0].RQ__c, slaN__c=Integer.valueOf(lstReqItms[0].xcpnc__c), Sta__c='Under Review');
                    if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                        update r;
                    }
                }
                else if (pr.reqStatus=='Refund Generated') {
                    g_Req__c r=new g_Req__c(id=lstReqItms[0].RQ__c, Sta__c='Completed');
                    if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                        update r;
                    }
                }
                resp.respCode  = '0';
                resp.respMsg     = 'Amount AED '+pr.totalAmount+' updated successfully for Request# ' + pr.axsReqId;
                resp.axsReqId = pr.axsReqId;

            }

        }catch (JSONException je) {
            resp.respCode='EXC_02'; resp.respMsg='Invalid JSON String.';
            system.debug(je.getMessage()+ ' ' +je.getStackTraceString());
        } catch (Exception e) {
            resp.respCode='EXC_01'; resp.respMsg='#Error : ' + e.getMessage();
            system.debug('#EXCEPTION: '+e.getMessage() + ' #StackTrace: ' +e.getStackTraceString());
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    public static ParkingResp updateSta(List<g_reqitem__c> lstReqItms, String toStatus) {
        ParkingResp resp = new ParkingResp();
        Map<String, String> mapStatusbyCode = new Map<String, String>();
        List<g_srvcitm_Status__c> lstStatus = new List<g_srvcitm_Status__c>();

        //List<g_reqitem__c> lstReqItems = [SELECT Id, sta__c, itm__r.cd__c, Name, xr__c, xcdocs__c, xcnotes__c, Time_stamp__c, rq__r.srvc__c From g_reqitem__c WHERE RQ__r.Name=:pr.axsReqId];

        if (lstReqItms != null && lstReqItms.size()>0) {
            lstStatus = [SELECT Id, Name, rqSTA__c, itm__r.cd__c, itm__c, itm__r.name FROM g_srvcitm_Status__c WHERE itm__r.srvc__c= :lstReqItms[0].rq__r.srvc__c];

            if (lstStatus == null || lstStatus.size()==0) {
                resp.respCode   = '1';
                resp.respMsg    = 'Status- '+toStatus+' not found in axs.';
                return resp;
            }

            if (lstStatus.size() > 0) {
                for (g_srvcitm_Status__c st : lstStatus) {
                    System.debug('st.Name ' + st.Name +' + st.itm__r.name : '+ st.itm__r.name);
                    mapStatusbyCode.put(st.Name + st.itm__r.name+st.itm__r.cd__c, St.id);
                }
            }

            for (g_reqitem__c itm : lstReqItms) {
                System.debug('mapStatusbyCode : ' + mapStatusbyCode + 'toStatus+itm.Name ;' +toStatus+itm.Name);
                system.debug('itm.sta__c -- '+itm.sta__c);
                itm.sta__c = mapStatusbyCode.get(toStatus+itm.Name+itm.itm__r.cd__c);
            }

            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update lstReqItms;
            }
        }

        resp.respCode   = '0';
        resp.respMsg    = 'Status updated successfully for Request# ' + lstReqItms[0].rq__r.name;
        resp.axsReqId =  lstReqItms[0].rq__r.name;

        return resp;
    }

    Public static ParkingResp createparkingrequest(agreement agr, string servicetype) {
        String cardList;
        ParkingResp resp = new ParkingResp();
        // rqMap=new Map<String, g_req__c>();

        List<Account> lstAcc = [SELECT Id, Name, ORACLE_PARTY_ID__c From Account WHERE ORACLE_PARTY_ID__c=:agr.oraclePartyId];
        if (lstAcc == null || lstAcc.size()==0) {
            resp.respCode   = '1';
            resp.respMsg    = 'Account with Oracle Id ' +  agr.oraclePartyId + ' not found in axs.';
            return resp;
        }

        if (agr.parkingCards != null && !agr.parkingCards.isEmpty()) {
        List<RenCard> lstCards = new List<RenCard>();
        for (RenCard card : agr.parkingCards) {
            RenCard r = new RenCard();
            r.SectorName = agr.SectorName;
                card.isSelected = true;
                card.isPaid = false;
            lstCards.add(card);
        }
            cardList = '{"cardslist":' + JSON.serialize(lstCards) + '}';
        }

        System.debug(cardlist);
        g_req__c req = new g_req__c();
        System.debug('agr.reqid : ' + agr.reqid);
        if (String.isNotBlank(agr.reqid)) {req.Id=agr.reqid;}

        Decimal finalAmount = Decimal.valueOf(agr.totalAmount)*(Decimal.valueOf(agr.totalslots));

        req.ias__c = servicetype == 'VIP' ? 'vip' : '0np';
        req.xadh__c = servicetype == 'VIP' ? 'vip;' : '0np;';
        req.srvc__c = servicetype == 'VIP' ? gu.csStr('srvc_vipParking') : gu.csStr('srvc_pRenewal');
        req.STA__c = 'Draft';
        req.xtcid__c = agr.oraclePartyId;
        req.xps__c = agr.SectorName;
        req.xrap__c = Decimal.valueOf(agr.totalslots);
        req.xtpa__c = finalAmount;
        //req.xrepd__c = finalAmount;
        req.xcmta__c=  finalAmount;
        req.xrpid__c = (agr.endDate != null) ? Date.valueOf(agr.endDate):null;
        req.xss__c = Decimal.valueOf(agr.totalslots);
        req.xanum__c = agr.agNo;
        req.xaed__c = (agr.endDate != null) ? Date.valueOf(agr.endDate):null;
        req.xfpc__c = (agr.startDate != null) ? Date.valueOf(agr.startDate):null;
        req.xuvdet__c = cardList != null ? cardList : '';
        req.xceml__c = agr.email;
        req.xoln__c = agr.phone;
        req.xcmob__c = agr.mobile;

        if (String.isNotBlank(agr.axsReqId) && agr.axsReqId.trim().length()>0) {
         List<g_req__c> rqlst = [Select id, name from g_req__c where name=:agr.axsReqId];
            if (rqlst != null && rqlst.size()>0) {req.id=rqlst[0].id;}
        }

        req.Acc__c = lstAcc[0].id;

        try{
            if (Schema.sObjectType.g_req__c.isCreateable()) {
                upsert req;
            }
            g_req__c rq = [SELECT id, name from g_req__c where id=:req.id];
            resp.respCode   = '0';
            resp.respMsg    = 'Parking request # ' +rq.name + ' has been inserted successfully' ;
            resp.axsReqId =  rq.name;
            return resp;
        }catch (Exception e) {
            system.debug('#EXCEPTION: '+e.getMessage() + ' #StackTrace: ' +e.getStackTraceString());
            resp.respCode   = '1';
            resp.respMsg    = 'Error while inserting the parking request';
            return resp;
        }

    }

    //#######################################################################################################################################
    //##### WRAPPER CLASSES ####
    //#######################################################################################################################################
    global class parkingReq {
        Public String methodName, axsReqId, noOfSlots, reqStatus, rejectionReason;
        Public Decimal totalAmount;
        Public Agreement agreement;
        Public PkgCard cardList;
    }

    global class ParkingResp {
        Public String respCode, respMsg, axsReqId;
    }

    global class ParkingRenewal {public Agreement agreement;}
    //global class Agreement { public String totalslots, reqid, totalAmt, stDate, sector, orclId, expDate, startDate, agNo, axsid, axsReqId, phone, mobile, email;public List<PkgCard> cardslist;}
    global class Agreement {
        public String agNo, totalslots, totalAmount, startDate, endDate, oraclePartyId, SectorName, SectorLocationId, sector, sectorId, reqid, axsid, axsReqId, phone, mobile, email;
        public List<RenCard> parkingCards;
    }
    public class PkgCard { public String totalslots, totalAmt, startDate, SectorLocationId, sectorId, oraclePartyId, endDate, agNo;public List<RenCard> cardslist; }
    public class RenCard { public String ParkingCardId, CardNumber, CardHolderName, SectorName, CardExpireDate; boolean isSelected; boolean isPaid;}

    //Single agreement
    //{"methodName":"parkingRenewal", "axsReqId":"114035320210530", "reqStatus":"", "agreement":{"axid":132322, "totalslots":5, "totalAmt":"2000.00", "stDate":null, "sector":null, "orclId":"29258", "expDate":null, "agNo":"AG-060612", "cardslist":[{"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder1", "cardexpDate":"2017-12-10"}, {"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder2", "cardexpDate":"2017-12-10"}]}}

    //list Agreements
    //{"methodName":"parkingRenewal", "axsReqId":"114035320210530", "reqStatus":"", "parkingRenewal":{"agreements":[{"axid":132322, "totalslots":5, "totalAmt":"2000.00", "stDate":null, "sector":null, "orclId":"29258", "expDate":null, "agNo":"AG-060612", "cardslist":[{"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder1", "cardexpDate":"2017-12-10"}, {"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder2", "cardexpDate":"2017-12-10"}]}]}}
}
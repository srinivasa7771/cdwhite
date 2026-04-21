public class OnboardQueueable implements Queueable,Database.AllowsCallouts {
    public Id recId ;
    public String reqJson;
    public String calltype;
    public List<Id> recIdLst ;
    public string reqId;
    public list < Ws_Call__c > lstwscall1;
    public OnboardQueueable(String calltype, String reqJson, String reqId) {
        this.calltype = calltype;
        this.reqJson = reqJson;
        this.reqId = reqId;
    }



    public OnboardQueueable(String calltype, Id recId){this.calltype = calltype;this.recId = recId;}
    public OnboardQueueable(String calltype, List<Id> recIdLst){this.calltype = calltype;this.recIdLst = recIdLst;}
    public OnboardQueueable(String calltype, Id reqId, Id recId,string reqJson) {
        this.calltype = calltype;
        this.reqId = reqId;
        this.recId = recId;
    }
    public OnboardQueueable(String calltype, list<Ws_Call__c> lstwscall1) {
        this.calltype = calltype;
        this.lstwscall1 = lstwscall1;
    }

    public void execute(QueueableContext context)
    {
        system.debug('calltype'+calltype);
        try{
             if (calltype=='fetchAccInfo'){list<ws_call__c> wslist=[select id from ws_call__c where intsts__c = 'Ready for Integration' and ws_typ__c = 'Onboarding' and mtd_nm__c = 'fetchAccInfo' and  LastModifiedDate=today order by createddate desc]; /* //if (wslist.size()==0){ ws_call__c wc = new ws_call__c(); wc.pmid__c = reqId; wc.ws_typ__c = 'Onboarding'; wc.mtd_nm__c = 'fetchAccInfo'; wc.intsts__c = 'Ready for Integration'; insert wc; // }*/ recId = wslist != null?wslist[0].Id: null ; system.debug('infetchAcc=1='+recId);}

            if (calltype=='uploadDoc'){DccaBatchUtil.processDocAmdBatch(recIdLst);  }
            if (calltype == 'sendDocCCRM') {
                //FitOutWebservice.sendDocs(reqId, recId);
            }
            if (calltype=='laCreationQ'){grqWsOnboard.LAWSCallCreation(reqId);  }
            if (calltype=='uploadAMDDoc'){DccaBatchUtil.excLADDADocBatch(recIdLst);  }//
            if (calltype=='laStatusUpdate'){DccaBatchUtil.updateAXSStatusLA(recIdLst);  }
            else if (calltype=='uploadDDADoc'){ List < ws_call__c > wslst = [Select Id, DDA_id__c, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.STA__r.exsyst__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Acc__r.id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xdmpn__c, rq_itm__r.RQ__r.xmloc__c from ws_call__c where id =: recIdLst and (ws_typ__c = 'DCCA License Renewals' OR ws_typ__c = 'DCCA Letters') AND intsts__c = 'Ready for Integration' AND(mtd_nm__c = 'LicenseRenewalCopy' OR mtd_nm__c = 'LicenseRenewalDoc' OR mtd_nm__c = 'auditFormDocs' OR mtd_nm__c = 'membersDocs') ];DccaBatchUtil.processDocBatch(wslst);  }
            else if (calltype=='UpdatePMSInfo'){ctrlPMSupdateinfo.upsertContractInfo(recIdLst);}
            else if (calltype=='courierBooking'){DccaBatchUtil.exchcbkBatch(recIdLst);  }
            else if (calltype=='courierBooking'){DccaBatchUtil.exchcbkBatch(recIdLst);  }
            else if (calltype=='courierStsUpdate'){DccaBatchUtil.exchcbStsBatch(recIdLst);  }
            /*else if (calltype=='cancelaccount'){ grqWsOnboard.cancelAccount(reqJson);} */
            /*else if (calltype == 'parking') { system.debug('calltype-1' + calltype); g_req__c rq = [select id, Name, srvc__r.UID__c, xcmta__c, xispd__c, xrped__c, Ap__c, AT__c, xtpa__c, xadtx4__c, xrpid__c from g_req__c where Name =: reqId]; String cards = ''; String edt = ''; if (rq.xadtx4__c != null) { Map < String, object > rqObj = (Map < String, object > ) JSON.deserializeUntyped(rq.xadtx4__c); cards = (String) rqObj.get('Cardlist'); } String reqJson; If(rq.srvc__r.UID__c == gu.csStr('AdditionalParking')) { reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","Amount":"' + rq.AT__c + '"}'; } If(rq.srvc__r.UID__c == gu.csStr('ParkingRenewal')) { reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","isAllCardsPaid":"' + String.ValueOf(rq.xispd__c) + '","Cardlist":"' + cards + '","ExpireDate":"' + String.ValueOf(rq.xrped__c != null ? rq.xrped__c : rq.xrpid__c) + '","Amount":"' + rq.xtpa__c + '"}'; } If(rq.srvc__r.UID__c == gu.csStr('ParkingLostCard')) { if (rq.xadtx4__c != null) { Map < String, object > rqObj = (Map < String, object > ) JSON.deserializeUntyped(rq.xadtx4__c); cards = (String) rqObj.get('CardNumber'); edt = (String) rqObj.get('EndDate'); } reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","isAllCardsPaid":"true","Cardlist":"' + cards + '","ExpireDate":"' + edt + '","Amount":"' + rq.AP__c + '"}'; } If(rq.srvc__r.UID__c == gu.csStr('VIPParking')) { reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","Cardlist":"' + cards + '","ExpireDate":"' + String.ValueOf(rq.xrpid__c) + '","Amount":"' + rq.xtpa__c + '"}'; } String resBody = WsParking.callParkingWs(reqJson); ParkingRenewalResponse resData = (ParkingRenewalResponse) JSON.deserialize(resBody, ParkingRenewalResponse.class); List < ws_call__c > wslst = [Select Id, xrno__c, rq_jsn__c, res_jsn__c, intsts__c from ws_call__c where xrno__c =: reqId and intsts__c = 'Ready for Integration']; system.debug('wslst --- ' + wslst); if (wslst != null && wslst.size() > 0) { system.debug('wslst[0] --- ' + wslst[0]); wslst[0].res_jsn__c = resBody; wslst[0].rq_jsn__c = reqJson; if (resData != null && resData.Status == 'Success') { wslst[0].intsts__c = 'Success'; } else { wslst[0].intsts__c = 'Failed'; } update wslst; } if (reqId.contains(';')) { String srvCd = reqId.split(';')[1]; system.debug('calltype-srvCd' + srvCd); if (srvCd == gu.csStr('ParkingActivation')) system.enqueueJob(new gctlPrk(reqId.split(';')[0])); } }*/
            else if (calltype == 'parking') { system.debug('calltype-1' + calltype); system.debug('reqId -- ' + reqId); g_req__c rq = [select id, Name, srvc__r.UID__c, xcmta__c, xispd__c, xrped__c, Ap__c, AT__c, xtpa__c, xadtx4__c, xrpid__c from g_req__c where Name = : reqId]; String cards = ''; String edt = ''; if (rq.xadtx4__c != null) { Map < String, object > rqObj = (Map < String, object > ) JSON.deserializeUntyped(rq.xadtx4__c); cards = (String) rqObj.get('Cardlist'); } /*String reqJson;*/ If(rq.srvc__r.UID__c == gu.csStr('AdditionalParking')&&rq.ap__c>0) { reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","Amount":"' + rq.AT__c + '"}'; } If(rq.srvc__r.UID__c == gu.csStr('ParkingRenewal')) { reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","isAllCardsPaid":"' + String.ValueOf(rq.xispd__c) + '","Cardlist":"' + cards + '","ExpireDate":"' + String.ValueOf(rq.xrped__c != null ? rq.xrped__c : rq.xrpid__c) + '","Amount":"' + rq.xtpa__c + '"}'; } If(rq.srvc__r.UID__c == gu.csStr('ParkingLostCard')&&rq.ap__c>0) { if (rq.xadtx4__c != null) { Map < String, object > rqObj = (Map < String, object > ) JSON.deserializeUntyped(rq.xadtx4__c); cards = (String) rqObj.get('CardNumber'); edt = (String) rqObj.get('EndDate'); } reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","isAllCardsPaid":"true","Cardlist":"' + cards + '","ExpireDate":"' + edt + '","Amount":"' + rq.AP__c + '"}'; } If(rq.srvc__r.UID__c == gu.csStr('VIPParking')) { reqJson = '{"ActionName":"updatepaymentstatus","AXSId":"' + rq.name + '","Cardlist":"' + cards + '","ExpireDate":"' + String.ValueOf(rq.xrpid__c) + '","Amount":"' + rq.xtpa__c + '"}'; } String resBody = WsParking.callParkingWs(reqJson); system.debug('resBody -- '+resBody); ParkingRenewalResponse resData = (ParkingRenewalResponse) JSON.deserialize(resBody, ParkingRenewalResponse.class); List < ws_call__c > wslst = [Select Id, xrno__c, rq_jsn__c, res_jsn__c, intsts__c from ws_call__c where xrno__c = : reqId and intsts__c = 'Ready for Integration']; system.debug('wslst --- ' + wslst); if (wslst != null && wslst.size() > 0) { system.debug('wslst[0] --- ' + wslst[0]); wslst[0].res_jsn__c = resBody; wslst[0].rq_jsn__c = reqJson; if (resData != null && resData.Status == 'Success') { wslst[0].intsts__c = 'Success'; } else { wslst[0].intsts__c = 'Failed'; } update wslst; } if (reqId.contains(';')) { String srvCd = reqId.split(';')[1]; system.debug('calltype-srvCd' + srvCd); if (srvCd == gu.csStr('ParkingActivation')) system.enqueueJob(new gctlPrk(reqId.split(';')[0])); } }
            if (calltype == 'revokeUserAccess') { List<Id> recordId = (recIdLst != null && !recIdLst.isEmpty())? recIdLst : string.isNotBlank(recId) ? new list<Id>{recid} : new list<Id>(); if (recordId != null &&  !recordId.isEmpty()){ grqWsOnboard.updateUsrAccess(recordId); } }
            else if (calltype == 'fetchAccInfo')
            {   system.debug('infetchAcc=2='); List < ws_call__c > wslst = [Select Id, rq_itm__r.rq__r.xdei__c, xrno__c, rq_itm__r.rq__r.xdccaRq__c, adhoc_text1__c, rq_itm__r.RQ__r.xuvdet__c, rq_itm__r.RQ__r.xcfn__c, rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.xbtnm__c, rq_itm__r.RQ__r.xcpic__c, rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, err_msg__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.srvc__r.uid__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xcn__c, rq_itm__r.ccrmid__c, rq_itm__r.sta__c, rq_itm__r.itm__r.cd__c, rq_itm__r.sta__r.cd__c, pmid__c, mtd_nm__c, intsts__c from ws_call__c where id =: recId]; new BatchOnboardFetchAccInfo().fetchAccInfo(wslst[0]); } else if (calltype == 'updateAccInfo') { List < ws_call__c > wslst = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id =: recId]; new BatchOnboardInfoUpdate().updateAccInfo(wslst[0]); }
            else if (calltype == 'ddaInvUpdate') { List < ws_call__c > wslst = [Select Id, rq_itm__r.RQ__r.xmamd__c, DDA_id__c, DDA_Amt__c, err_cd__c, xrno__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where id =: recIdLst]; DccaBatchUtil.processInvFineBatch(wslst); }
            else if (calltype == 'fetchAccInfo') { List < ws_call__c > wslst = [Select Id, rq_itm__r.rq__r.xdei__c, xrno__c, rq_itm__r.rq__r.xdccaRq__c, adhoc_text1__c, rq_itm__r.RQ__r.xuvdet__c, rq_itm__r.RQ__r.xcfn__c, rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.xbtnm__c, rq_itm__r.RQ__r.xcpic__c, rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, err_msg__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.srvc__r.uid__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xcn__c, rq_itm__r.ccrmid__c, rq_itm__r.sta__c, rq_itm__r.itm__r.cd__c, rq_itm__r.sta__r.cd__c, pmid__c, mtd_nm__c, intsts__c from ws_call__c where id =: recId]; new BatchOnboardFetchAccInfo().fetchAccInfo(wslst[0]); } else if (calltype == 'updateAccInfo') { List < ws_call__c > wslst = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id =: recId]; new BatchOnboardInfoUpdate().updateAccInfo(wslst[0]); }
            else if (calltype == 'axesToCCRMDDADocUpload') { List < ws_call__c > wsCallList = [Select Id, rq_jsn__c, pmid__c, adhoc_text1__c from ws_call__c where id in: recIdLst]; if (wsCallList.size() > 0) { DccaBatchUtil.processOICDocUpload(wsCallList); } }
            else if (calltype == 'fitoutCrReq'){List < ws_call__c > wslst = [Select Id, uid__c from ws_call__c where id =: recId and intsts__c = 'Ready for Integration']; FitOutWebservice.sendSR(wslst[0]);}
            else if (calltype == 'fitoutDocUp'){List < ws_call__c > wslst = [Select Id, uid__c,rq_itm__r.ccrmid__c,rq_itm__r.Name,rq_itm__r.RQ__c,rq_itm__c from ws_call__c where id =: recId and intsts__c = 'Ready for Integration']; FitOutWebservice.sendDocs(wslst[0]);}
          else if (calltype == 'ProcessAFee') {grqWsOnboard.updateAppfee(recIdLst[0]);}/*MS 1.1*/
            else if (calltype == 'pushOBCRMDocBatch') { List < ws_call__c > wslst = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id in : recIdLst]; /* BatchOnboardInfoUpdate.processAXSDocBatch(wslst[0]);*/ BatchOnboardInfoUpdate objDocUpdate = new BatchOnboardInfoUpdate(recIdLst); Database.executeBatch(objDocUpdate, 1); }/*MS 1.1*/
            else if (calltype == 'pushFLDocBatch') { list < String > lstWsId = new list < String > (); for (ws_call__c objWs: [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id in: recIdLst]) { lstWsId.add(objWs.Id); } if (lstWsId != null && !lstWsId.isEmpty()) { BatchOnboardFetchAccInfo obj = new BatchOnboardFetchAccInfo(lstWsId); Database.executeBatch(obj, 1); } } else if (calltype == 'CreateCDBGREF') { List < ws_call__c > wsCallList = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id in: recIdLst limit 1]; if (wsCallList != null && !wsCallList.isEmpty()) { gtFussionWs.voidCreateRefund(wsCallList[0].rq_jsn__c, wsCallList[0].rq_itm__r.RQ__c, wsCallList[0]); } }else if (calltype == 'createRefundWsCall') { insert lstwscall1; }
            else if (calltype == 'createLeaseRenewalRequest') { List < ws_call__c > wsCallList = [Select Id, rq_jsn__c,res_jsn__c,intsts__c, pmid__c, adhoc_text1__c,ritmId__c from ws_call__c where id in: recIdLst and intsts__c = 'Ready for Integration']; if (wsCallList.size() > 0) { DccaBatchUtil.createLeaseRenewalRequest(wsCallList[0]); } }

            else if (calltype == 'createHSESumittalRequest') { List < ws_call__c > wslst = [Select Id, uid__c,ws_typ__c,rq_itm__c,rq_jsn__c from ws_call__c where id in: recIdLst and intsts__c = 'Ready for Integration']; if (wslst.size() > 0){ FitOutWebservice.sendSR(wslst[0]); } }

            else if (calltype == 'yardiWetSignatureUpdate') { List < ws_call__c > wslst = [Select Id,rq_jsn__c,res_jsn__c,intsts__c from ws_call__c where id in: recIdLst and intsts__c = 'Ready for Integration']; if (wslst.size() > 0){ gTYardiInvCreation.pushInsurDetailsToYardi(wslst[0].Id); } }

            else if (calltype == 'yardiInsuarceDetailsUpdate') { List < ws_call__c > wslst = [Select Id,rq_jsn__c,res_jsn__c,intsts__c from ws_call__c where id in: recIdLst and intsts__c = 'Ready for Integration']; if (wslst.size() > 0){ for (ws_call__c ws : wslst){ gTYardiInvCreation.pushInsurDetailsToYardi(ws.id); } } }

            if (calltype=='landLeaseAssignment'){ grqWsOnboard.createLandAssignment(recId); }

            if (calltype=='NONSPONIDREN'){ BatchNonSponAutoUpdate.updateNSID(recId); }

            if (calltype=='NONSPONIDCAN'){ BatchNonSponAutoUpdate.updateNSID(recId); }

            if (calltype=='NAME_CHANGE_ASSGINMENT'){DccaBatchUtil.cncAssignmentReq(recIdLst);  }

        }catch (Exception e){system.debug(e.getStackTraceString());}
    }
    public class ParkingRenewalResponse{
        Public List<Vehicle> Vehicles;
        Public String Status;
        Public String Message;
        Public List<String> CardsDetail;
        Public List<String> AccountEligibility;
    }
    public class Vehicle
    {
        public string VehiclName { get; set; }
    }
}
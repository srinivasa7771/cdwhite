global class BatchOnboardInfoUpdate implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable  {
    /*Ms 1.1 start*/
    private List < String > lstOfWaCallID = new List < String > (); //list of ws call id
    public BatchOnboardInfoUpdate() {}public BatchOnboardInfoUpdate(list < Id > wsCallId) {
        lstOfWaCallID = wsCallId;}/*Ms 1.1 ends*/global Database.QueryLocator start(Database.BatchableContext BC) { String query = 'Select Id,rq_jsn__c,res_jsn__c,err_msg__c,ws_typ__c,intsts__c,xrno__c,pmid__c,rq_itm__c,rq_itm__r.RQ__c,mtd_nm__c,rq_itm__r.ccrmid__c,rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c,rq_itm__r.RQ__r.xuvdet__c from ws_call__c where ws_typ__c = \'Onboarding\' AND (mtd_nm__c=\'updateAccInfo\' OR mtd_nm__c=\'uploadDoc1\') AND intsts__c =\'Ready for Integration\''; if (lstOfWaCallID != null && !lstOfWaCallID.isEmpty()) { query += ' and Id IN: lstOfWaCallID'; } return Database.getQueryLocator(query); }

    global void execute(Database.BatchableContext BC, List<ws_call__c> scope) { if (scope[0].mtd_nm__c == 'updateAccInfo'){ updateAccInfo(scope[0]); } if (scope[0].mtd_nm__c == 'uploadDoc1') { processAXSDocBatch(scope[0]); }}public void updateAccInfo(ws_call__c wsCall){ List<ws_call__c> wsToUpdate = new List<ws_call__c>(); try{ String reqBody = wsCall.rq_jsn__c; string rqId = wsCall.rq_itm__r.RQ__c; String rqItemId = wsCall.rq_itm__c; System.debug('reqBody: '+reqBody); Http h = new Http(); HttpRequest request     = new HttpRequest(); HttpResponse response   = new HttpResponse(); request.setHeader('Content-Type','application/json'); request.setHeader('accept','application/json'); /*request.setEndpoint('callout:CCRM_UAT/apexrest/accinfo'); request.setEndpoint('callout:CCRM/apexrest/accinfo');*/ request.setEndpoint('callout:'+Label.CRM_Instance+'/apexrest/accinfo'); request.setTimeout(90000);request.setMethod('POST'); request.setBody(reqBody); response = h.send(request); if (response.getStatusCode()==200) { String respBody = ''; if (response.getBody()!=null){respBody =  response.getBody(); } System.debug('<response.getBody()> : ' + respBody); grqWsOnboard.Records recs = (grqWsOnboard.Records)JSON.deserialize(respBody,grqWsOnboard.Records.class); wsCall.intsts__c = 'Success'; if (recs.isSuccess){ if (recs!=null && recs.members != null && !recs.members.isEmpty()){ uploadDocs(recs,rqId,wsCall); /*ws_call__c wc = new ws_call__c(); wc.rq_jsn__c = respBody; wc.rq_itm__c = wsCall.rq_itm__c; wc.pmid__c = rqId; wc.ws_typ__c = 'Onboarding'; wc.mtd_nm__c = 'uploadDoc'; wc.intsts__c = 'Ready for Integration'; insert wc;*/ if (String.isNotBlank(respBody)){wsCall.res_jsn__c =  respBody;} } }else{ wsCall.intsts__c = 'Failed'; wsCall.err_msg__c =recs.respMsg;  }  }else {wsCall.intsts__c = 'Failed';if (response.getBody()!=null){ wsCall.res_jsn__c =  response.getBody(); } }   } catch (exception ex) { wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString(); wsCall.intsts__c = 'Failed'; System.debug('Exception:: '+ex.getMessage() + ' -- ' + ex.getStackTraceString()); } update wsCall; }public void uploadDocs(grqWsOnboard.Records rec,string rqid, ws_call__c wsCall) { set<Id> setparentId = new set<Id>(); List<ws_call__c> lstWs = new List<ws_call__c>(); if (rec.members != null && !rec.members.isEmpty()) { Map<string,string> mbmp = new Map<string,string>(); Map<string,string> rqDocMp = new Map<string,string>(); Map < string, string > mapConIdMem = new Map < string, string > (); /*MS 1.1*/ String gmP = ''; system.debug('rec.members::'+rec.members); Map < String, grqWsOnboard.Member > mapPassPort = new Map < String, grqWsOnboard.Member > (); /*MS 1.1*/ Set < String > setMemCode = new Set < String > ();/*MS 1.1*/ for (grqWsOnboard.Member m : rec.members){ mbmp.put(m.ctgCode,m.conid); if (m.ctgCode == 'gm') gmP = m.passportNo; /*MS 1.1*/ if (String.isNotBlank(m.passportNo) && String.isNotBlank(m.conid)) { mapPassPort.put(m.passportNo, m); mapConIdMem.put(m.conid, m.fname + ' ' + m.lname); setMemCode.add(m.ctgCode); } } if (String.isNotBlank(rec.proposedLegalForm) && rec.proposedLegalForm == 'Freelancer'){ for (grqWsOnboard.WorkOrderInfo wo : rec.workorders){ String ctgCd = ''; if (wo.recType == 'Brand Approval') ctgCd = 'br'; if (wo.recType == 'Security Clearance') ctgCd = 'se'; if (wo.recType == 'License Registration Request') ctgCd = 'frl'; mbmp.put(ctgCd,wo.recid); } } else { mbmp.put('dr',''); } List<g_reqitem__c> riLst = new List<g_reqitem__c>(); List<g_req__c> rqLst = new List<g_req__c>(); Map<String,String> getCrmId = new Map<String,String>(); if (String.isNotBlank(rec.prmLastName)){ g_req__c rq = new g_req__c(id=rqid,PRM_Name__c=rec.prmFirstName+' '+rec.prmLastName,PRM_Email__c=rec.prmEmail,PRM_LandlineNo__c=rec.prmPhone,PRM_MobileNo__c=rec.prmMobile); rqLst.add(rq); } for (g_reqitem__c ri : [select id,ccrmid__c,itm__r.cd__c,RQ__c from g_reqitem__c where RQ__c=:rqid and itm__r.cd__c=:mbmp.keyset()]){ system.debug('ri::'+ri.itm__r.cd__c); if (ri.itm__r.cd__c == 'dr' && mbmp != null && mbmp.containsKey('gm')){ ri.xcp__c = gmP; riLst.add(ri); } else if (mbmp != null && !mbmp.isEmpty() && mbmp.containsKey(ri.itm__r.cd__c)){ ri.ccrmid__c = mbmp.get(ri.itm__r.cd__c); riLst.add(ri); } } for (g_reqitemDoc__c doc : [select id,reqDoc__c,reqItm__r.ccrmid__c,reqItm__r.itm__r.cd__c from g_reqitemDoc__c where reqItm__r.RQ__c =:rqid and reqItm__r.itm__r.cd__c =:mbmp.keySet() and Req__c=true and reqAts__c=true and upOk__c=true and rqc__c=true order by createddate]){ rqDocMp.put(doc.reqItm__r.itm__r.cd__c+'-'+doc.reqDoc__c,doc.reqDoc__c); getCrmId.put(doc.reqDoc__c,mbmp.get(doc.reqItm__r.itm__r.cd__c)); } list<String> lstcode = new list<String>(); /*MS 1.1*/ lstcode.addAll(setMemCode); /*MS 1.1*/ for (g_reqitemDoc__c doc : [select id,reqDoc__c,reqItm__r.RQ__r.Acc__r.ccrm_sfid__c,reqItm__r.ccrmid__c,reqItm__r.itm__r.cd__c from g_reqitemDoc__c where reqItm__r.RQ__c =:rqid AND (reqItm__r.itm__r.cd__c IN ('dr', 'dfl', 'frl') OR reqItm__r.itm__r.cd__c IN: lstcode) and Req__c=true and reqAts__c=true and upOk__c=true order by createddate]){ rqDocMp.put(doc.reqItm__r.itm__r.cd__c+'-'+doc.reqDoc__c,doc.reqDoc__c); /*getCrmId.put(doc.reqDoc__c,doc.reqItm__r.RQ__r.Acc__r.ccrm_sfid__c);*/ getCrmId.put(doc.reqDoc__c,doc.reqItm__r.ccrmid__c); } system.debug('rqDocMp::'+rqDocMp); if (String.isBlank(rec.proposedLegalForm) || rec.proposedLegalForm != 'Freelancer'){ g_reqitem__c lRI = [SELECT id, name, ccrmid__c  from g_reqitem__c where RQ__c =: rqid and ccrmid__c   != null and Name = 'License_Registration_Request']; for (Attachment  att : [select id,parentid,name,body,parent.name  from Attachment where parentid=:rqDocMp.values()]) { grqWsOnboard.DocumentInfo doc = new grqWsOnboard.DocumentInfo(); ws_call__c wc = new ws_call__c(); /* MS 1.1*/ if (getCrmId.get(att.parentid) != null){ doc.recid = getCrmId.get(att.parentid); } system.debug(' doc.recid::'+ doc.recid); doc.docName = att.name; doc.fileName = att.name; String inputStr = att.name; String strExt = inputStr.substring(inputStr.lastindexOf('.'), inputStr.length()); /*Start Updated By Meenu MS 1.1*/ if (att.parent.name == 'Declaration of Appointment as General Manager') { doc.docName = 'General Declaration and Undertaking Form'+strExt; doc.fileName = 'General Declaration and Undertaking Form'+strExt; } if (att.name.contains('Passport - first page') ) { doc.fileName =  mapConIdMem.containsKey(doc.recid) ? 'Valid Passport Copy - '+mapConIdMem.get(doc.recid)+strExt : att.parent.name; doc.docName = mapConIdMem.containsKey(doc.recid) ? 'Valid Passport Copy - '+mapConIdMem.get(doc.recid)+strExt : att.parent.name; doc.woid = lRI.ccrmid__c; /*doc.fileName = mapDocCCrmId.containsKey(att.parentId) ? 'Valid Passport Copy - '+mapDocCCrmId.get(att.parentId).reqItm__r.xcfn__c+' '+mapDocCCrmId.get(att.parentId).reqItm__r.xcln__c+strExt : att.parent.name; doc.docName = mapDocCCrmId.containsKey(att.parentId) ? 'Valid Passport Copy - '+mapDocCCrmId.get(att.parentId).reqItm__r.xcfn__c+' '+mapDocCCrmId.get(att.parentId).reqItm__r.xcln__c+strExt : att.parent.name; doc.woid = lRI.ccrmid__c; */ } /*END Updated By Meenu MS 1.1*/ /*doc.fileBody = EncodingUtil.base64Encode(att.body); String rqBody = Json.serialize(doc);*/ wc.rq_itm__c = wsCall.rq_itm__c; wc.pmid__c = rqId; wc.ws_typ__c = 'Onboarding'; wc.mtd_nm__c = 'uploadDoc1'; wc.res_jsn__c = att.parentId; wc.rq_jsn__c = att.id; wc.intsts__c = 'Ready for Integration'; system.debug('wc==='+wc); lstWs.add(wc); } } if (riLst != null && !riLst.isEmpty()){ update riLst; } if (rqLst != null && !rqLst.isEmpty()) update rqLst; /*MS 1.1*/ if (mapPassPort!= null && !mapPassPort.isEmpty()) mapConToRqitm(mapPassPort, rqid); system.debug('lstWs===='+lstWs); /*MS 1.1*/ if (lstWs != null && !lstWs.isEmpty()) insert lstWs; list<id> upFetchg=new List<Id>(); if (String.isBlank(rec.proposedLegalForm) || rec.proposedLegalForm != 'Freelancer'){ ws_call__c wc = new ws_call__c(); wc.pmid__c = rec.crmAccId; wc.ws_typ__c = 'Onboarding'; wc.mtd_nm__c = 'upfetchAccInfo'; wc.intsts__c = 'Ready for Integration'; insert wc; upFetchg.add(wc.id); Database.executeBatch(new BatchOnboardFetchAccInfo(upFetchg),1); } } }
 /*Start===Added By Meenu*/public void mapConToRqitm(map<String, grqWsOnboard.Member> mapPassPort, String rqId) { list<g_reqitem__c> lstRqitm = new list<g_reqitem__c>(); for (g_reqitem__c objIm: [select id, name, Request_Status__c, xcp__c,ccrmid__c  from g_reqitem__c where RQ__c =:rqId and xcp__c IN: mapPassPort.keySet() and ccrmid__c = null]) { lstRqitm.add(new g_reqitem__c(Id = objIm.Id, ccrmid__c = mapPassPort.get(objIm.xcp__c).conid)); } if (!lstRqitm.isEmpty()) { update lstRqitm; } }public static void processAXSDocBatch(ws_call__c wsCall) { map<String, g_reqitemDoc__c> mapDocCCrmId = new map<String, g_reqitemDoc__c>(); String strRqId ; for (g_reqitemDoc__c docitm : [ SELECT id, reqDoc__c, reqItm__r.RQ__c, reqItm__r.RQ__r.Acc__r.ccrm_sfid__c, reqItm__r.ccrmid__c, reqItm__r.itm__r.cd__c, reqItm__r.xcfn__c, reqItm__r.xcln__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c = :wsCall.rq_itm__r.RQ__c AND (reqItm__r.ccrmid__c != null) AND Req__c = TRUE AND reqAts__c = TRUE AND upOk__c = TRUE ORDER BY createddate ]) { strRqId = docitm.reqItm__r.RQ__c; mapDocCCrmId.put(docitm.reqDoc__c, docitm); } List<g_reqitem__c> lRI = [SELECT id, name, ccrmid__c  from g_reqitem__c where RQ__c =: strRqId and ccrmid__c   != null and Name = 'License_Registration_Request']; list<grqWsOnboard.DocumentInfo> lstDoc = new list<grqWsOnboard.DocumentInfo>(); list<grqWsOnboard.DocumentInfo> lstDoc1 = new list<grqWsOnboard.DocumentInfo>(); grqWsOnboard.DocumentInfo doc = new grqWsOnboard.DocumentInfo(); grqWsOnboard.DocumentInfo doc1; list<String> lstPId = wsCall.res_jsn__c.split(','); list<String> lstAttId = new List<String>(); string strQuery = ' SELECT id, parentid, parent.name, name, body FROM Attachment WHERE parentid In: lstPId '; if (String.isNotBlank(wsCall.rq_jsn__c ) &&  wsCall.rq_jsn__c.startsWith('00P')) { lstAttId = wsCall.rq_jsn__c.split(','); strQuery += ' and Id IN: lstAttId'; } system.debug('strQuery==='+strQuery); list<Attachment> lstAtt = Database.query(strQuery); for (Attachment att :lstAtt ) { /*MS 1.1 start*/ doc.docName = att.name; doc.fileName = att.name; String inputStr = att.name; String strExt = inputStr.substring(inputStr.lastindexOf('.'), inputStr.length()); /*if (att.name == 'Declaration of Appointment as General Manager') { doc.docName = 'General Declaration and Undertaking Form'; }*/ if (att.parent.name == 'Declaration of Appointment as General Manager') { doc.docName = 'General Declaration and Undertaking Form'+strExt; doc.fileName = 'General Declaration and Undertaking Form'+strExt; } /*MS 1.1 stop*/ doc.recid = mapDocCCrmId.get(att.parentId).reqItm__r.ccrmid__c; /*Start Updated By Meenu*/ if (att.name.containsIgnoreCase('Passport - first page') ) { doc1 = new grqWsOnboard.DocumentInfo(); doc1.fileName = mapDocCCrmId.containsKey(att.parentId) ? 'Passport - first page - '+mapDocCCrmId.get(att.parentId).reqItm__r.xcfn__c+' '+mapDocCCrmId.get(att.parentId).reqItm__r.xcln__c+strExt : att.parent.name; doc1.docName = mapDocCCrmId.containsKey(att.parentId) ? 'Passport - first page - '+mapDocCCrmId.get(att.parentId).reqItm__r.xcfn__c+' '+mapDocCCrmId.get(att.parentId).reqItm__r.xcln__c+strExt : att.parent.name; if (lRI != null && !lRI.isEmpty()) { doc1.woid = lRI[0].ccrmid__c; doc.woid = lRI[0].ccrmid__c; } doc.fileName = mapDocCCrmId.containsKey(att.parentId) ? 'Valid Passport Copy - '+mapDocCCrmId.get(att.parentId).reqItm__r.xcfn__c+' '+mapDocCCrmId.get(att.parentId).reqItm__r.xcln__c+strExt : att.parent.name; doc.docName = mapDocCCrmId.containsKey(att.parentId) ? 'Valid Passport Copy - '+mapDocCCrmId.get(att.parentId).reqItm__r.xcfn__c+' '+mapDocCCrmId.get(att.parentId).reqItm__r.xcln__c+strExt : att.parent.name; } doc.fileBody = EncodingUtil.base64Encode(att.body); if (doc1 != null) { doc1.recid = doc.recid; doc1.fileBody = EncodingUtil.base64Encode(att.body); lstDoc1.add(doc1); } lstDoc.add(doc); } String rqBody = Json.serialize(doc); system.debug('rqBody==='+rqBody); try{ wsCall.intsts__c = 'On hold'; Http h = new Http(); HttpRequest request = new HttpRequest(); HttpResponse response = new HttpResponse(); request.setHeader('Content-Type', 'application/json'); request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/createdoc'); request.setTimeout(90000); request.setMethod('POST'); request.setBody(rqBody); response = h.send(request); system.debug('response=====3453=='+response); if (response.getStatusCode() == 200) { system.debug('res::' + response.getBody()); wsCall.intsts__c = 'Success'; wsCall.err_msg__c = response.getBody(); if (doc1 != null ) { String rqBody2 = Json.serialize(doc1); callWsUpload(rqBody2, wsCall, true); doc1 = null; } } else { wsCall.intsts__c = 'Failed'; wsCall.err_msg__c = response.getBody(); } } catch (exception ex) { wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString(); wsCall.intsts__c = 'Failed'; } update wsCall; if (wsCall.intsts__c == 'Failed') { processfailedDocBatch(wsCall); } }public static void processfailedDocBatch(ws_call__c wsCall) { list<Ws_call__c> lstWs = new list<Ws_call__c>(); for (WS_call__c objWs:  [Select Id,intsts__c,rq_itm__c,pmid__c,ws_typ__c,mtd_nm__c, res_jsn__c,rq_jsn__c  from ws_call__c where rq_itm__c =: wsCall.rq_itm__c and  mtd_nm__c = 'uploadDoc1']) { if (objWs.rq_jsn__c == wsCall.rq_jsn__c) { lstWs.add(objWs); } } } public static void callWsUpload(String rqBody, ws_call__c ws, boolean isInsert) { ws_call__c wsCall = new ws_call__c(); try{ if (isInsert) { wsCall.mtd_nm__c = ws.mtd_nm__c; wsCall.ws_typ__c =  ws.ws_typ__c; wsCall.rq_jsn__c = ws.rq_jsn__c; wsCall.res_jsn__c = ws.res_jsn__c; wsCall.rq_itm__c = ws.rq_itm__c; wsCall.intsts__c = 'On hold'; wsCall.pmid__c = ws.pmid__c; } else { wsCall = ws; } Http h = new Http(); HttpRequest request = new HttpRequest(); HttpResponse response = new HttpResponse(); request.setHeader('Content-Type', 'application/json'); request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/createdoc'); request.setTimeout(90000); request.setMethod('POST'); request.setBody(rqBody); response = h.send(request); if (response.getStatusCode() == 200) { system.debug('res::' + response.getBody()); wsCall.intsts__c = 'Success'; wsCall.err_msg__c = response.getBody(); } else { wsCall.intsts__c = 'Failed'; wsCall.err_msg__c = response.getBody(); } } catch (exception ex) { wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString(); wsCall.intsts__c = 'Failed'; } upsert wsCall; }public static String fetchAccountInfo(String accCRMID) { String respBody = ''; try{ system.debug('crmAccid::'+accCRMID); Http h = new Http(); HttpRequest request = new HttpRequest(); HttpResponse response   = new HttpResponse(); request.setHeader('Content-Type','application/json'); request.setHeader('accept','application/json'); request.setEndpoint('callout:'+label.CRM_Instance+'/apexrest/accinfo'); request.setHeader('accId',accCRMID); request.setTimeout(90000);request.setMethod('GET'); response = h.send(request); if (response.getStatusCode()==200){ if (response.getBody()!=null){ respBody = response.getBody(); } } }catch (Exception ex){ system.debug('ex1:'+ex.getMessage()); system.debug('ex::'+ex.getStackTraceString()); } return respBody; } global void finish(Database.BatchableContext BC) {}global void execute(SchedulableContext sc) { BatchOnboardInfoUpdate b = new BatchOnboardInfoUpdate();database.executebatch(b, 1);
    }
   /*End===Added By Meenu*/

   /* public void importLeaseInfoFromYardi() {
        axsYardiPaySchWs.ysiOICInterfaceSoap incSp = new axsYardiPaySchWs.ysiOICInterfaceSoap();
        axsYardiPaySchWs.AuthHeader ah = new axsYardiPaySchWs.AuthHeader();
        ah.sUserName='oicpoc';
        ah.sUserPassword='616814a160cfd51e1155fce175ee266d';
        ah.sCredentialName='Test';
        incSp.AuthHeader = ah;
        axsYardiPaySchWs.MEDealLease_Request deal = new axsYardiPaySchWs.MEDealLease_Request();
        deal.Ext_Ref_Lease_Id='2242424';
        deal.Yardi_Parent_Amendment_ID=0;
        deal.SF_AGNo='345w323';
        deal.SF_LegalTermsChanged='Yes';
        deal.SF_Quote_ID='42331311';
        deal.Amendment_Type='Original Lease';
        deal.Amendment_SubType='';
        deal.Expansion_Separate_Amendment_Terms=0;
        deal.Property_Code='d3_b01';
        deal.Yardi_Lease_Code='';
        deal.Yardi_Brand_Code='100305';
        deal.SF_Lease_Status='Approved';
        deal.Lease_Name='Test123';
        deal.Lease_Type='Office';
        deal.Lease_Start_Date=Datetime.newInstance(2018,05,15);
        deal.Lease_End_Date=Datetime.newInstance(2021,05,14);
        deal.Sales_Category='';
        deal.Move_In_Date=Datetime.newInstance(2018,08,15);
        deal.Move_Out_Date=Datetime.newInstance(2021,05,14);
        deal.Yardi_Customer_Code='c0000017';
        deal.Company_Name='Test112';
        deal.Possession_Date=Datetime.newInstance(2018,08,15);
        deal.Occupancy_Cert_Date=Datetime.newInstance(2018,08,15);
        deal.Sign_Date=Datetime.newInstance(2018,05,15);
        deal.Amendment_Description='test';
        deal.Lease_Currency='AED';
        deal.Yardi_Contact_Code='c0008354';
        axsYardiPaySchWs.MEUnitXref_Request[] arreq = new List<axsYardiPaySchWs.MEUnitXref_Request>();
        axsYardiPaySchWs.ArrayOfMEUnitXref_Request unitDet = new axsYardiPaySchWs.ArrayOfMEUnitXref_Request();
        axsYardiPaySchWs.MEUnitXref_Request unit = new axsYardiPaySchWs.MEUnitXref_Request();
        unit.Lease_Unit_Id=210;
        unit.Lease_Unit_Start_Date=Datetime.newInstance(2018,05,15);
        unit.Lease_Unit_End_Date=Datetime.newInstance(2021,05,14);
        unit.Lease_Unit_Move_in_Date=Datetime.newInstance(2018,08,15);
        unit.Lease_Unit_Move_Out_Date=Datetime.newInstance(2021,05,14);
        arreq.add(unit);
        unitDet.MEUnitXref_Request = arreq;
        deal.Unitxref_Details = unitDet;

        axsYardiPaySchWs.MEChargeSchedule_Request[] arrMechrSch = new List<axsYardiPaySchWs.MEChargeSchedule_Request>();
        axsYardiPaySchWs.ArrayOfMEChargeSchedule_Request arrChrgSch = new axsYardiPaySchWs.ArrayOfMEChargeSchedule_Request();
        axsYardiPaySchWs.MEChargeSchedule_Request chrgSch1 = new axsYardiPaySchWs.MEChargeSchedule_Request();
        axsYardiPaySchWs.MEChargeSchedule_Request chrgSch2 = new axsYardiPaySchWs.MEChargeSchedule_Request();
        axsYardiPaySchWs.MEChargeSchedule_Request chrgSch3 = new axsYardiPaySchWs.MEChargeSchedule_Request();
        chrgSch1.ChargeSchedule_From_Date=Datetime.newInstance(2018,05,15);
        chrgSch1.ChargeSchedule_To_Date=Datetime.newInstance(2021,05,14);
        chrgSch1.ChargeSchedule_Charge_Code='rntoff';
        chrgSch1.ChargeSchedule_Amount_Period='Annual';
        chrgSch1.ChargeSchedule_Estimate_Type='Amount per area';
        chrgSch1.Area_Column_Overide='';
        chrgSch1.ChargeSchedule_Currency='';
        chrgSch1.Invoice_Frequency='Quarterly';
        chrgSch1.ChargeSchedule_Unit_ID=210;
        chrgSch1.Proration_Method='monthly';
        chrgSch1.Rent_Increase_Start_Date=Datetime.newInstance(2019,05,15);
        chrgSch1.Rent_Increase_End_Date=Datetime.newInstance(2020,05,14);
        chrgSch1.ChargeSchedule_Amount=220;
        arrMechrSch.add(chrgSch1);
        chrgSch2.ChargeSchedule_From_Date=Datetime.newInstance(2018,05,15);
        chrgSch2.ChargeSchedule_To_Date=Datetime.newInstance(2021,05,14);
        chrgSch2.ChargeSchedule_Charge_Code='rntoff';
        chrgSch2.ChargeSchedule_Amount_Period='Annual';
        chrgSch2.ChargeSchedule_Estimate_Type='Amount per area';
        chrgSch2.Area_Column_Overide='';
        chrgSch2.ChargeSchedule_Currency='';
        chrgSch2.Invoice_Frequency='Quarterly';
        chrgSch2.ChargeSchedule_Unit_ID=210;
        chrgSch2.Proration_Method='monthly';
        chrgSch2.Rent_Increase_Start_Date=Datetime.newInstance(2020,05,15);
        chrgSch2.Rent_Increase_End_Date=Datetime.newInstance(2021,05,14);
        chrgSch2.ChargeSchedule_Amount=230;
        arrMechrSch.add(chrgSch2);
        chrgSch3.ChargeSchedule_From_Date=Datetime.newInstance(2018,05,15);
        chrgSch3.ChargeSchedule_To_Date=Datetime.newInstance(2021,05,14);
        chrgSch3.ChargeSchedule_Charge_Code='secdep';
        chrgSch3.ChargeSchedule_Amount_Period='Annual';
        chrgSch3.ChargeSchedule_Estimate_Type='Flat Amount';
        chrgSch3.Area_Column_Overide='';
        chrgSch3.ChargeSchedule_Currency='';
        chrgSch3.Invoice_Frequency='Annual';
        chrgSch3.ChargeSchedule_Unit_ID=210;
        chrgSch3.Proration_Method='monthly';
        chrgSch3.Rent_Increase_Start_Date=Datetime.newInstance(2019,05,15);
        chrgSch3.Rent_Increase_End_Date=Datetime.newInstance(2021,05,14);
        chrgSch3.ChargeSchedule_Amount=100000;
        arrMechrSch.add(chrgSch3);
        arrChrgSch.MEChargeSchedule_Request = arrMechrSch;
        deal.ChargeSchedule_Details=arrChrgSch;

        if (!Test.isRunningTest()){
            axsYardiPaySchWs.MEDealLease_Response res = incSp.YardiLeaseImport(deal);
            System.debug('response:>>>>> '+res);
        }
    }
    */

}
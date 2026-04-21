global class NrtaStatus {
    public static Map<String,g_req__c> rqMap{set;get;}
    webService static String updateNrtaStatus(string nrtaSTA) {
        /*nrtaSTA = '{"reqNumber":"42671820170724","fromStatus":"At Dispatcher","toStatus":"Accepted","updateTimeStamp":"3/08/2016 0:00","updateReason":"test11"}';*/
        NrtaSTAResponse response=new NrtaSTAResponse();
        System.debug('*** nrtaSTA : ' + nrtaSTA);

        try{
            NrtaSTA nrta = (NrtaSTA)JSON.deserialize(nrtaSTA, NrtaStatus.NrtaSTA.class);
            System.debug(' ** nrta: '+ nrta);
            g_Req__c rq = new g_Req__c();
            List<g_reqitem__c> lstReqItemsToUpdate = new List<g_reqitem__c>();
            List<g_Req__c> req = [SELECT ID,xbtnm__c,Name,xcddocs__c,STA__c,srvc__c,srvc__r.uid__c,xdmpn__c,xccn__c,xcped__c,xcpid__c,xcamc__c,Party_Id__c,(SELECT Id,vSTA__c,xdcr__c,itm__c,RQ__r.Service_Code__c,sta__c,itm__r.cd__c, Name,xr__c,xcdocs__c, xcnotes__c,Time_stamp__c From Items__r where sta__r.name not in ('Courier Initiated')),(select id,name from Transactions__r limit 1) From g_Req__c WHERE Name=:nrta.reqNumber];//US_APD2635 //'Waiting for Original Documents',
            if (req.size() > 0) {
                rq = req[0];
                List<g_reqitem__c> lstReqItems = req[0].Items__r;
                List<g_Tran__c> lstTrans= rq.Transactions__r; /*US APD2635*/
                /* LA Code */
                g_reqitem__c reqItem = new g_reqitem__c();
                system.debug('--lstReqItems--'+lstReqItems);
                boolean hasTecomLease=false; /*US APD2635*/
                for (g_reqitem__c ref:lstReqItems){
                    if (ref.itm__r.cd__c == 'tlf'){ /*US APD2635*/
                       hasTecomLease=true;
                    }
                    if (ref.itm__r.cd__c == 'ddd'){
                        reqItem = ref;
                    }
                }
                system.debug('reqItem -- '+reqItem);
                List<Courier_Status__c> nxtStLst = [select id,Req_STA__c,itmSTA__c,curSTA__c,curSTA__r.xcsits__c,curSTA__r.name,curSTA__r.cd__c,curSTA__r.uid__c,curSTA__r.rqSTA__c from Courier_Status__c where srvitm__c =:reqItem.itm__c  and Courier_Status__c=:nrta.toStatus];
                system.debug('nxtStLst -- '+nxtStLst);

                if (rq.srvc__r.uid__c == '220' && nxtStLst != null && !nxtStLst.isEmpty()) { System.debug('===' + nrta.toStatus); if (nrta.toStatus == 'Name Approved') { List<String> names = new List<String>(); String attStr = ''; for (srAttachments att : nrta.srAttachments) attStr = String.isEmpty(attStr) ? att.name + '@' + att.ddaId : attStr + ';' + att.name + '@' + att.ddaId; rq.Sta__c = 'Open'; rq.xbtnm__c = nrta.approvedCompanyName; rq.xcddocs__c = (rq.xcddocs__c == null || rq.xcddocs__c == '') ? attStr : rq.xcddocs__c + ';' + attStr; reqItem.rc__c = true; update req[0]; } if (nrta.toStatus == 'Completed' && rq.xcamc__c.contains('Name Change')) { System.debug('---nrta.toStatus---' + nrta.toStatus); rq.sta__c = 'In Process'; update req[0]; } if (nrta.toStatus != 'Requires Correction' && !String.isBlank(req[0].xcamc__c) && !req[0].xcamc__c.contains('Name Change') && String.isNotEmpty(nxtStLst[0].Req_STA__c)) { rq.STA__c = nxtStLst[0].Req_STA__c; System.debug('rq -- ' + rq); update req[0]; } if (nrta.toStatus == 'Rejected') { rq.STA__c = 'Rejected'; update req[0]; } if (nrta.toStatus == 'Requires Correction') { List<g_reqitemDoc__c> reqDocs = new List<g_reqitemDoc__c>(); List<g_reqDoc__c> reqDocsLst = new List<g_reqDoc__c>(); List<Id> rqDc = new List<Id>(); String attStr = ''; for (srAttachments att : nrta.srAttachments) { att.name = 'Copy of ' + att.name; attStr = String.isEmpty(attStr) ? att.name + '@' + att.ddaId : attStr + ';' + att.name + '@' + att.ddaId; } System.debug('attStr -- ' + attStr); rq.xcddocs__c = (rq.xcddocs__c == null || rq.xcddocs__c == '') ? attStr : rq.xcddocs__c + ';' + attStr; rq.sta__c = 'Open'; if (nrta.cfrComments != null && !nrta.cfrComments.isEmpty()) { List<String> orderedLines = new List<String>(); for (CommentInfo cmt : nrta.cfrComments) if (cmt.department != null && cmt.department.trim().toUpperCase() == 'AML') orderedLines.add(cmt.comment != null ? cmt.comment.replace('&amp;', '&') : ''); for (CommentInfo cmt : nrta.cfrComments) if (cmt.department != null && (cmt.department.contains('R&L') || cmt.department.contains('R&amp;L') || cmt.department.toUpperCase().contains('R AND L'))) orderedLines.add(cmt.comment != null ? cmt.comment.replace('&amp;', '&') : ''); reqItem.xcnotes__c = String.join(orderedLines, '\n'); } else { String cleanComment = nrta.updateNote != null ? nrta.updateNote.replace('&amp;', '&') : ''; System.debug('----cleanComment----' + cleanComment); reqItem.xcnotes__c = cleanComment; } reqItem.vSTA__c = 'Requires Correction'; System.debug('---rq----' + rq); update req[0]; update reqItem; } if ((nrta.toStatus == 'Waiting for Original Documents' && nrta.originalDocuments != null && !nrta.originalDocuments.isEmpty()) || nrta.toStatus == 'Pending for Attestation') { reqItem.xcnotes__c += ' Documents : ' + String.join(nrta.originalDocuments, ','); if (req[0].xcamc__c.contains('Name Change') && hasTecomLease) { ws_call__c objWs = new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'createAssignment', ws_typ__c = 'License Amendments', intsts__c = 'Ready for Integration'); Map<String, Object> jsonMap = new Map<String, Object>(); if (rq.Party_Id__c != null) jsonMap.put('oraclePartyId', rq.Party_Id__c); if (nrta.approvedCompanyName != null) jsonMap.put('approvedName', nrta.approvedCompanyName); if (rq.Transactions__r != null && !rq.Transactions__r.isEmpty() && rq.Transactions__r[0].Name != null) { jsonMap.put('transactionNumber', rq.Transactions__r[0].Name); jsonMap.put('isPaid', true); } objWs.rq_jsn__c = JSON.serialize(jsonMap); insert objWs; } } reqItem.sta__c = nxtStLst[0].itmSTA__c; if (String.isBlank(reqItem.xr__c)) reqItem.xr__c = nrta.updateReason; reqItem.xdcr__c = JSON.serialize(nrta.srAttachments); System.debug('reqItem -- ' + reqItem); if (!String.isBlank(req[0].xcamc__c) && !req[0].xcamc__c.contains('Name Change') && nrta.toStatus == 'Completed') { grqI.uItms(rq, 'ok'); req[0].sta__c = 'Completed'; update req[0]; } else { update reqItem; } }

                else {
                    /* End*/
                    Map<String,g_srvcitm_Status__c> mapStatusbyCode = new Map<String,g_srvcitm_Status__c>();
                    List<g_srvcitm_Status__c> lstStatus = new List<g_srvcitm_Status__c>();
                    if (rq.srvc__r.uid__c == '159000'){
                        lstStatus = [SELECT Id, Name, rqSTA__c, itm__r.cd__c, itm__c, itm__r.name FROM g_srvcitm_Status__c WHERE itm__c=: lstReqItems[0].itm__c];
                    }
                    else{
                        lstStatus = [SELECT Id, Name, rqSTA__c, itm__r.cd__c, itm__c, itm__r.name FROM g_srvcitm_Status__c WHERE itm__r.srvc__c= :rq.srvc__c];
                    }
                    system.debug('lstStatus -- '+lstStatus);
                    if (lstStatus.size() > 0) {
                        for (g_srvcitm_Status__c st : lstStatus) {
                            System.debug('st.Name ' + st.Name +' + st.itm__r.name : '+ st.itm__r.name);
                            mapStatusbyCode.put(st.Name + st.itm__r.name+st.itm__r.cd__c, St);
                        }
                    }
                    List<g_reqitemDoc__c> retDocs = [select id,name,mnAts__c,mxAts__c,upOk__c,Req__c from g_reqitemDoc__c where Re__c=:nrta.reqNumber and name in('Vehicle registration card - front - copy','Vehicle registration card - back - copy')];
                    system.debug('lstReqItems -- '+lstReqItems);
                    for (g_reqitem__c itm : lstReqItems) {
                        System.debug('mapStatusbyCode : ' + mapStatusbyCode + 'nrta.toStatus+itm.Name ;' + nrta.toStatus+itm.Name);
                        system.debug('itm.sta__c -- '+itm.sta__c);
                        system.debug('----mapStatusbyCode---'+mapStatusbyCode.values());
                        if (mapStatusbyCode.get(nrta.toStatus+itm.Name+itm.itm__r.cd__c).id !=null){
                            itm.sta__c = mapStatusbyCode.get(nrta.toStatus+itm.Name+itm.itm__r.cd__c).id;
                        }

                        if (nrta.updateReason!=null){
                            if (string.isblank(reqItem.xr__c))itm.xr__c = nrta.updateReason;
                            itm.xcnotes__c = nrta.updateReason;
                            system.debug('nrta.updateReason -- '+nrta.updateReason);
                            if (nrta.toStatus =='Requires Correction' &&(nrta.updateReason.toLowerCase().contains('doc'))){//!nrta.updateReason.toLowerCase().contains('customer name and contact is missing'))
                                system.debug('retDocs -- '+retDocs);
                                for (g_reqitemDoc__c d : retDocs){d.mnAts__c = 1;d.Req__c= true;d.reqAts__c = true;}
                            }

                        }
                        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, retDocs);
                        update secDec.getRecords();
                        if ( nrta.updateNote!=null){
                            itm.xcnotes__c = nrta.updateNote;
                        }
                        if ( nrta.docName!=null){
                            itm.xcdocs__c = nrta.docName;}

                        lstReqItemsToUpdate.add(itm);
                    }
                    system.debug('lstReqItemsToUpdate -- '+lstReqItemsToUpdate);
                    if (lstReqItemsToUpdate.size() > 0){update lstReqItemsToUpdate;}
                    rq.STA__c = mapStatusbyCode.get(nrta.toStatus+lstReqItems[0].Name+lstReqItems[0].itm__r.cd__c).rqSTA__c;
                    if ( String.isNotBlank(nrta.dccaPermitNo)){
                        rq.xdmpn__c = nrta.dccaPermitNo;}
                    if ( String.isNotBlank(nrta.servcPvd)){
                        rq.xccn__c = nrta.servcPvd;}
                    if ( nrta.permSd!=null ){
                        rq.xcpid__c = nrta.permSd;}
                    if ( nrta.permEd!=null){
                        rq.xcped__c = nrta.permEd;}

                    system.debug('rq.STA__c -- 62 '+rq.STA__c);
                    if (String.isNotBlank(rq.STA__c)){
                        system.debug('rq.STA__c -- 64 '+rq.STA__c);
                        update req[0];
                    }
                    response.error_code='0'; response.status='Success';
                }
            }else{ response.error_code='1';response.status='Record not found'; }
        }catch (JSONException je) {response.error_code='1';response.status='Invalid JSON String'; system.debug(je.getMessage());
                                 }catch (Exception e){
                                     response.error_code='1';response.status='#Error : ' + e.getMessage() + ' #Line Number : ' +e.getLineNumber();
                                     system.debug(e.getMessage());
                                 }
        system.debug(response);
        return  JSON.serialize(response);
    }

    webService static String updateAmount(String rqNum, Decimal amount) {
        NrtaSTAResponse response=new NrtaSTAResponse();
        response.error_code='0'; response.status='Success';

        try{
            List<g_Req__c> lstRq = [SELECT Id,Name,xtpa__c,xdapp__c,srvc__r.UID__c FROM g_Req__c WHERE name=:rqNum LIMIT 1];

            if (lstRq == null || lstRq.size() == 0) {
                response.error_code='1'; response.status='Failure - Request ['+ rqNum + '] not found.';
                return JSON.serialize(response);
            } else if (lstRq[0].srvc__r.UID__c != gu.csStr('AdditionalParking') && lstRq[0].srvc__r.UID__c != gu.csStr('ParkingRenewal')){
                response.error_code='1'; response.status='Failure - This service is only for Additional/Renew parking.';
                return JSON.serialize(response);
            } /*else if (lstRq[0].xdapp__c){
response.error_code='1'; response.status='Failure - discount has already been given.';
}*/

            lstRq[0].xtpa__c = amount; lstRq[0].xdapp__c = true;
            update lstRq[0];

        }catch (exception ex){
            System.debug('#Exception: ' + ex.getMessage() + ex.getStackTraceString());
            response.error_code='1'; response.status='#Error : ' + ex.getMessage();
        }

        return JSON.serialize(response);
    }


    webService static String parkingRenewal(String pDetails) {
        /*'{"agNo":"agNo-1234","orclId":"29258","noOfSlots":"4","pricePerSlot":"800.00","startDate":"3/08/2017","expDate":"3/08/2018","tAmount":"3200.00", "sector":"DSC" }';
        '{"cards":[{"cardNo":"Test1234","ExpDate":"12/12/2018","stDate":"10/10/2017"},{"cardNo":"Test4567","ExpDate":"09/12/2018","stDate":"06/10/2017"},{"cardNo":"Test7890","ExpDate":"11/11/2018","stDate":"09/08/2017"}]}';*/

        System.debug('<parkingRenewal> pDetails : ' + pDetails);
        NrtaSTAResponse response=new NrtaSTAResponse();
        response.error_code='0'; response.status='Success';

        try {
            List<g_req__c> reqsToInsert = getReqsToInsert(pDetails);
            List<String> lstOrclIds = new List<String>();
            for (g_req__c rq : reqsToInsert){
                lstOrclIds.add(rq.xtcid__c);
            }

            List<Account> lstAcc = [SELECT Id, Name,ORACLE_PARTY_ID__c From Account WHERE ORACLE_PARTY_ID__c=:lstOrclIds];
            Map<String,String> mapIdsByOrclID = new Map<String,String>();

            for (Account a : lstAcc){
                mapIdsByOrclID.put(a.ORACLE_PARTY_ID__c, a.Id);
            }

            System.debug('mapIdsByOrclID : ' + mapIdsByOrclID);
            for (g_req__c rq : reqsToInsert){
                rq.Acc__c = mapIdsByOrclID.get(rq.xtcid__c);
                rq.xtcid__c = '';
            }


            Database.UpsertResult[] srList= Database.upsert(reqsToInsert);
            for (Database.UpsertResult sr : srList) {if (sr.isSuccess()){ response.rqid=sr.getID();}}
            List<g_req__c> lstRq = [SELECT Id, Name From g_req__c WHERE id=:response.rqid];
            if (!lstRq.isEmpty()){response.axsid=lstRq.get(0).Name;}


        }catch (JSONException je) {
            response.error_code='1';response.status='Invalid JSON String'; system.debug(je.getMessage()+ ' ' +je.getStackTraceString());
        } catch (Exception e){
            response.error_code='1';response.status='#Error : ' + e.getMessage() + ' #Line Number : ' +e.getLineNumber();
            system.debug(e.getMessage() + ' ' +e.getStackTraceString());
        }

        system.debug('<parkingRenewal> response: '+response);
        return JSON.serialize(response);
    }


    public static List<g_req__c> getReqsToInsert(string pDetails) {

        System.debug('#### pDetail : ' + pDetails);
        NrtaStatus.ParkingRenewal r = (NrtaStatus.ParkingRenewal)JSON.deserialize(pDetails, NrtaStatus.ParkingRenewal.class);
        System.debug('#### : ' + r);
        List<g_req__c> lstReqs = new List<g_req__c>();
        String  sno;
        for (Agreement agr : r.agreements){
            List<PkgCard> lstCards = new List<PkgCard>();
            for (PkgCard card : agr.cardslist){
                lstCards.add(card);
            }
            String cardList = '{"cardslist":' + JSON.serialize(lstCards) + '}';
            System.debug(cardlist);
            g_req__c req = new g_req__c();
            System.debug('agr.reqid : ' + agr.reqid);
            if (String.isNotBlank(agr.reqid)){req.Id=agr.reqid;}
            req.ias__c    =  '0np';
            req.srvc__c   =   gu.csStr('srvc_pRenewal');
            req.STA__c     =   'Draft';
            req.xtcid__c  =  agr.orclId;
            req.xps__c     =   agr.sector;
            req.xtpa__c   =   Decimal.valueOf(agr.totalAmt);
            req.xrap__c   =   Decimal.valueOf(agr.totalslots);
            req.xanum__c   =   agr.agNo;
            req.xaed__c   =   (agr.expDate!=null) ? Date.valueOf(agr.expDate):null;
            req.xfpc__c   =   (agr.stDate!=null) ? Date.valueOf(agr.stDate):null; //Date.valueOf(agr.startDate);
            req.xuvdet__c  =  cardList;
            req.xceml__c  =  agr.email;
            req.xoln__c    =  agr.phone;
            req.rmob__c    =  agr.mobile;

            if (agr.rqid!=null && agr.rqid.trim().length()>0){req.id=agr.rqid;}
            lstReqs.add(req);

        }
        return lstReqs;
    }

     global class NrtaSTAResponse {webService String error_code,status,axsid,rqid;}
    global class NrtaSTA {public String reqNumber, fromStatus, toStatus, updateReason, docName, updateNote, dccaPermitNo, servcPvd, updateTimeStamp,approvedCompanyName; public Date permSd,permEd; public List<srAttachments> srAttachments;public List<String> originalDocuments;public List<CommentInfo> cfrComments;}
    global class ParkingRenewal {public List<Agreement> agreements;}
    global class Agreement { public String totalslots,reqid,totalAmt,stDate,sector,orclId,expDate,startDate,agNo,axsid,rqid,phone,mobile,email;public List<PkgCard> cardslist;}
    public class PkgCard { public String sfcid,sector,cnum,chname,cardexpDate,startDate; }
    public class srAttachments {public String relationName, name, ddaId,department; public Boolean isMandatory;}
    public class CommentInfo {//US APD2635
        public String comment;
        public String department;
    }
}
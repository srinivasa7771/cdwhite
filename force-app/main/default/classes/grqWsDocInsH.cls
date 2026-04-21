public class grqWsDocInsH {

    public static void uploadLetterDoc(list < id > rqItSet, map < Id, String > mapItmPolicyGen, map < Id, String > mapItmDocReq, map < Id, String > mapRqIdItm, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < g_Req__c > rqList = new List < g_Req__c > ();
        map < Id, g_reqitem__c > mapReg = new map < Id, g_reqitem__c > ();
        map < Id, map < String, Attachment >> mapAtt = new map < Id, map < String, Attachment >> ();
        map < Id, Id > mapRqItWs = new map < Id, Id > ();
        map < Id, map < String, Id >> reqItmDoc = new map < Id, map < String, Id >> ();
        List<string> docNamejpg = new List<string>();
        list<String> docName = new list<String> ();
        map<String, String> insdocMap = new map<String, String>();

        for (Id ri: rqItSet) {
            String str =mapItmDocReq.get(ri);
            if (str != null) {
                docName = str.split(';');
                system.debug(docName);
                for (string st : docName ) {
                    list<string> crtmap = st.split(':');
                    insdocMap.put(crtmap[0], crtmap[1]);
                    docNamejpg.add(crtmap[1]+'.jpg');
                }
            }
        }
        system.debug('JJ 1'+insdocMap);
        system.debug('JJ 2'+docNamejpg);
        //
        List < g_reqDoc__c > rqIDoc = [Select Id, Name, RQ__c, RQ__r.Id from g_reqDoc__c where RQ__c in: mapRqIdItm.values() and Name in:insdocMap.values()  ];
        set < Id > reqDcIds = new set < Id > ();
        system.debug('JJ 3'+rqIDoc);

        for (g_reqDoc__c rqDoc: rqIDoc) {
            if (!reqItmDoc.containsKey(rqDoc.RQ__r.Id)) {
                reqItmDoc.put(rqDoc.RQ__r.Id, new map < String, id > ());
            }
            reqItmDoc.get(rqDoc.RQ__r.Id).put(rqDoc.name, rqDoc.Id);
            reqDcIds.add(rqDoc.Id);
        }
        system.debug('JJ 4'+reqItmDoc);
        system.debug('JJ 5'+reqDcIds);
        List < Attachment > attList = [Select Id, Body, Description, Name, ParentId from Attachment where ParentId in: reqDcIds and Name in:docNamejpg];
        system.debug('JJ 6'+attList);
        for (Attachment att: attList) {
            if (!mapAtt.containsKey(att.id)) {
                mapAtt.put(att.ParentId, new map < String, Attachment > ());
            }
            mapAtt.get(att.ParentId).put(att.Name, att);
        }

        system.debug('JJ 7'+mapAtt);

        Integer i = 0;
        for (Id ri: rqItSet) {
            String rqId = mapRqIdItm.get(ri);

            grqWsDcca.serviceReq sr = new grqWsDcca.serviceReq();
            List<grqWsDcca.serviceReq> serviceReqList = new List<grqWsDcca.serviceReq>();
            grqWsDcca.serviceRequest srRq = new grqWsDcca.serviceRequest();
            sr.isPaid = true;
            try {
                for (string doc : insdocMap.keySet()) {
                    system.debug('JJ'+doc);
                    If(reqItmDoc.get(rqId).get(insdocMap.get(doc)) != null) {
                        string  dcNm = insdocMap.get(doc);
                        string dcNmjpg = dcNm+'.jpg';
                        sr.attName = doc + '.jpg';
                        id rqDocId = reqItmDoc.get(rqId).get(dcNm);
                        if (mapAtt.get(rqDocId)!=null && mapAtt.get(rqDocId).containsKey(dcNmjpg)) {
                            sr.attach = EncodingUtil.base64Encode(mapAtt.get(rqDocId).get(dcNmjpg).Body);
                        }
                        serviceReqList.add(sr);
                        system.debug('JJ 8'+serviceReqList);
                    }

                    grqWsDcca.serviceReq ser = serviceReqList[0];
                    List<grqWsDcca.serviceReq> serviceReqListnew = new List<grqWsDcca.serviceReq>();
                    grqWsDcca.serviceRequest srRqmew = new grqWsDcca.serviceRequest();
                    system.debug('JJ 9'+ser);
                    serviceReqListnew.add(ser);
                    srRqmew.serviceRequest =serviceReqListnew;
                    String jsonBody = JSON.serialize(srRqmew);
                    ws_call__c ws = new ws_call__c();
                    ws.rq_jsn__c = jsonBody;
                    ws.ws_typ__c = wsTyp;
                    ws.mtd_nm__c = wsMd;
                    ws.uid__c = rqId + '' + ri + '' + wsMd + system.now()+i;
                    ws.rq_itm__c = ri;
                    ws.intsts__c = 'Ready for Integration';
                    wsList.add(ws);
                    i++;

                }

            } catch (Exception e) {
                System.debug('#Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
        try {
            Insert wsList;
        } catch (Exception ex) {
            System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    public static void uploadPolicyDoc(list < id > rqItSet, map < Id, String > mapItmPolicyGen, map < Id, String > mapItmDocReq, map < Id, String > mapRqIdItm, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < g_Req__c > rqList = new List < g_Req__c > ();
        map < Id, g_reqitem__c > mapReg = new map < Id, g_reqitem__c > ();
        map < Id, map < String, Attachment >> mapAtt = new map < Id, map < String, Attachment >> ();
        map < Id, Id > mapRqItWs = new map < Id, Id > ();
        map < Id, map < String, Id >> reqItmDoc = new map < Id, map < String, Id >> ();
        List<string> docNamejpg = new List<string>();
        list<String> docName = new list<String> ();
        map<String, String> insdocMap = new map<String, String>();

        for (Id ri: rqItSet) {
            //'PASSPORT:Passport Copy;UID:Entry Permit Copy;EMIRATESID:EIDA Application form;'
            system.debug('inupload doc'+ri);
            String str =mapItmDocReq.get(ri);
            docName = str.split(';');
            system.debug(docName);
            for (string st : docName ) {
                list<string> crtmap = st.split(':');
                insdocMap.put(crtmap[0], crtmap[1]);
                docNamejpg.add(crtmap[1]+'.jpg');
            }
            system.debug('JJJ'+docNamejpg);
            system.debug('JJJ2'+insdocMap.values());
            system.debug('JJJ3'+insdocMap.keySet());
        }

        List < g_reqDoc__c > rqIDoc = [Select Id, Name, RQ__c, RQ__r.Id from g_reqDoc__c where RQ__c in: mapRqIdItm.values() and Name in:insdocMap.values() ];
        set < Id > reqDcIds = new set < Id > ();
        for (g_reqDoc__c rqDoc: rqIDoc) {
            if (!reqItmDoc.containsKey(rqDoc.RQ__r.Id)) {
                reqItmDoc.put(rqDoc.RQ__r.Id, new map < String, id > ());
            }
            reqItmDoc.get(rqDoc.RQ__r.Id).put(rqDoc.name, rqDoc.Id);
            reqDcIds.add(rqDoc.Id);
        }

        List < Attachment > attList = [Select Id, Body, Description, Name, ParentId from Attachment where ParentId in: reqDcIds and Name in:docNamejpg];
        for (Attachment att: attList) {
            if (!mapAtt.containsKey(att.id)) {
                mapAtt.put(att.ParentId, new map < String, Attachment > ());
            }
            mapAtt.get(att.ParentId).put(att.Name, att);
        }
        for (Id ri: rqItSet) {
            String rqId = mapRqIdItm.get(ri);

            gctlInsHelper.Insurance ins = new gctlInsHelper.Insurance();
            List < gctlInsHelper.DocumentInfo > lstdocInfo = new List < gctlInsHelper.DocumentInfo > ();
            gctlInsHelper.DocumentInfo docInfo = new gctlInsHelper.DocumentInfo();
            gctlInsHelper.PartnerInfo pi = new gctlInsHelper.PartnerInfo();

            try {

                String mebId = mapItmPolicyGen.get(ri);

                for (string doc : insdocMap.keySet()) {
                    system.debug('JJ'+doc);
                    If(reqItmDoc.get(rqId).get(insdocMap.get(doc)) != null) {
                        system.debug('JJ2'+reqItmDoc.get(rqId).get(insdocMap.get(doc)));
                        string  dcNm = insdocMap.get(doc);
                        string  dcNmjpg = dcNm+'.jpg';
                        system.debug('JJ3'+dcNm);
                        docInfo.DocumentCategory = doc;
                        docInfo.DocumentName = doc + '.jpg';
                        docInfo.MemberId = mebId;
                        id rqDocId = reqItmDoc.get(rqId).get(dcNm);
                        system.debug('JJ4'+rqDocId);
                        if (mapAtt.get(rqDocId)!=null && mapAtt.get(rqDocId).containsKey(dcNmjpg)) {
                            docInfo.DocumentContent = EncodingUtil.base64Encode(mapAtt.get(rqDocId).get(dcNmjpg).Body);
                        }
                        lstdocInfo.add(docInfo);
                    }

                }

                Map < String, adnicWS__c > adnicValues = adnicWS__c.getAll();
                pi.PartnerId = adnicValues.get('Json Creation').PartnerID__c;
                Integer i = 0;
                for (gctlInsHelper.DocumentInfo doc : lstdocInfo) {
                    ins.PartnerInfo = pi;
                    List <gctlInsHelper.DocumentInfo> docList = new  List <gctlInsHelper.DocumentInfo>();
                    docList.add(doc);
                    ins.DocumentInfo = docList;
                    String jsonBody = JSON.serialize(ins);
                    System.debug('jsonBody : ' + jsonBody);
                    ws_call__c ws = new ws_call__c();
                    ws.rq_jsn__c = jsonBody;
                    ws.ws_typ__c = wsTyp;
                    ws.mtd_nm__c = wsMd;
                    ws.uid__c = rqId + '' + ri + '' + '' + wsMd + i;
                    ws.rq_itm__c = ri;
                    ws.intsts__c = 'Ready for Integration';
                    wsList.add(ws);
                    i++;
                }

            } catch (Exception e) {
                System.debug('#Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
        try {
            Insert wsList;
        } catch (Exception ex) {
            System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }
}
public class grqWsCourier {

    public static void insertRecord(List < g_reqitem__c > rqItSet, Map < Id, g_Req__c > reqMap, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        Map < Id, g_reqitem__c > mapStsByItem = new Map < Id, g_reqitem__c > ([SELECT Id, lastModifiedDate, Name, sta__r.rqSTA__c, sta__r.Name FROM g_reqitem__c WHERE ID in: rqItSet]);
        try {
            for (g_reqitem__c ri: rqItSet) {
                g_Req__c rq = reqMap.get(ri.Id);
                serviceReq servReq = new serviceReq();
                List < serviceReq > serviceReqList = new List < serviceReq > ();
                serviceRequest sr = new serviceRequest();
                servReq.SRN = rq.Name;
                servReq.AWB = '' + rq.xawb__c;
                /**servReq.status = rq.sta__c;
                **/ if (mapStsByItem.containsKey(ri.Id)) {
                    g_reqitem__c dItm = mapStsByItem.get(ri.Id);
                    servReq.delStatus = dItm.sta__r.Name;
                    servReq.status = dItm.sta__r.rqSTA__c;
                    servReq.timeStamp = '' + dItm.lastModifiedDate.getTime();
                    if (wsMd.contains('updateCourColSta')) {
                        servReq.acName= rq.Acc__r.Name;
                        servReq.conName= rq.xchn__c;
                        servReq.docType= 'Lease Document Collection (Along with Cheque)';
                        servReq.refMobile= rq.rmob__c;
                        servReq.delZone= rq.xbrnd__c;
                        servReq.bldngName= rq.xbn__c;
                        servReq.delLoc= rq.xaloc__c;
                        servReq.notes= rq.nt__c;
                        servReq.noCheques= String.ValueOf(rq.prntcnt__c);
                        servReq.agNo= rq.xccn__c;
                        servReq.oracleId = rq.Acc__r.ORACLE_PARTY_ID__c;
                        servReq.axsReqId = rq.Id;
                    }
                }
                serviceReqList.add(servReq);
                sr.reqs = serviceReqList;
                String jsonBody = JSON.serialize(sr);
                ws_call__c ws = new ws_call__c(rq_jsn__c = jsonBody, ws_typ__c = wsTyp, mtd_nm__c = wsMd,
                    intsts__c = 'Ready for Integration', uid__c = rq.id + '' + ri.Id + '' + ri.sta__c + system.now() + wsMd,
                    rq_itm__c = ri.id);
                wsList.add(ws);
            }
            Insert wsList;
            System.debug('<insertRecord> Inserted WS records for courier Status Update.');
        }
        catch (Exception e) {
            System.debug('#EXCEPTION: ' + e.getMessage() + ' ##StackTrace: ' + e.getStackTraceString());
        }
    }

    public class serviceRequest {public List<serviceReq> reqs;}
 //   public class serviceReq {public String SRN, AWB, status, delStatus, timeStamp;}
      public class serviceReq {public String SRN, AWB, status, delStatus, timeStamp, acName, conName, oracleId, docType, refMobile, delZone, bldngName, delLoc, notes, axsReqId, noCheques, agNo;}

    public static void  wsCourBooking(String rqid) {

             g_req__c rq = [SELECT Id, Name, xawb__c, srvc__r.uid__c, xanum__c, Zone__c, rmob__c,
                 xaloc__c, Full_Name__c, Acc__r.Name, xbn__c, xbrnd__c, CreatedBy.Name FROM g_req__c WHERE id=:rqid LIMIT 1];

            List<g_reqitem__c> itm = [SELECT id, name, sta__r.cd__c, sta__r.Courier_Stage__c, xcub__c, xcasc__c, exp__c from g_reqitem__c where rq__c=:rqid LIMIT 1];

            XMLParserforEmpostWebservice pe = new XMLParserforEmpostWebservice();
            pe.createdon=Datetime.now();
            String courierType = label.courierType;
            //String courType = rq.srvc__r.uid__c=='196' ? 'Delivery' : 'Collection';
            String courType = courierType.Contains(rq.srvc__r.uid__c) ? 'Delivery' : 'Collection';
            pe.uid=itm[0].id+itm[0].sta__r.cd__c+false+courType+Datetime.now().format('ddmmyyyyHH');
            String bookingXML = pe.BuildXMLforCreateBooking(rq, courType);

            ws_call__c ws = new ws_call__c(rq_jsn__c=bookingXML, ws_typ__c='Courier Booking',
                mtd_nm__c='Courier Booking', intsts__c='Ready for Integration', rq_itm__c=itm[0].id,
                uid__c = rq.id + '' + itm[0].Id + '' + itm[0].sta__c + system.today() + 'Courier Booking');

            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert ws;
            }
            System.debug('ws - Courier Booking : ' + ws.Id);
    }
}
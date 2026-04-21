global class BatchCourBooking implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query ='SELECT Id, err_cd__c, rq_jsn__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c  From ws_call__c where ws_typ__c = \'Courier Booking\' AND mtd_nm__c = \'Courier Booking\' AND intsts__c =\'Ready for Integration\' ORDER BY createdDate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ws_call__c> scope) {

        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_cmb__c> culst=new list<g_cmb__c>();

        String awbno=''; Boolean isAdoch = false; String stage='Delivery';Datetime createdon=Datetime.now();

        for (ws_call__c ws: scope) {

            if (ws.intsts__c == 'Ready for Integration') {
                XMLParserforEmpostWebservice cour= new XMLParserforEmpostWebservice();
                stage = (ws.rq_itm__r.RQ__r.srvc__r.uid__c=='196')?'Delivery':'Collection';
                g_reqitem__c ri = new g_reqitem__c(id=ws.rq_itm__r.Id);
                g_req__c rq     = new g_req__c(id=ws.rq_itm__r.RQ__r.Id);
                ri.xcub__c         = stage;
                ws.intsts__c     = 'Failed';
                String uid         = ri.id+ws.rq_itm__r.sta__r.cd__c+isAdoch+stage+Datetime.now().format('ddmmyyyyHH');
                cour.uid         = uid;
                String CB         = cour.CreateBooking(ws.rq_itm__r.RQ__r.Name, ws.rq_jsn__c);
                System.debug('!!!! ri.sta__c : ' + ws.rq_itm__r.sta__c + ' id: ' + ri.id);
                if (CB != null) {
                    list<XMLParserforEmpostWebservice.XMLtoApex> lstxml = cour.XMLParser(CB);
                    if (lstxml != null) {
                        if (ri != null) {
                            awbno=lstxml[0].AIRWAYBILL;
                            culst.add(new g_cmb__c(xawb__c=Long.valueOf(lstxml[0].AIRWAYBILL),
                                coubdt__c=createdon, uid__c=uid, sta__c='At Dispatcher', adh__c=isAdoch,
                                tmpstamp__c=Datetime.now(), itm__c=ri.id, xcb__c=stage, itmsta__c=ws.rq_itm__r.sta__c,
                                xccpd__c=lstxml[0].CourierName));
                            ws.intsts__c = 'Success';
                        }
                    }
                }else{
                    awbno='0';
                    culst.add(new g_cmb__c(xawb__c=0, sta__c='At Dispatcher', tmpstamp__c=Datetime.now(),
                        uid__c=uid, coubdt__c=createdon, itm__c=ri.id, adh__c=isAdoch,
                        xcb__c=stage, itmsta__c=ws.rq_itm__r.sta__c, xccpd__c='NA'));
                }

                //if (!culst.isEmpty()) {insert culst;}
                wsList.add(ws);
            }
        }

        if (Schema.sObjectType.g_cmb__c.isCreateable()) { if (!culst.isEmpty()) {insert culst;} }
        if (Schema.sObjectType.ws_call__c.isUpdateable()) { if (wsList.size()>0) {update wsList;} }
    }

    global void finish(Database.BatchableContext BC) {}

}
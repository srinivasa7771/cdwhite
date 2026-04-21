@RestResource(urlMapping='/UpdateRequestsStatusAXSCCRM/*')
global with sharing class UpdateRequestStatusAXSCCRM {

    @HttpPost
    global static void updateStatus() {

        Set<String> eligibleServiceCode =new Set<String>{'196'};
        RestContext.response.addHeader('Content-Type', 'application/json');
        UpdateResponse resp = new UpdateResponse();
        ws_call__c logRec = initLog();

        try {
            String reqBody = RestContext.request.requestBody == null
                ? null
                : RestContext.request.requestBody.toString();

            logRec.rq_jsn__c = reqBody;

            if (String.isBlank(reqBody)) {
                fail(resp, logRec, 'VE_00', 'Request body cannot be empty.');
                return;
            }

            StatusWrapper req = (StatusWrapper) JSON.deserialize(reqBody, StatusWrapper.class);
            if (!validateRequest(req, resp, logRec)) {
                return;
            }

            g_req__c requestRec = fetchRequest(req);

            if (!eligibleServiceCode.contains(requestRec.srvc__r.uid__c)) {
                fail(resp, logRec, 'VE_04', 'Request is not configured for this service.');
                return;
            }

            if (requestRec.srvc__r.uid__c == '196') {
                resp = updateLeaseRenewalStatus(requestRec, req.status);
            }

            logRec.ws_typ__c = 'axsLeaseRenewal';
            logRec.res_jsn__c = JSON.serialize(resp);
            logRec.intsts__c  = resp.respCode == '200' ? 'Success' : 'Failed';
            insert logRec;

            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
        }
        catch (QueryException qe) {
            fail(resp, logRec, 'EXC_03', 'Invalid requestId. Record not found.');
        }
        catch (Exception e) {
            fail(resp, logRec, 'EXC_01', 'Unexpected error: ' + e.getMessage());
        }
    }

    public static UpdateResponse updateLeaseRenewalStatus(g_req__c rq, String courierStatus) {

        UpdateResponse resp = new UpdateResponse();
        Set<Id> serviceItemIds = new Set<Id>();

        List<g_reqitem__c> items = rq.Items__r;

        if (items.isEmpty()) {
            resp.respCode = 'VE_10';
            resp.respMsg  = 'No eligible items found for this request.';
            return resp;
        }

        for (g_reqitem__c item : items) {
            if (item.itm__c != null) {
                serviceItemIds.add(item.itm__c);
            }
        }

        /* Fetch courier mappings once */
        Map<Id, Courier_Status__c> statusMap = new Map<Id, Courier_Status__c>();
        for (Courier_Status__c cs : [ SELECT srvitm__c, Req_STA__c, itmSTA__c, itmSTA__r.Name FROM Courier_Status__c WHERE Courier_Status__c = :courierStatus
            AND srvitm__c IN :serviceItemIds
        ]) {
            statusMap.put(cs.srvitm__c, cs);
        }

        if (statusMap.isEmpty()) {
            resp.respCode = 'VE_03';
            resp.respMsg  = 'Invalid courier status for all request items.';
            return resp;
        }

        /* Apply updates */
        List<g_reqitem__c> itemsToUpdate = new List<g_reqitem__c>();
        String newReqStatus;

        for (g_reqitem__c item : items) {
            Courier_Status__c cs = statusMap.get(item.itm__c);
            if (cs != null) {
                System.debug('cs.itmSTA__c :'+cs.itmSTA__r.Name);
                System.debug('item.Name :'+item.Name);
                item.sta__c = cs.itmSTA__c;
                itemsToUpdate.add(item);
                newReqStatus = cs.Req_STA__c;
            }
        }

        if (itemsToUpdate.isEmpty()) {
            resp.respCode = 'VE_11';
            resp.respMsg  = 'No items eligible for status update.';
            return resp;
        }

        if (newReqStatus != null) {
            rq.STA__c = newReqStatus;
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update rq;
            }
        }

        if (!itemsToUpdate.isEmpty()) {
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update itemsToUpdate;
            }
        }

        resp.respCode  = '200';
        resp.respMsg   = 'Request status updated successfully.';
        resp.requestId = rq.Id;
        resp.newStatus = rq.STA__c;

        return resp;
    }

    private static g_req__c fetchRequest(StatusWrapper req) {
        return [
            SELECT Id, STA__c, srvc__r.uid__c,
                (SELECT Id, name, itm__c, sta__c
                 FROM Items__r
                 WHERE sta__r.Name != 'Courier Initiated')
            FROM g_req__c
            WHERE Id = :req.requestId
            LIMIT 1
        ];
    }

    private static Boolean validateRequest(StatusWrapper req, UpdateResponse resp, ws_call__c logRec) {
        if (String.isBlank(req.requestId)) {
            fail(resp, logRec, 'VE_01', 'requestId cannot be blank.');
            return false;
        }
        if (String.isBlank(req.status)) {
            fail(resp, logRec, 'VE_02', 'status cannot be blank.');
            return false;
        }
        return true;

    }

    private static ws_call__c initLog() {
        ws_call__c w = new ws_call__c();
        w.mtd_nm__c = 'updateAxsRequestStatus';
        return w;
    }

    private static void fail(UpdateResponse resp, ws_call__c logRec, String code, String msg) {
        resp.respCode = code;
        resp.respMsg  = msg;
        logRec.res_jsn__c = msg;
        logRec.intsts__c  = 'Failed';
        insert logRec;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    global class StatusWrapper {
        public String requestId;
        public String status;
    }

    global class UpdateResponse {
        public String respCode;
        public String respMsg;
        public String requestId;
        public String newStatus;
    }
}
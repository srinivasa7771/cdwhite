@RestResource(urlMapping='/CreateRequestsAXSCCRM/*')
global with sharing class CreateRequestAXSCCRM {

    @HttpPost
    global static void createRequest() {

        System.debug('reqBody : ' + RestContext.request.requestBody.toString());
        RestContext.response.addHeader('Content-Type', 'application/json');
        RequestResponse  resp = new RequestResponse();
        try{

            CreateRequestWrapper requestJSON = (CreateRequestWrapper)JSON.deserialize(RestContext.request.requestBody.toString(), CreateRequestWrapper.class);
            System.debug('requestJSON : ' + requestJSON);

            if (String.isBlank(requestJSON.methodName)) {
                resp.respCode = 'VE_01';
                resp.respMsg = '#ValidationError, methodName cannot be blank.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            if (requestJSON.methodName.equalsIgnoreCase('createLeaseRenewalRequest')) {
                resp = createLeaseRenewalRequest(requestJSON.reqJson);
                System.debug('resp :'+resp);
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

        }
        catch (JSONException je) {
            resp.respCode='EXC_02';
            resp.respMsg='Invalid JSON String.';
            system.debug(je.getMessage()+ ' ' +je.getStackTraceString());
        }
        catch (Exception e) {
            resp.respCode='EXC_01'; resp.respMsg='#Error : ' + e.getMessage();
            system.debug('#EXCEPTION: '+e.getMessage() + ' #StackTrace: ' +e.getStackTraceString());
        }
    }

    public static RequestResponse createLeaseRenewalRequest(String reqJson) {

        RequestResponse  resp = new RequestResponse();
        Account acc = new Account();
        // Parse JSON safely
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(reqJson);
        if (jsonMap == null || jsonMap.isEmpty()) return resp;

        // Extract data from JSON
        String renewalOppId   = (String) jsonMap.get('OppdId');
        String email           = (String) jsonMap.get('email');
        String axsAccId        = (String) jsonMap.get('axsAccId');
        String oraclePartyId   = (String) jsonMap.get('oraclePartyId');
        String hseStatus   = (String) jsonMap.get('hseStatus');
        String ccrmAccId   = (String) jsonMap.get('ccrmAccId');
        String tcode   = (String) jsonMap.get('tcode');
        String leaseEndDate =  (String) jsonMap.get('leaseStartDate');
        String agNumber =  (String) jsonMap.get('agNumber');

        if (axsAccId != null) {
            acc = [select id, Manager_Mobile__c, Manager_Email__c, lPrk__c from account where id=:axsAccId];
        }

        if (String.isBlank(renewalOppId) || String.isBlank(email) || String.isBlank(axsAccId) || String.isBlank(oraclePartyId) || String.isBlank(leaseEndDate)) {
            resp.respCode = 'VE_01';
            resp.respMsg = '#ValidationError, required parameters are missing.';
            return resp;
        }
        // Create request record
        g_req__c req = new g_req__c(
            xceml__c   = email,
            Acc__c     = acc.Id,
            PRM_Email__c     = acc.Manager_Email__c,
            PRM_MobileNo__c  = acc.Manager_Mobile__c,
            xtcid__c   = oraclePartyId,
            ccrmldid__c = renewalOppId,
            srvc__c    = gu.csStr('srvc_leaserenewal'),
            STA__c     = 'Open',
            xdedc__c  = hseStatus,
            InsChk__c = hseStatus == 'Applicable' ? true : false,
            rtacn__c = tcode,
            xanum__c =agNumber,
            rmob__c = acc.Manager_Mobile__c,
            xled__c = Date.valueOf(leaseEndDate)
        );

        try{
            if (Schema.sObjectType.g_req__c.isCreateable()) {
                insert req;
            }
            g_req__c rq = [SELECT id, Acc__c, name, ccrmldid__c from g_req__c where id=:req.id];

            Map<String, String> responseMap = new Map<String, String>();
            responseMap.put('requestId', rq.Id);
            responseMap.put('axsAccId', axsAccId);
            responseMap.put('renewalOppId', renewalOppId);
            responseMap.put('ccrmAccId', ccrmAccId);

            String responseJson = JSON.serialize(responseMap);
            List<ws_call__c> wsListToInsert = new List<ws_call__c>();

            ws_call__c wsRecord = new ws_call__c();
            wsRecord.rq_jsn__c = reqJson;
            wsRecord.ws_typ__c ='axsLeaseRenewal';
            wsRecord.mtd_nm__c ='createLeaseRenewalRequest';
            wsRecord.intsts__c = 'Ready for Integration';
            wsRecord.res_jsn__c= responseJson;
            wsListToInsert.add(wsRecord);

            resp.respCode   = '0';
            resp.respMsg    = 'Lease Renewal Request # ' +rq.name + ' has been created successfully' ;
            resp.requestId =  rq.Id;
            resp.axsAccId = rq.Acc__c;

            if (!wsListToInsert.isEmpty()) {
                if (Schema.sObjectType.ws_call__c.isCreateable()) {
                    insert wsListToInsert;
                }
            }
            return resp;
        }catch (Exception e) {
            system.debug('#EXCEPTION: '+e.getMessage() + ' #StackTrace: ' +e.getStackTraceString());
            resp.respCode   = '1';
            resp.respMsg    = 'Error while inserting the Lease Renewal request. Error : '+e.getMessage();
            return resp;
        }
    }

    global class CreateRequestWrapper {
        public String methodName;
        public String reqJson;
    }

    global class RequestResponse {
        public String respCode, respMsg, requestId, axsAccId;
    }
}
@RestResource(urlMapping='/courierWebhook/*')
global class ctrlEmpostWebhook {

    @HttpPost
    global static void processData() {
        StatusResponse res = new StatusResponse();
        String reqBody  = RestContext.request.requestBody.toString();
        system.debug('reqBody:'+reqBody);
        ctrlEmpostWebhook.ReqData rqData = (ctrlEmpostWebhook.ReqData)JSON.deserialize(reqBody, ctrlEmpostWebhook.ReqData.class);
        if (!string.isBlank(rqData.AWB_Number)) {
            List<g_cmb__c> cmbDataList = [Select id, sta__c, xnts__c, xupr__c, tmpstamp__c, IDType__c,
                IDName__c, IDNumber__c, IDExpiry__c, itm__c, itm__r.RQ__c, itm__r.sta__c, itm__r.itm__c from g_cmb__c where AWB__c =: rqData.AWB_Number limit 1];
            system.debug('----cmbDataList---'+cmbDataList);
            if (!cmbDataList.isEmpty()) {
                cmbDataList[0].sta__c= rqData.Status;
                cmbDataList[0].xnts__c= rqData.Remarks;
                if (String.isNotBlank(rqData.IDName) && rqData.Status == 'Shipment Delivered')
                    cmbDataList[0].xnts__c= (String.isNotBlank(rqData.Remarks)) ? (rqData.Remarks +'-Delivered to:'+rqData.IDName) : 'Delivered to:'+rqData.IDName;
                cmbDataList[0].xupr__c= rqData.UndeliveredReason;//ConsigneeContactName
                string ts = rqData.Time_Stamp;
                cmbDataList[0].tmpstamp__c= rqData.Time_Stamp != null?gU.strDateTime(rqData.Time_Stamp).addhours(-4):NULL;//ts != null?dt:NUll;
                system.debug('--SF Time Stamp--'+cmbDataList[0].tmpstamp__c);
                cmbDataList[0].IDType__c= rqData.IDType;
                cmbDataList[0].IDName__c= rqData.IDName;
                cmbDataList[0].IDNumber__c= rqData.IDNumber;
                cmbDataList[0].IDExpiry__c= (rqData.IDExpiry != null && rqData.IDExpiry !='' && rqData.IDExpiry.length() >= 14)?Date.valueOf(gU.strDateTime(rqData.IDExpiry)):NULL;
                //ie != NULL?idedt:Null;
                update cmbDataList[0];
                List<Courier_Status__c> csLst = [select id,
                    itmSTA__c, itmSTA__r.rqSTA__c from Courier_Status__c where srvitm__c=:cmbDataList[0].itm__r.itm__c and curSTA__c=:cmbDataList[0].itm__r.sta__c and Courier_Status__c=:rqData.Status];
                if (csLst != null && !csLst.isEmpty()) {
                    system.debug('Testing GitHUb US 2');
                    g_reqitem__c ri = new g_reqitem__c(id=cmbDataList[0].itm__c);
                    ri.sta__c = csLst[0].itmSTA__c;
                    if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                        update ri;
                    }
                    if (String.isNotBlank(csLst[0].itmSTA__r.rqSTA__c)) {
                        g_Req__c rq = new g_Req__c(id=cmbDataList[0].itm__r.RQ__c, sta__c=csLst[0].itmSTA__r.rqSTA__c);
                        if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                            update rq;
                        }
                    }

                }

                res.msg = 'Success';
                res.msgcode = 'S';
            }
            else{
                res.msg = 'ERROR-No record found with provided AWB Number';
                res.msgcode = 'F';
            }
        }
        else {
            res.msg = 'ERROR-No record found with provided AWB Number';
            res.msgcode = 'F';
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }

    global class StatusResponse{
        webservice String msg {set;get;}
        webservice String msgcode {set;get;}
    }
    global class ReqData {
        webservice String AWB_Number, Reference_Number, Time_Stamp, Status, SubStatus, ConsigneeContactName,
            ConsigneeAddress, ConsigneeMobNumber, DateOfShipmentCreation, Remarks, IDType, IDName,
            IDNumber, IDExpiry, UndeliveredReason, POD ;
    }
    /*global static Datetime strDateTime(String dttm) {
        String[] dd=dttm.split(' ');
        String[] dt=dd[0].split('/');
        String[] tm=dd[1].split(':');
        Integer hrs=Integer.valueof(tm[0]);
        system.debug(hrs+'-----'+tm);
        if (dd[2]=='PM') {if (hrs == 12) {hrs=12;}else{hrs=hrs+12;}}
        if (dd[2]=='AM') {if (hrs == 12) {hrs=0;}}
        Datetime dtm = Datetime.newInstance(Integer.valueof(dt[2]), Integer.valueof(dt[0]), Integer.valueof(dt[1]), hrs, Integer.valueof(tm[1]), Integer.valueof(tm[2]));
        return dtm;
    }*/
}
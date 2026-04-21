global class BatchInsertVFS implements Database.Batchable < sObject > , Database.AllowsCallouts, Schedulable {
     public String queryString;
    public BatchInsertVFS()
    {
     try{
       queryString = 'Select id, name,rq_jsn__c,intsts__c,ws_typ__c,err_msg__c,res_jsn__c from ws_call__c where ws_typ__c=\'AutoInsertVFS\' AND intsts__c=\'Ready for Integration\'';
    }catch (Exception e){}
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {return Database.getQueryLocator(queryString);}
    global void execute(Database.BatchableContext BC, List < ws_call__c > scope) {
        //rq_jsn__c = req.xadtx3__c,intsts__c='Ready for Integration',ws_typ__c='AutoInsertVFS'
        for (ws_call__c wc : scope){
            try{
                insertVFSReq(wc.rq_jsn__c);
                wc.intsts__c = 'Success';
            }catch (Exception ex){ String error = ex.getMessage() + '  ' + ex.getStackTraceString(); if (error.length()>=15001){error.substring(0,15000);} wc.intsts__c = 'Failed'; wc.err_msg__c = error; System.debug('BatchInsertVFS exception: ' + ex.getMessage() + '  ' + ex.getStackTraceString() ); }

            update wc;
        }
    }
    //sampleData : '{"country":"Afganisthan","countrycode":"xaf","certificate":"Education certificate","university":"Issuing University Name","colladdress":"Address for Collection","contactnum":"527876543","contactperson":"TEST PERSON FOR CONTACT"}';
    public static void insertVFSReq(String vfsData){
        List<g_srvc__c> srvcVFS = [select id, name from g_srvc__c where uid__c = 'vfs' limit 1];
        if (srvcVFS.size()>0 && String.isNotBlank(vfsData)) { Map<string, Object> mapVFSData = (Map<string, Object>)Json.deserializeUntyped(vfsData); String relatedReqID = (String)mapVFSData.get('reqstID'); /*check whether vfs request is already created for the same*/ List<g_req__c> existingVFSReq = [Select id, name from g_req__c where xrp__c= :relatedReqID]; if (existingVFSReq.size()==0){ /*toDo : assign the values dynamically*/ g_req__c reqVFS = new g_req__c(); reqVFS.xrp__c = relatedReqID; reqVFS.sta__c = 'Under Review'; reqVFS.Acc__c = (ID)mapVFSData.get('accid'); reqVFS.xcsnc__c = (String)mapVFSData.get('country');             /*Sponsor Nationality*/ reqVFS.xadh__c = (String)mapVFSData.get('countrycode')+';vfs;'; reqVFS.xvnum__c = (String)mapVFSData.get('certificate');        /*    Primary Vehicle Number*/ reqVFS.xpveh__c = (String)mapVFSData.get('university');            /*    Primary Vehicle Number*/ reqVFS.xcst__c = (String)mapVFSData.get('colladdress');            /*    Coast Guard #*/ reqVFS.xcmob__c = (String)mapVFSData.get('contactnum');            /*    Mobile*/ reqVFS.xcsfn__c = (String)mapVFSData.get('contactperson');        /*    */ reqVFS.xadtx3__c = vfsData; reqVFS.srvc__c = srvcVFS[0].id; insert reqVFS; } }
      }
    global void finish(Database.BatchableContext BC) {}
    global void execute(SchedulableContext sc) { database.executeBatch(new BatchInsertVFS(),1);}
}
@RestResource(urlMapping='/dhamedservc/*')
global class DHAMedicalStatService {

    
    @HttpPost
    global static void doPost() {
        
        StatusResponse res = new StatusResponse();
        String reqBody  = RestContext.request.requestBody.toString();
        system.debug('Req Body::'+reqBody);
        DHAMedicalStatService.ReqData rqData = (DHAMedicalStatService.ReqData)JSON.deserialize(reqBody,DHAMedicalStatService.ReqData.class);
        
        if(rqData.appicationNum != null && rqData.appicationNum != ''){
           List<g_reqitem__c> riLst = [select id,xf__c,itm__c,sta__c from g_reqitem__c where xf__c=:rqData.appicationNum and itm__r.cd__c in ('md','moh') limit 1];
            if(riLst != null && !riLst.isEmpty()){
                 Map<String,id> stsMp = new Map<String,id>(); 
             for(g_srvcitm_Status__c sts : [select id,cd__c,Name from g_srvcitm_Status__c where itm__c=:riLst[0].itm__c])
                stsMp.put(sts.cd__c,sts.id);
                if(rqData.status == '5' || rqData.status == '7'){
                    riLst[0].sta__c = stsMp.get('ok');
                    riLst[0].xmid__c = date.today();
                    riLst[0].xmed__c = date.today().addMonths(3); 
                }
               else
                 riLst[0].sta__c = stsMp.get('u'); 
                
               update riLst; 
              res.msg = 'Success'; 
              res.msgcode = 'S';
            } 
           else
           {
                res.msg = 'ERROR-No records exist with provided Application Number'; 
                res.msgcode = 'F';
           }   
            
        }
        else
        {
            res.msg = 'ERROR Message'; 
            res.msgcode = 'F';
        }  
        system.debug('res Message::'+res.msg);
        RestContext.response.addHeader('Content-Type', 'application/json'); 
        //return res;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }
    
    global class StatusResponse{
        webservice String msg {set;get;}
        webservice String msgcode {set;get;}    
    }
    global class ReqData {
        webservice String appicationNum, status;
    }
}
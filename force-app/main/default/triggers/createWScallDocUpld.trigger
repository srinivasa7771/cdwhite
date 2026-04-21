trigger createWScallDocUpld on ws_call__c (after update) {
List<g_Req__c> rqList= new List<g_Req__c>();
List<g_reqDoc__c> rqDocList = new List<g_reqDoc__c>();
for(ws_call__c ws: Trigger.new){
ws_call__c oldws = Trigger.oldMap.get(ws.Id);
if(oldws.is_pro__c!= ws.is_pro__c && ws.is_pro__c== true && ws.mtd_nm__c=='generatePolicy'){
rqList.add(ws.rq_itm__r.RQ__r);

}
 If(rqList.size()>0){
 //Create the new jason 
 rqDocList = [Select Id from g_reqDoc__c where RQ__c in:rqlist  AND Name = 'Passport Copy'];
 
 
 }
}

}
global class axsAmendCheckBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {
    public String queryString;public String mm;
    public axsAmendCheckBatch() {
        queryString = 'Select id, xmloc__c, xmamd__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.lc__c from g_req__c where srvc__r.uid__c=\'208\' and (STA__c=\'Draft\' OR  STA__c=\'Open\')';
    }
    // If mm is month and Integer x if 0 today and if 1 chosen Date
public axsAmendCheckBatch(String mm, Integer x ) { this(); if (x == 1) { queryString += 'and CALENDAR_MONTH(CreatedDate)=' + mm; }if (x == 0) { queryString += 'and CreatedDate= Today' ; } }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug(queryString);
        queryString+=' limit 999';
        return Database.getQueryLocator(queryString);  //where xdrv__c=true
    }

    global void execute(Database.BatchableContext BC, List <g_req__c> scope) {

        List<g_Req__c> newRqList = new List<g_Req__c> ();
        try{
            for (g_Req__c rq:scope) {

                List<grqWsDccaGetService.Records> tecomLeaseList = new  List<grqWsDccaGetService.Records>();
                List<grqWsDccaGetService.Records> d3LeaseList = new  List<grqWsDccaGetService.Records>();
                map<String, String> dccaStatusMap = new map<String, String>();
                Boolean amedFlag;
                String agreeNoAmd ='';
                if (rq.Acc__r.ORACLE_PARTY_ID__c != null) {
                    tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(rq.Acc__r.ORACLE_PARTY_ID__c);
                    system.debug('######################tecomLeaseList#############################');
                    system.debug(tecomLeaseList);
                    d3LeaseList = grqWsDccaGetService.loadD3Loc(rq.Acc__r.ORACLE_PARTY_ID__c);
                }
                system.debug('######################d3LeaseList#############################');
                if (d3LeaseList != null && !d3LeaseList.isEmpty() && d3LeaseList.size()>0) {
                    tecomLeaseList.addAll(d3LeaseList);
                }
                if (tecomLeaseList != null && tecomLeaseList.size()<1) {rq.xmloc__c = true; }else { rq.xmloc__c = false;} agreeNoAmd ='';
                if (tecomLeaseList != null && !tecomLeaseList.isEmpty() && tecomLeaseList.size()>0) {
                    List<grqWsDccaGetService.Records> filteredLeaseList =grqWsDccaGetService.filterCategories(tecomLeaseList);
                    for (grqWsDccaGetService.Records rc:filteredLeaseList) {
                        if (rc.AgNo != null && rc.AgNo !='null' && (rc.AgNo).length()>0 && (rc.RenewalOpp == null || rc.RenewalOpp=='')) {
                            string sta=rc.ContractStatusReason;
                            if (sta=='Active' || sta=='Under Termination' ||  sta=='Lease Printed' || sta=='Customer sign'  || sta=='Customer Signed' || sta=='Tecom Sign' || sta=='Tecom Signed' || sta=='Ready for Activation' || (sta.contains('Collected by BP')) || (sta.contains('Signed by BP')) || (sta.contains('Counter Signed')) || (sta.contains('Ready for Activation'))) {
                                sta='Active' ;
                            }
                            if (!(dccaStatusMap.containsKey(rc.AgNo)) || ((dccaStatusMap.containsKey(rc.AgNo)) && (!dccaStatusMap.get(rc.AgNo).contains(sta)) && (dccaStatusMap.get(rc.AgNo).contains('true'))) || ((dccaStatusMap.containsKey(rc.AgNo)) && sta=='Active' && (dccaStatusMap.get(rc.AgNo).contains('false'))) ) {
                                if (rc.ContractStatusReason!='Draft' && rc.ContractStatusReason!='Lease Verified' && rc.ContractStatusReason!='Printed' && rc.ContractEndDate != null &&  (Date.valueOf(grqWsDccaGetService.formatDt2(grqWsDccaGetService.formatDt(rc.ContractEndDate)))>Date.today())) {
                                    amedFlag = true; If(String.isBlank(agreeNoAmd)) { agreeNoAmd = +'*'+rc.AgNo;   }else{ agreeNoAmd =  agreeNoAmd +', ' +'*'+ rc.AgNo;  }
                                }
                            }  }}}
                If(String.isBlank(agreeNoAmd)) {rq.xmamd__c = true;}else{rq.xmamd__c = false;}

                newRqList.add(rq);
            }

            if (newRqList != null && newRqList.size()>0) {
                Update newRqList;
            }
        }catch (System.Exception e) { System.debug('ERROR: ' + e);}
    }

    global void finish(Database.BatchableContext BC) {}

}
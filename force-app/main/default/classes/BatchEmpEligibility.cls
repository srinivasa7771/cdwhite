public class BatchEmpEligibility implements Database.Batchable < sObject >, Database.AllowsCallouts, Schedulable {
    public String queryString;
    public String batchName;
    public List<String> opLst;
    public BatchEmpEligibility(List<String> opilst, String executeBatchName) {
        batchName = executeBatchName;
        opLst = opilst;
        queryString ='select id, lc__c, isIN5__c, vespe__c, tvespe__c, clt__c, ORACLE_PARTY_ID__c, Acc_Type__c, Type, VIP__c, name, licn__c, licnarb__c, on__c, onar__c, Legal_Framework__c, vcspst__c, vcspe__c, vcid__c, vcac__c, lcidt1__c from Account where ORACLE_PARTY_ID__c=:opLst';
    }
    public BatchEmpEligibility(String executeBatchName) {
        batchName = executeBatchName;
        queryString ='select id, lc__c, isIN5__c, vespe__c, tvespe__c, clt__c, ORACLE_PARTY_ID__c, Acc_Type__c, Type, VIP__c, name, licn__c, licnarb__c, on__c, onar__c, Legal_Framework__c, vcspst__c, vcspe__c, vcid__c, vcac__c, lcidt1__c from Account where lc__c !=\'\' and ORACLE_PARTY_ID__c  != \'\' and ORACLE_PARTY_ID__c  != \'999999999\' and lctp__c!=\'DED\' and (type=\'Customer - External\' or type=\'Customer - IN5\' or type=\'Customer - LAS\' or type=\'Customer - Outsourcing\') and  Legal_Framework__c!=\'Freelancer\' and isDeleted=false';
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {return Database.getQueryLocator(queryString);}
    public void execute(Database.BatchableContext bc, list<Account>  lst) {
        system.debug('execute::::');
        Account acc = lst[0];

        List<g_Req__c> rqLst = [select id, os__c, DDA_INV__c, name, xadtx3__c, xdccaRq__c,
            xadtx2__c, xdei__c, xadh__c, acc__c, acc__r.id, acc__r.lcedt__c,
                skpu__c from g_Req__c where acc__r.id=:acc.id and srvc__r.uid__c='216' and sta__c!='Cancelled' and  sta__c!='Rejected' and createddate=Last_N_DAYS:300  limit 1];

        if (rqLst != null && rqLst.size()>0 && String.isNotBlank(rqLst[0].xdccaRq__c)) {
            String res = grqWsDccaGetService.getNewReqDetails(rqLst[0].xdccaRq__c);
            if (res != null && String.isNotBlank(res)) {
                grqWsDccaGetService dccaResp= (grqWsDccaGetService) System.JSON.deserialize(res , grqWsDccaGetService.class);
                if (dccaResp != null && dccaResp.Data[0].sme == 'SME-In5' && !acc.isIN5__c) {
                    acc.Type='Customer - IN5';
                }
            }
        }

        /*grqWsEligibility.ElgRes res = grqWsEligibility.getEligibilityCnt(acc.ORACLE_PARTY_ID__c, 'Visa');
        system.debug('res.elgCnt:::'+res.elgCnt);
        system.debug('acc.vespe__c :::'+acc.vespe__c);
        if (res.elgCnt != 0 && acc.vespe__c != res.elgCnt ) {
            acc.tvespe__c = res.elgCnt;
            if (String.isBlank(acc.clt__c) || (String.isNotBlank(acc.clt__c) && acc.clt__c != 'PMS Lease') ) {
             if (acc.vespe__c < res.elgCnt) {
                acc.vespe__c = res.elgCnt;
             }
             else if (!acc.VIP__c) { //else if (!acc.VIP__c && acc.vespe__c <= 15 && clt__c != PMS Lease'//) {
                acc.vespe__c = res.elgCnt;
             }
           }
         }
         if (res.accType == 'Customer - IN5' && acc.Type != 'Customer - IN5') {
                acc.Type = res.accType;
          }*/
            //Update account details
            acc=setSponEmpAndStudCount(acc);
            acc=grqWsOnboard.updateAccName(acc);
            if (Schema.sObjectType.Account.isUpdateable()) {
                update acc;
            }

    }

    private Account setSponEmpAndStudCount(Account Acc) {
        Map<String, Integer>EligCountMap = new Map<String, Integer>();
        Integer sponCount=0;
        Integer acCount=0;
        Integer empCount=0;
        Integer studCount=0;

        system.debug('ACC'+Acc.id);
        for (AggregateResult aggRes : [select count(id),
            rol__c from contact  where sta__c IN ('Draft',
            'Active', 'Under Activation', 'Under Deactivation',
            'Under Absconder Declaration', 'Under Absconder Withdrawal',
            'Absconder Withdrawn') and rol__c IN ('Employee',
            'Non Sponsored', 'Access Card', 'Trainee',
            'Student') and Accountid=:acc.id  group by rol__c]) {
            system.debug('test:::');
            if (aggRes.get('rol__c') == 'Employee') {
                empCount =(Integer)aggRes.get('expr0');
            }
            else if (aggRes.get('rol__c') == 'Non Sponsored') {
                sponCount =(Integer)aggRes.get('expr0');
            }
            else if (aggRes.get('rol__c') == 'Access Card') {
                acCount = (Integer)aggRes.get('expr0');
            }
            else if (aggRes.get('rol__c') == 'Student') {
                studCount=(Integer)aggRes.get('expr0');
            }
        }
        acc.vcspe__c= empCount;
        acc.vcid__c = sponCount;
        acc.vcac__c= acCount;
        acc.vcspst__c=studCount;
        return acc;
    }
    public void finish(Database.BatchableContext bc) {
    }

    public void execute(SchedulableContext sc) {
        BatchEmpEligibility b = new BatchEmpEligibility('');
        database.executebatch(b, 1);
    }

}
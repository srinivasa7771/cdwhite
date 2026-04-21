public class dccaReqCreationBatchHelper {
    public static List<grqWsDccaGetService.Records> tecomLeaseList {get;set;}
    public static string leaseDt {get;set;}
    public static string loaction(Account Acc) {

        /*tecomLeaseList = new List<grqWsDccaGetService.Records> ();
        tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(Acc.ORACLE_PARTY_ID__c);

        List<grqWsDccaGetService.Records> d3LeaseList = grqWsDccaGetService.loadD3Loc(Acc.ORACLE_PARTY_ID__c);
        if (d3LeaseList != null && !d3LeaseList.isEmpty() && d3LeaseList.size()>0) {
            tecomLeaseList.addAll(d3LeaseList);
        }

        if (tecomLeaseList != null && tecomLeaseList.size()>0) {
            if (Acc.lcedt__c != null) { leaseDt=grqWsDccaGetService.getNewLicDt(tecomLeaseList, Acc.lcedt__c, Acc.Legal_Framework__c);}
        }

        if (leaseDt != null)
            leaseDt= grqWsDccaGetService.formatDt2(leaseDt);*/
        if (leaseDt == null) {
            leaseDt = String.ValueOf(Acc.lcedt__c);
        }
        system.debug('leaseDt'+leaseDt);
        String dccaRes = grqWsDccaGetService.getReqDetails(Acc.lc__c, leaseDt, Acc.dccaexId__c, false );
        if (String.isNotBlank(dccaRes)) {
            grqWsDccaGetService jj= (grqWsDccaGetService) System.JSON.deserialize(dccaRes, grqWsDccaGetService.class);
        }
        return dccaRes;
    }

}
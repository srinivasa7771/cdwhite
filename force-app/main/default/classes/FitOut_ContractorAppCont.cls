public class FitOut_ContractorAppCont {
    public String reqId;
    public g_Req__c fitOutReq{get;set;}
    public String buildingName{get;set;}
    public string PropertyUnit{get;set;}
    public FitOut_ContractorAppCont(ApexPages.StandardController controller) {
        reqId  = ApexPages.CurrentPage().getparameters().get('id');
   }
    public void fetchContData() {
        if (String.isNotBlank(reqId)) {
            fitOutReq = [Select id, xadtx2__c, xcfan__c from g_Req__c where id =: reqId];
            FitOutWebservice.fitOutWrapper adhocData = (FitOutWebservice.fitOutWrapper) System.JSON.deserialize(fitOutReq.xadtx2__c, FitOutWebservice.fitOutWrapper.class);
            PropertyUnit = adhocData.unitNumber;
            buildingName = adhocData.buildingName;
        }
    }
}
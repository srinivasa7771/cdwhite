global class BatchCourierReBooking implements Database.Batchable < sObject >, Database.AllowsCallouts {
    public String queryString;
    public String mm;
    public BatchCourierReBooking() {
        queryString ='SELECT Id, Name, xawb__c, itm__c, xcb__c, sta__c from g_cmb__c where xawb__c=0 and isdeleted=false limit 100 ';
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {return Database.getQueryLocator(queryString);}
    public void execute(Database.BatchableContext bc, list<g_cmb__c>  existingBooking) {
        XMLParserforEmpostWebservice cls = new XMLParserforEmpostWebservice();
        String itmId;
        g_Req__c rq;
        list<g_cmb__c> cmbList=new list<g_cmb__c>();
        list<g_reqitem__c> courBk;
        Set<Id> allItmIds = new Set<Id>();
        for (g_cmb__c cbPre : existingBooking) { allItmIds.add(cbPre.itm__c); }
        Map<Id, g_reqitem__c> itemMap = new Map<Id, g_reqitem__c>([SELECT Id, RQ__c, sta__c, nt__c, xcasc__c, exp__c, sta__r.Courier_Stage__c,
                sta__r.Courier_Notes__c, Name, RQ__r.Name, RQ__r.xbrnd__c, RQ__r.xbn__c, RQ__r.Zone__c,
                RQ__r.Acc__r.Name, RQ__r.Full_Name__c, RQ__r.xaloc__c, RQ__r.CreatedBy.Name, RQ__r.rmob__c from g_reqitem__c where Id IN :allItmIds]);
        for (g_cmb__c cb : existingBooking) {
            itmId=cb.itm__c;
            courBk = itemMap.containsKey(itmId) ? new List<g_reqitem__c>{itemMap.get(itmId)} : new List<g_reqitem__c>();
            g_reqitem__c ri=courBk[0];
            String returnVal;
            String stage=cb.xcb__c;
            rq=ri.Rq__r;
            if (ri.exp__c) {
                cls.assginedTo='X'+ri.xcasc__c;
            }
            else{
                cls.assginedTo=ri.xcasc__c;
            }
            String awbXML =cls.CreateBooking(rq, stage);
            if (awbXML != null) {
                list<XMLParserforEmpostWebservice.XMLtoApex> lstxml =cls.XMLParser(awbXML);
                if (lstxml != null) {
                    if (ri != null) {
                        cb.xawb__c=Long.valueOf(lstxml[0].AIRWAYBILL);
                        cb.sta__c='At Dispatcher';
                        cb.tmpstamp__c=Datetime.now();
                        cb.xccpd__c=lstxml[0].CourierName;
                        cmbList.add(cb);
                    }
                }
            }
        }
        if (!cmbList.isEmpty()) {
            if (Schema.sObjectType.g_cmb__c.isUpdateable()) {
                update cmbList;
            }
        }
    }
    public void finish(Database.BatchableContext bc) {}
}
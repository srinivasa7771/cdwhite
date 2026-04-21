public class AXSEmpostSyncSTA {
public  class empostSTAResp{
    public String type;
    public String zone;
    public String bookingDate;
    public String srs;
    public String awb;
    public String status;
    public String lastStatusDate;
    public String courierPerson;
    public String remarks;
    public String sender;
    public String receiver;
}
public List<empostSTAResp> courRplst = new List<empostSTAResp>();
public List<empostSTAResp> CreatedOn;
public List<empostSTAResp> updateList=new List<empostSTAResp>();
public  Map<String, empostSTAResp> respParser(String empostJson) {
    AXSEmpostSyncSTA parsedJSON = (AXSEmpostSyncSTA)System.JSON.deserialize(empostJson, AXSEmpostSyncSTA.class);
    List<empostSTAResp> respObj = parsedJSON.CreatedOn;
    Map<String, empostSTAResp> empObj = new Map<String, empostSTAResp>();
    for (empostSTAResp emp:respObj) {
        system.debug(emp.awb);
        empObj.put(emp.awb, emp);
    }
    return empObj;
}
public  Map<String, g_cmb__c>  getAXSCourierDetailsByCreatedDate(Date crDt) {
    List<g_cmb__c> courRecList=[select id, Name, xawb__c, AWB__c, itmsta__c, sta__c, tmpstamp__c,
        xupr__c, itm__c, itm__r.itm__c, xnsct__c from g_cmb__c  where DAY_ONLY(convertTimezone(createdDate)) = :crDt and   IsDeleted=false ORDER BY xawb__c];
    Map<String, g_cmb__c> axsObj = new Map<String, g_cmb__c>();
    for (g_cmb__c emp:courRecList) {
        axsObj.put(emp.AWB__c, emp);
    }
    return axsObj;
}
Public void sysnSTA(String crDt, Date dt, Boolean flag) {
    EmpostWebservice maincls = new EmpostWebservice();
    EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap();
    Map<String, empostSTAResp>  updateDetails=new  Map<String, empostSTAResp> ();
    list<g_cmb__c> upDetails=new list<g_cmb__c>();
    String[] key = gU.csStr('Courier_login').split(', ');
    String vlogin = cls.Login(key[0], key[1]);
    String returnVal = cls.GetDetailByCreatedOn(crDt, vlogin);
    AXSEmpostSyncSTA a=new AXSEmpostSyncSTA();
    Map<String, empostSTAResp> empObj=a.respParser(returnVal);
    Map<String, g_cmb__c> axsObj= getAXSCourierDetailsByCreatedDate(dt);
    for (String mkey:axsObj.keySet()) {
        if (axsObj.containsKey(mkey) && empObj.containsKey(mkey)) {
            g_cmb__c cb=axsObj.get(mkey.trim());
            empostSTAResp empost=empObj.get(mkey.trim());
            if (empost != null && cb != null && cb.sta__c != empost.status) {
                if (empost.status=='Transit') {
                    cb.sta__c='Alloted';
                }
                else{
                    cb.sta__c=empost.status;
                }
                upDetails.add(cb);
            }
        }
    }
    if (true) {
        if (Schema.sObjectType.g_cmb__c.isUpdateable()) {
            update upDetails;
        }
    }
}
}
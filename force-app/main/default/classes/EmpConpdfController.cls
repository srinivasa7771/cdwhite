public class EmpConpdfController {
    public g_Req__c req{get;set;}
    public String gSal{get;set;}
    public String reqId{get;set;}
    public String empDuration {get;set;}
    public date doj {set;get;}
    public decimal othAllowances {get;set;}
    public EmpConpdfController() {
        reqId = apexpages.currentpage().getparameters().get('id');
        othAllowances = 0;
        if (reqId != null ||reqId !='') {
            req = [SELECT id, xed__c, Name, Acc__r.name, Acc__r.lcarb__c, Acc__r.lc__c, xcjb__r.name,
                con__r.jd__c, Con__r.FlnAr__c, Con__r.name, xosln__c, xcp__c, xcma__c, xcmta__c,
                xcmoa__c, xcmbs__c, xcped__c, srvc__r.name, cldt__c FROM g_Req__c WHERE id=:reqId];
            Apexpages.currentPage().getHeaders().put('content-disposition', ' filename=Key Employment Contract - '+req.name+'.pdf');
           // if (String.isNotBlank(req.srvc__r.name))
              empDuration = string.isNotBlank(req.xed__c)?req.xed__c+' '+'Year(s)':'';

            if (req.cldt__c != null)
              doj = req.cldt__c;
            else if (req.con__r.jd__c != null)
              doj = req.con__r.jd__c;
            else{
               List<g_reqitem__c> rilst = [select id, xad__c from g_reqitem__c where RQ__c=:req.id and itm__r.cd__c ='ai'];
                if (rilst != null && !rilst.isEmpty()) {
                  doj = rilst[0].xad__c;
                }
            }

            othAllowances =  (req.xcma__c != null ? req.xcma__c : 0) + (req.xcmta__c != null ? req.xcmta__c : 0) + (req.xcmoa__c != null ? req.xcmoa__c : 0);
        }
    }

}
public class grqWsTecomInvoice {
    public ResponseData ResponseData;

    public class ReqData{
    public String AXSInvNo{set;get;}
    public String AgNo{set;get;}
    public string InvNo{set;get;}
    public string PaymentMethod{set;get;}
    public Date PaymentDate{set;get;}
     }
    public class ResponseData
    {
        public string AgNo{set;get;}
        public string AXSInvNo{set;get;} public string Error{set;get;}
        public boolean Success{set;get;} public string ResponseCode{set;get;}
    }

    public static void invWsCreation(g_Tran__c T, String ItemId, String agr , String Inv) {
        try{
        ReqData newInv = new ReqData();
        newInv.AXSInvNo = T.Name;
        newInv.AgNo = agr;
        newInv.InvNo = Inv;
        newInv.PaymentMethod = T.md__c;
        newInv.PaymentDate = T.dt__c;
        String jsonBody = JSON.serialize(newInv);
        ws_call__c ws = new ws_call__c();
        ws.rq_jsn__c = jsonBody;
        ws.rq_itm__c = ItemId;
        ws.ws_typ__c = 'TecomInvoice';
        ws.mtd_nm__c = 'InvoiceCreation';
        ws.intsts__c = 'Ready for Integration';
        ws.uid__c = T.RQ__r.name + system.now() +'TecomInvoice' ;
        if (Schema.sObjectType.ws_call__c.isCreateable()) {
            insert ws ;
        }
        }catch (Exception ex) {system.debug('invWsCreation exception:'+ex.getMessage());}
    }
}
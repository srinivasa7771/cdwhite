public class grqWsDccaInvoiceService {
    public class InvoiceInfoList {
        public List<Invoice> inv{set;get;}
    }
   public class Invoice {
       public string invNo{
           set;
           get;
       }
       public string invAmount{
           set;
           get;
       }
       public string payMethod{
           set;
           get;
       }
       public string refNo{
           set;
           get;
       }
       public string dccaSrId{
           set;
           get;
       }
       public string error{
           set;
           get;
       }
   }

  //  public class ServiceFee { public List<Fee> feeRec{set;get;}}
  //  public class Fee { public string servLine{set;get;} public string dccaSrId{set;get;} public string error{set;get;} }

  /** public static void wsFineCreation(string DccaId, String serviceLine, String ItemId) { ServiceFee serfee = new ServiceFee(); List<Fee>  feelist = new List<Fee> (); Fee newFee = new Fee(); newFee.servLine = serviceLine; newFee.dccaSrId =DccaId; feelist.add(newFee); serfee.feeRec = feelist; String jsonBody = JSON.serialize(serfee); ws_call__c ws = new ws_call__c(); ws.rq_jsn__c = jsonBody; ws.rq_itm__c = ItemId; ws.ws_typ__c = 'DccaExtraService'; ws.mtd_nm__c = 'fineCreation'; ws.intsts__c = 'Ready for Integration'; ws.uid__c = serviceLine+ DccaId+system.now() +'DccaFineCreation' ; insert ws ; }**/

    public static void invWsCreation(g_Tran__c T, String dccaId, String ItemId) {
        InvoiceInfoList invList = new InvoiceInfoList();
        List<Invoice> listInv = new List<Invoice>();
        Invoice newInv = new Invoice();
        newInv.invNo = T.Name;
        newInv.invAmount = String.ValueOf(T.A__c);
        newInv.payMethod = T.md__c;
        newInv.refNo = T.RQ__r.name;
        newInv.dccaSrId = dccaId;
        listInv.add(newInv);
        invList.inv = listInv;
        String jsonBody = JSON.serialize(invList);
        ws_call__c ws = new ws_call__c();
        ws.rq_jsn__c = jsonBody;
        ws.rq_itm__c = ItemId;
        ws.ws_typ__c = 'DccaExtraService';
        ws.mtd_nm__c = 'InvoiceCreation';
        ws.intsts__c = 'Ready for Integration';
        ws.uid__c = T.RQ__r.name + system.now() +'DccaInv' ;
        if (Schema.sObjectType.ws_call__c.isCreateable()) { if (!Test.isRunningTest()) insert ws ; }
    }

    public static  String dccaInvoiceCall( String jsonBody) {
        String returnjson='';
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/updateDccaInvoice');
        request.setMethod('POST');
        request.setTimeout(90000);
        request.setBody(jsonBody);
        response = h.send(request);

        if (response.getStatusCode() == 200 ) {
            returnjson = response.getBody();
        }else {
            returnjson = '';
        }
        return  returnjson   ;
    }

   /** public static  String dccaFineCall( String jsonBody) {
        String returnjson='';
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/CreateServiceFee');
        request.setMethod('POST');
        request.setTimeout(90000);
        request.setBody(jsonBody);
        response = h.send(request);

        if (response.getStatusCode() == 200 ) {
            returnjson = response.getBody();
        }else {
            returnjson = '';
        }
        return  returnjson   ;
    }**/

}
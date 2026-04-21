global class  dccaInvoiceandFineBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'DccaExtraService';
        String query = 'Select Id, DDA_id__c, DDA_Amt__c, err_cd__c, xrno__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where ws_typ__c = :type  AND intsts__c =\'Ready for Integration\' ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> finalList = new List<ws_call__c>();
        List<ws_call__c> wsfine = new List<ws_call__c>();
        Boolean fineflag = false;
        List<ws_call__c> wsInvoice= new List<ws_call__c>();
         List<ws_call__c> newwsInvoice= new List<ws_call__c>();
        Map<String, ws_call__c> invMap= new Map<String, ws_call__c> ();

         Map<String, ws_call__c> fineMap=new  Map<String, ws_call__c> ();
        for (ws_call__c ws : scope) {
            if (ws.mtd_nm__c =='InvoiceCreation') {
                wsInvoice.add(ws);
                invMap.put(ws.xrno__c, ws);
            } //else if (ws.mtd_nm__c =='fineCreation') {wsfine.add(ws);fineMap.put(ws.xrno__c, ws);fineflag = true;  }
        }

   /**     if (wsfine != null && wsfine.size()>0) {
            for (ws_call__c ws : wsfine) {
                //ws.res_jsn__c = grqWsDccaInvoiceService.dccaFineCall(ws.rq_jsn__c) ;
                if (ws.res_jsn__c != null && ws.res_jsn__c!='') {
                    grqWsDccaInvoiceService.ServiceFee reqjsRq =  (grqWsDccaInvoiceService.ServiceFee) JSON.deserialize(ws.res_jsn__c, grqWsDccaInvoiceService.ServiceFee.class);
                    system.debug('fine reqjsRq'+reqjsRq);
                    if (reqjsRq != null && reqjsRq.feeRec[0].error == null) {
                        ws.intsts__c = 'Success';
                        if (invMap.containsKey(ws.xrno__c)) {
                     /**       ws_call__c Invws =  invMap.get(ws.xrno__c);

                            Invws.res_jsn__c = grqWsDccaInvoiceService.dccaInvoiceCall(ws.rq_jsn__c) ;
                            if (Invws.res_jsn__c != null && Invws.res_jsn__c!='') {
                                grqWsDccaInvoiceService.InvoiceInfoList reqjsRq1 =  (  grqWsDccaInvoiceService.InvoiceInfoList) JSON.deserialize(Invws.res_jsn__c,
                                    grqWsDccaInvoiceService.InvoiceInfoList.class);
                                // system.debug('Inv reqjsRq'+reqjsRq);
                                if (reqjsRq1 != null && reqjsRq1.inv[0].error == null) {
                                    Invws.intsts__c = 'Success';
                                }else{
                                    Invws.intsts__c = 'Failed';
                                }

                            }else {
                                Invws.intsts__c = 'Failed';
                            }
                            finalList.add(Invws);**/
                  /**          invMap.remove(ws.xrno__c);
                        }
                    }else{
                        ws.intsts__c = 'Failed';
                    }

                }else {
                    ws.intsts__c = 'Failed';
                }
                finalList.add(ws);
            }
        }**/
       /** system.debug('wsfine.isEmpty()'+wsfine.isEmpty());
          system.debug('fineflag'+fineflag);
         system.debug('invMap'+invMap);**/
              if (wsInvoice != null && wsInvoice.size()>0 && (wsfine.isEmpty() && fineflag == false )) {
                  newwsInvoice.addAll(invMap.values());
            for (ws_call__c ws : newwsInvoice) { //wsInvoice
                g_Tran__c t=[select id, Name, Rq__r.name, md__c, dt__c from  g_Tran__c  where RQ__r.Name=:ws.xrno__c and tp__c='Payment' and STA__c='Completed'][0];
                system.debug('t---->'+t);
                List<Invoice> listInv = new List<Invoice>();
                InvoiceInfoList invList = new InvoiceInfoList();
                Invoice inv1=new Invoice();
                inv1.payMethod=t.md__c;
                inv1.refNo=t.Rq__r.name;
                inv1.axsPaymentDate=String.valueOf(t.dt__c);
                inv1.invDate=String.valueOf(t.dt__c);
                inv1.invNo=t.Name;
                inv1.dccaSrId=ws.DDA_id__c;
                inv1.invAmount=String.valueof(ws.DDA_Amt__c);
                listInv.add(inv1);
                invList.inv = listInv;
                ws.rq_jsn__c = JSON.serialize(invList);

                ws.res_jsn__c = grqWsDccaInvoiceService.dccaInvoiceCall(ws.rq_jsn__c) ;
                if (ws.res_jsn__c != null && ws.res_jsn__c!='') {
                    grqWsDccaInvoiceService.InvoiceInfoList reqjsRq =  (  grqWsDccaInvoiceService.InvoiceInfoList) JSON.deserialize(ws.res_jsn__c, grqWsDccaInvoiceService.InvoiceInfoList.class);
                    system.debug('Inv reqjsRq'+reqjsRq);
                    if (reqjsRq != null && reqjsRq.inv[0].error == null) {
                        ws.intsts__c = 'Success';
                    }else{
                        ws.intsts__c = 'Failed';
                    }

                }else {
                    ws.intsts__c = 'Failed';
                }
                finalList.add(ws);
            }
        }

        if (finalList != null && finalList.size()>0) {
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update finalList;
            }
        }
    }
    public class InvoiceInfoList {public List<Invoice> inv{set;get;}}
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
                          public string axsPaymentDate{set;get;}
                          public string invDate{set;get;}
                         }
    global void finish(Database.BatchableContext BC) {}

}
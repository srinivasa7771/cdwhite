/*  gTYardiInvCreation  is used for yardi invoice creation with tax 
 *  Method name : yardiInvCreation
 *
 *
 *
 */


public class gTYardiInvCreation {

    public class yrdResponse {
        public String errcd {
            set;
            get;
        }
        public String Errmsg {
            set;
            get;
        }
        public String resp {
            set;
            get;
        }
        public String status {
            set;
            get;
        }
    }

    public class yardiInv {
        public String legalname {
            set;
            get;
        }
        public String yardiInvoice {
            set;
            get;
        }
        public String axsinvoice {
            set;
            get;
        }
        public String yhInvoice {
            set;
            get;
        }
    }
    public STATIC FINAL DECIMAL EXCHANGERATE = 1;
    public STATIC FINAL String YARDI_USERNAME = Label.YARDI_USERNAME;
    public STATIC FINAL String YARDI_PASSWORD = Label.YARDI_PASSWORD;
    public STATIC FINAL String YARDI_INSTAINCE = Label.YARDI_INSTAINCE;
    public STATIC FINAL String YARDI_INTERCOMPANY = Label.YARDI_INTERCOMPANY;
    public STATIC FINAL String YARDI_PAYMEMT_REF = Label.YARDI_PAYMEMT_REF;
    public STATIC FINAL String YARDI_BankGL = Label.YARDI_BankGL;
    public STATIC FINAL String YARDI_INTERCOMPAANY_ACCNO = Label.YARDI_INTERCOMPAANY_ACCNO;
    public STATIC FINAL String YARDI_CURRENCY = 'AED';
    public STATIC FINAL String YARDI_VATCODE = 'SRS';


    public static void yardiInvCreation(String tranno) {

        yrdResponse rep = new yrdResponse();
        try {
            List < g_TranItem__c > ti = [select id, T__r.Name, T__r.Acc__r.Name, Yardi_prop_legal_nm__c, Yardi_trn_no__c, yardiinv__c, Yardi_property_code__c, name, A__c, VAT__c, itm__r.tcd__c, itm__r.pcd__c, pm__c from g_TranItem__c where T__c =: tranno and itm__r.itm__r.cd__c in ('ej', 'ejc', '1py', 'sc', 'afp', 'sp', 'sc', 'mq', 'af', 'rd', 'pt2', 'pt3', 'pt4', 'pt5', 'pt6', 'pt7', 'pt8', 'pt9', 'p10', 'p11', 'p12', 'drs')];
            Decimal Total_Amount = 0.0;
            Decimal Allocated_Net_Amount = 0.0;
            Decimal Allocated_Tax_Amount = 0.0;
            Decimal Allocated_Total_Amount = 0.0;
            Decimal Non_VAT_Amount = 0.0;
            String Property_Code = '';
            String Lease_Code = '';
            String paymentMethod = '';
            String axsRef = '';
            String accName = '';

            for (g_TranItem__c i: ti) {
                Total_Amount = Total_Amount + i.A__c;
                Allocated_Tax_Amount = Allocated_Tax_Amount + i.VAT__c;
                Property_Code = i.itm__r.pcd__c;
                Lease_Code = i.itm__r.tcd__c;
                paymentMethod = i.pm__c;
                axsRef = i.T__r.Name;
                accName = i.T__r.Acc__r.Name;
                if (i.VAT__c == 0.0) {
                    Non_VAT_Amount = Non_VAT_Amount + i.A__c;
                }
            }
            /*Total Amount is not equal to Allocated Net Amount + Tax Amount*/
            /* Allocated Total Amount is not equal to Allocated Net Amount & Tax Amount*/
            Allocated_Net_Amount = Total_Amount - Allocated_Tax_Amount - Non_VAT_Amount;
            Total_Amount = Total_Amount;

            ysiPsgD3MepaymentIntfcYardi.ysiYardiME_TransactionInterfacesSoap transIntfc = new ysiPsgD3MepaymentIntfcYardi.ysiYardiME_TransactionInterfacesSoap();
            ysiPsgD3MepaymentIntfcYardi.AuthHeader auth = new ysiPsgD3MepaymentIntfcYardi.AuthHeader();
            auth.sUserName = YARDI_USERNAME;
            auth.sUserPassword = YARDI_PASSWORD;
            auth.sCredentialName = YARDI_INSTAINCE;
            transIntfc.AuthHeader = auth;

            ysiPsgD3MepaymentIntfcYardi.METransaction_Request Transaction_x = new ysiPsgD3MepaymentIntfcYardi.METransaction_Request();
            Transaction_x.method = YARDI_INTERCOMPANY; //decided on runtime Direct OR Intercompany
            Transaction_x.Portal_Ref = axsRef; //'T2021011434107 ';    // AXS transaction# starting with T 
            Transaction_x.Property_Code = Property_Code; //'dic_cwk';//'d3_b09';  // from CCRM, from payment schedule
            Transaction_x.Lease_Code = Lease_Code; // from CCRM, from payment schedule        
            Transaction_x.ReceiptDate = system.today(); // AXS transaction# COMPLETED date
            Transaction_x.PostMonth = system.today(); //Date.newInstance(2023, 03, 01);     // current date, always
            Transaction_x.PaymentType = paymentMethod; //'Credit Card';    // payment method
            Transaction_x.PaymentRef = YARDI_PAYMEMT_REF; // hardcoded, always
            Transaction_x.Notes = axsRef + '-' + accName; //'T2021011434107';      // Service name
            Transaction_x.BankGL = YARDI_BankGL; //dummy 'axsintco';//adcbpdcw';    // from yardi, from account config. OR Custom Metadat
            Transaction_x.IntercompanyEntity = YARDI_INTERCOMPAANY_ACCNO; //'AXS';//164676
            Transaction_x.Currency_x = YARDI_CURRENCY; // CHANGE THE VAR NAME; value always AED.
            /** EXCHANGERATE,EXCHANGERATEDATE should be OPTIONAL **/
            Transaction_x.EXCHANGERATE = EXCHANGERATE; // ALWAYS 1, Create FINAL var
            Transaction_x.EXCHANGERATEDATE = system.today();
            /* Calcuations : Total_Amount = Allocated_Total_Amount+ Non_VAT_Amount; Allocated_Total_Amount = Allocated_Net_Amount+ Allocated_Tax_Amount*/
            Transaction_x.Non_VAT_Amount = Non_VAT_Amount;
            Transaction_x.Total_Amount = Total_Amount;
            Transaction_x.Allocated_Net_Amount = Allocated_Net_Amount;
            Transaction_x.Allocated_Tax_Amount = Allocated_Tax_Amount;
            Transaction_x.Allocated_Total_Amount = Allocated_Net_Amount + Allocated_Tax_Amount;
            Transaction_x.VAT_Code = YARDI_VATCODE; //from Custom labels, map it from transaction
            System.debug('#######################Transaction_x ###########################');
            system.debug('Transaction_x.method=' + Transaction_x.method);
            system.debug('Transaction_x.Portal_Ref=' + Transaction_x.Portal_Ref);
            system.debug('Transaction_x.Property_Code=' + Transaction_x.Property_Code);
            system.debug('Transaction_x.Lease_Code=' + Transaction_x.Lease_Code);
            system.debug('Transaction_x.ReceiptDate=' + Transaction_x.ReceiptDate);
            system.debug('Transaction_x.PostMonth=' + Transaction_x.PostMonth);
            system.debug('Transaction_x.PaymentType=' + Transaction_x.PaymentType);
            system.debug('Transaction_x.PaymentRef=' + Transaction_x.PaymentRef);
            system.debug('Transaction_x.Notes=' + Transaction_x.Notes);
            system.debug('Transaction_x.BankGL=' + Transaction_x.BankGL);
            system.debug('Transaction_x.IntercompanyEntity=' + Transaction_x.IntercompanyEntity);
            system.debug('Transaction_x.Currency_x=' + Transaction_x.Currency_x);
            system.debug('Transaction_x.EXCHANGERATE =' + Transaction_x.EXCHANGERATE);
            system.debug('Transaction_x.EXCHANGERATEDATE=' + Transaction_x.EXCHANGERATEDATE);
            system.debug('Transaction_x.Allocated_Tax_Amount=' + Transaction_x.Allocated_Tax_Amount);
            system.debug('Transaction_x.Allocated_Total_Amount=' + Transaction_x.Allocated_Total_Amount);
            system.debug('Transaction_x.Non_VAT_Amount=' + Transaction_x.Non_VAT_Amount);
            system.debug('Transaction_x.Total_Amount=' + Transaction_x.Total_Amount);
            system.debug('Transaction_x.Allocated_Net_Amount=' + Transaction_x.Allocated_Net_Amount);
            system.debug('Transaction_x.Allocated_Tax_Amount=' + Transaction_x.Allocated_Tax_Amount);
            system.debug('Transaction_x.Allocated_Total_Amount=' + Transaction_x.Allocated_Total_Amount);
            system.debug('Transaction_x.VAT_Code=' + Transaction_x.VAT_Code);
            System.debug('#######################Transaction_x ###########################');

            //METransactionImport_element.Transaction_x = Transaction_x;
            ysiPsgD3MepaymentIntfcYardi.METransaction_Response resp = transIntfc.METransactionImport(Transaction_x);
            System.debug('%%%% RESP %%%%:: ' + resp);
            rep.resp = resp.Message;
            rep.status = resp.Status;
            if (rep.status == 'Success') {
                String msg = rep.resp.replace('Import Success: ', '');
                msg = msg.replace('Legal Name', 'legalname');
                msg = msg.replace('C-"', 'C-');
                msg = msg.replace('yhInvoice",', 'yhInvoice":');
                String axsinv = '';
                String cnumYardiInv = '';
                yardiInv yardiInv = (yardiInv) System.JSON.deserialize(msg, yardiInv.class);
                if (yardiInv.axsinvoice != null) {
                    cnumYardiInv = yardiInv.axsinvoice.split(';')[0];
                }
                if (yardiInv.yhInvoice != null) {
                    axsinv = yardiInv.yhInvoice;
                }
                List < g_Tran__c > tLst = [select id, Name, Rq__c, rq__r.DDA_INV__c, YardiInv__c, rq__r.xdei__c, md__c, dt__c, (select id, itm__r.pcd__c, itm__r.itm__r.cd__c, name, ri__c, DDA_Inv_no__c, Yardi_trn_no__c, yardiinv__c, Yardi_property_code__c, Yardi_prop_legal_nm__c from Items__r) from g_Tran__c where id =: tranno and tp__c = 'Payment'
                    and STA__c = 'Completed'
                ];
                g_Req__c rq = new g_Req__c(id = tLst[0].Rq__c, xlinv__c = msg);
                update rq;
                List < g_TranItem__c > tiLst = tLst[0].Items__r;
                for (g_TranItem__c tii: tiLst) {
                    tii.ri__c = '1';
                    if (tii.itm__r.itm__r.cd__c == 'af' || tii.itm__r.itm__r.cd__c == 'afp' || tii.itm__r.itm__r.cd__c == 'mq' || tii.itm__r.itm__r.cd__c == 'ej' || tii.itm__r.itm__r.cd__c == 'ejc' || tii.itm__r.itm__r.cd__c == '1py' || tii.itm__r.itm__r.cd__c == 'sc') {
                        tii.Yardi_prop_legal_nm__c = yardiInv.legalname;
                        tii.Yardi_trn_no__c = axsinv;
                        tii.yardiinv__c = cnumYardiInv;
                        tii.Yardi_property_code__c = tii.itm__r.pcd__c;
                    } else {}
                }
                update tiLst;
                g_Tran__c yt = new g_Tran__c(id = tranno, YardiInv__c = msg);
                update yt;
            } else {}



        } catch (Exception e) {
            rep.status = 'Failed';
        }


    }
    //@Future(callout = true) 
    public static void createBankAccinYardi(String bnkDetails) {
        list < ws_call__c > ws = [select id, rq_itm__c, rq_jsn__c, res_jsn__c, intsts__c, rq_itm__r.RQ__c from ws_call__c where id =: bnkDetails];
        list < id > rqDocId = new List < id > ();
        list < ws_call__c > attws = new list < ws_call__c > ();
        List < g_reqDoc__c > reqDocLst = [select id, name, RQ__r.Name from g_reqDoc__c where RQ__c =: ws[0].rq_itm__r.RQ__c];
        for (g_reqDoc__c rd: reqDocLst) {
            rqDocId.add(rd.id);
        }
        list < Attachment > att = [select id, Body, name from Attachment where Parentid in: rqDocId];
        bnkDetails = ws[0].rq_jsn__c;
        String requestString = '';
        String endpointUrl = 'callout:OIC_Integration_PROD/AXS_YARDI_PERFOR_BANK_INTEGR/1.0/DirectDebitData/YardiImportDD';
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(90000);
            req.setMethod('POST');
            req.setBody(bnkDetails);
            req.setEndpoint(endpointUrl);
            Http http = new Http();
            res = http.send(req);
            ws[0].res_jsn__c = res.getBody();
            if (res.getStatusCode() == 200) {
                ws[0].intsts__c = 'Success';
                for (Attachment at: att) {
                    ws_call__c wss = new ws_call__c();
                    wss.rq_jsn__c = at.id;
                    wss.ws_typ__c = 'YardiCreateBankAttFu';
                    wss.mtd_nm__c = 'BankAccUpdate'; /*ws.uid__c = rq.id + '' + ri.id + '' + '' + 'BankAccUpdate'  + System.now();*/
                    wss.rq_itm__c = ws[0].rq_itm__c;
                    wss.intsts__c = 'Ready for Integration';
                    attws.add(wss);
                }
            } else {
                ws[0].intsts__c = 'failed';
            }
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            ws[0].intsts__c = 'failed';
            ws[0].res_jsn__c = e.getMessage() + '----' + ws[0].rq_jsn__c;
        }
        if (!attws.isEmpty()) {
            insert attws;
        }
        update ws[0];
    }

    @Future(callout = true)
    public static void createBankAccAttYardi(String attchmentDetails) {
        /*String requestString='{"YARDI_CUSTOMER_CODE":"c0042071","BENEFICIARY_NAME":"MBC BANK ONE","BENEFICIARY_BANK":"Emirates NBD","CURRENCY_Code":"AED","BENEFICIARY_IBAN_NO":"AE0192302103912039132","BENEFICIARY_ACCOUNT_NO":"00974291747916","BENEFICARY_BANK_ADDR1":"Bur Dubai","BENEFICARY_BANK_ADDR2":"","BENEFICARY_BANK_ADDR3":"Mankhool","BENEFICIARY_BANK_COUNTRY":"UAE","BENEFICIARY_BANK_SWIFT_CODE":974291747916,"ROUTING_CODE":1231231,"INTERMEDIARY_BANK_SWIFT_CODE":"q3e11231","BENEFICIARY_BANK_SORT_CODE":123}{"YARDI_CUSTOMER_CODE":"c0042071","BENEFICIARY_NAME":"MBC BANK ONE","BENEFICIARY_BANK":"Emirates NBD","CURRENCY_Code":"AED","BENEFICIARY_IBAN_NO":"AE0192302103912039132","BENEFICIARY_ACCOUNT_NO":"00974291747916","BENEFICARY_BANK_ADDR1":"Bur Dubai","BENEFICARY_BANK_ADDR2":"","BENEFICARY_BANK_ADDR3":"Mankhool","BENEFICIARY_BANK_COUNTRY":"UAE","BENEFICIARY_BANK_SWIFT_CODE":974291747916,"ROUTING_CODE":1231231,"INTERMEDIARY_BANK_SWIFT_CODE":"q3e11231","BENEFICIARY_BANK_SORT_CODE":123}';*/
        String bankLetter = '{"Object_type":478,"Attachment_Type":"Bank Letter","Record_Code":"c0042071","File_name":"bankletter.pdf","Attachment":""}';
        String mnagerLetter = '{"Object_type":478,"Attachment_Type":"Bank Letter","Record_Code":"c0042071","File_name":"bankletter.pdf","Attachment":""}';
        String endpointUrl = 'callout:OIC_Integration_PROD/AXS_YARDI_PERFOR_BANK_INTEGR/1.0/AttachmentData/YardiImportAttachment';
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(90000);
            req.setMethod('POST');
            req.setBody(attchmentDetails);
            req.setEndpoint(endpointUrl);
            Http http = new Http();
            res = http.send(req);
           
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
    }

    @Future(callout = true)
    public static void createBankAccAttYardiids(String wsid) {
        list < ws_call__c > ws = [select id, rq_itm__c, rq_jsn__c, rq_itm__r.RQ__r.Acc__r.Yardi_Cutsomer_Code__c, res_jsn__c, intsts__c from ws_call__c where id =: wsid];
        String attchmentid = ws[0].rq_jsn__c;
        list < Attachment > att = [select id, Body, name from Attachment where id =: attchmentid];
        refundFormBanKController.Att yat = new refundFormBanKController.Att();
        yat.Object_type = '478';
        yat.Attachment_Type = att[0].name;
        yat.Record_Code = ws[0].rq_itm__r.RQ__r.Acc__r.Yardi_Cutsomer_Code__c; /*cnumber c0042071*/
        yat.File_name = att[0].name;
        yat.Attachment = EncodingUtil.base64Encode(att[0].Body);
        String fuJson = JSON.serialize(yat);
        system.debug('fuJson' + fuJson);
        String endpointUrl = 'callout:OIC_Integration_PROD/AXS_YARDI_PERFOR_BANK_INTEGR/1.0/AttachmentData/YardiImportAttachment';
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(90000);
            req.setMethod('POST');
            req.setBody(fuJson);
            req.setEndpoint(endpointUrl);
            Http http = new Http();
            res = http.send(req);
            
            ws[0].res_jsn__c = res.getBody();
            if (res.getStatusCode() == 200) {
                ws[0].intsts__c = 'Success';
            } else {
                ws[0].intsts__c = 'failed';
            }
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            ws[0].intsts__c = 'failed';
            ws[0].res_jsn__c = e.getMessage() + '----' + ws[0].rq_jsn__c;
        }
        update ws[0];
    }

    @future(callout = true)
    public static void pushInsurDetailsToYardi(Id wsId) {
        ws_call__c wsRecord = [Select Id, rq_jsn__c, res_jsn__c, intsts__c from ws_call__c where id =: wsId];
        String endpointUrl = 'callout:OIC_Integration_PROD/AXS_YARDI_UPDATE_INSURANC/1.0/updateinsurance';
        String strResp = '';
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(90000);
            req.setMethod('POST');
            req.setBody(wsRecord.rq_jsn__c);
            req.setEndpoint(endpointUrl);
            Http http = new Http();
            res = http.send(req);
            strResp = res.getBody();
           
            wsRecord.res_jsn__c = res.getBody();
            wsRecord.intsts__c = 'Success';
            update wsRecord;
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
    }

    @future(callout = true) public static void createBankAccAttLeaseRenewalYardiIds(String wsid) {
        list < ws_call__c > ws = [select id, rq_itm__c, rq_jsn__c, rq_itm__r.RQ__r.rtacn__c, res_jsn__c, intsts__c from ws_call__c where id =: wsid];
        String attchmentid = ws[0].rq_jsn__c;
        list < Attachment > att = [select id, Body, name from Attachment where id =: attchmentid];
        refundFormBanKController.Att yat = new refundFormBanKController.Att();
        yat.Object_type = '542';
        yat.Attachment_Type = 'Insurance Policy';
        yat.Record_Code = ws[0].rq_itm__r.RQ__r.rtacn__c; /*tcode*/
        yat.File_name = att[0].Name;
        yat.Attachment = EncodingUtil.base64Encode(att[0].Body);
        String fuJson = JSON.serialize(yat);
        system.debug('fuJson' + fuJson);
        String endpointUrl = 'callout:OIC_Integration_PROD/AXS_YARDI_PERFOR_BANK_INTEGR/1.0/AttachmentData/YardiImportAttachment';
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(90000);
            req.setMethod('POST');
            req.setBody(fuJson);
            req.setEndpoint(endpointUrl);
            Http http = new Http();
            res = http.send(req);
           
            ws[0].res_jsn__c = res.getBody();
            if (res.getStatusCode() == 200) {
                ws[0].intsts__c = 'Success';
            } else {
                ws[0].intsts__c = 'failed';
            }
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            ws[0].intsts__c = 'failed';
            ws[0].res_jsn__c = e.getMessage() + '----' + ws[0].rq_jsn__c;
        }
        update ws[0];
    }

    public class YardiLRRequest {
        public String Table_Name;
        public String Entity_Record_Code;
        public List < FieldWrapper > Fields = new List < FieldWrapper > ();
    }

    public class FieldWrapper {
        public String Field_Name;
        public String Field_Value;
    }
}
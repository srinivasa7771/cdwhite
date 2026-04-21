public class gtFussionWs {

    /* TO  BE MOVED TO  SETTINGS*/
    /* public static final String USER_NAME='dham.axs@tahweel.dev';
        public static final String PASSWORD = Label.ORA_PASSWORD;*/

    /* public static final String USER_NAME='dham.axs@tahweel.uat';
        public static final String PASSWORD = Label.ORA_PASSWORD;
        */


    public static final String USER_NAME = Label.ORA_USER_NAME;
    public static final String PASSWORD = Label.ORA_PASSWORD;



    public static final String INVOICE_ENDPOINT = Label.ORA_INVOICE_ENDPOINT;
    public static final String RECEIPT_ENDPOINT = Label.ORA_RECEIPT_ENDPOINT;
    public static final String CREDITMEMO_ENDPOINT = Label.ORA_CREDITMEMO_ENDPOINT;
    public static final String DEBITMEMO_ENDPOINT = Label.ORA_DEBITMEMO_ENDPOINT;
    public static final String CM_DM_APP_ENDPOINT = Label.ORA_CM_DM_APP_ENDPOINT;
    public static final String BALANCE_CHK_ENDPOINT = Label.ORA_BALANCE_CHK_ENDPOINT;
    public static final String REFUND_ENDPOINT = Label.ORA_REFUND_ENDPOINT;
    public static final String REFUND_ATT_ENDPOINT = Label.ORA_REFUND_ATT_ENDPOINT;

    public static final String REFUND = Label.ORA_REFUND;
    public static final String REFUND_PAYMENT_METHOD = Label.ORA_REFUND_PAYMENT_METHOD;
    public static final String PARKING_SERVICES = Label.ORA_PARKING_SERVICES;
    public static final String FREELANCER_SERVICES = Label.ORA_FREELANCER_SERVICES;
    public static final String PMS_SERVICES = Label.ORA_PMS_SERVICES;
    public static final String YARDI_SERVICES = Label.ORA_YARDI_SERVICES;
    public static final String BANK_ACC_SERVICE = Label.ORA_BANK_ACC_SERVICE;
    public static final String TOKEN_ENDPOINT = Label.ORA_FUSION_TOKEN_ENDPOINT;

    public Static String getFUToken() {

        HTTPResponse res;
        String token = '';
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setEndpoint(TOKEN_ENDPOINT);
            req.setTimeout(90000);
            req.setMethod('POST');
            Http http = new Http();
            res = http.send(req);
            system.debug('fusionCallOut resopnse===>' + res.getBody());
            TokenResp cmResp = (TokenResp) JSON.deserialize(res.getBody(), TokenResp.class);
            token = cmResp.access_token;
        } catch (Exception e) {
            system.debug('====e==' + e);
            system.debug(e.getStackTraceString());
        }
        return token;

    }
    public static HTTPResponse fusionCallOut(String ENDPOINT, String inputJson) {
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Cache-Control', 'no-cache');
            String token = getFUToken();
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('AcceptLanguage', 'en-US');
            system.debug(inputJson + '==ENDPOINT==' + ENDPOINT);
            req.setBody(inputJson);
            req.setEndpoint(ENDPOINT);
            req.setTimeout(90000);
            req.setMethod('POST');
            Http http = new Http();
            res = http.send(req);
            system.debug('fusionCallOut resopnse===>' + res);
        } catch (Exception e) {
            system.debug('====e==' + e);
            system.debug(e.getStackTraceString());
        }
        return res;
    }
    public static HTTPResponse fusionCallOut2(String ENDPOINT, String inputJson) {
        HTTPResponse res;
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Cache-Control', 'no-cache');
            Blob headerValue = Blob.valueOf(USER_NAME + ':' + PASSWORD);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('AcceptLanguage', 'en-US');
            system.debug(inputJson + '==ENDPOINT==' + ENDPOINT);
            req.setBody(inputJson);
            req.setEndpoint(ENDPOINT);
            req.setTimeout(90000);
            req.setMethod('POST');
            Http http = new Http();
            res = http.send(req);
            system.debug('fusionCallOut resopnse===>' + res);
        } catch (Exception e) {
            system.debug('====e==' + e);
            system.debug(e.getStackTraceString());
        }
        return res;
    }

    public static String checkBalance(String pid, String typ) {

        String axsInv = '';
        String axsByInv = '';
        HTTPResponse res = new HTTPResponse();
        try {
            String apEndPoint = BALANCE_CHK_ENDPOINT;
            String refundJson = '{"REFUND_TYPE" : "' + typ + '", "ACCOUNT_NUMBER" : "' + pid + '" }';
            res = fusionCallOut(apEndPoint, refundJson);
            axsInv = res.getBody();
            system.debug('axsInv---axsInv--' + axsInv);
            if (res.getStatusCode() == 200) {
                axsInv = res.getBody();
            }

        } catch (Exception e) {
            system.debug(e.getStackTraceString());

        }

        return axsInv;

    }

    // @Future(callout = true)
    public static void voidCreateRefund(string payload, String tid, ws_call__c ws) {
        String axsInv = '';
        String axsByInv = '';
        HTTPResponse res = new HTTPResponse();
        try {
            String apEndPoint = REFUND_ENDPOINT;
            Decimal refundAmt = 0;
            List < g_reqitem__c > rqI = [select id, xrramt__c, xramt__c, sta__r.cd__c, xcnotes__c, name, RQ__r.xadtx1__c, xtrf__c from g_reqitem__c where id =: ws.rq_itm__c limit 1];

            String refundJson = payload;
            customerRefund crf = (customerRefund) System.JSON.deserialize(refundJson, customerRefund.class);
            if (rqI[0].xramt__c != null && rqI[0].sta__r.cd__c == 'pok' && (rqI[0].xtrf__c == 'Customer Deposit' || rqI[0].xtrf__c == 'Bank Guarantee')) {
                crf.REFUND_AMOUNT = rqI[0].xramt__c;
                crf.REMITTANCE_MESSAGE_2 = 'Partial refund';
                refundAmt = rqI[0].xramt__c;
                refundJson = JSON.serialize(crf);
            }

            if (rqI[0].xrramt__c != null && rqI[0].sta__r.cd__c == 'ok' && (rqI[0].xtrf__c == 'Customer Deposit' || rqI[0].xtrf__c == 'Bank Guarantee')) {
                crf.REFUND_AMOUNT = rqI[0].xrramt__c;
                crf.REMITTANCE_MESSAGE_2 = ' refund';
                refundAmt = rqI[0].xrramt__c;
                refundJson = JSON.serialize(crf);
            }


            res = fusionCallOut(apEndPoint, refundJson);

            axsInv = res.getBody();
            map < String, Object > jsonMap = (map < String, Object > ) JSON.deSerializeUntyped(res.getBody());
            String strStatus = '';
            if (jsonMap.containsKey('STATUS')) {
                strStatus = (String) jsonMap.get('STATUS');
            }
            ws.res_jsn__c = axsInv;
            ws.rq_jsn__c = refundJson;
            system.debug('axsInvaxsInv: ' + axsInv);
            g_Tran__c TT = [Select id, Name, Acc__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.adrfi__c from g_Tran__c where RQ__c =: tid limit 1];
            if (res.getStatusCode() == 200 && rqI[0].xtrf__c == 'Customer Deposit' && strStatus != 'Error') {
                List < Account > acclst = [select id, adrfi__c, adr__c from account where id =: TT.Acc__c limit 1];
                acclst[0].adrfi__c = acclst[0].adrfi__c - rqI[0].xrramt__c;
                acclst[0].adr__c = refundAmt;
                update acclst;
            }

            if (res.getStatusCode() == 200 && rqI[0].xtrf__c == 'Bank Guarantee' && strStatus != 'Error') {
                List < Account > acclst = [select id, bgrfi__c, bgrf__c, tbgr__c from account where id =: TT.Acc__c limit 1];
                acclst[0].bgrfi__c = 0;
                acclst[0].bgrf__c = refundAmt;
                acclst[0].tbgr__c = acclst[0].tbgr__c != null && acclst[0].tbgr__c > 0 ? acclst[0].tbgr__c + refundAmt : refundAmt;
                update acclst;
            }
            //||  strStatus == 'Error'
            g_tran__c t = new g_tran__c(Receipt_Resp__c = axsInv, BU_Inv__c = axsByInv, id = TT.id, isReceiptIntegrated__c = true);
            update t;
            ws.intsts__c = 'Success';

            if (res.getStatusCode() != 200) {
                ws.intsts__c = 'Failed';
            }
            update ws;

            //Attachment  WS call 
            if (res.getStatusCode() == 200 && strStatus != 'Error') {
                insertCallAtt(TT.id, rqI[0].id, tid);
            }

        } catch (Exception e) {
            ws.res_jsn__c = e.getStackTraceString();
            ws.intsts__c = 'Failed';
            update ws;

            system.debug('====e===' + e);
            system.debug(e.getStackTraceString());
        }
        system.debug('res: ' + res.getBody());
    }

    @future
    public static void insertCallAtt(Id ttId, String itemId, String rqId) {
        List < ws_call__c > lstWs = new List < ws_call__c > ();
        try {
            ws_call__c ws1 = new ws_call__c();
            ws1.rq_jsn__c = ttId;
            ws1.ws_typ__c = 'CreateCDBGREF';
            ws1.mtd_nm__c = 'CustomerRefundAtt';
            ws1.pmid__c = 'Bank Letter';
            ws1.rq_itm__c = itemId;
            ws1.intsts__c = 'Ready for Integration';
            lstWs.add(ws1);


            ws_call__c ws2 = new ws_call__c();
            ws2.rq_jsn__c = ttId;
            ws2.ws_typ__c = 'CreateCDBGREF';
            ws2.mtd_nm__c = 'CustomerRefundAtt';
            ws2.pmid__c = 'Manager Consent Letter';
            ws2.rq_itm__c = itemId;
            ws2.intsts__c = 'Ready for Integration';
            lstWs.add(ws2);

            ws_call__c ws3 = new ws_call__c();
            ws3.rq_jsn__c = ttId;
            ws3.ws_typ__c = 'CreateCDBGREF';
            ws3.mtd_nm__c = 'CustomerRefHistoryAtt';
            ws3.pmid__c = rqId;
            ws3.rq_itm__c = itemId;
            ws3.intsts__c = 'Ready for Integration';
            lstWs.add(ws3);

            System.enqueueJob(new OnboardQueueable('createRefundWsCall', lstWs));
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
    }




    public static void createInvoiceFu(String tid) {
        try {
            g_tran__c tran = [Select Id, Name, isinvoiceIntegrated__c, payload__c, bupayload__c, isReceiptIntegrated__c, STA__c, Srv_Code__c, dt__c, A__c, md__c, Invoice_Resp__c, CMCustomerTransactionId__c, Receipt_Resp__c, BU_Inv__c, Acc__r.park__c, TP__c, op__r.Name From g_tran__c where id =: tid and isDeleted = false][0];
            HTTPResponse res = new HTTPResponse();

            String axsInv = '';
            String buInv = '';
            String prechkResp = preChecks(tid);
            axsInv = prechkResp;
            String payload = '';
            String bupayload = '';
            if (tran.TP__c == 'Payment' && prechkResp == 'SUCCESS') {
                if (PMS_SERVICES.contains(tran.Srv_Code__c)) {
                    payload = gTDataTransformation.datatransformationInv(tid, 'AXS');
                    res = fusionCallOut(INVOICE_ENDPOINT, payload);
                    axsInv = res.getBody();
                    bupayload = gTDataTransformation.datatransformationInv(tid, 'BU');
                    res = fusionCallOut(INVOICE_ENDPOINT, bupayload);
                    buInv = res.getBody();
                } else if (PARKING_SERVICES.contains(tran.Srv_Code__c)) {
                    bupayload = gTDataTransformation.datatransformationInv(tid, 'BU');
                    res = fusionCallOut(INVOICE_ENDPOINT, bupayload);
                    buInv = res.getBody();
                } else {
                    payload = gTDataTransformation.datatransformationInv(tid, 'AXS');
                    res = fusionCallOut(INVOICE_ENDPOINT, payload);
                    axsInv = res.getBody();
                }
            }
            tran.Invoice_Resp__c = axsInv;
            tran.BU_Inv__c = buInv;
            tran.payload__c = payload;
            tran.bupayload__c = bupayload;
            tran.isinvoiceIntegrated__c = true;
            if (tran.TP__c == 'Refund') {
                String creditMemoResp = createCreditMemoFu(tid);
                tran.Invoice_Resp__c = creditMemoResp;
                if (!String.isEmpty(creditMemoResp) && !creditMemoResp.contains('error')) {
                    tran.BU_Inv__c = createDebitMemoFu(tid);
                }
                if (tran.Invoice_Resp__c != null) {
                    FusionCMResp cmResp = (FusionCMResp) JSON.deserialize(tran.Invoice_Resp__c, FusionCMResp.class);
                    tran.CMCustomerTransactionId__c = cmResp.Output.CustomerTransactionId;
                }
            }
            if (tran != null) {
                update tran;
            }
            system.debug('res: ' + res.getBody());
        } catch (Exception e) {
            system.debug('====e===' + e);
            system.debug(e.getStackTraceString());
        }

    }

    public static void createInvoiceFu(String tid, String itype) {
        try {
            g_tran__c tran = [Select Id, Name, isinvoiceIntegrated__c, isReceiptIntegrated__c, STA__c, Srv_Code__c, dt__c, A__c, md__c, Invoice_Resp__c, CMCustomerTransactionId__c, Receipt_Resp__c, BU_Inv__c, Acc__r.park__c, TP__c, op__r.Name From g_tran__c where id =: tid and isDeleted = false][0];
            HTTPResponse res = new HTTPResponse();

            String axsInv = '';
            String buInv = '';
            String prechkResp = preChecks(tid);
            axsInv = prechkResp;
            if (tran.TP__c == 'Payment' && prechkResp == 'SUCCESS') {

                if (itype == 'AXS') {
                    res = fusionCallOut(INVOICE_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'AXS'));
                    axsInv = res.getBody();
                } else if (itype == 'BU') {
                    res = fusionCallOut(INVOICE_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'BU'));
                    buInv = res.getBody();
                }
            }
            tran.Invoice_Resp__c = axsInv;
            tran.BU_Inv__c = buInv;
            tran.isinvoiceIntegrated__c = true;

            if (tran != null) {
                update tran;
            }
            system.debug('res: ' + res.getBody());
        } catch (Exception e) {
            system.debug('====e===' + e);
            system.debug(e.getStackTraceString());
        }

    }
    public static void createReceiptFu(String tid) {
        try {
            HTTPResponse res = fusionCallOut(RECEIPT_ENDPOINT, gTDataTransformation.datatransformationReceipt(tid));
            system.debug('createReceiptFu Response==>' + res.getBody());
            g_tran__c t = new g_tran__c(Receipt_Resp__c = res.getBody(), id = tid, isReceiptIntegrated__c = true);
            update t;

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
    }


    public static void createReceiptInvFu(String tid) {
        try {
            g_tran__c tran = [Select Id, Name, isinvoiceIntegrated__c, isReceiptIntegrated__c, STA__c, Srv_Code__c, dt__c, A__c, md__c, Invoice_Resp__c, CMCustomerTransactionId__c, Receipt_Resp__c, BU_Inv__c, Acc__r.park__c, TP__c, op__r.Name From g_tran__c where id =: tid and isDeleted = false][0];
            HTTPResponse res = new HTTPResponse();
            String axsInv = '';
            String buInv = '';

            String prechkResp = preChecks(tid);
            axsInv = prechkResp;
            if (tran.TP__c == 'Payment' && prechkResp == 'SUCCESS') {
                if (tran.Srv_Code__c == '208' || tran.Srv_Code__c == '322') {
                    res = fusionCallOut(INVOICE_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'AXS'));
                    axsInv = res.getBody();
                    res = fusionCallOut(INVOICE_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'BU'));
                    buInv = res.getBody();
                } else if (tran.Srv_Code__c == '156' || tran.Srv_Code__c == '154' || tran.Srv_Code__c == '150') {
                    res = fusionCallOut(INVOICE_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'BU'));
                    buInv = res.getBody();
                } else {
                    res = fusionCallOut(INVOICE_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'AXS'));
                    axsInv = res.getBody();
                }
            }
            /*invoice integrated */
            if (res.getStatusCode() == 200) {
                tran.isinvoiceIntegrated__c = true;
            }
            tran.Invoice_Resp__c = axsInv;
            tran.BU_Inv__c = buInv;
            res = fusionCallOut(RECEIPT_ENDPOINT, gTDataTransformation.datatransformationReceipt(tid));
            tran.Receipt_Resp__c = res.getBody();
            /*invoice integrated */
            if (res.getStatusCode() == 200) {
                tran.isReceiptIntegrated__c = true;
            }
            if (tran != null) {
                update tran;
            }
            system.debug('res: ' + res.getBody());

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }

    }

    /*for  cd to BG  create DM, followed by DR*/
    public static void createDMDRFu(String tid) {
        try {
            g_tran__c tran = [Select Id, Name, isinvoiceIntegrated__c, isReceiptIntegrated__c, STA__c, Srv_Code__c, dt__c, A__c, md__c, Invoice_Resp__c, CMCustomerTransactionId__c, Receipt_Resp__c, BU_Inv__c, Acc__r.park__c, TP__c, op__r.Name From g_tran__c where id =: tid and isDeleted = false][0];
            HTTPResponse res = new HTTPResponse();
            String axsInv = '';
            String buInv = '';
            if (tran.TP__c == 'Payment') {
                res = fusionCallOut(DEBITMEMO_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'DEBIT_MEMO'));
                system.debug('createDebitMemoFu: ' + res.getBody());
                axsInv = res.getBody();
            }
            /*DM integrated */
            if (res.getStatusCode() == 200) {
                tran.isinvoiceIntegrated__c = true;
            }
            tran.Invoice_Resp__c = axsInv;
            res = fusionCallOut(RECEIPT_ENDPOINT, gTDataTransformation.datatransformationReceipt(tid));
            tran.Receipt_Resp__c = res.getBody();
            /*Dummy receipt integrated */
            if (res.getStatusCode() == 200) {
                tran.isReceiptIntegrated__c = true;
            }
            if (tran != null) {
                update tran;
            }
            system.debug('res: ' + res.getBody());

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }

    }



    public static String createCreditMemoFu(String tid) {
        String output = '';
        try {
            HTTPResponse res = fusionCallOut(CREDITMEMO_ENDPOINT, gTDataTransformation.datatransformationCM(tid, 'CREDIT_MEMO'));
            system.debug('createCreditMemoFu: ' + res.getBody());
            output = res.getBody();
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
        return output;
    }
    public static String createDebitMemoFu(String tid) {
        String output = '';
        try {
            HTTPResponse res = fusionCallOut(DEBITMEMO_ENDPOINT, gTDataTransformation.datatransformationInv(tid, 'DEBIT_MEMO'));
            system.debug('createDebitMemoFu: ' + res.getBody());
            output = res.getBody();
            g_tran__c t = new g_tran__c(Invoice_Resp__c = res.getBody(), id = tid, isinvoiceIntegrated__c = true);
            update t;
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
        return output;
    }
    public static String CMDMApplicationFu(String tid) {
        String output = '';
        try {
            System.debug('====tid==' + tid);
            System.debug('====tid==' + gTDataTransformation.CMDMApplication(tid));
            HTTPResponse res = fusionCallOut(CM_DM_APP_ENDPOINT, gTDataTransformation.CMDMApplication(tid));
            System.debug('====CM_DM_APP_ENDPOINT==' + CM_DM_APP_ENDPOINT);
            system.debug('createDebitMemoFu: ' + res.getBody());
            output = res.getBody();
            g_tran__c t = new g_tran__c(CMDMAPPRes__c = res.getBody(), id = tid);
            update t;

        } catch (Exception e) {
            system.debug('====' + e);
            system.debug(e.getStackTraceString());
        }
        return output;
    }


    /* CMDMApplicationFu and dummy receipt  */
    public static String CMDMApplicationDmyRecpFu(String tid) {
        String axsInv = '';
        String axsRecp = '';

        g_tran__c tran = [Select Id, Name, isinvoiceIntegrated__c, isReceiptIntegrated__c, CMDMAPPRes__c, STA__c, Srv_Code__c, dt__c, A__c, md__c, Invoice_Resp__c, CMCustomerTransactionId__c, Receipt_Resp__c, BU_Inv__c, Acc__r.park__c, TP__c, op__r.Name From g_tran__c where id =: tid and isDeleted = false][0];
        try {
            System.debug('====tid==' + tid);
            System.debug('====tid==' + gTDataTransformation.CMDMApplication(tid));
            HTTPResponse res = fusionCallOut(CM_DM_APP_ENDPOINT, gTDataTransformation.CMDMApplication(tid));
            system.debug('createDebitMemoFu: ' + res.getBody());
            axsInv = res.getBody();
            tran.CMDMAPPRes__c = axsInv;
            /*DM integrated */
            if (res.getStatusCode() == 200 && !axsInv.contains('error')) {
                tran.isinvoiceIntegrated__c = true;
                tran.CMDMAPPRes__c = axsInv;
                res = fusionCallOut(RECEIPT_ENDPOINT, gTDataTransformation.datatransformationReceipt(tid));
                axsRecp = res.getBody();
                tran.Receipt_Resp__c = res.getBody();
                /*Dummy receipt integrated */
                if (res.getStatusCode() == 200 && !axsRecp.contains('error')) {
                    tran.isReceiptIntegrated__c = true;
                }

            }



            if (tran != null) {
                update tran;
            }


        } catch (Exception e) {
            system.debug('====' + e);
            system.debug(e.getStackTraceString());
        }
        return axsRecp;
    }

    @Future(callout = true)
    public static void createBankAcc(String wsid) {

        list < ws_call__c > ws = [select id, rq_itm__c, rq_jsn__c, res_jsn__c, intsts__c from ws_call__c where id =: wsid];
        List < g_reqitem__c > rqI = [select id, name, RQ__c, RQ__r.xadtx1__c, RQ__r.xadtx2__c from g_reqitem__c where id =: ws[0].rq_itm__c limit 1];
        String output = '';
        try {
            String accDetails = ws[0].rq_jsn__c;
            HTTPResponse res = fusionCallOut(BANK_ACC_SERVICE, accDetails);
            System.debug('====BANK_ACC_SERVICE==' + BANK_ACC_SERVICE);
            output = res.getBody();
            system.debug('BANK_ACC_SERVICE--' + output);



            if (res.getStatusCode() == 200) {
                ws[0].intsts__c = 'Success';
                ws[0].res_jsn__c = output;
                ws_call__c wss = new ws_call__c();
                wss.rq_jsn__c = rqI[0].RQ__r.xadtx2__c;
                wss.ws_typ__c = 'YardiCreateBankFu';
                wss.mtd_nm__c = 'BankAccUpdate';
                wss.uid__c = rqI[0].RQ__c + '' + rqI[0].id + '' + '' + 'BankAccUpdate' + System.now();
                wss.rq_itm__c = rqI[0].id;
                wss.intsts__c = 'Ready for Integration';
                insert wss;

                //  gTYardiInvCreation.createBankAccinYardi(wss.id);
            } else {
                ws[0].intsts__c = 'Failed';
                ws[0].res_jsn__c = output;
            }


        } catch (Exception e) {
            system.debug('====' + e);
            system.debug(e.getStackTraceString());

            ws[0].intsts__c = 'Failed';
            ws[0].res_jsn__c = e.getMessage();
        }

        update ws[0];


    }

    public static string preChecks(String tid) {
        try {
            g_tran__c tran = [Select Id, Name, repush__c, RQ__r.Total_amt__c, Lease_Start_Date__c, Rq__r.xdei__c, Lease_End_date__c, pre_fix__c, STA__c, Zone__c, Srv_Code__c, RQ__r.xps__c, RQ__r.xpmsle__c, RQ__r.xcpid__c, RQ__r.xcped__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where id =: tid and isDeleted = false][0];
            list < g_TranItem__c > tranLst = [select id, name, TAX_CODE__c, itm__r.name, itm__r.itmCd__c, itm__r.xcbsd__c, aj__c, itm__r.xcbed__c, A__c, ml__c, T__r.Name, VAT__c, DDA_Inv_no__c, yardiinv__c, Service_Name__c, itm__r.xlesd__c, itm__r.xleed__c, itm__r.itm__r.Bill_To__c, Supplier_Number__c from g_TranItem__c where T__c =: tid];
            for (g_TranItem__c ti: tranLst) {
                decimal vat = ti.A__c - (ti.A__c / 1.05);
                if (tran.Srv_Code__c == '154' || tran.Srv_Code__c == '156' || tran.Srv_Code__c == '150') {
                    if ((ti.VAT__c == 0 || ti.TAX_CODE__c != 'STANDARD RATE TAX' || ti.VAT__c != vat) && !ti.aj__c) {
                        /* return 'VAT_MISMATCH';*/ }
                }
                if (tran.Srv_Code__c == '208' || tran.Srv_Code__c == '216' || tran.Srv_Code__c == '322') {
                    if (ti.itm__r.itmCd__c == 'psf' || ti.itm__r.itmCd__c == 'tsf' || ti.itm__r.itmCd__c == 'apf' || ti.itm__r.itmCd__c == 'pa1' || ti.itm__r.itmCd__c == 'pa2' || ti.itm__r.itmCd__c == 'pa3') {
                        if ((ti.VAT__c == 0 || ti.TAX_CODE__c != 'STANDARD RATE TAX' || ti.VAT__c != vat) && !ti.aj__c) {
                            /*return 'VAT_MISMATCH';*/ }
                    }
                    if (ti.itm__r.itmCd__c == 'psf' || ti.itm__r.itmCd__c == 'apf' || ti.itm__r.itmCd__c == 'pa1' || ti.itm__r.itmCd__c == 'pa2' || ti.itm__r.itmCd__c == 'pa3') {
                        if (tran.Lease_Start_Date__c == null && tran.Lease_End_date__c == null && !ti.aj__c) {
                            return 'PSF_DATES_MISMATCH';
                        }
                    }
                    if (tran.Srv_Code__c == '208' || tran.Srv_Code__c == '216' || tran.Srv_Code__c == '322') {
                        if (ti.ml__c == 'AXS_LEASEFEE' || ti.ml__c == 'AXS_EJARISERVICECHARGE' || ti.ml__c == 'AXS_EJARI') {
                            if ((ti.yardiinv__c == null || ti.yardiinv__c == 'null' || ti.yardiinv__c == '') && !ti.aj__c) {
                                return 'MiSSING_YARDI_INV';
                            }
                        }
                        if (ti.ml__c == 'DDA Licence Renewal' || ti.ml__c == 'AXS_DDA_NEWLICENCE' || ti.ml__c == 'Freelancer Permit Fee - New' || ti.ml__c == 'Freelancer Permit Fee - Renew') {
                            if ((ti.DDA_Inv_no__c == null || ti.DDA_Inv_no__c == 'null' || ti.DDA_Inv_no__c == '') && !ti.aj__c) {
                                return 'MiSSING_DDA_INV';
                            } /*amount mismatch*/
                            if ((tran.Srv_Code__c == '208' || tran.Srv_Code__c == '216' || tran.Srv_Code__c == '322') && !tran.repush__c) {
                                String rqBody = '{"methodname":"invoiceinformation","data":[{"requestId":"' + tran.Rq__r.xdei__c + '"}]}';
                                String respBody = grqWsOnboard.ddaOnbordingInfo(rqBody);
                                if (String.isNotBlank(respBody)) {
                                    Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(respBody);
                                    Decimal invoiceAmount = (Decimal) results.get('invoiceAmount');
                                    system.debug('invNo:' + invoiceAmount);
                                    if (tran.RQ__r.Total_amt__c != invoiceAmount) {
                                        /*return 'DDA_INV_MISMATCH';*/ }
                                } else {
                                    /* return 'DDA_INV_MISMATCH';*/ }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            return 'ERROR';
        }
        return 'SUCCESS';
    }

    @future(callout = true)
    public static void voidCreateRefundAtt(string attribute, String tid, String wsId) {
        system.debug('tid==' + tid);
        try {
            ws_call__c ws = [Select Id, rq_jsn__c, pmid__c from ws_call__c where Id =: wsId limit 1];
            system.debug('ws==' + ws);
            g_Tran__c TT = [Select id, Name, Acc__c, Acc__r.ORACLE_PARTY_ID__c from g_Tran__c where RQ__c =: tid and Id =: ws.rq_jsn__c limit 1];
            list < g_reqitem__c > lstCustItm = [Select id from g_reqitem__c where name = 'Customer Bank Account'
                and RQ__r.Acc__c =: TT.Acc__c order by createddate desc limit 1
            ];
            list < Id > lstDocId = new list < Id > ();
            list < Attachment > lstAtt = new List < Attachment > ();
            list < String > lstReqBody = new list < String > ();
            String resbody = '';
            boolean isSuccess = true;
            String apEndPoint = REFUND_ATT_ENDPOINT;

            if (lstCustItm != null && !lstCustItm.isEmpty()) {
                for (g_reqitemDoc__c objItmDoc: [Select Id, name, reqDoc__c from g_reqitemDoc__c where reqItm__c IN: lstCustItm and Name =: ws.pmid__c]) {
                    lstDocId.add(objItmDoc.reqDoc__c);
                }

                if (lstDocId != null && !lstDocId.isEmpty()) {

                    for (Attachment ObjAtt: [Select Id, Body, parentid, Parent.name from Attachment where ParentId In: lstDocId order by createddate desc]) {

                        String resbd = '{"ACCOUNT_NUMBER": "' + TT.Acc__r.ORACLE_PARTY_ID__c + '", "REFUND_REFERENCE_ID": "' + TT.Name + '", "Attachments": [ { "FILENAME": "' + ObjAtt.Parent.name + '", "TITLE": "MANAGER AUTHORIZATION LETTER", "DESCRIPTION": "Description of the Attachment", "FILE_CONTENTS": "' + EncodingUtil.base64Encode(ObjAtt.Body) + '", "FILE_CONTENT_TYPE": "application/pdf" } ] }';
                        lstReqBody.add(resbd);
                    }
                }
            }

            if (lstReqBody != null && !lstReqBody.isEmpty()) {
                for (String reqBody: lstReqBody) {
                    HTTPResponse res = fusionCallOut(apEndPoint, reqBody);
                    String axsByInv = res.getBody();
                    system.debug('res==' + res);
                    if (res.getStatusCode() == 200) {
                        resbody += 'Success: ' + axsByInv;

                    } else {
                        isSuccess = false;
                        resbody += 'Error: ' + axsByInv;

                    }
                }
            }

            if (String.isNotBlank(resbody)) {
                ws.intsts__c = isSuccess ? 'Success' : 'Failed';
                ws.res_jsn__c = resbody;
                update ws;
            }

        } catch (Exception e) {
            system.debug('====' + e);
            system.debug(e.getStackTraceString());
        }

    }


    @future(callout = true)
    public static void voidCreateRefundHisAtt(string attribute, String tid, String wsId) {
        system.debug('tid==' + tid);
        try {
            ws_call__c ws = [Select Id, rq_jsn__c, pmid__c from ws_call__c where Id =: wsId limit 1];
            system.debug('ws==' + ws);
            g_Tran__c TT = [Select id, Name, Acc__c, Acc__r.ORACLE_PARTY_ID__c from g_Tran__c where RQ__c =: tid and Id =: ws.rq_jsn__c limit 1];
            list < String > lstReqBody = new list < String > ();
            String resbody = '';
            boolean isSuccess = true;
            String apEndPoint = REFUND_ATT_ENDPOINT;


            PageReference refundpage = new PageReference('/apex/grqStaHistory?id=' + ws.pmid__c);
            Blob refundPdf = refundpage.getContentAsPDF();
            String resbd = '{"ACCOUNT_NUMBER": "' + TT.Acc__r.ORACLE_PARTY_ID__c + '", "REFUND_REFERENCE_ID": "' + TT.Name + '", "Attachments": [ { "FILENAME": "REFUND_HISTORY", "TITLE": "REFUND_HISTORY", "DESCRIPTION": "Description of the Attachment", "FILE_CONTENTS": "' + EncodingUtil.base64Encode(refundPdf) + '", "FILE_CONTENT_TYPE": "application/pdf" } ] }';
            lstReqBody.add(resbd);

            if (lstReqBody != null && !lstReqBody.isEmpty()) {
                for (String reqBody: lstReqBody) {
                    system.debug('reqBody -- ' + reqBody);
                    HTTPResponse res = fusionCallOut(apEndPoint, reqBody);
                    String axsByInv = res.getBody();
                    system.debug('res==' + res);
                    if (res.getStatusCode() == 200) {
                        resbody += 'Success: ' + axsByInv;

                    } else {
                        isSuccess = false;
                        resbody += 'Error: ' + axsByInv;

                    }
                }
            }

            if (String.isNotBlank(resbody)) {
                ws.intsts__c = isSuccess ? 'Success' : 'Failed';
                ws.res_jsn__c = resbody;
                update ws;
            }
        } catch (Exception e) {
            system.debug('====' + e);
            system.debug(e.getStackTraceString());
        }
    }



}
public class gwsH {
    public static Boolean rBefore=true;
    public static Boolean rAfter=true;
    public enum tSCP {IB,IA,UB,UA,DB,DA}
    public class xObj{public sObject o;public payload pl;public xObj(sObject objNew,sObject objOld){if (objNew==null){o=objOld;}else{o=objNew;}pl=new payload(objNew,objOld);}}
    public class payload{public sObject nw;public sObject old;public map<string,object> mv;public map<string,sObject> mo;public map<string,list<sObject>> toInsert;public map<string,list<sObject>> toUpdate;public map<string,list<sObject>> toDelete; public payload(sObject objNew,sObject objOld){nw=objNew;old=objOld;mv=new map<string,object>();mo=new map<string,sObject>();toInsert=new map<string,list<sObject>>();toUpdate=new map<string,list<sObject>>();toDelete=new map<string,list<sObject>>();}}



    public class wsH{
        public wsH(){

        }

        private list<xObj> excH(list<ws_call__c>news,map<Id,ws_call__c>olds,tSCP scp){
            list<xObj>Rs=new list<xObj>();if (news==null&&olds==null){return Rs;}
            list<ws_call__c>lst;if (news==null){lst=olds.values();}else{lst=news;}
            List<id> invBatchIds = new List<id>();
            List<id> stsBatchIds = new List<id>();
            List<id> crmStsBatchIds = new List<id>();
            List<id> crmWOBatchIds = new List<id>();
            List<id> crmDocBatchIds = new List<id>();
            List <id> axdDocBatchIds = new List < id > (); /*MS 1.1*/
            List<id> cbkIds = new List<id>();
            List<id> cbStsIds = new List<id>();
            List<id> accInfoBatchIds = new List<id>();
            List < id > pmsUpdateBatchIds = new List < id > ();
            List<id> invDDABatchIds = new List<id>();
            List<id> invYardiBatchIds = new List<id>();
            List<id> docBatchIds = new List<id>();
            List<id> docAmdBatchIds = new List<id>();
            List<id> sancBatchIds = new List<id>();
            List<id> ltaprvlBatchIds = new List<id>();
            List<id> cpuReqList = new List<id>();
            List<id> laDDACreateReqIds = new List<id>();
            List<id> laDDAUploadDocIds = new List<id>();
            List<id> laDDAStatusUpdateIds = new List<id>();
            List<id> crm_callDDA_AMd_updateMemb = new List<id>();
            List<id> docOICUploadIds = new List<id>(); /* PJ 1.2 */
            List<id> oraFuBankIds = new List<id>();
            List<id> yardiBankIds = new List<id>();
            List<id> yardiBankAttIds = new List<id>();
            List<id> lstAppFee =  new List<id>(); /*MS1.1*/
            List<id> fitOutReq = new List<id>();
            List<id> fitOutDocUp = new List<Id>();
            List<id> cdbgRefund = new List<Id>();
            List<id> cdbgRefundAtt = new List<Id>();
            List<id> cdbgRefundHisAtt = new List<Id>();
            List < id > landAssignment = new List < Id > (); /**MS 1.1*/
            List<id> nsidR = new List<Id>();
            List<id> nsidC = new List<Id>();
            List<id> leaseRenewalwsIds = new List<id>();
            List<id> leaseRSubmittalReqWsIds = new List<id>();
            List<id> laCRMAssignmentReqIds = new List<id>();//US APD2635
            List<id> leaseRenewalDocUploadIds = new List<Id>();
            List<id> leaseRenewalWetSignUpdateIds = new List<Id>();
            List<id> leaseRenewalInsDetailsUpdateIds = new List<Id>();
            List<id> leaseRenewalyardiBankAttIds = new List<id>();
            if (scp == tSCP.IA) {
                for (ws_call__c ws: lst) {
                    if (ws.intsts__c == 'Ready for Integration' && ws.is_pro__c == false) {
                        if (ws.ws_typ__c == 'DccaExtraService') {
                            invBatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'DCCA update status' && ws.mtd_nm__c == 'dccaUpdStatus') {
                            stsBatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'DCCA License Renewals'|| ws.mtd_nm__c == 'auditFormDocs' || ws.mtd_nm__c == 'membersDocs') {
                            docBatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'DCCA AddRemove Sanction') {
                            sancBatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'DDA Amendments' && ws.mtd_nm__c == 'uploadDoc') {
                            docAmdBatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'DCCA Letters' && (ws.mtd_nm__c == 'dccaApproval' || ws.mtd_nm__c == 'auditform' || ws.mtd_nm__c == 'membersUpd')) {
                            ltaprvlBatchIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'Courier Booking' && ws.mtd_nm__c == 'Courier Booking') {
                            cbkIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'Courier Service' && (ws.mtd_nm__c == 'updateCourSta' || ws.mtd_nm__c == 'updateCourColSta')) {
                            cbStsIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'updateCRMStatus') {
                            crmWOBatchIds.add(ws.id);
                        }else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'updateStatus') {
                            crmStsBatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'fetchAccInfo') {
                            accInfoBatchIds.add(ws.id);
                        }
                        else if ((ws.ws_typ__c == 'Onboarding' || ws.ws_typ__c == 'DDA License Renewals') && ws.mtd_nm__c == 'updatePMSInfo') {
                            pmsUpdateBatchIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'uploadDoc') {
                            crmDocBatchIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'Onboarding' && (ws.mtd_nm__c == 'ddaupload' || ws.mtd_nm__c == 'crmupload')) {
                            docOICUploadIds.add(ws.id);
                        }/*MS 1.1*/
                        else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'uploadDoc1') {
                            system.debug('inside11==uploadDoc1');
                            axdDocBatchIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'DDANewInvoice' && Label.Onboarding_InvoiceUpdate == 'Y') {
                            invDDABatchIds.add(ws.id);
                        } else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'YardiInvoice' && Label.Onboarding_InvoiceUpdate == 'Y') {
                            invYardiBatchIds.add(ws.id);
                        }else if (ws.ws_typ__c == 'Parking' && ws.mtd_nm__c == 'ParkingRenewal') {
                            System.enqueueJob(new OnboardQueueable('parking', ws.rq_jsn__c, ws.xrno__c));
                        }else if (ws.ws_typ__c == 'License Amendments' && ws.mtd_nm__c == 'createRequest') {
                            laDDACreateReqIds.add(ws.id);
                        }else if (ws.ws_typ__c == 'License Amendments' && ws.mtd_nm__c == 'LADocs') {
                            laDDAUploadDocIds.add(ws.id);
                        }else if (ws.ws_typ__c == 'License Amendments' && ws.mtd_nm__c == 'statusUpdate') {
                            laDDAStatusUpdateIds.add(ws.id);
                        }else if (ws.ws_typ__c == 'License Amendments' && ws.mtd_nm__c == 'createAssignment') {//US APD2635
                            laCRMAssignmentReqIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'DDA Amendments' && ws.mtd_nm__c == 'updateMember') {
                            crm_callDDA_AMd_updateMemb.add(ws.id);
                        }
                         else if (ws.ws_typ__c == 'CreateBankFu' && ws.mtd_nm__c == 'BankAccUpdate') {
                            oraFuBankIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'YardiCreateBankFu' && ws.mtd_nm__c == 'BankAccUpdate') {
                            yardiBankIds.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'YardiCreateBankAttFu' && ws.mtd_nm__c == 'BankAccUpdate') {
                            yardiBankAttIds.add(ws.id);
                        }

                        else if (ws.ws_typ__c == 'Onboarding' && ws.mtd_nm__c == 'AppFeeInvoice')
                        {
                            lstAppFee.add(ws.id);
                        }else if (ws.ws_typ__c == 'Fitout' && ws.mtd_nm__c == 'CreateRequest'){
                            fitOutReq.add(ws.id);
                        }else if (ws.ws_typ__c == 'Fitout' && ws.mtd_nm__c == 'UploadDocs'){
                            fitOutDocUp.add(ws.id);
                        }else if (ws.ws_typ__c == 'CreateCDBGREF' && ws.mtd_nm__c == 'CustomerRefund'){
                            cdbgRefund.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'CreateCDBGREF' && ws.mtd_nm__c == 'CustomerRefundAtt')
                        {
                            cdbgRefundAtt.add(ws.id);
                        }
                         else if (ws.ws_typ__c == 'CreateCDBGREF' && ws.mtd_nm__c == 'CustomerRefHistoryAtt')
                        {
                            cdbgRefundHisAtt.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'OnBoarding' && ws.mtd_nm__c == 'landLeaseAssignment') {
                            landAssignment.add(ws.id);
                        }
                        else if (ws.mtd_nm__c == 'NONSPONIDCAN')
                        {
                            nsidC.add(ws.id);
                        }
                        else if (ws.mtd_nm__c == 'NONSPONIDREN')
                        {
                            nsidR.add(ws.id);
                        }
                        else if (ws.ws_typ__c == 'axsLeaseRenewal' && ws.mtd_nm__c == 'createLeaseRenewalRequest') {
                            leaseRenewalwsIds.add(ws.id);
                        }

                        else if (ws.ws_typ__c == 'axsLeaseRenewal' && ws.mtd_nm__c == 'createHSESumittalRequest') {
                            leaseRSubmittalReqWsIds.add(ws.id);
                        }

                        else if (ws.ws_typ__c == 'axsLeaseRenewal' && ws.mtd_nm__c == 'UploadDocs'){
                            leaseRenewalDocUploadIds.add(ws.id);
                        }

                        else if (ws.ws_typ__c == 'axsLeaseRenewal' && ws.mtd_nm__c == 'yardiWetSignatureUpdate'){
                            leaseRenewalWetSignUpdateIds.add(ws.id);
                        }

                        else if (ws.ws_typ__c == 'axsLeaseRenewal' && ws.mtd_nm__c == 'yardiInsuarceDetailsUpdate'){
                            leaseRenewalInsDetailsUpdateIds.add(ws.id);
                        }

                        else if (ws.ws_typ__c == 'axsLeaseRenewal' && ws.mtd_nm__c == 'BankAccUpdate') {
                            leaseRenewalyardiBankAttIds.add(ws.id);
                        }

                    }
                }
                if (laDDAStatusUpdateIds!= null && !laDDAStatusUpdateIds.isEmpty()) DccaBatchUtil.updateAXSStatusLA(laDDAStatusUpdateIds);
                if (laDDACreateReqIds != null && !laDDACreateReqIds.isEmpty()) DccaBatchUtil.excLADDABatch(laDDACreateReqIds);
                if (laCRMAssignmentReqIds != null && !laCRMAssignmentReqIds.isEmpty()){
                    System.enqueueJob(new OnboardQueueable('NAME_CHANGE_ASSGINMENT', laCRMAssignmentReqIds));
                }
                if (invDDABatchIds != null && !invDDABatchIds.isEmpty()) DccaBatchUtil.exchInvDDABatch(invDDABatchIds);
                if (invYardiBatchIds != null && !invYardiBatchIds.isEmpty()) DccaBatchUtil.exchInvYardiBatch(invYardiBatchIds);
                if (invBatchIds != null && !invBatchIds.isEmpty()) DccaBatchUtil.exchInvBatch(invBatchIds);
                if (crm_callDDA_AMd_updateMemb!= null && !crm_callDDA_AMd_updateMemb.isEmpty()) DccaBatchUtil.exchCRMUpsertContacts(crm_callDDA_AMd_updateMemb);


                if (laDDAUploadDocIds != null && !laDDAUploadDocIds.isEmpty()){ for (id  ladd:laDDAUploadDocIds){ List<id> laddList = new List<id>(); laddList.add(ladd); LADocs__e lde=new LADocs__e(); lde.wsid__c=ladd; Database.saveresult sr=EventBus.publish(lde); if (sr.isSuccess()) {  System.debug('Successfully inserted WS ID: ' + sr.getId()); } else { for (Database.Error err : sr.getErrors()) { System.debug('The following error has occurred.'); System.debug(err.getStatusCode() + ': ' + err.getMessage()); System.debug('WS fields that affected this error: ' + err.getFields()); } }    } }

                if (cbkIds != null && !cbkIds.isEmpty()){
                    System.enqueueJob(new OnboardQueueable('courierBooking', cbkIds));
                }
                if (cbStsIds != null && !cbStsIds.isEmpty()){
                    System.enqueueJob(new OnboardQueueable('courierStsUpdate', cbStsIds));
                }
                if (stsBatchIds != null && !stsBatchIds.isEmpty()) DccaBatchUtil.exchStsBatch(stsBatchIds);
                if (docBatchIds != null && !docBatchIds.isEmpty()) DccaBatchUtil.exchDocBatch(docBatchIds);
                if (docAmdBatchIds != null && !docAmdBatchIds.isEmpty()) DccaBatchUtil.exchDocAmdBatch(docAmdBatchIds);
                if (sancBatchIds != null && !sancBatchIds.isEmpty()) DccaBatchUtil.exchAddRemoveSancBatch(sancBatchIds);
                if (ltaprvlBatchIds != null && !ltaprvlBatchIds.isEmpty()) DccaBatchUtil.exchdccaLtAprovalBatch(ltaprvlBatchIds);
                if (crmWOBatchIds != null && !crmWOBatchIds.isEmpty()) DccaBatchUtil.exchCRMWOBatch(crmWOBatchIds);
                if (crmStsBatchIds != null && !crmStsBatchIds.isEmpty()) DccaBatchUtil.exchCRMStsBatch(crmStsBatchIds);
                if (accInfoBatchIds != null && !accInfoBatchIds.isEmpty()) DccaBatchUtil.exchAccInfoBatch(accInfoBatchIds);
                //if (pmsUpdateBatchIds != null && !pmsUpdateBatchIds.isEmpty()) DccaBatchUtil.exchPMSUpdateCCRMBatch(pmsUpdateBatchIds);
                if (pmsUpdateBatchIds != null && !pmsUpdateBatchIds.isEmpty())grqWsOnboard.callUpdatePMSInfo(pmsUpdateBatchIds);/*ctrlPMSupdateinfo.upsertContractInfo(pmsUpdateBatchIds);*/
                if (crmDocBatchIds != null && !crmDocBatchIds.isEmpty()) /*DccaBatchUtil.exchCRMDocBatch(crmDocBatchIds);*/ DccaBatchUtil.pushFlDocBatch(crmDocBatchIds);
                /*MS 1.1*/
                if (docOICUploadIds != null && !docOICUploadIds.isEmpty()) DccaBatchUtil.exchOICDocUpload(docOICUploadIds); /* PJ 1.2 */
                if (axdDocBatchIds != null && !axdDocBatchIds.isEmpty()) {
                   // BatchOnboardInfoUpdate objDocUpdate = new BatchOnboardInfoUpdate(axdDocBatchIds);
                    //Database.executeBatch(objDocUpdate, 1);
                    DccaBatchUtil.pushCRMDocBatch(axdDocBatchIds);
                }

                if (oraFuBankIds != null && !oraFuBankIds.isEmpty()) gtFussionWs.createBankAcc(oraFuBankIds[0]);
                if (yardiBankIds != null && !yardiBankIds.isEmpty())
                {System.enqueueJob(new OnboardQueueable('YardiCreateBankFu', yardiBankIds));}
                   // gTYardiInvCreation.createBankAccinYardi(yardiBankIds[0]);
                if (yardiBankAttIds != null && !yardiBankAttIds.isEmpty())
                {
                   for (String wsAttId: yardiBankAttIds) {
                        gTYardiInvCreation.createBankAccAttYardiids(wsAttId);
                    }


                }
                if (cdbgRefund != null && !cdbgRefund.isEmpty())
                {
                    System.enqueueJob(new OnboardQueueable('CreateCDBGREF', cdbgRefund));
                }

                if (cdbgRefundAtt != null && !cdbgRefundAtt.isEmpty())
                {
                      DccaBatchUtil.pushCreateCDBGREFATT(cdbgRefundAtt);
                }
                if (cdbgRefundHisAtt != null && !cdbgRefundHisAtt.isEmpty())
                {
                      DccaBatchUtil.pushCreateCDBGREFHISATT(cdbgRefundHisAtt);
                }
                if (landAssignment != null && !landAssignment.isEmpty()) {
                    System.enqueueJob(new OnboardQueueable('landLeaseAssignment', landAssignment[0]));
                }
                if (lstAppFee != null && !lstAppFee.isEmpty())
                {
                    System.enqueueJob(new OnboardQueueable('ProcessAFee', lstAppFee));
                }
                if (nsidR != null && !nsidR.isEmpty())
                {
                    System.enqueueJob(new OnboardQueueable('NONSPONIDREN', nsidR[0]));
                }
                if (nsidC != null && !nsidC.isEmpty())
                {
                    System.enqueueJob(new OnboardQueueable('NONSPONIDCAN', nsidC[0]));
                }

                if (leaseRenewalwsIds != null && !leaseRenewalwsIds.isEmpty()) {
                        System.enqueueJob(new OnboardQueueable('createLeaseRenewalRequest', leaseRenewalwsIds));
                }

                if (leaseRSubmittalReqWsIds != null && !leaseRSubmittalReqWsIds.isEmpty()) {
                    System.enqueueJob(new OnboardQueueable('createHSESumittalRequest', leaseRSubmittalReqWsIds));
                }
                if (leaseRenewalDocUploadIds != null && !leaseRenewalDocUploadIds.isEmpty()) {
                    System.enqueueJob(new OnboardQueueable('fitoutDocUp', leaseRenewalDocUploadIds[0]));
                }

                if (leaseRenewalWetSignUpdateIds != null && !leaseRenewalWetSignUpdateIds.isEmpty()) {
                    System.enqueueJob(new OnboardQueueable('yardiWetSignatureUpdate', leaseRenewalWetSignUpdateIds));
                }
                if (leaseRenewalInsDetailsUpdateIds != null && !leaseRenewalInsDetailsUpdateIds.isEmpty()) {
                    System.enqueueJob(new OnboardQueueable('yardiInsuarceDetailsUpdate', leaseRenewalInsDetailsUpdateIds));
                }
                if (leaseRenewalyardiBankAttIds != null && !leaseRenewalyardiBankAttIds.isEmpty())
                {
                   for (String wsAttId: leaseRenewalyardiBankAttIds) {
                        gTYardiInvCreation.createBankAccAttLeaseRenewalYardiIds(wsAttId);
                    }
                }
            }
            return Rs;
        }
        public void hIB(list<ws_call__c>news){}
        public void hIA(list<ws_call__c>news){this.excH(news,null,tSCP.IA);}
    }

}
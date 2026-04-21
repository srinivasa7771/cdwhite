/**************************************************************************************************
@Version History
* Version       Date            Name                        Description
        Initial          DHAM                         Initial
        26-06-2024       Prateek Jangir              Updated method to get STATE of transaction and update transaction status as failed if response state is FAILED.
  v1.2  23-12-2024       Sorna Mary                  APD-3180 - ID Card Generation
**************************************************************************************************/
public class boprv {

    public String reqnum {get;set;}
    public String op {get;set;}
    public g_req__c rq {get; set;}
    public g_Tran__c tran {get; set;}
    public Date arrivalDate {get; set;}
    public greccc.PaymentRes transactionDetails {get; set;} //1.1
    public list<g_reqitem__c> lstRqItem {get; set;}
    public String srCode {get;set;}
    public list<itmWrapper> lstitmWrapper {get; set;}
    public string stCode {get;set;}

    public boprv() {
        rq = new g_req__c();
        tran = new g_Tran__c();
        lstRqItem =  new list<g_reqitem__c>();
        lstitmWrapper = new list<itmWrapper>();
    }

    public PageReference searchReq() {
        rq = new g_req__c();
        System.debug('reqnum:: ' + reqnum );
        reqnum = reqnum.trim();

        if (String.isNotBlank(reqnum)) {
            List<g_req__c> lstRq = [Select id, name, sta__c, xadh__c, srvc__r.uid__c from g_req__c where name=:reqnum];
            if (lstRq != null && lstRq.size()>0) {
                rq = lstRq[0];
                System.debug('rq status ' + rq.sta__c);
            }
        }
        return null;
    }

    public PageReference saveRq() {
        Map<String, String> mapSta = new Map<String, String>{'Completed'=>'ok', 'Cancelled'=>'c', 'Rejected'=>'r'};
            Set<String> setItmCds = new Set<String>{'ai', 'la', 'cx', 'eca', 'eci', 'exn', 'apr', 'et', 'eti'};
                Set<String> setEnableDocs = new Set<String>{'insurance', 'Cancellation document'};

                    try{
                        rq = new g_req__c();
                        System.debug('reqnum:: ' + reqnum );

                        if (String.isNotBlank(reqnum)) {
                            List<g_req__c> lstRq = [SELECT id, xtpa__c, name, sta__c, xadh__c, resetOTP__c, ldmob__c, inschk__c, srvc__c, srvc__r.uid__c, AP__c, AOP__c,
                                                           Con__c, Con__r.Photo_ID__c, //v1.2
                                                    (SELECT id, name, itm__r.cd__c FROM Items__r)
                                                    FROM g_req__c WHERE name=:reqnum];
                            if (lstRq != null && lstRq.size()>0) {
                                rq = lstRq[0];
                                System.debug('rq status ' + rq.sta__c);
                            }else{
                                gu.AddErrorMsg('Request# "' + String.escapeSingleQuotes(reqnum) + '" not found!');
                                return null; // show error and exit
                            }
                        }

                        //v1.2 Start
                        if (op == 'id' || op == 'letter') {
                            if (rq.AP__c > 0) {
                                String oldSta = rq.STA__c;
                                rq.STA__c = 'Open';
                                rq.ID_Generated__c = false;
                                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                                    update rq;
                                }

                                List<g_reqDoc__c> phtoDoc = [ SELECT Id FROM g_reqDoc__c WHERE Name LIKE '%photo%' and RQ__c=:rq.id ORDER BY LastModifiedDate DESC LIMIT 1 ];

                                if (!phtoDoc.isEmpty() && rq.Con__c != NULL) {

                                    List<Attachment> photoAtt = [ SELECT Id FROM Attachment WHERE ParentId = :phtoDoc[0].Id ORDER BY CreatedDate DESC LIMIT 1 ];

                                    if (!photoAtt.isEmpty() && rq.Con__r.Photo_ID__c != photoAtt[0].Id) {
                                        update new Contact (Id = rq.Con__c, Photo_ID__c = photoAtt[0].Id);
                                    }

                                }

                                rq.STA__c = oldSta;
                                rq.ID_Generated__c = true;
                                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                                    update rq;
                                }

                                gu.addSuccessMsg('Request# ' + String.escapeSingleQuotes(reqnum) + ' : ' + ((op == 'id') ? 'ID' : 'Letter') + ' has been generated successfully!');
                                return null;

                            } else {
                                gu.addErrorMsg('Payment is pending for the request, please inform client to make the payment.');
                                return null;
                            }
                        }
                        //v1.2 End

                        //for status update
                        if (mapSta.containsKey(op)) {
                            If(!op.equalsIgnoreCase('completed')) {
                                if (rq.AP__c > 0) {
                                    gu.AddWarningMsg('The request cannot be ' + String.escapeSingleQuotes(op) + ' as payments are already processed. Please contact the back office.');
                                    return null;
                                }
                                else if (rq.STA__c != 'Draft' && rq.STA__c != 'Open') {
                                    gu.AddWarningMsg('The request cannot be ' + String.escapeSingleQuotes(op) + ' due to its current status. Please contact the back office if needed');
                                    return null;
                                }
                            }
                            if ((rq.srvc__r.uid__c=='tad' || rq.srvc__r.uid__c=='tbg') && rq.xtpa__c == null && (op.equalsIgnoreCase('Cancelled') || op.equalsIgnoreCase('Rejected'))) {
                                rq.xtpa__c=2500;
                            }

                            rq.STA__c = op;
                            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                                update rq;
                            }

                            if (!op.equalsIgnoreCase('completed')) {
                                updateItms(rq, mapSta.get(op));
                            }
                            gu.AddSuccessMsg('Request# ' + String.escapeSingleQuotes(reqnum) + ' has been ' + String.escapeSingleQuotes(op) + ' successfully!');
                            return null;
                        }

                        if (op=='resetOTP') {
                            if (!rq.resetOTP__c) {
                            rq.resetOTP__c = true;
                            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                                update rq;
                            }
                            gu.AddSuccessMsg('OTP count has been reset to allow another 5 attempts.');
                            }else {gu.AddSuccessMsg('OTP count has already been reset 5 attempts please check the mobile number#'+rq.ldmob__c);}
                            return null;
                        }
                        // for insertion of items
                        if (setItmCds.contains(op)) {

                            List<g_srvcitm__c> srvcItms = [select id, name, cd__c  From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c=:rq.srvc__c ];
                            Set<String> setSrvcItms = new Set<String>();

                            for (g_srvcitm__c itm : srvcItms) {
                                setSrvcItms.add(itm.cd__c);
                            }

                            if (!setSrvcItms.contains(op)) {
                                gu.AddErrorMsg('Requested item does not exist for Request# "' + String.escapeSingleQuotes(reqnum) + '", please contact axs backoffice.' );
                                return null;
                            }

                            List<g_reqitem__c> lstExtItms = [SELECT Id, name, itm__r.cd__c FROM g_reqitem__c WHERE RQ__c =:rq.id];
                            Set<String> setExtItms = new Set<String>();
                            for (g_reqitem__c rqItm: lstExtItms) {
                                setExtItms.add(rqItm.itm__r.cd__c);
                            }
                            if (setExtItms.contains(op)) {
                                gu.AddErrorMsg('Item is already enabled for Request# ' +reqnum );
                                return null;
                            }

                          if (String.isBlank(rq.xadh__c)) {rq.xadh__c = op+';';}else{rq.xadh__c += ';' + String.escapeSingleQuotes(op) + ';';}
                            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                                update rq;
                            }
                            if (op.equalsIgnoreCase('ai')) {
                                List<g_reqitem__c> aiItms = [SELECT Id, name, xad__c, itm__r.cd__c FROM g_reqitem__c WHERE RQ__c =:rq.id and itm__r.cd__c='ai'];
                                System.debug('arrivalDate :: ' + arrivalDate);
                                if (aiItms != null &&  aiItms.size()>0 && arrivalDate != null) {
                                    aiItms[0].xad__c = arrivalDate;
                                    update aiItms[0];
                                }
                            }
                            gu.AddSuccessMsg('Request# ' + String.escapeSingleQuotes(reqnum) + ' has been updated successfully!');
                            return null;
                        }
                        // to enable the request item docs
                        if (setEnableDocs.contains(op)) {
                            System.debug('op :: ' + op);

                            if (rq.inschk__c && op.equalsIgnoreCase('insurance')) {
                                gu.AddErrorMsg('Applicant opted for ADNIC insurance policy, Health insurance document cannot be enabled.');
                                return null;
                            }

                            String query = 'select id, name, mnAts__c, Req__c, reqAts__c from g_reqitemDoc__c where Re__c=:reqnum and Tp__c =:op';

                            if (op.equalsIgnoreCase('cancellation document')) {
                                query +=' and reqItm__r.name =\'RP cancellation Inside UAE\''; //Exit Process
                            }

                            List<g_reqitemDoc__c> lstReqItmDoc = Database.query(query);
                            System.debug('op :: ' + lstReqItmDoc);

                            if (lstReqItmDoc != null && lstReqItmDoc.size()>0) {
                                lstReqItmDoc[0].mnAts__c = 1;lstReqItmDoc[0].Req__c = true;lstReqItmDoc[0].reqAts__c = true;update lstReqItmDoc[0];
                                gu.AddSuccessMsg('"' + op.replace('document', '') +' document" has been enabled successfully for Request# ' +reqnum);
                            }else{
                                gu.AddErrorMsg('"' + op.replace('document', '') +' document" does not exists for Request# ' +reqnum);
                            }
                            return null;
                        }
                    }
                    catch (Exception ex) {
                        gu.AddErrorMsg('** Exception:'+ex.getMessage() + ':: ' + ex.getStackTraceString());
                        System.Debug('** Exception:'+ex.getMessage() + ':: ' + ex.getStackTraceString());
                    }

        return null;
    }

    public PageReference searchTran() {
        tran = new g_Tran__c();
        System.debug('Transaction number:: ' + reqnum);
         List < g_TranItem__c > Tis = new List < g_TranItem__c > ();
        List < g_Tran__c > lstTran = [Select RQ__r.srvc__r.Category__c, niord__c, Last_Modified_Since__c,
            RQ__r.srvc__r.AddOnSrv__c, RQ__r.srvc__r.payMd__c, Id, Name, STA__c, TP__c, A__c,
            md__c, gwrf__c, gwcd__c, gwdt__c, gwmsg__c, Acc__r.adx__c, Acc__r.bg__c, Acc__r.Name,
            Acc__r.BillingStreet, Acc__r.BillingPostalCode, Acc__r.lc__c, RQ__r.xaed__c, RQ__r.xanum__c,
            RQ__r.Full_Name__c, RQ__r.Acc__r.Name, RQ__r.xaloc__c, RQ__r.CreatedBy.Name, RQ__r.Zone__c,
            RQ__r.rmob__c, RQ__r.xbn__c, RQ__r.xbrnd__c, RQ__r.Id, RQ__c, RQ__r.xfpc__c, RQ__r.AP__c,
            RQ__r.xtpa__c, RQ__r.Name, RQ__r.STA__c, RQ__r.srvc__c, RQ__r.srvc__r.Name, RQ__r.srvc__r.suvtp__c,
            RQ__r.srvc__r.uid__c, RQ__r.AOP__c, RQ__r.srvc__r.stg__r.apx__c, RQ__r.CreatedDate,
            RQ__r.xcs__c, RQ__r.xcn__c, (select id, A__c, exp__c, itm__c, itm__r.exp__c, itm__r.xcawb__c,
            itm__r.itm__r.Name, itm__r.itm__r.lbl__c, itm__r.sta__c, itm__r.sta__r.Courier_Stage__c,
            itm__r.sta__r.next_status__r.Courier_Stage__c, itm__r.sta__r.Next_Status__c, itm__r.sta__r.staown__c,
            itm__r.sta__r.cd__c, itm__r.xcasc__c, itm__r.xcub__c,
                itm__r.xcco__c from Items__r where isDeleted = false order by itm__r.itm__r.ord__c) from g_Tran__c where md__c='Credit / Debit Card' and name=:reqnum and isDeleted = false];
        if (lstTran != null && lstTran.size()>0) {
            tran = lstTran[0];
             if (String.isNotBlank(tran.niord__c) || (String.isNotBlank(tran.gwrf__c) && tran.gwrf__c != null && (tran.gwrf__c).length()>15)) {

                    String ordId=(String.isNotBlank(tran.gwrf__c) && tran.gwrf__c != null && (tran.gwrf__c).length()>15)?tran.gwrf__c:tran.niord__c;
                    transactionDetails =new greccc().getPaymentResponse(ordId);
                    if (transactionDetails != null && tran.STA__c == 'Open' && tran.Last_Modified_Since__c>14 && ((transactionDetails.STATE).touppercase() == 'STARTED' || (transactionDetails.STATE).touppercase() == 'FAILED')) {
                    tran.STA__c = 'Cancelled'; for (g_TranItem__c i: tran.Items__r) { i.STA__c ='Cancelled'; Tis.add(i); } if (tran != null) { update tran; } if (Tis != null) { update Tis; }
                    }
                    else if (tran.Last_Modified_Since__c<14 && tran.STA__c == 'Open') {
                     gu.AddErrorMsg('System is currently reconciling with the payment gateway and bank. Please wait for 15 minutes.');
                    }

             }

        }else{
            gu.AddErrorMsg('Transaction "' + String.escapeSingleQuotes(reqnum) + '" not found!');
        }
        return null;
    }
    @TestVisible
    private Boolean updateItms(g_req__c rq, String itmCode) {
        map < String, Id > mapSTA = new map < String, Id > ();

        for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =:rq.srvc__c and cd__c = :itmCode]) {
            mapSTA.put(s.itm__r.cd__c, s.Id);
        }
        list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c from g_reqitem__c where RQ__c =: rq.Id and isDeleted = false and sta__r.Tp__c = 'Open'];
        list < g_reqitem__c > toUpdate = new list < g_reqitem__c > ();

        for (g_reqitem__c i: items) {
            if (mapSTA.get(i.itm__r.cd__c) == null) {gu.AddErrorMsg(Label.msgNFSTAC);return false;}
            i.sta__c = mapSTA.get(i.itm__r.cd__c);
            toUpdate.add(i);
        }
        if (toUpdate.size() > 0) {
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update toUpdate;
            }
        }
        return true;
    }

    public PageReference getRefundItm() {
        system.debug('op==' + op);
        system.debug('reqnum==' + reqnum);
        srCode = '';
        system.debug('options==' + String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('options')));
        system.debug('rq==' + String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('rq')));
        String itmName = '';
        if (op == 'sd') {
            srCode = '041';
            itmName = 'Security Deposit';
            stCode = 'r';
        }
        else if (op == 'epc') {
            srCode = '050';
            itmName = 'Emirates ID Amendment';
            stCode = 'c';
        }
        else if (op == 'ef') {
            itmName = 'Express Service Fees';
            stCode = 'c';
        }
        String strItemQuery = 'select id, Name, AP__c, sta__c , Rq__c, Rq__r.Service_code__c, itm__r.cd__c from g_reqitem__c where itm__r.cd__c=:op ' +
            ' and itm__r.Name=:itmName  and AP__c>0 and sta__r.cd__c!=\'c\' and  sta__r.cd__c!=\'r\' ' + ' and  Rq__r.Name=:reqnum';
        if (String.isNotBlank(srCode)) {
            strItemQuery += ' and  service_code__c=:srCode ';
        }
        system.debug('strItemQuery====' + strItemQuery);
        lstRqItem = database.query(strItemQuery);
        lstitmWrapper = new list < itmWrapper > ();
        for (g_reqitem__c objItem: lstRqItem) {
            itmWrapper obj = new itmWrapper(objItem);
            if (String.isBlank(srCode)) {
                srCode = objItem.Rq__r.Service_code__c;
            }
            lstitmWrapper.add(obj);
        }
        return null;
    }
    public PageReference refundItm() {
        if (System.label.Refund_user.contains(UserInfo.getUserId().substring(0, 15))) {
            try{
                list<g_req__c> lstReq = [Select Id from g_req__c where name =: reqnum.trim()];
                if (lstReq.isEmpty()) {
                    gu.AddErrorMsg('Please enter valid request number.');
                    return null;
                }
                else {
                    getRefundItm();
                    if (lstitmWrapper.isEmpty()) {
                        gu.addErrorMsg('Refund is in process for this request number.');
                        return null;
                    }
                    else {
                        system.debug('options==' + String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('rfitems')));
                        String itemToRef = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('rfitems'));
                        List < g_reqitem__c > lstItmToCancel = new List < g_reqitem__c > ();
                        List < String > lstitem = itemToRef.split(', ');
                        map < String, Id > mSTA = new map < String, Id > ();
                        system.debug('srCode==' + srCode);
                        system.debug('op==' + op);
                        for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__r.uid__c =: srCode and cd__c =: stCode and itm__r.cd__c =: op]) {
                            mSTA.put(s.itm__r.cd__c, s.Id);
                        }
                        system.debug('mSTA==' + mSTA);
                        for (g_reqitem__c objItem: lstRqItem) {
                            objItem.sta__c = mSTA.get(objItem.itm__r.cd__c);
                            lstItmToCancel.add(objItem);
                        }
                        system.debug('lstItmToCancel===' + lstItmToCancel);
                        if (!lstItmToCancel.isEmpty()) {
                            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                                update lstItmToCancel;
                            }
                        }
                        getRefundItm();
                    }
                }
                gu.AddSuccessMsg('Refund request has been succesfully registered.');
            }
            catch (exception ex) {
                gu.AddErrorMsg('There is some technical glitch , Please contact Axs Support.');
            }
        }
        else {
            gu.AddErrorMsg('Please contact GSO refund team.');
            return null;
        }
        return null;
    }

    public class itmWrapper { public g_reqitem__c obj { get; set; } public Boolean selected { get; set; } public itmWrapper(g_reqitem__c opp) { this.obj = opp; this.selected = false; } }
}
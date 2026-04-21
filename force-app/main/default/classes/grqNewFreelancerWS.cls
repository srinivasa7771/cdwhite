@RestResource(urlMapping = '/newFreelancer/*')
global class grqNewFreelancerWS {
    public List < ReqData > ReqData;
    @HttpPost
    global static void doPost() {
        StatusResponse res = new StatusResponse();
        String reqBody = RestContext.request.requestBody.toString();
        ws_call__c wc = null;
        try {
            system.debug('Req Body::' + reqBody);
            ReqData rqData = (ReqData) JSON.deserialize(reqBody, ReqData.class);
            //system.debug('rqData.appicationnum::' + Resp.ReqData);
            // ReqData rqData = Resp.ReqData[0];
            String z,addr;
            if (String.isNotBlank(rqData.park)){
                if (rqData.park == 'DIC') {
                    z = 'Dubai Internet City';
                    addr = 'Ground Floor,Building 16,Dubai Internet City';
                }else if (rqData.park == 'DPC') { z = 'Dubai Production City'; addr = 'Ground Floor,Building 16,Dubai Production City'; }else if (rqData.park == 'DOC') {z = 'Dubai Outsource City'; addr = 'Ground Floor,Building 16,Dubai Outsource City'; }else if (rqData.park == 'DI') { z = 'Dubai Industrial City'; addr = 'Ground Floor,Building 16,Dubai Industrial City'; }else if (rqData.park == 'DIAC') { z = 'Dubai International Academic City'; addr = 'Ground Floor,Building 16,Dubai International Academic City'; }
                else if (rqData.park == 'DMC') {
                    z = 'Dubai Media City';
                    addr = 'Floor 2,Building 2,Dubai Media City';
                }else if (rqData.park == 'DKP') {z = 'Dubai Knowledge Park'; addr = 'Ground Floor,Building 9,Dubai Knowledge Park';
                }
                else if (rqData.park == 'DSC') {
                    z = 'Dubai Studio City'; addr = 'Ground Floor,Building 9,Dubai Studio City';
                }else if (rqData.park == 'DDD') {z = 'Dubai Design District'; addr = 'Floor 3,Building 3,Dubai Design District';}else if (rqData.park == 'DSP') { z = 'Dubai Science Park'; addr = 'Floor 3,Building 3,Dubai Science Park'; }else if (rqData.park == 'D3') { z = 'Dubai Design District'; addr = 'Floor 3,Building 3,Dubai Design District'; }else{ z = 'Dubai Internet City'; addr = 'Ground Floor,Building 16,Dubai Internet City'; }
            }

            system.debug('rqData.park::'+rqData.park);
            system.debug('z::'+z);
            String srvId = '',legalFrmwrk = '',
            /*licType = 'DDA';*/ /*MS 1.1*/
            licType = (String.isNotBlank(rqData.productCategory) && rqData.productCategory == 'Land') ? rqData.licenseType : 'DDA'; /*MS 1.1*/


            if (String.isNotBlank(rqData.srtype) && rqData.srtype == 'Freelancer'){
                srvId = Label.New_Freelancer_SID;
                legalFrmwrk = rqData.srtype;
            } else{
                srvId = Label.Onboarding_SID;

               /* if (String.isBlank(rqData.srtype)) {
                    licType = 'DED';
                }*/
                /*else { */

                    if (String.isBlank(rqData.srtype) || rqData.srtype == 'Free Zone Limited Liability company')
                        legalFrmwrk = 'FZ-LLC';
                    else if (rqData.srtype == 'Branch of a UAE Company')
                        legalFrmwrk = 'Branch of UAE Company';
                    else if (rqData.srtype == 'Branch of a Foreign Company')
                        legalFrmwrk = 'Branch of Foreign Company';
                    else
                    legalFrmwrk = rqData.srtype;
                /*} */
            }

            if (String.isNotBlank(rqData.productCategory) && rqData.productCategory == 'Land' && String.isNotBlank(rqData.licenseType) && rqData.licenseType == 'DED') /*MS 1.1*/
            {
                legalFrmwrk = 'Branch of UAE Company'; /*MS 1.1*/
            }

            if (String.isNotBlank(rqData.leadId) && String.isBlank(rqData.axsSrNo) && String.isBlank(rqData.partyid) && String.isBlank(rqData.accid)){

               List<g_Req__c> dpRqLst =  [select id from g_Req__c where srvc__c=:srvId and createddate=TODAY and xceml__c=:rqData.emailid];
                if (dpRqLst != null && dpRqLst.size() > 10){
                    res.msg = 'Duplicate requests exist with provided email';
                    res.msgcode = 'F';
                }
                else{
                 String mb = rqData.phoneno;
                 string ldphno = mb.replaceAll('\\D', '');
                dpRqLst =  [select id,ldpcnt__c,name from g_Req__c where srvc__c=:srvId and Acc__r.lc__c=:Label.Onboarding_Account_LC and xcfn__c=:rqData.accountname and ldmob__c=:ldphno and xaccbrand__c=:z and xfb__c=:legalFrmwrk and xceml__c=:rqData.emailid order by createddate desc];
                 if (dpRqLst != null && dpRqLst.size() > 0){
                    decimal dpcnt = (dpRqLst[0].ldpcnt__c !=null && dpRqLst[0].ldpcnt__c !=0) ? (dpRqLst[0].ldpcnt__c + 1) : dpRqLst.size();
                    dpRqLst[0].ldpcnt__c = dpcnt; update  dpRqLst; res.msg = 'Success'; res.msgcode = 'S';  res.axsSrNo = dpRqLst[0].name;
                }
               else{
                Account onbordingAcc = (Test.isRunningTest()) ?  [select id,name from Account limit 1] : [select id,name from Account where id=:Label.Onboarding_Account];

                g_Req__c r = new g_Req__c(os__c = 'Lead generated',ccrmldid__c=rqData.leadId,srvc__c = srvId, xceml__c = rqData.emailid,xaccbrand__c=z, xbrnd__c = z, xcfn__c = rqData.accountname,xcfan__c= rqData.accountname, xadtx1__c = reqBody, Acc__c = onbordingAcc.id,sta__c='Draft',PRM_Name__c=rqData.prmFirstName+' '+rqData.prmLastName,PRM_Email__c=rqData.prmEmail,PRM_MobileNo__c=rqData.prmMobile,PRM_LandlineNo__c=rqData.prmPhone,xfb__c =legalFrmwrk,xvtyp__c=licType, parCat__c = rqData.productCategory); /*MS 1.1*/

                if (String.isNotBlank(rqData.phoneno) && rqData.phoneno.contains(' ') )
                {
                    r.xui__c = rqData.phoneno.substringBefore(' ');
                    r.xcmob__c = rqData.phoneno.substringAfter(' ').replaceAll('\\D', '');
                }
                else if (String.isNotBlank(rqData.phoneno)){
                    String phno = mb.replaceAll('\\D', '');
                    if (phno.startsWith('971')){
                         r.xui__c = '+971';
                         r.xcmob__c = phno.substringAfter('971');
                    }
                    else if (phno.startsWith('05')){
                        r.xui__c = '+971';
                        r.xcmob__c = phno.substringAfter('0');
                    }
                    else
                       r.xcmob__c = phno;
                }

                mb = mb.replaceAll('\\D', '');
                r.ldmob__c = mb;
                insert r;
                res.msg = 'Success'; res.msgcode = 'S';
                g_Req__c rq =  [select id,name from  g_Req__c where id=:r.id]; res.axsSrNo = rq.name;
               }
              }

            }
            else if (String.isNotBlank(rqData.partyid) && String.isNotBlank(rqData.accid) && String.isNotBlank(rqData.axsSrNo)) {
                system.debug('reqBodyreqBody--' + reqBody);
                system.debug('z1::'+z);
                res.msg = 'Success';
                res.msgcode = 'S';
                Decimal ddaAmnt = 0;
                List<g_Req__c> rqLst =  [select id,xvtyp__c,name,xpmsle__c,skpu__c,xadh__c,acc__c,xdei__c,xdccaRq__c,xadtx1__c,ok__c,cldt__c, clcnt__c from g_Req__c where (name=:rqData.axsSrNo or id=:rqData.axsSrNo)];
                if (rqLst != null && !rqLst.isEmpty()){

                    List < Account > acc = [select id, Name,clt__c,lc__c,Phone,billingstreet, on__c, licn__c, ORACLE_PARTY_ID__c, Prk__c, Legal_Framework__c, mxPortalUsers__c, vespe__c, Type, d3_aid__c, ccrm_sfid__c,PRM_Name__c,PRM_Email__c,PRM_MobileNo__c,createddate from Account where id =: rqLst[0].acc__c];

                    if (acc != null && acc.size() > 0 && (String.isBlank(acc[0].lc__c) || acc[0].lc__c != Label.Onboarding_Account_LC)) {
                        /*if (String.isNotBlank(rqData.srtype) && rqData.srtype != 'Freelancer'){String resStr = grqWsOnboard.fetchAccInfo(rqData.accid);rqLst[0].xadtx3__c = resStr;}*/
                        if (acc[0].ccrm_sfid__c != rqData.accid){
                           List<Account> dupAccLst =  [select id,ccrm_sfid__c,d3_aid__c,ORACLE_PARTY_ID__c,toBeDeleted__c from account where ccrm_sfid__c=:rqData.accid];
                            if (dupAccLst != null && !dupAccLst.isEmpty()){
                                dupAccLst[0].ccrm_sfid__c = '';dupAccLst[0].d3_aid__c = '';dupAccLst[0].ORACLE_PARTY_ID__c = '';dupAccLst[0].toBeDeleted__c = true; update dupAccLst;
                            }
                        }
                        String accName = AxsMethods.trimAndCapitalize(rqData.accountname);
                        acc[0].Name = accName;
                        acc[0].on__c = accName;
                        acc[0].licn__c = accName;
                        acc[0].ORACLE_PARTY_ID__c = rqData.partyid;
                        acc[0].Prk__c = z;
                        //acc[0].billingstreet = addr;
                        if (legalFrmwrk == 'Freelancer'){
                            acc[0].Legal_Framework__c = 'Freelancer';
                            acc[0].vespe__c = 1;
                            rqLst[0].cldt__c = (GDRFAUtil.noOfWorkingDays((acc[0].createddate).date(), 3)).date();
                            rqLst[0].clcnt__c = 0;
                        }
                        acc[0].mxPortalUsers__c = 1;
                        acc[0].Type = 'Customer - External';

                        acc[0].d3_aid__c = rqData.accid;
                        acc[0].ccrm_sfid__c = rqData.accid;
                        acc[0].PRM_Name__c = rqData.prmFirstName+' '+rqData.prmLastName;
                        acc[0].PRM_Email__c = rqData.prmEmail;
                        acc[0].PRM_MobileNo__c = rqData.prmMobile;
                        acc[0].Phone = rqData.phoneno;
                        /*start update as part of land By Meenu*/
                          acc[0].clt__c = rqData.productCategory == 'Land Assignment' ? 'Land' : rqData.productCategory; /*MS 1.1*/
                        acc[0].lctp__c = rqData.licenseType; /*MS 1.1*/
                        /*end update as part of land By Meenu*/
                        if (String.isNotBlank(rqData.leaseClassification) && rqData.leaseClassification == 'PMS') {
                            rqLst[0].xpmsle__c = true;
                            rqLst[0].xadh__c = rqLst[0].xadh__c + 'psf;';
                            acc[0].clt__c = 'PMS Lease';
                            //wc = new ws_call__c(pmid__c = rqData.accid, ws_typ__c = 'Onboarding', mtd_nm__c = 'fetchAccInfo', intsts__c = 'Ready for Integration');
                        } else {
                            rqLst[0].xpmsle__c = false;
                            //acc[0].clt__c = ''; /*MS 1.1*/
                        }
                        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, acc);
                        update secDec.getRecords();
                        map<String, string> mapwoStatus = new  map<String, string>();
                        if (legalFrmwrk != 'Freelancer'){
                            grqWsOnboard.Records rec = new grqWsOnboard.Records();
                            if (rqData.workOrders != null && !rqData.workOrders.isEmpty()){
                                List<WO> wlst = rqData.workOrders;
                                List<grqWsOnboard.WorkOrderInfo> workorders = new List<grqWsOnboard.WorkOrderInfo>();

                                for (WO w : wlst){
                                    grqWsOnboard.WorkOrderInfo woInfo = new grqWsOnboard.WorkOrderInfo();
                                    woInfo.recid = w.workOrderId;
                                    mapwoStatus.put(w.workOrderId, w.status);
                                     /* woInfo.recType = w.RecordTypeDeveloperName;*//*MS 1.1*/
                                    if (woInfo.recType == 'Government_Relations')/*MS 1.1*/
                                        rec.gvtRlsWorkId = w.workOrderId;/*MS 1.1*/
                                    if (w.RecordTypeDeveloperName == 'Government_Relations') /*MS 1.1*/
                                        { woInfo.recType = 'License_Registration_Request';} /*MS 1.1*/
                                    else {woInfo.recType = w.RecordTypeDeveloperName;} /*MS 1.1*/

                                    woInfo.status = w.status;
                                    if (woInfo.recType == 'Brand_Approval')
                                        rec.brandWorkid = w.workOrderId;
                                    if (woInfo.recType == 'Security_Clearance')
                                        rec.scWorkid = w.workOrderId;
                                    if (woInfo.recType == 'License_Registration_Request')
                                        rec.nameResWorkid = w.workOrderId;

                                    workorders.add(woInfo);
                                }
                                rec.crmAccId = rqData.accid;
                                rec.workorders = workorders;
                                rec.licenseType = licType;
                                rec.DDAReqNo = rqData.appicationnum;
                                String adhoctx3 = Json.serialize(rec);
                                rqLst[0].xadtx3__c = adhoctx3;
                            }
                        }

                        rqLst[0].xdei__c = rqData.ddaid;
                        rqLst[0].xdccaRq__c = rqData.appicationnum;
                        system.debug('rqData.skipLeaseValidations:::'+rqData.skipLeaseValidations);
                        /*MS 1.1 */
                        rqLst[0].xadh__c = (String.isNotBlank(rqLst[0].xadh__c) && rqLst[0].xvtyp__c != 'DED') ? (rqLst[0].xadh__c + 'ec;') : (rqLst[0].xvtyp__c != 'DED') ? 'ec;' : rqLst[0].xadh__c;
                        if (rqData.skipLeaseValidations != null && rqData.skipLeaseValidations) {
                            rqLst[0].skpu__c = rqData.skipLeaseValidations;
                            rqLst[0].xadh__c = (String.isNotBlank(rqLst[0].xadh__c) && rqLst[0].xvtyp__c != 'DED') ? (rqLst[0].xadh__c + ';nl;ec;') : (rqLst[0].xvtyp__c != 'DED') ? 'nl;ec;' : rqLst[0].xadh__c;
                            wc = new ws_call__c(pmid__c = rqData.accid, ws_typ__c = 'Onboarding', mtd_nm__c = 'fetchAccInfo', intsts__c = 'Ready for Integration');
                        }
                        if (String.isNotBlank(rqData.leaseClassification) && rqData.leaseClassification == 'PMS') {
                            rqLst[0].xpmsle__c = true;
                            rqLst[0].xadh__c = rqLst[0].xadh__c + 'psf;';

                        } else {
                            rqLst[0].xpmsle__c = false;
                        }
                        rqLst[0].xadtx1__c = reqBody;

                        SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.UPDATABLE, rqLst);
                        update secDec2.getRecords();
                        if (wc != null)
                         insert wc;
                      res.axsSrNo = rqLst[0].name;
                      res.axsAccId = acc[0].id;
                        if (!mapwoStatus.isEmpty())
                        {
                            updateStatus(mapwoStatus);
                        }
                    }
                    else{
                        rqLst[0].xdei__c = rqData.ddaid; rqLst[0].xdccaRq__c = rqData.appicationnum;rqLst[0].xadtx1__c = reqBody;rqLst[0].ok__c = true;update rqLst; res.axsSrNo = rqLst[0].name; res.axsAccId = '';
                       /*res.msg = 'Lead conversion issue'; res.msgcode = 'F';*/
                    }


                /*else {
                    a = new Account(Name = rqData.accountname,Phone=rqData.phoneno, d3_aid__c = rqData.accid, ccrm_sfid__c = rqData.accid,billingstreet=addr, vespe__c = 1, on__c = rqData.accountname, licn__c = rqData.accountname, ORACLE_PARTY_ID__c = rqData.partyid, Prk__c = z, Legal_Framework__c = 'Freelancer', mxPortalUsers__c = 1, Type = 'Customer - External',PRM_Name__c=rqData.prmFirstName+' '+rqData.prmLastName,PRM_Email__c=rqData.prmEmail,PRM_MobileNo__c=rqData.prmMobile);
                    insert a;
                }
                contact con = new Contact(lastname = rqData.accountname, email = rqData.emailid, p__c = rqData.accid, accountid = a.id);
                insert con;
                String nicknm = rqData.accountname.substring(0, 2) + String.valueof(Math.random()).substring(2, 7);
                User nwU = new User();
                nwU.LastName = rqData.accountname;
                nwU.Email = rqData.emailid;
                nwU.Username = nicknm + '@' + (rqData.park).toLowerCase() + '.axs';
                nwU.Alias = nicknm;
                nwU.ProfileId = gU.csStr('gpSU');
                nwU.ContactId = con.id;
                nwU.CommunityNickname = rqData.accountname.substring(0, 1) + rqData.park + nicknm;
                nwU.IsActive = true;
                nwU.TimeZoneSidKey = 'Asia/Dubai';
                nwU.LocaleSidKey = 'en_GB';
                nwU.LanguageLocaleKey = 'en_US';
                nwU.EmailEncodingKey = 'ISO-8859-1';
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerUserEmail = true;
                nwU.setOptions(dmo);
                insert nwU;
                system.debug('aa--' + a.id);
                system.debug('rqData.ddaid--' + rqData.ddaid);
                system.debug('z--' + z);
                system.debug('rqData.accountname--' + rqData.accountname);
                g_Req__c r = new g_Req__c(xdei__c = rqData.ddaid, srvc__c = Label.New_Freelancer_SID, xdccaRq__c = rqData.appicationnum, xceml__c = rqData.emailid,xaccbrand__c=z, xbrnd__c = z, xcfn__c = rqData.accountname, xadtx4__c = reqBody, Acc__c = a.id,sta__c='Draft',PRM_Name__c=rqData.prmFirstName+' '+rqData.prmLastName,PRM_Email__c=rqData.prmEmail,PRM_MobileNo__c=rqData.prmMobile,PRM_LandlineNo__c=rqData.prmPhone);
                if (String.isNotBlank(rqData.phoneno) && rqData.phoneno.contains(' ') )
                {
                    r.xui__c = rqData.phoneno.split(' ')[0];
                    r.xcmob__c = rqData.phoneno.split(' ')[1];
                }

                insert r; */

                }
                else{
                    res.msg = 'shared axs request no  not avaliable '; res.msgcode = 'F';
                }

            }else if (String.isNotBlank(rqData.axsSrNo)){
                                system.debug('reqBodyreqBody--' + reqBody);
                                system.debug('z1::'+z);
                                res.msg = 'Success';
                                res.msgcode = 'S';

                                List<g_Req__c> urqLst=  [select id,xceml__c,xui__c,xcmob__c,ldmob__c,name,acc__c,xdei__c,xdccaRq__c,xadtx1__c from g_Req__c where name=:rqData.axsSrNo];
                                if (urqLst!= null && !urqLst.isEmpty()){
                                 urqLst[0].xadtx1__c = reqBody;
                                 urqLst[0].xceml__c = rqData.emailid;

                               String mb = rqData.phoneno;
                                /*if (String.isNotBlank(rqData.phoneno) && rqData.phoneno.contains(' ') )
                                {
                                    urqLst[0].xui__c = rqData.phoneno.substringBefore(' ');
                                    urqLst[0].xcmob__c = rqData.phoneno.substringAfter(' ').replaceAll('\\D', '');
                                }
                                else if (String.isNotBlank(rqData.phoneno)){
                                    String phno = mb.replaceAll('\\D', '');
                                    if (phno.startsWith('971')){
                                          urqLst[0].xui__c = '+971';
                                         urqLst[0].xcmob__c = phno.substringAfter('971');
                                    }
                                    else if (phno.startsWith('05')){
                                        urqLst[0].xui__c = '+971';
                                       urqLst[0].xcmob__c = phno.substringAfter('0');
                                    }
                                    else
                                      urqLst[0].xcmob__c = phno;
                                }*/

                                mb = mb.replaceAll('\\D', '');
                                urqLst[0].ldmob__c = mb;
                                SObjectAccessDecision secDec3 = Security.stripInaccessible(AccessType.UPDATABLE, urqLst);
                                update secDec3.getRecords();

                                }


                    }
                    /**/
            else if (String.isNotBlank(rqData.MethodName) && rqData.MethodName == 'Existing' && String.isBlank(rqData.axsSrNo) && String.isNotBlank(rqData.partyid) && String.isNotBlank(rqData.accid) )
            {
                Account objAccount;
                List<Account> lstAccount =  [select id, Name, clt__c, lc__c, Phone, billingstreet, on__c, licn__c, ORACLE_PARTY_ID__c, Prk__c,
                                       Legal_Framework__c, mxPortalUsers__c, vespe__c, Type, d3_aid__c, ccrm_sfid__c, PRM_Name__c, PRM_Email__c,
                                       PRM_MobileNo__c, createddate from Account where ORACLE_PARTY_ID__c =: rqData.partyid or ccrm_sfid__c =:rqData.accid limit 1];
                if (lstAccount != null && !lstAccount.isEmpty())
                {
                    objAccount = lstAccount[0];
                    if (objAccount.ccrm_sfid__c != rqData.accid) {
                        List < Account > dupAccLst = [select id, ccrm_sfid__c, d3_aid__c, ORACLE_PARTY_ID__c, toBeDeleted__c from account where ccrm_sfid__c =: rqData.accid];
                        if (dupAccLst != null && !dupAccLst.isEmpty()) {
                            dupAccLst[0].ccrm_sfid__c = '';
                            dupAccLst[0].d3_aid__c = '';
                            dupAccLst[0].ORACLE_PARTY_ID__c = '';
                            dupAccLst[0].toBeDeleted__c = true;
                            SObjectAccessDecision secDec4 = Security.stripInaccessible(AccessType.UPDATABLE, dupAccLst);
                            update secDec4.getRecords();
                        }
                    }
                }
                else
                {
                    objAccount = new Account();
                }
                system.debug('objAccount==='+objAccount);
                objAccount.ccrm_sfid__c = rqData.accid;
                String accName = AxsMethods.trimAndCapitalize(rqData.accountname);
                objAccount.Name = accName;
                objAccount.on__c = accName;
                objAccount.licn__c = accName;
                objAccount.ORACLE_PARTY_ID__c = rqData.partyid;
                objAccount.Prk__c = z;

                if (legalFrmwrk == 'Freelancer') {
                    objAccount.Legal_Framework__c = 'Freelancer';
                    objAccount.vespe__c = 1;

                }

                objAccount.mxPortalUsers__c = 1;
                objAccount.Type = 'Customer - External';
                objAccount.d3_aid__c = rqData.accid;
                objAccount.PRM_Name__c = rqData.prmFirstName + ' ' + rqData.prmLastName;
                objAccount.PRM_Email__c = rqData.prmEmail;
                objAccount.PRM_MobileNo__c = rqData.prmMobile;
                objAccount.Phone = rqData.phoneno;
                objAccount.clt__c = rqData.productCategory;
                objAccount.lctp__c = rqData.licenseType;
                upsert objAccount;

                contact objContact = new Contact();
                list<Contact> lstContact = [Select id from Contact where email =: rqData.emailid and accountid =: objAccount.id order by createddate desc limit 1];
                if (!lstContact.isEmpty())
                {
                    objContact = lstContact[0];
                }
                contactInfo conInfo = rqData.ctInfo;
                if (conInfo != null)
                {
                    objContact.firstName = conInfo.FirstName;
                    objContact.LastName = conInfo.LastName;
                    objContact.email = rqData.emailid;
                    objContact.phone = rqData.phoneno;
                    objContact.p__c = rqData.passportno;
                    objContact.nc__c = rqData.currentnat;
                    // objContact.Birthdate = rqData.dob;
                    objContact.accountId = objAccount.id;

                }
                upsert objContact ;


                String mb = rqData.phoneno;

                g_Req__c r = new g_Req__c(os__c = 'Lead Generated',
                                          srvc__c = srvId,
                                          xceml__c = rqData.emailid,
                                          xaccbrand__c = z,
                                          xbrnd__c = z,
                                          xcfn__c = rqData.accountname,
                                          xcfan__c = rqData.accountname,
                                          xadtx1__c = reqBody,
                                          sta__c = 'Draft',
                                          PRM_Name__c = rqData.prmFirstName + ' ' + rqData.prmLastName,
                                          PRM_Email__c = rqData.prmEmail,
                                          PRM_MobileNo__c = rqData.prmMobile,
                                          PRM_LandlineNo__c = rqData.prmPhone,
                                          xfb__c = legalFrmwrk,
                                          xvtyp__c = licType,
                                          parCat__c = rqData.productCategory,
                                          xpmsle__c = false,
                                          Acc__c = objAccount.id,
                                          mtnm__c = rqData.MethodName); /*MS 1.1*/

                if (String.isNotBlank(rqData.phoneno) && rqData.phoneno.contains(' ')) { r.xui__c = rqData.phoneno.substringBefore(' '); r.xcmob__c = rqData.phoneno.substringAfter(' ').replaceAll('\\D', ''); } else if (String.isNotBlank(rqData.phoneno)) { String phno = mb.replaceAll('\\D', ''); if (phno.startsWith('971')) { r.xui__c = '+971'; r.xcmob__c = phno.substringAfter('971'); } else if (phno.startsWith('05')) { r.xui__c = '+971'; r.xcmob__c = phno.substringAfter('0'); } else r.xcmob__c = phno; }
                mb = mb.replaceAll('\\D', '');
                r.ldmob__c = mb;

                if (legalFrmwrk == 'Freelancer') {
                    r.cldt__c = (GDRFAUtil.noOfWorkingDays((objAccount.createddate).date(), 3)).date();
                    r.clcnt__c = 0;
                }
                //insert r;

                wc = new ws_call__c();


                map < String, string > mapwoStatus = new map < String, string > ();
                grqWsOnboard.Records rec = new grqWsOnboard.Records();
                if (legalFrmwrk != 'Freelancer') {

                    if (rqData.workOrders != null && !rqData.workOrders.isEmpty()) {
                        List < WO > wlst = rqData.workOrders;
                        List < grqWsOnboard.WorkOrderInfo > workorders = new List < grqWsOnboard.WorkOrderInfo > ();

                        for (WO w: wlst) {
                            grqWsOnboard.WorkOrderInfo woInfo = new grqWsOnboard.WorkOrderInfo();
                            woInfo.recid = w.workOrderId;
                            mapwoStatus.put(w.workOrderId, w.status);
                            if (woInfo.recType == 'Government_Relations')
                                rec.gvtRlsWorkId = w.workOrderId;
                            if (w.RecordTypeDeveloperName == 'Government_Relations')  {
                                woInfo.recType = 'License_Registration_Request';
                            }
                            else {
                                woInfo.recType = w.RecordTypeDeveloperName;
                            }

                            woInfo.status = w.status;
                            if (woInfo.recType == 'Brand_Approval')
                                rec.brandWorkid = w.workOrderId;
                            if (woInfo.recType == 'Security_Clearance')
                                rec.scWorkid = w.workOrderId;
                            if (woInfo.recType == 'License_Registration_Request')
                                rec.nameResWorkid = w.workOrderId;
                            if (woInfo.recType == 'HSE')
                                rec.hscResWorkid = w.workOrderId;


                            workorders.add(woInfo);
                        }


                        rec.crmAccId = rqData.accid;
                        rec.workorders = workorders;
                        rec.licenseType = licType;
                        rec.DDAReqNo = rqData.appicationnum;
                        String adhoctx3 = Json.serialize(rec);
                        r.xadtx3__c = adhoctx3;
                    }
                }

                r.xdei__c = rqData.ddaid;
                r.xdccaRq__c = rqData.appicationnum;
                system.debug('rqData.skipLeaseValidations:::' + rqData.skipLeaseValidations);
                /*MS 1.1 */
                r.xadh__c = (String.isNotBlank(r.xadh__c) && r.xvtyp__c != 'DED') ? (r.xadh__c + 'ec;') : (r.xvtyp__c != 'DED') ? 'ec;' : r.xadh__c;
                if (rqData.skipLeaseValidations != null && rqData.skipLeaseValidations) {
                    r.skpu__c = rqData.skipLeaseValidations;
                    r.xadh__c = (String.isNotBlank(r.xadh__c) && r.xvtyp__c != 'DED') ? (r.xadh__c + ';nl;ec;') : (r.xvtyp__c != 'DED') ? 'nl;ec;' :r.xadh__c;
                    wc = new ws_call__c(pmid__c = rqData.accid, ws_typ__c = 'Onboarding', mtd_nm__c = 'fetchAccInfo', intsts__c = 'Ready for Integration');
                }
                if (String.isNotBlank(rqData.leaseClassification) && rqData.leaseClassification == 'PMS') {
                    r.xpmsle__c = true;
                    r.xadh__c = r.xadh__c + 'psf;';

                } else {
                    r.xpmsle__c = false;
                }
                r.xadtx1__c = reqBody;

                insert r;
                list<g_reqitem__c> lstItm = new list<g_reqitem__c>();
                if (rec != null)
                {
                    for ( g_reqitem__c itm:[SELECT id, itm__c, ccrmid__c, name, sta__c, sta__r.cd__c from g_reqitem__c
                                           where RQ__c =: r.id])
                    {

                        if (itm.name == 'Security_Clearance')
                        {
                            itm.ccrmid__c =  rec.scWorkid;
                            lstItm.add(itm);
                        }
                        else if (itm.name == 'Brand_Approval')
                        {
                            itm.ccrmid__c =  rec.brandWorkid;
                            lstItm.add(itm);

                        }
                        else if (itm.name == 'License_Registration_Request')
                        {
                            itm.ccrmid__c =  rec.nameResWorkid;
                            lstItm.add(itm);

                        }
                        else if (itm.name == 'HSE')
                        {
                            itm.ccrmid__c =  rec.hscResWorkid;
                            lstItm.add(itm);

                        }
                    }
                    if (!lstItm.isEmpty())
                    {
                        SObjectAccessDecision secDec5 = Security.stripInaccessible(AccessType.UPDATABLE, lstItm);
                        update secDec5.getRecords();
                    }
                }
                if (wc != null)
                    insert wc;
                g_req__c req1 = [Select Id, name from g_req__c where id =: r.Id];
                res.axsSrNo = req1.name;
                res.axsAccId = objAccount.id;
                res.msg = 'Success';
                res.msgcode = 'S';
                if (!mapwoStatus.isEmpty()) {
                    // updateStatus(mapwoStatus);
                }
            }
            else {
               res.msg = 'either  party id or CRM account id, axs srno is missing in  json';
                res.msgcode = 'F';
            }
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            res.msg = 'ERROR Message:' + e.getStackTraceString();
            res.msgcode = 'F';
        }
        system.debug('res Message::' + res.msg);
        RestContext.response.addHeader('Content-Type', 'application/json'); /*return res;*/
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }

    public static void updateStatus(map < String, String > mapStatus) { map < String, g_reqitem__c > mapSrvItm = new map < String, g_reqitem__c > (); list<g_reqitem__c> lstrqItmToUp = new list<g_reqitem__c>(); for (g_reqitem__c itm: [SELECT id, itm__c, ccrmid__c, sta__c, sta__r.cd__c from g_reqitem__c where ccrmid__c in: mapStatus.keySet()]) { mapSrvItm.put(itm.itm__c, itm); } if (!mapSrvItm.isEmpty()) { for (Courier_Status__c objStatus: [select id,itmSTA__r.cd__c, srvitm__c, itmSTA__c, itmSTA__r.name, srvitm__r.name, curSTA__c, curSTA__r.xcsits__c, curSTA__r.name, curSTA__r.cd__c, curSTA__r.uid__c, curSTA__r.rqSTA__c, Courier_Status__c from Courier_Status__c where srvitm__c IN: mapSrvItm.keyset() and Courier_Status__c =: mapStatus.values()]) { if (mapSrvItm.containsKey(objStatus.srvitm__c) && mapStatus.containsKey(mapSrvItm.get(objStatus.srvitm__c).ccrmid__c) && mapStatus.get(mapSrvItm.get(objStatus.srvitm__c).ccrmid__c) == objStatus.Courier_Status__c && mapSrvItm.get(objStatus.srvitm__c).sta__r.cd__c != objStatus.itmSTA__r.cd__c) { g_reqitem__c objRqItm = mapSrvItm.get(objStatus.srvitm__c); objRqItm.sta__c = objStatus.itmSTA__c; lstrqItmToUp.add(objRqItm); } } } system.debug('lstrqItmToUp===' +lstrqItmToUp); if (!lstrqItmToUp.isEmpty()) { update lstrqItmToUp; } }

    global class StatusResponse {
        webservice String msg {
            set;
            get;
        }
        webservice String msgcode {
            set;
            get;
        }
        webservice String axsAccId {set;get;}
        webservice String axsSrNo {set;get;}
    }
    global class WO {
        webservice String workOrderId,status,RecordTypeDeveloperName;
    }
    global class ReqData {
        /* webservice String appicationNum, status,emailId,PhoneNo,licno,accountName,partyId,PassportNo,currentNat,ccrmId,ddaId,ddasrid,srtype,park,dob;*/
        webservice String appicationnum,axsSrNo, leadId,status, emailid, phoneno, licno, accountname, partyid, passportno, currentnat, ccrmid, accid, ddaid, ddasrid, srtype, park, dob,prmFirstName,prmLastName,prmMobile,prmPhone,prmEmail,leaseClassification, licenseType, productCategory, MethodName;
        webservice contactInfo ctInfo;
       webservice list<WO> workOrders;webservice boolean skipLeaseValidations;
    }
    global class contactInfo {
        webservice String firstName;
        webservice String lastName;
    }
}
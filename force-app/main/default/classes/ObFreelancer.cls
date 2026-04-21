public class ObFreelancer {

    public static string username = '';
    public static string newAccID = '';


    public void createAccount(g_req__c rq, String username, String freelancePass){

        System.debug('<createAccount> : rq: ' + rq);
        system.debug('rq.xfb__c::'+rq.xfb__c);

        Map<String,String> mapFormation = new Map<String,String>{
            'FZ-LLC'=>'Free Zone Limited Liability company',
                'Branch of Foreign Company'=>'Branch of Foreign Company',
                'Branch of UAE Company'=>'Branch of UAE Company',
                'Freelancer'=>'Freelancer'
                };


        Account acc = new Account();
          if (!String.isBlank(rq.mtnm__c) && rq.mtnm__c == 'Existing') {
            acc.id = rq.Acc__c;
        }
        acc.Name = rq.xcfn__c + (String.isNotBlank(rq.xcln__c) ? ' '+ rq.xcln__c:'') ;
        acc.Email__c = rq.xceml__c;
        acc.Phone = rq.xchph__c;
        acc.Type = 'Customer - External';

        acc.os__c ='Initiated';
        acc.Legal_Framework__c = String.isnotBlank(rq.xfb__c) ? mapFormation.get(rq.xfb__c) : '';

        acc.clt__c =  rq.parCat__c == 'Land Assignment' ? 'Land' : rq.parCat__c; /*MS 1.1*/
        acc.Prk__c = rq.xaccbrand__c;
        /*MS 1.1 start*/
        /*if (String.isBlank(rq.xfb__c))
        acc.lctp__c = 'DED';
        else
        acc.lctp__c = 'DDA'; */
        acc.lctp__c = rq.xvtyp__c;
        /*MS 1.1 end*/

        upsert acc;
        System.debug('acc id ::' + acc.id);

        newAccID = acc.id;
       /* contact con = new Contact(lastname = acc.Name, email = rq.xceml__c, p__c = rq .Id, accountid = acc.id);
        insert con;*/
        /*MS 1.1 start*/
         list < Contact > lstCon = new list < Contact > ();
        contact con = new Contact();
        if (!String.isBlank(rq.mtnm__c) && rq.mtnm__c == 'Existing') {
            lstCon = [Select Id from contact where email =: rq.xceml__c and accountid =: acc.id order by createddate limit 1];
        }
        if (lstCon.isEmpty()) {
            con = new Contact(lastname = acc.Name, email = rq.xceml__c, p__c = rq.Id, accountid = acc.id);
        } else {
            con = lstCon[0];
            con.p__c = rq.Id;
        }
        //contact con = new Contact(lastname = acc.Name, email = rq.xceml__c, p__c = rq .Id, accountid = acc.id);
        upsert con;
        String profileId = gU.csStr('gpSU');
        list < User > lstUser = [Select id from user where contactId =: con.Id and ProfileId =: profileId
            and isactive = true and email =: rq.xceml__c order by createddate limit 1
        ];

        /*MS 1.1 End*/

        String nicknm = acc.Name.substring(0, 2) + String.valueof(Math.random()).substring(2, 7);
        User nwU = new User(); /*nwU.FirstName   = m.FirstName;*/
        nwU.LastName = acc.Name;
        nwU.Email = rq.xceml__c;
        nwU.Username = username;
        nwU.Alias = nicknm;
        nwU.ProfileId = gU.csStr('gpSU');
        nwU.ContactId = con.id;
        nwU.CommunityNickname = acc.Name.substring(0, 1) + (rq.xaccbrand__c).substring(0, 15) + nicknm;
        nwU.IsActive = true;
        nwU.TimeZoneSidKey = 'Asia/Dubai';
        nwU.LocaleSidKey = 'en_GB';
        nwU.LanguageLocaleKey = 'en_US';
        nwU.EmailEncodingKey = 'ISO-8859-1';





    if (!Test.isRunningTest() && lstUser.isEmpty())
          site.createExternalUser(nwU, newAccID, freelancePass, false);



        /*String respBody = '{"Managers":[{"accLicNo":"'+rq .Id+'","salutation":"'+rq.xcslt__c+'","freelanceUsername":"'+username+'","freelancePass":"'+freelancePass+'","firstName":"'+rq.xcfn__c+'","lastName":"'+rq.xcln__c+'","mobile":"'+rq.xcmob__c+'","email":"'+rq.xceml__c+'","isfreelancerOb":true}]}';

        WsCAll_InsertUsr cu = new WsCAll_InsertUsr();
        cu.mapAccByLic = new Map<String,String>();
        cu.mapAccByLic.put(rq.Id,acc.id);

        WsCAll_InsertUsr.Records recs = (WsCAll_InsertUsr.Records)JSON.deserialize(respBody,WsCAll_InsertUsr.Records.class);

        if (recs!=null){
            cu.autoCreate(recs.Managers);
        }*/

    }

    @future(callout=true)
   public static void crtCCRMAcc(String accId, String rqNo){  Account acc = [SELECT id, name,prk__c,ccrm_sfid__c FROM Account WHERE id=:accId]; g_req__c rq = [SELECT id, name,xcslt__c, xcfn__c, xcln__c, xceml__c, xcmob__c,xaccbrand__c,xchph__c,xcnc__c,xcp__c, segmentFL__c,activitiesFL__c, xcfnar__c,xclnar__c, acc__r.id, acc__r.name, acc__r.prk__c FROM g_req__c WHERE name=:rqNo];  AccInfo ai= new AccInfo(); ai.accName = rq.xcfn__c +' '+rq.xcln__c; ai.accLegalName = rq.xcfn__c + ' ' + rq.xcln__c; ai.accNameArabic= (String.isNotBlank(rq.xcfnar__c) ? rq.xcfnar__c+ ' ':'') + (String.isNotBlank(rq.xclnar__c)?rq.xclnar__c:'');  ai.axsAccId = rq.acc__r.id; ai.axsRqNo = rqNo; ai.bParkName = rq.acc__r.prk__c; ai.phone = rq.xchph__c; ai.email = rq.xceml__c; ai.country = rq.xcnc__c; ai.segment = rq.segmentFL__c; ai.activities = rq.activitiesFL__c;  /*check fields for the legal form,licType and licStatus avoid hardcoding*/ ai.proposed_Legal_Form_of_Business = 'Freelancer'; ai.lcType = 'DDA'; ai.licenseStatus = 'Initiated';  String reqBd = JSON.serialize(ai); System.debug('reqBd : ' + reqBd);  Http h = new Http(); HttpRequest request     = new HttpRequest(); HttpResponse response   = new HttpResponse();  request.setHeader('Content-Type','application/json'); request.setHeader('accept','application/json'); request.setEndpoint('callout:'+Label.CRM_Instance+'/apexrest/getacc'); request.setTimeout(90000); request.setMethod('POST'); request.setBody(reqBd); response = h.send(request);  ws_call__c ws = new ws_call__c(rq_jsn__c = accId, pmid__c= rqNo, mtd_nm__c = 'crtAccCCRM');  if (response.getStatusCode()==200){ String respBody = response.getBody(); System.debug('respBody : ' + respBody); AccResponse accResponse = (AccResponse)JSON.deserialize(respBody,AccResponse.class); ws.intsts__c = accResponse.isSuccess ? 'Success' : 'Failed'; ws.err_msg__c = accResponse.respMsg;  if (String.isNotBlank(accResponse.ccrmAccId)) { ws.res_jsn__c = 'CCRM account ID: '+accResponse.ccrmAccId; acc.ccrm_sfid__c = accResponse.ccrmAccId; update acc; }else{ ws.res_jsn__c = 'CCRM account creation failed.'; }    }else{ ws.err_msg__c = 'response status code: ' +response.getStatusCode(); ws.intsts__c = 'Failed'; }  insert ws;    }

    // SECURITY: Removed sensitive debug log




   public class AccInfo { public string accName; public string accNameArabic; public string accLegalName; public string axsAccId; public string axsRqNo; public string bParkName; public string phone; public string country; public string email; public string lcType; public string proposed_Legal_Form_of_Business; public string legalFramework; public string industry; public string activities; public string segment; public string licenseStatus;  } public class AccResponse { public Boolean isSuccess; public string respMsg; public string ccrmAccId; }

}
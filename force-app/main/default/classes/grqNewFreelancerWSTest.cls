@isTest(SeeAllData=false)
private class grqNewFreelancerWSTest {

    @testSetup /*MS*/
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }

    static testMethod void unitTest01() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/newFreelancer/';
        String postData = '{"workOrders":[], "status":null, "srtype":"Freelancer", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"+971 502571570", "passportno":null, "partyid":null, "park":"DIC", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "axsSrNo":null, "appicationnum":null, "accountname":"Ahmed Mohammed", "accid":null}';
        //'Your actual request which covers both scenario in JSON format';
        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        grqNewFreelancerWS.doPost();
        grqNewFreelancerWS.StatusResponse res1 = new grqNewFreelancerWS.StatusResponse();
        res1.msg = '';
        grqNewFreelancerWS.ReqData obj = new grqNewFreelancerWS.ReqData();

        Test.stopTest();
    }
     static testMethod void unitTest04() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/newFreelancer/';
        String postData = '{"workOrders":[], "status":null, "srtype":"Freelancer", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"971502571570", "passportno":null, "partyid":null, "park":"DPC", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "axsSrNo":null, "appicationnum":null, "accountname":"Ahmed Mohammed", "accid":null}';
        //'Your actual request which covers both scenario in JSON format';
        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        grqNewFreelancerWS.doPost();
        grqNewFreelancerWS.StatusResponse res1 = new grqNewFreelancerWS.StatusResponse();
        res1.msg = '';
        grqNewFreelancerWS.ReqData obj = new grqNewFreelancerWS.ReqData();

        Test.stopTest();
    }

    static testMethod void unitTest02() {

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/newFreelancer/';
        String postData = '{"workOrders":[], "partyid":"12345", "axsSrNo":"'+r.name+'", "accid":"'+accLst[0].id+
            '", "status":null, "srtype":"Freelancer", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"+971 502571570", "passportno":null, "park":"DSP", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "appicationnum":null, "accountname":"Ahmed Mohammed"}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        grqNewFreelancerWS.doPost();

        postData = '{"workOrders":[{"workOrderId":"0WO05000000DUSxGAO", "status":"Draft", "RecordTypeDeveloperName":"Brand_Approval"}, {"workOrderId":"0WO05000000DUSyGAO", "status":"Draft", "RecordTypeDeveloperName":"Security_Clearance"}, {"workOrderId":"0WO05000000DUSzGAO", "status":"Draft", "RecordTypeDeveloperName":"License_Registration_Request"}], "partyid":"12345", "axsSrNo":"'+
            r.name+'", "accid":"'+accLst[0].id+'", "status":null, "srtype":"Branch of a Foreign Company", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"971502571570", "passportno":null, "park":"DMC", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "appicationnum":null, "accountname":"Ahmed Mohammed"}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        grqNewFreelancerWS.doPost();

        Test.stopTest();
    }
    static testMethod void unitTest03() {

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/newFreelancer/';
        String postData = '{"workOrders":[], "partyid":"", "axsSrNo":"'+
            r.name+'", "accid":"", "status":null, "srtype":"Freelancer", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"+971 502571570", "passportno":null, "park":"DSC", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "appicationnum":null, "accountname":"Ahmed Mohammed"}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        grqNewFreelancerWS.doPost();

        postData = '{"workOrders":[{"workOrderId":"0WO05000000DUSxGAO", "status":"Draft", "RecordTypeDeveloperName":"Brand_Approval"}, {"workOrderId":"0WO05000000DUSyGAO", "status":"Draft", "RecordTypeDeveloperName":"Security_Clearance"}, {"workOrderId":"0WO05000000DUSzGAO", "status":"Draft", "RecordTypeDeveloperName":"License_Registration_Request"}], "partyid":"12345", "axsSrNo":"'+
            r.name+'", "accid":"'+accLst[0].id+'", "status":null, "srtype":"Branch of a Foreign Company", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"971502571570", "passportno":null, "park":"DMC", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "appicationnum":null, "accountname":"Ahmed Mohammed"}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        grqNewFreelancerWS.doPost();

        Test.stopTest();
    }

    static testMethod void unitTest05() {

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/newFreelancer/';
        String postData = '{"workOrders":[{"workOrderId":"0WO05000000DUSxGAO", "status":"Draft", "RecordTypeDeveloperName":"Brand_Approval"}, {"workOrderId":"0WO05000000DUSyGAO", "status":"Draft", "RecordTypeDeveloperName":"Security_Clearance"}, {"workOrderId":"0WO05000000DUSzGAO", "status":"Draft", "RecordTypeDeveloperName":"License_Registration_Request"}], "MethodName":"Existing", "partyid":"12345", "accid":"'+
            accLst[0].id+'", "status":null, "srtype":"Branch of a UAE Company", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"+971 502571570", "passportno":null, "park":"DSP", "licno":null, "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "appicationnum":null, "accountname":"Ahmed Mohammed", "ctInfo": { "FirstName": "TestContact", "LastName": "Test", "emailid": "Brand_Approval", "phoneno": "0567789898", "passportno": "S0786778", "currentnat": "INDIA" }}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        grqNewFreelancerWS.doPost();

        postData = '{"workOrders":[{"workOrderId":"0WO05000000DUSxGAO", "status":"Draft", "RecordTypeDeveloperName":"Brand_Approval"}, {"workOrderId":"0WO05000000DUSyGAO", "status":"Draft", "RecordTypeDeveloperName":"Security_Clearance"}, {"workOrderId":"0WO05000000DUSzGAO", "status":"Draft", "RecordTypeDeveloperName":"License_Registration_Request"}], "partyid":"12345", "axsSrNo":"'+
            r.name+'", "accid":"'+accLst[0].id+'", "status":null, "srtype":"Branch of a Foreign Company", "prmPhone":"04-391 41 40", "prmMobile":null, "prmLastName":"Khartabil", "prmFirstName":"Nadine", "prmEmail":"nadine.khartabil@dmc.ae.invalid", "phoneno":"971502571570", "passportno":null, "park":"DMC", "licno":null, "leadId":"00Q05000004hK3WEAU", "emailid":"ahm3d.mohamm3d84@gmail.com", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "appicationnum":null, "accountname":"Ahmed Mohammed"}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        grqNewFreelancerWS.doPost();

        Test.stopTest();
    }

}
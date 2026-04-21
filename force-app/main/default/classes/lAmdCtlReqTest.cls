@isTest
public class lAmdCtlReqTest {

    @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        //Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }
     static testmethod void test1() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        //List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];
        accLst[0].ORACLE_PARTY_ID__c = '987654321';
        update accLst[0];
        User adminU = [Select Id, Name from User where Name = 'System Admin' LIMIT 1 ];
        Contact emp = new Contact(accountid=accLst[0].id, Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
                                rol__c = 'Student', p__c = 'Pass1',
                                pid__c = date.today(), ped__c = date.today().addYears(1),
                                Owner = adminU, ptsta__c='Eligible');
        insert emp;
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
         g_reqDoc__c rdoc= new g_reqDoc__c(name='test', RQ__c=r.id, or__c=true);
         insert rDoc;
        List<g_srvcitm_Status__c> cancelItmes=[select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: r.srvc__c and cd__c = 'c'];
        list<g_Req__c> req= [select id, xcawp__c, acc__c, con__c, sta__c from g_Req__c where id=:r.id limit 1];
         list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c from g_reqitem__c where RQ__c =: req[0].Id and isDeleted = false and sta__r.Tp__c = 'Open'];
        req[0].xcawp__c=false;
        update req;
        req[0].sta__c='Cancelled';
        update req;
        system.debug(req[0].sta__c);
        User u = createUser();
        system.debug('--u--'+u);
        string unitNoEn='1234';
        string status='Draft';boolean hasSanctions = false;boolean accesssOk=false;
        PMSAmdDataWrapperTest.createUnitInfo(unitNoEn, status);
        g_Tran__c gt = new g_Tran__c(Acc__c=accLst[0].Id, RQ__c=req[0].Id, dt__c=system.today(), TP__c='Payment', STA__c='Completed', md__c='Credit / Debit Card');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockgetcrmLoc2());
        List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.loadD3Loc('987654321');
        system.runAs(u) {
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        ApexPages.currentPage().getParameters().put('id', r.Id);
           ApexPages.currentPage().getParameters().put('sid', srvcLst[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(r);
        lAmdCtlReq ctrl = new lAmdCtlReq(sc);

        ctrl.isgu=true;
        ctrl.isPu=true;
        ctrl.nD=true;
        system.debug('--isgu--'+ctrl.isgu);
        system.debug('--isPU--'+ctrl.isPu);
        ctrl.authenticateUser();
        system.debug(req[0].sta__c);
           hasSanctions=false;
        accesssOk=false;
        ctrl.loadData(true);
        ctrl.upsertR(req[0].sta__c);
        ctrl.cancelItms();
        ctrl.CancelR();
        ctrl.saveOpen();
        }
        test.stopTest();
    }
    static testmethod void test2() {
        List<Account> accLst = [select id, lc__c from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];
        accLst[0].ORACLE_PARTY_ID__c = '987654321';
        accLst[0].lc__c = '54321';
        update accLst[0];
        User adminU = [Select Id, Name from User where Name = 'System Admin' LIMIT 1 ];
        Contact emp = new Contact(accountid=accLst[0].id, Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
                                rol__c = 'Student', p__c = 'Pass1',
                                pid__c = date.today(), ped__c = date.today().addYears(1),
                                Owner = adminU, ptsta__c='Eligible');
        insert emp;
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
         g_reqDoc__c rdoc= new g_reqDoc__c(name='test', RQ__c=r.id, or__c=true);
         insert rDoc;
        List<g_srvcitm_Status__c> cancelItmes=[select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: r.srvc__c and cd__c = 'c'];
        list<g_Req__c> req= [select id, xcawp__c, acc__c, con__c, sta__c from g_Req__c where id=:r.id limit 1];
         list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c from g_reqitem__c where RQ__c =: req[0].Id and isDeleted = false and sta__r.Tp__c = 'Open'];
        req[0].xcawp__c=false;
        update req;
        req[0].sta__c='Cancelled';
        update req;
        system.debug(req[0].sta__c);
        Account act = new Account(Name = 'Sample Account', OwnerId = userInfo.getUserId());
            Database.insert(act);

        Contact contact1 = new Contact(FirstName = 'Test1', Lastname = 'McTesty1', AccountId = act.Id, Email = 'mctesty1.sahni1@axsstg.com');
            Database.insert(contact1);
        Profile portalProfile = [SELECT Id FROM Profile WHERE id='00e20000001Ajl3' Limit 1];
       // user u =new user();
        User user1 = new User(
                UserName = contact1.Email,
                FirstName = contact1.FirstName,
                LastName = contact1.LastName,
                Alias = 'test123', Department__c= 'Finance',
                email = contact1.Email,
                ProfileId = portalProfile.Id,
                EmailEncodingKey = 'UTF-8',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
        string unitNoEn='1234';
        string status='Draft';
        boolean hasSanctions = false;boolean accesssOk=false;
        PMSAmdDataWrapperTest.createUnitInfo(unitNoEn, status);
        g_Tran__c gt = new g_Tran__c(Acc__c=accLst[0].Id, RQ__c=req[0].Id, dt__c=system.today(), TP__c='Payment', STA__c='Completed', md__c='Credit / Debit Card');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockgetcrmLoc2());
        List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.loadD3Loc('987654321');
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess('lic'));
        gwsPMSIntegration.getEjariContractInfoByContractNo('54321');
        List<PMSDataWrapper.ContractInformation> ejariContractList = gwsPMSIntegration.getEjariContractInfoByLicenseNo('54321');
        system.runAs(user1) {
        //PageReference myVfPage = Page.grqatt;
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        ApexPages.currentPage().getParameters().put('id', r.Id);
           ApexPages.currentPage().getParameters().put('sid', srvcLst[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(r);
        lAmdCtlReq ctrl = new lAmdCtlReq(sc);

        ctrl.isgu=true;
        ctrl.isPu=true;
        ctrl.nD=true;
        system.debug('--isgu--'+ctrl.isgu);
        system.debug('--isPU--'+ctrl.isPu);
        ctrl.authenticateUser();
        system.debug(req[0].sta__c);
           hasSanctions=true;
        accesssOk=true;
        ctrl.loadData(true);
        ctrl.upsertR(req[0].sta__c);
        ctrl.cancelItms();
        ctrl.CancelR();
        //ctrl.cancelItms=true;
        ctrl.saveOpen();
        }
        test.stopTest();
    }
    static user createUser() {
        //user u = [Select id from user where id =: userInfo.getUserId()];
       // system.runAs(u) {
            //Create account
            Account act = new Account(Name = 'Sample Account', OwnerId = userInfo.getUserId());
            Database.insert(act);

            //Create contact
            Contact contact1 = new Contact(FirstName = 'Test', Lastname = 'McTesty', AccountId = act.Id, Email = 'mctesty.sahni@axsstg.com');
            Database.insert(contact1);

            //Create Portal User
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='W' Limit 1];
            User user1 = new User(
                UserName = contact1.Email,
                FirstName = contact1.FirstName,
                LastName = contact1.LastName,
                Alias = 'test123', Department__c= 'Finance',
                email = contact1.Email,
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                EmailEncodingKey = 'UTF-8',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            return user1;
       // }
       // return null;
    }

    public class MockgetcrmLoc2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ResponseData":{"PartyId":"987654321", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Closed Won", "AgNo":"AG-119902", "LeaseType":"Tecom / PMLA", "BusinessPark":"DKP", "ContractStartDate":"2017-02-01", "ContractEndDate":"2019-01-31", "Category":"Office", "SubCategory":"Premium Fitted-out Office", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":true, "RenewalOpp":"", "Products":[{"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-FL1C1", "ProductName":"DKP-B02-FL1C1", "UnitNumber":"FL1C1"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-163A", "ProductName":"DKP-B02-163A", "UnitNumber":"163A"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-162", "ProductName":"DKP-B02-162", "UnitNumber":"162"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-161", "ProductName":"DKP-B02-161", "UnitNumber":"161"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-160", "ProductName":"DKP-B02-160", "UnitNumber":"160"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-159", "ProductName":"DKP-B02-159", "UnitNumber":"159"}]}, {"StageName":"Closed Won", "AgNo":"AG-117256", "LeaseType":"Tecom / PMLA", "BusinessPark":"DIC", "ContractStartDate":"2016-09-15", "ContractEndDate":"2021-09-14", "Category":"Common Area", "SubCategory":"Corridor", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":false, "RenewalOpp":"", "Products":[{"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-305", "ProductName":"DIC-Bldg 05-305", "UnitNumber":"305"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-306", "ProductName":"DIC-Bldg 05-306", "UnitNumber":"306"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-320", "ProductName":"DIC-Bldg 05-320", "UnitNumber":"320"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-318", "ProductName":"DIC-Bldg 05-318", "UnitNumber":"318"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-319", "ProductName":"DIC-Bldg 05-319", "UnitNumber":"319"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-324", "ProductName":"DIC-Bldg 05-324", "UnitNumber":"324"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-321", "ProductName":"DIC-Bldg 05-321", "UnitNumber":"321"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-301", "ProductName":"DIC-Bldg 05-301", "UnitNumber":"301"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-304", "ProductName":"DIC-Bldg 05-304", "UnitNumber":"304"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-302", "ProductName":"DIC-Bldg 05-302", "UnitNumber":"302"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-311", "ProductName":"DIC-Bldg 05-311", "UnitNumber":"311"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-C", "ProductName":"DIC-Bldg 05-C", "UnitNumber":"C"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-323", "ProductName":"DIC-Bldg 05-323", "UnitNumber":"323"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-310", "ProductName":"DIC-Bldg 05-310", "UnitNumber":"310"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-303", "ProductName":"DIC-Bldg 05-303", "UnitNumber":"303"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-221", "ProductName":"DIC-Bldg 05-221", "UnitNumber":"221"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-222", "ProductName":"DIC-Bldg 05-222", "UnitNumber":"222"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-219", "ProductName":"DIC-Bldg 05-219", "UnitNumber":"219"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-307", "ProductName":"DIC-Bldg 05-307", "UnitNumber":"307"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-312", "ProductName":"DIC-Bldg 05-312", "UnitNumber":"312"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-314", "ProductName":"DIC-Bldg 05-314", "UnitNumber":"314"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-220", "ProductName":"DIC-Bldg 05-220", "UnitNumber":"220"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-322", "ProductName":"DIC-Bldg 05-322", "UnitNumber":"322"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-308", "ProductName":"DIC-Bldg 05-308", "UnitNumber":"308"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-309", "ProductName":"DIC-Bldg 05-309", "UnitNumber":"309"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-223", "ProductName":"DIC-Bldg 05-223", "UnitNumber":"223"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-315", "ProductName":"DIC-Bldg 05-315", "UnitNumber":"315"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-313", "ProductName":"DIC-Bldg 05-313", "UnitNumber":"313"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-317", "ProductName":"DIC-Bldg 05-317", "UnitNumber":"317"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-316", "ProductName":"DIC-Bldg 05-316", "UnitNumber":"316"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-224", "ProductName":"DIC-Bldg 05-224", "UnitNumber":"224"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-112", "ProductName":"DIC-Bldg 05-112", "UnitNumber":"112"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-109", "ProductName":"DIC-Bldg 05-109", "UnitNumber":"109"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-110", "ProductName":"DIC-Bldg 05-110", "UnitNumber":"110"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-111", "ProductName":"DIC-Bldg 05-111", "UnitNumber":"111"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-205", "ProductName":"DIC-Bldg 05-205", "UnitNumber":"205"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-201", "ProductName":"DIC-Bldg 05-201", "UnitNumber":"201"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-203", "ProductName":"DIC-Bldg 05-203", "UnitNumber":"203"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-202", "ProductName":"DIC-Bldg 05-202", "UnitNumber":"202"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-204", "ProductName":"DIC-Bldg 05-204", "UnitNumber":"204"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-206", "ProductName":"DIC-Bldg 05-206", "UnitNumber":"206"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-FL2C1", "ProductName":"DIC-Bldg 05-FL2C1", "UnitNumber":"FL2C1"}]}]}} ');
            res.setStatusCode(200);
            return res;
        }
    }
    /*public static testmethod void meth2() {
      Test.startTest();
       PMSContractDataWrapper pms = new PMSContractDataWrapper();

       PMSContractDataWrapper.PropertyInformationList pi = new PMSContractDataWrapper.PropertyInformationList();
       pi.ejariBusPropertyTypeId = '';pi.approvalRefNumber='';pi.unitNumber='';
       pi.area='';pi.dewa='';pi.propertyTypeId='';pi.propertyType='';pi.propertySubTypeId='';
       pi.propertySubType='';pi.propertyUsageId='';pi.propertyUsage='';
       PMSContractDataWrapper.Name nm = new PMSContractDataWrapper.Name();
       nm.englishName = '';nm.arabicName='';
       PMSContractDataWrapper.CommunityInformation ci = new PMSContractDataWrapper.CommunityInformation();
       ci.code = 123; ci.name='';
       PMSContractDataWrapper.LandLordInformation li = new PMSContractDataWrapper.LandLordInformation();
       li.name = nm;
       PMSContractDataWrapper.AreaZone az = new PMSContractDataWrapper.AreaZone();
       az.code = 123;az.name=nm;
       PMSContractDataWrapper.LicenseAuthorityInformation lai = new PMSContractDataWrapper.LicenseAuthorityInformation();
       lai.code=123;lai.name=nm;lai.id='';
       PMSContractDataWrapper.LicenseInformation lci = new PMSContractDataWrapper.LicenseInformation();
       lci.initialApprovalNumber = '123'; lci.licenseNumber = '';lci.licenseAuthorityInformation=lai;
       PMSContractDataWrapper.GeoLocation gl = new PMSContractDataWrapper.GeoLocation();
       gl.latitude = '';gl.longitude = '';
       PMSContractDataWrapper.AuthorityInformation ai = new PMSContractDataWrapper.AuthorityInformation();
       ai.code = '';ai.id = ''; ai.name = '';

       PMSContractDataWrapper.ValidationErrorsList vel = new PMSContractDataWrapper.ValidationErrorsList();
        vel.errorMessage = '';vel.errorNumber=null;vel.validationType='';

        PMSContractDataWrapper.TenantInformation ti = new PMSContractDataWrapper.TenantInformation();
        ti.tenantType = '';ti.emiratesID = '';ti.passportNo = '';ti.visaNo = '';ti.visaStartDt = '';
        ti.visaEndDt = '';ti.mobileNo = '';ti.email = '';ti.poBox = '';ti.licenseInformation = lci;ti.name = nm;
        PMSContractDataWrapper.ContractInformation cinfo = new PMSContractDataWrapper.ContractInformation();
       cinfo.makaniNumber = '';cinfo.uaeNGNumber = '';cinfo.contractNumber = ''; cinfo.startDate = '';cinfo.endDate = '';
       cinfo.contractAnnualAmount = null;cinfo.contractAmount = null;cinfo.areaZone = az; cinfo.location =az;cinfo.authorityInformation = ai;
       cinfo.licenseInformation = lci;cinfo.geoLocation = gl;cinfo.communityInformation = ci; cinfo.landLordInformation = li;cinfo.tenantInformation = ti;
       cinfo.versionNumber = null;cinfo.parcelID = null;cinfo.landNumber = null;cinfo.buildingName = null;
       List<PMSContractDataWrapper.PropertyInformationList> pinfoLst = new List<PMSContractDataWrapper.PropertyInformationList>();
        pinfoLst.add(pi);
        cinfo.propertyInformationList = pinfoLst;
        PMSContractDataWrapper.Response res = new PMSContractDataWrapper.Response();
       res.additionalData = '';
       List<PMSContractDataWrapper.ContractInformation> ciLst = new List<PMSContractDataWrapper.ContractInformation>();
       ciLst.add(cinfo);

       pms.dedLicenseNumber = '';pms.contractNumber = ''; pms.timeStamp = ''; pms.responseCode = '';
       pms.response = res;
       res.contractInformation = cinfo;

       List<PMSContractDataWrapper.ValidationErrorsList> validationErrorsList = new List<PMSContractDataWrapper.ValidationErrorsList>();
       validationErrorsList.add(vel);
       pms.ValidationErrorsList =validationErrorsList;
       PMSLeaseAmdInfo pmi = new PMSLeaseAmdInfo();
        pmi.invMsg = ''; pmi.leaseAreaCRM = null; pmi.leaseAreaEjari = null; pmi.leaseAreaDiff = null;pmi.visaQuota=null;
      Test.stopTest();
  }*/
     public class MockApplicationProcess implements HttpCalloutMock {
        public String responseBody;
        public Integer statusCode;
        public MockApplicationProcess(String arg) {
            if (arg=='lic') {
                statusCode=200;
                responseBody = '{"TimeStamp":"2023-10-06T05:23:41.5858162+00:00", "ResponseCode":"Success", "ValidationErrorsList":[], "Response":{"ContractInformation":[{"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000299", "UnitNumber":"2", "Area":"651.97", "Dewa":"382037804", "PropertyTypeId":"1", "PropertyType":"Shop", "PropertySubTypeId":"421", "PropertySubType":"Shop", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120160809000489", "StartDate":"09/01/2022", "EndDate":"01/31/2024", "ContractAnnualAmount":1444169.8, "ContractAmount":1444169.8, "VersionNumber":6, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}, {"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000295", "UnitNumber":"2", "Area":"258.63", "Dewa":"382037766", "PropertyTypeId":"2", "PropertyType":"Office", "PropertySubTypeId":"422", "PropertySubType":"Office", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120211209004458", "StartDate":"02/01/2023", "EndDate":"01/31/2024", "ContractAnnualAmount":334080.0, "ContractAmount":334080.0, "VersionNumber":2, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}], "AdditionalData":null}}';
            } else if (arg=='contract') {
                statusCode=200;
                responseBody = '{"TimeStamp":"2023-10-06T05:26:04.8723682+00:00", "ResponseCode":"Success", "ValidationErrorsList":[], "Response":{"ContractInformation":{"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000295", "UnitNumber":"2", "Area":"258.63", "Dewa":"382037766", "PropertyTypeId":"2", "PropertyType":"Office", "PropertySubTypeId":"422", "PropertySubType":"Office", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120211209004458", "StartDate":"02/01/2023", "EndDate":"01/31/2024", "ContractAnnualAmount":334080.0, "ContractAmount":334080.0, "VersionNumber":2, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}, "AdditionalData":null}}';
            }
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if (req != null && req.getEndpoint().contains('shareNewLicData') ) {
                 responseBody = '{"Data":[{"status":"Pending for Documents", "sme":null, "shareHldType":"Corporate - BOF", "sancs":[], "name":"REQ-00298741", "mangerNameA":"ربى ربى ربى", "mangerName":"Amine El behhar", "managerNationA":"فرنسا", "managerNation":"France", "locAmd":false, "lines":[{"segment":"Air and Environment", "lineName":"Air and Environment - Consultancy", "amount":11189, "activity":"Consultancy"}, {"segment":null, "lineName":"Economic Register Fee", "amount":10, "activity":null}, {"segment":null, "lineName":"Knowledge Dirham", "amount":10, "activity":null}, {"segment":null, "lineName":"Innovation Dirham", "amount":10, "activity":null}, {"segment":"Air and Environment", "lineName":"Air and Environment - Management (Free for Segment:Air and Environment)", "amount":0, "activity":"Management"}], "lincenseeeng":"Insignia FZ-LLC", "lincenseearabic":"إنسجنيا منطقة حرة-ذ.م.م", "licType":"Commercial License", "licNo":"30973", "legaleng":"Insignia FZ-LLC", "legalarabic":"إنسجنيا منطقة حرة-ذ.م.م", "leaseType":"PMS Lease", "isUniv":false, "isUBOSubmitted":false, "isUBORequired":true, "isRenewalAllowed":false, "idRec":"a1C0k000001ZsxHEAS", "frameworkeng":"Free Zone Limited Liability Company", "frameworkarabic":"شركة منطقة حرة ذات مسؤولية محدودة", "expDate":"2024-06-20", "errorMessage":null, "errorCode":null, "docs":[{"shareHolderName":null, "name":"Certificate of Good Standing issued by the Registrar of Companies", "isRequired":true, "id":null, "category":null}], "businessPark":"Dubai Media City", "buRecomendation":false, "amount":11219, "actspeNotes":null, "activities":[{"segment":"Air and Environment", "lineName":"Consultancy", "amount":0, "activity":"Consultancy"}, {"segment":"Air and Environment", "lineName":"Management", "amount":0, "activity":"Management"}]}]}';
            }
            else if (req != null && req.getEndpoint().contains('/pms')) {
                responseBody = '[{"pmsLeaseId":"a3Y7A0000002GW4UAM", "isSuccess":true, "errorMessage":""}, {"pmsLeaseId":"a3Y7A0000002GW4UAM", "isSuccess":true, "errorMessage":""}, {"pmsLeaseId":"a3Y7A0000002GW4UAM", "isSuccess":true, "errorMessage":""}]';
            }
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }
}
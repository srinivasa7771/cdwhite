@isTest
private class refundFormBanKControllerTest {
 @testSetup
    static void setup() {
        gStg__c setting = new gStg__c();
        setting.Name = 'enableOCR';
        setting.Text_Value__c = 'Passport First Page;New Passport Copy - First Page;Passport - first page;';
        insert setting;
        gStg__c setting1 = new gStg__c();
        setting1.Name = 'OptionsDocs';
        setting1.Text_Value__c = 'Passport First Page;New Passport Copy - First Page;Passport - first page;';
        insert setting1;

        testData.init();
        User usr = testData.createportalUser('test');
        insert usr;

        List<user> ulist = [select contactid from user where id=:usr.id LIMIT 1];
        List<Contact> conList = [select accountid from contact where id=:ulist[0].contactid LIMIT 1];
        conList[0].xped__c =Date.newInstance(2023, 12, 9);
        conList[0].rp__c ='1123123123';
        conList[0].rol__c ='Employee';
        update conList;
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Contact emp=testData.conCrt(null, conList[0].accountId, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(conList[0].accountId, s.Id, conList[0].Id, 'Open', stg.reqq__c);
    }

      static testMethod void doTest() {
        boolean blV;String sV;

           Test.startTest();
           List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];

        g_srvc_definition__c srvDef = new g_srvc_definition__c();
        srvdef.ptype__c= 'normal:10 Days;express:3 Days;';
        srvDef.docslbl__c='Passport First Page:Passport - first page;Passport Last Page:Passport - last page;Personal Photo:Recent passport size photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Attested Marriage Certificate:Attested Marriage Certificate;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;Electricity and water bill:Electricity and water bill;';
        srvDef.srvtdocs__c='Passport First Page:Passport First Page;Passport Last Page:Passport Last Page;Personal Photo:Personal Photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Electricity and water bill:Electricity and water bill;Attested Birth Certificate:Attested Birth Certificate;Mother Passport First Page:Mother Passport First Page;Mother Passport Last Page:Mother Passport Last Page;Mother Visa Copy:Mother Visa Copy;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;';
        srvDef.srvdocs__c ='Passport First Page:Passport - first page;Passport Last Page:Passport - last page;Personal Photo:Recent passport size photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Attested Marriage Certificate:Attested Marriage Certificate;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;Electricity and water bill:Electricity and water bill;';
        //srvDef.pyChk__c=true;
        insert srvDef;
        g_Srvc__c srv =[SELECT name from g_Srvc__c LIMIT 1];
        srv.sdg__c = srvDef.id;
        srv.uid__c='058';
        srv.Sub_Category__c ='Renewals';
        update  srv;

        g_Req__c req =[Select id from g_Req__c  limit 1];
        req.xaed__c =Date.newInstance(2023, 12, 9);
        req.xceidedt__c =Date.newInstance(2023, 12, 9);
        req.e__c='1123123123';
        req.xadh__c='ins;';
        req.xadtx4__c='{"g_bacnm":"Huawei Tech (UAE) FZ-LLC", "bandb__c":"EMIRATES BANK", "gbrnlkid":"a2LIk000000Z1mk", "g_banum":"066850629700087878", "g_iban":"AE980186685062970001784", "g_basft":"", "g_bfrc":"EMIBAEA1", "g_bfsc":"EMRABK123", "g_bifc":"", "inba":"", "otp":"1234"}';
        req.xadtx1__c='{"Routing_Code":"EMIBAEA1", "PrimaryFlag":"true", "ifscCode":null, "IBAN":"AE980186685062970001784", "FusionAccountNumber":"TDD-14035", "Description":"https://dhsoicap-axgfix83p9dp-dx.integration.ocp.oraclecloud.com/ic/builder/rt/DH_Bank_Letter_Attachment_Downloade/live/webApps/bank_letter_attachment_downloader/?call_type=cust&amp;account_number=206414520241114", "CurrencyCode":"AED", "CountryName":"United Arab Emirates", "CountryCode":"AE", "Beneficiary_Bank_Sort_Code":"EMRABK123", "BankName":"EMIRATES BANK", "BankBranchName":"Main Branch", "BankAccountNumber":"066850629700087878", "BankAccountName":"Huawei Tech (UAE) FZ-LLC"}';
         req.xadtx2__c ='{"YARDI_CUSTOMER_CODE":"35621", "ROUTING_CODE":"EMIBAEA1", "INTERMEDIARY_BANK_SWIFT_CODE":null, "EXT_REF_NUMBER":"Customer update bank account WRT AXS SR#206414520241114", "CURRENCY_Code":"AED", "BENEFICIARY_NAME":"Huawei Tech (UAE) FZ-LLC", "BENEFICIARY_IBAN_NO":"AE980186685062970001784", "BENEFICIARY_BANK_SWIFT_CODE":"EMIBAEA1", "BENEFICIARY_BANK_SORT_CODE":"EMRABK123", "BENEFICIARY_BANK_IFSC_CODE":null, "BENEFICIARY_BANK_COUNTRY":"United Arab Emirates", "BENEFICIARY_BANK":"EMIRATES BANK", "BENEFICIARY_ACCOUNT_NO":"066850629700087878", "BENEFICARY_BANK_ADDR3":"", "BENEFICARY_BANK_ADDR2":"", "BENEFICARY_BANK_ADDR1":"Main Branch"}';
        update req;

        List<g_reqitem__c> rqItemList = [SELECT id FROM g_reqitem__c where RQ__c =:req.id];

        g_reqDoc__c rqDoc = new g_reqDoc__c();
        rqDoc.Name='test';
        rqDoc.ats__c =5;
        rqDoc.RQ__c = req.id;
        //rqDoc.nmReq__c =2;
        //rqdoc.anmReqAts__c =2;
        rqdoc.ats__c =4;
        //rqdoc.mnAts__c=4;
        //rqdoc.Req__c= true;
        //rqdoc.reqAts__c= true;
        //rqdoc.upOk__c= true;
        insert rqDoc;

        g_reqitemDoc__c rqItemDoc  = new g_reqitemDoc__c();
        rqItemDoc.Name ='test';
        rqItemDoc.lbl__c ='test';
        rqItemDoc.mxAts__c =0;
        rqItemDoc.mnAts__c =0;
        rqItemDoc.reqItm__c =rqItemList[0].id;
        rqItemDoc.reqDoc__c =rqDoc.id;
        insert rqItemDoc;
           system.runAs(ulist[0]) {

            ApexPages.CurrentPage().getParameters().put('sid', srvDef.id);
                ApexPages.CurrentPage().getParameters().put('id', req.id);
           refundFormBanKController rf=new refundFormBanKController();
           rf.getBankOptions();
           rf.getVfsCountriesOptions();
               refundFormBanKController.BankDetails bk=new refundFormBanKController.BankDetails();

        bk.BankName=bk.BankName;
        bk.CountryName=bk.CountryName;
        bk.BankBranchName=bk.BankBranchName;
        bk.BankAccountNumber=bk.BankAccountNumber;
        bk.CurrencyCode=bk.CurrencyCode;
        bk.BankAccountName=bk.BankAccountName;
        bk.IBAN=bk.IBAN;
        bk.PrimaryFlag=bk.PrimaryFlag;
        bk.CountryCode=bk.CountryCode;
        bk.FusionAccountNumber=bk.FusionAccountNumber;
        bk.Description=bk.Description;
        bk.Routing_Code=bk.Routing_Code;
        bk.Beneficiary_Bank_Sort_Code=bk.Beneficiary_Bank_Sort_Code;
        bk.ifscCode=bk.ifscCode;
               rf.docName=rf.docName;
               rf.imageBase64=rf.imageBase64;
               rf.imageBase264=rf.imageBase264;
               rf.srvcID=rf.srvcID;
               rf.pgHide=rf.pgHide;
        refundFormBanKController.yardiBankDetails ybk=new refundFormBanKController.yardiBankDetails();
ybk.YARDI_CUSTOMER_CODE=ybk.YARDI_CUSTOMER_CODE;
ybk.BENEFICIARY_NAME=ybk.BENEFICIARY_NAME;
ybk.BENEFICIARY_BANK=ybk.BENEFICIARY_BANK;
ybk.CURRENCY_Code=ybk.CURRENCY_Code;
ybk.BENEFICIARY_IBAN_NO=ybk.BENEFICIARY_IBAN_NO;
ybk.BENEFICIARY_ACCOUNT_NO=ybk.BENEFICIARY_ACCOUNT_NO;
ybk.BENEFICARY_BANK_ADDR1=ybk.BENEFICARY_BANK_ADDR1;
ybk.BENEFICARY_BANK_ADDR2=ybk.BENEFICARY_BANK_ADDR2;
ybk.BENEFICARY_BANK_ADDR3=ybk.BENEFICARY_BANK_ADDR3;
ybk.BENEFICIARY_BANK_COUNTRY=ybk.BENEFICIARY_BANK_COUNTRY;
ybk.BENEFICIARY_BANK_SWIFT_CODE=ybk.BENEFICIARY_BANK_SWIFT_CODE;
ybk.ROUTING_CODE=ybk.ROUTING_CODE;
ybk.INTERMEDIARY_BANK_SWIFT_CODE=ybk.INTERMEDIARY_BANK_SWIFT_CODE;
ybk.BENEFICIARY_BANK_SORT_CODE=ybk.BENEFICIARY_BANK_SORT_CODE;
ybk.EXT_REF_NUMBER=ybk.EXT_REF_NUMBER;
ybk.BENEFICIARY_BANK_IFSC_CODE=ybk.BENEFICIARY_BANK_IFSC_CODE;

refundFormBanKController.adh4 abk=new refundFormBanKController.adh4();
abk.g_bacnm=abk.g_bacnm;
abk.bandb=abk.bandb;
abk.g_banum=abk.g_banum;
abk.g_iban=abk.g_iban;
abk.g_basft=abk.g_basft;
abk.g_bfrc=abk.g_bfrc;
abk.g_bfsc=abk.g_bfsc;
abk.g_bifc=abk.g_bifc;
abk.gbrnlkid =abk.gbrnlkid;
abk.inba=abk.inba;

refundFormBanKController.Att attbk=new refundFormBanKController.Att();
attbk.Object_type=attbk.Object_type;
attbk.Attachment_Type=attbk.Attachment_Type;
attbk.Record_Code=attbk.Record_Code;
attbk.File_name=attbk.File_name;
attbk.Attachment=attbk.Attachment;
               rf.saveReq();
               rf.docName='test';
             //  rf.saveAttachment_r();
               rf.saveDraft_m();
               rf.saveRF();

           Test.stopTest();
           }

      }
}
@isTest
private class gctlUsersNewTest {
    static testMethod void doTest() {
        Test.startTest();

        list<g_Srvc__c> srList=new list<g_Srvc__c>();
        list<g_srvc_definition__c> sdList=new list<g_srvc_definition__c>();
        sdList.add(new g_srvc_definition__c(Name='testServDef1', slbl__c='Service 1', sd__c='testing ser1', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef2', slbl__c='Service 2', sd__c='testing ser2', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef3', slbl__c='Service 3', sd__c='testing ser3', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef4', slbl__c='Service 4', sd__c='testing ser4', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef5', slbl__c='Service 5', sd__c='testing ser5', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef6', slbl__c='Service 6', sd__c='testing ser6', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef7', slbl__c='Service 7', sd__c='testing ser7', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef8', slbl__c='Service 8', sd__c='testing ser8', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef9', slbl__c='Service 9', sd__c='testing ser9', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        insert sdList;

        g_srvc_settings__c ssetting = testData.stgCrt();

        srList.add(new g_Srvc__c(Name='testServ1', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef1'].Id, lbl__c='Service 1', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES',
                                     Sub_Category__c='LETTERS & NOCs', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te1', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ2', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef2'].Id, lbl__c='Service 2', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='VISAS AND IMMIGRATION', Sub_Category__c='NEW', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te2', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ3', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef3'].Id, lbl__c='Service 3', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='COMPANY SERVICES', Sub_Category__c='NEW', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te3', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ4', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef4'].Id, lbl__c='Service 4', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='OTHER SERVICES', Sub_Category__c='TRANSFER', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te4', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ5', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef5'].Id, lbl__c='Service 5', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES',
                                     Sub_Category__c='RENEW', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te5', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ6', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef6'].Id, lbl__c='Service 6', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='VISAS AND IMMIGRATION', Sub_Category__c='TRANSFER',
                                     AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te6', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ7', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef7'].Id, lbl__c='Service 7', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='COMPANY SERVICES', Sub_Category__c='DEPOSIT & PAYMENTS',
                                     AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te7', actv__c=true, Prk__c='Dubai Internet City'));
        insert srList;
        System.debug('srList======='+srList);

        User u = testData.createportalUser('pnActUsr');
        insert u;
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id=:u.contactId];
        Account A = [Select id, on__c , onar__c , Website, vespe__c, vespex__c, vetemp__c,
            vbtemp__c , vetst__c, vespst__c, vespstx__c , vbtst__c, vev__c, mxPortalUsers__c,
            Name, Email__c, lPrk__c, Building_Name__c,
                     xcublg__c, Location__c, Location_Cluster__c, xcuzn__c , Phone, Type, Prk__c, adb__c,
                         info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c,
                         sncNt__c, vbvv__c, lcidt1__c,
                     ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c,
                         psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c,
                         licexdt__c, licIdt__c,
                     bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c , adx__c, adc__c from Account where id=:C.AccountId ];
        A.mxPortalUsers__c = 5;
        update A;
        Contact c1 = new Contact(Salutation='Mr.', firstName='fName1', lastName='lName1',
            STA__c='Active', rol__c='Employee', p__c='Pass1234', pid__c=date.today(), ped__c=date.today().addYears(1),
            bc__c='India', pic__c='India', AccountId=A.Id);
        insert c1;

        Contact c2 = new Contact(Salutation='Mr.', firstName='fName2', lastName='lName2',
            STA__c='Active', rol__c='Employee', p__c='Pas12345', pid__c=date.today(), ped__c=date.today().addYears(1),
            bc__c='India', pic__c='India', AccountId=A.Id);
        insert c2;

        Contact c3 = new Contact(Salutation='Mr.', firstName='fName3', lastName='lName3',
            STA__c='Active', rol__c='Employee', p__c='Pa123456', pid__c=date.today(), ped__c=date.today().addYears(1),
            bc__c='India', pic__c='India', AccountId=A.Id);
        insert c3;

        Contact c4 = new Contact(Salutation='Mr.', firstName='fName4', lastName='lName4',
            STA__c='Active', rol__c='Employee', p__c='P1234567', pid__c=date.today(), ped__c=date.today().addYears(1),
            nc__c='India', bc__c='India', pic__c='India', AccountId=A.Id);
        insert c4;
        testData.init();testData.bRulesReqCrt();testData.bRulesItemCrt();g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c = '208';
        update s;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_Req__c r=testData.reqCrt(A.Id, s.Id, C.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);
        g_reqitem__c ritm = [Select id, Name, xcp__c, xcnc__c from g_reqitem__c where RQ__c=:r.Id LIMIT 1];
            system.Debug('request ritm'+ritm);
        ritm.xcnc__c = 'India';
        ritm.xcp__c = 'P1234567';
        ritm.xcfn__c = 'riUserF1';
        ritm.xcln__c = 'riUserL1';
        ritm.xceml__c = 'riUserF1.reUserL1@test.comstg';
        update ritm;
        system.Debug('request ritm'+ritm);

        System.runAs(u) {
            testdata.init();
            gctlUsersNew obj = new gctlUsersNew ();
            obj.wrp = ritm;
            obj.createUser();
            //obj.loadEmployeeContact();
            obj.conId = c.Id;
            obj.UsrId = u.Id;
            obj.AccID = A.Id;
            obj.foundContact = c;
            obj.loadEmployeeData();
            obj.clearDataCntrl();
            //PageReference pageRef = Page.MyAccount;
            PageReference pageRef = new PageReference('/apex/MyAccount');
            pageRef.getParameters().put('selInd', c2.id);
            pageRef.getParameters().put('acsType', 'fromManage');
            Test.setCurrentPage(pageRef);
            obj.loadEmployeeData();
            obj.defaultGroupsAccess = true;
            obj.emailId = 'fname2.laname2@testorg.com';
            obj.username = 'fname2.laname2@testorg.comstg';
            obj.checkUserExistWithAnotherAcc();
            obj.chkUserName();
            obj.validateUnique();
            obj.accessDefaultCntrl();
            obj.checkUserExist(c2);
            PageReference pg = obj.addUser();

            //PageReference pageRef2 = Page.MyAccount;
            PageReference pageRef2 = new PageReference('/apex/MyAccount');
            pageRef2.getParameters().put('selInd', c.id);
            pageRef2.getParameters().put('acsType', 'fromManage');
            Test.setCurrentPage(pageRef2);
            obj.defaultGroupsAccess = true;
            obj.UsrExist = true;
            obj.conExist = true;
            obj.loadEmployeeData();

        }
        Test.stopTest();
    }

    static testMethod void doTest1() {
        Test.startTest();

        list<g_Srvc__c> srList=new list<g_Srvc__c>();
        list<g_srvc_definition__c> sdList=new list<g_srvc_definition__c>();
        sdList.add(new g_srvc_definition__c(Name='testServDef1', slbl__c='Service 1', sd__c='testing ser1', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef2', slbl__c='Service 2', sd__c='testing ser2', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef3', slbl__c='Service 3', sd__c='testing ser3', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef4', slbl__c='Service 4', sd__c='testing ser4', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef5', slbl__c='Service 5', sd__c='testing ser5', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef6', slbl__c='Service 6', sd__c='testing ser6', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef7', slbl__c='Service 7', sd__c='testing ser7', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef8', slbl__c='Service 8', sd__c='testing ser8', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef9', slbl__c='Service 9', sd__c='testing ser9', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        insert sdList;

        g_srvc_settings__c ssetting = testData.stgCrt();

        srList.add(new g_Srvc__c(Name='testServ1', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef1'].Id, lbl__c='Service 1', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES',
                                     Sub_Category__c='LETTERS & NOCs', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te1', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ2', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef2'].Id, lbl__c='Service 2', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='VISAS AND IMMIGRATION', Sub_Category__c='NEW', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te2', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ3', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef3'].Id, lbl__c='Service 3', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='COMPANY SERVICES', Sub_Category__c='NEW', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te3', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ4', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef4'].Id, lbl__c='Service 4', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='OTHER SERVICES', Sub_Category__c='TRANSFER', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te4', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ5', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef5'].Id, lbl__c='Service 5', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES',
                                     Sub_Category__c='RENEW', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te5', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ6', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef6'].Id, lbl__c='Service 6', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='VISAS AND IMMIGRATION', Sub_Category__c='TRANSFER',
                                     AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te6', actv__c=true, Prk__c='Dubai Internet City'));
        srList.add(new g_Srvc__c(Name='testServ7', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef7'].Id, lbl__c='Service 7', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='COMPANY SERVICES', Sub_Category__c='DEPOSIT & PAYMENTS',
                                     AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                 stg__c=ssetting.id, uid__c='te7', actv__c=true, Prk__c='Dubai Internet City'));
        insert srList;
        System.debug('srList======='+srList);

        User u = testData.createportalUser('pnActUsr');
        insert u;
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id=:u.contactId];
        Account A = [Select id, on__c , onar__c , Website, vespe__c, vespex__c, vetemp__c,
            vbtemp__c , vetst__c, vespst__c, vespstx__c , vbtst__c, vev__c, mxPortalUsers__c,
            Name, Email__c, lPrk__c, Building_Name__c,
                     xcublg__c, Location__c, Location_Cluster__c, xcuzn__c , Phone, Type, Prk__c, adb__c,
                         info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c,
                         sncNt__c, vbvv__c, lcidt1__c,
                     ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c,
                         psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c,
                         licexdt__c, licIdt__c,
                     bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c , adx__c, adc__c from Account where id=:C.AccountId ];
        A.mxPortalUsers__c = 5;
        update A;
        Contact c1 = new Contact(Salutation='Mr.', firstName='fName1', lastName='lName1',
            STA__c='Active', rol__c='Employee', p__c='Pass1234', pid__c=date.today(), ped__c=date.today().addYears(1),
            bc__c='India', pic__c='India', AccountId=A.Id);
        insert c1;

        Contact c2 = new Contact(Salutation='Mr.', firstName='fName2', lastName='lName2',
            STA__c='Active', rol__c='Employee', p__c='Pas12345', pid__c=date.today(), ped__c=date.today().addYears(1),
            bc__c='India', pic__c='India', AccountId=A.Id);
        insert c2;

        Contact c3 = new Contact(Salutation='Mr.', firstName='fName3', lastName='lName3',
            STA__c='Active', rol__c='Employee', p__c='Pa123456', pid__c=date.today(), ped__c=date.today().addYears(1),
            bc__c='India', pic__c='India', AccountId=A.Id);
        insert c3;

        Contact c4 = new Contact(Salutation='Mr.', firstName='fName4', lastName='lName4',
            STA__c='Active', rol__c='Employee', p__c='P1234567', pid__c=date.today(), ped__c=date.today().addYears(1),
            nc__c='India', bc__c='India', pic__c='India', AccountId=A.Id);
        insert c4;
        testData.init();testData.bRulesReqCrt();testData.bRulesItemCrt();g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c = '208';
        update s;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_Req__c r=testData.reqCrt(A.Id, s.Id, C.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);
        g_reqitem__c ritm = [Select id, Name, xcp__c, xcnc__c from g_reqitem__c where RQ__c=:r.Id LIMIT 1];
            system.Debug('request ritm'+ritm);
        ritm.xcnc__c = 'India';
        ritm.xcp__c = 'P1234567';
        ritm.xcfn__c = 'riUserF1';
        ritm.xcln__c = 'riUserL1';
        ritm.xceml__c = 'riUserF1.reUserL1@test.comstg';
        update ritm;
        system.Debug('request ritm'+ritm);

        System.runAs(u) {
            testdata.init();
            gctlUsersNew obj = new gctlUsersNew ();
            obj.wrp = ritm;
            obj.createUser();
            //obj.loadEmployeeContact();
            obj.conId = c.Id;
            obj.UsrId = u.Id;
            obj.AccID = A.Id;
            obj.foundContact = c;
            obj.loadEmployeeData();
            obj.clearDataCntrl();
            //PageReference pageRef = Page.MyAccount;
            PageReference pageRef = new PageReference('/apex/MyAccount');
            pageRef.getParameters().put('selInd', c2.id);
            pageRef.getParameters().put('acsType', 'fromManage');
            Test.setCurrentPage(pageRef);
            obj.loadEmployeeData();
            obj.defaultGroupsAccess = true;
            obj.emailId = 'fname2.laname2@testorg.com';
            obj.username = 'fname2.laname2@testorg.comstg';
            obj.checkUserExistWithAnotherAcc();
            obj.chkUserName();
            obj.validateUnique();
            obj.accessDefaultCntrl();
            obj.checkUserExist(c2);
            PageReference pg = obj.addUser();

            //PageReference pageRef3 = Page.MyAccount;
            PageReference pageRef3 = new PageReference('/apex/MyAccount');
            pageRef3.getParameters().put('selInd', null);
            pageRef3.getParameters().put('acsType', null);
            Test.setCurrentPage(pageRef3);
            obj.defaultGroupsAccess = true;
            obj.UsrExist = false;
            obj.conExist = false;
            obj.firstName = 'AnthrTest1';
            obj.lastName = 'AnthrLstTest1';
            obj.passNumber = 'mn120967';
            obj.nationality = 'India';
            obj.emailId = 'AnthrTest1.AnthrLstTest1@testorg.com';
            obj.username = 'AnthrTest1.AnthrLstTest1@testorg.comstg';
            obj.phNo = '503059523';
            obj.createContact();
            obj.loadEmployeeData();

        }
        Test.stopTest();
    }
}
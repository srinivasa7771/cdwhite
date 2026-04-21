@isTest
private class grp_NonVisaServiceReportControllerTest {
    /* static void setup() {
        testData.init();
       User usr = testData.createportalUser('test');
        insert usr;
        List<user> ulist = [select contactid from user where id=:usr.id LIMIT 1];
        List<Contact> conList = [select accountid from contact where id=:ulist[0].contactid LIMIT 1];
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //Contact emp=testData.conCrt(null, conList[0].accountId, 'Active', 'Employee', 'Pass1', 'Egypt');

    }*/
    static testmethod void test() {

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
        List<Contact> cntLst = new List<Contact>();
        cntLst.add(new Contact(Firstname='MOHAMED', LastName='TAWFIK',
            Birthdate=date.parse('7/11/1956'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('5/3/2024'), nc__c='Egypt', STA__c='Active',
            idtxt__c='125482', idedt__c=date.parse('27/11/2022'), rp__c='201/2011/7103656',
            rped__c=date.parse('27/11/2022'), mbs__c=26548, ma__c=14166.67,
            mta__c=2500, moa__c=0, p__c='Z4914936'));
        cntLst.add(new Contact(Firstname='KATARINA', LastName='RUNCAKOVA',
            Birthdate=date.parse('22/01/1987'), Salutation='Ms.', rol__c='Employee',
            ped__c=date.parse('12/12/2021'), nc__c='Slovakia', STA__c='Active',
            idtxt__c='185858', idedt__c=date.parse('4/4/2023'), rp__c='201/2014/7157954',
            rped__c=date.parse('27/11/2022'), mbs__c=14083, ma__c=11333,
            mta__c=2000, moa__c=0, p__c='N1311439'));
        cntLst.add(new Contact(Firstname='KAMRAN', LastName='SIDDIQUI',
            Birthdate=date.parse('2/8/1971'), Salutation='Ms.', rol__c='Employee',
            ped__c=date.parse('7/8/2029'), nc__c='United States', STA__c='Active',
            idtxt__c='124587', idedt__c=date.parse('15/03/2023'), rp__c='201/2011/7080386',
            rped__c=date.parse('15/03/2023'), mbs__c=36716, ma__c=17000,
            mta__c=4000, moa__c=0, p__c='Z3657507'));
        cntLst.add(new Contact(Firstname='JUNAID', LastName='SIDDIQUE',
            Birthdate=date.parse('13/09/1972'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('7/5/2023'), nc__c='Pakistan', STA__c='Active',
            idtxt__c='37613', idedt__c=date.parse('4/2/2018'), rp__c='201/2006/7074864',
            rped__c=date.parse('27/11/2022'), mbs__c=37687.82, ma__c=17000,
            mta__c=4000, moa__c=0, p__c='97360718'));
        cntLst.add(new Contact(Firstname='KATHERINE AMANDER', LastName='OUTTERSIDE',
            Birthdate=date.parse('4/2/1981'), Salutation='Ms.', rol__c='Student',
            ped__c=date.parse('1/6/2022'), nc__c='United Kingdom', STA__c='Active',
            idtxt__c='115445', idedt__c=date.parse('22/11/2016'), rp__c='201/2009/7161108',
            rped__c=date.parse('22/11/2016'), mbs__c=30375, ma__c=0, mta__c=0,
            moa__c=0, p__c='761250334'));
        cntLst.add(new Contact(Firstname='JOHN', LastName='COLLINS', Birthdate=date.parse('27/03/1957'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('29/01/2016'),
            nc__c='United States', STA__c='Active', idtxt__c='159833', idedt__c=date.parse('28/04/2016'),
            rp__c='201/2013/7075972', rped__c=date.parse('27/11/2022'), mbs__c=54000,
            ma__c=19000, mta__c=5000, moa__c=0, p__c='Z2511113'));
        cntLst.add(new Contact(Firstname='JOHN', LastName='WALKER', Birthdate=date.parse('17/04/1961'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('3/6/2025'),
            nc__c='United States', STA__c='Active', idtxt__c='145579', idedt__c=date.parse('11/6/2021'),
            rp__c='201/2012/7147579', rped__c=date.parse('27/11/2022'), mbs__c=47494,
            ma__c=17000, mta__c=4000, moa__c=0, p__c='459040677'));
        cntLst.add(new Contact(Firstname='JOHN', LastName='SHORLAND',
            Birthdate=date.parse('11/11/1972'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('19/06/2025'), nc__c='United Kingdom', STA__c='Active',
            idtxt__c='182472', idedt__c=date.parse('7/5/2017'), rp__c='201/2014/7096510',
            rped__c=date.parse('27/11/2022'), mbs__c=27702, ma__c=0, mta__c=0,
            moa__c=0, p__c='EH957849'));
        cntLst.add(new Contact(Firstname='JOHN', LastName='HAYDEN', Birthdate=date.parse('1/11/1946'),
            Salutation='Ms.', rol__c='Employee', ped__c=date.parse('15/12/2015'),
            nc__c='United Kingdom', STA__c='Active', idtxt__c='163610', idedt__c=date.parse('23/06/2021'),
            rp__c='201/2013/7139734', rped__c=date.parse('14/07/2016'), mbs__c=96666,
            ma__c=25583, mta__c=5500, moa__c=0, p__c='Z2349387'));
        cntLst.add(new Contact(Firstname='JOHN', LastName='NAWAR', Birthdate=date.parse('10/4/1980'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('26/11/2024'),
            nc__c='Egypt', STA__c='Active', idtxt__c='11609', idedt__c=date.parse('23/06/2021'),
            rp__c='201/2005/7002992', rped__c=date.parse('27/11/2022'), mbs__c=35003,
            ma__c=21050, mta__c=4000, moa__c=0, p__c='106930276'));
        cntLst.add(new Contact(Firstname='JOHN LAWRENCE', LastName='MACALINTAL',
            Birthdate=date.parse('10/1/1987'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('21/02/2015'), nc__c='Philippines', STA__c='Active',
            idtxt__c='186306', idedt__c=date.parse('23/07/2017'), rp__c='201/2014/7155010',
            rped__c=date.parse('27/11/2022'), mbs__c=12250, ma__c=0, mta__c=0,
            moa__c=0, p__c='132124520'));
        cntLst.add(new Contact(Firstname='KATHY', LastName='YOUNGBLOOD',
            Birthdate=date.parse('5/9/1969'), Salutation='Ms.', rol__c='Employee',
            ped__c=date.parse('18/01/2018'), nc__c='Canada', STA__c='Active',
            idtxt__c='89990', idedt__c=date.parse('20/06/2018'), rp__c='201/2009/7101968',
            rped__c=date.parse('20/06/2018'), mbs__c=21666, ma__c=14167,
            mta__c=2500, moa__c=0, p__c='508438652'));
        cntLst.add(new Contact(Firstname='JYOTI', LastName='YAGNIK', Birthdate=date.parse('30/09/1971'),
            Salutation='Ms.', rol__c='Student', ped__c=date.parse('26/08/2025'),
            nc__c='India', STA__c='Active', idtxt__c='152453', idedt__c=date.parse('23/06/2021'),
            rp__c='201/2012/7219753', rped__c=date.parse('23/06/2021'), mbs__c=23002,
            ma__c=14167, mta__c=2500, moa__c=0, p__c='801686729'));
        cntLst.add(new Contact(Firstname='JONATHAN', LastName='SMYTHE SHERMAN',
            Birthdate=date.parse('6/6/1972'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('4/8/2020'), nc__c='United Kingdom', STA__c='Active',
            idtxt__c='1869', idedt__c=date.parse('11/6/2022'), rp__c='201/2003/7049200',
            rped__c=date.parse('27/11/2022'), mbs__c=43409, ma__c=17000,
            mta__c=4000, moa__c=0, p__c='AS9919022'));
        cntLst.add(new Contact(Firstname='JOHN', LastName='BIDGOOD', Birthdate=date.parse('16/05/1972'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('14/05/2026'),
            nc__c='United Kingdom', STA__c='Active', idtxt__c='163500', idedt__c=date.parse('24/01/2019'),
            rp__c='201/2013/7132289', rped__c=date.parse('24/01/2019'), mbs__c=42420,
            ma__c=17000, mta__c=4000, moa__c=0, p__c='BA838712'));
        cntLst.add(new Contact(Firstname='KAIN', LastName='CLARK-DARBY',
            Birthdate=date.parse('12/1/1977'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('1/4/2022'), nc__c='United Kingdom', STA__c='Active',
            idtxt__c='79401', idedt__c=date.parse('1/10/2015'), rp__c='201/2008/7293296',
            rped__c=date.parse('27/11/2022'), mbs__c=59786, ma__c=0, mta__c=0,
            moa__c=0, p__c='99267168'));
        cntLst.add(new Contact(Firstname='KENNETH', LastName='ROSS', Birthdate=date.parse('27/09/1973'),
            Salutation='Ms.', rol__c='Employee', ped__c=date.parse('16/05/2024'),
            nc__c='United Kingdom', STA__c='Active', idtxt__c='171172', idedt__c=date.parse('30/07/2019'),
            rp__c='201/2013/7238268', rped__c=date.parse('30/07/2019'), mbs__c=27484,
            ma__c=0, mta__c=0, moa__c=0, p__c='208276169'));
        cntLst.add(new Contact(Firstname='KAMESH', LastName='VENKATARAMAN',
            Birthdate=date.parse('3/6/1985'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('2/10/2026'), nc__c='India', STA__c='Active',
            idtxt__c='136571', idedt__c=date.parse('26/01/2021'), rp__c='201/2012/7007968',
            rped__c=date.parse('26/01/2021'), mbs__c=30033, ma__c=14167,
            mta__c=3500, moa__c=0, p__c='A07009600'));
        cntLst.add(new Contact(Firstname='KHALED', LastName='MALAS', Birthdate=date.parse('9/11/1987'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('20/12/2020'),
            nc__c='Jordan', STA__c='Active', idtxt__c='186687', idedt__c=date.parse('2/3/2017'),
            rp__c='201/2014/7168841', rped__c=date.parse('27/11/2022'), mbs__c=17750,
            ma__c=0, mta__c=0, moa__c=0, p__c='H0855734'));
        cntLst.add(new Contact(Firstname='KARIM', LastName='MOUSA', Birthdate=date.parse('11/12/1982'),
            Salutation='Ms.', rol__c='Student', ped__c=date.parse('5/11/2022'),
            nc__c='Poland', STA__c='Active', idtxt__c='119123', idedt__c=date.parse('11/6/2022'),
            rp__c='201/2011/7009124', rped__c=date.parse('27/11/2022'), mbs__c=16960,
            ma__c=0, mta__c=0, moa__c=0, p__c='BA670602'));
        cntLst.add(new Contact(Firstname='KARIM', LastName='YOUNSI', Birthdate=date.parse('19/04/1982'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('5/9/2021'),
            nc__c='Tunisia', STA__c='Active', idtxt__c='86760', idedt__c=date.parse('11/6/2022'),
            rp__c='201/2009/7048965', rped__c=date.parse('27/11/2022'), mbs__c=51577.44,
            ma__c=19833, mta__c=5000, moa__c=0, p__c='2699127'));
        cntLst.add(new Contact(Firstname='KAROL', LastName='SEREDAY',
            Birthdate=date.parse('22/04/1982'), Salutation='Ms.', rol__c='Employee',
            ped__c=date.parse('14/07/2022'), nc__c='Slovakia', STA__c='Active',
            idtxt__c='11330', idedt__c=date.parse('11/6/2022'), rp__c='201/2004/7078131',
            rped__c=date.parse('27/11/2022'), mbs__c=34971, ma__c=17000,
            mta__c=4000, moa__c=0, p__c='AF3924462'));
        cntLst.add(new Contact(Firstname='KARTHIGASEN', LastName='PATHER',
            Birthdate=date.parse('1/12/1974'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('5/9/2020'), nc__c='South Africa', STA__c='Active',
            idtxt__c='79265', idedt__c=date.parse('11/6/2022'), rp__c='201/2008/7265635',
            rped__c=date.parse('15/09/2017'), mbs__c=26289, ma__c=14167,
            mta__c=3500, moa__c=0, p__c='AH6802402'));
        cntLst.add(new Contact(Firstname='KARTHIK', LastName='RAGHURAMAN',
            Birthdate=date.parse('24/05/1971'), Salutation='Mr.', rol__c='Student',
            ped__c=date.parse('26/12/2027'), nc__c='India', STA__c='Active',
            idtxt__c='142339', idedt__c=date.parse('21/10/2020'), rp__c='201/2012/7090292',
            rped__c=date.parse('27/05/2023'), mbs__c=56266.25, ma__c=19833.33,
            mta__c=5000, moa__c=0, p__c='G4926728'));
        cntLst.add(new Contact(Firstname='KARTHIK', LastName='SAMI', Birthdate=date.parse('16/11/1971'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('14/06/2025'),
            nc__c='India', STA__c='Active', idtxt__c='145041', idedt__c=date.parse('26/01/2021'),
            rp__c='201/2012/7137377', rped__c=date.parse('27/11/2022'), mbs__c=53983,
            ma__c=23625, mta__c=5500, moa__c=0, p__c='206526853'));
        cntLst.add(new Contact(Firstname='KASHIF', LastName='BASHIR AHMAD',
            Birthdate=date.parse('29/01/1982'), Salutation='Mr.', rol__c='Employee',
            ped__c=date.parse('19/06/2018'), nc__c='Pakistan', STA__c='Active',
            idtxt__c='9000045822', idedt__c=date.parse('26/01/2021'), rp__c='201/2016/7136761',
            rped__c=date.parse('20/06/2019'), mbs__c=39583, ma__c=17000,
            mta__c=4000, moa__c=0, p__c='A00696072'));
        cntLst.add(new Contact(Firstname='KARUN', LastName='DAS', Birthdate=date.parse('9/8/1969'),
            Salutation='Mr.', rol__c='Employee', ped__c=date.parse('26/02/2027'),
            nc__c='India', STA__c='Active', idtxt__c='3908', idedt__c=date.parse('21/05/2021'),
            rp__c='201/2001/7022364', rped__c=date.parse('21/05/2021'), mbs__c=29395,
            ma__c=14167, mta__c=3500, moa__c=0, p__c='104825075'));
        cntLst.add(new Contact(Firstname='KUSHBOO', LastName='JETHANAND PAGARNI',
            Birthdate=date.parse('9/7/1990'), Salutation='Ms.', rol__c='Non Sponsored',
            ped__c=date.parse('20/06/2015'), nc__c='India', STA__c='Active',
            idtxt__c='NI15719', idedt__c=date.parse('1/10/2015'), rp__c='203/2003/7022364',
            rped__c=date.parse('14/03/2016'), mbs__c=5700, ma__c=5104, mta__c=1000,
            moa__c=0, p__c='Z1969468'));
        insert cntLst;

        testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            //Account a1=testData.accCrt(false);
            Contact sp=testData.conCrt(null, A.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, A.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
           g_Req__c r=testData.reqCrt(A.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            /*g_Req__c r1=testData.reqCrt(A.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Req__c r2=testData.reqCrt(A.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Req__c r3=testData.reqCrt(A.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Req__c r4=testData.reqCrt(A.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');
            g_Tran__c T1 = new g_Tran__c(Acc__c=r1.Acc__c, RQ__c=r1.Id, TP__c='Payment');
            g_Tran__c T2 = new g_Tran__c(Acc__c=r2.Acc__c, RQ__c=r2.Id, TP__c='Payment');
            g_Tran__c T3 = new g_Tran__c(Acc__c=r3.Acc__c, RQ__c=r3.Id, TP__c='Payment');
            g_Tran__c T4 = new g_Tran__c(Acc__c=r4.Acc__c, RQ__c=r4.Id, TP__c='Payment');*/

        Test.startTest();
        system.runAs(u) {
            grp_NonVisaServiceReportController obj = new grp_NonVisaServiceReportController();
            obj.ageSelectedValue = 'Employee';
            obj.ageChangeMethod();
            obj.rpSelectedValue = 'Employee';
            obj.rpChangeMethod();
            obj.passSelectedValue = 'Employee';
            obj.passportChangeMethod();
            obj.countrySelectedValue = 'Employee';
            obj.countryChangeMethod();
            obj.genderSelectedValue = 'Employee';
            obj.genderChangeMethod();
            obj.TypeSelectedValue = 'Employee';
            obj.typeChangeMethod();
            obj.salarySelectedValue = 'Employee';
            obj.salaryChangeMethod();
            obj.gettransDa();
            //obj.TransactionDataWrap = new obj.TransactionDataWrap('Name', 'Service', 'passNo', 'paymentTyp', 'paymentMethod', 'payInitDate', '12/12/2020', '123.45', 'transcStatus');
            //obj.TransactionDataWrap = new obj.TransactionDataWrap();
        }
        Test.stopTest();
    }
}
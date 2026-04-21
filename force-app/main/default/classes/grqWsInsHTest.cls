@istest
public class grqWsInsHTest {
    static TestMethod void doTest() {
        Test.startTest();

        gStg__c cs = new gStg__c();
        cs.name = 'BH';
        cs.Text_Value__c = '01m20000000BKEa';
        insert cs;
        gStg__c cs1 = new gStg__c();
        cs1.name = 'slaExpiry';
        cs1.Number_Value__c = 50;
        insert cs1;
        List<adnicWS__c> lstGStg = new List<adnicWS__c>();
        adnicWS__c CalPrem = new adnicWS__c(Name='CalPrem', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');  lstGStg.add(CalPrem);
        adnicWS__c jsnCre = new adnicWS__c(Name='Json Creation', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(jsnCre);
        adnicWS__c Decrypt = new adnicWS__c(Name='Decrypt', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(Decrypt);
        adnicWS__c Encrypt = new adnicWS__c(Name='Encrypt', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(Encrypt);

        Country__c ctry = new Country__c(Name = 'Egypt', ntadnic__c  = 'Egypt');
        insert ctry;

        insert lstGStg;
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact con=testData.conCrt(null, a.Id, 'Active', 'Spouse', 'Pass1', 'Egypt');
        con.rol__c='Spouse';
        con.e__c='201/2017/7067890';
        update con;
        g_Req__c r=testData.reqCrt(a.Id, s.Id, con.Id, 'Open', stg.reqq__c);
        r.xintp__c ='Basic';
        r.xcmob__c='+971555555555';
        r.xceml__c='test.test@test.com';
        r.xard__c=true;
        r.xceidid__c='784197653865890';
        r.con__c = con.id;
        r.xbrnd__c = 'DMC';
        r.xaloc__c = 'test location';
        r.xbn__c = 'Al Ameri Tower';
        r.xcms__c = 'Married';
        r.xcslt__c = 'Mr.';
        r.xpgs__c = '';
        r.xirfn__c = '27352746732974';
        r.xqno__c = '75236726';
        update r;
        //system.debug('rol:::'+r.Con__r.rol__c);
        List< g_reqitem__c > reqItemList =[SELECT id, AP__c, sta__c, RQ__c, RQ__r.Con__r.rol__c, RQ__r.Con__c FROM g_reqitem__c where RQ__C=: r.id];

        g_reqDoc__c rdoc= new g_reqDoc__c(Name='test', RQ__c=r.Id);
        insert rdoc;
        Map<Id, Contact> conMap = new map<Id, Contact>();
        conMap.put(con.id, con);

        map < Id, g_Req__c > reqMap  = new map < Id, g_Req__c >();
        map < Id, String > reqItDocMap  = new map < Id, String >();
         map < Id, String > mapRqIdItm = new map < Id, String >();
        List <Id> rqIdList = new List<Id>();
        //reqMap.put(r.id, r);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', STA__C='Completed');
        insert T;
        System.debug('====='+T);
        g_TranItem__c ti=new g_TranItem__c();
        ti.A__c=1;
        ti.T__c=T.Id;
        ti.Tp__c = 'Payment';
        ti.itm__c=reqItemList[0].id;
        ti.STA__C='Completed';
        for (g_reqitem__c rqIt : reqItemList) {
           // ti.itm__c=rqIt.id;
            //ti.STA__C='Completed';
            reqMap.put(rqIt.id, r);
            reqItDocMap.put(rqIt.id, 'Passport');
            rqIdList.add(rqIt.id);
            mapRqIdItm.put(rqIt.Id, rqIt.RQ__c);
        }

        insert ti;
        reqItemList[0] = [Select id, AP__c, xramt__c, RQ__c, RQ__r.Con__c, RQ__r.Con__r.rol__c from g_reqitem__c where id =:reqItemList[0].id];
        reqItemList[0].xramt__c=100.00;
        String temp;
        for (Id rqitid : reqMap.keySet()) {
            g_req__c req2 = reqMap.get(rqitid);
            req2.Con__c = con.Id;
            req2.Con__r = con;
            reqMap.put(rqitid, req2);
            temp = rqitid;
        }
        System.debug('::reqMap::'+reqMap);
        System.debug('::Request::::'+reqMap.get(temp));

        grqWsInsH.insgeneratePolicy(reqItemList, reqMap, 'Insurance', 'generatePolicy', conMap);
        grqWsInsH.uploadPolicyDoc(rqIdList, reqItDocMap, mapRqIdItm, 'Insurance', 'uploadDoc');
        grqWsInsH.createMedicalRequest(new List < g_reqitem__c >(), '', '');
        grqWsInsH.createRPRequest(new List < g_reqitem__c >(), '', '');
        grqWsInsH.createLARequest(new List < g_reqitem__c >(), '', '');
        grqWsInsH.createBankAcc(r, reqItemList[0]);
        grqWsInsH.createCDBGRefund(r, reqItemList[0]);

        List<Id> ritemIds = new List<Id> {reqItemList[0].Id};
        grqWsInsH.createUserLA(ritemIds);
        grqWsInsH.createLAMD(reqItemList, 'Insurance', 'generatePolicy');

        Test.stopTest();
    }
}
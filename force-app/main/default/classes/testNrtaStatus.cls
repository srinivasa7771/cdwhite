@isTest
public class testNrtaStatus {

    @isTest static void testUpdateNrtaStatus() {

        Test.startTest();
        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        /*** tests for --updateNrtaStatus-- ***/
        //valid json - valid response
        NrtaStatus.updateNrtaStatus('{"reqNumber":"'+rq.Name+'", "fromStatus":"At Dispatcher", "toStatus":"c", "updateTimeStamp":"3/08/2016 0:00", "updateReason":"test11"}');
        //exception
        NrtaStatus.updateNrtaStatus('{"reqNumber":"'+rq.Name+'", "fromStatus":"At Dispatcher", "toStatus":"Accepted", "updateTimeStamp":"3/08/2016 0:00", "updateReason":"test11"}');
        //record not found
        NrtaStatus.updateNrtaStatus('{"reqNumber":"'+'TestNotFound'+'", "fromStatus":"At Dispatcher", "toStatus":"Accepted", "updateTimeStamp":"3/08/2016 0:00", "updateReason":"test11"}');
        //invalid JSON format
        NrtaStatus.updateNrtaStatus('"reqNumber":"'+rq.Name+'", "fromStatus":"At Dispatcher", "toStatus":"Accepted", "updateTimeStamp":"3/08/2016 0:00", "updateReason":"test11"}');

        /*** tests for --updateAmount-- ***/
        NrtaStatus.updateAmount(rq.Name, Decimal.valueOf('100.20'));        // exception
        List<gStg__c> lstCS = new List<gStg__c>();
        gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
        lstCS.add(paidParking);
        gStg__c srvc_pRenewal = new gStg__c(name='srvc_pRenewal', Text_Value__c = 'a0LN0000006uZryAAA');
        lstCS.add(srvc_pRenewal);
        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.CREATABLE, lstCS);
        insert secDec.getRecords();

        NrtaStatus.updateAmount(rq.Name, Decimal.valueOf('100.20'));        // srvc is only for paid parking
        s.uid__c = '154'; update s;
        NrtaStatus.updateAmount(rq.Name, Decimal.valueOf('100.20'));        // valid json, valid response
        NrtaStatus.updateAmount(rq.Name+'0', Decimal.valueOf('100.20'));    // record not found

        String pDetails = '{"agreements":[{"totalslots":5, "totalAmt":"2000.00", "stDate":null, "sector":null, "orclId":"29258", "expDate":null, "agNo":"AG-060612", "cardslist":[{"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"Ankit", "cardexpDate":"2017-12-10"}, {"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"Ankit", "cardexpDate":"2017-12-10"}]}]}';
        NrtaStatus.parkingRenewal(pDetails);
    }
}
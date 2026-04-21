@isTest
private class AsyncAXSDHATest {
    static testmethod void test1() {

     Test.startTest();
        gStg__c cusStg = new gStg__c();
        cusStg.Name = 'DHA_ENDPOINT';
        cusStg.Text_Value__c = 'https://gsb.qa.dubai.gov.ae';
        insert cusStg;
        AsyncAXSDHA obj = new AsyncAXSDHA();
        AsyncAXSDHA.UpgradePackageResponse_elementFuture inObj1 = new AsyncAXSDHA.UpgradePackageResponse_elementFuture();
        inObj1.getValue();
        AsyncAXSDHA.getApplicationStatusResponse_elementFuture inObj2 = new AsyncAXSDHA.getApplicationStatusResponse_elementFuture();
        AsyncAXSDHA.createApplicationResponse_elementFuture inObj3 = new AsyncAXSDHA.createApplicationResponse_elementFuture();
        AsyncAXSDHA.AsyncDHASalemFreeZoneToConsoleHttpsSoap11Endpoint inObj4 = new AsyncAXSDHA.AsyncDHASalemFreeZoneToConsoleHttpsSoap11Endpoint();
        AsyncAXSDHA.UpgradePackageResponse_elementFuture inObj5 = new AsyncAXSDHA.UpgradePackageResponse_elementFuture();
     Test.stopTest();
    }
}
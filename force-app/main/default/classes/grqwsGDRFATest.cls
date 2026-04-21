@isTest
private class grqwsGDRFATest {
    static testMethod void doTest() {
        Test.startTest();
            grqwsGDRFA obj = new grqwsGDRFA();
            obj.access_token ='test';
            obj.IsSuccess='test';
            obj.TargetFileNo='test';
            obj.applicationNumber='test';
            obj.statusId='test';
            obj.StatesCode='test';
            obj.applicationId='test';
            grqwsGDRFA.Documents doc = new grqwsGDRFA.Documents();
                doc.documentTypeId='test';
                doc.IsMandatory= true;
                doc.documentNameEn='test';
                doc.documentNameAr='test';
             obj.batchId='test';
            grqwsGDRFA.Fees fee = new grqwsGDRFA.Fees();
                fee.feeTypeId='test';
                fee.amount=34;
                fee.nameEn='test';
                fee.nameAr='test';
        Test.stopTest();
    }
}
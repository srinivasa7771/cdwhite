@isTest
private class BatchVatUpdtsTest {

    @IsTest
    private static  void XMLParsertest() {
        try{
            database.executeBatch(new BatchVatUpdts(12, 2018), 10);
        }catch (Exception e) {}
    }
}
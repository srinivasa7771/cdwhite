@isTest
private class Batch_Cour_upTest {
    private static testMethod void Batch_Cour_upTest() {
        new Batch_Cour_up();
          new Batch_Cour_up('6');
    }
    @IsTest
    private static  void cancelTest() {
        try{
           database.executeBatch(new Batch_Cour_up(), 1);
        }catch (Exception e) {}
    }
}
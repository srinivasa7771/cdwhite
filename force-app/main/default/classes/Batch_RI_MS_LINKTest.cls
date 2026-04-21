@isTest
public class Batch_RI_MS_LINKTest {
  private static testMethod void Batch_RI_MS_LNKTest() {
        new Batch_RI_MS_LNK();
    }

    @IsTest
    private static  void Batchtest() {
        try{
           database.executeBatch(new Batch_RI_MS_LNK(), 1);
             database.executeBatch(new Batch_RI_MS_LNK('01'), 1);
        }catch (Exception e) {}
    }
}
@isTest
private class AXSEmpostSyncSTATest {
   @IsTest
    private static  void sysnSTATest() {
        try{

           AXSEmpostSyncSTA axs=new AXSEmpostSyncSTA();
            axs.sysnSTA('14-Jul-2016', date.newInstance(2016, 07, 14), false);

            axs.respParser('');
            axs.getAXSCourierDetailsByCreatedDate(date.newInstance(2016, 07, 14));

                   }catch (Exception e) {}
    }

}
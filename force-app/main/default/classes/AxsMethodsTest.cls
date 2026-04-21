@isTest(SeeAllData=false)
public class AxsMethodsTest {
static testmethod void testUploadDoc() {
          Test.startTest();
          AxsMethods.trimAndCapitalize('Test Axs');
        AxsMethods.getUsername('test@test.com');
         Test.stopTest();
     }
}
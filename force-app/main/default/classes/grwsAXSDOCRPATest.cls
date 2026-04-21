@isTest/*(SeeAllData=true)*/
public class grwsAXSDOCRPATest {
@isTest
    static void testgrwsAXSDOCRPA() {
        try{
        Test.startTest();
        grwsAXSDOCRPA r=new grwsAXSDOCRPA();
        grwsAXSDOCRPA.loadReqDocs('32332323232323');
        grwsAXSDOCRPA.doPost();
        Test.setMock(HttpCalloutMock.class, new grwsAXSDOCRPA());
        Test.stopTest();
        }catch (Exception e) {}
    }

}
@isTest
public class PDFGeneratorWSTest {
    static testmethod void test1() {
      Test.startTest();
            PDFGeneratorWS obj = new PDFGeneratorWS();
        PDFGeneratorWS.GenerateMOAPDFResponse_element obj1 = new  PDFGeneratorWS.GenerateMOAPDFResponse_element();
        obj1.GenerateMOAPDFResult = 'tst';
      Test.stopTest();
    }
}
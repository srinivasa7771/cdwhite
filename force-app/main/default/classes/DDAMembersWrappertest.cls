/*U_S DFZC made the changes in the class*/
@isTest/*(SeeAllData=true)*/
private  class DDAMembersWrappertest {
 @testSetup static void setup() {
        testData.init();
 }
     @isTest static void testgetDDAServices() {
        Test.startTest();
         Test.setMock(WebServiceMock.class, new MockgetDDAServices());
         DDAMembersWrapper obj=new DDAMembersWrapper();
         obj.drWrp=null;
         obj.nonDrWrp=null;
         obj.srList=null;
         obj.message=null;
         obj.licenseInfos=null;
         obj.isSuccess=null;
         DDAMembersWrapper.LicenseInfos linfo=new DDAMembersWrapper.LicenseInfos();
         linfo.totalShareCapital=null;
         linfo.totalNumberOfShares=null;
         linfo.parentCompanyName=null;
         linfo.parentCompanyPermanentAddress=null;
         linfo.parentCompanyNationality=null;
         linfo.parentCompanyRegistrationNo=null;
         linfo.ManagerInChargerPerMobile=null;
         linfo.ManagerInChargerPerEmail=null;
         linfo.ManagerInChargerNationalityArabicCountry=null;
         linfo.ManagerInChargerNationality=null;
         linfo.ManagerInChargerName=null;
         linfo.ManagerInChargerFullNameArabic=null;
         linfo.licenseNo=null;
         linfo.LicenseIssueDate=null;
         linfo.LicenseFirstIssueDate=null;
         linfo.LicenseExpiryDate=null;
         linfo.LicenseeNameArabic=null;
         linfo.LicenseeName=null;
         linfo.LegalNameArabic=null;
         linfo.LegalName=null;
         linfo.LegalFrameworkName=null;
         linfo.LegalFrameworkLegalFrameworkArabic=null;
         linfo.CountryofIncorporationName=null;
         linfo.CountryofIncorporationArabicCountryName=null;
         linfo.companyDdaId=null;
         linfo.members=null;
         DDAMembersWrapper.EmiratesId_Z eida=new DDAMembersWrapper.EmiratesId_Z();
         eida.placeOfIssuance=null;
         eida.issueDate=null;
         eida.expiryDate=null;
         eida.docNo=null;
         eida.countryOfIssuance=null;
         DDAMembersWrapper.Members membinfo=new DDAMembersWrapper.Members();
         membinfo.type=null;
         membinfo.salutation=null;
         membinfo.registrationNo=null;
         membinfo.registrationDate=null;
         membinfo.proposedNumberOfShares=null;
         membinfo.positions=null;
         membinfo.placeborn=null;
         membinfo.perMobile=null;
         membinfo.perEmail=null;
         membinfo.passports =null;
         membinfo.operatingNameArabic=null;
         membinfo.operatingName=null;
         membinfo.nationality=null;
         membinfo.middleNameArabic=null;
         membinfo.middleName=null;
         membinfo.lastNameArabic=null;
         membinfo.lastName=null;
         membinfo.gender=null;
         membinfo.firstNameArabic=null;
         membinfo.firstName=null;
         membinfo.externalId=null;
         membinfo.emiratesId=null;
         membinfo.ddaId=null;
         membinfo.dateOfIncorporation=null;
         membinfo.currentNumberOfShares=null;
         membinfo.countryOfIncorporation=null;
         membinfo.cessationDate=null;
         membinfo.birthDate=null;
         membinfo.addresses=null;
         membinfo.actionType=null;
             Test.stopTest();
     }

     public class MockgetDDAServices implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
         List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
         String jsonStr = '{ "licenseNos": [ "102202" ] }';
         String responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point, 'licenseAmendment/getLicenseInfo', 'POST', jsonStr);
         DDAMembersWrapper ref = (DDAMembersWrapper) System.JSON.deserialize(responseBody, DDAMembersWrapper.class);
            response.put('response_x', responseBody);
        }
    }

}
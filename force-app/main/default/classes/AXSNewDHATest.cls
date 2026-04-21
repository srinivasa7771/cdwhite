@isTest
public class AXSNewDHATest {
   @IsTest
    private static  void coverTypesAXS() {

         List<gStg__c> lstGStg = new List<gStg__c>();
         lstGStg.add(new gStg__c(name='DHA_ENDPOINT', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
         lstGStg.add(new gStg__c(name='DHA_ENDPOINT_New', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));

       insert lstGStg;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DHAMedicalAppliactionMockImpl());
        AXSNewDHA.createApplicationResponse_element x=new AXSNewDHA.createApplicationResponse_element();
        x.applicationName=x.applicationName;
        x.applicationName_type_info=x.applicationName_type_info;
        x.apex_schema_type_info=x.apex_schema_type_info;
        x.field_order_type_info=x.field_order_type_info;

        AXSNewDHA.getApplicationStatusResponse_element r=new AXSNewDHA.getApplicationStatusResponse_element();
        r.applicationStatus=r.applicationStatus;

        AXSNewDHA.UpgradePackageResponse_element ri=new AXSNewDHA.UpgradePackageResponse_element();
        ri.ResponseCode=ri.ResponseCode;
        ri.ResponseDescription=ri.ResponseDescription;
        ri.ApplicationNumber=ri.ApplicationNumber;

        AXSNewDHA.upgradePackageFault_element ii=new AXSNewDHA.upgradePackageFault_element();
        ii.payload=ii.payload;

        AXSNewDHA.getApplicationStatusFault_element iii=new AXSNewDHA.getApplicationStatusFault_element();
        iii.payload=iii.payload;

        AXSNewDHA.createApplicationRequest_element rri=new AXSNewDHA.createApplicationRequest_element();
        rri.ResidencyNo=rri.ResidencyNo;
        rri.Name=rri.Name;
        rri.NameAr=rri.NameAr;
        rri.SponsorName=rri.SponsorName;
        rri.SponsorNameAr=rri.SponsorNameAr;
        rri.Profession=rri.Profession;
        rri.ProfessionAr=rri.ProfessionAr;
        rri.ProfessionId=rri.ProfessionId;
        rri.Nationality=rri.Nationality;
        rri.NationalityAr=rri.NationalityAr;
        rri.NationalityId=rri.NationalityId;
        rri.PassportNum=rri.PassportNum;
        rri.Photo=rri.Photo;
        rri.Gender=rri.Gender;
        rri.DOB=rri.DOB;
        rri.ClientMobile=rri.ClientMobile;
        rri.LandLine=rri.LandLine;
        rri.SponsorAddress=rri.SponsorAddress;
        rri.SponsorAddressAr=rri.SponsorAddressAr;
        rri.Mail=rri.Mail;
        rri.SponsorMobile=rri.SponsorMobile;
        rri.EmiratesIDNo=rri.EmiratesIDNo;
        rri.UIDNo=rri.UIDNo;
        rri.SponsorTypes=rri.SponsorTypes;
        rri.VisaType=rri.VisaType;
        rri.PersonType=rri.PersonType;
        rri.UrgencyCategory=rri.UrgencyCategory;
        rri.Centers=rri.Centers;
        rri.PackageType=rri.PackageType;
        rri.FzSubEntity=rri.FzSubEntity;
        rri.FreeZoneOrganization=rri.FreeZoneOrganization;

        AXSNewDHA.getApplicationStatusRequest_element rri1=new AXSNewDHA.getApplicationStatusRequest_element();
        rri1.ApplicationNumber=rri1.ApplicationNumber;
        rri1.Email=rri1.Email;
        rri1.FreeZoneOrganization=rri1.FreeZoneOrganization;

        AXSNewDHA.createApplicationFault_element rri2=new AXSNewDHA.createApplicationFault_element();
        rri2.payload=rri2.payload;

        AXSNewDHA.UpgradePackageRequest_element rri3=new AXSNewDHA.UpgradePackageRequest_element();
        rri3.ApplicationName=rri3.ApplicationName;
        rri3.UrgencyCategory=rri3.UrgencyCategory;
        rri3.FreeZoneOrganization=rri3.FreeZoneOrganization;

        AXSNewDHA.getApplicationStatusResponse_element  ele1 = new AXSNewDHA.getApplicationStatusResponse_element();
         AXSNewDHA.getApplicationStatusResponse_element  ele2 = new AXSNewDHA.getApplicationStatusResponse_element();
        AXSNewDHA.DHAFreezonesToConsolServiceHttpSoap11Endpoint cls = new AXSNewDHA.DHAFreezonesToConsolServiceHttpSoap11Endpoint();
        cls.createApplication('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '0525454568', '43911111', 'Dubai', 'دبي', '', '0525454568', '', '', '', '', '', '', '', '', '', '');

        Test.stopTest();
    }

   public class DHAMedicalAppliactionMockImpl implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
          if (requestName == 'UpgradePackageRequest') {
              AXSNewDHA.UpgradePackageRequest_element req = (AXSNewDHA.UpgradePackageRequest_element) request;
              string appNo = (string) req.ApplicationName;

             AXSNewDHA.UpgradePackageResponse_element response_x = new AXSNewDHA.UpgradePackageResponse_element();
              if (appNo == '12345')
              response_x.ResponseCode = '00';
              else
                 response_x.ResponseCode = '01';
              response.put('response_x', response_x);
         }
       else if (requestName == 'getApplicationStatusRequest') {
          AXSNewDHA.getApplicationStatusResponse_element response_x = new AXSNewDHA.getApplicationStatusResponse_element();
           response_x.applicationStatus = 'Success';
           response.put('response_x', response_x);
        }
        else{
             AXSNewDHA.createApplicationResponse_element  res = new AXSNewDHA.createApplicationResponse_element();
             res.applicationName = '12345';
             response.put('response_x', res);
        }
   }
}
}
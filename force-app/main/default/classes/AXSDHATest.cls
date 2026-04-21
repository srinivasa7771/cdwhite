@isTest
public class AXSDHATest {
   @IsTest
    private static  void coverTypesAXS() {

         List<gStg__c> lstGStg = new List<gStg__c>();
         lstGStg.add(new gStg__c(name='DHA_ENDPOINT', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
       insert lstGStg;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DHAMedicalAppliactionMockImpl());
        AXSDHA.UsernameToken a=new AXSDHA.UsernameToken();
        a.username=a.username;
        a.password=a.password;
        a.Nonce=a.Nonce;
        a.Created=a.Created;
        a.username_type_info=a.username_type_info;
        a.password_type_info=a.password_type_info;
        a.Nonce_type_info=a.Nonce_type_info;
        a.apex_schema_type_info=a.apex_schema_type_info;
        a.field_order_type_info=a.field_order_type_info;

        AXSDHA.Security b=new AXSDHA.Security();
        b.usernameToken_type_info=b.usernameToken_type_info;
        b.Timestamp_type_info=b.Timestamp_type_info;
        b.apex_schema_type_info=b.apex_schema_type_info;
        b.field_order_type_info=b.field_order_type_info;

        AXSDHA.Timestamp t=new AXSDHA.Timestamp();
        t.Created=t.Created;
        t.Expires=t.Expires;
        t.Created_type_info=t.Created_type_info;
        t.Expires_type_info=t.Expires_type_info;
        t.apex_schema_type_info=t.apex_schema_type_info;
        t.field_order_type_info=t.field_order_type_info;

        AXSDHA.faultInfo f=new AXSDHA.faultInfo();
        f.faultcode=f.faultcode;
        f.faultstring=f.faultstring;
        f.faultcode_type_info= f.faultcode_type_info;
        f.faultstring_type_info=f.faultstring_type_info;
        f.apex_schema_type_info=f.apex_schema_type_info;
        f.field_order_type_info=f.field_order_type_info;

        AXSDHA.createApplicationResponse_element x=new AXSDHA.createApplicationResponse_element();
        x.applicationName=x.applicationName;
        x.applicationName_type_info=x.applicationName_type_info;
        x.apex_schema_type_info=x.apex_schema_type_info;
        x.field_order_type_info=x.field_order_type_info;

        AXSDHA.getApplicationStatusResponse_element r=new AXSDHA.getApplicationStatusResponse_element();
        r.applicationStatus=r.applicationStatus;
        r.applicationStatus_type_info=r.applicationStatus_type_info;
        r.apex_schema_type_info=r.apex_schema_type_info;
        r.field_order_type_info=r.field_order_type_info;

        AXSDHA.UpgradePackageResponse_element ri=new AXSDHA.UpgradePackageResponse_element();
        ri.ResponseCode=ri.ResponseCode;
        ri.ResponseDescription=ri.ResponseDescription;
        ri.ApplicationNumber=ri.ApplicationNumber;
        ri.ResponseCode_type_info=ri.ResponseCode_type_info;
        ri.ResponseDescription_type_info=ri.ResponseDescription_type_info;
        ri.ApplicationNumber_type_info=ri.ApplicationNumber_type_info;
        ri.apex_schema_type_info=ri.apex_schema_type_info;
        ri.field_order_type_info=ri.field_order_type_info;

        AXSDHA.upgradePackageFault_element ii=new AXSDHA.upgradePackageFault_element();
        ii.payload=ii.payload;
        ii.payload_type_info=ii.payload_type_info;
        ii.apex_schema_type_info=ii.apex_schema_type_info;
        ii.field_order_type_info=ii.field_order_type_info;

        AXSDHA.getApplicationStatusFault_element iii=new AXSDHA.getApplicationStatusFault_element();
        iii.payload=iii.payload;
        iii.payload_type_info=iii.payload_type_info;
        iii.apex_schema_type_info=iii.apex_schema_type_info;
        iii.field_order_type_info=iii.field_order_type_info;

        AXSDHA.createApplicationRequest_element rri=new AXSDHA.createApplicationRequest_element();
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
        rri.ResidencyNo_type_info=rri.ResidencyNo_type_info;
        rri.Name_type_info=rri.Name_type_info;
        rri.NameAr_type_info=rri.NameAr_type_info;
        rri.SponsorName_type_info=rri.SponsorName_type_info;
        rri.SponsorNameAr_type_info=rri.SponsorNameAr_type_info;
        rri.Profession_type_info=rri.Profession_type_info;
        rri.ProfessionAr_type_info=rri.ProfessionAr_type_info;
        rri.ProfessionId_type_info=rri.ProfessionId_type_info;
        rri.Nationality_type_info=rri.Nationality_type_info;
        rri.NationalityAr_type_info=rri.NationalityAr_type_info;
        rri.NationalityId_type_info=rri.NationalityId_type_info;
        rri.PassportNum_type_info=rri.PassportNum_type_info;
        rri.Photo_type_info=rri.Photo_type_info;
        rri.Gender_type_info=rri.Gender_type_info;
        rri.DOB_type_info=rri.DOB_type_info;
        rri.ClientMobile_type_info=rri.ClientMobile_type_info;
        rri.LandLine_type_info=rri.LandLine_type_info;
        rri.SponsorAddress_type_info=rri.SponsorAddress_type_info;
        rri.SponsorAddressAr_type_info=rri.SponsorAddressAr_type_info;
        rri.Mail_type_info=rri.Mail_type_info;
        rri.SponsorMobile_type_info=rri.SponsorMobile_type_info;
        rri.EmiratesIDNo_type_info=rri.EmiratesIDNo_type_info;
        rri.UIDNo_type_info=rri.UIDNo_type_info;
        rri.SponsorTypes_type_info=rri.SponsorTypes_type_info;
        rri.VisaType_type_info=rri.VisaType_type_info;
        rri.PersonType_type_info=rri.PersonType_type_info;
        rri.UrgencyCategory_type_info=rri.UrgencyCategory_type_info;
        rri.Centers_type_info=rri.Centers_type_info;
        rri.PackageType_type_info=rri.PackageType_type_info;
        rri.FzSubEntity_type_info=rri.FzSubEntity_type_info;
        rri.FreeZoneOrganization_type_info=rri.FreeZoneOrganization_type_info;
        rri.apex_schema_type_info=rri.apex_schema_type_info;
        rri.field_order_type_info=rri.field_order_type_info;

        AXSDHA.getApplicationStatusRequest_element rri1=new AXSDHA.getApplicationStatusRequest_element();
        rri1.ApplicationNumber=rri1.ApplicationNumber;
        rri1.Email=rri1.Email;
        rri1.FreeZoneOrganization=rri1.FreeZoneOrganization;
        rri1.ApplicationNumber_type_info=rri1.ApplicationNumber_type_info;
        rri1.Email_type_info=rri1.Email_type_info;
        rri1.FreeZoneOrganization_type_info=rri1.FreeZoneOrganization_type_info;
        rri1.apex_schema_type_info=rri1.apex_schema_type_info;
        rri1.field_order_type_info=rri1.field_order_type_info;

        AXSDHA.createApplicationFault_element rri2=new AXSDHA.createApplicationFault_element();
        rri2.payload=rri2.payload;
        rri2.payload_type_info=rri2.payload_type_info;
        rri2.apex_schema_type_info=rri2.apex_schema_type_info;
        rri2.field_order_type_info=rri2.field_order_type_info;

        AXSDHA.UpgradePackageRequest_element rri3=new AXSDHA.UpgradePackageRequest_element();
        rri3.ApplicationName=rri3.ApplicationName;
        rri3.UrgencyCategory=rri3.UrgencyCategory;
        rri3.FreeZoneOrganization=rri3.FreeZoneOrganization;
        rri3.ApplicationName_type_info=rri3.ApplicationName_type_info;
        rri3.UrgencyCategory_type_info=rri3.UrgencyCategory_type_info;
        rri3.FreeZoneOrganization_type_info=rri3.FreeZoneOrganization_type_info;
        rri3.apex_schema_type_info=rri3.apex_schema_type_info;
        rri3.field_order_type_info=rri3.field_order_type_info;
        AXSDHA.getApplicationStatusResponse_element  ele1 = new AXSDHA.getApplicationStatusResponse_element();
         AXSDHA.getApplicationStatusResponse_element  ele2 = new AXSDHA.getApplicationStatusResponse_element();

        AXSDHA.DHASalemFreeZoneToConsoleHttpsSoap11Endpoint rri4=new AXSDHA.DHASalemFreeZoneToConsoleHttpsSoap11Endpoint();
        rri4.Header=rri4.Header;
        rri4.inputHttpHeaders_x=rri4.inputHttpHeaders_x;
        rri4.outputHttpHeaders_x=rri4.outputHttpHeaders_x;
        rri4.clientCertName_x=rri4.clientCertName_x;
        rri4.clientCert_x=rri4.clientCert_x;
        rri4.clientCertPasswd_x=rri4.clientCertPasswd_x;
        rri4.timeout_x=rri4.timeout_x;
        rri4.endpoint_x=rri4.endpoint_x;
         rri4.ns_map_type_info=rri4.ns_map_type_info;
         rri4.endpoint_x=rri4.endpoint_x;
         rri4.endpoint_x=rri4.endpoint_x;
         rri4.endpoint_x=rri4.endpoint_x;
         rri4.upgradePackage('12345', 'Urgent (24 hrs)', 'kv');
        rri4.createApplication('', '', '', '', '',  '',  '', '', '', '', '',  '', '',  '',
            '', '', '48873737', '', 'ARABIC add', 'dhatest0@gmail.com', '', '', '',  'Company (3)',
            'Renew Visa', '1', '', 'KnowledgeVillageMedicalFitnessCenter', 'All Categories Excluding HDS',
            '', 'kv');
        rri4.getApplicationStatus('12345', 'test@test.com', 'kv');
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
              AXSDHA.UpgradePackageRequest_element req = (AXSDHA.UpgradePackageRequest_element) request;
              string appNo = (string) req.ApplicationName;

             AXSDHA.UpgradePackageResponse_element response_x = new AXSDHA.UpgradePackageResponse_element();
              if (appNo == '12345')
              response_x.ResponseCode = '00';
              else
                 response_x.ResponseCode = '01';
              response.put('response_x', response_x);
         }
       else if (requestName == 'getApplicationStatusRequest') {
          AXSDHA.getApplicationStatusResponse_element response_x = new AXSDHA.getApplicationStatusResponse_element();
           response_x.applicationStatus = 'Success';
           response.put('response_x', response_x);
        }
        else{
             AXSDHA.createApplicationResponse_element  res = new AXSDHA.createApplicationResponse_element();
             res.applicationName = '12345';
             response.put('response_x', res);
        }
   }
}
}
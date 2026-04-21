/*U_S DFZC made the changes in the class*/
@isTest
private class LARequestWrapperTest {

    static testmethod void test1() {
        String json = '{"serviceRequests":[{"members":[{"visaId":"00PH1000008T4FdMAK", "salutation":"Mr.", "positions":"Manager", "placeborn":"JODHPUR", "perMobile":"+971-645645645", "perEmail":"m@a.com", "passports":[{"placeOfIssuance":"DUBAI", "issueDate":"2015-04-16", "expiryDate":"2025-04-15", "docNo":"D6112136"}], "nationality":"India", "lastName":"Vyas", "gender":"M", "firstName":"Goklendra", "emiratesId":{"issueDate":"2024-02-05", "expiryDate":"2024-02-28", "docNo":"545-3543-5435435-4"}, "EIDfId":"00PH1000008T4JTMA0", "EIDbId":"00PH1000008T4JOMA0", "birthDate":"1990-04-15", "attachmentId":"00PH1000008T3wdMAC", "addresses":[{"type":"UAE", "street":"fsdfds", "postalCode":"435435", "city":"Dubai", "buildingNo":"sfsdfds", "area":"fsdfdsf"}, {"type":"HOME", "street":"sdfdsf", "country":"India", "city":"sdfsdf"}], "actionType":"ADD"}], "isPaid":false}]}}';
        LARequestWrapper.parse(json);

        LARequestWrapper.Addresses testWrap = new LARequestWrapper.Addresses();
        testWrap.type ='test Type';
        testWrap.street = 'test Street';
        testWrap.postalCode = 'test postal';
        testWrap.phone ='0978002791';
        testWrap.mobile = '038302303';
        testWrap.homePhone = '839293749';
        testWrap.email = 'test@gmail.com';
        testWrap.city = 'test city';
        testWrap.buildingNo = '15';
        testWrap.area = 'test area';

        LARequestWrapper.Activities testWrapv1 = new LARequestWrapper.Activities();
        testWrapv1.noOfTitleAndChannels =10;
        testWrapv1.name ='test Name';
        testWrapv1.ddaId = 'test';
        testWrapv1.actionType = 'test type';

        LARequestWrapper.EmiratesId testWrapv2 = new LARequestWrapper.EmiratesId();
        //testWrapv2.issueDate = '2024-02-01 02:02:00';
        //testWrapv2.expiryDate = '2024-02-01 02:02:00';
        testWrapv2.docNo = 'test number';

        LARequestWrapper.ServiceRequests testWrapv3 = new LARequestWrapper.ServiceRequests();
        testWrapv3.serviceId ='test Id';
        testWrapv3.axsRefNo ='007382';
        testWrapv3.licenseNo = 'Z23450';
        testWrapv3.isPaid = true;

        LARequestWrapper.Locations testWrapv4 = new LARequestWrapper.Locations();
        testWrapv4.name ='test name';
        testWrapv4.leaseItemDdaId ='007382';
        testWrapv4.actionType = 'test type';

        LARequestWrapper.Passports testWrapv5 = new LARequestWrapper.Passports();
        testWrapv5.countryOfIssuance ='Dubai';
        testWrapv5.placeOfIssuance ='Dubai';
        testWrapv5.issueDate = system.today();
        testWrapv5.expiryDate = system.today();
        testWrapv5.docNo = 'SR0980';

        LARequestWrapper.CompanyInfo testWrapv6 = new LARequestWrapper.CompanyInfo();
        testWrapv6.proposedNewName3 ='test Name';
        testWrapv6.proposedNewName2 ='test New Name';
        testWrapv6.proposedNewName1 = 'test Old name';
        testWrapv6.operatingName = 'test Operation';

        LARequestWrapper.Members testWrapv7 = new LARequestWrapper.Members();
        testWrapv7.positions ='test Name';
        testWrapv7.attachmentId ='SR-0987';
        testWrapv7.EIDfId = 'test EID';
        testWrapv7.EIDbId = 'test bid';
        testWrapv7.visaId = 'test Visa Id';
        testWrapv7.phoneNo = '0989292';
        testWrapv7.perMobile = '0989292';
        testWrapv7.perEmail = 'test Email';
        testWrapv7.nationality = 'Indian';
        testWrapv7.lastName = 'test LastName';
        testWrapv7.gender = 'Male';
        testWrapv7.ddaId = 'SR0987';
        testWrapv7.birthDate = system.Today();
        testWrapv7.placeborn = 'India';
        testWrapv7.dateOfIncorporation = system.Today();
        testWrapv7.countryOfIncorporation = 'India';
        testWrapv7.operatingName = 'test Operating';
        testWrapv7.registrationNo = '098QAS5';
        testWrapv7.proposedNumberOfShares = 5;
        testWrapv7.currentNumberOfShares = 3;
        testWrapv7.registrationDate = system.Today();
        testWrapv7.cessationDate =  system.Today()-1;
        testWrapv7.actionType =  'test type';
        testWrapv7.UID =  '09876RT';
        testWrapv7.salutation = 'Mr';
        testWrapv7.middleName =  'test MiddleName';
        testWrapv7.operatingNameArabic =  'test Arabic';
        testWrapv7.firstNameArabic =  'test FirstArabic';
        testWrapv7.lastNameArabic =  'test LastArabic';
        testWrapv7.middleNameArabic =  'test MiddleArabic';

        LARequestWrapper.ChannelTitles testWrapv8 = new LARequestWrapper.ChannelTitles();
        testWrapv8.targetedAudience = 'test Audience';
        testWrapv8.requestType =  'test requestType';
        testWrapv8.printingCompany =  'test Printing';
        testWrapv8.name =  'test Name';
        testWrapv8.languages =  'Arabic';
        testWrapv8.isOnAir =  true;
        testWrapv8.isNameConfirmed =  true;
        testWrapv8.isApprovedByNMC =  true;
        testWrapv8.genre =  'test Genre';
        testWrapv8.frequency =  'test Frequency';
        testWrapv8.distributionType =  'test Type';
        testWrapv8.distributionCompany =  'test Company';
        testWrapv8.background =  'test';
        testWrapv8.areaOfDistribution =  'Dubai';
        testWrapv8.arabicName =  'Dubai';
        testWrapv8.approvalStatus =  'Pending';

    }

}
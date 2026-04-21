@isTest
private class PMSLeaseValidateCtrlTest {
 static testMethod void unitTest1() {

            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='216',
                actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
                ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
                Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
                Milestone_SLA__c='10;2;6');
            insert s;
             list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
              itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
                  slaXP__c=2, ord__c=1, Tp__c='Service Item',
                      cd__c='lc2', dcr__c ='Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;',
                  Name='rp', lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1,
                  rv__c=true, prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0,
                  scN__c=10, cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1,
                  smXP__c=1, spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
              itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
                  slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='lc3', Name='pnt',
                  lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
                  DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
                  spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
              itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
                  slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='psf', Name='pnt',
                  lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
                  DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
                  spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
             insert itms;
        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
        }
        insert sta;
        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';  a.lc__c='999999';
        update a;

        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');

          g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
          rq.activitiesFL__c = '[{"versionNumber":1, "uaeNGNumber":null, "tenantInformation":{"visaStartDt":null, "visaNo":null, "visaEndDt":null, "tenantType":"1", "poBox":"75397", "passportNo":null, "name":{"englishName":"INSIGNIA FZ-LLC", "arabicName":"إنسجنيا منطقة حرة - ذ. م. م"}, "mobileNo":"0506532369", "licenseInformation":{"licenseNumber":"30973", "licenseAuthorityInformation":{"name":{"englishName":"DUBAI DEVELOPMENT AUTHORITY", "arabicName":"DUBAI DEVELOPMENT AUTHORITY"}, "id":"47", "code":null}, "initialApprovalNumber":null}, "emiratesID":null, "email":"Gs@insigniaworldwide.com"}, "startDate":"03/06/2023", "propertyInformationList":[{"unitNumberArb":null, "unitNumber":"1810", "propertyUsageId":"2", "propertyUsage":"Commercial", "propertyTypeId":"2", "propertyType":"Office", "propertySubTypeId":"422", "propertySubType":"Office", "isMainAddr":null, "floorEN":null, "floorAR":null, "ejariBusPropertyTypeId":"2", "dewa":"383090016", "area":"104.52", "approvalRefNumber":"0620170320000667"}], "parcelID":"3830324", "makaniNumber":"16269 77181", "location":{"name":{"englishName":"Al Thanyah First", "arabicName":"الثنيه الأولى"}, "code":443}, "licenseInformation":{"licenseNumber":"30973", "licenseAuthorityInformation":{"name":{"englishName":"DUBAI DEVELOPMENT AUTHORITY", "arabicName":"DUBAI DEVELOPMENT AUTHORITY"}, "id":"47", "code":null}, "initialApprovalNumber":null}, "landNumber":"48", "landLordInformation":{"name":{"englishName":"DUBAI ISLAMIC BANK (PUBLIC JOINT STOCK COMPANY)", "arabicName":"بنك دبي الاسلامي (شركة مساهمة عامة)"}}, "geoLocation":{"longitude":"55.1779822380012", "latitude":"25.0992888370032"}, "endDate":"03/19/2024", "contractNumber":"0120230308000301", "contractAnnualAmount":140000.0, "contractAmount":140000.0, "communityInformation":{"name":null, "code":0}, "buildingName":{"englishName":"Grosvenor Business Tower", "arabicName":"جروسفينور بيزنس تاور"}, "authorityInformation":{"name":null, "id":null, "code":null}, "areaZone":{"name":{"englishName":"Dubai", "arabicName":"دبي"}, "code":2}}]';
          rq.xadtx2__c = '[{"versionNumber":1, "uaeNGNumber":null, "tenantInformation":{"visaStartDt":null, "visaNo":null, "visaEndDt":null, "tenantType":"1", "poBox":"75397", "passportNo":null, "name":{"englishName":"INSIGNIA FZ-LLC", "arabicName":"إنسجنيا منطقة حرة - ذ. م. م"}, "mobileNo":"0506532369", "licenseInformation":{"licenseNumber":"30973", "licenseAuthorityInformation":{"name":{"englishName":"DUBAI DEVELOPMENT AUTHORITY", "arabicName":"DUBAI DEVELOPMENT AUTHORITY"}, "id":"47", "code":null}, "initialApprovalNumber":null}, "emiratesID":null, "email":"Gs@insigniaworldwide.com"}, "startDate":"03/06/2023", "propertyInformationList":[{"unitNumberArb":null, "unitNumber":"1810", "propertyUsageId":"2", "propertyUsage":"Commercial", "propertyTypeId":"2", "propertyType":"Office", "propertySubTypeId":"422", "propertySubType":"Office", "isMainAddr":null, "floorEN":null, "floorAR":null, "ejariBusPropertyTypeId":"2", "dewa":"383090016", "area":"104.52", "approvalRefNumber":"0620170320000667"}], "parcelID":"3830324", "makaniNumber":"16269 77181", "location":{"name":{"englishName":"Al Thanyah First", "arabicName":"الثنيه الأولى"}, "code":443}, "licenseInformation":{"licenseNumber":"30973", "licenseAuthorityInformation":{"name":{"englishName":"DUBAI DEVELOPMENT AUTHORITY", "arabicName":"DUBAI DEVELOPMENT AUTHORITY"}, "id":"47", "code":null}, "initialApprovalNumber":null}, "landNumber":"48", "landLordInformation":{"name":{"englishName":"DUBAI ISLAMIC BANK (PUBLIC JOINT STOCK COMPANY)", "arabicName":"بنك دبي الاسلامي (شركة مساهمة عامة)"}}, "geoLocation":{"longitude":"55.1779822380012", "latitude":"25.0992888370032"}, "endDate":"03/19/2024", "contractNumber":"0120230308000301", "contractAnnualAmount":140000.0, "contractAmount":140000.0, "communityInformation":{"name":null, "code":0}, "buildingName":{"englishName":"Grosvenor Business Tower", "arabicName":"جروسفينور بيزنس تاور"}, "authorityInformation":{"name":null, "id":null, "code":null}, "areaZone":{"name":{"englishName":"Dubai", "arabicName":"دبي"}, "code":2}}]';
          rq.xadtx3__c = '{"Success":null, "Source":null, "ResponseCode":null, "Records":[{"Units":[{"UnitNumber":"509N", "UnitNoEnglish":"509N", "UnitNoArabic":"509 ان", "UnitNameArabic":null, "UnitName":"509N", "UnitArea":null, "UniqueKey":"AG-100214Premises:509NFloor:5Building:Dubai Science Park (DSP) Towers - NorthBusiness Park:DSP", "SubCategory":"Office", "SendToDCCA":"true", "FloorName":"", "FloorEnglish":"5", "FloorArabic":"5", "ContractStartDate":"21/06/2023", "ContractEnddate":"20/06/2024", "CommercialName":null, "Category":"Commercial Office", "BusinessPark":"DSP", "BuildingNameArabic":"دي اس بي تاورس نورث", "BuildingName":"Dubai Science Park (DSP) Towers - North", "AgNo":"AG-100214"}, {"UnitNumber":"509N", "UnitNoEnglish":"509N", "UnitNoArabic":"509 ان", "UnitNameArabic":null, "UnitName":"509N", "UnitArea":null, "UniqueKey":"AG-100214Premises:509NFloor:5Building:Dubai Science Park (DSP) Towers - NorthBusiness Park:DSP", "SubCategory":"Office", "SendToDCCA":"true", "FloorName":"", "FloorEnglish":"5", "FloorArabic":"5", "ContractStartDate":"21/06/2023", "ContractEnddate":"20/06/2024", "CommercialName":null, "Category":"Commercial Office", "BusinessPark":"DSP", "BuildingNameArabic":"دي اس بي تاورس نورث", "BuildingName":"Dubai Science Park (DSP) Towers - North", "AgNo":"AG-100214"}], "Type":null, "TotalSize":null, "SubCategory":null, "Status":null, "StageName":null, "RenewalOpp":null, "regOff":null, "PushToDDA":null, "Products":null, "PaymentSchedules":null, "OppArea":null, "LeaseType":null, "IsDownsize":null, "Invoices":null, "fullUnitAdd":null, "FreelancerLease":null, "ContractStatusReason":null, "ContractStatus":null, "ContractStartDate":null, "ContractNumber":null, "ContractEndDate":null, "Category":null, "BusinessPark":null, "BuildingName":null, "Building":null, "Area":null, "AgNo":"AG-100214"}, {"Units":[{"UnitNumber":null, "UnitNoEnglish":"1810", "UnitNoArabic":null, "UnitNameArabic":null, "UnitName":null, "UnitArea":null, "UniqueKey":"0120230308000301Premises:1810Floor:1Building:Grosvenor Business TowerBusiness Park:DIC", "SubCategory":null, "SendToDCCA":null, "FloorName":null, "FloorEnglish":"1", "FloorArabic":null, "ContractStartDate":"06/03/2023", "ContractEnddate":"19/03/2024", "CommercialName":null, "Category":null, "BusinessPark":"DIC", "BuildingNameArabic":null, "BuildingName":"Grosvenor Business Tower", "AgNo":"0120230308000301"}], "Type":null, "TotalSize":null, "SubCategory":null, "Status":null, "StageName":null, "RenewalOpp":null, "regOff":null, "PushToDDA":null, "Products":null, "PaymentSchedules":null, "OppArea":null, "LeaseType":null, "IsDownsize":null, "Invoices":null, "fullUnitAdd":null, "FreelancerLease":null, "ContractStatusReason":null, "ContractStatus":null, "ContractStartDate":"03/06/2023", "ContractNumber":null, "ContractEndDate":"03/19/2024", "Category":null, "BusinessPark":null, "BuildingName":null, "Building":null, "Area":null, "AgNo":"0120230308000301"}], "PartyId":null, "Error":null}';
          rq.xdccaRq__c = 'REQ-1234';
        update rq;
        gwsPMSIntegration.insertPMSOffLoc(rq);

        list < g_reqitem__c > ritms = new list < g_reqitem__c > ();
          list < g_srvcitm_Status__c > STAs = [select id, cd__c, statype__c, slaa__c, Milestone__c,
              itm__r.cd__c, Name, lbl__c, Tp__c, rqSTA__c, rc__c, slaN__c, slaXP__c, noEXP__c from g_srvcitm_Status__c where itm__r.srvc__c =: s.id and itm__r.actv__c = true and isDeleted = false];
         for (g_srvcitm__c si: [Select Id, cd__c, Stage__c, Name, lbl__c, Tp__c, xf__c, Req__c,
             rv__c, aln__c, mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c,
             smN__c, spChN__c, cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c From g_srvcitm__c where srvc__c =: s.id and(cd__c in ('psf')) and IsDeleted = false]) {
          g_reqitem__c i = new g_reqitem__c(Name = si.Name, xleatp__c= 'PMS Lease', xlesd__c=Date.today(),
              xleed__c=Date.today().AddMonths(6), itm__c = si.id, RQ__c = rq.Id, m__c = null, exp__c = false,
              rv__c = si.rv__c, vSTA__c = si.rv__c ? 'Requires Verification' : 'Verified', slaN__c = 4,
              slaXP__c = 2, DscApp__c = si.DscApp__c, KF__c = si.KF__c, cN__c = si.cN__c, cXP__c = si.cXP__c,
              smN__c = si.smN__c, smXP__c = si.smXP__c, scN__c = 0, scXP__c = 0, dtiacls__c = Datetime.now(),
              dtsc__c = Datetime.now());
           for (g_srvcitm_Status__c iSTA: STAs) {
             if (i.itm__c == iSTA.itm__c) {
                 i.STA__c = iSTA.id;
                 break;
             }
          }
         ritms.add(i);
        }
       insert ritms;
                           ws_call__c ws = new ws_call__c();
                            ws.rq_itm__c = ritms[0].id;
                            ws.ws_typ__c = 'Onboarding';
                            ws.mtd_nm__c = 'updatePMSInfo';
                            ws.intsts__c = 'Ready for Integration';
                            ws.uid__c = ritms[0].id + ''+system.now() +'PMSInfo' ;
                            ws.is_pro__c = true;
                           insert ws;
        List<g_reqitem__c> rilcList = [select id, xpreno__c, xpstp__c, xoffnoarb__c, xlesd__c,
            xplt__c, xpltar__c, xasf__c, xcasqm__c, xargno__c, xflr__c, xflrarb__c, xisma__c,
            xleed__c, xbldg__c, xbldgarb__c from g_reqitem__c where rq__c=:rq.id and itm__r.cd__c in ('lc2',
            'lc3', 'lc4', 'lc5', 'lc6', 'lc7')];
        for (g_reqitem__c ri: rilcList) {
            ri.xleatp__c = 'PMS Lease';
            ri.xlesd__c = Date.today();
            ri.xleed__c = Date.today().addMonths(9);
        }
        update rilcList;
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockApplicationProcess('lic'));
          ApexPages.CurrentPage().getParameters().put('rid', ''+rq.id);
           PMSLeaseValidateCtrl obj =new PMSLeaseValidateCtrl();
           obj.refreshEjariInfo();
        PMSLeaseValidateCtrl.UnitInfo u = new PMSLeaseValidateCtrl.UnitInfo();
        u.unitNoAr = '';u.approvalReferenceNumber = '';u.dewa = '';u.propertyTypeEn = '';u.propertyTypeAr = '';u.propertySubTypeEn = '';
        u.propertySubTypeAr = '';u.floor = '';u.usage = '';

        Test.stopTest();
    }
    public class MockApplicationProcess implements HttpCalloutMock {
        public String responseBody;
        public Integer statusCode;
        public MockApplicationProcess(String arg) {
            if (arg=='lic') {
                statusCode=200;
                responseBody = '{"TimeStamp":"2023-10-06T05:23:41.5858162+00:00", "ResponseCode":"Success", "ValidationErrorsList":[], "Response":{"ContractInformation":[{"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000299", "UnitNumber":"2", "Area":"651.97", "Dewa":"382037804", "PropertyTypeId":"1", "PropertyType":"Shop", "PropertySubTypeId":"421", "PropertySubType":"Shop", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120160809000489", "StartDate":"09/01/2022", "EndDate":"01/31/2024", "ContractAnnualAmount":1444169.8, "ContractAmount":1444169.8, "VersionNumber":6, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}, {"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000295", "UnitNumber":"2", "Area":"258.63", "Dewa":"382037766", "PropertyTypeId":"2", "PropertyType":"Office", "PropertySubTypeId":"422", "PropertySubType":"Office", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120211209004458", "StartDate":"02/01/2023", "EndDate":"01/31/2024", "ContractAnnualAmount":334080.0, "ContractAmount":334080.0, "VersionNumber":2, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}], "AdditionalData":null}}';
            } else if (arg=='contract') {
                statusCode=200;
                responseBody = '{"TimeStamp":"2023-10-06T05:26:04.8723682+00:00", "ResponseCode":"Success", "ValidationErrorsList":[], "Response":{"ContractInformation":{"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000295", "UnitNumber":"2", "Area":"258.63", "Dewa":"382037766", "PropertyTypeId":"2", "PropertyType":"Office", "PropertySubTypeId":"422", "PropertySubType":"Office", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120211209004458", "StartDate":"02/01/2023", "EndDate":"01/31/2024", "ContractAnnualAmount":334080.0, "ContractAmount":334080.0, "VersionNumber":2, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}, "AdditionalData":null}}';
            }
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if (req != null && req.getEndpoint().contains('getLeaseDetailsWithProducts') ) {
                 responseBody = '{"ResponseData":{"PartyId":"1928197", "Success":true, "Source":"D3", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Active", "AgNo":"AG-100214", "LeaseType":"Office", "Type":"New", "BusinessPark":"DSP", "ContractStartDate":"2023-06-21", "ContractEndDate":"2024-06-20", "Building":"Dubai Science Park (DSP) Towers - North", "Area":1278.43, "Category":"Commercial Office", "SubCategory":"Office", "ContractStatus":"Active", "ContractStatusReason":"Original Lease Activation", "Products":[{"LineItemName":"00450126", "ProductName":"DSP-Dubai Science Park (DSP) Towers - North-509N", "UnitNumber":"509N", "UnitArea":1278.43}, {"LineItemName":"00450127", "ProductName":"DSP-Dubai Science Park (DSP) Towers - North-509N", "UnitNumber":"509N", "UnitArea":1278.43}]}, {"ContractNumber":"0120230308000301", "Status":"Active", "ContractStartDate":"2023-03-06", "ContractEndDate":"2024-03-19", "BusinessPark":"TECOM", "BuildingName":"Grosvenor Business Tower", "TotalSize":1125.04, "Products":[{"ProductName":"1810", "UnitNumber":"1810", "UnitArea":1125.04}, {"ProductName":"1810", "UnitNumber":"0620170320000667", "UnitArea":1125.04}]}]}}';
            }
            else if (req != null && req.getEndpoint().contains('/getcontractlistbylicensenumber')) {
                responseBody = '{"TimeStamp":"2023-10-06T05:23:41.5858162+00:00", "ResponseCode":"Success", "ValidationErrorsList":[], "Response":{"ContractInformation":[{"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000299", "UnitNumber":"2", "Area":"651.97", "Dewa":"382037804", "PropertyTypeId":"1", "PropertyType":"Shop", "PropertySubTypeId":"421", "PropertySubType":"Shop", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120160809000489", "StartDate":"09/01/2022", "EndDate":"01/31/2024", "ContractAnnualAmount":1444169.8, "ContractAmount":1444169.8, "VersionNumber":6, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}, {"MakaniNumber":"15084 77630", "UAENGNumber":null, "PropertyInformationList":[{"EjariBusPropertyTypeId":"5", "ApprovalRefNumber":"0620150623000295", "UnitNumber":"2", "Area":"258.63", "Dewa":"382037766", "PropertyTypeId":"2", "PropertyType":"Office", "PropertySubTypeId":"422", "PropertySubType":"Office", "PropertyUsageId":"2", "PropertyUsage":"Commercial"}], "ContractNumber":"0120211209004458", "StartDate":"02/01/2023", "EndDate":"01/31/2024", "ContractAnnualAmount":334080.0, "ContractAmount":334080.0, "VersionNumber":2, "AreaZone":{"Code":2, "Name":{"EnglishName":"Dubai", "ArabicName":"دبي"}}, "Location":{"Code":371, "Name":{"EnglishName":"Al Safouh Second", "ArabicName":"الصفوح الثانيه"}}, "AuthorityInformation":{"Id":null, "Name":null, "Code":null}, "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}, "GeoLocation":{"Latitude":"25.1031929460032", "Longitude":"55.1661779730016"}, "CommunityInformation":{"Code":0, "Name":null}, "LandLordInformation":{"Name":{"EnglishName":"AL TAWFEEQ FOR DEVELOPMENT AND INVESTMENT L.L.C", "ArabicName":"التوفيق للتطوير والاستثمار ش.ذ.م.م"}}, "TenantInformation":{"TenantType":"1", "Name":{"EnglishName":"Fragomen FZ-LLC", "ArabicName":"فراجومين منطقة حرة-ذ.م.م"}, "EmiratesID":null, "PassportNo":null, "VisaNo":null, "VisaStartDt":null, "VisaEndDt":null, "MobileNo":"0504583541", "Email":"JeYao@Fragomen.com", "POBox":"0", "LicenseInformation":{"InitialApprovalNumber":null, "LicenseNumber":"16026", "LicenseAuthorityInformation":{"Id":"17", "Name":{"EnglishName":"TECOM", "ArabicName":"تيكوم"}, "Code":null}}}, "ParcelID":"3820849", "LandNumber":"74", "BuildingName":{"EnglishName":"DIC-EIB 04", "ArabicName":"م.د.ا-إ.أي.بي-04"}}], "AdditionalData":null}}';
            }
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }
}
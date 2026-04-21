public with sharing class MockResponseOnBoarding {

    public static MockHttpResponseHandler formMockResponse() {
        String testEndpoint1 = 'callout:DCCA_Auth/apexrest/RnLIntegrationActLoc?licenseno=1&method=getLocations';
        String getResponse1  = '{'+
        +'    "MethodName": "getLocations", '+
        +'    "locationList": [{'+
        +'        "totalArea": "662", '+
        +'        "subleaseCompany": null, '+
        +'        "SubCategory": "Office", '+
        +'        "Status": "Active", '+
        +'        "showOnLicen": false, '+
        +'        "regOffFlag": null, '+
        +'        "Recordtype": "Tecom CRM Integration", '+
        +'        "prodList": [{'+
        +'            "UnitNumber": "305", '+
        +'            "regOff": false, '+
        +'            "ProductName": "DIC-Bldg 05-305", '+
        +'            "LineItemName": "a0sA0000000UgkOIAS", '+
        +'            "floor": "3", '+
        +'            "buildingName": "5"'+
        +'        }], '+
        +'        "OfficeNo": "305", '+
        +'        "masterLocationLicense": "", '+
        +'        "LocationId": "a1i5D0000001fhGQAQ", '+
        +'        "licenseType": "Commercial License", '+
        +'        "LicenseNo": "19299", '+
        +'        "IsSubLease": "NO", '+
        +'        "IsMainAdd": false, '+
        +'        "Floor": "3", '+
        +'        "error": "", '+
        +'        "ContractStatusReason": null, '+
        +'        "ContractStartDate": "2016-09-15", '+
        +'        "ContractEnddate": "2021-09-14", '+
        +'        "Category": "Office", '+
        +'        "BusinessPark": "Dubai Internet City", '+
        +'        "BuildingName": "5", '+
        +'        "ArabicOfficeNo": "305", '+
        +'        "ArabicFloor": "3", '+
        +'        "ArabicBusinessUnit": "مدينة دبي للإنترنت", '+
        +'        "ArabicBuildingName": "5", '+
        +'        "AgreementNo": "AG-117256"'+
        +'    }, {'+
        +'        "totalArea": "0", '+
        +'        "subleaseCompany": null, '+
        +'        "SubCategory": null, '+
        +'        "Status": "Active", '+
        +'        "showOnLicen": false, '+
        +'        "regOffFlag": null, '+
        +'        "Recordtype": "Tecom CRM Integration", '+
        +'        "prodList": [{'+
        +'            "UnitNumber": "401", '+
        +'            "regOff": false, '+
        +'            "ProductName": "Building 08-401", '+
        +'            "LineItemName": "a03w000000Ekwt4AAB", '+
        +'            "floor": "4", '+
        +'            "buildingName": "089"'+
        +'        }], '+
        +'        "OfficeNo": "415", '+
        +'        "masterLocationLicense": "", '+
        +'        "LocationId": "a1i5D0000001TjAQAU", '+
        +'        "licenseType": "Commercial License", '+
        +'        "LicenseNo": "19299", '+
        +'        "IsSubLease": "NO", '+
        +'        "IsMainAdd": false, '+
        +'        "Floor": "4", '+
        +'        "error": "", '+
        +'        "ContractStatusReason": null, '+
        +'        "ContractStartDate": "2015-08-16", '+
        +'        "ContractEnddate": "2020-11-13", '+
        +'        "Category": "Office", '+
        +'        "BusinessPark": "Dubai Design District", '+
        +'        "BuildingName": "089", '+
        +'        "ArabicOfficeNo": "415", '+
        +'        "ArabicFloor": "4", '+
        +'        "ArabicBusinessUnit": "حي دبي للتصميم", '+
        +'        "ArabicBuildingName": "089", '+
        +'        "AgreementNo": "AG-6849"'+
        +'    }], '+
        +'    "LicnseNo": "19299", '+
        +'    "errorCode": "0", '+
        +'    "error": "", '+
        +'    "act": null'+
        +'}';
        String postResponse1 = '{"LicnseNo": "1", "Methodname": "getLocations"}';

        String testEndpoint2 = 'callout:D3_NC/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId=32023';
        String getResponse2 = '{'+
        +'    "ResponseData": {'+
        +'        "PartyId": "TDD-99219", '+
        +'        "Success": true, '+
        +'        "Source": "D3", '+
        +'        "Error": "", '+
        +'        "ResponseCode": "200", '+
        +'        "Records": [{'+
        +'            "ContractNumber": "0220190915002500", '+
        +'            "Status": "Active", '+
        +'            "ContractStartDate": "2023-08-04", '+
        +'            "ContractEndDate": "2024-08-03", '+
        +'            "BusinessPark": "DSC", '+
        +'            "BuildingName": "THE HIVE-B", '+
        +'            "TotalSize": 1051.31, '+
        +'            "Products": [{'+
        +'                "ProductName": "SHOP-7", '+
        +'                "UnitNumber": "NA", '+
        +'                "UnitArea": 1051.31'+
        +'            }]'+
        +'        }]'+
        +'    }'+
        +'}';

       String testEndpoint3 = 'callout:D3_NC/apexrest/pms';
       String postResponse3 = ''; //ws1.rq_jsn__c;
       String getResponse3 = '[{"type":"PMS Lease", "isSuccess":true, "Id":"23234324"}]';

         String testEndpoint4 = 'callout:' + label.CRM_Instance + '/apexrest/accinfo?accId=231314';
        String postResponse4 = ''; //ws1.rq_jsn__c;
        String getResponse4 = '{ "workorders": [ { "status": "Approved", "recType": "Brand_Approval", "recid": "0WONq0000091pxlOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }, { "status": "Pending with R&L", "recType": "License_Registration_Request", "recid": "0WONq0000091pxnOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }, { "status": "Approved", "recType": "Security_Clearance", "recid": "0WONq0000091pxmOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null } ], "usrName": "Rosalie Lalic", "skipLeaseValidations": false, "scWorkid": "0WONq0000091pxmOAA", "respMsg": "Success", "requestid": "a0EFf000001ALNZMA4", "quotes": [ { "units": [], "totalOfrPrice": 0, "totalLandQtAmt": 0, "totalDiscount": null, "totalBstRate": 0, "status": "Draft", "rqtype": "New", "requestId": "a0EFf000001ALNZMA4", "quoteNo": "00106964", "quoteName": "Quote - New - Land - 20250721", "quoteId": "0Q0Nq000001CnyrKAC", "opportunityId": "006Nq00000JLRK5IAP", "lsStDt": "2025-07-21", "lsStatus": null, "lsEndDt": "2074-07-20", "locDet": null, "agNo": "AG-117359" } ], "proposedLegalForm": "DDA", "prmPhone": "50", "prmMobile": "971552347193", "prmLastName": "Lalic", "prmFirstName": "Rosalie", "prmEmail": "rosalie.lalic@dsp.ae.invalid", "paymentSchedules": [], "oppId": "006Nq00000JLRK5IAP", "onbReqid": "a2lNq000000ovXqIAI", "nameResWorkid": "0WONq0000091pxnOAA", "members": [ { "website": null, "visitedUAE": null, "uboType": null, "uboRelatedTo": null, "uboOwnedbyUAE": null, "uboDeclaration": null, "street": null, "stockExchangeListed": null, "sourceOfwealth": [], "sh": "50", "security": null, "salutation": "Ms.", "rpNo": null, "rpExpDate": null, "role": "Member;Board of Directors;General Manager;Ultimate Beneficiary", "postalCode": null, "placeissued": "test", "pIssuedDate": null, "phoneno": null, "pExpDate": "2029-01-02", "pepRelated": [], "pepCountry": null, "pepCloselyRelatedOthers": null, "pepCloselyAssociatedOthers": null, "pepAssociation": null, "passportNo": "23470HDSHGD", "nationality": "Lebanon", "mobile": "+971-562351086", "mname": null, "mailingStreet": null, "mailingPostalCode": null, "mailingCountry": null, "mailingCity": null, "lnameAr": null, "lname": "Abou hamzeh", "legals": null, "iAuthority": null, "gender": "Female", "fnameAr": null, "fname": "Amena", "emiratesIdIssueDate": null, "email": "test@tst.com", "eid": null, "eExpDate": null, "dob": "1992-12-16", "ctgCode": null, "cshType": null, "corpORind": "Individual Shareholder", "conid": "003Nq00000eqUMVIA2", "city": null, "citizenOrResident": null, "birthplace": null, "birthCountry": null, "actingAsNomineeShareholder": null, "actingAsNomineeDirector": null }, { "website": null, "visitedUAE": null, "uboType": null, "uboRelatedTo": null, "uboOwnedbyUAE": null, "uboDeclaration": null, "street": null, "stockExchangeListed": null, "sourceOfwealth": [], "sh": "null", "security": null, "salutation": "Mr.", "rpNo": null, "rpExpDate": null, "role": null, "postalCode": null, "placeissued": null, "pIssuedDate": null, "phoneno": "+971562351086", "pExpDate": null, "pepRelated": [], "pepCountry": null, "pepCloselyRelatedOthers": null, "pepCloselyAssociatedOthers": null, "pepAssociation": null, "passportNo": null, "nationality": null, "mobile": null, "mname": null, "mailingStreet": null, "mailingPostalCode": null, "mailingCountry": null, "mailingCity": null, "lnameAr": null, "lname": "Ahmed", "legals": null, "iAuthority": null, "gender": null, "fnameAr": null, "fname": "Neyyar", "emiratesIdIssueDate": null, "email": "test@test.com", "eid": null, "eExpDate": null, "dob": null, "ctgCode": null, "cshType": null, "corpORind": null, "conid": "003Nq00000eqN6LIAU", "city": null, "citizenOrResident": null, "birthplace": null, "birthCountry": null, "actingAsNomineeShareholder": null, "actingAsNomineeDirector": null } ], "lrWorkid": null, "licenseType": "DDA", "legalFramework": "DDA", "lcExpdate": null, "isSuccess": true, "Invoices": [], "hseWorkid": null, "gvtRlsWorkId": null, "documents": [ { "name": "Signed Article of Association", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Signed Article of Association", "ddaDocId": "a3eFV0000002bUwYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJuMAI" }, { "name": "General Declaration and Undertaking Form", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "General Declaration and Undertaking Form", "ddaDocId": "a3eFV0000002bUxYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJvMAI" }, { "name": "Resolution for the Incorporation of an FZ-LLC", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Resolution for the Incorporation of an FZ-LLC", "ddaDocId": "a3eFV0000002bUyYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJwMAI" }, { "name": "NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Ho", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Hotel - Five Star", "ddaDocId": "a3eFV0000002bWXYAY", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcWnMAI" }, { "name": "Valid Passport Copy - Amena Abou hamzeh", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Valid Passport Copy - Amena Abou hamzeh", "ddaDocId": "a3eFV0000002bWYYAY", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcWoMAI" } ], "DDAReqNo": null, "crmAccName": "Testing Analogies FZ-LLC", "crmAccId": "001Nq00000gkuE4IAI", "caseid": null, "businessPark": "DDA", "brandWorkid": "0WONq0000091pxlOAA", "actvities": [ { "title": null, "segment": "Hotels and Leisure Services", "name": "Hotel - Five Star", "channel": null, "actId": "a0L2R00000KCyWQUA1" } ], "accStatus": null }';

        String testEndpoint7 = 'callout:' + label.CRM_Instance + '/apexrest/onboarding/';
        String postResponse7 = ''; //ws1.rq_jsn__c;
        String getResponse7 = '{ "workorders": [ { "status": "Approved", "recType": "Brand_Approval", "recid": "0WONq0000091pxlOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }, { "status": "Pending with R&L", "recType": "License_Registration_Request", "recid": "0WONq0000091pxnOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }, { "status": "Approved", "recType": "Security_Clearance", "recid": "0WONq0000091pxmOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null } ], "usrName": "Rosalie Lalic", "skipLeaseValidations": false, "scWorkid": "0WONq0000091pxmOAA", "respMsg": "Success", "requestid": "a0EFf000001ALNZMA4", "quotes": [ { "units": [], "totalOfrPrice": 0, "totalLandQtAmt": 0, "totalDiscount": null, "totalBstRate": 0, "status": "Draft", "rqtype": "New", "requestId": "a0EFf000001ALNZMA4", "quoteNo": "00106964", "quoteName": "Quote - New - Land - 20250721", "quoteId": "0Q0Nq000001CnyrKAC", "opportunityId": "006Nq00000JLRK5IAP", "lsStDt": "2025-07-21", "lsStatus": null, "lsEndDt": "2074-07-20", "locDet": null, "agNo": "AG-117359" } ], "proposedLegalForm": "DDA", "prmPhone": "50", "prmMobile": "971552347193", "prmLastName": "Lalic", "prmFirstName": "Rosalie", "prmEmail": "rosalie.lalic@dsp.ae.invalid", "paymentSchedules": [], "oppId": "006Nq00000JLRK5IAP", "onbReqid": "a2lNq000000ovXqIAI", "nameResWorkid": "0WONq0000091pxnOAA", "members": [ { "website": null, "visitedUAE": null, "uboType": null, "uboRelatedTo": null, "uboOwnedbyUAE": null, "uboDeclaration": null, "street": null, "stockExchangeListed": null, "sourceOfwealth": [], "sh": "50", "security": null, "salutation": "Ms.", "rpNo": null, "rpExpDate": null, "role": "Member;Board of Directors;General Manager;Ultimate Beneficiary", "postalCode": null, "placeissued": "test", "pIssuedDate": null, "phoneno": null, "pExpDate": "2029-01-02", "pepRelated": [], "pepCountry": null, "pepCloselyRelatedOthers": null, "pepCloselyAssociatedOthers": null, "pepAssociation": null, "passportNo": "23470HDSHGD", "nationality": "Lebanon", "mobile": "+971-562351086", "mname": null, "mailingStreet": null, "mailingPostalCode": null, "mailingCountry": null, "mailingCity": null, "lnameAr": null, "lname": "Abou hamzeh", "legals": null, "iAuthority": null, "gender": "Female", "fnameAr": null, "fname": "Amena", "emiratesIdIssueDate": null, "email": "test@tst.com", "eid": null, "eExpDate": null, "dob": "1992-12-16", "ctgCode": null, "cshType": null, "corpORind": "Individual Shareholder", "conid": "003Nq00000eqUMVIA2", "city": null, "citizenOrResident": null, "birthplace": null, "birthCountry": null, "actingAsNomineeShareholder": null, "actingAsNomineeDirector": null }, { "website": null, "visitedUAE": null, "uboType": null, "uboRelatedTo": null, "uboOwnedbyUAE": null, "uboDeclaration": null, "street": null, "stockExchangeListed": null, "sourceOfwealth": [], "sh": "null", "security": null, "salutation": "Mr.", "rpNo": null, "rpExpDate": null, "role": null, "postalCode": null, "placeissued": null, "pIssuedDate": null, "phoneno": "+971562351086", "pExpDate": null, "pepRelated": [], "pepCountry": null, "pepCloselyRelatedOthers": null, "pepCloselyAssociatedOthers": null, "pepAssociation": null, "passportNo": null, "nationality": null, "mobile": null, "mname": null, "mailingStreet": null, "mailingPostalCode": null, "mailingCountry": null, "mailingCity": null, "lnameAr": null, "lname": "Ahmed", "legals": null, "iAuthority": null, "gender": null, "fnameAr": null, "fname": "Neyyar", "emiratesIdIssueDate": null, "email": "test@test.com", "eid": null, "eExpDate": null, "dob": null, "ctgCode": null, "cshType": null, "corpORind": null, "conid": "003Nq00000eqN6LIAU", "city": null, "citizenOrResident": null, "birthplace": null, "birthCountry": null, "actingAsNomineeShareholder": null, "actingAsNomineeDirector": null } ], "lrWorkid": null, "licenseType": "DDA", "legalFramework": "DDA", "lcExpdate": null, "isSuccess": true, "Invoices": [], "hseWorkid": null, "gvtRlsWorkId": null, "documents": [ { "name": "Signed Article of Association", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Signed Article of Association", "ddaDocId": "a3eFV0000002bUwYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJuMAI" }, { "name": "General Declaration and Undertaking Form", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "General Declaration and Undertaking Form", "ddaDocId": "a3eFV0000002bUxYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJvMAI" }, { "name": "Resolution for the Incorporation of an FZ-LLC", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Resolution for the Incorporation of an FZ-LLC", "ddaDocId": "a3eFV0000002bUyYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJwMAI" }, { "name": "NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Ho", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Hotel - Five Star", "ddaDocId": "a3eFV0000002bWXYAY", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcWnMAI" }, { "name": "Valid Passport Copy - Amena Abou hamzeh", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Valid Passport Copy - Amena Abou hamzeh", "ddaDocId": "a3eFV0000002bWYYAY", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcWoMAI" } ], "DDAReqNo": null, "crmAccName": "Testing Analogies FZ-LLC", "crmAccId": "001Nq00000gkuE4IAI", "caseid": null, "businessPark": "DDA", "brandWorkid": "0WONq0000091pxlOAA", "actvities": [ { "title": null, "segment": "Hotels and Leisure Services", "name": "Hotel - Five Star", "channel": null, "actId": "a0L2R00000KCyWQUA1" } ], "accStatus": null }';

        String testEndpoint5 = 'callout:DCCA_Auth/apexrest/shareNewLicData';
        String postResponse5 = ''; //ws1.rq_jsn__c;
        String getResponse5 = '{"Data":[{"status":"Pending with R&L", "sme":null, "shareHldType":"Individual", "sancs":[], "name":"REQ-00351186", "mangerNameA":"", "mangerName":"", "managerNationA":"", "managerNation":"", "locAmd":false, "lines":[{"segment":"Hotels and Leisure Services", "lineName":"Hotels and Leisure Services - Hotel - Five Star", "amount":45000, "activity":"Hotel - Five Star"}, {"segment":null, "lineName":"Registration Fees", "amount":3500, "activity":null}, {"segment":null, "lineName":"Knowledge Dirham", "amount":10, "activity":null}, {"segment":null, "lineName":"Innovation Dirham", "amount":10, "activity":null}, {"segment":null, "lineName":"Knowledge Dirham", "amount":10, "activity":null}, {"segment":null, "lineName":"Innovation Dirham", "amount":10, "activity":null}], "lincenseeeng":"Testing Analogies FZ-LLC", "lincenseearabic":"اختبار القياسات", "licType":"Commercial License", "licNo":null, "legaleng":"Testing Analogies FZ-LLC", "legalarabic":"اختبار القياسات", "leaseType":null, "isUniv":false, "isUBOSubmitted":false, "isUBORequired":false, "isRenewalAllowed":false, "isAMLCompleted":true, "idRec":"a1CFV000001L7172AC", "frameworkeng":"Free Zone Limited Liability Company", "frameworkarabic":"شركة منطقة حرة ذات مسؤولية محدودة", "expDate":null, "errorMessage":null, "errorCode":null, "docs":[{"shareHolderName":null, "name":"Franchise agreement", "isRequired":false, "id":null, "category":null}, {"shareHolderName":null, "name":"Signed Article of Association", "isRequired":true, "id":null, "category":null}, {"shareHolderName":null, "name":"General Declaration and Undertaking Form", "isRequired":true, "id":null, "category":null}, {"shareHolderName":null, "name":"Resolution for the Incorporation of an FZ-LLC", "isRequired":true, "id":null, "category":null}, {"shareHolderName":null, "name":"NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Hotel - Five Star", "isRequired":true, "id":null, "category":null}, {"shareHolderName":null, "name":"Valid Passport Copy - Amena Abou hamzeh", "isRequired":true, "id":null, "category":null}, {"shareHolderName":null, "name":"Declaration of Appointment as General Manager - Amena Abou hamzeh", "isRequired":false, "id":null, "category":null}], "businessPark":"Dubai Science Park", "buRecomendation":false, "amount":48540, "actspeNotes":null, "activities":[{"segment":"Hotels and Leisure Services", "lineName":"Hotel - Five Star", "amount":0, "activity":"Hotel - Five Star"}]}]}';

      /*  String testEndpoint8 = 'callout:D3_NC/apexrest/accinfo';
        String postResponse8 = ''; //ws1.rq_jsn__c;
        String getResponse8 = '{"workorders":[{"status":"Approved", "recType":"Brand_Approval", "recid":"0WONq0000091pxlOAA", "parentid":null, "members":null, "ddaRequestId":null}, {"status":"Name Approved", "recType":"License_Registration_Request", "recid":"0WONq0000091pxnOAA", "parentid":null, "members":null, "ddaRequestId":null}, {"status":"Approved", "recType":"Security_Clearance", "recid":"0WONq0000091pxmOAA", "parentid":null, "members":null, "ddaRequestId":null}], "usrName":"Rosalie Lalic", "tdLcStdt":null, "tdLcEddt":null, "taxRgNo":null, "SubCategory":null, "StageName":null, "skipLeaseValidations":"false", "shareHoldersType":null, "shareDetails":null, "shareCapital":null, "secofceml":null, "secMobile":null, "seccode":null, "scWorkid":"0WONq0000091pxmOAA", "respMsg":"Success", "requestid":"a0EFf000001ALNZMA4", "quotes":[{"units":[{"status":"Soft Booked", "productName":"DSP-Dubai Science Park Land Lease Property-990512", "name":"990512", "isActive":true, "floor":null, "buildingName":"Dubai Science Park Land Lease Property", "area":182500.00}], "totalOfrPrice":3066000, "totalLandQtAmt":70518000.00, "totalDiscount":20.94, "totalBstRate":7756250.00, "status":"Approved", "rqtype":"New", "requestId":"a0EFf000001ALNZMA4", "quoteNo":"00106963", "quoteName":"Quote - New - Land - 20250718", "quoteId":"0Q0Nq000001C9a1KAC", "productName":null, "paymentSchedules":null, "opportunityId":"006Nq00000JLRK5IAP", "lsStDt":"2025-07-01", "lsStatus":null, "lsEndDt":"2074-06-30", "locDet":null, "AgNo":"AG-117359"}], "proposedLegalForm":"DDA", "profceml":null, "Products":null, "productName":null, "productCategory":null, "prmPhone":"50", "prMobile":null, "prmMobile":"971552347193", "prmLastName":"Lalic", "prmFirstName":"Rosalie", "prmEmail":"rosalie.lalic@dsp.ae.invalid", "prmccode":null, "pcRegNo":null, "pcDOI":null, "paymentSchedules":null, "parentCompany":null, "oppId":"006Nq00000JLRK5IAP", "onbReqid":"a2lNq000000ovXqIAI", "ofcPhone":null, "ofcEmail":null, "ofcCountry":null, "ofcAddress":null, "noofShares":null, "nationality":null, "nameResWorkid":"0WONq0000091pxnOAA", "members":[{"website":null, "visitedUAE":null, "uboType":null, "uboRelatedTo":null, "uboOwnedbyUAE":null, "uboException":null, "uboDeclaration":null, "street":null, "stockExchangeListed":null, "sourceOfwealth":[], "sh":"50", "security":null, "salutation":"Ms.", "rRegNum":null, "rpNo":null, "rpExpDate":null, "role":"Member;Board of Directors;General Manager;Ultimate Beneficiary", "postalCode":null, "placeissued":"test", "placeborn":null, "pIssuedDate":null, "phoneno":null, "pExpDate":"2029-01-02", "pepRelated":[], "pepCountry":null, "pepCloselyRelatedOthers":null, "pepCloselyAssociatedOthers":null, "pepAssociation":null, "passportNo":"23470HDSHGD", "passportId":null, "nationality":"Lebanon", "mobile":"+971-562351086", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"Abou hamzeh", "legals":null, "isParentComp":null, "inUAE":null, "iAuthority":null, "gender":"Female", "fullName":null, "fnameAr":null, "fname":"Amena", "fda":null, "emiratesIdIssueDate":null, "emirate":null, "email":"test@tst.com", "eidExp":null, "eid":null, "eExpDate":null, "dob":"1992-12-16", "ctgCode1":null, "ctgCode":null, "ctg":null, "cshType":null, "country":null, "corpORind":"Individual Shareholder", "contryCode":null, "conid":"003Nq00000eqUMVIA2", "cityIn":null, "city":null, "citizenOrResident":null, "birthplace":null, "birthCountry":null, "Area":null, "address":null, "actingAsNomineeShareholder":null, "actingAsNomineeDirector":null}, {"website":null, "visitedUAE":null, "uboType":null, "uboRelatedTo":null, "uboOwnedbyUAE":null, "uboException":null, "uboDeclaration":null, "street":null, "stockExchangeListed":null, "sourceOfwealth":[], "sh":"null", "security":null, "salutation":"Mr.", "rRegNum":null, "rpNo":null, "rpExpDate":null, "role":null, "postalCode":null, "placeissued":null, "placeborn":null, "pIssuedDate":null, "phoneno":"+971562351086", "pExpDate":null, "pepRelated":[], "pepCountry":null, "pepCloselyRelatedOthers":null, "pepCloselyAssociatedOthers":null, "pepAssociation":null, "passportNo":null, "passportId":null, "nationality":null, "mobile":null, "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"Ahmed", "legals":null, "isParentComp":null, "inUAE":null, "iAuthority":null, "gender":null, "fullName":null, "fnameAr":null, "fname":"Neyyar", "fda":null, "emiratesIdIssueDate":null, "emirate":null, "email":"khaja.rafeeq-v@dham.ae", "eidExp":null, "eid":null, "eExpDate":null, "dob":null, "ctgCode1":null, "ctgCode":null, "ctg":null, "cshType":null, "country":null, "corpORind":null, "contryCode":null, "conid":"003Nq00000eqN6LIAU", "cityIn":null, "city":null, "citizenOrResident":null, "birthplace":null, "birthCountry":null, "Area":null, "address":null, "actingAsNomineeShareholder":null, "actingAsNomineeDirector":null}], "licenseType":"DDA", "lcExpdate":null, "issuingAuthority":null, "isSuccess":true, "Invoices":[], "hseWorkid":null, "gvtRlsWorkId":null, "fullNameAr":null, "fullName":null, "documents":[{"name":"Signed Article of Association", "isFileAttached":false, "isCallforReview":false, "gracePeriod":false, "description":"Signed Article of Association", "ddaDocId":"a3eFV0000002bUwYAI", "ccrmParentId":"0WONq0000091pxnOAA", "ccrmDocId":"a0HNq000004xcJuMAI"}, {"name":"General Declaration and Undertaking Form", "isFileAttached":false, "isCallforReview":false, "gracePeriod":false, "description":"General Declaration and Undertaking Form", "ddaDocId":"a3eFV0000002bUxYAI", "ccrmParentId":"0WONq0000091pxnOAA", "ccrmDocId":"a0HNq000004xcJvMAI"}, {"name":"Resolution for the Incorporation of an FZ-LLC", "isFileAttached":false, "isCallforReview":false, "gracePeriod":false, "description":"Resolution for the Incorporation of an FZ-LLC", "ddaDocId":"a3eFV0000002bUyYAI", "ccrmParentId":"0WONq0000091pxnOAA", "ccrmDocId":"a0HNq000004xcJwMAI"}, {"name":"NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Ho", "isFileAttached":false, "isCallforReview":false, "gracePeriod":false, "description":"NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Hotel - Five Star", "ddaDocId":"a3eFV0000002bWXYAY", "ccrmParentId":"0WONq0000091pxnOAA", "ccrmDocId":"a0HNq000004xcWnMAI"}, {"name":"Valid Passport Copy - Amena Abou hamzeh", "isFileAttached":true, "isCallforReview":false, "gracePeriod":false, "description":"Valid Passport Copy - Amena Abou hamzeh", "ddaDocId":"a3eFV0000002bWYYAY", "ccrmParentId":"0WONq0000091pxnOAA", "ccrmDocId":"a0HNq000004xcWoMAI"}], "dedLicense":null, "dedLeaseType":null, "dedCompanyName":null, "dedActivities":null, "DDAReqNo":null, "currentpgid":null, "crmOppId":null, "crmAccName":"Testing Analogies FZ-LLC", "crmAccId":"001Nq00000gkuE4IAI", "countryOfIncorp":null, "ContractStatusReason":null, "ContractStatus":null, "ContractStartDate":null, "ContractEndDate":null, "conEmail":null, "compName":null, "Category":null, "caseid":null, "BusinessPark":"DDA", "businessName3":null, "businessName2":null, "businessName1":null, "brandWorkid":"0WONq0000091pxlOAA", "AgNo":null, "addstreet":null, "addState":null, "addPO":null, "adcity":null, "actvities":[{"vatAmount":null, "totalPrice":null, "title":null, "term":null, "tenantCode":null, "segment":"Hotels and Leisure Services", "propertyCode":null, "price":null, "name":"Hotel - Five Star", "docs":null, "description":null, "chargeTo":null, "chargeFrom":null, "chargeCode":null, "channel":null, "actId":"a0L2R00000KCyWQUA1"}], "accStatus":null, "accDesc":null}';
*/

         String testEndpoint9 = 'callout:DCCA_Auth/apexrest/shareNewLicData';
         String postResponse9 = '';
         String getResponse9 =  '{"Data":[{"status":null, "sme":null, "shareHldType":null, "sancs":[], "name":null, "mangerNameA":null, "mangerName":null, "managerNationA":null, "managerNation":null, "locAmd":false, "lines":[], "lincenseeeng":null, "lincenseearabic":null, "licType":null, "licNo":null, "legaleng":null, "legalarabic":null, "leaseType":null, "isUniv":false, "isUBOSubmitted":false, "isUBORequired":false, "isRenewalAllowed":false, "isAMLCompleted":false, "idRec":null, "frameworkeng":null, "frameworkarabic":null, "expDate":null, "errorMessage":"There is valid request", "errorCode":"1", "docs":[], "businessPark":null, "buRecomendation":false, "amount":null, "actspeNotes":null, "activities":[]}]}';

        String testEndpoint10 = 'callout:D3_NC/apexrest/accinfo';
        String postResponse10 = ''; //ws1.rq_jsn__c;
        String getResponse10 = '{ "workorders": [{ "status": "Approved", "recType": "Brand_Approval", "recid": "0WONq0000091pxlOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }, { "status": "Pending with R&L", "recType": "License_Registration_Request", "recid": "0WONq0000091pxnOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }, { "status": "Approved", "recType": "Security_Clearance", "recid": "0WONq0000091pxmOAA", "parentid": null, "members": null, "ddaRQNo": null, "ddaRQId": null }], "usrName": "Rosalie Lalic", "skipLeaseValidations": false, "scWorkid": "0WONq0000091pxmOAA", "respMsg": "Success", "requestid": "a0EFf000001ALNZMA4", "quotes": [{ "units": [], "totalOfrPrice": 0, "totalLandQtAmt": 0, "totalDiscount": null, "totalBstRate": 0, "status": "Draft", "rqtype": "New", "requestId": "a0EFf000001ALNZMA4", "quoteNo": "00106964", "quoteName": "Quote - New - Land - 20250721", "quoteId": "0Q0Nq000001CnyrKAC", "opportunityId": "006Nq00000JLRK5IAP", "lsStDt": "2025-07-21", "lsStatus": null, "lsEndDt": "2074-07-20", "locDet": null, "agNo": "AG-117359" }], "proposedLegalForm": "DDA", "prmPhone": "50", "prmMobile": "971552347193", "prmLastName": "Lalic", "prmFirstName": "Rosalie", "prmEmail": "rosalie.lalic@dsp.ae.invalid", "paymentSchedules": [], "oppId": "006Nq00000JLRK5IAP", "onbReqid": "a2lNq000000ovXqIAI", "nameResWorkid": "0WONq0000091pxnOAA", "members": [{ "website": null, "visitedUAE": null, "uboType": null, "uboRelatedTo": null, "uboOwnedbyUAE": null, "uboDeclaration": null, "street": null, "stockExchangeListed": null, "sourceOfwealth": [], "sh": "50", "security": null, "salutation": "Ms.", "rpNo": null, "rpExpDate": null, "role": "Member;Board of Directors;General Manager;Ultimate Beneficiary", "postalCode": null, "placeissued": "test", "pIssuedDate": null, "phoneno": null, "pExpDate": "2029-01-02", "pepRelated": [], "pepCountry": null, "pepCloselyRelatedOthers": null, "pepCloselyAssociatedOthers": null, "pepAssociation": null, "passportNo": "23470HDSHGD", "nationality": "Lebanon", "mobile": "+971-562351086", "mname": null, "mailingStreet": null, "mailingPostalCode": null, "mailingCountry": null, "mailingCity": null, "lnameAr": null, "lname": "Abou hamzeh", "legals": null, "iAuthority": null, "gender": "Female", "fnameAr": null, "fname": "Amena", "emiratesIdIssueDate": null, "email": "test@tst.com", "eid": null, "eExpDate": null, "dob": "1992-12-16", "ctgCode": null, "cshType": null, "corpORind": "Individual Shareholder", "conid": "003Nq00000eqUMVIA2", "city": null, "citizenOrResident": null, "birthplace": null, "birthCountry": null, "actingAsNomineeShareholder": null, "actingAsNomineeDirector": null }, { "website": null, "visitedUAE": null, "uboType": null, "uboRelatedTo": null, "uboOwnedbyUAE": null, "uboDeclaration": null, "street": null, "stockExchangeListed": null, "sourceOfwealth": [], "sh": "null", "security": null, "salutation": "Mr.", "rpNo": null, "rpExpDate": null, "role": null, "postalCode": null, "placeissued": null, "pIssuedDate": null, "phoneno": "+971562351086", "pExpDate": null, "pepRelated": [], "pepCountry": null, "pepCloselyRelatedOthers": null, "pepCloselyAssociatedOthers": null, "pepAssociation": null, "passportNo": null, "nationality": null, "mobile": null, "mname": null, "mailingStreet": null, "mailingPostalCode": null, "mailingCountry": null, "mailingCity": null, "lnameAr": null, "lname": "Ahmed", "legals": null, "iAuthority": null, "gender": null, "fnameAr": null, "fname": "Neyyar", "emiratesIdIssueDate": null, "email": "test@test.com", "eid": null, "eExpDate": null, "dob": null, "ctgCode": null, "cshType": null, "corpORind": null, "conid": "003Nq00000eqN6LIAU", "city": null, "citizenOrResident": null, "birthplace": null, "birthCountry": null, "actingAsNomineeShareholder": null, "actingAsNomineeDirector": null }], "lrWorkid": null, "licenseType": "DDA", "legalFramework": "DDA", "lcExpdate": null, "isSuccess": true, "Invoices": [], "hseWorkid": null, "gvtRlsWorkId": null, "documents": [{ "name": "Signed Article of Association", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Signed Article of Association", "ddaDocId": "a3eFV0000002bUwYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJuMAI" }, { "name": "General Declaration and Undertaking Form", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "General Declaration and Undertaking Form", "ddaDocId": "a3eFV0000002bUxYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJvMAI" }, { "name": "Resolution for the Incorporation of an FZ-LLC", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "Resolution for the Incorporation of an FZ-LLC", "ddaDocId": "a3eFV0000002bUyYAI", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcJwMAI" }, { "name": "NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Ho", "isFileAttached": true, "isCallforReview": false, "gracePeriod": false, "description": "NOC from Dubai Tourism and Commercial Marketing-Hotels and Leisure Services - Hotel - Five Star", "ddaDocId": "a3eFV0000002bWXYAY", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcWnMAI" }, { "name": "Valid Passport Copy - Amena Abou hamzeh", "isFileAttached": false, "isCallforReview": false, "gracePeriod": false, "description": "Valid Passport Copy - Amena Abou hamzeh", "ddaDocId": "a3eFV0000002bWYYAY", "ccrmParentId": "0WONq0000091pxnOAA", "ccrmDocId": "a0HNq000004xcWoMAI" }], "DDAReqNo": null, "crmAccName": "Testing Analogies FZ-LLC", "crmAccId": "001Nq00000gkuE4IAI", "caseid": null, "businessPark": "DDA", "brandWorkid": "0WONq0000091pxlOAA", "actvities": [{ "title": null, "segment": "Hotels and Leisure Services", "name": "Hotel - Five Star", "channel": null, "actId": "a0L2R00000KCyWQUA1" }], "accStatus": null }';

        MockHttpResponseHandler mock = new MockHttpResponseHandler();
        mock.ignoreQuery = false;

        //successful POST which return data in body.  Can change contentType
        MockHttpResponseHandler.SimpleMockResponse postResp1 = new MockHttpResponseHandler.SimpleMockResponse('POST', getResponse1);
        system.debug('postResp1==='+postResp1);
        postResp1.body = getResponse1;

        system.debug('postResp1=1=='+postResp1);
        //successful GET which return data in body
        MockHttpResponseHandler.SimpleMockResponse getResp2 = new MockHttpResponseHandler.SimpleMockResponse('GET', getResponse2);
        system.debug('getResp2==='+getResp2);

        //successful POST which return data in body.  Can change contentType
        MockHttpResponseHandler.SimpleMockResponse postResp3 = new MockHttpResponseHandler.SimpleMockResponse('POST', getResponse3);
        system.debug('postResp3==='+postResp3);
        postResp3.body = getResponse3;
       system.debug('postResp3=1=='+postResp3);

        MockHttpResponseHandler.SimpleMockResponse postResp4 = new MockHttpResponseHandler.SimpleMockResponse('GET', getResponse4);
        system.debug('postResp4==='+postResp4);

         MockHttpResponseHandler.SimpleMockResponse postResp5 = new MockHttpResponseHandler.SimpleMockResponse('POST', getResponse5);
        system.debug('postResp5==='+postResp5);

         MockHttpResponseHandler.SimpleMockResponse postResp7 = new MockHttpResponseHandler.SimpleMockResponse('POST', getResponse7);
        system.debug('postResp7==='+postResp7);

       //  MockHttpResponseHandler.SimpleMockResponse postResp8 = new MockHttpResponseHandler.SimpleMockResponse('GET', getResponse8);
       //  system.debug('postResp9==='+postResp8);

        MockHttpResponseHandler.SimpleMockResponse postResp9 = new MockHttpResponseHandler.SimpleMockResponse('POST', getResponse9);
         system.debug('postResp9==='+postResp9);

         MockHttpResponseHandler.SimpleMockResponse postResp10 = new MockHttpResponseHandler.SimpleMockResponse('GET', getResponse10);
         system.debug('postResp10==='+postResp10);

        mock.addResponse(testEndpoint1, postResp1);
        mock.addResponse(testEndpoint2, getResp2);
        mock.addResponse(testEndpoint3, postResp3);
        mock.addResponse(testEndpoint4, postResp4);
        mock.addResponse(testEndpoint5, postResp5);
        mock.addResponse(testEndpoint7, postResp7);
      //  mock.addResponse(testEndpoint8, postResp8);
        mock.addResponse(testEndpoint9, postResp9);
        mock.addResponse(testEndpoint10, postResp10);

        return mock;
    }
}
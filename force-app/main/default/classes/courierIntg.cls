@RestResource(urlMapping='/courierservices/*')
global class courierIntg {

    @HttpPost
    global static void createReq() {
        System.debug('reqBody : ' + RestContext.request.requestBody.toString());
        courierResp resp = new courierResp();
        RestContext.response.addHeader('Content-Type', 'application/json');

        try{
            CourierService cs = (CourierService)JSON.deserialize(RestContext.request.requestBody.toString(), courierIntg.CourierService.class);
            System.debug('CourierService : ' + cs);

            if (String.isBlank(cs.oracleID)) {
                resp.respCode = 'VE_01';
                resp.respMsg = '#ValidationError, Oracle ID cannot be blank.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            List<Account> lstAcc = [SELECT Id, Name, ORACLE_PARTY_ID__c From Account WHERE ORACLE_PARTY_ID__c=:cs.oracleID];

            if (lstAcc == null || lstAcc.size()==0) {
                resp.respCode = 'DE_01';
                resp.respMsg = '#DataError, Account with Oracle ID {' + cs.oracleID + '} not found.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            g_req__c rq    = new g_req__c(ias__c='ldd', srvc__c=gu.csStr('LDD_SrvcID'), STA__c='In Process', acc__c=lstAcc[0].Id,
                                      rmob__c=cs.refMobile.replace(' ', ''), xbrnd__c=cs.deliveryZone, xbn__c=getMappedBldg(cs.buildName), xaloc__c=cs.deliveryLoc,
                                      xanum__c=cs.agNum, xdcmt__c=cs.docType, xchn__c=cs.conName, nt__c=cs.notes, rtacn__c=cs.tcode);

            if (Schema.sObjectType.g_req__c.isCreateable()) {
                insert rq;
            }

            //toDo : handle NPE
            rq = [SELECT Id, Name, xawb__c, xanum__c, Zone__c, rmob__c, xaloc__c, Full_Name__c, Acc__r.Name, xbn__c, xbrnd__c, CreatedBy.Name FROM g_req__c WHERE id=:rq.ID LIMIT 1];

            /***
             List<g_reqitem__c> itm = [SELECT id, name, sta__r.cd__c, sta__r.Courier_Stage__c, xcub__c, xcasc__c, exp__c from g_reqitem__c where rq__c=:rq.Id LIMIT 1];

            XMLParserforEmpostWebservice pe = new XMLParserforEmpostWebservice();
            pe.createdon=Datetime.now();
            pe.uid=itm[0].id+itm[0].sta__r.cd__c+false+'Delivery'+Datetime.now().format('ddmmyyyyHH');

            String bookingXML = pe.BuildXMLforCreateBooking(rq, 'Delivery');

            ws_call__c ws = new ws_call__c(rq_jsn__c=bookingXML, ws_typ__c='Courier Booking',
                mtd_nm__c='Courier Booking', intsts__c='Ready for Integration', rq_itm__c=itm[0].id,
                uid__c = rq.id + '' + itm[0].Id + '' + itm[0].sta__c + system.today() + 'Courier Booking');

            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert ws;
            }
            System.debug('ws - Courier Booking : ' + ws.Id);***/

            //grqWsCourier.wsCourBooking(rq.Id);

            resp.respCode    = '0';         resp.respMsg     = 'Success';
            resp.SRN        = rq.name;     resp.agNum        = rq.xanum__c; resp.AxsId = rq.Id;

        }catch (JSONException je) {
            resp.respCode='EXC_02'; resp.respMsg='Invalid JSON String.';
            system.debug(je.getMessage()+ ' ' +je.getStackTraceString());
        } catch (Exception e) {
            resp.respCode='EXC_01'; resp.respMsg='#Error : ' + e.getMessage();
            system.debug('#EXCEPTION: '+e.getMessage() + ' #StackTrace: ' +e.getStackTraceString());
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
        System.debug('resp : ' + resp);
    }

    public static String getMappedBldg(String tecomBlgd) {
        String axsBldg = tecomBlgd;

        Map<String, String> mapBldgs = new Map<String, String>{
        'Bldg 01'=>'Building 01', 'Bldg 02'=>'Building 02', 'Bldg 03'=>'Building 03', 'Bldg 04'=>'Building 04',
            'Bldg 05'=>'Building 05', 'Bldg 06'=>'Building 06', 'Bldg 07'=>'Building 07', 'Bldg 08'=>'Building 08',
            'Bldg 09'=>'Building 09', 'Bldg 10'=>'Building 10', 'Bldg 11'=>'Building 11', 'Bldg 12'=>'Building 12',
            'Sr. Bldg 01'=>'Sr. Building 01', 'Sr. Bldg 02'=>'Sr. Building 02', 'Bldg 01'=>'Building 01',
            'Bldg 02'=>'Building 02', 'Bldg 03'=>'Building 03', 'Bldg 04'=>'Building 04', 'Bldg 05'=>'Building 05',
            'Bldg 06'=>'Building 06', 'Bldg 07'=>'Building 07', 'Bldg 08'=>'Building 08', 'Bldg 09'=>'Building 09',
            'Bldg 10'=>'Building 10', 'Bldg 11'=>'Building 11', 'Bldg 12'=>'Building 12', 'Bldg 13'=>'Building 13',
            'Bldg 14'=>'Building 14', 'Bldg 15'=>'Building 15', 'Bldg 16'=>'Building 16', 'Bldg 17'=>'Building 17',
            'Bldg 18'=>'Building 18', 'Bldg 19'=>'HSBC Building (Building 02)', 'EIB 03'=>'APTEC (EIB 03)',
            'EIB 04'=>'Star Holding (EIB 04)', 'Galadhari & Associates'=>'Galadhari & Associates',
            'Waqf TECOM Mosque'=>'MSQ01', 'B01'=>'Block 01', 'B02'=>'Block 02', 'B03'=>'Block 03',
            'B04'=>'Block 04', 'B05'=>'Block 05', 'B06'=>'Block 06', 'B07'=>'Block 07', 'B08'=>'Block 08',
            'B09'=>'Block 09', 'B10'=>'Block 10', 'B11'=>'Block 11', 'B12'=>'Block 12', 'B13'=>'Block 13',
            'B14'=>'Block 14', 'B15'=>'Block 15', 'B16'=>'Block 16', 'B17'=>'Block 17', 'B18'=>'Block 18',
            'B19'=>'Block 19', 'CYS &CO INC'=>'CYS & CO INC', 'EIB 07'=>'Holiday INN Express Hotel',
            'Bldg 01'=>'Building 01', 'Bldg 02'=>'CNN Building ( Building 02)', 'Bldg 03'=>'Building 03',
            'Bldg 04'=>'Building 04', 'Bldg 05'=>'Building 05', 'Bldg 06'=>'Building 06', 'Bldg 07'=>'Building 07',
            'Bldg 08'=>'Building 08', 'Bldg 09'=>'Building 09', 'Bldg 10'=>'Building 10', 'Bldg 11'=>'Building 11',
            'Bldg 14'=>'Building 14', 'BO01'=>'Boutique Office 01', 'BO02'=>'Boutique Office 02',
            'BO03'=>'Boutique Office 03', 'BO04'=>'Boutique Office 04', 'BO05'=>'Boutique Office 05',
            'BO06'=>'Boutique Office 06', 'BO07'=>'Boutique Office 07', 'BO08'=>'Boutique Office 08',
            'BO09'=>'Boutique Office 09', 'BO10'=>'Boutique Office 10', 'BO11'=>'Boutique Office 11',
            'BO12'=>'Boutique Office 12', 'BO13'=>'Boutique Office 13', 'BO14'=>'Boutique Office 14',
            'BO15'=>'Boutique Office 15', 'BO16'=>'Boutique Office 16', 'BO17'=>'Boutique Office 17',
            'BO18'=>'Boutique Office 18', 'BO19'=>'Boutique Office 19', 'BO20'=>'Boutique Office 20',
            'BO21'=>'Boutique Office 21', 'BO22'=>'Boutique Office 22', 'BO23'=>'Boutique Office 23',
            'L1'=>'Loft Office 1', 'L2'=>'Loft Office 2', 'L3'=>'Loft Office 3', 'Raddison Blu Hotel'=>'Radisson Blue Hotel',
            'Bldg 01'=>'Building 01', 'Bldg 02'=>'Building 02', 'Bldg 03'=>'Building 03', 'Bldg 04'=>'Building 04',
            'Bldg 05'=>'Building 05', 'Bldg 06'=>'Building 06', 'Bldg 07'=>'Building 07', 'Bldg 08'=>'Building 08',
            'Bldg A'=>'Buliding A', 'BS01'=>'Boutique Studio 01', 'BS02'=>'Boutique Studio 02',
            'BS03'=>'Boutique Studio 03', 'BS04'=>'Boutique Studio 04', 'BS05'=>'Boutique Studio 05',
            'BS06'=>'Boutique Studio 06', 'BS07'=>'Boutique Studio 07', 'BS08'=>'Boutique Studio 08',
            'BS09'=>'Boutique Studio 09', 'BS10'=>'Boutique Studio 10', 'BS11'=>'Boutique Studio 11',
            'BS12'=>'Boutique Studio 12', 'BS13'=>'Boutique Studio 13', 'BS14'=>'Boutique Studio 14',
            'BS15'=>'Boutique Studio 15', 'BS16'=>'Boutique Studio 16', 'BS17'=>'Boutique Studio 17',
            'BS18'=>'Boutique Studio 18'
        }
        ;
        System.debug('<getMappedBldg > tecomBlgd: ' + tecomBlgd);
        if (mapBldgs.containsKey(tecomBlgd)) {
            axsBldg = mapBldgs.get(tecomBlgd);
            System.debug('<getMappedBldg > axsBldg : '+ axsBldg);
        }
        return axsBldg;
    }

    global class CourierService {webService String oracleID, tcode, accName, conName, agNum, docType, refMobile, deliveryZone, buildName, deliveryLoc, notes;}
    global class courierResp     {webService String respCode, respMsg, agNum, AWB, SRN, AxsId;}
}
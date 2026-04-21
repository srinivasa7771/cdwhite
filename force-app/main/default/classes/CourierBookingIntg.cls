@RestResource(urlMapping='/createbooking/*')
global class CourierBookingIntg {

    @HttpPost
    global static void createCourBooking() {
        System.debug('reqBody : ' + RestContext.request.requestBody.toString());
        courierResp resp = new courierResp();
        List<g_req__c> rq  = new List<g_req__c>();
        /***try{
            CourierService cs = (CourierService)JSON.deserialize(RestContext.request.requestBody.toString(), CourierBookingIntg.CourierService.class);
            System.debug('CourierService : ' + cs);

            if (String.isBlank(cs.SRN)) {
                resp.respCode = 'VE_01';
                resp.respMsg = '#ValidationError, SRN ID cannot be blank.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            //ToDo : merge rq and rqItm queries
            rq = [SELECT Id, Name, xawb__c, xanum__c, Zone__c, rmob__c, xaloc__c, Full_Name__c, Acc__r.Name, xbn__c, xbrnd__c, CreatedBy.Name FROM g_req__c WHERE name=:cs.SRN LIMIT 1];

            if (rq.size()==0) {
                resp.respCode = 'DE_01';
                resp.respMsg = '#DataError, Request with SRN {' + cs.SRN + '} not found.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            system.debug('rq[0].Id: '+ rq[0].Id + ' Name : ' + rq[0].Name);
            List<g_reqitem__c> itm = [SELECT Id, name, sta__r.cd__c, sta__r.Courier_Stage__c, xcub__c, xcasc__c, exp__c from g_reqitem__c where rq__c=:rq[0].Id LIMIT 1];
            system.debug('<itm.size()> : '+itm.size());

            if (itm.size()==0) {
                resp.respCode = 'VE_04';
                resp.respMsg = '#Technical Error, Please try again or contact your Administrator.';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
                return;
            }

            XMLParserforEmpostWebservice cour= new XMLParserforEmpostWebservice();
            cour.courierBooking(itm[0], rq[0], false, '');

            resp.respCode='0';  resp.respMsg='Success';resp.SRN=rq[0].name; resp.AWB=cour.awbno; resp.agNum= rq[0].xanum__c;resp.AxsId=rq[0].Id;

        }catch (Exception e) { resp.respCode='EXC_01'; resp.respMsg='#Error : ' + e.getMessage();system.debug('#EXCEPTION: '+e.getMessage() + ' #StackTrace: ' +e.getStackTraceString());}

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
        System.debug('resp : ' + resp);***/

        resp.respCode='0';  resp.respMsg='Success';
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    global class CourierService {webService String SRN;}
    global class courierResp     {webService String respCode, respMsg, agNum, AWB, SRN, AxsId;}

}
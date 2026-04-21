public class CourierRespParser
{
    //public String JString = '{"settings":[{"srNo":12345665765, "awbNo":12345665765, "fromStatus":"At Hud", "toStatus":"At mail roon", "updateReason":"my wish", "updateTimeStamp":"10:10", "type":"Delivery"}, {"srNo":12345665769, "awbNo":12345665769, "fromStatus":"At mail roonm", "toStatus":"out for deloivery", "updateReason":"my wish", "updateTimeStamp":"10:10", "type":"Collection"}]}';
    public class empostResp
    {
        public String srNo;
        public String awbNo;
        public String fromStatus;
        public String toStatus;
        public String updateReason;
        public String updateTimeStamp;
        public String dtype;
    }

    public List<empostResp> settings;
    public List<empostResp> courRplst = new List<empostResp>();
    //empost json parser
    public List<empostResp> respParser(String empostJson) {
        CourierRespParser ParsedJSON = (CourierRespParser) System.JSON.deserialize(empostJson, CourierRespParser.class);
        List<CourierRespParser.empostResp> respObj = ParsedJSON.settings;

        for (CourierRespParser.empostResp obj : respObj) {
            empostResp sObj = new empostResp();
            sObj.srNo = obj.srNo;
            sObj.awbNO = obj.awbNo;
            sObj.fromStatus = obj.fromStatus;
            sObj.toStatus = obj.toStatus;
            sObj.updateReason = obj.updateReason;
            sObj.updateTimeStamp = obj.updateTimeStamp;
            sObj.dtype = obj.dtype;
            courRplst.add(sObj);
        }
        return courRplst;
    }
}
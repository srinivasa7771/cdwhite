public class ctrlLAReqWrapper {

    public class Activities {
        public String name;
        public String ddaId;
        public String actionType;
        public List<ChannelTitles> channelTitles;
        public Object noOfTitleAndChannels;
    }

    public List<ServiceRequests> serviceRequests;

    public class ServiceRequests {
        public String serviceId;
        public Integer licenseNo;
        public List<Activities> activities;
        public List<ChannelTitles> members;
        public Object locations;
        public Object companyInfo;
        public Object isPaid;
        public Object ddaSegmentId;
    }

    public class ChannelTitles {
    }

   public static ctrlLAReqWrapper parse(String json) {
        return (ctrlLAReqWrapper ) System.JSON.deserialize(json, ctrlLAReqWrapper.class);
    }

}
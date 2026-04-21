trigger grDDALADocst on LADocs__e (after insert) {
  if(trigger.isAfter){
        DccaBatchUtil.ladocsevnt(trigger.new);
    }
}
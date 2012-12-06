require 'rex/post/meterpreter/packet'

describe Rex::Post::Meterpreter::Tlv do
  subject{Rex::Post::Meterpreter::Tlv.new(Rex::Post::Meterpreter::TLV_TYPE_STRING,"test")}

  it "should respond to type" do
    subject.should respond_to :type
  end

  it "should respond to value" do
    subject.should respond_to :value
  end

  it "should respond to compress" do
    subject.should respond_to :compress
  end

  it "should respond to inspect" do
    subject.should respond_to :inspect
  end

  it "should respond to meta_type?" do
    subject.should respond_to :meta_type?
  end

  it "should respond to type?" do
    subject.should respond_to :type?
  end  

  it "should respond to value?" do
    subject.should respond_to :value?
  end

  it "should respond to to_r" do
    subject.should respond_to :to_r
  end

  it "should respond to from_r" do
    subject.should respond_to :from_r
  end

  context "A String TLV" do
    it "should return the correct TLV type" do
      subject.type.should == Rex::Post::Meterpreter::TLV_TYPE_STRING
    end

    it "should return the correct value" do
      subject.value.should == "test"
    end

    context "the type? method" do
      it "should return true for STRING" do
        subject.type?(Rex::Post::Meterpreter::TLV_TYPE_STRING).should == true
      end

      it "should return false for UINT" do
        subject.type?(Rex::Post::Meterpreter::TLV_TYPE_UINT).should == false
      end
    end

    context "the value? method" do
      it "should return true for the correct value" do
        subject.value?("test").should == true
      end

      it "should return false for an incorrect value" do
        subject.value?("fake").should == false
      end
    end

    context "the inspect method" do
      it "should return a string representation of the TLV" do
        tlv_to_s = "#<Rex::Post::Meterpreter::Tlv type=STRING          meta=STRING     value=\"test\">"
        subject.inspect.should == tlv_to_s
      end
    end

    context "the to_r method" do
      it "should return the raw bytes of the TLV to send over the wire" do
        tlv_bytes = "\x00\x00\x00\r\x00\x01\x00\ntest\x00"
        subject.to_r.should == tlv_bytes
      end
    end

    context "the from_r method" do
      it "should adjust the tlv attributes from the given raw bytes" do
        subject.from_r("\x00\x00\x00\r\x00\x01\x00\ntes2\x00")
        subject.value.should == "tes2"
      end
    end
  end

  context "A Method TLV" do
    subject{Rex::Post::Meterpreter::Tlv.new(Rex::Post::Meterpreter::TLV_TYPE_METHOD,"test")}
    it "should return true when checked for a meta type of String" do
      subject.meta_type?(Rex::Post::Meterpreter::TLV_META_TYPE_STRING).should == true
    end

    it "should show the correct type and meta type in inspect" do
      tlv_to_s = "#<Rex::Post::Meterpreter::Tlv type=METHOD          meta=STRING     value=\"test\">"
      subject.inspect.should == tlv_to_s
    end
  end

  context "A String TLV with a number value" do
    subject{Rex::Post::Meterpreter::Tlv.new(Rex::Post::Meterpreter::TLV_TYPE_STRING,5)}
    it "should return the string version of the number" do
      subject.value.should == "5"
    end
  end

end

describe Rex::Post::Meterpreter::GroupTlv do
  subject{Rex::Post::Meterpreter::GroupTlv.new(Rex::Post::Meterpreter::TLV_TYPE_CHANNEL_DATA_GROUP)}

  it "should respond to tlvs" do
    subject.should respond_to :tlvs
  end

  it "should respond to each" do
    subject.should respond_to :each
  end

  it "should respond to each_tlv" do
    subject.should respond_to :each_tlv
  end

  it "should respond to each_with_index" do
    subject.should respond_to :each_with_index
  end

  it "should respond to each_tlv_with_index" do
    subject.should respond_to :each_tlv_with_index
  end

  it "should respond to get_tlvs" do
    subject.should respond_to :get_tlvs
  end

  it "should respond to add_tlv" do
    subject.should respond_to :add_tlv
  end

  it "should respond to add_tlvs" do
    subject.should respond_to :add_tlvs
  end

  it "should respond to get_tlv" do
    subject.should respond_to :get_tlv
  end

  it "should respond to get_tlv_value" do
    subject.should respond_to :get_tlv_value
  end

  it "should respond to get_tlv_values" do
    subject.should respond_to :get_tlv_values
  end

  it "should respond to has_tlv?" do
    subject.should respond_to :has_tlv?
  end

  it "should respond to reset" do
    subject.should respond_to :reset
  end

  it "should respond to to_r" do
    subject.should respond_to :to_r
  end

  it "should respond to from_r" do
    subject.should respond_to :from_r
  end

  it "should return an empty array for tlvs by default" do
    subject.tlvs.should == []
  end

  context "the add_tlv method" do
    it "should add to the tlvs array when given basic tlv paramaters" do
      subject.add_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,"test")
      subject.tlvs.first.type.should == Rex::Post::Meterpreter::TLV_TYPE_STRING
      subject.tlvs.first.value.should == "test"
    end

    it  "should replace any existing TLV of the same type when the replace flag is set to true" do
      subject.add_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,"test")
      subject.add_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,"test2", true)
      subject.tlvs.count.should == 1
      subject.tlvs.first.value.should == "test2"
    end

    it "should add both if replace is set to false" do
      subject.add_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,"test")
      subject.add_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,"test2", false)
      subject.tlvs.first.value.should == "test"
      subject.tlvs.last.value.should == "test2"
    end
  end

  context "the add_tlvs method" do
    it "should be able to add an array of type-value hashes" do
      tlv_array = [
        {'type' => Rex::Post::Meterpreter::TLV_TYPE_STRING, 'value' => "test"},
        {'type' => Rex::Post::Meterpreter::TLV_TYPE_STRING, 'value' => "test2"}
      ]
      subject.add_tlvs(tlv_array)
      subject.tlvs.count.should == 2
      subject.tlvs.first.value.should == "test"
      subject.tlvs.last.value.should == "test2"
    end

    it "should raise an error when given something other than nil or an array" do
      pending "RM #7598"
      subject.add_tlvs("bad value").should raise_error
    end

    it "should raise an error when given an array of objects other than hashes" do
      pending "RM #7598"
      subject.add_tlvs([1,2,3]).should raise_error
    end

    it "should raise an error when any of the hashes are missing a key" do
      pending "RM #7598"
      tlv_array = [
        {:type => Rex::Post::Meterpreter::TLV_TYPE_STRING, :value => "test"},
        {:type => Rex::Post::Meterpreter::TLV_TYPE_STRING}
      ]
      subject.add_tlvs(tlv_array).should raise_error
    end
  end

  context "with TLVs added" do
    before(:each) do
      subject.reset
      tlv_array = [
        {'type' => Rex::Post::Meterpreter::TLV_TYPE_STRING, 'value' => "test"},
        {'type' => Rex::Post::Meterpreter::TLV_TYPE_STRING, 'value' => "test2"},
        {'type' => Rex::Post::Meterpreter::TLV_TYPE_UINT, 'value' => 5}
      ]
      subject.add_tlvs(tlv_array)
      @raw_group =  "\x00\x00\x00/@\x00\x005\x00\x00\x00\r\x00\x01\x00\ntest\x00\x00\x00\x00\x0E\x00\x01\x00\ntest2\x00\x00\x00\x00\f\x00\x02\x00\v\x00\x00\x00\x05"
    end

    it "should empty the array of TLV when reset is called" do
      subject.reset
      subject.tlvs.should == []
    end

    it "should convert to raw bytes when to_r is called" do
      subject.to_r.should == @raw_group
    end


    context "the from_r method" do
      it "should build the TLV group when given the propper raw bytes" do
        subject.reset 
        subject.from_r( @raw_group)
        subject.tlvs[0].inspect.should == "#<Rex::Post::Meterpreter::Tlv type=STRING          meta=STRING     value=\"test\">"
        subject.tlvs[1].inspect.should == "#<Rex::Post::Meterpreter::Tlv type=STRING          meta=STRING     value=\"test2\">"
        subject.tlvs[2].inspect.should == "#<Rex::Post::Meterpreter::Tlv type=UINT            meta=INT        value=5>"
      end
    end


    context "the get_tlvs method" do
      it "should return all TLVs of the supplied type" do
        tlvs = subject.get_tlvs(Rex::Post::Meterpreter::TLV_TYPE_STRING)
        tlvs.count.should == 2
        tlvs.first.value.should == "test"
        tlvs.last.value.should == "test2"
      end

      it "should return all TLVs when supplied the ANY TLV type" do
        tlvs = subject.get_tlvs(Rex::Post::Meterpreter::TLV_TYPE_ANY)
        tlvs.count.should == subject.tlvs.count
      end

      it "should return an empty array for a TLV type that isn't present" do
        subject.get_tlvs(Rex::Post::Meterpreter::TLV_TYPE_BOOL).should == []
      end

      it "should return an empty array for a nonexistant TLV type" do
        subject.get_tlvs(55555555).should == []
      end
    end

    context "the get tlv_method" do
      it "should return the first TLV of the specified type by default" do
        subject.get_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING).should == subject.tlvs.first
        subject.get_tlv(Rex::Post::Meterpreter::TLV_TYPE_UINT).should == subject.tlvs.last
      end

      it "should return the correct TLV of the specified type for the given index" do
        subject.get_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,1).should == subject.tlvs[1]
      end

      it "should return nil if given an out of bounds index" do
        subject.get_tlv(Rex::Post::Meterpreter::TLV_TYPE_STRING,5).should == nil
      end

      it "should return nil if given a non-present TLV type" do
        subject.get_tlv(Rex::Post::Meterpreter::TLV_TYPE_BOOL).should == nil
      end
    end

    context "the get_tlv_value method" do
      it "should return the value of the first TLV with the given type" do
        subject.get_tlv_value(Rex::Post::Meterpreter::TLV_TYPE_STRING).should == subject.tlvs.first.value
      end

      it "should return the correct TLV value of the specified type for the given index" do
        subject.get_tlv_value(Rex::Post::Meterpreter::TLV_TYPE_STRING,1).should == subject.tlvs[1].value
      end

      it "should return nil if given an out of bounds index" do
        subject.get_tlv_value(Rex::Post::Meterpreter::TLV_TYPE_STRING,5).should == nil
      end

      it "should return nil if given a non-present TLV type" do
        subject.get_tlv_value(Rex::Post::Meterpreter::TLV_TYPE_BOOL).should == nil
      end
    end

    context "the get_tlv_values method" do
      it "should return an array of values for the designated TLV types" do
        subject.get_tlv_values(Rex::Post::Meterpreter::TLV_TYPE_STRING).should == ["test", "test2"]
      end

      it "should return an empty array for a non-present TLV type" do
        subject.get_tlv_values(Rex::Post::Meterpreter::TLV_TYPE_BOOL).should == []
      end
    end

    context "the has_tlv? method" do
      it "should return true if the TLV Type is present" do
        subject.has_tlv?(Rex::Post::Meterpreter::TLV_TYPE_STRING).should == true
      end

      it "should return false if the TLV type is not present" do
        subject.has_tlv?(Rex::Post::Meterpreter::TLV_TYPE_BOOL).should == false
      end
    end

    

  end


end

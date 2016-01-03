module Helper
  def csv2json(csv)
    @temp = Tempfile.new 'temp.csv'
    @temp.write csv
    @temp.rewind
    @converter = Switch::Csv2Json.new(@temp, '/tmp')
    @files = @converter.convert
  end
end

describe Switch::Csv2Json do
  include Helper

  context "with a single column csv" do
    before do
      csv = %Q{en,keys,order\nhello,greeting,1}
      csv2json(csv)
    end

    it "should create a single json file" do
      expect(@files.count).to eq(1)
    end

    it "should have the following format" do
      expect(File.new(@files[0]).read).to eq("{\n  \"greeting\": \"hello\"\n}")
    end
  end

  context "order column" do
    before do
      csv = %Q{en,keys,order\ngoodbye,ending,2\nhello,greeting,1}
      csv2json(csv)
    end

    it "should be used regardless of the actual order of row order" do
      expect(File.new(@files[0]).read).to eq("{\n  \"greeting\": \"hello\",\n  \"ending\": \"goodbye\"\n}")
    end
  end

  context "with a two column csv" do
    before do
      csv = %Q{en,fr,keys,order\nhello,bonjour,greeting,1}
      csv2json(csv)
    end

    it "should produce two files" do
      expect(@files.count).to eq(2)
    end

    it "should have the following format" do
      expect(File.new(@files[0]).read).to eq("{\n  \"greeting\": \"hello\"\n}")
      expect(File.new(@files[1]).read).to eq("{\n  \"greeting\": \"bonjour\"\n}")
    end

    it "should duplicate english and prefix it with the language if translation is missing" do
      csv = %Q{en,fr,keys,order\nhello,,greeting,1}
      csv2json(csv)
      expect(File.new(@files[1]).read).to eq("{\n  \"greeting\": \"FR_hello\"\n}")
    end
  end

  context "supports nested keys" do
    it "should support a single nested keys" do
      csv = %Q{en,keys,order\nhello,greeting.title,1}
      csv2json(csv)
      expect(File.new(@files[0]).read).to eq("{\n  \"greeting\": {\n    \"title\": \"hello\"\n  }\n}")
    end

    it "should support multiple nested keys" do
      csv = %Q{en,keys,order\nhello,greeting.title,1\nstranger,greeting.description,2\n}
      csv2json(csv)
      expect(File.new(@files[0]).read).to eq("{\n  \"greeting\": {\n    \"title\": \"hello\",\n    \"description\": \"stranger\"\n  }\n}")
    end
  end
end

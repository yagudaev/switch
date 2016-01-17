module Helper
  def json2csv(files)
    files.each do |language, values|
      temp = File.open "tmp/#{language}.json", 'w'
      temp.write values.to_json
      temp.rewind
    end

    @converter = Switch::Json2Csv.new('./tmp')
    @output = @converter.convert('./tmp/output.csv')
  end
end

describe Switch::Json2Csv do
  include Helper

  after do
    File.delete(*Dir['./tmp/*'])
  end

  context "single json file" do
    before do
      json2csv({en: { title: 'hello',  description: 'world'}})
    end

    it "should generate one column" do
      expect(File.new(@output).read).to eq("en,keys,order\nhello,title,1\nworld,description,2\n")
    end

    it "should add an order column based on json file" do
      expect(File.new(@output).read).to include('order')
    end
  end

  context "two json files" do
    it "should generate two columns" do
      json2csv({
        en: { title: 'hello',  description: 'world' },
        fr: { title: 'bonjour', description: 'monde' }
      })
      expect(File.new(@output).read).to eq("en,fr,keys,order\nhello,bonjour,title,1\nworld,monde,description,2\n")
    end

    it "should remove values with langauge prefix" do
      json2csv({
        en: { title: 'hello', description: 'world' },
        fr: { title: 'FR_hello', description: 'FR_world' }
      })
      expect(File.new(@output).read).to eq("en,fr,keys,order\nhello,,title,1\nworld,,description,2\n")
    end

    it "should leave values empty if key is missing in one json file" do
      json2csv({
        en: { title: 'hello', description: 'world' },
        fr: { title: 'FR_hello' }
      })
      expect(File.new(@output).read).to eq("en,fr,keys,order\nhello,,title,1\nworld,,description,2\n")
    end
  end

  context "support nested keys" do
    it "should flatten nested keys" do
      json2csv({
        en: { cart_page: {title: 'Cart'}}
      })
      expect(File.new(@output).read).to eq("en,keys,order\nCart,cart_page.title,1\n")
    end
  end

  context "order column" do
    it "should depend on order of json file" do
      json2csv({
        en: {
          title: 'Site name',
          slogan: 'Site slogan',
          cart_page: {
            title: 'Cart'
          }
        }
      })
      expect(File.new(@output).read).to eq("en,keys,order\nSite name,title,1\nSite slogan,slogan,2\nCart,cart_page.title,3\n")
    end
  end
end

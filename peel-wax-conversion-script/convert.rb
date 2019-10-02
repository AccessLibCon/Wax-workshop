require "nokogiri"
require "csv"

@records = []
Dir.foreach("xml"){ |file|
  next if file == "." or file == ".."

  xml_doc = File.open("xml/#{file}"){ |f| Nokogiri::XML(f) }
  xml_doc.remove_namespaces!

  record = {}

  record[:pid] = xml_doc.xpath("//identifier").text
  record[:title] = xml_doc.xpath("//title").text
  record[:country] = xml_doc.xpath("//hierarchicalGeographic/country").text
  record[:province] = xml_doc.xpath("//hierarchicalGeographic/province").text
  record[:city] = xml_doc.xpath("//hierarchicalGeographic/city").text
  record[:extent] = xml_doc.xpath("//extent").text
  record[:public_to] = xml_doc.xpath('//*[@type="public_to"]').text
  record[:public_from] = xml_doc.xpath('//*[@type="public_from"]').text
  record[:public_address] = xml_doc.xpath('//*[@type="public_address"]').text
  record[:public_message] = xml_doc.xpath('//*[@type="public_message"]').text
  record[:public_postmark_date] = xml_doc.xpath('//*[@type="public_postmark_date"]').text
  record[:public_on_front] = xml_doc.xpath('//*[@type="public_on_front"]').text

  @records << record
}

  CSV.open("data.csv", "wb") {|csv|
    @records.each do |rec|
    csv << rec.values
  end
  }

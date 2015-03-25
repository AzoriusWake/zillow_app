# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

state_abbrevs = %w(AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY)

state_abbrevs.each do |state|
  response = HTTParty.get("http://www.zillow.com/webservice/GetRegionChildren.htm?zws-id=X1-ZWz1ay025pe03v_4eq90&state=#{state}")
  response["regionchildren"]["response"]["list"]["region"].each do |region|
    if region["zindex"]
      Pillow.create(zid: region["id"].to_s, state: state.to_s, region: region["name"].to_s, price: region["zindex"]["__content__"].to_s, lat: region["latitude"].to_s, long: region["longitude"].to_s)
      puts region["name"].to_s
    end
  end
end
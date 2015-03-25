require 'httparty'
require 'pp'

class PillowsController < ApplicationController
  def index
  end
  def state_profile
    state = params[:state]
    state = "CA" if params[:state].nil?
    response = HTTParty.get("http://www.zillow.com/webservice/GetRegionChildren.htm?zws-id=X1-ZWz1ay025pe03v_4eq90&state=#{state}")
    profile = Hash.new
    profile[:name] = state_it(state)
    profile[:count] = response["regionchildren"]["response"]["list"]["count"]
    profile[:counties] = []
    response["regionchildren"]["response"]["list"]["region"].each do |county|
      if county["zindex"]
        county_obj = { :name => county["name"], :price => county["zindex"]["__content__"].to_i }
        profile[:counties] << county_obj
      end
    end
    render json: profile
  end
  def endpoint
    get_state_data
    fill_it_up
    render json: @state_hash
  end
  private
    def get_state_data
      @state_hash = Hash.new
      Pillow.all.each do |pillow|
        if @state_hash.key?(pillow.state)
          @state_hash[pillow.state][:region_count] += 1
          @state_hash[pillow.state][:avg_price] = avgify(@state_hash[pillow.state][:avg_price], pillow.price.to_i, @state_hash[pillow.state][:region_count])
          @state_hash[pillow.state][:low_price] = pillow.price.to_i if pillow.price.to_i < @state_hash[pillow.state][:low_price]
          @state_hash[pillow.state][:high_price] = pillow.price.to_i if pillow.price.to_i > @state_hash[pillow.state][:high_price]
        else
          @state_hash[pillow.state] = {}
          @state_hash[pillow.state][:region_count] = 1
          @state_hash[pillow.state][:avg_price] = pillow.price.to_i
          @state_hash[pillow.state][:low_price] = pillow.price.to_i
          @state_hash[pillow.state][:high_price] = pillow.price.to_i
        end
      end
    end
    def fill_it_up
      @state_hash.each do |key, state|
        case state[:avg_price]
        when 0...150000
          state[:fillKey] = "low"
        when 150000...200000
          state[:fillKey] = "med"
        else
          state[:fillKey] = "high"
        end
      end
    end
    def avgify(current, upd, count)
      (current * count / (count + 1) ) + (upd / (count + 1) )
    end
    def state_it(abbrev)
      case abbrev
      when "AL"
        "Alabama"
      when "AK"
        "Alaska"
      when "AZ"
        "Arizona"
      when "AR"
        "Arkansas"
      when "CA"
        "California"
      when "CO"
        "Colorado"
      when "CT"
        "Connecticut"
      when "DE"
        "Delaware"
      when "FL"
        "Florida"
      when "GA"
        "Georgia"
      when "HI"
        "Hawaii"
      when "ID"
        "Idaho"
      when "IL"
        "Illinois"
      when "IN"
        "Indiana"
      when "IA"
        "Iowa"
      when "KS"
        "Kansas"
      when "KY"
        "Kentucky"
      when "LA"
        "Louisiana"
      when "ME"
        "Maine"
      when "MT"
        "Montana"
      when "NE"
        "Nebraska"
      when "NV"
        "Nevada"
      when "NH"
        "New Hampshire"
      when "NJ"
        "New Jersey"
      when "NM"
        "New Mexico"
      when "NY"
        "New York"
      when "NC"
        "North Carolina"
      when "ND"
        "North Dakota"
      when "OH"
        "Ohio"
      when "OK"
        "Oklahoma"
      when "OR"
        "Oregon"
      when "MD"
        "Maryland"
      when "MA"
        "Massachusetts"
      when "MI"
        "Michigan"
      when "MN"
        "Minnesota"
      when "MS"
        "Mississippi"
      when "MO"
        "Missouri"
      when "PA"
        "Pennsylvania"
      when "RI"
        "Rhode Island"
      when "SC"
        "South Carolina"
      when "SD"
        "South Dakota"
      when "TN"
        "Tennessee"
      when "TX"
        "Texas"
      when "UT"
        "Utah"
      when "VT"
        "Vermont"
      when "VA"
        "Virginia"
      when "WA"
        "Washington"
      when "WV"
        "West Virginia"
      when "WI"
        "Wisconsin"
      when "WY"
        "Wyoming"
    end
  end
end

# response = HTTParty.get("http://www.zillow.com/webservice/GetRegionChildren.htm?zws-id=X1-ZWz1ay025pe03v_4eq90&state=CA")
class UsaState
  include ActiveModel::Model

  # ~~ constants ~~
  NAME_BY_CODE = {
    AL: 'Alabama'
    AK: 'Alaska'
    AZ: 'Arizona'
    AR: 'Arkansas'
    CA: 'California'
    CO: 'Colorado'
    CT: 'Connecticut'
    DE: 'Delaware'
    DC: 'District of Columbia'
    FL: 'Florida'
    GA: 'Georgia'
    HI: 'Hawaii'
    ID: 'Idaho'
    IL: 'Illinois'
    IN: 'Indiana'
    IA: 'Iowa'
    KS: 'Kansas'
    KY: 'Kentucky'
    LA: 'Louisiana'
    ME: 'Maine'
    MD: 'Maryland'
    MA: 'Massachusetts'
    MI: 'Michigan'
    MN: 'Minnesota'
    MS: 'Mississippi'
    MO: 'Missouri'
    MT: 'Montana'
    NE: 'Nebraska'
    NV: 'Nevada'
    NH: 'New Hampshire'
    NJ: 'New Jersey'
    NM: 'New Mexico'
    NY: 'New York'
    NC: 'North Carolina'
    ND: 'North Dakota'
    OH: 'Ohio'
    OK: 'Oklahoma'
    OR: 'Oregon'
    PA: 'Pennsylvania'
    PR: 'Puerto Rico'
    RI: 'Rhode Island'
    SC: 'South Carolina'
    SD: 'South Dakota'
    TN: 'Tennessee'
    TX: 'Texas'
    UT: 'Utah'
    VT: 'Vermont'
    VA: 'Virginia'
    WA: 'Washington'
    WV: 'West Virginia'
    WI: 'Wisconsin'
    WY: 'Wyoming'
  }.freeze
  CODES = NAME_BY_CODE.keys

  # ~~ virtual attributes ~~
  attr_accessor :name, :code

  # ~~ public class methods ~~
  def self.all
    NAME_BY_CODE.map{|code, name| new code: code, name: name }
  end

  def self.find_by_code(code)
    return unless NAME_BY_CODE.key? code
    new code: code, name: NAME_BY_CODE[code]
  end

  # ~~ public instance methods ~~
  def ==(other)
    other.class == self.class && other.code == code
  end

  def for_select
    [name, code]
  end
end

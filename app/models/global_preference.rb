class GlobalPreference < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  DEFAULT_TTL = 10.minutes
  def ttl
    self["ttl"] || DEFAULT_TTL
  end

  @@cache = {}

  def self.get(variable)
    value, expires = @@cache[variable]

    # return cache if exists and still valid
    return value if expires && expires > Time.now

    if pref = find_by_name(variable)
      @@cache[variable] = [pref.value, pref.ttl.from_now]
      pref.value
    else
      # unknown values are cached for 5 minutes
      @@cache[variable] = [nil, DEFAULT_TTL.from_now]
      nil
    end
  end

  def self.set!(variable, value, ttl = DEFAULT_TTL)
    pref = find_or_initialize_by_name(variable)
    pref.value = value
    pref.ttl = ttl
    pref.save!
    @@cache[variable] = [value, ttl.from_now]
  end
end

class GlobalPreference < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessible :name, :value, :ttl

  DEFAULT_TTL = 10.minutes
  def ttl
    self["ttl"] || DEFAULT_TTL
  end

  @@cache = {}

  def self.get(variable, default = nil)
    variable = variable.to_s
    value, expires = @@cache[variable]

    # return cache if exists and still valid
    if expires && expires > Time.now
      if !value && default
        set(variable, default)
        value = default
      end

      return value
    end

    pref = find_or_initialize_by_name(variable)
    if pref.new_record? || (pref.value.blank? && default)
      # create the record in the db for easy editing
      pref.value = default
      pref.ttl = DEFAULT_TTL
      pref.save!
    end

    @@cache[variable] = [pref.value, pref.ttl.from_now]
    pref.value
  end

  def self.set!(variable, value, ttl = DEFAULT_TTL)
    variable = variable.to_s
    pref = find_or_initialize_by_name(variable)
    pref.value = value
    pref.ttl = ttl
    pref.save!
    @@cache[variable] = [value, ttl.from_now]
  end
end

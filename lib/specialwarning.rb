# SpecialWarning
module SpecialWarning
  def self.warning(warn)
    warn = "WARNING: #{choice_equal_point_trace(caller[1..-1])} #{warn}"
    puts warn
    if Rails.logger || Rails.logger.debug?
      Rails.logger.debug(warn)
      trace = clean_trace(caller[1..-1]).join("\n     ")
      Rails.logger.debug(trace) unless trace.empty?
    end
  end

  private
  VENDOR_RAILS_REGEXP = %r(vendor/plugins/special_warning)
  def self.clean_trace(trace)
    return trace unless defined?(RAILS_ROOT)
    
    trace.select{|t| /#{Regexp.escape(File.expand_path(RAILS_ROOT))}/ =~ t}.reject{|t| VENDOR_RAILS_REGEXP =~ t}.collect{|t| t.gsub(RAILS_ROOT + '/', '')}
  end

  def self.choice_equal_point_trace(trace)
    choice_trace = trace.reject{|t| VENDOR_RAILS_REGEXP =~ t}.first
    return choice_trace ? "#{choice_trace} :" : ""
  end
end

require File.join(File.dirname(__FILE__), 'special_warning/equals')

# Validates that an
class UriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid?(URI.parse(value))
    record.errors[attribute] << (options[:message] || 'is not an valid HTTP or HTTPS URI')
  rescue URI::InvalidURIError
    record.errors[attribute] << (options[:message] || 'is not an valid URI')
  end

  def valid?(uri)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::Generic) && uri.scheme.nil?
  end
end
